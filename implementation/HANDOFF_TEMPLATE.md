# Phase NN handoff — title

Copy this into the phase folder as `HANDOFF.md` at the end of implementation.
Fill every section with evidence or explicit unknown/blocker. This template
is not a completed handoff and does not attest to any gate.

## State and identities

- State: not started / in progress / blocked / complete.
- Gate: passed / failed / not run. Only passed permits dependent phases.
- Source revision, worktree, and scoped uncommitted bytes/digests:
- Accepted contract IDs, executable predicate digests, domains, and authority:
- Required claim inventory and exact theorem/translated-definition identities:
- Captured build, BEAM/debug/Core/translation IDs and artifact locations:
- Actual Elixir/OTP, Lynx revision, Lean toolchain, proof dependencies:
- Checker binaries, axiom policy, isolation/platform, and receipt policy IDs:
- Plan revision and prerequisite handoff identities:

For uncommitted or untracked artifacts, give durable locations and content hashes.
Do not claim a commit identifies bytes it does not contain. Preserve unrelated
user work. An installed sibling checkout is not an immutable dependency identity.

## Delivered behavior

Describe runnable behavior, interfaces, changed files, and deliberate scope.
Link required artifacts. Distinguish code written, behavior tested, direct Lynx
proofs, and independently authorized Pudding receipts. Do not call a plan or
successful smoke test an implemented security guarantee.

## Gate checklist and validation

Copy the phase checklist and attach evidence or a blocker to each item. Record
working directory, actual environment, exact commands, exit/results, log locations,
and checked artifact IDs for:

- Targeted regression/control tests and meaningful failure-before evidence.
- `mix precommit`; record failures/skips without suppressing them.
- Separate non-test library, ordinary consumer, and actual package checks.
- Lynx verification reports and complete required-obligation inventory.
- Fresh unique exports, exact statement binding, and transitive axiom audits.
- Independent paranoid checking of the full closure, including every checker outcome.
- Clean offline replay, tamper controls, and resource/isolation enforcement.
- Remote CI only if actually run; a local pass is not remote evidence.

A Mix pass does not establish formal checking. A Lynx pass/export alone does not
authorize a receipt. Checker exhaustion, missing tools, unknown output, or an old
export file is not success. Record exact toolchain mismatches and blockers.

## Claims and trust

For every target/contract list evidence outcome, exact domain/quantifiers,
normal/error results, assumed premises, conformance, freshness, and exclusions.
State artifact/receipt locations or explicitly say no receipt exists yet.

List newly trusted reconstruction/translation machinery, runtime models, proof
imports, logical assumptions, compiler/runtime/environment dependencies, and
remaining gaps. Preserve the distinction between a model theorem and real BEAM
correspondence. A model witness needs independent BEAM replay to become a violation.

## Effort and budget

Record human time for backend setup, capture/adapter, policy review, handwritten
proofs/lemmas, upstream runtime changes, repair, and independent review. Record
agent attempts/tokens/elapsed time, CPU/memory/kernel/checker time, actual cost,
failed work, and manual preparation separately.

Compare cumulative phases 01–03 effort to their owner-reviewed ceiling; later
phases use their recorded budgets. Include spend authority and remaining allowance
where relevant. No paid-run authorization is implied by reading the roadmap.

## Blockers and deviations

Give retained inputs, reproducible errors, unresolved obligations, and the smallest
remaining task. Explain approved dependency, contract, backend/model, checker-policy,
toolchain, or protocol changes and all evidence invalidated by them. Record unknown
build inputs, nondeterminism, mismatches, and quarantine. State which dependent
phases are blocked; never present a narrowed goal as passing the original gate.

For a Lynx-owned limitation, include the minimal reproducer, ownership rationale,
upstream issue URL or report draft location, and proposed fix/regression test.
Record any offer to draft a patch, posting/implementation authority still needed,
and the review/removal condition for any explicitly approved temporary workaround.

## Next entry point

- Next permitted phase or same phase to resume:
- Files and immutable artifacts to read first:
- Exact smoke/replay command and expected outcome:
- Required interfaces, obligations, contract, and policy identities to preserve:
- Owner decisions needed, with concrete options and existing authority:

The next agent validates this handoff and current identities before editing.
