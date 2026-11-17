# Runs only after independently compiling trusted, sealed Lynx sources.
alias Pudding.Project.{Beam, Manifest}
Mix.start()
Mix.env(:prod)
Application.load(:lynx)
{:ok, _} = Application.ensure_all_started(:lynx)
selected = File.read!("/inputs/selected.json") |> JSON.decode!()
# Whole input preflight precedes code loading or debug callbacks.
for {name, hash} <- selected do
  bytes = File.read!("/inputs/beam/" <> name)
  true = Manifest.digest(bytes) == hash
  {:ok, _} = Beam.preflight(bytes)
end

# lists is sticky OTP runtime code. Require exact captured bytes at the actual
# image code path; do not replace a running VM's stdlib or silently ignore it.
true = Manifest.digest(File.read!(:code.which(:lists))) == selected["lists.beam"]

:ok =
  Beam.selected(:lists, %{
    "path" => List.to_string(:code.which(:lists)),
    "sha256" => selected["lists.beam"]
  })

File.mkdir_p!("/scratch/selected")

for {name, _} <- selected, name != "lists.beam" do
  File.cp!("/inputs/beam/" <> name, "/scratch/selected/" <> name)
end

Code.prepend_path("/scratch/selected")

bindings =
  for {name, hash} <- selected, name != "lists.beam" do
    module = name |> Path.rootname() |> String.to_atom()
    expected = %{"path" => "/scratch/selected/" <> name, "sha256" => hash}
    # Load only the preflighted, fixed-fixture modules before binding both the
    # on-disk artifact and OTP's currently loaded executable identity.
    {:module, ^module} = :code.ensure_loaded(module)
    :ok = Beam.selected(module, expected)
    {Atom.to_string(module), expected}
  end

File.write!("/out/selected-bindings.json", Manifest.canonical(Map.new(bindings)))
# Static application metadata only, no captured application callback is started.
:ok = :application.load({:application, :archive_path, [vsn: ~c"0.1.0", modules: []]})

Code.require_file(
  "/scratch/work/test/fixtures/projects/archive_path/proof_qualification_test.exs"
)

for {name, hash} <- selected do
  true = Manifest.digest(File.read!("/inputs/beam/" <> name)) == hash
end
