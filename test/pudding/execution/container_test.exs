defmodule Pudding.Execution.ContainerTest do
  use ExUnit.Case, async: true
  alias Pudding.Execution.Container

  test "output, nonzero exit and timeout are explicit bounded failures" do
    assert {:ok, "ok"} = Container.command(["-c", "printf ok"], engine: "sh")

    assert {:error, %{reason: :nonzero_exit, status: 7, output: "bad"}} =
             Container.command(["-c", "printf bad; exit 7"], engine: "sh")

    assert {:error, %{reason: :output_limit, output: output}} =
             Container.command(["-c", "printf 1234567890"], engine: "sh", output_bytes: 4)

    assert byte_size(output) <= 4

    started = System.monotonic_time(:millisecond)

    assert {:error, %{reason: :timeout}} =
             Container.command(["-c", "exec sleep 20"], engine: "sh", timeout_ms: 20)

    assert System.monotonic_time(:millisecond) - started < 2_000
  end

  test "unavailable engine never falls back to local execution" do
    assert {:error, %{reason: :engine_unavailable}} =
             Container.command([], engine: "pudding-nonexistent-engine")
  end
end
