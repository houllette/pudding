# Phase 10 — Freeze the evaluation corpus and protocol

**State:** Not started.

**Depends on:** Passed phases 01–09 and current prerequisite handoffs.

**Next:** [11 — Execute the comparison and decide continuation](../11-evaluation-execution/README.md).

Read the [shared architecture](../ARCHITECTURE.md), [plan](../README.md), and
[backend/reference sources](../REFERENCES.md) with the prerequisite handoffs.

## Assignment

Preregister a comparison that distinguishes discovery, additional assurance,
repair quality, preparation cost, held-out reuse, and economic limits. Freeze the
experiment before executing or adapting to held-out results.

## Work

1. Select 20 target/contract pairs across at least five real packages: ten for
   development and ten held out by package. Pin revisions, licenses, inclusion/
   exclusion rules, source/build identities, and the complete denominator. Audit
   compatibility before attempting historical vulnerable/fixed cases.
2. Include supported real byte-oriented functions, known-answer controls, recovered
   historical cases where feasible, and deliberately unsupported targets. Synthetic
   bugs are mechanism controls, not newly discovered or historical vulnerabilities.
   Record held-out exposure/contamination and replace compromised splits explicitly.
3. Accept contracts before runs, including useful acceptance/output, rejection,
   termination scope, and environment assumptions. Time unfamiliar-target contract
   review with misleading inferred policies, reject-all, and weaker-precondition
   traps; retain disagreements and review effort.
4. Freeze three arms: property-based testing (plus actual coverage guidance only
   if implemented); LLM-assisted testing/repair; and the same discovery/testing
   pipeline plus checked proof search. Give all arms identical policies, starting
   examples/artifacts, and behavioral patch gates: unchanged policy, original/new
   regressions, valid/invalid oracle cases, fresh capture, and independent replay.
   Define permitted feedback precisely. Proof completion/receipts are additional
   assurance outcomes, not prerequisites for accepting a testing arm's patch into
   evaluation. Report tested-only patches as tested, not universally correct.
5. Predeclare CPU/memory/elapsed/token budgets at multiple levels, repeated seeds,
   actual monetary accounting, cold/warm measurements, and independent-check cost.
   Freeze Lynx/runtime/toolchain, adapter, tactics/lemmas, isolation/checker policy,
   and all shared preparation before held-out runs. Separate upstream/model work,
   contract review, handwritten proof, per-target adaptation, and failed work.
6. Define schemas and metrics for every attempted pair/arm/run: proof completion,
   reproduced violations, unsupported/unknown/mismatches, patch quality, total cost,
   human time, uncertainty, reuse, and maintenance after source/config/dependency
   changes. Require missing runs and exclusions in the denominator.
7. Freeze tampered translation, omitted-error, hidden-axiom, weakened-policy,
   nonreturning, reject-all, stale-evidence, and missing-claim controls. Proposed
   continuation requires no unresolved supported-subset disagreement, every control
   refused, and at least three held-out real functions from two packages proved
   with frozen backend/lemmas and no hand-edited translation. Obtain review of
   criteria and explicit live-run spend authority before execution.

## Deliverables

`bench/` pinned corpus and policy manifests, run/seed/budget matrix, three-arm
harness, negative controls, and hashed preregistered evaluation protocol.

## Validation and handoff gate

- [ ] Counts, package split, target/build identities, accepted policies, held-out
  access rules, and full denominator are frozen and auditable.
- [ ] All arms share starting information/contracts/behavioral patch gates;
  proof assurance is measured separately. Feedback, budgets, repetitions,
  uncertainty, and cost categories are preregistered.
- [ ] Controls, maintenance mutations, continuation criteria, and deviation policy
  are fixed before held-out execution. Backend adaptation cannot count as free reuse.
- [ ] Development-only smoke tests validate harness/schema mechanics; held-out
  efficacy has not been tuned. Required spend authority is recorded.
- [ ] `mix precommit` and development harness smoke checks pass.

Write `HANDOFF.md` using the [template](../HANDOFF_TEMPLATE.md), with exact
identities, commands/logs, measured effort, and any unresolved gate items.
A failed or incomplete gate blocks dependent phases; never relabel reduced scope
as the original pass.

## Boundary

Do not run paid comparisons without authority, hide unsupported targets, count
external published proof totals as local results, or claim ecosystem qualification
from this small sample. Freeze is not completed evaluation.
