# Phase 17 — Add conservative incremental evidence reuse

**State:** Not started.

**Depends on:** Phase 16 continuation decision permitting this scope, plus passed
build/checker/result foundations.

**Next:** [18 — Mix and CI product](../18-mix-and-ci-product/README.md).

**Brief:** Sections 3, 10–11, 13.7, and 13.9; references 23–25.

## Assignment

Replace exact-bundle-only handling with a content-addressed dependency graph
that safely reuses current evidence and invalidates every affected claim when
build, contracts, semantics, or checking policy changes.

## Work

1. Model distinct build nodes and proof nodes using earlier immutable manifests.
   Capture source/generated files, `mix.lock`, path/Git dependency contents,
   Elixir/OTP/options, `MIX_ENV`, `MIX_TARGET`, compile-time configuration, macros,
   external resources, BEAM/debug/Core/imported artifacts, and support policy.
2. Link proof nodes to accepted contract/version/acceptance identity, semantic
   definitions, BIF summaries, lemmas and assumptions, checker image/configuration,
   and policy. Include runtime configuration wherever it affects a permitted
   claim. Store exact theorems, proofs, violations, regression cases, and patches.
3. Begin at module granularity. Propagate changes through runtime callees,
   summaries, import/semantic dependencies, and all dependent proofs even when
   caller bytes are unchanged. Do not invent function-level linking guarantees.
4. Use tracers/compile-env/external-resource data as dependency evidence, not a
   complete boundary on arbitrary compile-time file/env/clock/network reads.
   Require isolated clean builds and declared inputs for cross-build reuse;
   disable reuse when capture is incomplete or nondeterministic.
5. Distinguish offline rechecking of an old bundle from current-build binding.
   Validate any newly assigned binding; refuse stale/missing/tampered receipts.
   Keep source mappings separate from semantics-preserving identity decisions.
6. Persist mismatch quarantine and freshness through the graph. A newly found
   semantic disagreement removes implementation assurance for all affected
   descendants, while retaining the old mathematical theorem and separately
   replayed violations with their proper identities.

## Deliverables

Evidence graph/store, conservative lookup/invalidation API, graph inspection,
quarantine propagation, migration/replay of earlier bundles, and a mutation suite.

## Validation and handoff gate

- [ ] Changing source, macro provider, compile-time setting, external/generated
  file, compiler option/toolchain, or Mix environment/target invalidates the
  appropriate current claim.
- [ ] Changing a path dependency without a version bump, runtime callee, BIF
  summary, semantic model, lemma, accepted contract, assumption allowlist, or
  checker configuration invalidates dependent proofs.
- [ ] Unchanged controlled inputs permit demonstrated reuse, while unknown inputs
  and nondeterministic rebuilds disable it; all artifacts still have digests.
- [ ] Old-bundle replay cannot certify a changed build; tampered/missing nodes
  fail closed and mismatch quarantine propagates to every affected descendant.
- [ ] Normalization/source-map handling never erases semantic differences, and
  independent receipt replay remains possible after cache/store restoration.
- [ ] `mix precommit`, targeted mutation tests, and non-test consumer use pass.

Write `HANDOFF.md` with graph/schema/version rules, mutation results, reuse
demonstrations, current-build binding commands, trust gaps, and recovery steps.

## Boundary

No line-count security percentage, source-hash-only cache, dependency-version-only
identity, fine-grained function reuse without checked linking, or hidden runtime
configuration assumption. Do not use cache hits to hide missing original evidence.
