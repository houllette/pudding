# Phase 06 — Authorize exact-contract evidence independently

**State:** Not started.

**Depends on:** Passed phases 01–05 and current prerequisite handoffs.

**Next:** [07 — Discover candidates and replay concrete violations](../07-discovery-and-counterexamples/README.md).

Read the [shared architecture](../ARCHITECTURE.md), [plan](../README.md), and
[backend/reference sources](../REFERENCES.md) with the prerequisite handoffs.

## Assignment

Establish the sole authority for product `proved` receipts. Worker proof text,
Lynx success reports, and valid exports are proposals until trusted preparation,
exact obligation binding, independent checking, and artifact freshness all pass.

## Work

1. Freeze accepted contract, required predicates/domains, captured implementation,
   translated runtime dependencies, approved helper lemmas, toolchain/checker
   policy, and proof configuration outside worker write authority. Validate the
   trusted preparation path from capture to expected theorem type/definition IDs.
2. Rebuild law statements from those inputs and attach untrusted proof bodies only.
   Use exact-type wrappers or equivalent checked binding to the expected target
   and specification declarations. Verify the entire required inventory and
   inspect transitive assumptions; names or theorems about worker replacements
   cannot satisfy the contract. Conditional premises remain visible.
3. Freshly elaborate/export with private scratch and no worker-controlled cache,
   compiled modules, response JSON, imports, plugins, or tool resolution. Use an
   empty unique output path; verify return reports and output binding. Test the
   stale-file hazard when a previous export exists but the new run fails.
4. Independently check the complete export closure with the pinned paranoid
   checkers and explicit axiom allowlist. Require all configured checkers to
   complete successfully. Fuel exhaustion, crash, timeout, missing tool, unknown
   output, and partial checking remain unknown, never proved.
5. Enforce offline/resource-limited environments for both elaboration and checking,
   with read-only trusted inputs and no receipt-store write access. Test Lean
   initializers, shell/process/network attempts, path traversal, hostile imports,
   atom/name encodings, output floods, symlinks, and private-cache substitution.
6. Issue immutable versioned receipts binding build/contract, exact obligations,
   domains, assumptions, model/trust identities, export digest, independent logs,
   conformance, freshness, and exclusions. Recheck a bundle offline without the
   original worker/session. Identity changes or relevant disagreements block
   current assurance; keep direct historical theorem evidence separately.
7. Exercise hidden `sorryAx`/axiom, unsafe settings, weakened/vacuous precondition,
   different target/spec, absent law, stale export/cache, tampered BEAM/debug data,
   replaced checker, and altered proof-dependency controls. Record detection points
   and residual translation/compiler trust. Publish the integration gate decision.

## Deliverables

Trusted checker/preparation modules, exact-obligation binding checks, isolated
runner, receipt schema/store boundary, hostile controls, offline replay recipe,
and trustworthy-integration decision.

## Validation and handoff gate

- [ ] The fixed validator and wrapper receive receipts only after exact accepted
  obligations, artifact binding, fresh export/audit, and full independent checks.
- [ ] Every adversarial statement/assumption/stale-input control is refused; checker
  limits and unrecognized results produce explicit non-success outcomes.
- [ ] Trusted inputs, tool resolution, isolation, and receipt authority survive
  executable worker-escape and tamper tests; worker code cannot mint receipts.
- [ ] Complete bundles replay offline in a clean environment and altered artifacts
  cannot retain a current receipt. Assumptions/exclusions remain visible.
- [ ] Gate decision records remaining trusted layers and costs; `mix precommit`
  and ordinary non-test consumer tests pass.

Write `HANDOFF.md` using the [template](../HANDOFF_TEMPLATE.md), with exact
identities, commands/logs, measured effort, and any unresolved gate items.
A failed or incomplete gate blocks dependent phases; never relabel reduced scope
as the original pass.

## Boundary

No claim that independent checking proves compiler/debug/BEAM equivalence,
no relaxed axiom or sandbox policy to make a proof pass, and no proof-authorized
contract revision. A valid theorem about the wrong code is not implementation evidence.
