# Phase 04 — Capture isolated builds and implementation provenance

**State:** Not started.

**Depends on:** Passed phases 01–03 and current prerequisite handoffs.

**Next:** [05 — Integrate Lynx reports, support, and conformance](../05-lynx-backend-adapter/README.md).

Read the [shared architecture](../ARCHITECTURE.md), [plan](../README.md), and
[backend/reference sources](../REFERENCES.md) with the prerequisite handoffs.

## Assignment

Automate phase 03's artifact preparation for an ordinary consumer without
changing Lynx's translation semantics. Bind what will be proved and replayed to
an identified controlled build, including every reachable dependency.

## Work

1. Resolve the consumer's source/generated inputs, lockfile, path/Git dependencies,
   external resources, compile-time configuration, `MIX_ENV`, `MIX_TARGET`, compiler
   options, and actual toolchain. Fetch authorized inputs before an offline build.
2. Run consumer compilation/macros in enforced isolated workspaces without host
   credentials, with time/memory/process/output bounds. Test denied network,
   writes to trusted inputs, child-process escape, and timeout cleanup. Record
   platform gaps rather than treating subprocess invocation as a sandbox.
3. Capture source and dependency contents, BEAM bytes, raw debug/compile chunks,
   source mapping, runtime/build configuration where relevant, and available
   reconstructed Core/translation output. Version immutable manifests and digests.
   Use existing Lynx outputs or a narrow pinned inspection bridge, not a new importer.
4. Preflight debug-info backends against an explicit allowlist for target, law,
   and dependency modules before callbacks execute. Bind backend/options/version
   and call Lynx only in the controlled workspace. Missing/malformed debug data,
   unexpected callbacks, unsupported reconstruction, and build errors are explicit.
5. Resolve the closure from captured artifacts and modeled operations, not host
   module availability. Ensure the selected module on the verification/replay
   code path matches recorded bytes; fail on ambiguity or substitution.
6. Compare two clean builds and classify nondeterminism/undeclared inputs.
   Initially require fresh capture after identity changes, with no cross-build
   proof reuse. Keep all identity normalizations nonsemantic and justified.

## Deliverables

Project capture/execution modules, versioned immutable manifests, ordinary
consumer driver, source mappings, isolation tests, and extraction/trust instructions.

## Validation and handoff gate

- [ ] Ordinary vulnerable/fixed consumers capture automatically, with actual
  target/dependency BEAMs, accepted-policy inputs, source maps, and versions bound.
- [ ] Changed source, macro input, config, path dependency, compiler option, debug
  backend, or target code path changes identity or refuses reuse.
- [ ] Stripped/malformed debug data, unknown backend, build timeout/failure, and
  module substitution are explicit non-success diagnostics; callbacks are gated.
- [ ] Isolation/limit enforcement and two-clean-build comparison have retained
  executable results; untracked build inputs prevent unsupported freshness claims.
- [ ] `mix precommit` and non-test consumer compilation pass; phase 03 proof still
  replays against the captured fixed artifact.

Write `HANDOFF.md` using the [template](../HANDOFF_TEMPLATE.md), with exact
identities, commands/logs, measured effort, and any unresolved gate items.
A failed or incomplete gate blocks dependent phases; never relabel reduced scope
as the original pass.

## Boundary

No alternate Core translator, universal debug-info authenticity claim, deployment
attestation, general build cache, or theorem from capture alone. A dev build
cannot silently certify a production build with different configuration.
