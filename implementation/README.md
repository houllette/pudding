# Pudding implementation plan

Pudding is a security workflow built on Lynx: reviewed executable contracts,
real-BEAM counterexamples, implementation-bound proof evidence, and constrained
repair. Lynx supplies Core-to-Lean translation, the Erlang runtime model, laws,
and proof checking. Pudding does not maintain a second language semantics or
translator.

This is a plan, not an implemented verifier. All phases are **not started**.
The first milestone is an independently replayable proof of the actual binary
path validator, before building a general adapter or autonomous worker.

## Running a phase

Give one agent one numbered folder. Read its assignment with root
[AGENTS.md](../AGENTS.md), [ARCHITECTURE.md](ARCHITECTURE.md), relevant
[references](REFERENCES.md), and completed prerequisite handoffs. Check the
actual repository: proposed paths and commands are not existing interfaces.
Implement only that phase, run its checks, and write `HANDOFF.md` using the
[template](HANDOFF_TEMPLATE.md). Do not advance on a failed gate.

```text
Implement implementation/01-lynx-foundation/README.md as one dedicated phase.
Read AGENTS.md, implementation/README.md, implementation/ARCHITECTURE.md,
and prerequisite handoffs before editing. Verify repository and toolchain
state. Complete the phase's deliverables and checks, run mix precommit, and
write HANDOFF.md using implementation/HANDOFF_TEMPLATE.md. Report exact gate
evidence and stop at this phase boundary. Leave incomplete work resumable.
```

A phase may need several runs. Split unexpectedly large work into reviewed
subtasks rather than omitting obligations. Preserve incomplete handoffs and
validate identities before reusing any artifact.

## Phase order

Run in numeric order; each phase depends on all earlier passed phases. A failed
or invalidated prerequisite blocks dependent assurance, even if its old code
still runs.

| Phase | Deliverable | Gate |
| --- | --- | --- |
| [01 — Lynx foundation](01-lynx-foundation/README.md) | Pinned backend/toolchain, clean build, trust inventory | Ordinary consumer verifies and independently rechecks a small law |
| [02 — Contracts and fixtures](02-contracts-and-fixtures/README.md) | Reviewed byte policy, vulnerable/fixed Mix fixtures, result schema | Exact positive/negative behavior and policy authority are explicit |
| [03 — Validator proof](03-validator-proof/README.md) | Direct Lynx proof of the real binary validator and wrapper | Full contract independently replays; first go/no-go decision |
| [04 — Build capture](04-build-capture/README.md) | Isolated ordinary-project capture and immutable manifests | Actual target/dependency artifacts and build inputs are bound |
| [05 — Lynx backend adapter](05-lynx-backend-adapter/README.md) | Thin adapter, support inventory, targeted conformance checks | Exact required claims run against captured code; mismatches quarantine evidence |
| [06 — Evidence checker](06-evidence-checker/README.md) | Isolated exact-contract checking and durable receipts | Hostile submissions, stale exports, and substituted inputs fail closed |
| [07 — Discovery and counterexamples](07-discovery-and-counterexamples/README.md) | Minimal Mix task, generation, shrinking, BEAM replay | Real violation retained; no-counterexample remains unknown without proof |
| [08 — Bounded proof worker](08-bounded-proof-worker/README.md) | Untrusted proof proposals behind the checker | Budgets and write boundaries enforced; worker cannot approve claims |
| [09 — Guarded repair](09-guarded-repair/README.md) | Regression, restricted patch, rebuild, reproof | Newly patched artifact meets the unchanged accepted contract |
| [10 — Evaluation preparation](10-evaluation-preparation/README.md) | Frozen corpus, arms, budgets, controls | Held-out split and acceptance criteria fixed before execution |
| [11 — Evaluation execution](11-evaluation-execution/README.md) | Reproducible results and continuation decision | Full denominator, independent replay, effort/cost, and deviations reported |
| [12 — Incremental evidence](12-incremental-evidence/README.md) | Conservative evidence graph and invalidation | Changed build/policy/backend cannot reuse stale assurance |
| [13 — Mix and CI product](13-mix-and-ci-product/README.md) | Fresh-consumer packaging and required-claim CI | Missing/stale/unknown required evidence fails; offline replay works |

## Decision gates and scope control

1. **Validator feasibility, after phase 03.** Before phase 01 implementation,
   record an owner-reviewed cumulative effort/time ceiling for phases 01–03.
   Count backend setup, contract review, proof work, upstream gaps, and independent
   checking separately. No budget is implied by this document. At the ceiling,
   retain artifacts and stop for a scope decision. A nonbinary helper or finite
   binary sample cannot substitute for the universal byte-validator theorem.
2. **Trustworthy integration, after phase 06.** Direct proofs from phase 03 are
   feasibility evidence, not product receipts. Capture, required-claim binding,
   conformance, isolation, and independent checking must pass before Pudding can
   issue `proved`. Do not add autonomous workers to compensate for a failed gate.
3. **Repair demonstration, after phase 09.** The original violation and newly
   captured repair must replay under the same accepted policy. Disclose all
   manual reference/proof preparation; it is not autonomous repair evidence.
4. **Reuse and economics, after phase 11.** Apply predeclared continuation
   criteria before investing in incremental evidence and product qualification.
   A negative result is valid; do not narrow the denominator after seeing it.

Use existing Lynx capabilities first. Follow the [upstream-first policy in
AGENTS.md](../AGENTS.md#lynx-limitations-upstream-first) for genuine Lynx gaps:
prepare an actionable upstream report and offer a bounded fix rather than build
around the limitation locally. Unresolved gaps retain honest unsupported/unknown
outcomes and blocked gates. No scheduler, solver fleet, broad framework analysis, or
Pudding proof cache before the first useful proof. Early evidence uses fresh,
immutable per-build bundles; cross-build reuse begins only in phase 12.

## Completion and authority

Every implementation handoff runs `mix precommit`, plus its explicit formal,
independent-checker, isolation, and consumer checks. Mix checks do not imply
independent proof checking. Test library use outside Pudding's own test environment;
`reach` is test-only. Do not silently change `.tool-versions` to match the host.

This roadmap selects Lynx as the backend direction. It does not install a
dependency, accept a security contract, authorize a semantic/checker-policy
change, or approve paid model runs. Obtain the concrete approvals required by
AGENTS.md and each phase, reusing prior authority only where it actually applies.

Update phase status only with evidence-backed handoffs. If a mismatch invalidates
prior evidence, block dependent gates until revalidated. Follow-on work is in
[DEFERRED.md](DEFERRED.md), not an implicit obligation of the current phase.
