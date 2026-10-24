# Phase 03 — Capture an ordinary build and reconstruct Core

**State:** Not started.

**Depends on:** Passed phases 01–02.

**Next:** [04 — Nonbinary importer](../04-nonbinary-importer/README.md).

**Brief:** Sections 5.2, 6–8, 10, 13.7, and 14; references 14–15, 23–25, 32.

## Assignment

Build the smallest project adapter that discovers compiled fixture targets and
captures their actual BEAM/debug/Core artifacts in a controlled build. Establish
implementation provenance before adding proof import or a polished CLI.

## Work

1. Resolve the consumer's Mix project, build environment/target, lockfile,
   source/generated inputs, dependencies, compiler configuration, and module
   entry points. Use the repository's pinned toolchain; record actual versions.
2. Run compilation/macros and target inspection in an enforced isolated workspace
   without unrelated credentials. Fetch declared inputs first and build without
   network. Bound time, memory, and output; retain failures separately from
   exceptions raised by the target. Document enforcement and platform gaps.
3. Capture source/build configuration, dependency contents (including path/Git
   dependencies), BEAM bytes, debug chunk, compile options, and source mappings.
   Introduce versioned immutable manifests and artifact digests. Be conservative
   about undeclared compile-time inputs; no cross-build cache reuse yet.
4. Read debug info through `:beam_lib.chunks/2`, validate the recorded backend
   against an explicit allowlist, then request `:core_v1`. Treat callback failure,
   missing info, unexpected format/backend, or malformed artifacts explicitly.
   Do not invoke arbitrary recorded modules or generate atoms from user text.
5. Preserve canonical captured Core plus raw reconstruction artifacts and relevant
   annotations. Bind backend/options/toolchain and mapping identities. Label
   reconstruction trusted, not the original compiler intermediate.
6. Provide a scripted ordinary-project driver that enumerates candidates, selects
   a target, and emits a capture bundle without manual transcription. Fresh
   capture is required after source/contract changes; identity mismatch refuses
   reassignment of old evidence. Phase 17 adds reusable caching later.

## Deliverables

Project/extraction modules, capture manifests, minimal fixture driver, and
`docs/verification/extraction.md` with isolation/rebuild instructions. Reconcile
the proposed paths in shared architecture with the interfaces actually created.

## Validation and handoff gate

- [ ] An ordinary Mix fixture produces automatic captures for both list and binary
  targets; reports distinguish the byte artifacts' existence from support.
- [ ] Two controlled clean builds are compared. Nondeterminism is explained and
  prevents unsafe reuse; normalizations never erase semantic information.
- [ ] Missing/stripped debug info, disallowed backend, malformed chunk, compile
  timeout, and extraction failure yield explicit non-success diagnostics.
- [ ] Source, option/config, and contract mutations alter the appropriate binding
  or refuse stale use. The result links to BEAM/Core/toolchain identities.
- [ ] Source mappings remain available for later counterexamples and patches.
- [ ] Isolation and resource limits have an executable check, not just prose.
- [ ] `mix precommit` and non-test library/consumer compilation pass.

Write `HANDOFF.md` with the capture schema, exact fixture command, durable
artifacts, toolchain identity, build-input gaps, and all newly trusted code.

## Boundary

No proof, general dependency cache, AST-based substitute implementation, or
assumption that all reconstructible Core is supported. Do not infer production
claims from a capture made under a different Mix environment/configuration.
