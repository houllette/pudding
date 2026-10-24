# Phase 18 — Qualify the ordinary Mix and CI workflow

**State:** Not started.

**Depends on:** Passed phase 17 and the permitted scope from the evaluation gate.

**Next:** No automatic expansion; select future work from [DEFERRED.md](../DEFERRED.md).

**Brief:** Sections 3, 6, 9–10, 13.7, 13.9, and 14.

## Assignment

Deliver a documented prototype that an ordinary Mix consumer can install, use,
recheck, and enforce in CI, with precise evidence outcomes and conservative
incrementality. Qualify the workflow; do not imply a stable release or publication.

## Work

1. Consolidate the existing task around `mix pudding.verify`, `--target`,
   `--check-existing`, and `--propose-patches`, implementing or explicitly
   documenting exact option behavior. Separate candidate nomination, contract
   acceptance, proof attempts, current evidence, and patch review in reports.
2. Add reviewed configuration for required target/contract claims versus optional
   discovery. A required claim fails CI when current accepted-policy evidence is
   absent, stale, unknown, unsupported, violated, or unaccepted. Conditional proofs
   count only under the configured reviewed assumption policy, shown in output.
3. Report exact scope, quantifiers/bounds, model/importer/checker versions,
   reconstructed-Core trust, assumed premises, conformance, freshness, and known
   exclusions. Link each result to replayable evidence. Show proved/attempted/
   discovered denominators and selection rules; line coverage is not security.
4. Document bootstrap/pinned proof environment, isolation requirements, accepted
   policy review, build capture, proof checking, cache invalidation, mismatch
   recovery, counterexample replay, and reviewable patches. Keep internal
   engineering details out of routine user decisions unless they affect the claim.
5. Add explicit CI execution for formal/checker tests and representative consumer
   evidence replay; the original Mix precommit alias alone does not run Rocq.
   Preserve existing checks and document slow/optional evaluation jobs separately.
6. Validate a fresh consumer outside Pudding's own test environment with the
   intended dependency mode and packaged files. The existing `package.files`
   allowlist does not include future proof assets by default: deliberately
   include required owned assets or document pinned external bootstrap, with
   license treatment. Avoid relying on repository-only files or test-only deps.
7. Run a clean end-to-end consumer demonstration, then mutate source/configuration/
   dependency/contract to show stale claims fail and rechecking rebuilds affected
   evidence. Recheck a copied immutable bundle without the original model session.

## Deliverables

User-facing task/docs, required-claim CI configuration and workflow checks,
fresh-consumer/package rehearsal artifacts, release-readiness limits, and a
final prototype qualification report under `docs/verification/`.

## Validation and handoff gate

- [ ] Fresh consumer install/compile/use succeeds outside `MIX_ENV=test` with
  no production `Reach` dependency or untracked local fixture/proof prerequisite.
- [ ] Discovery, explicit target, existing-evidence replay, violation, unsupported,
  unknown, and proposed-patch paths show the correct identities and report states.
- [ ] Required claims fail on missing/stale/pending/violated/unsupported/unknown
  evidence and pass only for current exact checked claims under approved assumptions.
- [ ] Source/config/dependency/contract mutations trigger correct invalidation;
  optional discovery remains visible without being counted as proof success.
- [ ] Independent clean checker/consumer replay and owned proof-asset packaging
  rehearsal pass with license/bootstrap requirements recorded.
- [ ] `mix precommit`, appropriate formal/checker gates, non-test consumer checks,
  and existing CI checks pass locally; report remote CI only if actually observed.

Write `HANDOFF.md` with consumer commands, packaging/bootstrap identities, CI
semantics and evidence, complete gate status, and remaining research limits.
Update the implementation index to reflect evidence-backed completion.

## Boundary

No automatic Hex publication, release tag, merge, infrastructure deployment,
third-party patch submission, or broader security certification is authorized by
this plan. Future semantics and scaling work require their own bounded phase.
