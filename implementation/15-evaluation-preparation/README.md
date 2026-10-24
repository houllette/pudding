# Phase 15 — Freeze the evaluation corpus and protocol

**State:** Not started.

**Depends on:** Passed phase 14 demonstration; recorded preparation/adaptation cost.

**Next:** [16 — Evaluation execution](../16-evaluation-execution/README.md).

**Brief:** Sections 11, 13.4, 13.6, and 13.8.

## Assignment

Prepare a reproducible, preregistered evaluation that can distinguish bug
discovery, additional assurance, repair quality, reuse, and economic cost. This
phase freezes the experiment; it does not run the comparison and tune to results.

## Work

1. Select 20 target/contract pairs from at least five packages: ten development
   pairs and ten held out by package. Record immutable revisions, selection
   rules, license handling, inclusion/exclusion reasons, and full denominator.
   Keep held-out packages out of semantic/tactic/adapter tuning; if a single
   agent cannot avoid exposure, record contamination and replace the split.
2. Include supported real code, known-answer functions, recoverable historical
   vulnerable/fixed cases where compatible, and deliberate unsupported targets.
   Synthetic defects validate mechanisms; do not report them as newly found or
   historical vulnerabilities. Audit compatibility before using the ZIP advisory.
3. Accept/version contracts before runs, including useful behavior, rejection,
   termination/resource scope, and environment assumptions. Run a small timed
   unfamiliar-target policy review exercise with misleading inferred policies,
   reject-all traps, and precondition weakening; retain disagreements and minutes.
4. Freeze three arms: property-based/coverage-guided testing; LLM-assisted
   testing/repair; and the same discovery/testing pipeline plus checked proof
   search. Use the same initial examples, policies, source artifacts, and patch
   acceptance rules. Explain exactly what feedback each testing arm uses.
5. Predeclare multiple CPU/memory/elapsed/token budget levels, repeated stochastic
   runs/seeds, actual monetary-cost accounting, cold/warm runs, and separation
   of foundation/semantics cost from per-target work. Freeze shared semantics,
   tactics, adapters, checker policy, and package-held-out allocation.
6. Define metrics/artifact schemas: checked proof completion, reproduced bugs,
   disagreements, unsupported/unknown reasons, patch correctness, human effort,
   total compute/model/checker cost, lemma reuse, uncertainty, and maintenance
   after source/macro/configuration/dependency changes.
7. Preregister controls: wrong import, omitted error, hidden assumption, weakened
   policy, nonreturning patch, and reject-all. Continuation proposes no unresolved
   supported-subset disagreement, all controls refused as expected, and at least
   three held-out real functions from two packages proved with frozen semantics
   and no hand-edited imported program. Record review of these criteria before
   running, not after seeing results.

## Deliverables

`bench/` corpus manifests, accepted policy records, budget/seed/run matrix,
control corpus, reproducible harness commands, and a frozen evaluation protocol
with content hashes. Prepare and record authorization for actual live-run spend;
do not incur it merely to make a planning phase appear complete.

## Validation and handoff gate

- [ ] Counts, package-held-out separation, target identities, exclusions, and
  contract acceptance are auditable before comparison runs.
- [ ] All arms have equivalent starting examples/policies and patch gates;
  coverage guidance is real or the arm description is corrected before freeze.
- [ ] Multiple budgets/repetitions, uncertainty, cost/effort categories, controls,
  maintenance mutations, and continuation criteria are preregistered.
- [ ] Smoke runs use development fixtures only and validate artifact mechanics,
  not held-out efficacy. Schema checks reject missing denominator/results.
- [ ] Required live-run budget/authority is recorded for phase 16; absent
  authorization leaves execution pending with a concrete prepared run plan.
- [ ] `mix precommit` and development-fixture harness smoke checks pass.

Write `HANDOFF.md` with frozen hashes, split access rules, acceptance records,
exact run matrix, spend limits/authority, and any contamination or selection gaps.

## Boundary

Do not run held-out tuning, discard hard/unsupported cases, silently install
concolic tools with old OTP support, or interpret a 20-pair experiment as
ecosystem-scale qualification.
