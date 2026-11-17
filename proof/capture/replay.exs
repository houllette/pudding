# Explicit fixture qualification, not a general capture replay API or receipt.
# Run: mise exec -- mix run proof/capture/replay.exs CAPTURE NEW_OUTPUT
alias Pudding.Execution.Container
alias Pudding.Project.Manifest
[capture, output] = System.argv()
summary = capture |> Path.join("capture.json") |> File.read!() |> JSON.decode!()
inputs = Manifest.load!(Path.join(capture, "inputs"))
build = Manifest.load!(Path.join(capture, "build-1"))
true = inputs["id"] == summary["inputs"]
true = build["id"] == hd(summary["builds"])
false = File.exists?(output)
File.mkdir_p!(output)
output = Path.expand(output)
stage = Path.join(output, "inputs")
File.mkdir!(stage)

# Only the named fixture BEAMs and accepted predicate are placed on the replay
# path. Lynx is compiled independently from its sealed trusted source, never
# from consumer-built tools. There is no consumer Mix evaluation or rebuild.
selected =
  Map.filter(build["files"], fn {name, _} ->
    (String.starts_with?(name, "build/prod/lib/archive_path/ebin/") and
       String.ends_with?(name, ".beam")) or
      name in [
        "build/prod/lib/pudding/ebin/Elixir.Pudding.Contracts.PathPolicy.beam",
        "runtime/lists.beam"
      ]
  end)

true = map_size(selected) == 11

for {name, entry} <- selected do
  bytes = File.read!(Path.join([capture, "build-1", "objects", entry["sha256"]]))
  path = Path.join([stage, "beam", Path.basename(name)])
  File.mkdir_p!(Path.dirname(path))
  File.write!(path, bytes)
end

for {name, entry} <- inputs["files"], String.starts_with?(name, "tool/lynx/") do
  relative = String.replace_prefix(name, "tool/", "")
  path = Path.join(stage, relative)
  attributes = get_in(inputs, ["metadata", "tool_inventory", relative])

  if attributes && attributes["type"] == "directory" do
    File.mkdir_p!(path)
  else
    File.mkdir_p!(Path.dirname(path))
    File.write!(path, File.read!(Path.join([capture, "inputs", "objects", entry["sha256"]])))
    if attributes, do: File.chmod!(path, attributes["mode"])
  end
end

postlude = "proof/validator/lemmas.lean"
entry = Map.fetch!(inputs["files"], "source/" <> postlude)
File.mkdir_p!(Path.join(stage, "proof/validator"))

File.write!(
  Path.join(stage, postlude),
  File.read!(Path.join([capture, "inputs", "objects", entry["sha256"]]))
)

# The trusted qualification harness is bound to exactly the already-authorized
# source bytes. Changing it requires recapture rather than quietly widening replay.
fixture = "test/fixtures/projects/archive_path"

for relative <- [
      "proof_qualification_test.exs",
      "test/contract_test.exs",
      "test/production_test.exs"
    ] do
  name = fixture <> "/" <> relative
  bytes = File.read!(name)
  true = Manifest.digest(bytes) == inputs["files"]["source/" <> name]["sha256"]
  dest = Path.join(stage, name)
  File.mkdir_p!(Path.dirname(dest))
  File.write!(dest, bytes)
end

File.write!(
  Path.join(stage, "selected.json"),
  Manifest.canonical(
    Map.new(selected, fn {name, entry} ->
      {Path.basename(name), entry["sha256"]}
    end)
  )
)

name = "pudding-replay-" <> Base.encode16(:crypto.strong_rand_bytes(8), case: :lower)
limits = Container.limits()
started = System.monotonic_time(:millisecond)

try do
  result =
    Container.command(
      Container.isolation(name, limits) ++
        [
          "--user",
          "1000:1000",
          "--mount",
          "type=bind,src=#{stage},dst=/inputs,readonly",
          "--mount",
          "type=bind,src=#{File.cwd!()}/proof/capture,dst=/driver,readonly",
          "--mount",
          "type=bind,src=#{File.cwd!()}/lib/pudding,dst=/capture,readonly",
          "--mount",
          "type=bind,src=#{output},dst=/out",
          summary["image"],
          "sh",
          "/driver/replay.sh"
        ],
      container: name,
      timeout_ms: limits["wall_ms"],
      output_bytes: limits["output_bytes"]
    )

  log =
    case result do
      {:ok, bytes} -> bytes
      {:error, error} -> error.output
    end

  File.write!(Path.join(output, "replay.log"), log)

  File.write!(
    Path.join(output, "execution.json"),
    Manifest.canonical(%{
      "elapsed_ms" => System.monotonic_time(:millisecond) - started,
      "inputs" => inputs["id"],
      "build" => build["id"],
      "result" => inspect(result |> elem(0)),
      "limits" => limits,
      "phase_04_gate" => "blocked",
      "assurance" => "fixture_qualification_not_receipt"
    })
  )

  IO.puts(log)
  unless match?({:ok, _}, result), do: System.halt(1)
after
  Container.command(["rm", "--force", name])
end
