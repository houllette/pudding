# Phase 04 — Inventory support and import the nonbinary subset

**State:** Not started.

**Depends on:** Passed phases 01–03 and their immutable contracts/captures.

**Next:** [05 — Execution conformance](../05-execution-conformance/README.md).

**Brief:** Sections 5.1, 6–7, 9, 13.1–13.3, and 14.

## Assignment

Implement a deterministic closed-world mapping from captured Core into HARP
syntax for the selected nonbinary helper. The result is the actual program as
syntax, with explicit rejections for unsupported code.

## Work

1. Inventory emitted Core from 10–20 small real compiled functions, including
   the chosen fixtures and representative guard/failure paths. This is a
   compatibility sample, not a commitment to prove all sampled functions.
   Record every reachable tag, annotations relevant to meaning, BIF/primop/MFA,
   argument restrictions, error behavior, semantic rule, and validation case.
2. Compute a conservative reachable closure from each target. Resolve local
   recursion and static cross-module calls. Bind imported bodies or reviewed
   summaries to implementation identity; unresolved/dynamic calls block support.
3. Implement only the nonbinary subset necessary for the useful helper. Preserve
   binding/scope, arity, constructors/literals, evaluation order, recursive
   definitions, cases, guards, exceptions, and compiler-generated failure paths.
   No skipped branches or optimistic defaults.
4. Explicitly allowlist BIFs/primops by semantics and domain. Reject operations
   absent from the model before upstream's `BNothing` fallback can manufacture
   an `undef`. Distinguish a real modeled `undef` from unsupported calls.
5. Serialize formal syntax as safe data with validated names/encodings. Atoms or
   strings containing Rocq tokens cannot inject commands. Hash imported terms,
   importer version, support policy, and source mapping into the capture bundle.
6. Add structural mutation controls for wrong literals, renamed/captured
   bindings, omitted failure branches, wrong arities, and unmodeled calls.
   Identify which checks detect malformed syntax and which semantic faults
   require phase 05; hashing cannot establish translation correctness.

## Deliverables

Support matrix and inventory under `docs/verification/`, import/support-analysis
modules, generated formal-term fixtures, and deterministic capture-to-import
commands. The importer remains an explicit trusted component.

## Validation and handoff gate

- [ ] Every operation in the chosen helper's reachable closure is modeled or
  bound to an explicit accepted conditional contract; no unexplained fallback.
- [ ] Same captured input/config gives identical imported syntax/digests.
- [ ] Binary nodes, unaudited maps, effects, unresolved dispatch, unsupported
  BIF/primop domains, and invalid scope/arity produce exact unsupported reasons.
- [ ] Bindings, nested cases, recursion, improper lists, guard failure, match
  failure, and exceptional branches have meaningful import regression tests.
- [ ] Data containing adversarial atom/name text cannot become Rocq code.
- [ ] Structural negative controls run; semantic mutation controls are retained
  with expected detection points in phases 05–07.
- [ ] `mix precommit`, formal syntax compilation, and non-test compilation pass.

Write `HANDOFF.md` with supported node/call inventory, all rejected sampled
functions, imported helper identity, interfaces, and remaining importer trust.

## Boundary

Do not claim semantic fidelity from parser acceptance, hand-edit generated
programs, encode binary targets as unrelated lists, or add broad library
semantics to improve the sampled support count.
