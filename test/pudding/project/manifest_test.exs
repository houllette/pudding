defmodule Pudding.Project.ManifestTest do
  use ExUnit.Case, async: true

  alias Pudding.Project.Manifest

  @tag :tmp_dir
  test "immutable bundles bind every byte and reject tampering and extra files", %{tmp_dir: dir} do
    bundle = Path.join(dir, "bundle")
    assert {:ok, first} = Manifest.seal(bundle, %{"environment" => "prod"}, %{"beam/a" => "abc"})
    assert {:ok, ^first} = Manifest.load(bundle)
    assert {:error, :already_exists} = Manifest.seal(bundle, %{}, %{})
    File.chmod!(Path.join(bundle, "objects/" <> Manifest.digest("abc")), 0o600)
    File.write!(Path.join(bundle, "objects/" <> Manifest.digest("abc")), "replacement")
    assert {:error, {:object_mismatch, "beam/a"}} = Manifest.load(bundle)
  end

  @tag :tmp_dir
  test "oversized sparse replacement is refused using length before reading content", %{
    tmp_dir: dir
  } do
    bundle = dir <> "/bundle"
    assert {:ok, _} = Manifest.seal(bundle, %{}, %{"small" => "x"})
    path = bundle <> "/objects/" <> Manifest.digest("x")
    File.chmod!(path, 0o600)

    File.open!(path, [:write], fn file ->
      :file.position(file, 134_217_728)
      IO.binwrite(file, "x")
    end)

    assert {:error, {:object_mismatch, "small"}} = Manifest.load(bundle)
  end

  @tag :tmp_dir
  test "duplicate content is stored once, including empty files", %{tmp_dir: dir} do
    assert {:ok, _} =
             Manifest.seal(dir <> "/bundle", %{}, %{
               "a" => "same",
               "b" => "same",
               "c" => "",
               "d" => ""
             })

    assert {:ok, _} = Manifest.load(dir <> "/bundle")
    assert length(File.ls!(dir <> "/bundle/objects")) == 2
  end

  @tag :tmp_dir
  test "unlisted objects and symlinked manifest are refused", %{tmp_dir: dir} do
    bundle = dir <> "/bundle"
    assert {:ok, _} = Manifest.seal(bundle, %{}, %{})
    File.write!(bundle <> "/objects/extra", "unbound")
    assert {:error, :unexpected_entries} = Manifest.load(bundle)
    File.rm!(bundle <> "/objects/extra")
    File.rename!(bundle <> "/manifest.json", dir <> "/outside.json")
    File.ln_s!(dir <> "/outside.json", bundle <> "/manifest.json")
    assert {:error, :unsafe_bundle} = Manifest.load(bundle)
  end

  @tag :tmp_dir
  test "metadata, names, and file content all participate in identity", %{tmp_dir: dir} do
    for {name, metadata, files} <- [
          {"one", %{"env" => "prod"}, %{"source" => "a"}},
          {"two", %{"env" => "test"}, %{"source" => "a"}},
          {"three", %{"env" => "prod"}, %{"source" => "b"}},
          {"four", %{"env" => "prod"}, %{"other" => "a"}}
        ] do
      assert {:ok, _} = Manifest.seal(Path.join(dir, name), metadata, files)
    end

    identities =
      for name <- ~w(one two three four), do: Manifest.load!(Path.join(dir, name))["id"]

    assert length(Enum.uniq(identities)) == 4

    assert {:error, :unsafe_name} =
             Manifest.seal(Path.join(dir, "unsafe"), %{}, %{"../escape" => "x"})
  end
end
