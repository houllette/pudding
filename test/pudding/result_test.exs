defmodule Pudding.ResultTest do
  use ExUnit.Case, async: true

  alias Pudding.Result

  defp example(overrides \\ %{}) do
    Map.merge(
      %{
        schema_version: 1,
        outcome: :unknown,
        authority: :observation,
        contract: %{id: "archive-path/v1", state: :candidate},
        target: "example-build-sha256",
        assumptions: ["Idealized sufficient memory; no filesystem interpretation"],
        conformance: :unassessed,
        freshness: :current,
        required_claims: ["binary_contract/1", "nonbinary_wrapper/1"],
        established_claims: [],
        evidence: [],
        reason: :not_run
      },
      overrides
    )
  end

  test "direct and conditional proofs remain unknown without receipt authority" do
    for reason <- [:direct_proof_without_receipt, :conditional_proof] do
      attrs =
        example(%{
          authority: :direct_lynx,
          reason: reason,
          established_claims: ["binary_contract/1", "nonbinary_wrapper/1"],
          evidence: ["example/export.ndjson"]
        })

      assert {:ok, result} = Result.new(attrs)
      assert result.outcome == :unknown
      assert result.assumptions == attrs.assumptions
      refute Result.proved?(result)
    end
  end

  test "replayed violation, unsupported construct and timeout are different outcomes" do
    examples = [
      %{outcome: :violation_reproduced, reason: :replayed_violation, evidence: ["replay.log"]},
      %{outcome: :unsupported, reason: :unsupported_construct},
      %{outcome: :unknown, reason: :timeout}
    ]

    for attrs <- examples do
      assert {:ok, result} = Result.new(example(attrs))
      assert result.outcome == attrs.outcome
      assert result.reason == attrs.reason
      refute Result.proved?(result)
    end
  end

  test "stale, missing obligation and conformance disagreement cannot be proof" do
    for attrs <- [
          %{freshness: :stale, reason: :stale_evidence},
          %{reason: :missing_obligation, established_claims: ["binary_contract/1"]},
          %{conformance: :observed_disagreement, reason: :conformance_mismatch}
        ] do
      assert {:ok, result} = Result.new(example(attrs))
      assert result.outcome == :unknown
      refute Result.proved?(result)
    end
  end

  test "contract acceptance, assumed premises, conformance and freshness stay independent" do
    attrs =
      example(%{
        contract: %{id: "archive-path/v1", state: :accepted},
        assumptions: ["Conditional premise", "Runtime model trust"],
        conformance: :tested_agreement,
        freshness: :stale,
        reason: :stale_evidence
      })

    assert {:ok, result} = Result.new(attrs)
    assert result.contract.state == :accepted
    assert result.assumptions == attrs.assumptions
    assert result.conformance == :tested_agreement
    assert result.freshness == :stale
    assert result.outcome == :unknown
  end

  test "no caller can mint a proved result before the trusted checker exists" do
    assert {:error, :receipt_authority_unavailable} = Result.new(example(%{outcome: :proved}))

    assert {:error, :invalid_record} =
             Result.new(example(%{authority: :trusted_checker, outcome: :proved}))

    refute Result.proved?(%{outcome: :proved})
    refute Result.proved?(%{outcome: :surprise})
  end

  test "unknown enums, missing fields, extra fields and mismatched evidence fail closed" do
    invalid = [
      example(%{outcome: :success}),
      example(%{schema_version: 2}),
      example(%{schema_version: 1.0}),
      example(%{assumptions: ["premise" | :improper]}),
      example(%{evidence: ["log" | :improper]}),
      example(%{authority: :agent}),
      example(%{conformance: :perfect}),
      example(%{freshness: :fresh}),
      example(%{contract: %{id: "archive-path/v1", state: :auto_accepted}}),
      example(%{reason: :arbitrary}),
      example(%{assumptions: :hidden}),
      example(%{required_claims: []}),
      example(%{established_claims: ["different/1"]}),
      example(%{outcome: :violation_reproduced, reason: :timeout}),
      example(%{outcome: :violation_reproduced, reason: :replayed_violation}),
      example(%{outcome: :unsupported, reason: :not_run}),
      example(%{outcome: :assumed}),
      example(%{receipt: "self-issued"}),
      Map.delete(example(), :assumptions)
    ]

    for attrs <- invalid do
      assert {:error, _reason} = Result.new(attrs), inspect(attrs)
    end

    assert {:error, :invalid_record} = Result.new(nil)
  end
end
