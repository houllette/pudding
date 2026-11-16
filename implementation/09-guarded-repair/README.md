# Phase 09 — Repair behind the unchanged accepted contract

**State:** Not started.

**Depends on:** Passed phases 01–08 and current prerequisite handoffs.

**Next:** [10 — Freeze the evaluation corpus and protocol](../10-evaluation-preparation/README.md).

Read the [shared architecture](../ARCHITECTURE.md), [plan](../README.md), and
[backend/reference sources](../REFERENCES.md) with the prerequisite handoffs.

## Assignment

Demonstrate discovery, regression, patch proposal, fresh build, and independent
reproof while preserving the security contract and useful accepted behavior.
Use a distinct repair workspace; do not let proof-worker privileges grow implicitly.

## Work

1. Begin from captured vulnerable code and its independently replayed violation.
   Freeze accepted contract/claim IDs, reference policy, original tests, and
   checker/backend inputs. Retain original artifact and failed attempt history.
2. Permit patch proposals only in declared implementation and new regression paths.
   Deny edits to accepted policy, old tests, trusted lemmas, generated Lean code,
   backend/toolchain, checker, build configuration, and evidence authority unless
   separately reviewed outside the repair loop.
3. Add the minimized witness as a regression and run valid-input/output cases,
   original tests, and consumer checks. Then recapture the entire patched closure
   and prove the unchanged full binary/wrapper obligations through phase 06.
4. Reject reject-all, output sanitization, hidden validity preconditions, swallowed
   errors, nonreturning patches, renamed/missing claims, and edits that evade
   capture. A timeout is unknown, not a successful repair.
5. Independently replay old and new BEAM artifacts on the witness; retain source
   diff, build provenance, tests, proof/export/checker bundle, assumptions, limits,
   actual costs, and intervention. No automatic commit, publish, or deployment.
6. Disclose the earlier fixed fixture/reference and handwritten proof work as
   preparation. Measure automation separately; use authorization and hard limits
   for any live worker spend. Write the demonstration gate decision.

## Deliverables

End-to-end repair demonstration, guarded patch runner, retained regression/diff,
old/new capture and evidence bundles, cost/intervention ledger, and gate decision.

## Validation and handoff gate

- [ ] Original violation remains reproducible; newly patched artifact rejects it
  and accepts valid paths with exact original components.
- [ ] Fresh independently checked receipts bind the patched build to the identical
  accepted contract and all binary/wrapper obligations.
- [ ] Restricted writes and malicious/vacuous/nonreturning repair controls are
  enforced; old regressions cannot be deleted to get a pass.
- [ ] Both artifact histories, attempts, manual preparation, resources, and gate
  decision remain replayable without the agent transcript.
- [ ] `mix precommit` and fresh non-test consumer tests pass.

Write `HANDOFF.md` using the [template](../HANDOFF_TEMPLATE.md), with exact
identities, commands/logs, measured effort, and any unresolved gate items.
A failed or incomplete gate blocks dependent phases; never relabel reduced scope
as the original pass.

## Boundary

No general autonomous vulnerability-fixing claim, deployment authority, policy
weakening, or claim that a prepared demonstration proves zero-touch generalization.
