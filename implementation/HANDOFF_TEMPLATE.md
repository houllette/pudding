# Phase NN handoff — title

Copy this into the phase folder as `HANDOFF.md` at the end of its implementation
run. Fill every section with evidence or an explicit unknown. This template is
not a completed handoff and does not attest to any gate.

## State and identities

- State: not started / in progress / blocked / complete.
- Gate: passed / failed / not run. Only passed permits the next phase.
- Source revision, worktree, and uncommitted scoped changes:
- Accepted contract IDs/digests and acceptance authority:
- Build/Core/imported-program IDs and artifact locations:
- Semantics, HARP/fork, proof-toolchain, checker, and policy identities:
- Implementation plan revision and original research digest used:

For artifacts not committed to Git, give durable locations and content hashes.
If identity is tied to uncommitted bytes, record their digests; do not claim a
commit identifies changes it does not contain. Preserve unrelated user work.

## Delivered behavior

Describe the runnable result, public interfaces, changed files, and deliberate
scope choices. Link the phase's specific required artifacts. Distinguish code
written from behavior verified and research claims established.

## Gate checklist and validation

Copy the phase's handoff checklist and mark each item with a supporting artifact
or unresolved blocker. Record working directory, environment, exact commands,
exit/result, and log locations for:

- Targeted regression/negative controls and meaningful failure-before evidence.
- `mix precommit` and any separate non-test consumer compile.
- Formal-library builds, expected-theorem checks, assumption audits, `rocqchk`.
- Clean-environment replay and artifact tamper checks where required.
- Remote CI, if actually run; a local pass is not a remote CI result.

List skipped or failed checks and their concrete causes. A green Mix gate does
not establish Rocq checking or model/BEAM correspondence.

## Claims and trust

For each target/contract report the evidence outcome, exact domain/bounds,
assumed premises, conformance status, freshness, and exclusions. List newly
trusted code, semantic rules, BIF models, logical assumptions, and conversion
machinery. Do not substitute a worker's explanation for checker evidence.

## Effort and budget

Record human minutes by foundation, adapter, contract, import, semantics, lemma,
repair, and review; agent elapsed time/tokens; CPU/memory/checker time; monetary
cost if any; manual preparation; and failed attempts. Maintain cumulative
phase 01–07 effort against the proposed ten-engineer-day ceiling. For later
gates identify their predeclared budget and remaining allowance.

## Blockers and deviations

Give reproducible errors, retained inputs, unresolved obligations, and the
smallest remaining task. Explain any approved plan, dependency, policy, or
toolchain changes and invalidated evidence. If the gate failed, state which
later phases must not start. Never relabel a reduced goal as the original pass.

## Next agent entry point

- Next permitted phase (or same phase to resume):
- Files and immutable artifacts to read first:
- Exact smoke/replay command and expected outcome:
- Interfaces and policy identities to preserve:
- Open decisions requiring owner input, with concrete options prepared:

The next agent verifies this handoff and current identities before editing.
