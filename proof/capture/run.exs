# Run from the Pudding checkout with `mix run proof/capture/run.exs NEW_OUTPUT`.
# This is the explicit ordinary-consumer authorization, not consumer Mix evaluation.
[root_output] = System.argv()
root = File.cwd!()
consumer = "test/fixtures/projects/archive_path"
lynx = Path.join(root, "deps/lynx")
revision = "99a6db764c154207cf3b28c35409d9b56c463357"
image = "sha256:a9a8fdbf73d3b787505b55a6f366959aca929725da359abd0b400c2b1b2a3758"

request = %{
  "root" => root,
  "project" => consumer,
  "inputs" =>
    ~w(mix.exs mix.lock lean-toolchain .tool-versions lib priv/capture proof/validator/lemmas.lean proof/validator/contract test/fixtures/contracts) ++
      Enum.map(
        ~w(mix.exs mix.lock lib test proof_qualification_test.exs),
        &Path.join(consumer, &1)
      ),
  "dependencies" =>
    Enum.map(["deps/lynx", consumer <> "/deps/lynx"], fn dest ->
      %{
        "kind" => "git",
        "source" => lynx,
        "destination" => dest,
        "revision" => revision,
        "url" => "https://github.com/josevalim/lynx.git"
      }
    end),
  "writable_paths" => ["deps/lynx/Lean/.lake", consumer <> "/deps/lynx/Lean/.lake"],
  "environment" => %{"MIX_ENV" => "prod", "MIX_TARGET" => "host"},
  "roots" =>
    Enum.map(
      [
        "Elixir.ArchivePath.Fixed",
        "Elixir.ArchivePath.Vulnerable",
        "Elixir.Pudding.Contracts.PathPolicy"
      ],
      fn module ->
        %{
          "module" => module,
          "function" =>
            if(module == "Elixir.Pudding.Contracts.PathPolicy", do: "expected", else: "validate"),
          "arity" => 1
        }
      end
    ),
  "laws" => ["Elixir.ArchivePath.Laws"],
  "proof_postlude" => "proof/validator/lemmas.lean",
  "accepted_inputs" =>
    ~w(test/fixtures/contracts/candidates/archive-path-v1.json test/fixtures/contracts/accepted/archive-path-v1.json proof/validator/contract/proof-inputs.json),
  "unknown_inputs" => [
    "clock, entropy, scheduling and VM/kernel observations are not virtualized; two equal builds do not establish absence of undeclared inputs"
  ]
}

case Pudding.Project.Capture.run(request, root_output,
       image: image,
       trusted_root: root,
       lynx_source: lynx
     ) do
  {:ok, summary} ->
    IO.puts(Pudding.Project.Manifest.canonical(summary))

  error ->
    IO.inspect(error)
    System.halt(1)
end
