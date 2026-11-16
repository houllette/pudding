# Phase 01 handoff — pinned Lynx foundation

## State and identities

- State: **complete**. Gate: **passed** on the recorded Linux ARM64 platform.
  Phase 02 may begin after validating these identities; phase 02 is not started.
- Implementation branch: `phase-01-lynx-foundation`, starting revision
  `0276f3b5ce135ed08ac39b9a1fafef079c67cc1a`. The implementation commit containing
  this handoff identifies versioned bytes; the qualification input manifest
  identifies the exact pre-commit worktree/fixture bytes actually run.
- No accepted security contract, predicate digest, policy authority, product
  result category, or Pudding receipt exists. This is backend qualification only.
- Required claim: `Elixir.Foundation.Laws.laws.«involution/2»`; the only expected
  generated proof in the report inventory. Definition:
  `Elixir.Foundation.Laws.«involution:ensures/2»`, calling
  `Elixir.Foundation.Pair.«swap/1»` twice and `Erlang.erlang.«=:=/2»`.
- Actual toolchain: Elixir `1.20.2-otp-29`, OTP `29.0.2`, ERTS `17.0.2`;
  Lynx Git `99a6db764c154207cf3b28c35409d9b56c463357`;
  Lean `4.35.0` / commit `eb6cafb7290e8bd5f2937522d8d804f58f02bafc`.
  Mix/Lake transitive proof input and packaging inventory:
  [foundation.md](../../docs/verification/foundation.md).
- Model/checker policy: pinned Lynx and Lake source allow exactly `propext`,
  `Classical.choice`, `Quot.sound`. No policy change or sandbox opt-out.
  Independent binary hashes are in `qualification.log`; OS/engine and image
  identities are retained in the evidence below. Image config:
  `sha256:a9a8fdbf73d3b787505b55a6f366959aca929725da359abd0b400c2b1b2a3758`;
  image manifest:
  `sha256:adb04a68311ce73be23c8ddcfc2b779b204008fc07de7cffa868635165bee9a1`.
  This is not a product receipt-policy ID.
- Plan baseline: the phase assignment, shared architecture and references at
  the starting revision. No implementation-phase prerequisite.

## Delivered behavior

- Runtime, all-environment Git Lynx pin in `mix.exs` / `mix.lock`, and root
  `lean-toolchain`. `.tool-versions` is unchanged. No production implementation
  or Reach calls were added under `lib/`.
- Standalone ordinary production consumer under
  `test/fixtures/projects/foundation`, depending on Pudding by path and Lynx
  transitively. Its manually run ExUnit script asserts no Reach, correct pinned
  tool availability, one universal tuple-swap involution law, a false-law
  rejection, and transitive `sorryAx` rejection. Root test filtering excludes
  nested consumers and their dependency tests for relative, `./` and absolute
  path spellings. This does not suppress any root Pudding tests.
- ARM64 Linux bootstrap, clean offline build/export/paranoid-check recipe under
  `proof/foundation`. The source bundle uses ordinary Git metadata and Mix SCM
  lock checks (revision **and declared origin URL**), not a lock bypass.
- Trust/license/environment/packaging documentation in
  [foundation.md](../../docs/verification/foundation.md), distinguishing source
  inspection from observed tests and independent logical validity from capture,
  statement authority and real-BEAM correspondence.
- CI receives checksum-pinned x86_64 Lean build tooling. That is not the ARM64
  proof qualification. Existing audit findings required updating Bandit and
  Tidewave locks, with their ordinary resolved Nimble/Telemetry/Websock-adapter
  transitive locks; no dependency constraints or security suppressions changed.

## Gate checklist and validation

Retained evidence: [Linux ARM64 run manifest](../../proof/foundation/evidence/linux-arm64-2026-11-16/MANIFEST.md).
Its `SHA256SUMS` covers all retained artifacts; `implementation-input-digests.txt`
binds the versioned source and scripts. A compressed original source archive
and full export are retained, not just a successful exit code.

- [x] Exact Pudding pins and pinned Lynx/toolchain build in a clean consumer;
  actual invoked versions and transitive inputs retained in `qualification.log`,
  `os-packages.txt`, source archive and Lynx Git-tree manifest.
- [x] The small true law verifies; false control fails for the intended reason:
  four consumer tests passed, exact one-theorem inventory and unconditional
  statement, false `rfl` elaboration error, admitted `sorryAx` error; no negative
  exports. Reports and generated Lean are retained.
- [x] Fresh export independently rechecks under the recorded axiom policy and
  enforced environment: `checker.log` records all six accepting kernels and
  exactly the three standard axioms. Malformed-export control exits 1 with actual
  parser errors (not missing tool or sandbox failure).
- [x] Trust inventory distinguishes logical checking from translation/BEAM
  correspondence: foundation.md source audit; startup probes passed in the
  same run. Explicit containment limitations remain documented.
- [x] Dependency approval, licenses, bootstrap, phases 01–03 budget/effort, and
  final `mix precommit` evidence retained. `precommit-final.log` passed strict
  Credo, audits, formatting, compile/xref, usage rules, docs and two root tests.

Final commands/results (working directory: repository root):

- `sh proof/foundation/run.sh "$PWD/tmp/foundation-linux-14"`: exit 0,
  `FOUNDATION_GATE_PASSED`, `2026-11-16T21:39:19Z`–`21:40:51Z` (**92 s** whole
  run, including clean library/native runner build and controls). No host build
  cache or online dependency resolution. All six checker acceptance lines and
  `Uses axioms: propext, Quot.sound, Classical.choice` retained. Fresh export
  SHA256: `1c16df66c3fc14fa4d186bfdee4f5a9b55fea6a3e9b3b9f3597c1b916503b842`.
- `mise exec -- mix precommit`: exit 0 after that exact run; final log retained.
  `mise exec -- mix dialyzer`: exit 0, zero errors; final log retained.
- `mise exec -- mix test ./test --warnings-as-errors` and the equivalent absolute
  `$PWD/test`: both passed two root tests, confirming nested projects are excluded.
  `sh -n proof/foundation/{bootstrap,run,qualify}.sh`,
  `mise exec -- mix format --check-formatted`, and `git diff --check` passed.
- The archived source and all three retained qualification recipe files were
  byte-compared to the final worktree before committing; matches confirmed.
- Pre-merge review repeated `sh proof/foundation/run.sh "$PWD/tmp/foundation-pr-review"`
  against unchanged source/recipe inputs and the same qualified image: exit 0,
  `FOUNDATION_GATE_PASSED`, `2026-11-16T21:57:48Z`–`21:58:56Z` (**68 s** whole
  run). Four tests, all six kernels, the three-axiom audit and malformed-export
  rejection passed again; the full fresh export had the same SHA256 as run 14.
  `review-qualification.log` retains the complete new run. Review also verified
  all original evidence/input/source hashes, source archive bytes and 539,149
  complete export JSON records, and checked that the launcher rejects an existing
  output directory. `mise exec -- mix precommit` and `mise exec -- mix dialyzer`
  passed again; transcripts are `review-precommit.log` and `review-dialyzer.log`.

Failure-before and packaging observations (not omitted from accounting):

- Host initial three-control smoke passed before the stronger admitted/statement
  controls; host smoke is not Linux independent evidence.
- Clean Linux run 11: ordinary production consumer compiled, four ExUnit tests
  passed, fresh 27,192,750-byte export generated. Independent checking correctly
  failed closed at sandbox startup: `bwrap: Can't mkdir /run/user: Read-only
  file system`. The image now provisions that empty mount point, and the early
  probe exercises Lake's actual hide-home/runtime/tmp layout. Runs 12–14 then
  passed independently; run 14 binds the final fixture filename and scripts.
  The pre-fix `run-11-checker-failure.log` is retained.
- Strict Credo rejected the temporary manual test filename `qualification.exs`;
  it was restored to `qualification_test.exs`, not suppressed. Root test filtering
  excludes nested projects in both load and ignore filters (load overrides ignore).
  Final precommit passed with the conventional filename.
- Actual `mix hex.build` failed because runtime Git dependencies cannot be
  published on Hex. Pre-merge review reproduced this with
  `mise exec -- mix hex.build` from the repository root: exit 1, explicitly naming
  `lynx` as excluded because only Hex packages can be dependencies. The complete
  transcript is retained losslessly as `review-hex-build.log.gz` in the evidence
  directory. Current supported consumption is Git/path, not Hex package release;
  package qualification remains phase 13. No successful Hex build is claimed.
- Remote CI and PR identities are recorded in the PR checks, not substituted
  for the local ARM64 independent-check evidence. See the final delivery report
  for the actual PR URL and observed remote status.

## Claims and trust

The unconditional theorem universally quantifies two `Lynx.Term` arguments
and proves double swap on their constructed pair returns `Except.ok true`.
It excludes non-pair calls, arbitrary OTP behaviors, resource/latency guarantees
and every security/path contract. No `requires` hypothesis, finite-input
restriction, cutoff, alternate semantics, prelude, postlude or admitted proof
is used for the positive obligation. Concrete BEAM checks are conformance
examples only. The false expectation has the real BEAM counterexample
`{1, :different}`; this is not an archive-path violation.

Fresh export bypasses Lynx's ordinary cache. Required inventory and exact
unconditional theorem header are checked; old output paths are rejected. Both
false/admitted cases must lack exports. This covers one deliberately fixed
trusted fixture, not phase 06's general hostile statement binder.

New trust includes Core reconstruction/debug callbacks, compiler/translation,
Lynx runtime equality/tuple definitions, purity/partiality interpretation,
imports/elaborators/exporter and cache/axiom audit, Lean/Lake/checker binaries,
BEAM/OTP/JIT, OS/VM/container engine and trusted launcher. Independent kernels
validate the export's logical closure, not the accuracy or authority of its
statement or identity to executed BEAM. Full source map, logical assumptions,
license notices, sandbox settings and explicit limits are in foundation.md.
Writable-output diagnostics are not independently protected receipts. Hardening
of hostile build capture and evidence finalization remains phases 04/06.

## Effort and budget

**Owner authority:** explicitly approved the Git Lynx revision and Lean 4.35.0
before dependency changes. Asked for a cumulative phases 01–03 ceiling and
paid-run limits, owner answered **“no limits all around”**. Recorded ceiling:
uncapped for effort, wall time and spend across 01–03. No finite remaining
allowance can be calculated. This is not permission to broaden the contract or
skip a gate. Phases 02/03 have not started.

This is agent-driven, manually prepared feasibility evidence, not autonomous
proof/repair performance. Human active minutes and parent-agent billing/token
counts were not instrumented and are **unknown**, not zero. Observed branch
implementation window starts about `2026-11-16T21:12:08Z`; investigation and
approval began earlier. Final clean qualification finished `21:40:51Z` (~29 min
from that branch event), followed by evidence review/docs and PR preparation.
The final delivery message timestamp bounds the remaining elapsed work.
Parallel work overlaps; do not sum estimates into a precise person-hour total.

| Category | Work / measured evidence | Time/cost accounting |
| --- | --- | --- |
| Backend setup | Pinned Mix/Git/Lean; consumer; ARM image/Hex bootstrap; offline SCM lock handling | Dominant elapsed implementation work; exact active time unmeasured |
| Capture/adapter | No product adapter; allowlisted source archive, Git bundle, digests and trusted-fixture launcher | Included in implementation window; no phase 04 capture claim |
| Policy/contract review | Phase boundary, tuple law statement and trust/license review; no security policy frozen | Exact active time unmeasured |
| Handwritten proof/lemma preparation | One explicit positive `simp` proof over swap/equality; intentionally false `rfl`; admission `sorry`; no new runtime lemma | One positive obligation, two controls; not autonomous synthesis |
| Upstream gaps/runtime changes | No Lynx source edits, dependency patches or upstream semantic work | Zero upstream patches; no unresolved Lynx issue confirmed |
| Repair/setup failures | macOS lacks Linux bwrap; VM SELinux/proc, shared filesystem mounts, OTP archive format, origin mismatch, missing `/run/user`, log plumbing | Failed attempts retained/recorded; not excluded from effort |
| Independent checking | Clean Linux six-kernel full-closure checking plus malformed-export control passed in final run 14 (and prior corrected runs 12–13) | Final whole run 92 s; checker-only CPU/wall/peak RSS not separately instrumented; limits explicit, not measurements |
| Independent review | Initial two read-only repository-scout audits; latest found real sandbox mount-point failure | Reported API-equivalent cost $0.255624 + $0.297874 = $0.553498; not a billed invoice or full session cost |
| Pre-merge review | Two further read-only audits of implementation/fail-closed controls and assignment/evidence completeness; no technical blocker, missing packaging transcript corrected | Combined 457,545 input / 8,640 output tokens, including repeated context; reported API-equivalent cost $0.930998, not actual billed spend; parent review tokens/time unknown |
| Local project checks | Precommit, production build, consumer and Dialyzer; dependency security remediation | Actual log outcomes retained at completion; no paid external prover |

Additional bootstrap/image/CPU/download/storage charges were not exposed by the
local tooling. Actual monetary total is **unknown**. There is no reason to
present the subagent API-equivalent estimate as the total billed cost. The
enforced 4 CPU / 6 GiB limits are caps, not resource usage observations.

## Blockers and deviations

- **No unresolved phase 01 qualification blocker.** Phase 02 is permitted; no
  byte-validator feasibility or later product gate is implied by this pass.
- Linux ARM64 is the qualified platform, not macOS native or Linux
  x86_64. Nested user namespaces required explicit VM SELinux/seccomp mount
  allowances; these weaken defense in depth and are disclosed, not hidden.
- Clean Hex bootstrap needed source compilation under the unchanged OTP pin;
  ordinary Git lock checking needed restoration of the declared upstream URL
  after offline bundle clone. Neither modifies Lynx or weakens semantics.
- The checker's required mount points must exist in the read-only image.
  Provisioning directories fixes our environment, not an upstream Lynx gap.
- No verified Lynx-owned limitation requiring a report, private API bypass,
  local semantic workaround or checker-policy change was encountered. No
  upstream issue was filed and no dependency source was changed. If later
  byte-validator work reveals one, follow AGENTS.md's upstream-first procedure.
- Mutable apt repositories, host VM/kernel identity and nondeterministic timings
  are explicit build inputs/limits. A new image/backend/toolchain or changed
  fixture requires fresh exports/checks, not reuse of these results.

## Next entry point

- Next permitted phase: **02 — Freeze the policy and ordinary consumer fixtures**.
  Validate this handoff/evidence and unchanged pins first. Phase 03 still depends
  on phase 02's explicit contract; the tuple law does not replace it.
- Read this handoff, `docs/verification/foundation.md`, `proof/foundation/*`, the
  phase assignment and architecture before editing.
- Replay from repo root:
  `sh proof/foundation/run.sh "$PWD/tmp/foundation-replay-NEW"` after bootstrap;
  expect four fixture tests, six accepted kernels, malformed export rejection,
  the gate marker and exit 0. Any missing tool or different result blocks.
- Preserve exact pins, unconditional obligation, standard-axiom policy, fresh
  output, real independent sandbox and Git/path-only packaging disclosure.
- No additional owner decision is needed for the approved scope/budget. Hex
  release, contract/semantic changes and later phases require their own gates.
