# Phase 02 handoff — accepted byte contract and ordinary fixtures

## State and identities

- **State: complete. Gate: passed.** Phase 03 may begin after checking these
  identities. This gate freezes policy and exercises concrete behavior; it does
  **not** prove the universal validator law or authorize a Pudding receipt.
- Base source: `eb0084fcae50f50557526b79c520948969064557` (merged phase 01).
  Implementation branch: `phase-02-contracts-and-fixtures`. The review PR's head
  commit identifies the delivered tree; the base commit does not identify the
  added bytes. [Source digests][sources] identify prepared implementation/config,
  tests, contract records and plan inputs independently of commit assignment.
  The handoff and evidence index are outside that source list to avoid a
  self-referential digest; [SHA256SUMS][sums] binds the retained evidence files.
- Contract: **`pudding.archive_path.bytes/v1`**. Immutable [candidate][candidate]
  SHA256 `f576679bad86234b75c59241be674e2cfab0bf0c704cdef8845f516057ea8d7f`.
  Separate [accepted record][accepted] SHA256
  `a5e98649589a7ef637e672871af17de018a2a0854749cb589e0e4a33fdf72663`.
  Owner explicitly selected **“Accept this exact contract identity”** in session
  question `question_01M7K84B82CTE2JE0E10XD1MS2`; this is not agent self-approval.
  The retained transcription is not a cryptographic signature or checker receipt.
- Executable reference: `Pudding.Contracts.PathPolicy.expected/1`;
  `lib/pudding/contracts/path_policy.ex` SHA256
  `ce441a804adfa0e91b2cb26b707408db7ae1921d573ed5e76edae8b74af5d8b5`.
  Initial `test/fixtures/projects/archive_path/lib/laws.ex` SHA256
  `c7779d866d45bb7f5836f2483ebe64c39d821cc38add745138174ce7489edf9a`.
- Required inventory (not optional helper-only completion):
  1. `ArchivePath.Laws.binary_contract/1`, requires **only `is_binary(input)`**;
     exact `ArchivePath.Fixed.validate(input) === PathPolicy.expected(input)`.
  2. `ArchivePath.Laws.nonbinary_wrapper/1`, requires `not is_binary(input)`;
     exact `ArchivePath.Fixed.validate(input) === {:error, :not_binary}`.
  Expected generated names are
  `Elixir.ArchivePath.Laws.laws.«binary_contract/1»` and
  `Elixir.ArchivePath.Laws.laws.«nonbinary_wrapper/1»`, with the corresponding
  `Elixir.ArchivePath.Laws.«NAME:requires/1»` and `«NAME:ensures/1»`
  definitions. These are **expected identities**, not inspected generated Lean
  in this phase. Phase 03 must inspect actual statements and successful
  `Except.ok Lynx.Term.true` return, including totality and both complete domains.
- No phase 04 capture or Core/translation artifact bundle exists. [BEAM digests][beams]
  identify local production qualification outputs only; those mutable build files
  are not retained or claimed to be reproducible captured targets. Source/locks
  are retained so the ordinary consumer can be rebuilt and reidentified.
- Actual environment: macOS 27.2 ARM64, Erlang/OTP 29.0.2 / ERTS 17.0.2,
  Elixir 1.20.2 compiled with OTP 29. Lynx Git revision remains
  `99a6db764c154207cf3b28c35409d9b56c463357`. Lean pin remains 4.35.0;
  host `lean --version` reports 4.35.0 commit
  `eb6cafb7290e8bd5f2937522d8d804f58f02bafc`; Lake 5.0.0-src+eb6cafb.
  These host versions do not extend phase 01's Linux independent-check qualification.
- Checker binaries/axiom policy/isolated receipts: **not exercised in phase 02**.
  Preserve phase 01's qualified Linux ARM64 recipe and standard-axiom policy;
  no new proof import, local semantics, backend change or product receipt policy.
- Prerequisite [phase 01 handoff](../01-lynx-foundation/HANDOFF.md) SHA256
  `f274e5cace1120c7e6816a84ebd250f17fb51cf4cbc792cea132d0df16132a77`;
  all its retained `SHA256SUMS` entries verified OK ([environment transcript][env]).
  Phase 01's independent proof was not rerun and is not validator evidence.
  Current plan/architecture/reference source identities are in [source digests][sources].

## Delivered behavior

- [Byte-policy reference](../../lib/pudding/contracts/path_policy.ex): split first,
  preserve empty components, then check complete components with binary matching.
  Every finite binary is in domain; every nonbinary term, including nonbyte
  bitstrings, has a separate exact wrapper result.
- [Ordinary consumer](../../test/fixtures/projects/archive_path/README.md): separate
  incremental byte-recursive fixed validator and synthetic vulnerable check that
  rejects `../` but accepts `..` and `a/..`. No historical OTP ZIP reproduction,
  handwritten Lean program substitute or change to vendored dependencies.
- [Contract documentation](../../test/fixtures/contracts/README.md), frozen candidate,
  separate explicit acceptance and an identity test that checks their linkage and
  executable/initial-law digests. It detects accidental changes, not hostile
  tampering or human authority by itself. Semantic changes require new acceptance;
  implementation/proof-only changes need fresh identities and unchanged-statement
  review/rechecking. Do not rewrite the old candidate or silently weaken a law.
- Exact-value boundary tests, all 256 single-byte classifications, finite
  differential checks (single bytes, prefixed/suffixed bytes and 512 representative
  triples), invalid UTF-8, raw backslash/colon/percent bytes, NUL, slash/empty/dot
  cases, nonbinary terms and nonbyte bitstrings. Executable negative-control laws
  fail for reject-all, sanitized output and a validity-only hidden precondition.
- [Observation schema v1](../../docs/verification/results.md),
  `Pudding.Result.new/1`, validates complete known fields/enums/claim IDs and keeps
  assumptions, approval, conformance, freshness and authority separate. Malformed
  fields and unknown outcomes fail closed. It rejects `:proved`; `proved?/1`
  always returns false, even for forged records. It is not an evidence checker.
- Root precommit and CI now explicitly run production consumer qualification.
  Root test discovery still excludes standalone project tests. The ordinary
  project also passes its own warnings-as-errors test suite. Reach remains
  unavailable in the production consumer; no library code uses Reach.

## Gate checklist and validation

Evidence directory: [macos-arm64-2026-11-16][evidence]. Commands below use the
repository's existing toolchain through `mise exec --`; no alternate installation.

- [x] **Accepted identity and approval:** frozen candidate plus separate owner
  acceptance above. `Pudding.Contracts.IdentityTest` verifies exact source and
  record digests. The original candidate remains visibly candidate.
- [x] **Concrete exact behavior:** root policy tests and consumer tests assert
  exact success components/error atoms. The original BEAM `..` mismatch is
  asserted directly, not inferred from failed proof. [Production log][prod]
  records eight passing tests.
- [x] **Full-domain initial laws and explicit exclusions:** binary law has no
  validity/length premise; wrapper covers all nonbinary terms including nonbyte
  bitstrings. Candidate and docs state normal/error behavior, unexpected failures,
  abstract totality, idealized memory, Unicode/filesystem exclusions and trust.
  These statements are obligations, not discharged universal proofs.
- [x] **Non-vacuity controls:** executable Lynx law assertions reject reject-all
  and changed-output implementations on `a/b`; malicious `..` is rejected by the
  deliberately stronger law's requirement but evaluated by the actual binary law.
  The original vulnerable law's expectation fails on `..`. No general missing-law
  evidence checker is claimed (that is later work).
- [x] **Schema and checks:** direct/conditional observations remain unknown;
  reproduced violation, unsupported construct, timeout, stale evidence and
  missing obligations are distinct; acceptance/assumptions/conformance/freshness
  never create receipt authority. Root precommit and ordinary tests pass.

| Working directory | Command | Observed result / retained transcript |
| --- | --- | --- |
| root, before implementations | `mise exec -- mix test test/pudding/contracts/path_policy_test.exs` | Failed for unavailable reference; `policy-before.log` (also contains dependency compile diagnostics) |
| root, before schema | `mise exec -- mix test test/pudding/result_test.exs` | Six failed tests for unavailable `Pudding.Result`; `result-before.log` |
| root | `mise exec -- mix precommit` | Exit 0: audits, warnings-as-errors compile, format, strict Credo, usage sync, compile-dependency gate, docs, **14 passed (1 doctest, 13 tests)**, then **8 passed** production consumer; `precommit-final.log` |
| root | `mise exec -- mix dialyzer` | Exit 0, zero errors/skips; `dialyzer.log` |
| root | `MIX_ENV=prod mise exec -- mix compile --warnings-as-errors` | Exit 0, non-test library compile; included in implementation checks, not a formal proof |
| archive_path project | `mise exec -- mix test --warnings-as-errors` | Exit 0, **8 passed**; `consumer-test-final.log` |
| archive_path project | `MIX_ENV=prod mise exec -- mix compile --warnings-as-errors` then `MIX_ENV=prod mise exec -- mix run qualification.exs` | Exit 0, **8 passed**, no Reach at runtime; `production-consumer-final.log` |
| root | `mise exec -- mix test ./test --warnings-as-errors` and absolute test path | Both exit 0, **14 passed** each; no nested test loading; `discovery-format.log` |
| root | `mise exec -- mix format --check-formatted` and `git diff --check` | Exit 0; included in `discovery-format.log` |
| root | `mise exec -- mix hex.build --unpack --output tmp/phase02/package` | **Exit 1**, Git dependency Lynx cannot be a Hex dependency; `package.log.gz`; same phase 01 release limitation, not concealed or fixed by changing pins |

Failure accounting: the first precommit failed because a newly linked result
schema page was not in ExDoc extras (`precommit.log`); adding the actual page to
extras corrected it. Credo initially required aliases and conventional ExUnit
filenames. A manual runner under `test/` then caused Mix's non-test-file warning;
putting the runner at the fixture root removed it without suppressing checks.
The final ordinary suite and precommit pass. An early invalid
`mix run --warnings-as-errors` invocation was replaced with separate strict compile
and run; it was not counted as a successful check.

**Not run / not phase 02 claims:** `Lynx.Laws.verify/2` for these validator laws,
fresh exports, generated-statement inspection, transitive axiom audit,
independent paranoid checking, clean offline validator-proof replay, hostile
capture, general tamper/resource/isolation checking or required-claim CI receipts.
The default law proof attempt is not completed proof. Those remain phase 03 and
later gates. CI configuration is present; remote PR check identities/status are
reported in the PR and delivery message only when actually observed.

## Claims and trust

| Target / contract | Outcome and domain | Assumptions, conformance, freshness |
| --- | --- | --- |
| Fixed / accepted v1 | Universal evidence **unknown / not run**. Intended for every finite binary plus every nonbinary term; concrete corpus matches exact oracle outputs | Idealized sufficient memory, compiler/runtime and later Lynx model/translation trust. Only finite tested agreement on current prepared source/build; no general backend conformance guarantee |
| Vulnerable / accepted v1 | **Concrete synthetic violation reproduced** on BEAM: `..` returns `{:ok, [".."]}` instead of `{:error, :invalid_path}` (also `a/..`) | Same byte interpretation; source/test and local build digests retained. No isolated captured replay receipt or claim about arbitrary deployed code |
| Reject-all / sanitized / stronger-precondition controls | Concrete control conflicts established, not universal proof artifacts | Demonstrate useful acceptance, exact-output and domain obligations; not additional approved policies |
| Pudding result schema | Shape validation tested; never product proof authority | Caller-supplied claim IDs, approval state and evidence references are descriptive and unauthenticated |

No receipt exists. Acceptance concerns only the exact policy, not compiler
correctness, Lynx runtime models or source-to-BEAM-to-Core-to-Lean equivalence.
No Unicode decoding/normalization, filesystem/symlink/Windows/ZIP safe extraction,
effects, deployment or practical resource guarantee. No new trusted reconstruction
or checker machinery was introduced here. Phase 03 must verify actual reached
operations, arbitrary-binary support and full nonbyte wrapper coverage rather
than narrow the accepted domain to make proofs pass.

## Effort and budget

The phase 01 handoff records the owner's cumulative phases 01–03 authority:
**“no limits all around”** (uncapped time/effort/spend). It does not permit scope,
contract or checker-policy changes. There is no finite remaining allowance to
calculate. Phase 03 has not started in this run.

Observed branch work began `2026-11-16T22:27:54Z` (Git reflog); final local gate
checks and handoff preparation occurred around `22:44–22:48Z`, followed by PR
preparation/review. This is an elapsed-work window, not instrumented human labor.
Parent-agent token/billing totals, active human minutes, peak memory, CPU/kernel
and checker timings were not instrumented and remain **unknown**, not zero.
The retained logs contain individual test/lint/Dialyzer elapsed times; no actual
paid model/prover job was launched beyond the current agent and read-only review.

| Category | Work and accounting |
| --- | --- |
| Backend setup | Reused unchanged pins and existing installations; verified phase 01 evidence hashes. No new backend setup or source patch; exact active time unknown |
| Capture/adapter | None implemented; manual source/build digest preparation only, not phase 04 capture |
| Policy review | One exact candidate, one explicit owner acceptance; agent-prepared executable policy and documentation, human active time unknown |
| Proof/lemma work | Two required initial laws plus negative controls; **zero completed validator proofs or new Lean lemmas** |
| Upstream runtime changes | Zero dependency edits, patches or confirmed Lynx-owned issue reports |
| Repair/setup failures | Red-first missing modules, lint aliases/filenames, manual-runner warning, ExDoc link/extra, invalid run option, known Hex release failure; included rather than excluded |
| Independent review | One read-only repository-scout technical review reported no blocker and recommended explicit frozen-source binding; identity regression check added. This is code review, not independent proof checking. Actual billing/tokens unknown |
| Project validation | Root and consumer tests, precommit, strict non-test compile, Dialyzer, source/evidence hashes; transcripts retained |
| Independent proof checking | Not attempted for phase 02; no measurement or result claimed |

Cumulative phases 01–02 actual cost/person-hours remain unknown; phase 01's
recorded measured windows/estimates remain in its handoff. Do not add overlapping
agent wall times into fabricated person-hours or present missing telemetry as free.

## Blockers and deviations

- **No unresolved phase 02 gate blocker.** Explicit approval was obtained rather
  than interpreting this implementation request as contract acceptance.
- Hex packaging remains blocked by the unchanged runtime Git dependency; Git/path
  ordinary consumption works. Release qualification remains phase 13.
- Phase 02's local behavioral evidence is macOS ARM64, not a replay of phase 01's
  Linux proof gate. No universal proof/export/checker evidence was generated and
  no existing evidence was promoted to prove this validator.
- No confirmed Lynx gap, semantics workaround, private proof-interface bypass,
  checker-policy change, pin change or upstream publication occurred. If phase 03
  finds a gap, use public APIs to minimize it and follow AGENTS.md upstream-first
  policy; do not patch installed dependencies or weaken this contract.
- The candidate binds initial law-source bytes. Adding proofs in phase 03 must
  retain that candidate, review unchanged executable requirements/expectations,
  update the source-identity test with fresh proof-artifact binding and recheck
  dependent evidence. Policy/domain/assumption changes require new owner approval.
- Product freshness/receipt/capture enforcement does not exist yet; this schema
  deliberately cannot issue `proved`. Later phases remain blocked by phase 03's
  universal-proof/feasibility gate, not by passing this finite test corpus.

## Next entry point

1. **Phase 03 — [validator proof](../03-validator-proof/README.md)**, and nothing
   beyond that gate. Re-read both handoffs, accepted candidate/approval, contract
   docs, law source and phase 01's qualified proof recipe before modifying code.
2. Check evidence with
   `(cd implementation/02-contracts-and-fixtures/evidence/macos-arm64-2026-11-16 && shasum -a 256 -c SHA256SUMS)`;
   check source identities from repository root with
   `shasum -a 256 -c implementation/02-contracts-and-fixtures/evidence/macos-arm64-2026-11-16/source-sha256.txt`.
   Historical build digests are observations, not assertions against a new build.
3. Run `mise exec -- mix precommit`; expect 14 root passes and eight production
   consumer passes. For the focused consumer, from its directory run
   `MIX_ENV=prod mise exec -- mix do deps.get + compile --warnings-as-errors + run qualification.exs`;
   expect eight passes and exit 0. This is not a proof replay.
4. Preserve full binary quantification, exact original components/errors, the
   nonbyte-bitstring wrapper domain, idealized-memory/exclusion/trust statement,
   both required claim IDs and explicit owner-acceptance discipline. Do not
   accept validity as a precondition or replace the real implementation with Lean.
5. Inspect actual generated statements/reached operations; prove and independently
   replay the full required closure under phase 01's qualified environment. A
   proof or public-lemma gap must stop at an actionable upstream report/bounded
   reviewed fix, not local semantics or a narrowed theorem.
6. No additional owner choice is needed for the current accepted scope and inherited
   budget. New policy/assumptions, backend/model or checker changes need their
   applicable review. No universal `proved` result or product receipt is available.

[evidence]: evidence/macos-arm64-2026-11-16
[sources]: evidence/macos-arm64-2026-11-16/source-sha256.txt
[beams]: evidence/macos-arm64-2026-11-16/beam-sha256.txt
[sums]: evidence/macos-arm64-2026-11-16/SHA256SUMS
[env]: evidence/macos-arm64-2026-11-16/environment.log
[prod]: evidence/macos-arm64-2026-11-16/production-consumer-final.log
[candidate]: ../../test/fixtures/contracts/candidates/archive-path-v1.json
[accepted]: ../../test/fixtures/contracts/accepted/archive-path-v1.json
