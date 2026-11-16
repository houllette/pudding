defmodule ArchivePath.ProductionQualificationTest do
  use ExUnit.Case, async: true

  alias Pudding.Contracts.PathPolicy

  test "ordinary consumption has the policy but no Reach" do
    assert :code.which(Reach) == :non_existing
    assert Application.spec(:lynx, :vsn) == ~c"0.1.0"
    assert PathPolicy.expected("a/b") === {:ok, ["a", "b"]}
  end
end
