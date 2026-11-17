ExUnit.start(autorun: false)

if Mix.env() != :prod, do: raise("proof qualification requires MIX_ENV=prod")

# Manual phase-03 harness, not a general Pudding evidence checker or receipt.
defmodule ArchivePath.ProofQualification do
  use ExUnit.Case, async: true

  alias Pudding.Contracts.PathPolicy

  @output System.fetch_env!("VALIDATOR_OUTPUT")
  @root Path.expand("../../../..", __DIR__)
  @required ["binary_contract/1", "nonbinary_wrapper/1"]

  test "both exact full-domain statements verify freshly and export together" do
    {reports, output, export} = verify(ArchivePath.Laws, "fixed", postlude: true)
    assert complete?(reports)
    assert File.stat!(export).size > 0

    statements = File.read!(Path.join(output, "Elixir/ArchivePath/Laws/laws.lean"))

    for name <- ["binary_contract", "nonbinary_wrapper"] do
      assert statements =~ """
             theorem «#{name}/1» (input : Lynx.Term)
                 (requires : «#{name}:requires/1» input = Except.ok Lynx.Term.true) :
                 «#{name}:ensures/1» input = Except.ok Lynx.Term.true := by
             """
    end

    definitions = File.read!(Path.join(output, "Elixir/ArchivePath/Laws.lean"))

    assert definitions =~ """
           def «binary_contract:requires/1» (_0 : Lynx.Term) : Except Lynx.Exception Lynx.Term :=
             Erlang.erlang.«is_binary/1» _0
           """

    assert definitions =~ """
           def «binary_contract:ensures/1» (_0 : Lynx.Term) : Except Lynx.Exception Lynx.Term := do
             let _2 ← Elixir.ArchivePath.Fixed.«validate/1» _0
             let _1 ← Elixir.Pudding.Contracts.PathPolicy.«expected/1» _0
             Erlang.erlang.«=:=/2» _2 _1
           """

    assert definitions =~ """
           def «nonbinary_wrapper:requires/1» (_0 : Lynx.Term) : Except Lynx.Exception Lynx.Term := do
             let _1 ← Erlang.erlang.«is_binary/1» _0
             Erlang.erlang.«not/1» _1
           """

    assert definitions =~ """
           def «nonbinary_wrapper:ensures/1» (_0 : Lynx.Term) : Except Lynx.Exception Lynx.Term := do
             let _1 ← Elixir.ArchivePath.Fixed.«validate/1» _0
             Erlang.erlang.«=:=/2» _1 (Lynx.Term.tuple #[Lynx.Term.atom "error", Lynx.Term.atom "not_binary"])
           """

    # A green wrapper alone or a cached/skipped result is not completion.
    missing =
      Enum.map(
        reports,
        &Map.update!(&1, :theorems, fn ts ->
          Enum.reject(ts, fn t -> t.name == "binary_contract/1" end)
        end)
      )

    refute complete?(missing)
    refute complete?([])
    refute complete?(Enum.map(reports, &Map.put(&1, :cached, true)))
    refute complete?(Enum.map(reports, &Map.put(&1, :status, :skipped)))
  end

  test "vulnerable, reject-all, changed output and strengthened-domain controls do not complete" do
    for {module, witness} <- [
          {ArchivePath.VulnerableLaws, ".."},
          {ArchivePath.RejectAllLaws, "a/b"},
          {ArchivePath.SanitizedLaws, "a/b"}
        ] do
      assert_raise RuntimeError, ~r/expects returned false/, fn ->
        module.binary_contract(witness)
      end

      {reports, _output, export} = verify(module, inspect(module))
      refute complete?(reports)

      assert Enum.any?(reports, fn r ->
               r.status == :error and Enum.any?(r.diagnostics, &(&1.severity == :error))
             end)

      refute File.exists?(export)
    end

    assert ArchivePath.Vulnerable.validate("..") === {:ok, [".."]}
    assert PathPolicy.expected("..") === {:error, :invalid_path}
    assert ArchivePath.Laws.binary_contract("..")

    assert_raise ArgumentError, ~r/requires returned false/, fn ->
      ArchivePath.StrongerPreconditionLaws.binary_contract("..")
    end

    {reports, output, export} = verify(ArchivePath.StrongerPreconditionLaws, "stronger")
    refute complete?(reports)
    refute File.exists?(export)
    source = File.read!(Path.join(output, "Elixir/ArchivePath/StrongerPreconditionLaws.lean"))
    assert source =~ "PathPolicy.«expected/1»"

    refute source =~ """
           def «binary_contract:requires/1» (_0 : Lynx.Term) : Except Lynx.Exception Lynx.Term :=
             Erlang.erlang.«is_binary/1» _0
           """
  end

  test "admitted transitive helper cannot export a false claim" do
    {reports, _output, export} = verify(ArchivePath.AdmittedLaws, "admitted")

    assert Enum.any?(reports, fn r ->
             r.status == :error and Enum.any?(r.diagnostics, &(&1.message =~ "sorryAx"))
           end)

    refute complete?(reports)
    refute File.exists?(export)
  end

  defp complete?(reports) do
    reports != [] and Enum.all?(reports, &(&1.status == :ok and not &1.cached)) and
      Enum.flat_map(reports, & &1.theorems) |> Enum.map(& &1.name) |> Enum.sort() == @required
  end

  defp verify(module, name, opts \\ []) do
    output = Path.join(@output, name)
    File.mkdir!(output)
    export = Path.join(output, "proof.ndjson")
    refute File.exists?(export)

    postludes =
      if opts[:postlude],
        do: [Lynx.Lean.from_file!(Path.join(@root, "proof/validator/lemmas.lean"))],
        else: []

    reports =
      Lynx.Laws.verify([module],
        cache: false,
        export: export,
        debug: :lean,
        debug_dir: output,
        postludes: postludes,
        options: [maxRecDepth: 4096, maxHeartbeats: 2_000_000]
      )

    File.write!(
      Path.join(output, "reports.txt"),
      inspect(reports, pretty: true, limit: :infinity)
    )

    {reports, output, export}
  end
end

Code.require_file("test/contract_test.exs", __DIR__)
Code.require_file("test/production_test.exs", __DIR__)
%{failures: failures} = ExUnit.run()
if failures != 0, do: System.halt(1)
