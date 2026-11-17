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

    policy = candidate["executable_policy"]
    assert sha256(File.read!(Path.join(@root, policy["path"]))) == policy["sha256"]

    # The immutable candidate binds Phase 02's initial law bytes. Phase 03 adds
    # proofs only; compare executable law ASTs independently of those proofs.
    initial = File.read!(Path.join(@root, "proof/validator/contract/initial-laws.ex.txt"))
    current = File.read!(Path.join(@root, candidate["initial_law_source"]["path"]))
    assert sha256(initial) == candidate["initial_law_source"]["sha256"]
    assert law_statements(current) == law_statements(initial)
    assert length(law_statements(current)) == 3

    bindings =
      @root
      |> Path.join("proof/validator/contract/proof-inputs.json")
      |> File.read!()
      |> :json.decode()

    for {path, digest} <- bindings do
      assert sha256(File.read!(Path.join(@root, path))) == digest, path
    end
  end

  defp law_statements(source) do
    {_ast, statements} =
      source
      |> Code.string_to_quoted!()
      |> Macro.prewalk([], fn
        {:law, _, [call, opts]} = ast, acc ->
          statement = {call, Keyword.take(opts, [:requires, :expects])}

          {normalized, _} =
            Macro.prewalk(statement, nil, fn
              {name, metadata, args}, state when is_list(metadata) -> {{name, [], args}, state}
              node, state -> {node, state}
            end)

          {ast, [normalized | acc]}

        ast, acc ->
          {ast, acc}
      end)

    statements
  end

  defp sha256(bytes), do: :sha256 |> :crypto.hash(bytes) |> Base.encode16(case: :lower)
end
