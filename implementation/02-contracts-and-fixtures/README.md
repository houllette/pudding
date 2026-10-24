# Phase 02 — Establish contracts, fixtures, and result meaning

**State:** Not started.

**Depends on:** Phase 01's foundation/trust handoff.

**Next:** [03 — Build capture and extraction](../03-build-capture-and-extraction/README.md).

**Brief:** Sections 3–4, 7–8, 10, 13.4, and 13.9.

## Assignment

Create ordinary Mix fixtures and the versioned contract/result model that later
proofs and repair attempts must preserve. A candidate contract is never accepted
because the code, tests, or an agent suggested it.

## Work

1. Add a small ordinary consumer project, driven through Pudding as a dependency.
   Include a nonbinary helper over already separated list components, a binary
   archive validator with the deliberate `../` versus `..` defect, and a fixed
   reference fixture retained separately. Do not generate compiled artifacts
   by hand or rewrite emitted programs in the fixture pipeline.
2. Choose a useful nonbinary contract within the audited list/tuple/atom/integer
   subset. Specify its full input domain, successful output relation, expected
   errors/exceptions, positive acceptance, and totality. For example, validate
   integer-list components with exact preservation of accepted components.
   Do not claim this establishes the later binary interface.
3. Encode the strict byte policy from shared architecture and brief section 8.
   Freeze success as exactly `split_slash(b)` and binary rejection as exactly
   `{:error, :invalid_path}`. Give the nonbinary wrapper its own
   `{:error, :not_binary}` obligation and declared caller domain.
4. Create stable contract IDs/versions/digests, definitions, examples, assumption
   inventories, and acceptance provenance. Prepare a concrete reviewable policy;
   obtain explicit acceptance where not already authorized. Preserve proposals
   separately and test that workers cannot promote or mutate them.
5. Implement a minimal result schema distinguishing evidence outcome, accepted
   policy state, visible assumed premises, conformance, freshness, and diagnostics.
   Include `proved`, `violation_reproduced`, `unsupported`, `unknown`; satisfy
   AGENTS.md's assumed reporting requirement as a separate visible dimension.
6. Establish a shared restricted definition or a documented checked-equivalence
   plan connecting executable contract oracles and formal predicates. Until
   checked, record their translation as trusted rather than implied equivalence.

## Deliverables

Use `test/fixtures/projects/`, `test/fixtures/contracts/`,
`lib/pudding/contracts/`, and a small result module as appropriate. Document the
schema and acceptance decision in `docs/verification/contracts.md`. Record all
manual fixture preparation for later automation/economics reporting.

## Validation and handoff gate

- [ ] Nonbinary helper examples assert useful acceptance and rejection, including
  malformed/improper inputs wherever their domain includes them.
- [ ] Binary examples cover empty/repeated/trailing components, absolute paths,
  `.`, `..`, traversal at multiple depths, NUL, invalid UTF-8, backslash, and
  colon. Invalid UTF-8/backslash/colon cases assert the required acceptance.
- [ ] The vulnerable fixture accepts `..` contrary to the oracle; keep this as
  an asserted known defect, without leaving the project test suite red.
- [ ] Reject-all and nonreturning implementations cannot satisfy the full policy;
  tests/time limits are diagnostics, not universal totality proofs.
- [ ] Accepted contracts have recorded authority and immutable identities;
  misleading inferred policies remain proposals.
- [ ] Result-schema tests prevent timeout/unsupported/checker failure from being
  reported proved and show assumptions beside conditional claims.
- [ ] `mix precommit` passes; library use does not require test-only `reach`.

Write `HANDOFF.md` with contract identities, acceptance evidence, fixture entry
points, and oracle/formal-definition trust. Missing required acceptance blocks
proof/repair work for that contract; it does not block drafting concrete policy.

## Boundary

No filesystem extraction, symlink, Windows, normalization, or generic application
security claim. No binary semantic theorem yet. Do not add a contract DSL macro
or dependency merely to represent these initial records.
