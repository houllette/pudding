# Phase 01 — Qualify the pinned Lynx foundation

**State:** Not started.

**Depends on:** No implementation phase; explicit dependency and budget approvals remain required.

**Next:** [02 — Freeze the policy and ordinary consumer fixtures](../02-contracts-and-fixtures/README.md).

Read the [shared architecture](../ARCHITECTURE.md), [plan](../README.md), and
[backend/reference sources](../REFERENCES.md) with the prerequisite handoffs.

## Assignment

Establish a reproducible Lynx/Lean environment and an honest trust inventory.
Use the baseline in the shared architecture as the starting candidate, not as
an already qualified dependency. Obtain approval before adding Lynx to Mix.
Record an owner-reviewed cumulative budget for phases 01–03 before implementation.

## Work

1. Read the pinned Lynx README, `lib/lynx.ex`, `lib/lynx/laws.ex`, toolchain,
   license, and build/check instructions. Record the exact source/transitive
   dependency digests, package strategy, and offline bootstrap requirements.
   Do not depend on `../lynx` or move Pudding's Elixir/OTP pins to match the host.
2. Build Lynx with the exact Pudding pins, then create the smallest ordinary Mix
   consumer smoke test using public `Lynx.Case` or `Lynx.Laws` APIs. Verify a
   nontrivial small law and confirm a false expectation fails. This is backend
   qualification, not a substitute for the phase 03 binary theorem.
3. Export fresh elaborated declarations and run the pinned toolchain's paranoid
   independent check. Qualify checker output, logical-axiom policy, availability,
   execution limits, and Linux sandbox requirements. No sandbox opt-out may be
   silently treated as the qualified evidence path.
4. Audit reconstruction callbacks, translation, runtime BIF definitions, purity,
   partiality/exhaustion, generated statement shape, transitive axiom audit,
   export closure, cache behavior, and executable elaborator/import surfaces.
   Distinguish inspected source from behavior actually tested.
5. Specify the enforced environments for untrusted compilation/elaboration and
   checking, including network/credential/write restrictions and process limits.
   Validate the bootstrap sandbox; capture/checker hardening continues in 04/06.
6. Retain a clean-build/recheck recipe and actual logs under proposed `proof/`
   and `docs/verification/foundation.md`. Account for licenses and packaging;
   record compatibility failures as blockers rather than patching `deps/`.

## Deliverables

Pinned backend integration, consumer smoke fixture, rebuild/check commands,
trust/license manifest, logs, and the initial effort ledger.

## Validation and handoff gate

- [ ] Exact Pudding pins and pinned Lynx/toolchain build in a clean consumer;
  actual invoked versions and transitive inputs are retained.
- [ ] The small true law verifies; its false control fails for the intended reason.
- [ ] A fresh export independently rechecks under the recorded axiom policy and
  enforced environment. Missing checker tooling remains a blocker.
- [ ] Trust inventory distinguishes logical checking from translation and BEAM
  correspondence; sandbox claims have executable checks and explicit limits.
- [ ] Dependency approval, licenses, reproducible bootstrap, and phase 01–03
  budget/effort accounting are recorded; `mix precommit` passes.

Write `HANDOFF.md` using the [template](../HANDOFF_TEMPLATE.md), with exact
identities, commands/logs, measured effort, and any unresolved gate items.
A failed or incomplete gate blocks dependent phases; never relabel reduced scope
as the original pass.

## Boundary

No custom Core semantics, solver fleet, broad library verification, accepted
security contract, or production `proved` receipt. A successful build does not
establish compatibility of every Lynx operation with the pinned OTP.
