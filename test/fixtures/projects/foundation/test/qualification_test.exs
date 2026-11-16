ExUnit.start(autorun: false)

defmodule Foundation.Qualification do
  use ExUnit.Case, async: true

  @output System.fetch_env!("FOUNDATION_OUTPUT")

  test "ordinary production consumer has no test-only Reach dependency" do
    assert Mix.env() == :prod
    assert :code.which(Reach) == :non_existing
    assert Pudding.hello() == :world
    assert Application.spec(:lynx, :vsn) == ~c"0.1.0"
  end

  test "fresh true law verifies and exports exactly the required obligation" do
    output = Path.join(@output, "true")
    File.mkdir_p!(output)
    export = Path.join(output, "proof.ndjson")
    refute File.exists?(export)

    reports =
      Lynx.Laws.verify([Foundation.Laws],
        export: export,
        debug: :lean,
        debug_dir: output
      )

    File.write!(
      Path.join(output, "reports.txt"),
      inspect(reports, pretty: true, limit: :infinity)
    )

    assert reports != []
    assert Enum.all?(reports, &(&1.status == :ok and &1.cached == false))
    assert Enum.flat_map(reports, & &1.theorems) |> Enum.map(& &1.name) == ["involution/2"]
    assert File.stat!(export).size > 0
    statement = File.read!(Path.join(output, "Elixir/Foundation/Laws/laws.lean"))

    assert statement =~ """
           theorem «involution/2» (left : Lynx.Term) (right : Lynx.Term) :
               «involution:ensures/2» left right = Except.ok Lynx.Term.true := by
           """

    assert Foundation.Laws.involution(1, :different)
    assert Foundation.Pair.swap({1, :different}) == {:different, 1}
  end

  test "transitive sorry axiom is rejected even when elaboration completes" do
    output = Path.join(@output, "admitted")
    File.mkdir_p!(output)
    export = Path.join(output, "proof.ndjson")
    refute File.exists?(export)
    reports = Lynx.Laws.verify([Foundation.AdmittedLaws], export: export)

    File.write!(
      Path.join(output, "reports.txt"),
      inspect(reports, pretty: true, limit: :infinity)
    )

    assert Enum.any?(reports, fn report ->
             report.status == :error and
               Enum.any?(report.diagnostics, &(&1.message =~ "sorryAx"))
           end)

    refute File.exists?(export)
  end

  test "false universal expectation fails proof elaboration and leaves no export" do
    output = Path.join(@output, "false")
    File.mkdir_p!(output)
    export = Path.join(output, "proof.ndjson")
    refute File.exists?(export)

    assert_raise RuntimeError, ~r/expects returned false/, fn ->
      Foundation.FalseLaws.unchanged(1, :different)
    end

    reports =
      Lynx.Laws.verify([Foundation.FalseLaws],
        export: export,
        debug: :lean,
        debug_dir: output
      )

    File.write!(
      Path.join(output, "reports.txt"),
      inspect(reports, pretty: true, limit: :infinity)
    )

    errors = for report <- reports, report.status == :error, do: report
    assert [%{module: "Elixir.Foundation.FalseLaws.laws", diagnostics: diagnostics}] = errors
    assert Enum.any?(diagnostics, &(&1.severity == :error and &1.message =~ "rfl"))
    refute File.exists?(export)
  end
end

%{failures: failures} = ExUnit.run()
if failures != 0, do: System.halt(1)
