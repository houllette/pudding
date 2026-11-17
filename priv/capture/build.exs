request = File.read!("/request.json") |> JSON.decode!()
project = "/workspace/" <> request["project"]
mounts = [request["project"] <> "/_build" | request["writable_paths"]]
File.mkdir_p!("/work/home")
File.mkdir_p!("/work/build")

binds =
  mounts
  |> Enum.with_index()
  |> Enum.flat_map(fn {relative, n} ->
    source = if n == 0, do: "/work/build", else: "/work/generated-#{n}"
    File.mkdir_p!(source)
    ["--bind", source, "/workspace/" <> relative]
  end)

# The consumer cannot read orchestration scripts, requests, or trusted tool output.
# Only the declared snapshot, image filesystem, and explicit writable outputs exist.
args =
  [
    "--ro-bind",
    "/",
    "/",
    "--tmpfs",
    "/trusted",
    "--tmpfs",
    "/tool",
    "--tmpfs",
    "/work",
    "--ro-bind",
    "/dev/null",
    "/request.json",
    "--tmpfs",
    "/home",
    "--tmpfs",
    "/root",
    "--tmpfs",
    "/run",
    "--tmpfs",
    "/var",
    "--tmpfs",
    "/scratch",
    "--tmpfs",
    "/tmp",
    "--dir",
    "/tmp/home",
    "--dev",
    "/dev",
    "--proc",
    "/proc",
    "--clearenv",
    "--unshare-all",
    "--die-with-parent",
    "--new-session",
    "--setenv",
    "PATH",
    System.fetch_env!("PATH"),
    "--setenv",
    "HOME",
    "/tmp/home",
    "--setenv",
    "MIX_HOME",
    "/tmp/home/.mix",
    "--setenv",
    "HEX_HOME",
    "/tmp/home/.hex",
    "--setenv",
    "MIX_ARCHIVES",
    "/opt/mix/archives",
    "--setenv",
    "ERL_FLAGS",
    "+S 4:4 +fnu",
    "--setenv",
    "GIT_CONFIG_NOSYSTEM",
    "1",
    "--setenv",
    "GIT_CONFIG_GLOBAL",
    "/dev/null",
    "--setenv",
    "GIT_NO_REPLACE_OBJECTS",
    "1",
    "--setenv",
    "GIT_OPTIONAL_LOCKS",
    "0",
    "--setenv",
    "GIT_TERMINAL_PROMPT",
    "0",
    "--chdir",
    project
  ] ++
    binds ++
    Enum.flat_map(request["environment"], fn {key, value} -> ["--setenv", key, value] end)

# Host staging does not parse untrusted Git objects. These checks run under the
# same cgroup/network/namespace bounds as compilation, before consumer evaluation.
for dep <- request["dependencies"], dep["kind"] == "git" do
  path = "/workspace/" <> dep["destination"]

  git = [
    "git",
    "-c",
    "core.hooksPath=/dev/null",
    "-c",
    "core.attributesFile=/dev/null",
    "-C",
    path
  ]

  {:ok, revision} =
    Pudding.Execution.Container.command(args ++ git ++ ["rev-parse", "HEAD"],
      engine: "bwrap",
      timeout_ms: 60_000
    )

  unless String.trim(revision) == dep["revision"],
    do: raise("Git revision mismatch: #{dep["destination"]}")

  {:ok, ""} =
    Pudding.Execution.Container.command(
      args ++ git ++ ["status", "--porcelain", "--untracked-files=all"],
      engine: "bwrap",
      timeout_ms: 60_000
    )
end

args = args ++ ["mix", "compile", "--warnings-as-errors"] ++ Map.get(request, "compiler_args", [])

port =
  Port.open({:spawn_executable, System.find_executable("bwrap")}, [
    :binary,
    :exit_status,
    :stderr_to_stdout,
    args: args
  ])

stream = fn stream ->
  receive do
    {^port, {:data, bytes}} ->
      IO.binwrite(bytes)
      stream.(stream)

    {^port, {:exit_status, status}} ->
      System.halt(status)
  end
end

stream.(stream)
