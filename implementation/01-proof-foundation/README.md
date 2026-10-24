# Phase 01 — Rebuild and audit the proof foundation

**State:** Not started.

**Depends on:** No implementation phase.

**Next:** [02 — Contracts and fixtures](../02-contracts-and-fixtures/README.md).

**Brief:** Sections 5.1, 5.3, 6, 9, 13.1–13.3, and 14; references 10–12, 16–20.

## Assignment

Produce a reproducible HARP/Rocq foundation and an honest trust inventory. This
is the foundation portion of the cumulative ten-engineer-day feasibility gate,
not a proof about an Elixir function.

Read the shared [architecture](../ARCHITECTURE.md), actual project pins, and
upstream build/license instructions. Work in an isolated proof environment;
do not alter Pudding's Elixir/OTP pins to match HARP's older tooling.

## Work

1. Fetch HARP revision `4a59339cdc5c9cff3a144732397d56dfa7378631` and record
   source/archive digests. Pin exact Rocq 9.1.x, compatible stdpp, build tools,
   base environment, and all transitive dependencies. Record how fetched inputs
   become an offline rebuild, including platform constraints.
2. Build the sequential frame-stack development, its executable interpreter,
   and the relevant equivalence results from clean source. Identify the exact
   modules and conditions needed by a restricted sequential backend.
3. Inventory axioms, admitted results, unsafe settings, trusted plugins and
   conversions, and dependency assumptions. Distinguish upstream facts actually
   rechecked from source-level observations. Unsupported or unchecked upstream
   results cannot silently enter Pudding's trusted closure.
4. Document syntax/BIF entry points and the unknown-operation fallback. Record
   the absence of binary constructors and presence of maps as audit findings,
   not modern-compiler compatibility results.
5. Record LGPL-3.0-or-later obligations and an explicit packaging/fork boundary
   before incorporating upstream code. Use a separately tracked owned extension
   or fork; never patch files under `deps/` as the maintained implementation.
6. Add pinned build/recheck commands, logs, and a small dependency/trust manifest.
   Begin effort accounting for the entire phases 01–07 budget.

## Deliverables

- Rebuildable environment/lock/build instructions under `proof/`.
- `docs/verification/foundation-audit.md`: revisions, built modules, assumptions,
  outstanding compatibility issues, license treatment, and actual clean logs.
- Machine-readable dependency identities suitable for later evidence bundles.
- A starting trust inventory and cumulative effort ledger; no invented theorem.

## Validation and handoff gate

- [ ] A clean environment rebuilds the selected foundation from pinned inputs;
  an unavailable dependency or build failure is recorded as a blocker.
- [ ] Relevant interpreter/equivalence objects are identified and checked, with
  their premises and assumption closure visible.
- [ ] The replay commands do not depend on an unrecorded host opam switch,
  branch head, local patch, or mutable container tag.
- [ ] License/fork handling and the remaining trusted machinery are explicit.
- [ ] `mix precommit` passes; this is recorded separately from the Rocq build.

Write `HANDOFF.md` using the [template](../HANDOFF_TEMPLATE.md), with exact
proof-environment entry/rebuild commands and the modules phase 02 may rely on.
If the build is blocked, stop downstream work that assumes this foundation.

## Boundary

Do not install speculative solver integrations, implement a general scheduler,
rewrite HARP into another assistant, or claim OTP 29 support. A foundation build
does not establish the implementation connection; phase 07 owns that gate.
