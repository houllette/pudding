# Phase 16 — Execute the comparison and decide continuation

**State:** Not started.

**Depends on:** Passed phase 15, frozen protocol/artifacts, authorized run budget.

**Next:** [17 — Incremental evidence](../17-incremental-evidence/README.md), subject to the written continuation decision.

**Brief:** Sections 9, 11, 13.4, 13.6–13.8.

## Assignment

Run the preregistered three-arm evaluation, independently validate its evidence,
and report what the results support. A completed experiment can produce a no-go;
finishing the runs does not itself qualify the product.

## Work

1. Verify protocol, corpus, contracts, semantics/tactics/adapters, and checker
   hashes before each run. Execute the recorded repetitions/budget levels with
   fixed initial examples. Retain all attempts, seeds, resource/cost logs,
   failures, exclusions, unknowns, unsupported targets, and manual interventions.
2. Freeze shared machinery before held-out packages. If a new semantic feature,
   imported-program edit, adapter, or target lemma preparation is necessary,
   classify it as adaptation cost and a protocol deviation; do not quietly
   count it as zero-touch held-out reuse or rewrite the denominator.
3. Replay violations independently on uninstrumented identified BEAM artifacts.
   Recheck every reported proof through the offline checker and complete
   dependency closure. A generated proof script without a receipt remains
   unknown. Quarantine semantic disagreement rather than counting its theorem
   as current implementation assurance.
4. Apply identical patch gates in all arms: unchanged accepted policy, original
   regressions, valid-input requirements, fresh capture, and independent replay.
   Report correctness separately from whether an arm's formal proof completed.
5. Run all negative controls and maintenance mutations from the protocol.
   Measure cold/warm reuse, contract-review time/disagreements, adapter/lemma/
   repair effort, failed work, checker cost, and infrastructure cost separately.
6. Produce inspectable results with full proved/attempted/discovered denominators,
   selection rules, stochastic uncertainty, and actual monetary/resource budgets.
   Distinguish universal assurance from new bug discovery and held-out reuse.
7. Publish `docs/verification/evaluation.md` and a continuation decision against
   predeclared criteria: no unresolved supported disagreement, all negative
   controls refused, and at least three held-out real functions from two packages
   proved using frozen semantics without hand-edited imports. If unmet, record
   no-go/limited scope and the concrete next experiment before phase 17.

## Deliverables

Reproducible per-run bundles, structured aggregate results, independent replay
logs, intervention/expense ledger, protocol-deviation report, and gate decision.
No result should require the original LLM transcript to validate.

## Validation and handoff gate

- [ ] Every planned target/arm/repetition has a result or explicit failed/missing
  run, with its budget and reason retained; the denominator is unchanged.
- [ ] Reported proofs/violations independently replay and reported patches pass
  identical frozen-contract quality gates.
- [ ] Held-out adaptation, human time, preparation, failed attempts, checker time,
  actual cost, and uncertainty are visible rather than folded into successes.
- [ ] Negative controls and maintenance cases have explicit expected/actual results.
- [ ] The continuation decision states which criteria passed or failed. A no-go
  requires a documented scope decision before product/reuse qualification work.
- [ ] `mix precommit` and result/harness consistency checks pass; no new comparison
  run is required merely to regenerate tables from retained artifacts.

Write `HANDOFF.md` with protocol/result hashes, exact reaggregation/replay commands,
evaluation limits, gate decision, and the specifically permitted next scope.

## Boundary

Do not treat a local proof count, selected successful examples, total tokens, or
synthetic defect discovery as measured production efficacy or universal economic
superiority. Unfavorable results must remain reviewable.
