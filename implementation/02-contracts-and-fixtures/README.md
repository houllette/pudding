# Phase 02 — Freeze the policy and ordinary consumer fixtures

**State:** Not started.

**Depends on:** Passed phase 01 and its current handoff.

**Next:** [03 — Prove the actual binary validator directly with Lynx](../03-validator-proof/README.md).

Read the [shared architecture](../ARCHITECTURE.md), [plan](../README.md), and
[backend/reference sources](../REFERENCES.md) with the prerequisite handoffs.

## Assignment

Turn the shared archive-path policy into a reviewed executable specification
and ordinary vulnerable/fixed Elixir fixtures. Define the result/evidence schema
before a proof worker can influence policy. Only explicit authority accepts a
contract; preparing it in this phase is not approval.

## Work

1. Encode the exact byte policy in ARCHITECTURE.md, including empty-preserving
   slash splitting, exact success components, error atoms, invalid UTF-8, and
   ordinary backslash/colon bytes. Use a reference algorithm meaningfully distinct
   from the validator. Keep its implementation separate from its law/proof.
2. Prepare immutable candidate/accepted policy records with authority, domain,
   quantifiers, assumptions, executable predicate digests, and required claim IDs.
   Obtain owner acceptance before phase 03. Record what would require new approval.
3. Create ordinary Mix consumer fixtures with an intentionally vulnerable check
   that rejects `../` but accepts `..`, and a fixed byte-recursive validator.
   Preserve both implementations; no hand-written Lean replacement of either.
   Label this a synthetic defect, not a historical OTP ZIP reproduction.
4. Add concrete oracle/fixture tests for empty input/components, `.`, `..`, embedded
   NUL, leading/trailing/repeated slash, valid arbitrary bytes, backslash, colon,
   exact component output, and invalid UTF-8. Test the nonbinary wrapper, including
   nonbyte bitstrings if it promises all nonbinary terms. State its precise domain.
5. Prepare direct Lynx laws for the full binary input domain and separate wrapper.
   Positive acceptance and error behavior are obligations, not validity assumptions.
   Test reject-all, sanitized-output, and stronger-precondition policies as controls
   so that a vacuous security statement cannot replace the accepted contract.
6. Define structured evidence outcome, visible assumed premises, contract approval,
   conformance, and freshness dimensions with examples: direct proof without receipt,
   conditional proof, reproduced violation, unsupported construct, timeout, stale
   result, and missing obligation. No unrecognized outcome defaults to success.

## Deliverables

Accepted policy records, separate reference/fixture implementations, ExUnit
boundary/control tests, initial direct Lynx laws, and versioned result schema.

## Validation and handoff gate

- [ ] Accepted contract identity and approval exist; candidate proposals remain
  separately visible. Without approval, leave this gate blocked.
- [ ] Concrete byte-policy cases assert exact values and expose the vulnerable `..`
  behavior while the fixed fixture satisfies them.
- [ ] Laws cover every finite binary, not only already valid paths; wrapper scope,
  unexpected errors, totality, and filesystem/Unicode exclusions are explicit.
- [ ] Reject-all, changed-output, and hidden-precondition controls conflict with
  required obligations. No production claim follows from a passing case corpus.
- [ ] Outcome/schema tests distinguish assumptions, conformance, freshness, and
  evidence authority; `mix precommit` and ordinary consumer tests pass.

Write `HANDOFF.md` using the [template](../HANDOFF_TEMPLATE.md), with exact
identities, commands/logs, measured effort, and any unresolved gate items.
A failed or incomplete gate blocks dependent phases; never relabel reduced scope
as the original pass.

## Boundary

No discovery worker, contract DSL, inferred-policy auto-acceptance, filesystem
security theorem, or universal validator proof claim. Do not infer policy from
what the vulnerable implementation happens to accept.
