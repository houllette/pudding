defmodule Pudding.Project.BeamTest do
  use ExUnit.Case, async: true
  alias Pudding.Project.{Beam, Manifest}

  defmodule UnexpectedBackend do
    def debug_info(_, _, pid, _) do
      send(pid, :unexpected_callback)
      raise "must not run"
    end
  end

  defp beam, do: File.read!(:code.which(Manifest))

  defp replace_debug(bytes, debug) do
    {:ok, _, chunks} = :beam_lib.all_chunks(bytes)

    {:ok, changed} =
      :beam_lib.build_module(
        List.keyreplace(chunks, ~c"Dbgi", 0, {~c"Dbgi", :erlang.term_to_binary(debug)})
      )

    changed
  end

  test "unapproved backend never executes; stripped and malformed artifacts are explicit errors" do
    bytes = beam()
    assert {:ok, preflight} = Beam.preflight(bytes)
    assert match?({:elixir_v1, %{}, _}, preflight.data), inspect(preflight.data)
    assert {:ok, core} = Beam.reconstruct(preflight)
    assert :cerl.type(core) == :module
    unexpected = replace_debug(bytes, {:debug_info_v1, UnexpectedBackend, self()})
    assert {:error, :unapproved_debug_backend_or_compile_info} = Beam.preflight(unexpected)

    assert {:error, :unapproved_debug_backend} =
             Beam.reconstruct(%{
               backend: UnexpectedBackend,
               module: PuddingCaptureBeamFixture,
               data: self()
             })

    refute_received :unexpected_callback
    assert {:error, _} = Beam.preflight("not BEAM")
    assert {:error, _} = Beam.preflight(replace_debug(bytes, :malformed))
    assert {:error, _} = Beam.reconstruct(%{preflight | data: :malformed})
    {:ok, {_, stripped}} = :beam_lib.strip(bytes)
    assert {:error, _} = Beam.preflight(stripped)
    refute_received :unexpected_callback
  end

  test "duplicate chunks cannot disagree with the decoded preflight evidence" do
    bytes = beam()
    {:ok, _, chunks} = :beam_lib.all_chunks(bytes)

    for chunk <- [
          {~c"Dbgi", :erlang.term_to_binary({:debug_info_v1, UnexpectedBackend, self()})},
          {~c"CInf", :erlang.term_to_binary(source: ~c"forged")}
        ] do
      {:ok, ambiguous} = :beam_lib.build_module(chunks ++ [chunk])
      assert {:error, :duplicate_beam_chunks} = Beam.preflight(ambiguous)
    end

    refute_received :unexpected_callback
  end

  test "approved backends reject indirect transforms in options and forms" do
    bytes = beam()
    {:ok, preflight} = Beam.preflight(bytes)
    {:elixir_v1, data, specs} = preflight.data

    for key <- [:parse_transform, :core_transform, :debug_info] do
      unsafe = {:elixir_v1, %{data | compile_opts: [{key, UnexpectedBackend}]}, specs}

      assert {:error, _} =
               Beam.preflight(replace_debug(bytes, {:debug_info_v1, :elixir_erl, unsafe}))

      assert {:error, :unsupported_compiler_directive} =
               Beam.reconstruct(%{preflight | data: unsafe})
    end

    for attribute <- [
          {:attribute, 1, :compile, {:parse_transform, UnexpectedBackend}},
          {:attribute, 1, :compile, [{:core_transform, UnexpectedBackend}]}
        ] do
      unsafe = {[attribute], []}

      assert {:error, _} =
               Beam.preflight(replace_debug(bytes, {:debug_info_v1, :erl_abstract_code, unsafe}))
    end

    assert {:ok, self_preflight} = Beam.preflight(File.read!(:code.which(Beam)))
    assert {:ok, _} = Beam.reconstruct(self_preflight)
    # A function called compile/2 in stored Elixir definitions is not a compiler
    # attribute. Conversely, a real persisted compile attribute must be gated.
    unsafe =
      {:elixir_v1, %{data | attributes: [{:compile, {:parse_transform, UnexpectedBackend}}]},
       specs}

    assert {:error, _} =
             Beam.preflight(replace_debug(bytes, {:debug_info_v1, :elixir_erl, unsafe}))

    refute_received :unexpected_callback
    assert {:ok, otp} = Beam.preflight(File.read!(:code.which(:lists)))
    assert {:ok, core} = Beam.reconstruct(otp)
    assert :cerl.type(core) == :module
  end

  @tag :tmp_dir
  test "loaded executable substitution is rejected even with the expected filename", %{
    tmp_dir: dir
  } do
    module = PuddingCaptureLoadedIdentityFixture

    {:ok, ^module, original} =
      :compile.forms([
        {:attribute, 1, :module, module},
        {:attribute, 1, :export, [value: 0]},
        {:function, 1, :value, 0, [{:clause, 1, [], [], [{:atom, 1, :original}]}]}
      ])

    {:ok, ^module, replacement} =
      :compile.forms([
        {:attribute, 1, :module, module},
        {:attribute, 1, :export, [value: 0]},
        {:function, 1, :value, 0, [{:clause, 1, [], [], [{:atom, 1, :replacement}]}]}
      ])

    path = dir <> "/fixture.beam"
    File.write!(path, original)
    candidate = %{"path" => path, "sha256" => Manifest.digest(original)}

    try do
      assert {:module, ^module} = :code.load_binary(module, String.to_charlist(path), original)
      assert :ok = Beam.selected(module, candidate)
      assert {:module, ^module} = :code.load_binary(module, String.to_charlist(path), replacement)
      assert Function.capture(module, :value, 0).() == :replacement

      assert {:error, {:module_substitution, "Elixir.PuddingCaptureLoadedIdentityFixture"}} =
               Beam.selected(module, candidate)
    after
      :code.purge(module)
      :code.delete(module)
      :code.purge(module)
    end
  end

  @tag :tmp_dir
  test "ambiguous identical candidates and code-path substitution fail", %{tmp_dir: dir} do
    path = :code.which(Enum) |> List.to_string()
    bytes = File.read!(path)
    candidate = %{"module" => "Elixir.Enum", "path" => path, "sha256" => Manifest.digest(bytes)}
    assert {:ok, %{"Elixir.Enum" => ^candidate}} = Beam.index([candidate])
    assert {:error, {:ambiguous_module, "Elixir.Enum"}} = Beam.index([candidate, candidate])
    assert :ok = Beam.selected(Enum, candidate)

    assert {:error, {:module_substitution, "Elixir.Enum"}} =
             Beam.selected(Enum, %{candidate | "sha256" => Manifest.digest("replacement")})

    assert {:error, {:module_substitution, "Elixir.Enum"}} =
             Beam.selected(Enum, %{candidate | "path" => dir <> "/Enum.beam"})
  end
end
