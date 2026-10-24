# Phase 05 — Cross-test imported execution against BEAM

**State:** Not started.

**Depends on:** Passed phases 01–04.

**Next:** [06 — Independent checker](../06-independent-checker/README.md).

**Brief:** Sections 5.3, 6–7, 9, 11, 13.2–13.3, and 13.9; reference 18.

## Assignment

Connect the imported syntax to HARP's executable semantics and compare it with
the real captured BEAM implementation. Produce a mismatch-finding harness,
not a universal compiler/import equivalence claim.

## Work

1. Expose execution of the exact phase 04 imported program through the audited
   interpreter. Record the relation/equivalence results connecting executable
   steps to formal semantics and their premises. Any extracted host interpreter
   is cross-testing machinery, not the independent proof checker.
2. Define comparison encodings for normal values and target exceptions; retain
   relevant exception reason/class and modeled trace. Keep expected errors,
   raised exceptions, guard/match failure, stuck states, and exhausted fuel
   distinguishable. Fuel exhaustion is unknown, never termination or rejection.
3. Execute the identified BEAM artifact in an isolated bounded runner. Compare
   normal and exceptional results using retained deterministic seeds/cases.
   Cover malformed/improper lists, recursive boundaries, signed integer
   division/remainder where supported, failed guards, and error propagation.
4. Generate and shrink cases within supported domains using existing facilities
   or standard-library helpers. If a new testing dependency is necessary,
   prepare the concrete rationale and obtain the approval AGENTS.md requires.
5. When outcomes disagree, retain both artifacts/inputs/results/traces, minimize
   the case, and quarantine affected assurance. Known support gaps become
   unsupported; undiagnosed disagreement remains unknown. A policy violation
   still requires independent BEAM replay.
6. Run the wrong-literal, binding, and omitted-error-branch mutation controls
   from phase 04. Record detection coverage and honest blind spots; do not
   assert a finite suite detects every possible wrong importer.

## Deliverables

Executable-model bridge, BEAM runner, differential case corpus, mismatch bundle
format, and `docs/verification/conformance.md` with seeded replay commands.

## Validation and handoff gate

- [ ] All selected normal and exceptional supported-subset cases agree; every
  disagreement is resolved before a supported assurance claim advances.
- [ ] Injected wrong literal/binding/error branch produces a retained disagreement
  or fails a justified earlier check; the detection mechanism is identified.
- [ ] A modeled failure does not become a concrete violation without real replay.
- [ ] Fuel exhaustion, BEAM timeout, malformed output, and model stuck state
  remain explicit non-success results.
- [ ] Mismatch quarantine demonstrably prevents affected evidence appearing as
  current implementation assurance.
- [ ] `mix precommit`, proof-interpreter build, and non-test compilation pass.

Write `HANDOFF.md` with model and runtime artifact IDs, comparison rules,
conformance corpus/seeds, mutation results, mismatch handling, and tested bounds.

## Boundary

Passing cross-tests cannot justify calling the importer verified or deleting
its trust entry. Do not broaden support to hide a disagreement, ignore target
exceptions, or count a finite search limit as an induction argument.
