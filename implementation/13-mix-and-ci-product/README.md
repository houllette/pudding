# Phase 13 — Qualify the consumer and required-claim CI workflow

**State:** Not started.

**Depends on:** Passed phases 01–12 and current prerequisite handoffs.

**Next:** Qualified scope only; further research requires a new reviewed assignment.

Read the [shared architecture](../ARCHITECTURE.md), [plan](../README.md), and
[backend/reference sources](../REFERENCES.md) with the prerequisite handoffs.

## Assignment

Make the proven workflow installable and usable by an ordinary Mix consumer,
with explicit required claims, fail-closed CI, independent offline replay, and
honest documentation of trust, limitations, and costs.

## Work

1. Package the Pudding library, approved pinned Lynx dependency, required owned
   proof assets, and bootstrap/recheck tooling. Test the actual package allowlist
   from a clean consumer without sibling paths, development/test dependencies,
   unrecorded local toolchains, credentials, or warm caches. Keep Reach test-only.
2. Document qualification/sandbox platform requirements and exact toolchain install,
   policy acceptance, verify/discover/replay commands, artifact retention, resource
   settings, and independent checking. Add an Application only if actual long-lived
   processes require it; do not create a pool merely for future scale.
3. Provide required-claim configuration that binds accepted contract IDs/domains,
   target identity, required obligations, allowed assumptions, and freshness.
   Fail CI on missing, skipped, stale, unaccepted, unsupported, unknown, violated,
   or incompletely checked required evidence. Optional exploration stays separate.
4. Exercise fresh install, vulnerable/fixed projects, source/config/dependency
   changes, backend/checker upgrades, missing offline inputs, and reproducible replay.
   Validate command exit semantics and machine/human reports without an agent.
5. Recheck receipt schemas, lock/provenance identity, secrets/network boundaries,
   artifact retention/access, and cache behavior on the actual CI platform. Never
   describe a local test as remote CI evidence; record remote runs only if run.
6. Publish public API/operator documentation from implemented behavior and measured
   evaluation limits. Show accepted versus candidate policy, evidence outcomes,
   visible assumptions, conformance, freshness, abstract termination scope, and
   translation/compiler/runtime trust. No generalized extractor/DoS guarantee.

## Deliverables

Installable consumer workflow, required-claim CI interface, packaged proof assets,
fresh-consumer/maintenance tests, and verified operator/API documentation.

## Validation and handoff gate

- [ ] A fresh packaged consumer outside Pudding's test environment installs,
  verifies all fixed obligations, reproduces the original violation, and replays
  independent evidence without sibling checkouts or a model service.
- [ ] Required-claim negative controls and stale/missing/unknown/unsupported cases
  fail CI with stable diagnostics; optional scans cannot mask required failures.
- [ ] Supported platform isolation/toolchain/bootstrap and offline-input limits are
  enforced and documented; package assets and dependency licenses are complete.
- [ ] Cold/warm and maintenance mutation results preserve current-claim correctness;
  reports distinguish all assumptions, conformance, and freshness dimensions.
- [ ] `mix precommit`, fresh non-test package/consumer checks, and offline replay
  pass; any actual remote CI result is recorded separately.

Write `HANDOFF.md` using the [template](../HANDOFF_TEMPLATE.md), with exact
identities, commands/logs, measured effort, and any unresolved gate items.
A failed or incomplete gate blocks dependent phases; never relabel reduced scope
as the original pass.

## Boundary

No claim of ecosystem-wide support, compiler correctness, arbitrary native-code
verification, automatic deployment, or universal security. Remaining research
belongs in DEFERRED.md, not hidden behind a green command.
