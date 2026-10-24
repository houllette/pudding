# Phase 13 — Add bounded untrusted proof search

**State:** Not started.

**Depends on:** Passed phases 06–12 and their immutable trust/contract interfaces.

**Next:** [14 — Guarded repair loop](../14-guarded-repair-loop/README.md).

**Brief:** Sections 6, 10–11, 13.5–13.6; references 19–22 and 31.

## Assignment

Add a bounded worker interface for proof proposals, using reusable checked
lemmas before model assistance. Only phase 06's independent checker may turn a
submission into a proved result.

## Work

1. Define a proof job from immutable implementation, accepted contract, model,
   expected obligations, allowed lemmas, and assumption policy. Specify artifact
   and permission boundaries, attempt/time/token/CPU/memory limits, cancellation,
   and result states. Preserve useful failed/partial work with its identity.
2. Run deterministic tactics/reuse first. Let an optional model adapter propose
   invariants, lemmas, or scripts into a worker-owned area. A deterministic fake
   adapter should make integration/permission tests reproducible.
3. Pass submitted source through exact-theorem checking; regenerate the expected
   statement from trusted inputs each time. Block changes to contracts, imported
   programs, semantics, checker policy/scripts, and trusted dependencies at the
   actual filesystem/process boundary, not only in a prompt.
4. Retain every attempt, budgets/actual consumption, checker errors, scripts,
   assumption summaries, and reusable-lemma provenance. Any new premise or
   assumption remains a proposal and cannot make a missing proof succeed.
5. Exercise ordinary tactics and the validator/list theorem families. Measure
   which goals actually need assistance. Do not add SMTCoq or solver services
   unless repeated need, theory/encoding correctness, exact version compatibility,
   and accepted certificates have their own justified scoped decision.
6. Prepare a bounded live-run configuration if model assistance is required for
   the next demonstration. Reuse existing authorization if applicable; otherwise
   obtain concrete provider/budget authorization before any paid requests. Offline
   adapter tests establish mechanics, not model efficacy.

## Deliverables

Proof-worker interface/runner, deterministic test adapter, optional model adapter,
permission/budget enforcement, and attempt/economics records under proposed worker
and evidence modules. Avoid a long-lived worker fleet.

## Validation and handoff gate

- [ ] A valid proposed proof reaches the independent checker and receives only
  the receipt for the exact current statement.
- [ ] Worker attempts to replace trusted inputs, weaken a contract, add axioms,
  run unauthorized plugins, or forge success are refused by enforcement/checking.
- [ ] Timeout, cancellation, unavailable model, malformed output, and exhausted
  budgets terminate cleanly as unknown with retained partial artifacts.
- [ ] Lemma reuse preserves transitive assumptions and implementation/model IDs.
- [ ] Deterministic tests distinguish mechanics from any separately authorized
  live-run results; cost/manual intervention are explicit.
- [ ] `mix precommit`, affected checker/proof rechecks, and non-test use pass.

Write `HANDOFF.md` with job schema, enforced boundaries, adapters, exact budget
settings, attempts/receipts, authorization scope, and any unassessed live efficacy.

## Boundary

No source repair or policy/semantics changes by the worker. Do not equate
generated scripts, solver `unsat`, a convincing explanation, or a successful
fake-adapter test with a checked implementation proof or autonomous efficacy.
