# Phase 08 — Formalize byte-aligned values and construction

**State:** Not started.

**Depends on:** Passed phase 07 gate and its separately recorded binary budget.

**Next:** [09 — Binary matching semantics](../09-binary-matching-semantics/README.md).

**Brief:** Sections 5.1, 7–9, 13.2, and 14; reference 34.

## Assignment

Extend the owned formal foundation with binary values, literals, and only the
construction operations actually emitted by the chosen byte validator. This
phase does not import or prove the binary interface yet.

## Work

1. Read the validator's captured operation inventory and upstream syntax,
   substitution, value, equality, and execution definitions. Specify exactly
   which byte-aligned segment forms/flags/sizes/units this phase supports.
2. Add first-class formal binary values and literals. An internal byte-list
   representation is permitted only with an explicit representation relation,
   byte-range invariant, and checked relation to imported binary operations.
   Do not substitute a list-taking program for the original function.
3. Define evaluation/construction behavior including empty values, concatenation,
   segment evaluation order, value/range/size restrictions, and exceptional
   behavior for the selected forms. Distinguish a well-defined runtime failure
   from syntax/operations deliberately outside the backend.
4. Prove representation, equality, length/decomposition, and construction lemmas
   needed by the later matcher. Update structural lemmas impacted by extending
   syntax/values, including substitution or well-formedness as applicable.
5. Repair and recheck relevant existing interpreter/semantic equivalence and
   preservation results without adding admissions, broad axioms, or unsafe
   settings. Record the exact extension revision and trust delta.
6. Add executable construction cases and small compiled BEAM probes for empty,
   boundary-byte, and invalid construction behavior. Freeze unsupported flags,
   arbitrary bitstrings, nonbyte sizes, signedness/endian/UTF forms explicitly.

## Deliverables

Owned binary value/construction semantics under `proof/`, checked foundational
lemmas, operation support table, construction probes, and an extension report.
Keep upstream source/license boundaries intact; use maintained owned changes.

## Validation and handoff gate

- [ ] Every selected construction form has a precise formal rule and byte
  representation relation; empty and short values are covered.
- [ ] Unsupported bit syntax is explicitly rejected/classified, not interpreted
  using an accidental general-purpose list operation.
- [ ] New lemmas and the affected old proof closure check under the pinned policy.
- [ ] The phase 07 helper theorem independently rechecks with the extension.
- [ ] Selected executable construction outcomes agree with captured BEAM probes;
  disagreements block matching/import claims until resolved.
- [ ] No new unauthorized axioms/admissions/unsafe checking flags; trust and
  budget changes are recorded; `mix precommit` passes.

Write `HANDOFF.md` with formal constructors/rules, representation invariants,
checked dependencies, exact segment support, probes, and remaining matching work.

## Boundary

Do not implement all OTP bit syntax, Unicode, a binary importer, or the full
validator proof. If the extension disrupts the foundation beyond its budget,
report the concrete cost/blocker at the binary gate instead of weakening it.
