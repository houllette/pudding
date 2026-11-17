# Retained partial Phase 04 qualification — Linux ARM64, 2026-11-17

**Capture and fixture-replay evidence, not Phase 04 closure or a product receipt.**
The review refresh supersedes the earlier capture/replay identities after two local
BEAM provenance fixes. Historical check logs remain labelled below; current
qualification uses the `review-*` capture/replay logs and refreshed archives.
The latest documentation/test-call revision is checked by `upstream-scope-*`
logs. The unchanged container policy/isolation driver reuses its qualification.
See [the handoff](../../../../implementation/04-build-capture/HANDOFF.md) and
[upstream request](../../../../implementation/04-build-capture/UPSTREAM.md), now
posted with owner approval as [josevalim/lynx#20](https://github.com/josevalim/lynx/issues/20).
Only the approved issue text was published upstream; no upstream PR was opened.
An ownership review narrowed that draft to a supported translation-only entry
point; capture, validation, isolation and evidence stay in Pudding. Validation
also changed one dynamically loaded test-fixture call to `Function.capture/3`
to avoid an undefined-module warning, without changing its assertions. Source
archive/digests and the handoff digest were refreshed for these revisions;
captured library/worker bytes and replay results are unchanged.
Phase 05 remains blocked. The owner requested shelving the partial delivery in a
**draft Pudding PR** on `phase04-isolated-capture-draft`, based on
`079f0b049b7689838013b185f2603b043ab72e85`. The base does not identify new bytes;
use the PR's head commit for the published snapshot and these digests for retained
source/evidence. Shelving changes only documentation and its integrity bindings,
not captured library/worker bytes or replay qualification.

## Retained runs and exact identities

All commands ran at the repository root using `mise exec --`, on a macOS ARM64
host with a Podman applehv Linux ARM64 VM (8 CPUs/8 GiB, cgroup v2), Docker CLI,
Elixir 1.20.2, OTP 29.0.2 / ERTS 17.0.2. The digest-pinned image is
`sha256:a9a8fdbf73d3b787505b55a6f366959aca929725da359abd0b400c2b1b2a3758`.
Lynx `99a6db764c154207cf3b28c35409d9b56c463357`; Lean 4.35.0 commit
`eb6cafb7290e8bd5f2937522d8d804f58f02bafc`. No backend or axiom policy change.

| Retained archive | Original output | Meaning |
| --- | --- | --- |
| `capture.tar.gz` | `tmp/phase04-capture-review-20261117T155738Z` | Complete sealed input and both artifact bundles, source/tool inventories, objects including Git and BEAM/debug/Core bytes, exact comparison, engine configurations and stage logs/execution JSON |
| `replay.tar.gz` | `tmp/phase04-replay-review-20261117T160105Z` | Complete staged replay inputs, selected BEAM identities, fresh fixed export and all required generated definitions/theorems/reports, negative-control reports, six-kernel logs, both tampered exports/logs and resource observations; no consumer rebuild |
| `isolation.tar.gz` | `tmp/phase04-isolation-final-20261117T044311Z` | All bounded probes, stdout, engine inspection results, limits/timings and absence-after-cleanup checks |
| `source.tar.gz` | Prepared worktree, not an implementation commit | Exact 86 source/config/test/driver/plan inputs named in `source-digests.txt`; includes prerequisite handoffs, accepted records, postlude and license. Excludes evidence directories and current Phase 04 handoff to avoid recursion |

Archives preserve full regular-file bytes, with lossless `gzip -n` compression,
not excerpts or rewritten evidence. Tar metadata need not be reproducible; stored
archive bytes have their own SHA256 identities. There are no image layers or
checker binaries here. The sealed input bundle contains the pinned Lynx source
and Git objects; do not treat it as an executable installation before review.
The replay has no retained Lake cache; Lake is rebuilt from those sealed sources.

### Capture

Command: `mise exec -- mix run proof/capture/run.exs NEW_CAPTURE`, exit 0.

- Input ID `d48ea6b765ab91132f6f8de3718cbc82e141a409daf0a2ef75b7d4ba3d04e5db`.
- Build 1 ID `ffffd3bce480fc4feb0524d79ff4b8036ac3d502142c74fcf465f6bc0aeca672`.
- Build 2 ID `a6b1857c2bc42feaed6b854b43e8fe6334effbac7e9fc3d0e5aafaecb753c624`.
- All three manifests validate (schema, canonical identity, exact object lengths,
  hashes and layout). **1,140 input names; 71 artifact names/build; 66 equal;
  all 39 BEAM artifact names equal.** These are named entries, not counts of
  unique modules or content hashes; requested module copies duplicate build BEAMs.
- Five changed names: `build-inventory.json`, `inspection.json`, and the
  `.mix/compile.elixir` files for archive_path, lynx and pudding. Classification
  `nondeterministic_or_undeclared_input`, no normalizations, proof reuse forbidden.
  Executable equality in this pair is not universal build determinism.
- Tools stage 39,745 ms; builds 43,746 / 46,680 ms; inspectors 1,220 / 1,230 ms.
  These stage observations are not whole-session effort measurements.
- Input metadata binds staged regular/directory types, permissions, size/hash and
  empty directories. Source quiescence is assumed; no ownership/timestamp/ACL,
  snapshot/TOCTOU, deployed-BEAM correspondence or complete ambient-input claim.
- Writables include a 713-entry, 365,880,692-byte Lake cache inventory only;
  its bytes are not retained as reusable cache. The inputs bundle separately
  retains trusted sources for fresh tools. General closure inspection remains
  `blocked_supported_lynx_api_required`.

### Fixed-byte replay

Command: `mise exec -- mix run proof/capture/replay.exs CAPTURE NEW_REPLAY`, exit 0,
`CAPTURED_FIXTURE_REPLAY_PASSED_NOT_PHASE04_CLOSURE`. Bound exactly to input/build 1
above. **11 tests pass** in the existing Phase 03 qualification harness, including
full exact required statement checks, vulnerable/reject-all/changed-output/
strengthened-precondition/admitted-helper controls and production behavior.

Only 11 explicitly selected BEAMs are used: nine fixture modules, accepted policy,
and image OTP `lists`. Consumer/predicate path and content must match capture;
`lists` uses the exact pinned-image bytes. Trusted Lynx is rebuilt independently.
No consumer source recompilation or consumer Mix evaluation occurs, and absence
of a consumer `_build` is asserted. This is a fixture driver, not general replay.

- Required full-domain claims: `ArchivePath.Laws.binary_contract/1` and
  `ArchivePath.Laws.nonbinary_wrapper/1`, unchanged accepted
  `pudding.archive_path.bytes/v1`; see sealed sources, exact statement assertions,
  `fixed/reports.txt`, generated definitions and `fixed/**/laws.lean`.
- Fresh complete export: `fixed/proof.ndjson`, **34,351,530 bytes**,
  SHA256 `e8b428eb115775ccadf8f98c2e484423078e9ba3a491aabb36d53e6572935da2`.
- `checker.log`: Lean paranoid, lean4lean, nanoda, con-leche, con-ron, Lean default
  all accept; audit exactly `propext`, `Quot.sound`, `Classical.choice`.
- `malformed.ndjson` / `malformed-checker.log`: aggregate check exits 1 with
  actual parser rejection. Some importers accept the empty declaration set; that
  is **not** a valid nonempty required-theorem export or universal rejection by
  every kernel.
- `tampered.ndjson` / `tampered-checker.log`: valid JSON with binary-contract
  theorem value replaced by expression 0; aggregate exits 1, all six reject,
  actual type-check rejection rather than sandbox/setup failure. Nanoda reports
  its kernel assertion failure; no timeout/tool-not-found is counted as rejection.
- Total replay wall **150,308 ms**; cgroup CPU **166,642,912 µs**;
  memory peak **3,214,589,952 bytes**; pids peak **149**, no OOM events. Kernel
  timings are not separately instrumented beyond individual tools' own logs.

### Isolation

Command: `PHASE04_HOST_SENTINEL=must-not-enter-guest mise exec -- mix run
proof/capture/isolation.exs NEW_ISOLATION`, exit 0, `ISOLATION_PROBES_PASSED`.
Trusted probes exercise the same outer policy; they are not an exhaustive hostile
consumer assessment. No sockets/token forwarding, UID 1000, only loopback,
public-IP TCP denied, root/inputs read-only, nested bwrap restrictions checked.

| Probe | Observed outcome | Elapsed including cleanup |
| --- | --- | ---: |
| Boundary | passed assertions | 751 ms |
| Detached descendant | `setsid` child started, 2 s timeout, container absent | 12,178 ms |
| Output | explicit output limit at 4,096-byte cap | 195 ms |
| Memory | printed 134,217,728-byte cgroup limit, allocation exit 137 | 819 ms |
| Storage | 1 MiB tmpfs rejects 4 MiB write | 595 ms |
| Pids | limit 32, fork failure | 716 ms |

All probe containers removed. `--rm` means exited/OOM engine state was not retained;
no claim that OOMKilled inspection independently confirmed the kill. Final
`cleanup.txt` records no capture/replay/probe containers or token volumes; unrelated
jump services, BuildKit and their volumes were preserved. A 2 s execution timeout
is not a guarantee of 2 s total return time during engine teardown.

The qualified policy deliberately permits seccomp-unconfined, label-disable and
unmask-ALL for bwrap. Trust includes the VM/kernel/image/engine and permitted
OTP/Elixir debug callbacks; these probes do not erase those boundaries. Hashes
of debug/Core provenance do not prove executable BEAM correspondence.

## Other evidence

| Files | Meaning |
| --- | --- |
| `checks/draft-pr-precommit.log.gz` | Fresh local precommit after the draft-shelving review/documentation updates: 38 root checks and 8 production-consumer tests pass; dependency compilation warnings remain visible, no new capture/replay run |
| `capture.json`, `isolation-results.json`, `replay-execution.json`, `replay-resource-usage.txt` | Convenient exact copies of archive summaries; not alternate receipts |
| `checks/review-regressions-before.log.gz` | Both new regressions fail on the reviewed code: duplicate chunks are accepted and loaded replacement code is not detected |
| `checks/review-regressions-after.log.gz`, `checks/review-targeted.log.gz` | Both fixes pass; focused BEAM tests 5 pass; project/execution suite 24 pass with warnings-as-errors |
| `checks/upstream-scope-precommit-final.log.gz`, `checks/upstream-scope-beam.log.gz` | Latest full precommit passes (38 root checks, 8 prod consumer tests); focused BEAM suite 5 pass with warnings-as-errors after the test-call adjustment |
| `checks/upstream-scope-precommit.log.gz` | Earlier run exposed an undefined-module warning at the dynamically loaded test-fixture call; assertions passed but root warnings-as-errors rejected the suite; corrected before the final run |
| `checks/upstream-scope-public-api.log.gz` | Expected public no-laws boundary rerun during the narrowed API review; not a translator bug reproducer |
| `checks/review-precommit-final.log.gz` | Precommit for the prior test-call form: audits/compile/format/Credo/docs/usage-rules/xref, 38 root checks (1 doctest/37 tests), 8 ordinary prod consumer tests |
| `checks/review-precommit.log.gz` | Intermediate lint failure (`apply/3` with known arity) corrected before the final precommit; not a passing check |
| `checks/review-dialyzer.log.gz` | Current project PLT/toolchain, zero errors and zero skipped warnings, exit 0 |
| `checks/review-bundle-validation.log.gz` | Current three bundles validate; exact comparison counts; all 12 current library/capture-script regular files equal sealed input bytes |
| `checks/review-capture.log.gz`, `checks/review-replay.log.gz` | Current original host stdout logs, not excerpts |
| `checks/review-public-api.log.gz`, `checks/review-upstream-issues.json.gz`, `checks/review-upstream-main.txt.gz` | Refreshed expected no-laws boundary; all 13 issues checked and upstream main equals the pin; recorded before #20 was posted |
| `checks/targeted-final.log.gz`, `checks/precommit-final.log.gz`, `checks/precommit-handoff.log.gz`, `checks/dialyzer-final.log.gz` | Historical pre-review checks, superseded by `review-*` checks for changed bytes |
| `checks/package-final.log.gz` | Expected inherited exit 1: Hex rejects Git runtime dependency `lynx`; correct package file list is not a produced/installable package |
| `checks/public-api.log.gz` | Historical expected no-laws boundary |
| `checks/filesystem-input-before.log.gz`, `checks/input-regressions-before.log.gz` | Meaningful failing tests before filesystem inventory and referenced-input/staging/resource fixes |
| `checks/final-capture.log.gz`, `checks/replay-final.log.gz`, `checks/bundle-validation.log.gz`, `checks/source-binding.log.gz`, `checks/archive-validation.log.gz` | Historical pre-review capture/replay/validation; not qualification of the changed current source |
| `checks/isolation-final.log.gz` | Unchanged isolation-driver/policy qualification stdout |
| `checks/review-archive-validation.log.gz` | All current regular archive members byte-match originals, no symlink/special members; local handoff/evidence links exist |
| `source-digests.txt`, `source.tar.gz` | Exact prepared implementation and driver identities, including the upstream request and fixture proof inputs |
| `handoff-digest.txt` | Root-relative SHA256 of the partial Phase 04 handoff (not inside the source archive) |
| `lean-LICENSE.txt.gz`, `lean-LICENSES.txt`, `lynx-LICENSE.txt` | Retained original release notices and source license, not binary redistribution compliance |
| `SHA256SUMS` | All evidence-file identities except itself; no signature or receipt authority |

The unchanged image/checker/license identity inventory is in
[Phase 01 qualification](../../../foundation/evidence/linux-arm64-2026-11-16/MANIFEST.md)
and its source/binary/version hashes. The full-domain proof/import policy is in
[Phase 03 qualification](../../../validator/evidence/linux-arm64-2026-11-16/MANIFEST.md).
No package release was completed. These retained local logs are not remote CI
evidence; consult the draft Pudding PR for its current hosted checks. Complete
session human labor, tokens, billing and cost are unmeasured. Repeated superseded captures
and a cancelled attempt under ignored tmp are not promoted to final evidence;
only the final IDs here are authoritative for this partial delivery.

## Verify and replay

From this evidence directory:

```sh
shasum -a 256 -c SHA256SUMS
```

From the repository root:

```sh
shasum -a 256 -c proof/capture/evidence/linux-arm64-2026-11-17/source-digests.txt
shasum -a 256 -c proof/capture/evidence/linux-arm64-2026-11-17/handoff-digest.txt
mkdir -p tmp/review-phase04/capture
# These are the reviewed, checksum-verified archives made here, not a consumer tar.
tar -xzf proof/capture/evidence/linux-arm64-2026-11-17/capture.tar.gz -C tmp/review-phase04/capture
mise exec -- mix run -e 'for n <- ~w(inputs build-1 build-2), do: IO.puts(Pudding.Project.Manifest.load!("tmp/review-phase04/capture/" <> n)["id"])'
mise exec -- mix run proof/capture/replay.exs "$PWD/tmp/review-phase04/capture" "$PWD/tmp/review-phase04/replay"
```

Use fresh output paths. Linux can replace `shasum -a 256` with `sha256sum`.
Replay requires the qualified engine/image and current driver bytes matching
`source-digests.txt`; inspecting retained files alone requires neither solver nor
network. Expect six accepting kernels, the exact three axioms, required statement
checks, both rejection controls, fixture-only marker and exit 0. Do not reinterpret
that marker as Phase 04 closure. Future backend/image/input changes require new
identities and dependent-evidence invalidation; no cross-build proof reuse exists.
