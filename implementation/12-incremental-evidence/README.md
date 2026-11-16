# Phase 12 — Add conservative evidence reuse and invalidation

**State:** Not started.

**Depends on:** Passed phases 01–11 and current prerequisite handoffs.

**Next:** [13 — Qualify the consumer and required-claim CI workflow](../13-mix-and-ci-product/README.md).

Read the [shared architecture](../ARCHITECTURE.md), [plan](../README.md), and
[backend/reference sources](../REFERENCES.md) with the prerequisite handoffs.

## Assignment

Only after the evaluation gate, add content-addressed reuse without weakening
claim identity or freshness. Separate build dependence, proof dependence, and
trusted checker authority; Lynx's local verification cache is not a receipt.

## Work

1. Model distinct nodes for source/generated inputs, compile environment/resources,
   dependency contents, BEAM/debug/Core/translation, accepted policy/law inventory,
   proof/helpers/imports, Lynx/runtime/toolchain, checker/isolation policy, conformance,
   exports, and receipts. Record exact bytes and transitive external Lean imports.
2. Start with conservative module-level build invalidation, including macros,
   compile-time config, path/Git dependencies, compiler/toolchain/options, and
   runtime configuration where relevant. Unknown inputs or nondeterminism refuse
   cross-build reuse. Do not substitute a source-MFA call graph for Mix recompilation.
3. Reuse a mathematical proof for a changed build only under a reviewed, explicitly
   validated artifact-equivalence binding. Otherwise recapture/retranslate/recheck.
   A newly changed contract or assumption set always changes the claim. Rechecking
   an old export proves only the old bound statement.
4. Keep trusted immutable receipt storage separate from worker scratch, compiler
   caches, and normal Lynx caches. Treat result JSON/cache keys and compiled files
   as untrusted unless protected/validated by the configured authority. Test cache
   poisoning and transitive-import changes outside Lynx's normal fingerprint.
5. Track conformance quarantine and current versus historical evidence. A mismatch,
   backend/model fix, checker-policy change, revocation, or tampered object invalidates
   all affected current assurance. Preserve old bundles for honest historical replay.
6. Run a mutation matrix over source, macro/generated/resource bytes, config,
   compiler options, lock/path dependency, debug backend, policy/predicate/domain,
   law inventory, proof import, Lynx/runtime/toolchain, checker, conformance, and
   missing cache objects. Measure cold/warm correctness and cost, not just hit rate.

## Deliverables

Versioned build/proof evidence graph, conservative invalidation/reuse engine,
protected receipt boundary, mutation suite, and warm/cold measurements.

## Validation and handoff gate

- [ ] Every mutation changes or invalidates the correct dependency closure or explicitly
  refuses reuse; old receipts never certify new unidentified builds/contracts.
- [ ] Worker-controlled caches, success JSON, replaced compiled modules, missing
  objects, and untracked proof imports cannot authorize proved.
- [ ] Quarantine/revocation invalidates dependent current claims while immutable old
  bundles remain replayable as historical statements.
- [ ] Warm reuse and cold clean verification agree on claims/assumptions/freshness;
  costs and conservative over-invalidation are measured.
- [ ] `mix precommit`, consumer mutation tests, and offline replay pass.

Write `HANDOFF.md` using the [template](../HANDOFF_TEMPLATE.md), with exact
identities, commands/logs, measured effort, and any unresolved gate items.
A failed or incomplete gate blocks dependent phases; never relabel reduced scope
as the original pass.

## Boundary

No fine-grained function cache, distributed scheduler, source-hash-only freshness,
or silent reliance on Lynx cache keys as authenticated evidence. Optimize only
after correctness is demonstrated on the mutation matrix.
