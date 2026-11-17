defmodule Pudding.Project.CaptureTest do
  use ExUnit.Case, async: true
  alias Pudding.Project.Capture

  test "comparison includes inspector/toolchain identity rather than discarding metadata" do
    first = %{"files" => %{"inspection.json" => %{"sha256" => "a", "size" => 1}}}
    second = %{"files" => %{"inspection.json" => %{"sha256" => "b", "size" => 1}}}

    assert %{"equal" => false, "changed" => ["inspection.json"], "normalizations" => []} =
             Capture.compare(first, second)

    assert %{"equal" => true, "changed" => []} = Capture.compare(first, first)
  end
end
