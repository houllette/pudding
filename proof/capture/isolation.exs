# Manual retained probes using the same outer isolation policy as capture.
# Run: mise exec -- mix run proof/capture/isolation.exs NEW_OUTPUT
alias Pudding.Execution.Container
alias Pudding.Project.Manifest
[output] = System.argv()
false = File.exists?(output)
File.mkdir_p!(output)
output = Path.expand(output)
File.mkdir!(output <> "/readonly")
File.write!(output <> "/readonly/authorized", "read only")
image = "sha256:a9a8fdbf73d3b787505b55a6f366959aca929725da359abd0b400c2b1b2a3758"
limits = Map.merge(Container.limits(), %{"memory" => "256m", "pids" => 64})

probes = [
  {"boundary", %{}, 30_000, 65_536,
   """
   set -eu
   test "$(id -u)" = 1000
   test "$(ls /sys/class/net)" = lo
   test ! -e /var/run/docker.sock
   test ! -e /run/podman/podman.sock
   test -z "${PHASE04_HOST_SENTINEL:-}${GITHUB_TOKEN:-}${GH_TOKEN:-}${AWS_SECRET_ACCESS_KEY:-}"
   ! touch /inputs/write 2>/dev/null
   ! touch /opt/write 2>/dev/null
   bwrap --ro-bind / / --tmpfs /home --tmpfs /root --tmpfs /run --tmpfs /tmp --dev /dev --proc /proc --clearenv --unshare-all --die-with-parent --new-session /bin/sh -c 'test "$(ls /sys/class/net)" = lo; ! touch /inputs/write 2>/dev/null; ! touch /opt/write 2>/dev/null; test -z "${PHASE04_HOST_SENTINEL:-}"'
   elixir -e 'case :gen_tcp.connect({1,1,1,1}, 443, [:binary], 1000) do {:error, reason} -> IO.inspect(reason, label: "network_denied"); {:ok, _} -> raise "network escaped" end'
   printf 'BOUNDARY_PROBES_PASSED\n'
   """},
  {"timeout-descendants", %{}, 2_000, 65_536,
   "setsid sh -c 'sleep 90' & echo descendant_started; wait"},
  {"output", %{}, 30_000, 4096, "head -c 1000000 /dev/zero"},
  {"memory", %{"memory" => "128m"}, 30_000, 65_536,
   "cat /sys/fs/cgroup/memory.max; x=$(head -c 300000000 /dev/zero | tr '\\000' x); test -n \"$x\""},
  {"storage", %{}, 30_000, 65_536, "dd if=/dev/zero of=/bounded/full bs=1048576 count=4"},
  {"pids", %{"pids" => 32}, 30_000, 65_536,
   "i=0; while test $i -lt 80; do sleep 60 & i=$((i+1)); done; wait"}
]

results =
  for {label, changes, timeout, bytes, script} <- probes do
    name =
      "pudding-probe-" <>
        label <> "-" <> Base.encode16(:crypto.strong_rand_bytes(6), case: :lower)

    started = System.monotonic_time(:millisecond)

    try do
      result =
        Container.command(
          Container.isolation(name, Map.merge(limits, changes)) ++
            [
              "--user",
              "1000:1000",
              "--mount",
              "type=bind,src=#{output}/readonly,dst=/inputs,readonly",
              "--tmpfs",
              "/bounded:rw,nosuid,nodev,size=1m,mode=1777",
              image,
              "sh",
              "-c",
              script
            ],
          container: name,
          timeout_ms: timeout,
          output_bytes: bytes
        )

      log =
        case result do
          {:ok, log} -> log
          {:error, error} -> error.output
        end

      File.write!(output <> "/#{label}.log", log)

      inspection =
        Container.command(["inspect", "--format", "{{json .State}} {{json .HostConfig}}", name])

      File.write!(output <> "/#{label}.inspection.txt", inspect(inspection, limit: :infinity))

      case {label, result} do
        {"boundary", {:ok, log}} ->
          true = String.contains?(log, "BOUNDARY_PROBES_PASSED")

        {"timeout-descendants", {:error, %{reason: :timeout, output: log}}} ->
          true = String.contains?(log, "descendant_started")

        {"output", {:error, %{reason: :output_limit}}} ->
          :ok

        {"storage", {:error, %{reason: :nonzero_exit, output: log}}} ->
          true = String.contains?(log, "No space left on device")

        {"memory", {:error, %{reason: :nonzero_exit, status: 137}}} ->
          true = String.contains?(log, "134217728")

        {"pids", {:error, %{output: log}}} ->
          true =
            String.contains?(log, "Cannot fork") or
              String.contains?(log, "Resource temporarily unavailable")

        other ->
          raise "unexpected probe outcome #{inspect(other)}"
      end

      {:ok, _} = Container.command(["rm", "--force", name])
      {:error, _} = Container.command(["inspect", name])

      {label,
       %{
         "outcome" => inspect(elem(result, 0)),
         "elapsed_ms" => System.monotonic_time(:millisecond) - started,
         "limits" => Map.merge(limits, changes),
         "wall_ms" => timeout,
         "output_bytes" => bytes,
         "container_absent_after_cleanup" => true
       }}
    after
      Container.command(["rm", "--force", name])
    end
  end

File.write!(output <> "/results.json", Manifest.canonical(Map.new(results)))
IO.puts("ISOLATION_PROBES_PASSED")
