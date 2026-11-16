# Retained phase 01 qualification — Linux ARM64, 2026-11-16

This is **backend qualification**, not a security-contract proof or production
Pudding receipt. See [the handoff](../../../../implementation/01-lynx-foundation/HANDOFF.md)
and [trust/bootstrap documentation](../../../../docs/verification/foundation.md).

## Observed run

- Command from repository root:
  `sh proof/foundation/run.sh "$PWD/tmp/foundation-linux-14"`.
- UTC start `2026-11-16T21:39:19Z`; finish `2026-11-16T21:40:51Z`: **92 s** elapsed
  whole run. Exit **0**, `FOUNDATION_GATE_PASSED`. Individual CPU/memory/checker
  durations were not instrumented; enforced limits are not usage measurements.
- ARM64 Linux, Elixir 1.20.2 / OTP 29.0.2 / ERTS 17.0.2, Lean 4.35.0 commit
  `eb6cafb7290e8bd5f2937522d8d804f58f02bafc`.
- Lynx Git `99a6db764c154207cf3b28c35409d9b56c463357`.
- Image config `sha256:a9a8fdbf73d3b787505b55a6f366959aca929725da359abd0b400c2b1b2a3758`;
  manifest `sha256:adb04a68311ce73be23c8ddcfc2b779b204008fc07de7cffa868635165bee9a1`.
  Build recipe is `../../Dockerfile`; exact engine/kernel in `container-version.txt.gz`
  and `qualification.log`, package versions in `os-packages.txt`. These inputs
  remain trusted; this is not a bit-reproducible image build attestation.

## Evidence inventory

| Files | Meaning |
| --- | --- |
| `qualification.log`, timestamps, `exit-status.txt` | Original whole offline run log, version/binary hashes, executable sandbox probes, clean build, four consumer tests and independent checker results |
| `checker.log` | All six actual accepting checker outcomes plus standard axiom audit: `propext`, `Quot.sound`, `Classical.choice` |
| `true/reports.txt`, `true/Elixir/**` | Exact nonempty, uncached report inventory and generated definitions/required unconditional theorem; only `involution/2` |
| `false/reports.txt`, `false/Elixir/**` | Intended false-law `rfl` elaboration rejection; no export |
| `admitted/reports.txt` | Explicit transitive `sorryAx` rejection; no export |
| `malformed.ndjson`, `malformed-checker.log` | Aggregate check exits 1 with nanoda/con-leche/con-ron parser rejections; some other importers accept an empty declaration set, not a valid required theorem |
| `true/proof.ndjson.gz`, `export-digest.txt` | Complete original fresh export compressed losslessly, **27,192,750 bytes** uncompressed; not an excerpt |
| `source.tar.gz`, `input-digests.txt` | Exact allowlisted original source archive compressed losslessly; includes Mix/consumer locks, toolchain pins, library, fixture, test script |
| `implementation-input-digests.txt` | SHA256 of every archived source file plus versioned bootstrap/launcher/qualifier/Dockerfile; paths relative to repository root |
| `source-digests.txt`, `beam-digests.txt` | Original in-container source and compiled artifact hashes, with original scratch paths; hashes do not claim independently reproduced BEAM bytes |
| `lynx-git-tree.txt`, `lynx-source-sha256.txt`, `lynx-lake-manifest.json` | Complete committed Lynx Git tree and individual source SHA256s; no Mix dependencies or external Lake packages |
| `lean-LICENSE.txt.gz`, `lean-LICENSES.txt`, `license-digests.txt`, `lynx-LICENSE.txt` | Original release notices and source license, not a substitute for binary redistribution compliance |
| `precommit-final.log`, `dialyzer.log` | Final local project checks after final qualification source/filename; both exited 0, Dialyzer zero errors |
| `run-11-checker-failure.log` | Actual failure-before evidence: all six sandbox startups rejected missing `/run/user` under read-only root; fixed by provisioning an image mount point, not disabling sandbox |
| `review-qualification.log`, `review-precommit.log`, `review-dialyzer.log`, `review-hex-build.log.gz` | Supplemental pre-merge review on the unchanged implementation: repeat clean six-kernel qualification passed in 68 s with identical full export; project/type checks passed; expected Hex runtime-Git packaging rejection retained losslessly (exit 1) |
| `SHA256SUMS` | Integrity hashes of all retained files except itself; no independent signature or product receipt authority |

`implementation-input-digests.txt` was checked against the final worktree before
commit. The source archive was also byte-compared file-by-file to that worktree.
`run.sh`, `qualify.sh` and Dockerfile retained in the full ignored output matched
versioned recipe bytes. The implementation commit identifies those same files,
not a future assumed revision. Documentation edits do not change the run inputs.

No Lean binaries, 4.6 MiB Lynx Git bundle, large downloaded archives or image
layers are committed. The full local run under ignored `tmp/foundation-linux-14`
retains the original bundle/scripts/archive too; it is not required for replay.
The bundle is identified in `input-digests.txt`; its Git packing may differ on
rebuild. Restore the dependency from its pinned Git revision and verify its
source manifest instead. Compressed files have deterministic gzip headers;
`SHA256SUMS` identifies their stored bytes separately from uncompressed inputs.

## Verify retained identities

From this evidence directory (Linux SHA256 tools):

```sh
sha256sum -c SHA256SUMS
gzip -dc true/proof.ndjson.gz | sha256sum
# 1c16df66c3fc14fa4d186bfdee4f5a9b55fea6a3e9b3b9f3597c1b916503b842
gzip -dc source.tar.gz | sha256sum
# a984f766d94e5287f7451158f2808d34aa8cb7b7c79bdc561b58c24de84ae8b7
```

From the repository root:

```sh
sha256sum -c proof/foundation/evidence/linux-arm64-2026-11-16/implementation-input-digests.txt
(cd deps/lynx && sha256sum -c ../../proof/foundation/evidence/linux-arm64-2026-11-16/lynx-source-sha256.txt)
```

On macOS replace `sha256sum` with `shasum -a 256`.
To recheck the retained export, decompress it to a NEW output directory's
`true/proof.ndjson`, then use the same pinned image, outer limits/isolation and
Lake command documented in foundation.md. For a stronger clean rebuild, run the
normal `bootstrap.sh` / `run.sh` recipe into new directories; expect all four
tests, all six kernel acceptance lines, the three-axiom audit, malformed control
rejection, gate marker and exit 0. Different paths, seeds, archive metadata and
BEAM hashes are possible; any changed backend/image/policy needs requalification.

The output mount is writable during compilation/elaboration. Its reports and
hashes are diagnostic records reviewed against this trusted fixed fixture, not
protected receipts from hostile submissions. That hardening and general
statement authorization remain phases 04/06. This run qualifies neither native
macOS checking nor the x86_64 CI platform as independent proof evidence.
