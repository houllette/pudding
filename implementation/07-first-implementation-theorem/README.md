# Phase 07 — Prove the imported helper and decide feasibility

**State:** Not started.

**Depends on:** Passed phases 01–06 and an accepted nonbinary contract.

**Next:** [08 — Binary values and construction](../08-binary-values-and-construction/README.md), only after this gate passes.

**Brief:** Sections 6–9, 13.1, 13.3, 13.5–13.6, and 14.

## Assignment

Produce one nontrivial checked contract about the exact automatically imported
nonbinary helper, then publish the first go/no-go decision. This closes the
brief's import-and-first-proof experiment.

## Work

1. Rebuild/capture the ordinary fixture through the adapter, import it without
   manual term edits, and regenerate its expected theorem from the accepted
   contract. Reconfirm conformance on the retained corpus.
2. Prove useful output safety/exact preservation, positive acceptance, expected
   rejection/error behavior, and totality to the extent required by the frozen
   helper contract. Quantify over its full declared domain, not fixed examples.
   Link any proof-friendly helper definition to imported execution by a checked
   refinement/equivalence result.
3. Use ordinary computation/tactics/induction and reusable lemmas first. Record
   semantic, adapter, theorem, and manual preparation effort separately. Do not
   add a solver or proof worker to avoid understanding the initial obligations.
4. Package exact program, contract, proof source/objects, theorem statement,
   build provenance, assumptions, checker receipt, negative-control results,
   and independent replay instructions. Rebuild/recheck from a clean environment.
5. Exercise implementation and contract mutations: old proof binding must fail
   for a changed program/policy. Rerun importer and checker adversarial controls.
6. Account for cumulative phases 01–07 effort against the proposed ten focused
   engineer-days. Publish `docs/verification/nonbinary-gate.md` with pass/no-go,
   actual blockers, trust left in place, and measured cost. On failure compare
   earlier Core capture/smaller subset alternatives with concrete estimates;
   do not silently switch to BEAM or native semantics.

## Deliverables

The first independently replayable implementation evidence bundle; reusable
nonbinary lemmas; a gate report; and, on pass, a separately scoped/budgeted binary
experiment based on actual emitted operations from the selected validator.

## Validation and handoff gate

- [ ] The theorem is nontrivial and bound to the exact imported helper, with
  universal obligations over its accepted domain and useful positive behavior.
- [ ] An independent clean run regenerates the expected statement, audits all
  assumptions, and rechecks the proof and dependency closure.
- [ ] There are no unresolved conformance disagreements for the supported helper.
- [ ] Wrong importer/checker controls are refused at their documented detection
  points; changed implementation/contract identities cannot reuse the receipt.
- [ ] The gate report includes total effort, manual work, failed attempts, trusted
  code/semantics, resource exclusions, and the go/no-go rationale.
- [ ] A separate phases 08–11 budget/scope is recorded before starting binaries.
- [ ] `mix precommit` and non-test consumer compilation pass.

Write `HANDOFF.md` linking the bundle and decision. If any required theorem or
independent check is absent, resume this phase or stop for the recorded scope
decision; do not advance to binary semantics or orchestrator work.

## Boundary

This is an infrastructure milestone. It proves neither the binary path
interface nor practical security efficacy, automated repair, or compiler/VM
correctness. A finite evaluator trace is not the required universal theorem.
