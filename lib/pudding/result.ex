defmodule Pudding.Result do
  @moduledoc """
  Version 1 observation schema, not an evidence checker or receipt authority.

  Outcome, visible assumed premises, contract approval, conformance and freshness
  are independent dimensions. `:assumed` is represented by `assumptions`, never
  as proof of implementation behavior. Claim and evidence identifiers describe
  observations; this module does not authenticate their contents.

  `:proved` is reserved for phase 06's trusted checker. This version cannot issue
  it, even for an accepted contract or a successful direct Lynx proof. Unknown
  fields, enums and incomplete records fail closed instead of defaulting to success.
  """

  @fields [
    :schema_version,
    :outcome,
    :authority,
    :contract,
    :target,
    :assumptions,
    :conformance,
    :freshness,
    :required_claims,
    :established_claims,
    :evidence,
    :reason
  ]
  @enforce_keys @fields
  defstruct @fields

  @type outcome :: :proved | :violation_reproduced | :unsupported | :unknown
  @type t :: %__MODULE__{
          schema_version: 1,
          outcome: outcome(),
          authority: :observation | :direct_lynx,
          contract: %{id: String.t(), state: :candidate | :accepted},
          target: String.t(),
          assumptions: [String.t()],
          conformance: :tested_agreement | :observed_disagreement | :unassessed,
          freshness: :current | :stale | :unassessed,
          required_claims: [String.t()],
          established_claims: [String.t()],
          evidence: [String.t()],
          reason: atom()
        }

  @unknown_reasons [
    :not_run,
    :direct_proof_without_receipt,
    :conditional_proof,
    :timeout,
    :stale_evidence,
    :missing_obligation,
    :conformance_mismatch,
    :checker_error,
    :build_error,
    :proof_incomplete,
    :no_counterexample
  ]

  @doc "Validates a complete observation. This does not check or authorize evidence."
  @spec new(attributes :: term()) ::
          {:ok, t()} | {:error, :invalid_record | :receipt_authority_unavailable}
  def new(attributes) when is_map(attributes) do
    if valid_fields?(attributes),
      do: validate_outcome(attributes),
      else: {:error, :invalid_record}
  end

  def new(_attributes), do: {:error, :invalid_record}

  @doc "Always false in schema v1: no product receipt authority exists yet."
  @spec proved?(result :: term()) :: false
  def proved?(_result), do: false

  defp valid_fields?(attributes) do
    Enum.sort(Map.keys(attributes)) == Enum.sort(@fields) and
      valid_dimensions?(attributes) and valid_identifiers?(attributes)
  end

  defp valid_dimensions?(attributes) do
    attributes.schema_version === 1 and
      attributes.outcome in [:proved, :violation_reproduced, :unsupported, :unknown] and
      attributes.authority in [:observation, :direct_lynx] and
      attributes.conformance in [:tested_agreement, :observed_disagreement, :unassessed] and
      attributes.freshness in [:current, :stale, :unassessed] and
      valid_contract?(attributes.contract)
  end

  defp valid_contract?(%{id: id, state: state} = contract) when map_size(contract) == 2,
    do: nonempty_string?(id) and state in [:candidate, :accepted]

  defp valid_contract?(_contract), do: false

  defp valid_identifiers?(attributes) do
    nonempty_string?(attributes.target) and strings?(attributes.assumptions) and
      strings?(attributes.required_claims) and attributes.required_claims != [] and
      strings?(attributes.established_claims) and strings?(attributes.evidence) and
      Enum.uniq(attributes.required_claims) == attributes.required_claims and
      Enum.uniq(attributes.established_claims) == attributes.established_claims and
      Enum.all?(attributes.established_claims, &(&1 in attributes.required_claims))
  end

  defp strings?([]), do: true
  defp strings?([value | rest]), do: nonempty_string?(value) and strings?(rest)
  defp strings?(_values), do: false
  defp nonempty_string?(value), do: is_binary(value) and byte_size(value) > 0

  defp validate_outcome(%{outcome: :proved}), do: {:error, :receipt_authority_unavailable}

  defp validate_outcome(%{outcome: :unknown, reason: reason} = attributes)
       when reason in @unknown_reasons,
       do: {:ok, struct!(__MODULE__, attributes)}

  defp validate_outcome(%{outcome: :unsupported, reason: :unsupported_construct} = attributes),
    do: {:ok, struct!(__MODULE__, attributes)}

  defp validate_outcome(
         %{
           outcome: :violation_reproduced,
           reason: :replayed_violation,
           evidence: [_ | _],
           authority: :observation
         } = attributes
       ),
       do: {:ok, struct!(__MODULE__, attributes)}

  defp validate_outcome(_attributes), do: {:error, :invalid_record}
end
