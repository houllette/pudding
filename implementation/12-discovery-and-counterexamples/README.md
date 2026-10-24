# Phase 12 — Discover targets and retain replayable counterexamples

**State:** Not started.

**Depends on:** Passed phase 11 binary gate and prior project/result interfaces.

**Next:** [13 — Bounded proof worker](../13-bounded-proof-worker/README.md).

**Brief:** Sections 3, 6, 8, 10–11, 13.4, 13.8–13.9.

## Assignment

Provide the first minimal `mix pudding.verify` workflow on the ordinary fixture:
discover candidates, match accepted contracts, generate/shrink inputs, and
replay actual violations. Integrate existing checking; do not build a broad UI.

## Work

1. Extend phase 03 candidate enumeration with static reachable-call information,
   source locations, semantic-support status, and a simple documented ranking.
   Tests/docs may nominate properties; a name like `validate` cannot accept one.
   Keep discovery implementable without production `Reach` calls.
2. Add a minimal Mix task with all-candidate and explicit-target selection,
   using captured build identities and accepted contracts. Reuse proof/checker
   records only for exact matching immutable inputs; otherwise capture afresh.
   Show unknown/unsupported or contract-pending results honestly.
3. Generate raw binaries, structured valid inputs, and malformed boundary cases.
   Prefer StreamData for generation/shrinking if approved; it is not already
   selected/installed by this plan and does not itself provide coverage guidance.
   Retain seeds, budgets, original/shrunk inputs, oracle identity, and outcomes.
4. Add initial target-level line/clause feedback via OTP `cover` where useful,
   with a bounded corpus/mutation scheduler if claiming coverage-guided search.
   Record the signal's limits; runtime/native coverage is not target path coverage.
5. Replay every candidate violation on the captured uninstrumented BEAM artifact
   in a fresh bounded runner. Minimize it while preserving the violated contract.
   Retain diagnostic/model-only mismatches without labeling them real violations.
6. Produce an isolated regression test/case artifact tied to target/contract/build.
   Keep the known-vulnerable fixture intentional so Pudding's own suite stays
   green; future repairs must run the regression against their candidate artifact.

## Deliverables

Minimal Mix task, discovery metadata, bounded generator/shrinker/replay pipeline,
seeded corpus, violation/regression artifacts, and a runnable ordinary-project demo.

## Validation and handoff gate

- [ ] Discovery finds the ordinary fixture without manually copying its body;
  explicit target selection uses the same pipeline and current build identity.
- [ ] Search discovers or reproduces `..`, retains/minimizes it, and independently
  replays the violation on the uninstrumented vulnerable artifact.
- [ ] Fixed reference passes the same cases; regressions assert the actual policy
  and useful valid inputs, including non-UTF-8 and ordinary backslash/colon bytes.
- [ ] Required coverage feedback/corpus behavior is demonstrated if described as
  coverage-guided; generation-only evidence is labeled accurately.
- [ ] No counterexample found is unknown without proof; unsupported/missing debug
  info, timeout, pending policy, and mismatch reasons remain visible.
- [ ] `mix precommit` and the non-test ordinary consumer workflow pass.

Write `HANDOFF.md` with task syntax, discovery/support inventory, seeds, budgets,
replay command, regression artifact, feedback mechanism, and recorded limitations.

## Boundary

No automatic source repair, inferred-policy approval, generic framework analysis,
production security certification, or full CI/cache implementation yet.
