# Phase 09 — Formalize byte matching and failure semantics

**State:** Not started.

**Depends on:** Passed phase 08 and the phase 07 binary scope/budget.

**Next:** [10 — Binary import and conformance](../10-binary-import-and-conformance/README.md).

**Brief:** Sections 7–9, 13.2, and 14; references 11–12, 17, and 34.

## Assignment

Add exact matching and associated guard/error semantics for the chosen
byte-recursive validator. Preserve the connection between relational execution
and the executable interpreter before extending the importer.

## Work

1. Map each emitted binary pattern/segment, guard, and required BIF/primop to a
   precise supported rule using the pinned OTP behavior. Reuse audited rules
   where adequate; record version/domain/error restrictions for new ones.
2. Model empty/short input, byte extraction, remaining-tail binding, segment
   sizes/units/alignment, ordered pattern alternatives, and pattern failure.
   Keep failed matches, guard failure, raised exceptions, and propagation
   distinct. An unsupported operation must never become a successful no-match.
3. Extend executable steps to correspond to the new relational rules. Prove the
   affected equivalence, well-formedness, preservation, and determinism facts
   actually used downstream, stating premises rather than inventing guarantees.
4. Prove byte-decomposition, remaining-input-length, and recursive-progress
   lemmas sufficient to support later totality. Do not claim totality merely
   because a step function has finite fuel.
5. Add rule-level compiled probes for selected matching/guard/error cases,
   including nonbyte bitstrings and unsupported segment flags. Define the
   boundary between target runtime errors and unsupported model constructs.
6. Recheck old nonbinary and construction results and update the support/trust
   manifests. No downstream proof may keep a receipt for the old semantic model
   while claiming to use the new one.

## Deliverables

Matching/failure rules and lemmas under `proof/`, executable counterpart,
rule-level probes, and a versioned byte-semantics support matrix. The phase 10
importer must consume this exact matrix rather than accepting syntax broadly.

## Validation and handoff gate

- [ ] Selected empty/short/boundary-byte matches, fallthrough, guards, and failures
  agree with pinned BEAM probes.
- [ ] Nonbyte/signed/endian/UTF or otherwise unsupported segments are refused
  explicitly; no unknown rule or call reaches a default `undef`/harmless value.
- [ ] Relevant step/interpreter correspondence and structural/preservation
  obligations check without unauthorized assumptions or skipped cases.
- [ ] Progress/length lemmas are checked and available for validator induction.
- [ ] Prior nonbinary/construction proof closures recheck under the new model.
- [ ] Actual semantic-development effort remains visible against the separate
  binary budget; `mix precommit` passes.

Write `HANDOFF.md` with the exact rule inventory, rule-level conformance cases,
checked lemmas, new BIF trust, and any operation still blocking the real target.

## Boundary

No full binary-target import, universal validator theorem, stateful effects, or
practical resource guarantee. Do not drop a failure branch to make preservation
proofs easier or generalize support beyond the rules actually checked.
