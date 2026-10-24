# Phase 11 — Prove the validator contract and decide binary feasibility

**State:** Not started.

**Depends on:** Passed phases 08–10, phase 06 checker, frozen phase 02 policy.

**Next:** [12 — Discovery and counterexamples](../12-discovery-and-counterexamples/README.md), only after this gate passes.

**Brief:** Sections 4, 7–9, 13.5, and 14.

## Assignment

Prove safety, exact useful acceptance, rejection, and totality for the imported
fixed reference validator. Publish a separate go/no-go decision about the
affordability of the byte semantics and security target.

## Work

1. Reconfirm accepted policy/oracle identities and connect executable oracle to
   formal predicates by the planned shared definition or checked equivalence.
   Disclose any remaining trusted specification translation explicitly.
2. Prove the safety statement over imported evaluation: a returned `Ok(cs)`
   implies `valid(b)` and `cs = split_slash(b)` for every binary input.
3. Prove total functional correctness: every finite binary terminates with
   `Ok(split_slash(b))` exactly when valid, and otherwise
   `Error(invalid_path)`. Exclude unexpected exceptions and stuck states.
   Base recursive induction on decreasing remaining bytes/component count;
   interpreter fuel is not a universal termination argument.
4. Prove the nonbinary `not_binary` wrapper obligation separately over its
   declared caller domain. Do not infer it from the binary-only theorem.
5. Check the exact regenerated statements through phase 06, audit assumptions,
   and independently recheck their dependency closure. Retain reusable parser,
   component, acceptance, and termination lemmas with their actual premises.
6. Test reject-all, input-substitution, hidden-precondition, and nonreturning
   variants: none may acquire the full original contract receipt. Keep the
   vulnerable original and its concrete `..` witness separate from fixed proofs.
7. Publish `docs/verification/binary-gate.md` with operation coverage, clean
   replay evidence, trust delta, actual phases 08–11 cost versus its budget,
   failed approaches, and pass/no-go. Record manual reference preparation;
   this phase is not the automated repair experiment.

## Deliverables

Fixed-reference proof bundle, separate binary/wrapper statements and receipts,
reusable byte lemmas, negative controls, and the binary feasibility decision.

## Validation and handoff gate

- [ ] Safety, exact acceptance/rejection, no unexpected exceptions/stuck states,
  and totality check over the full stated binary domain.
- [ ] Wrapper claim checks separately; every claim shows quantified domain,
  idealized memory/runtime exclusions, and conditional premises.
- [ ] Independent clean replay binds the current fixed implementation to the
  exact theorem and rechecks all dependencies/assumptions.
- [ ] Reject-all, substitution, nonreturning, and weakened-statement controls
  receive no full-contract proved result.
- [ ] No unresolved supported-subset conformance disagreement remains.
- [ ] Budget/effort and the explicit binary go/no-go decision are recorded;
  `mix precommit` and non-test consumer compilation pass.

Write `HANDOFF.md` with each theorem/receipt, reusable lemmas, exact replay,
manual work, and the gate decision. Missing acceptance or termination is a failed
gate, even if a safety-only theorem checks. Stop downstream assurance work.

## Boundary

No safe-extraction, filesystem/symlink, Windows-path, compiler/runtime, or real
resource-bound claim. This is a conditional formal contract for the validator.
