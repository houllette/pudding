defmodule Pudding.Contracts.IdentityTest do
  use ExUnit.Case, async: true

  @root Path.expand("../../..", __DIR__)
  @candidate "test/fixtures/contracts/candidates/archive-path-v1.json"
  @accepted "test/fixtures/contracts/accepted/archive-path-v1.json"
  @candidate_sha256 "f576679bad86234b75c59241be674e2cfab0bf0c704cdef8845f516057ea8d7f"

  test "the owner-accepted candidate and its frozen executable sources retain their identity" do
    candidate_bytes = File.read!(Path.join(@root, @candidate))
    candidate = :json.decode(candidate_bytes)
    accepted = @root |> Path.join(@accepted) |> File.read!() |> :json.decode()

    assert sha256(candidate_bytes) == @candidate_sha256
    assert accepted["candidate_sha256"] == @candidate_sha256
    assert accepted["candidate_path"] == @candidate
    assert accepted["contract_id"] == candidate["contract_id"]
    assert accepted["state"] == "accepted"
    assert accepted["selected_option"] == "accept: Accept this exact contract identity"
    assert candidate["state"] == "candidate"

    for source <- [candidate["executable_policy"], candidate["initial_law_source"]] do
      bytes = @root |> Path.join(source["path"]) |> File.read!()
      assert sha256(bytes) == source["sha256"], source["path"]
    end
  end

  defp sha256(bytes), do: :sha256 |> :crypto.hash(bytes) |> Base.encode16(case: :lower)
end
