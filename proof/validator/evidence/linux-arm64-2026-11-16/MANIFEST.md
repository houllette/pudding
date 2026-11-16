# Retained Phase 03 qualification — Linux ARM64, 2026-11-16

This is a direct feasibility proof of the actual ordinary compiled validator's
accepted full-domain contract, **not a Pudding receipt or verified translation**.
See the [handoff](../../../../implementation/03-validator-proof/HANDOFF.md) and
[proof/replay recipe](../../README.md).

## Observed run and immutable inputs

- Root command: `sh proof/validator/run.sh "$PWD/tmp/phase03/linux-06"`.
- UTC start **2026-11-16T23:39:57Z**, finish **2026-11-16T23:42:38Z**:
  **161 seconds** whole run; exit **0**, `VALIDATOR_GATE_PASSED`.
- Clean offline production consumer; **11 tests passed**, exact two uncached
  required laws exported. Proof harness wall **13 s** (including controls);
  full six-checker accepting replay wall **17 s**. Individual fixed translation/
  elaboration wall timings are in `fixed/reports.txt`: six module totals sum to
  **1,925 ms**, of which the postlude is 906 ms; named binary/wrapper proof
  timings 41/1 ms. These are backend-reported times, not isolated CPU benchmarks.
- Container cgroup usage through the last control, `resource-usage.txt`:
  **201.096354 CPU seconds** (163.665328 user / 37.431026 system),
  **3,888,549,888 bytes peak memory** (~3.62 GiB), peak **155 PIDs**;
  zero memory OOM events. Memory includes the clean tmpfs build and records;
  this is container aggregate use, not proof-kernel-only or whole-host use.
- ARM64 Linux, Elixir 1.20.2, OTP 29.0.2, ERTS 17.0.2, Lean 4.35.0 commit
  `eb6cafb7290e8bd5f2937522d8d804f58f02bafc`;
  Lynx Git `99a6db764c154207cf3b28c35409d9b56c463357`.
- Image config `sha256:a9a8fdbf73d3b787505b55a6f366959aca929725da359abd0b400c2b1b2a3758`;
  manifest `sha256:adb04a68311ce73be23c8ddcfc2b779b204008fc07de7cffa868635165bee9a1`.
  Exact image/engine/kernel/package identities and checker executable hashes
  are retained. The image/VM and manual records remain trusted, not a
  bit-reproducible-image or hostile-submission capture attestation.
- Fresh full export SHA256
  `e8b428eb115775ccadf8f98c2e484423078e9ba3a491aabb36d53e6572935da2`;
  **34,351,530 bytes uncompressed**. All original bytes are retained losslessly,
  not a pruned declaration excerpt.
- Original source archive SHA256
  `be16bd98d4389a538264e00834d69a99d9b4e07b7eab7be41c563069315df3dd`.
  Its every file was byte-compared to the final worktree, as were the retained
  launcher/qualifier/Dockerfile. `implementation-input-digests.txt` adds those
  scripts, CI, contract authority records, root identity test and prerequisite
  handoffs. Documentation and evidence curation do not alter proof inputs.

## Evidence inventory

| Files | Meaning |
| --- | --- |
| `qualification.log`, timestamps, `exit-status.txt` | Original complete offline build, probes, versions, 11 tests, checks and gate marker |
| `checker.log` | All six accepting outcomes, full closure, transitive standard-only axiom audit |
| `claim-inventory.json` | Manually extracted exact two required theorem names/records and declaration-kind counts; indexes refer to the full original export |
| `fixed/Elixir/**`, `fixed/Erlang/**`, `fixed/reports.txt` | Generated executable bodies, exact original premise/expectation and `.ok true` theorem statements, checked postlude and six uncached module reports |
| `fixed/proof.ndjson.gz`, `export-digest.txt` | Complete original fresh export, compressed with deterministic gzip header |
| `ArchivePath.VulnerableLaws/**`, `ArchivePath.RejectAllLaws/**`, `ArchivePath.SanitizedLaws/**`, `stronger/**` | Noncompleting wrong-implementation/strengthened-domain reports and generated Lean; no proof exports |
| `admitted/**` | Transitive `sorryAx` diagnostic, no export |
| `beam/**`, `core/**`, `artifact-digests.txt` | Actual fixed/vulnerable/laws/reference/reached OTP lists BEAM, debug ETF, compile-info, exact `:core_v1` Core ETF and readable Core; hashes of uncompressed artifacts |
| `beam-digests.txt` | In-container compiled consumer/dependency BEAM hashes with original scratch paths; not a byte-reproducible-build claim |
| `source.tar.gz`, `input-digests.txt`, `source-digests.txt`, `implementation-input-digests.txt` | Original allowlisted source archive, original launcher input hashes, checked in-container sources, final source/script/contract/handoff bindings |
| `lynx-git-tree.txt`, `lynx-source-sha256.txt`, `lynx-lake-manifest.json` | Full committed dependency identity and source digests; no external Lake packages |
| `image.json`, `container-version.txt.gz`, `os-packages.txt`, `resource-usage.txt` | Platform/tooling/limits/observed resource use |
| `lean-LICENSE.txt.gz`, `lean-LICENSES.txt`, `license-digests.txt`, `lynx-LICENSE.txt` | Source/release notices; no checker binaries redistributed |
| `malformed.ndjson`, `malformed-checker.log` | Aggregate exit 1, parser rejection by nanoda/con-leche/con-ron; some other importers accept an empty set, not an authorized required theorem |
| `tampered-checker.log`, `tampered-digest.txt` | Aggregate exit 1 after changing exactly the binary theorem's proof-expression index to 0 in syntactically valid export v3; all six report rejection |
| `checks/*` | Host final precommit/production compile/Dialyzer, 11-test proof harness, baseline and meaningful failure-before diagnostics |
| `SHA256SUMS` | All retained stored bytes except itself; integrity manifest, not independent signature/authority |

Tamper checking reached logical failure: con-leche and con-ron explicitly report
**type mismatch in the named required binary theorem**. Lean paranoid/default
reject too; lean4lean and nanoda terminate with assertion/panic diagnostics and
are conservatively recorded as rejection, **not clean logical diagnostics from
those two tools**. There are no sandbox startup/path/permission failures. This
is sufficient negative-path evidence for this fixture but is not a robustness
qualification of arbitrary hostile exports. `qualify.sh` exactly reconstructs
the mutation; the entire redundant 34 MB modified export is not committed, and
its SHA256 remains in `tampered-digest.txt`.

`checks/linux-01-failure.log` retains missing `/usr/bin/time`, corrected to POSIX
wall timers. `checks/linux-05-failure.log` retains Lean thread creation exhaustion
under overlapping containers; the final run ran alone with the same limits.
`checks/precommit-01.log.gz` retains a fixed Credo alias-style error.
`checks/initial-proof.log` records both unfinished default `rfl` attempts, not an
upstream bug or claimed counterexample. Concrete BEAM violations are asserted
in the retained harness and passed in this run.

`checks/precommit-final.log`: exit 0, all configured checks, 14 root and 8
ordinary consumer tests. `checks/dialyzer-final.log`: exit 0, zero errors/skips.
`checks/prod-compile-final.log` is empty because compilation succeeded silently
(exit 0). `checks/package.log.gz`: expected **exit 1**, existing Hex runtime-Git Lynx
packaging exclusion; not a distributable-release pass or changed dependency.
Remote CI is recorded on the PR, separately from these local checks.

Generated `fixed/Erlang/postlude.lean.gz` and two failure logs are also compressed
to preserve their exact whitespace without introducing source-diff whitespace
errors; decompress before viewing. No downloaded binaries/image layers or Lynx
Git bundle are committed. The
original full ignored run contains the bundle; `input-digests.txt` identifies it,
but Git packing may differ on recreation. Restore the exact pinned revision and
verify its committed-tree/source digests instead. All compressed files retain
original content; `SHA256SUMS` identifies their compressed bytes separately.

## Verify / replay

From this directory:

```sh
sha256sum -c SHA256SUMS
gzip -dc fixed/proof.ndjson.gz | sha256sum
# e8b428eb115775ccadf8f98c2e484423078e9ba3a491aabb36d53e6572935da2
gzip -dc source.tar.gz | sha256sum
# be16bd98d4389a538264e00834d69a99d9b4e07b7eab7be41c563069315df3dd
```

From root:

```sh
sha256sum -c proof/validator/evidence/linux-arm64-2026-11-16/implementation-input-digests.txt
(cd deps/lynx && sha256sum -c ../../proof/validator/evidence/linux-arm64-2026-11-16/lynx-source-sha256.txt)
sh proof/validator/run.sh "$PWD/tmp/validator-new"
```

Use `shasum -a 256` instead on macOS. New output only; run qualification alone to
avoid host-wide concurrent build contention. Expect 11 tests, exact two laws,
all six accepting lines, standard-only axiom audit, negative controls failing,
`VALIDATOR_GATE_PASSED` and exit 0. The full original retained export can instead
be decompressed into a new output directory and checked using the same pinned
image, outer isolation and `lake --dir deps/lynx/Lean check --paranoid --from-export`
command. Rebuild/replay is stronger than only hashing retained records. Paths,
seeds, archive metadata and BEAM bytes may vary; any changed backend, model,
image or policy requires requalification, not reuse of an old pass.
