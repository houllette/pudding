# Phase 10 — Import and cross-test the real binary validator

**State:** Not started.

**Depends on:** Passed phases 08–09 plus the capture/import/checker foundations.

**Next:** [11 — Validator theorems](../11-validator-theorems/README.md).

**Brief:** Sections 5.2, 7–9, 11, 13.2, and 13.9.

## Assignment

Automatically import the vulnerable and fixed binary fixtures using the exact
new byte semantics and demonstrate tested agreement with their real BEAM
artifacts, including the nonbinary wrapper where supported.

## Work

1. Recapture both fixtures from the ordinary Mix project and inventory their
   full reachable closures. Resolve the exact operations in emitted `binary`
   and `bitstr` nodes, plus failure paths and compiler-generated calls.
2. Extend deterministic import only for phase 08–09 supported forms. Preserve
   evaluation order, sizes/units/flags, pattern binding, errors, and guard
   semantics. Reject unknown nodes/domains rather than encoding bytes as an
   unrelated list-taking implementation.
3. Bind the binary extension/model/support-policy versions into imported terms
   and manifests. Regenerate expected theorem inputs through trusted preparation;
   do not hand-edit imported output for a proof-friendly shape.
4. Extend paired execution and shrinking to raw binaries, structured valid
   inputs, malformed boundary cases, invalid UTF-8, NUL, repeated separators,
   backslash, colon, and short values. Include wrapper tests over its declared
   nonbinary domain, especially nonbyte bitstrings.
5. Retain/minimize discrepancies and run binary-specific wrong-byte, wrong-size,
   binding, and omitted-failure mutation controls. Reapply mismatch quarantine
   to all evidence depending on the changed importer/semantics.
6. Freeze the supported operation inventory and record any newly required
   semantics as a return to phase 08/09, with budget/gate updates. Do not bury
   semantic expansion inside an importer patch.

## Deliverables

Binary import adapter, complete vulnerable/fixed capture/import bundles,
seeded paired-execution corpus, updated support matrix, and replay commands.

## Validation and handoff gate

- [ ] Both fixtures are automatically captured/imported without manual program
  edits and every reachable operation is accounted for.
- [ ] Normal/error/exception outcomes agree on the selected conformance corpus;
  the vulnerable fixture concretely accepts `..` and the fixed reference rejects it.
- [ ] Valid arbitrary bytes, backslash, colon, exact output components, and strict
  empty/separator/NUL cases are exercised against the frozen oracle.
- [ ] Wrapper behavior and unsupported bit syntax remain distinct from the
  binary theorem's input domain.
- [ ] Injected import faults are detected at documented controls; fuel exhaustion
  and mismatches cannot appear as proved/reproduced violations without replay.
- [ ] `mix precommit`, affected formal proof rechecks, and non-test compilation pass.

Write `HANDOFF.md` with exact artifacts/model IDs, binary support inventory,
corpus/seeds, known exclusions, and the theorem inputs phase 11 will consume.

## Boundary

This gate establishes empirical conformance for selected executions. It is not
the binary feasibility pass, a totality proof, or evidence that an archive
extractor is safe. Phase 11 owns the universal contract.
