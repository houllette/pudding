# Phase 11 — Execute the comparison and decide continuation

**State:** Not started.

**Depends on:** Passed phases 01–10 and current prerequisite handoffs.

**Next:** [12 — Add conservative evidence reuse and invalidation](../12-incremental-evidence/README.md).

Read the [shared architecture](../ARCHITECTURE.md), [plan](../README.md), and
[backend/reference sources](../REFERENCES.md) with the prerequisite handoffs.

## Assignment

Run the frozen comparison, independently validate evidence, and report what it
supports. Finishing an experiment can legitimately produce no-go or a limited
scope decision; it does not automatically qualify the product.

## Work

1. Verify corpus/policy, build, Lynx/toolchain, lemmas/tactics, adapter, checker,
   and protocol identities before each scheduled run. Execute all planned arms,
   repetitions, and budget levels; retain seeds, failures, exclusions, resources,
   actual cost, manual intervention, and explicit missing runs.
2. Preserve package-held-out separation. Any new backend feature, library model,
   target preparation, lemma, or adapter change is adaptation and a protocol
   deviation, not zero-touch held-out reuse. Never hand-edit translated programs.
3. Independently replay all reported violations on identified uninstrumented BEAM
   and recheck every reported proof through the exact-contract checker. Quarantine
   supported-subset disagreements; no receipt or independent-check completion means
   no proved result. Apply identical behavioral patch gates in all arms;
   testing-only patches need not obtain proofs and cannot be called universally
   correct. Measure independent proof assurance separately from behavioral acceptance.
4. Run frozen controls and maintenance mutations. Measure preparation, contract
   review, per-target proof/repair work, failures, checker/infrastructure cost, and
   warm/cold behavior separately. Reuse here is experimental measurement, not
   qualification of the cross-build evidence cache deferred to phase 12.
5. Aggregate with the complete denominator and uncertainty. Distinguish newly
   found bugs, known/synthetic reproductions, additional universal assurance,
   conditional assumptions, unsupported code, and unknown attempts.
6. Publish retained results and `docs/verification/evaluation.md` with deviations,
   contamination, economic limits, and an explicit continuation decision against
   phase 10 criteria. A no-go requires owner-reviewed scope/next-experiment choice
   before incremental/product qualification, not silent threshold reduction.

## Deliverables

Per-run replayable bundles, structured/aggregate results, intervention/expense
ledger, deviation report, reaggregation commands, and continuation decision.

## Validation and handoff gate

- [ ] Every scheduled pair/arm/run has evidence or a retained missing/failed result
  with reason, budget, and unchanged denominator.
- [ ] All reported proofs and violations independently replay; patched artifacts
  meet identical behavioral policy/regression gates across arms. Tested-only
  patch acceptance and independently checked assurance remain distinct outcomes.
- [ ] Controls and maintenance cases have expected/actual outcomes; unresolved
  disagreements do not contribute current assurance.
- [ ] Held-out adaptation, preparation, human effort, failures, checker cost, actual
  spend, uncertainty, and protocol deviations remain visible.
- [ ] Written continuation criteria are evaluated, with authorized next scope;
  `mix precommit` and result/reaggregation consistency checks pass.

Write `HANDOFF.md` using the [template](../HANDOFF_TEMPLATE.md), with exact
identities, commands/logs, measured effort, and any unresolved gate items.
A failed or incomplete gate blocks dependent phases; never relabel reduced scope
as the original pass.

## Boundary

Do not select only successful targets, revise criteria after results, conflate
universal assurance with new bug discovery, or describe measured local costs as
universal economic superiority. Unfavorable results remain reviewable.
