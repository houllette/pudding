# Pudding implementation plan

This folder supersedes the research brief with ordered assignments for dedicated
agent runs. It is an implementation plan,
not evidence that the verifier exists or that the research gates have passed.
All phases start **not started**. This planning task does not accept a contract,
approve a new dependency, or authorize a paid model experiment.

The original source was the October 23, 2026 brief, SHA-256
`6fa0fe99e419453370e487c5cea3185fbe7c2a2e989cd60a98162a905610860c`.
Its requirements are mapped in [SOURCE_MAP.md](SOURCE_MAP.md), and its numbered
source links are retained in [REFERENCES.md](REFERENCES.md). The original file
has been removed. Phase `Brief` fields preserve its section/reference numbering;
use the source map and bibliography for that research context.

## How to run a phase

Give one agent one numbered folder. Its `README.md` is the assignment: read it
with the root [AGENTS.md](../AGENTS.md), [architecture](ARCHITECTURE.md), and the
previous phase's completed handoff. Implement only that phase, validate it, then
create `HANDOFF.md` in its folder using the [handoff template](HANDOFF_TEMPLATE.md).
Do not begin the next phase in the same run by default.

Use this launch prompt, substituting the selected folder:

```text
Implement implementation/01-proof-foundation/README.md as one dedicated phase.
Read AGENTS.md, implementation/README.md, implementation/ARCHITECTURE.md, and
the prerequisite handoffs before editing. Check the actual repository state;
the plan's landing paths are proposals, not existing APIs. Complete this
phase's deliverables and validation, run mix precommit, and write its
HANDOFF.md using implementation/HANDOFF_TEMPLATE.md. Report the exact gate
evidence and stop at this phase boundary. Do not advance on a failed gate.
```

Each phase has one primary deliverable. Formalization remains research work;
one assignment is not a promise that it fits an arbitrary context or time limit.
If a run stops early, leave a resumable handoff with the remaining obligations
and exact blockers. A successor resumes that phase until its gate passes. Split
an unexpectedly large task into reviewed smaller assignments rather than
claiming completion with omitted work.

## Phase order

Run in numeric order. Dependencies include all earlier passed phases unless a
phase explicitly narrows them. A later phase may read earlier artifacts but
must revalidate their identities before reusing evidence.

| Phase | Dedicated deliverable | Handoff gate |
| --- | --- | --- |
| [01 — Proof foundation](01-proof-foundation/README.md) | Pinned, rebuildable HARP/Rocq foundation and trust inventory | Clean foundation build; exact dependencies, assumptions, and license treatment recorded |
| [02 — Contracts and fixtures](02-contracts-and-fixtures/README.md) | Frozen demonstration policies, ordinary Mix fixtures, result schema | Reviewed acceptance records and executable contract examples; proposals remain separate |
| [03 — Build capture and extraction](03-build-capture-and-extraction/README.md) | Isolated project adapter and reproducible BEAM/Core capture | Real fixture automatically extracted with complete provenance and explicit failures |
| [04 — Nonbinary importer](04-nonbinary-importer/README.md) | Closed-world support inventory and deterministic Core import | Every reachable construct classified; faithful syntax import or explicit rejection |
| [05 — Execution conformance](05-execution-conformance/README.md) | Imported-model/BEAM differential runner | Normal and exceptional outcomes agree in the tested subset; mismatch quarantine works |
| [06 — Independent checker](06-independent-checker/README.md) | Exact-theorem, isolated proof checking and tamper controls | Valid submission accepted; weakened statements, hidden assumptions, and unsafe settings refused |
| [07 — First implementation theorem](07-first-implementation-theorem/README.md) | Nontrivial theorem about the exact imported helper | Clean independent replay and written first feasibility decision |
| [08 — Binary values and construction](08-binary-values-and-construction/README.md) | Byte-aligned values, literals, construction rules, and representation lemmas | Checked construction semantics; existing nonbinary results still check |
| [09 — Binary matching semantics](09-binary-matching-semantics/README.md) | Exact byte matching, failure, and preservation rules | Checked supported matching rules and explicit rejection of other bit syntax |
| [10 — Binary import and conformance](10-binary-import-and-conformance/README.md) | Actual binary-validator Core imported and cross-tested | Full closure supported; no unresolved supported-subset disagreement |
| [11 — Validator theorems](11-validator-theorems/README.md) | Checked safety, exact acceptance, and totality | Independent replay of binary and wrapper claims; separate binary feasibility decision |
| [12 — Discovery and counterexamples](12-discovery-and-counterexamples/README.md) | Minimal Mix verification command and replayable search | Discover fixture, reproduce/minimize `..`, retain regression and honest outcomes |
| [13 — Bounded proof worker](13-bounded-proof-worker/README.md) | Untrusted proof-search worker behind the checker | Budgets, permissions, artifact retention, and adversarial refusal validated |
| [14 — Guarded repair loop](14-guarded-repair-loop/README.md) | Complete discovery/regression/patch/reproof demonstration | Vulnerable and patched artifacts retained; unchanged contracts pass independent checks |
| [15 — Evaluation preparation](15-evaluation-preparation/README.md) | Frozen corpus and comparable-budget protocol | Twenty target/contract pairs, package-held-out split, controls, budgets, and run authorization recorded |
| [16 — Evaluation execution](16-evaluation-execution/README.md) | Reproducible three-arm results and continuation decision | Full denominator, failures, cost, intervention, and held-out reuse reported |
| [17 — Incremental evidence](17-incremental-evidence/README.md) | Content-addressed build/proof graph and conservative invalidation | Mutation suite invalidates affected claims; old bundles cannot certify new builds |
| [18 — Mix and CI product](18-mix-and-ci-product/README.md) | Fresh-consumer workflow, required-claim CI, and documentation | Ordinary consumer installs/runs/rechecks; stale or missing required evidence fails CI |

## Decision gates and budgets

1. **Nonbinary feasibility, after phase 07.** Use the brief's proposed ceiling
   of ten focused engineer-days across phases 01–07. Track actual foundation,
   adapter, contract, import, checker, and theorem effort from phase 01. This is
   a planning ceiling, not a measured delivery estimate. At the limit publish
   the working bundle or blockers and stop for a scope decision; do not reset
   the clock per phase. Agent elapsed time and token usage are separate measures.
2. **Binary feasibility, after phase 11.** At phase 07, scope and record a
   separate budget for phases 08–11 from the emitted-operation inventory. A
   list theorem does not pass this gate. Missing binary semantics or totality
   blocks the security demonstration and downstream assurance claims.
3. **Demonstration, after phase 14.** Both the original violation and the fixed
   implementation must independently replay. A manually prepared proof from
   phase 11 is infrastructure evidence; automation and repair effort must still
   be measured here.
4. **Reuse and economics, after phase 16.** Apply the predeclared evaluation
   criteria. Failure is a research result, not permission to narrow the
   denominator, weaken the policy, or describe the prototype as qualified.

Do not build a general scheduler, solver fleet, or proof cache before the first
two gates. Early phases retain immutable bundles and reject changed build or
contract identities; phase 17 adds cross-build reuse. Minimal discovery and a
scripted ordinary-project driver begin in phase 03, before a polished CLI.

## Completion and continuation

A phase passes only when its specific checklist and the shared handoff contract
pass. Run `mix precommit` for every implementation handoff. Record formal builds,
independent checking, clean consumer replay, and CI separately; the Mix alias
does not automatically check new Rocq artifacts. Check compilation/use outside
`MIX_ENV=test` for library changes because `reach` is test-only. Never narrow a
gate, suppress a failure, or treat an unrun check as green.

New dependencies still require the approval required by AGENTS.md. Prepare the
concrete choice and rationale first, then obtain approval before adding it.
Acceptance of contracts, changes to trusted semantics/checker policy, and any
paid evaluation have their own recorded authority. Reading this plan does not
provide that authority. Existing authorization should be reused when it covers
the exact action.

Update this index only when a completed handoff supports a status change.
Retain blocked or incomplete handoffs. If a later mutation exposes a mismatch,
invalidate dependent gates and evidence before continuing. Future research is
in [DEFERRED.md](DEFERRED.md); it is not part of an active phase's completion
criteria. The [source map](SOURCE_MAP.md) accounts for the entire brief.
