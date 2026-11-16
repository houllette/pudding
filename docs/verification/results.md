# Result schema v1

`Pudding.Result.new/1` validates a **complete observation map** with exactly the
fields below. It does not run proofs, authenticate contracts/artifacts, inspect
logs, replay witnesses, infer freshness or authorize receipts. `proved?/1` always
returns false, including for forged maps/structs. Only phase 06's future trusted
checker may issue product `proved` receipts. Source-level struct construction is
not a security boundary; callers must not treat an `outcome` field as authority.

| Field | Meaning / allowed values |
| --- | --- |
| `schema_version` | Exact integer `1` |
| `outcome` | `:unknown`, `:unsupported`, `:violation_reproduced`; `:proved` reserved and rejected |
| `authority` | `:observation` or `:direct_lynx`, both descriptive |
| `contract` | Exactly `%{id: nonempty_binary, state: :candidate \| :accepted}` |
| `target` | Nonempty build/artifact identifier, not authenticated by this schema |
| `assumptions` | Visible list of nonempty strings, including logical premises and trust/exclusions; never promotes to proof |
| `conformance` | `:tested_agreement`, `:observed_disagreement`, `:unassessed` |
| `freshness` | `:current`, `:stale`, `:unassessed`, relative to the identified build |
| `required_claims` | Nonempty list of unique nonempty claim IDs |
| `established_claims` | Unique IDs, subset of required IDs; reported evidence only |
| `evidence` | List of nonempty artifact/log IDs; references are not checked |
| `reason` | Recognized atom consistent with outcome (below) |

Unknown enums/keys, missing fields, improper lists, mismatched claim IDs or unknown
versions return `{:error, :invalid_record}`. Attempting `:proved` with otherwise
valid fields returns `{:error, :receipt_authority_unavailable}`. This module never
silently creates a successful result. Assumed premises are a separate dimension,
not a fifth outcome or automatic proof.

## Examples

This complete example is **illustrative**, not a retained proof result:

```elixir
base = %{
  schema_version: 1,
  outcome: :unknown,
  authority: :observation,
  contract: %{id: "pudding.archive_path.bytes/v1", state: :accepted},
  target: "example-source-and-build-digest",
  assumptions: ["Idealized sufficient memory; runtime-model/compiler trust"],
  conformance: :unassessed,
  freshness: :current,
  required_claims: ["ArchivePath.Laws.binary_contract/1", "ArchivePath.Laws.nonbinary_wrapper/1"],
  established_claims: [],
  evidence: [],
  reason: :not_run
}
{:ok, observation} = Pudding.Result.new(base)
false = Pudding.Result.proved?(observation)
```

Each row gives overrides for `base` using `Map.merge(base, overrides)`. Executable
schema tests cover these cases, independence, malformed input and proof refusal.

| Situation | Overrides / classification |
| --- | --- |
| Direct Lynx proof, no product receipt | `authority: :direct_lynx`, `outcome: :unknown`, `reason: :direct_proof_without_receipt`, with reported claim/export IDs |
| Conditional proof | `authority: :direct_lynx`, `outcome: :unknown`, `reason: :conditional_proof`, explicit premises in `assumptions` |
| Real replayed violation | `authority: :observation`, `outcome: :violation_reproduced`, `reason: :replayed_violation`, nonempty replay evidence |
| Missing backend construct | `outcome: :unsupported`, `reason: :unsupported_construct` |
| Timeout | `outcome: :unknown`, `reason: :timeout`; not nontermination proof |
| Stale result | `outcome: :unknown`, `freshness: :stale`, `reason: :stale_evidence` |
| Missing required obligation | `outcome: :unknown`, `reason: :missing_obligation`, incomplete established IDs |
| Conformance disagreement | `outcome: :unknown`, `conformance: :observed_disagreement`, `reason: :conformance_mismatch` |

Other recognized unknown reasons are `:not_run`, `:checker_error`, `:build_error`,
`:proof_incomplete` and `:no_counterexample`. A model witness or failed proof is
not a reproduced violation. A caller-supplied replay reference satisfies only
schema shape, not the captured uninstrumented-BEAM replay requirement. Phase 02's
fixture test demonstrates the concrete synthetic BEAM mismatch; it does not
implement phase 04 capture or phase 07 general witness replay.

Contract approval, assumptions, finite conformance and freshness remain independent:
an accepted contract can have stale unknown evidence; tested agreement is not a
universal theorem. Required-claim CI must later reject every missing, stale,
unsupported, unknown or violated required obligation. No evidence consumer should
authorize success from this observation-only version.
