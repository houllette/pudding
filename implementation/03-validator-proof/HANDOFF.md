# Phase 03 handoff — direct full-domain validator proof

## State and identities

- State: **complete — all five Phase 03 gates passed. Go to Phase 04.** The full
  accepted contract is feasible without weakening, backend changes or extra
  axioms. No dependent phase is being implemented.
- Implementation branch: `phase-03-validator-proof`, starting revision
  `cb29859`. The eventual implementation commit identifies versioned bytes;
  retained source and implementation-input manifests identify the exact
  pre-commit inputs actually run, not a presumed commit.
- Phase 02 was shipped: merged PR [#4](https://github.com/houllette/pudding/pull/4),
  revision `e3930bd`, with all six remote checks passing. Its handoff, accepted
  records, consumer behavior and retained evidence were inspected; baseline
  `mix precommit` passed before this work. No Phase 02 gate was substituted by a
  plan or initial law definition.
- Accepted contract: `pudding.archive_path.bytes/v1`; candidate SHA256
  `f576679bad86234b75c59241be674e2cfab0bf0c704cdef8845f516057ea8d7f`;
  acceptance record SHA256
  `a5e98649589a7ef637e672871af17de018a2a0854749cb589e0e4a33fdf72663`.
  Authority is the existing explicit owner acceptance recorded in Phase 02,
  not a new approval inferred from a test. Neither JSON record changed.
- Executable reference `lib/pudding/contracts/path_policy.ex` SHA256
  `ce441a804adfa0e91b2cb26b707408db7ae1921d573ed5e76edae8b74af5d8b5`;
  historical initial-law SHA256
  `c7779d866d45bb7f5836f2483ebe64c39d821cc38add745138174ce7489edf9a`.
  Current laws add proof options but preserve every accepted `requires`/`expects`
  AST. The initial bytes are retained at
  `proof/validator/contract/initial-laws.ex.txt`; current proof/source hashes are
  in `contract/proof-inputs.json` and tested against the worktree.
- Required claim inventory (exactly two):
  `Elixir.ArchivePath.Laws.laws.«binary_contract/1»` and
  `Elixir.ArchivePath.Laws.laws.«nonbinary_wrapper/1»`. Each quantifies over
  `input : Lynx.Term`, takes its corresponding translated
  `Elixir.ArchivePath.Laws.«NAME:requires/1» input = Except.ok Lynx.Term.true`,
  and concludes `«NAME:ensures/1» input = Except.ok Lynx.Term.true`.
  Generated definitions bind the binary premise **only** to `is_binary`, its
  expectation to exact fixed/reference equality, and the wrapper premise to
  `not is_binary`, expectation to exact `{:error, :not_binary}`.
- Actual toolchain: Elixir `1.20.2`, OTP `29.0.2`, ERTS `17.0.2`;
  Lynx Git `99a6db764c154207cf3b28c35409d9b56c463357`;
  Lean `4.35.0` / commit `eb6cafb7290e8bd5f2937522d8d804f58f02bafc`.
  No dependency, backend, toolchain or lock change. Lean uses no external Lake
  packages. The pinned Lynx Git tree and individual source digests are retained.
- Checker/axiom policy unchanged: Lean paranoid, lean4lean, nanoda, con-leche,
  con-ron and Lean default; only `propext`, `Quot.sound`, `Classical.choice`.
  Exact executable hashes, versions, image/kernel/engine and environment probes
  are in retained logs. Qualified image config
  `a9a8fdbf73d3b787505b55a6f366959aca929725da359abd0b400c2b1b2a3758`,
  manifest `adb04a68311ce73be23c8ddcfc2b779b204008fc07de7cffa868635165bee9a1`.
  Platform: Linux ARM64 in the same qualified container/VM boundary as Phase 01;
  no native macOS or x86_64 independent-check qualification is claimed.
- Plan/prerequisite handoffs: unchanged Phase 01 and 02 handoffs at `cb29859`;
  exact handoff and assignment digests are retained with implementation inputs.
  No receipt-policy ID or Pudding `proved` receipt exists in this phase.

## Delivered behavior

- [Proof recipe](../../proof/validator/README.md) describes the private checked
  scanner invariant, arbitrary-byte/reference connection, normal-return proof,
  exact domains and reached-operation/purity inventory. Only the final binary
  and wrapper proof entry points are public. No generated executable body is
  edited; no runtime/dependency file is patched and no second semantics is added.
- The ordinary fixture's fixed/vulnerable/reference implementations are unchanged.
  Law proof options use the public `Lynx.Laws.verify/2` postlude mechanism.
  `ProofQualification` is a deliberately manual feasibility harness, not a
  generic adapter/checker. It demands fresh, uncached complete reports and exact
  generated statements and predicates. Missing binary law, empty inventory,
  cached or skipped reports fail its completion predicate.
- Eleven harness tests combine eight ordinary production consumer tests and
  three proof/control tests: fixed two-law success, concrete BEAM witnesses plus
  invalid-replacement/strengthened-domain controls, and transitive `sorryAx`
  rejection. Each output subdirectory must be new; no stale export can qualify.
- Clean Linux launcher/qualifier retain the actual BEAM, debug chunks, compile
  information and Core recovered with the same public `:core_v1` debug callback
  used by Lynx, including reached OTP `lists`; generated Lean, full original
  export, source archive, reports and check logs. Manual manifest preparation is
  explicit. General capture/provenance remains Phase 04.
- CI runs the exact proof/control harness after ordinary consumer qualification;
  it is explicitly not the independently qualified checking platform. Existing
  checks and pinned tools remain in place.

## Gate checklist and validation

Retained run and file identities: [Linux evidence manifest](../../proof/validator/evidence/linux-arm64-2026-11-16/MANIFEST.md).
Commands below run from repository root except the consumer `cd`. Host commands
use `mise exec --` to honor `.tool-versions`; the qualified image pins the same
Elixir/OTP and Lean versions. The host's unrelated default Elixir is not used.

- [x] Actual fixed binary interface, full-domain exact acceptance/output/rejection,
  with normal return: checked induction over arbitrary finite byte lists and
  arbitrary separated components. Both target and reference return `.ok` of
  the specified result; exact equality therefore returns `.ok true`. No length,
  validity, exhausted-computation or corpus premise. The retained generated
  executable expectation, theorem statement and report bind this proof.
- [x] Separate full nonbinary wrapper, including non-byte-aligned bitstrings:
  cases over every `Lynx.Term` constructor and the bit-alignment split. Both
  required laws export together and are included in the complete kernel replay.
- [x] Original BEAM `".."` returns `{:ok, [".."]}`, while accepted reference/fixed
  reject. Executable vulnerable law raises `expects returned false`; its attempted
  universal proof fails elaboration and exports nothing. Reject-all and sanitized
  output fail on `"a/b"`. Stronger requirements exclude `".."` and differ from the
  authorized generated guard, so cannot count. Missing/empty/cached/skipped law
  inventory is rejected. Admitted transitive helper is rejected for `sorryAx`.
- [x] Fresh export, exact statement and assumption audit, all six independent
  checker outcomes, clean offline replay and artifact identity verification:
  final run **exit 0**; export SHA256
  `e8b428eb115775ccadf8f98c2e484423078e9ba3a491aabb36d53e6572935da2`.
  Full 34,351,530-byte export is retained losslessly. All six checkers accept;
  transitive audit lists only `propext`, `Quot.sound`, `Classical.choice`.
  Original source archive byte-compared file by file to final inputs; exact
  source/script/authority and raw compiled artifact digests retained.
- [x] Explicit feasibility decision, cumulative budget, final `mix precommit`:
  **go**, full original contract feasible within inherited uncapped authority.
  Final precommit **exit 0**: audits, compile, format, strict Credo, usage rules,
  compile-connected xref, docs, 14 root and 8 ordinary consumer tests.
  Production root compile **exit 0**; Dialyzer **exit 0**, zero errors/skips.
  CI's additional exact proof/control regression is distinct from independent
  replay; remote results are attached to the open implementation PR.

Failure-before evidence: default initial `rfl` failed both real law obligations
with the exact `.ok true` goals, retained in `checks/initial-proof.log`. This is
unfinished proof evidence, not a Lynx bug. Host final proof harness passed 11
checks after all helpers were made private. Malformed export aggregate exit 1;
valid-format binary-theorem tamper aggregate exit 1, all six reject. con-leche/
con-ron name a type mismatch in the required theorem; lean4lean/nanoda panic,
which is rejection but not a graceful logical diagnostic. This is not a hostile
export robustness qualification; complete diagnostics are retained.

Separate library/consumer/package checks: production root compile with warnings
as errors passed; ordinary production consumer passes without Reach. Actual
`MIX_ENV=prod mix hex.build` rejects the existing runtime Git Lynx dependency
because Hex excludes Git dependencies (exit 1, retained `checks/package.log.gz`).
This pre-existing release/packaging gap remains explicit, not suppressed or
misreported as a package pass; product packaging is Phase 13. No package was
published or dependency policy changed.

## Phase 03 question closure

A follow-up audit checked the Phase 03 assignment, shared architecture, handoff
requirements and prerequisite decisions against the proof sources and retained
evidence, rather than relying on the completion checkboxes. Two read-only source
reviews found no mathematical or required-gate blocker. This was a source/evidence
audit, not a new independent-kernel run or human proof review.

| Question required by the end of Phase 03 | Answer and evidence |
| --- | --- |
| Can the ordinary compiled binary validator satisfy the entire accepted policy, not just safety examples? | **Yes.** `lemmas.lean` connects the translated reference and scanner to the same arbitrary-byte specification, proving exact ordered components or exact rejection. See [proof design](../../proof/validator/README.md#proof-and-exact-domain), generated definitions and both required theorem records in the [retained inventory](../../proof/validator/evidence/linux-arm64-2026-11-16/claim-inventory.json). |
| Does equality hide exceptions or exhaustion, or assume malicious inputs away? | **No.** Both computations return normally; the executable expectation returns `.ok true`. The binary requirement is exactly `is_binary`, with no validity, length or fuel premise. This establishes abstract totality under sufficient memory, not practical latency/allocation bounds. |
| Is the wrapper complete, including nonbyte-aligned bitstrings? | **Yes.** Its independent proof cases over every `Lynx.Term` constructor and bit alignment; its requirement is exactly `not is_binary` and result exactly `{:error, :not_binary}`. Both laws must be present together. |
| Are the accepted policy and actual implementation preserved, and is existing Lynx support sufficient? | **Yes.** Frozen candidate/reference identities and normalized law ASTs are tested; compiled implementation bytes are retained. The checked mathematical specification is connected to the generated executable definitions, not substituted for them. Public postlude/runtime APIs suffice; private helpers add no axioms, model patches, generated-body edits or unresolved upstream gap. See the [reached-operation inventory](../../proof/validator/README.md#reached-operations-and-purity). |
| Do concrete failures and substitution controls distinguish useful correctness from a vacuous pass? | **Yes.** Identified BEAM bytes replay vulnerable `..` acceptance and reject-all/changed-output witnesses. Missing/empty/cached/skipped claims and `sorryAx` fail completion. A stronger guard is rejected by exact domain/statement binding, independently of its unfinished proof attempt; failed elaboration alone is not a counterexample or a general guard-substitution detector. See the [harness](../../test/fixtures/projects/archive_path/proof_qualification_test.exs). |
| Can fresh full exports replay independently from clean retained inputs? | **Yes on qualified Linux ARM64.** Both exact laws, all six accepting checkers, the standard-three-axiom audit, clean offline build, enforced limits and malformed/tampered controls are retained in the [manifest and logs](../../proof/validator/evidence/linux-arm64-2026-11-16/MANIFEST.md). Some tamper rejections panic, as disclosed; arbitrary hostile-export robustness is not qualified. |
| Is the proof feasible within the approved cumulative budget, and what effort remains unknown? | **Go.** The inherited Phase 01–03 authority is uncapped; session/run/checker timing, resources, manual work and failures are recorded below and in prerequisite handoffs. Human labor, full token/billing totals and isolated per-kernel CPU measurements are unknown, not zero. No economics or autonomous-proof-performance result is inferred. |
| What remains trusted or unresolved, and does anything block Phase 04? | **No unresolved Phase 03 blocker.** Compiler/debug reconstruction, Lynx translation/models, tool builds and manual records remain trusted. General capture, conformance/receipt authority and hostile submission hardening are later gates. The known Hex Git-dependency packaging failure remains a Phase 13 release gate; verified translation, deployment, filesystem and practical resource guarantees are not claimed. |

The root README's stale “not completed proofs” status was corrected in this
follow-up; no proof, implementation, contract, qualification script or retained
input identity changed. The original six-check CI run at implementation head
`c98d8af0e51bdc9c3aafc229a66729b3e13b2165`
[passed](https://github.com/houllette/pudding/actions/runs/43982593855), including
the exact proof/control regression. Distributed tests and Sobelow were inapplicable
and skipped. Follow-up-head CI results are recorded on the PR; neither run is
independent-platform qualification. No new owner decision is required to close
Phase 03, and no Phase 04 work is authorized by this audit.

## Claims and trust

**Evidence outcome:** direct, independently checked model proofs for the two
accepted obligations, not a product security receipt. Binary quantification is
all finite byte sequences including empty, arbitrary non-UTF-8/NUL/dot/slash
patterns. Success is exactly the original ordered slash-split components; failure
is exactly invalid_path. Nonbinary quantification covers the full accepted domain,
including nonaligned bitstrings, and returns exactly not_binary. The model proof
accounts for normal evaluation/abstract totality under sufficient memory; it is
not a wall-time, allocation, filesystem containment, ZIP, Unicode-normalization,
symlink, or operating-system path guarantee.

Trust remains the Elixir/Erlang compiler and debug reconstruction, pinned Lynx
Core translation and public runtime models, Lean elaboration/export interfaces,
independent kernels and their executable builds, image/host VM and manually
prepared manifests. The retained compiled bytes and Core are diagnostic binding
for this trusted ordinary fixture, not proof of compiler/translation correctness.
No conformance service, deployed-code extraction attestation, general capture,
receipt authority or autonomous repair is added. Output records are writable
while elaborating and are not hardened against hostile submissions. Assumptions
are transitively audited; no additional axioms or semantic bypasses are used.

## Effort and budget

The inherited owner-reviewed cumulative Phase 01–03 authority is **“no limits all
around”** (uncapped effort/time/spend), recorded in prerequisite handoffs. No
additional paid service, dependency change or model/checker-policy authority was
inferred. There is no finite remaining allowance to subtract. Phases 01–02 retain
their own recorded measurements; unavailable measurements are not retroactively
estimated.

Phase 03 session implementation began `2026-11-16T23:13:30Z`. Work included manual
reference/scanner lemma development, statement inspection, harness/negative
controls, repeated clean exports and checker runs, evidence curation and handoff.
Human proof/setup/policy-review time, agent token totals, billed cost and host
aggregate CPU/memory were not instrumented and are **unknown**, not zero. No
upstream runtime change, backend patch or contract redesign was needed. Read-only
agent review was used for proof-scope/gate inspection; this is not independent
logical checking or a human proof review.

Failed work is retained: initial `rfl`/intermediate proof development; first
container run failed on absent `/usr/bin/time` (replaced with POSIX wall timers);
first precommit failed Credo alias style (fixed without suppression); overlapping
clean builds exhausted available thread resources in one attempt (Lean explicitly
reported `failed to create thread`), so final qualification is run alone. Earlier
successful replays were superseded to make all helpers private and retain exact
`:core_v1`/OTP-list provenance, not to narrow any obligation.

Final clean run: `2026-11-16T23:39:57Z`–`23:42:38Z`, **161 s** total;
proof harness **13 s**, full accepting checker replay **17 s**. Cgroup measured
**201.096354 CPU s**, **3,888,549,888 peak memory bytes** (~3.62 GiB), **155 peak
PIDs**, no OOM events. This includes tmpfs builds/records and controls, not just
the proof kernel. Resource limits are not usage values. Backend reports total
**1,925 ms** for the six fixed modules (906 ms postlude, named law proofs 41/1 ms).
Phase 03 elapsed implementation/qualification/curation time through
`23:46:30Z` is **33 min**, excluding later remote CI wait. That is session wall
time, not measured human labor or summed compute; failures/rework are included.
Cumulative Phase 01–03 measurements retain earlier handoffs plus these values;
unavailable token/cost/human totals remain unknown, not fabricated.

## Blockers and deviations

No confirmed Lynx-owned semantic or proof-API gap was found, so no speculative
upstream issue or local workaround was introduced. The pinned backend sufficed
via public APIs. All accepted statements, policy bytes, pins and checker policy
remain unchanged. Proof source has a new identity while the initial predicate
identity is preserved by historical-source binding and AST equality tests.

The known Hex runtime-Git packaging restriction remains a later product gate,
not a claim of a distributable Hex release. All Phase 03 gates passed, with
limits and exclusions recorded above; no unresolved blocker for direct-proof
scope. Remote CI observation lives on the implementation PR and is not a new
independent-checking platform. No Phase 04 implementation has begun.

## Next entry point

- Next permitted phase after this gate passes: **04 — Build capture**, with no
  authorization here to implement later phases automatically.
- Read this handoff, accepted contract/record, exact proof-input JSON, retained
  evidence manifest and `proof/validator/README.md` first. Revalidate current
  inputs against `implementation-input-digests.txt` and `SHA256SUMS`.
- Smoke/replay: `sh proof/validator/run.sh "$PWD/tmp/validator-new"` using the
  qualified image. Expect 11 tests, both exact laws, all six checkers accepting,
  standard three-axiom audit, malformed/tampered rejection, gate marker and exit 0.
- Preserve exact law inventory/domains, accepted policy, dependency/toolchain,
  model/checker boundary and receipt distinctions. Any changed backend/image or
  proof inputs invalidate dependent evidence until rechecked.
- No owner decision is needed for the completed direct-proof scope. New backend,
  policy, packaging or budget authority must not be inferred from this handoff.
