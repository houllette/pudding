# Phase 08 — Constrain untrusted proof search

**State:** Not started.

**Depends on:** Passed phases 01–07 and current prerequisite handoffs.

**Next:** [09 — Repair behind the unchanged accepted contract](../09-guarded-repair/README.md).

Read the [shared architecture](../ARCHITECTURE.md), [plan](../README.md), and
[backend/reference sources](../REFERENCES.md) with the prerequisite handoffs.

## Assignment

Let an untrusted worker propose proof bodies against frozen accepted obligations.
Keep the worker optional: existing manual proofs, offline checking, and evidence
replay must remain usable without a model service.

## Work

1. Define a bounded request containing immutable target/contract IDs, generated
   goal/context, approved public lemmas/imports, allowed proof-body locations,
   resources, and stop conditions. Trusted preparation retains statement authority.
2. Run workers in disposable enforced workspaces with read-only target, policy,
   backend/toolchain, checker, and lemmas. Grant only scratch/proposal writes;
   separate receipt storage, credentials, network access, and model transport.
3. Bound attempts, elapsed time, CPU, memory, output, and model tokens/cost. Keep
   all proposals, diagnostics, resource use, failed attempts, and intervention.
   Local/fake-worker tests precede any explicitly authorized paid run.
4. Submit proposals through the phase 06 checker. Do not accept worker success
   messages, cached responses, exports, or edits to law requirements. New helper
   statements need checked definitions/proofs and reviewed import-policy treatment;
   backend changes require a separate reviewed task, not a worker escape hatch.
5. Test tampering with predicates, assumptions, target code, generated program
   bodies, dependencies, checkers, caches, receipt files, and symlinked paths.
   Exercise forked children, resource exhaustion, interrupted jobs, and cleanup.
6. Measure proof search separately from preexisting handwritten lemma/proof effort.
   Make replay deterministic from retained proposals/inputs where possible; record
   model/version/configuration and stochastic limits honestly.

## Deliverables

Worker request/proposal protocol, isolated bounded runner, budget/attempt ledger,
adversarial tests, and retained successful/unsuccessful submissions.

## Validation and handoff gate

- [ ] Worker can propose a valid proof body, but only trusted independent checking
  can issue its receipt for the original obligations.
- [ ] Statement/target/checker/cache/receipt mutations are denied or rejected with
  executable adversarial tests; allowed writes remain narrowly scoped.
- [ ] Budgets and child-process cleanup work; exhaustion leaves unknown with full
  artifacts. No model call occurs without applicable explicit authorization.
- [ ] Manual/offline proof submission and replay do not depend on worker availability.
- [ ] Attempt ledger separates preparation from search; `mix precommit` and isolated
  worker/checker integration tests pass.

Write `HANDOFF.md` using the [template](../HANDOFF_TEMPLATE.md), with exact
identities, commands/logs, measured effort, and any unresolved gate items.
A failed or incomplete gate blocks dependent phases; never relabel reduced scope
as the original pass.

## Boundary

No solver fleet, automatic contract/lemma acceptance, hidden persistent service,
or agent-written checker policy. The worker is a proposer, never evidence authority.
