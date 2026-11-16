# Phase 07 — Discover candidates and replay concrete violations

**State:** Not started.

**Depends on:** Passed phases 01–06 and current prerequisite handoffs.

**Next:** [08 — Constrain untrusted proof search](../08-bounded-proof-worker/README.md).

Read the [shared architecture](../ARCHITECTURE.md), [plan](../README.md), and
[backend/reference sources](../REFERENCES.md) with the prerequisite handoffs.

## Assignment

Expose the first minimal Mix workflow for ordinary consumers: explicit candidate
selection, accepted-policy lookup, bounded counterexample search, independent
BEAM replay, and existing proof/checker invocation. Discovery proposes; it does
not accept contracts or manufacture evidence.

## Work

1. Enumerate compiled candidates and source mappings from the controlled capture.
   Use structural/security heuristics conservatively. Rank suggested target/policy
   pairs, but keep unaccepted policy proposals outside the required claim set.
2. Add `mix pudding.verify` with explicit project/target/accepted-policy selection,
   resource limits, artifact location, and structured diagnostics. Reuse capture,
   adapter, and checker; no daemon or general scheduling layer is required.
3. Generate raw bytes and structured valid/invalid paths, using deterministic seeds
   and shrinkers that preserve the observed violation. Cover the accepted wrapper
   domain. Use standard facilities first; obtain approval for new dependencies.
4. Search concrete implementations under enforced execution limits. Replay each
   candidate witness independently on captured uninstrumented BEAM bytes, record
   expected/actual results, artifact identity, input encoding, and minimal regression.
   A model-only failure, instrumented discrepancy, or timeout is not a violation.
5. Invoke checked proof attempts separately from testing. No counterexample found
   remains unknown unless the exact accepted contract has a valid receipt. Display
   all evidence/assumption/conformance/freshness dimensions without conflation.
6. Retain and replay the vulnerable `..` witness and fixed implementation result
   through a fresh ordinary consumer. Report build failures, unsupported targets,
   missing approval, flaky replay, resource limits, and absent proofs explicitly.

## Deliverables

Minimal Mix task, candidate proposal interface, seeded generator/shrinker,
concrete replay/regression bundles, and structured command output.

## Validation and handoff gate

- [ ] A consumer can select a compiled fixture and accepted policy through the
  Mix task, without manual Lean program editing or production `Reach` calls.
- [ ] Search finds and shrinks the original violation; independent uninstrumented
  BEAM replay and saved regression identify exact artifacts and bytes.
- [ ] Fixed valid inputs remain accepted; tested-without-proof remains unknown,
  while proved requires phase 06's receipt and all required claims.
- [ ] Missing policy, unsupported code, timeout, model-only witness, stale bundle,
  failed replay, and checker error cannot fall through to success.
- [ ] `mix precommit`, non-test consumer invocation, and replay tests pass.

Write `HANDOFF.md` using the [template](../HANDOFF_TEMPLATE.md), with exact
identities, commands/logs, measured effort, and any unresolved gate items.
A failed or incomplete gate blocks dependent phases; never relabel reduced scope
as the original pass.

## Boundary

No automatic policy acceptance, full fuzzing platform, semantic bug discovery
claim from proof failure, or historical CVE claim for the synthetic fixture.
