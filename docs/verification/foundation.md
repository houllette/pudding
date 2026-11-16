# Lynx foundation qualification (phase 01)

This qualifies one pinned backend on **Linux ARM64**. It is not Pudding's
security verifier, the phase 03 byte-validator theorem, a proof of translation
correctness, or a production `proved` receipt. The phase gate and actual run
identities live in [the handoff](../../implementation/01-lynx-foundation/HANDOFF.md).

## Rebuild and replay

Use the Elixir/OTP versions in `.tool-versions` (locally `mise exec -- mix …`),
Git, curl, and a Docker-compatible Linux engine with nested unprivileged user
namespaces and cgroup limits. The tested host uses a rootful Podman Linux VM
on macOS ARM64. **Do not run this on a shared privileged production host.**
The VM/engine/kernel and trusted launcher are part of the containment boundary.

```sh
mise exec -- mix deps.get
# Network-enabled bootstrap; downloads are checksum checked in the Dockerfile.
sh proof/foundation/bootstrap.sh "$PWD/tmp/foundation-bootstrap"
# Must be a NEW directory on a filesystem shared with the container engine.
sh proof/foundation/run.sh "$PWD/tmp/foundation-run"
```

`bootstrap.sh` needs its parent directory to exist (`mkdir -p tmp`). The image
contains Lean, the exact BEAM pins, OS tooling and a source-built Hex manager.
Hex's published 2.7.0 archive contains BEAM code rejected by OTP 29; the recipe
builds the unchanged release source with OTP 29 instead. Hex is required to
parse Pudding's Hex dependencies even though its development/test dependencies
are excluded from the production consumer. No Hex package is fetched at run time.

The launcher copies only allowlisted project source and a committed Lynx Git
bundle. It does not copy host `_build`, the mutable installed dependency tree,
`.git`, credentials, or environment variables. Inside fresh tmpfs scratch, the
ordinary consumer depends on Pudding by path; Lynx is selected transitively by
the consumer lock, with real Git metadata and ordinary Mix lock checks. No
`--no-deps-check`, sibling checkout, dependency patch, or hand-edited translation
is used. First compilation builds the Lynx Lean library/runner from source.
After the offline clone, its origin URL is restored to the declared upstream
URL because Mix correctly compares origin as well as revision; no fetch occurs.

The output includes the input archive/bundle, exact scripts/Dockerfile, image
identity, package inventory, source/BEAM/binary/export digests, generated Lean,
Lynx reports, independent-checker log and exit status. Hashes bind the observed
run, not an unavailable hypothetical reproducible BEAM build. Source paths,
random seeds, timings, archive metadata and generated BEAM can vary by rebuild.
Keep output immutable after completion. Source and scripts are also versioned;
retained repository evidence uses the compact files listed in its manifest.

ExUnit runs manually as `mix run test/qualification_test.exs` inside the production
consumer. Root Mix load/ignore filters exclude nested fixture projects (and their
dependency tests) for relative, `./`, and absolute path spellings.

The checker command inside the offline container is:

```sh
lake --dir deps/lynx/Lean check --paranoid --from-export /out/true/proof.ndjson
```

There is **no sandbox opt-out**. `--from-export` skips dependency resolution and
builds; it checks the fresh full declaration closure exported by Lynx. All six
bundled/default checker outcomes must succeed, followed by Lake's axiom audit.
An exit code alone does not establish correct statement binding. The fixture
also checks the required theorem inventory and generated statement.

## Pinned inputs and packaging

| Input | Identity / source |
| --- | --- |
| Elixir / OTP | `1.20.2-otp-29` / `29.0.2`; `.tool-versions` unchanged |
| Lynx | Git `99a6db764c154207cf3b28c35409d9b56c463357`, root and consumer `mix.lock` |
| Lean / Lake | `leanprover/lean4:v4.35.0`, commit `eb6cafb7290e8bd5f2937522d8d804f58f02bafc`; Lake `5.0.0-src+eb6cafb` |
| Linux ARM64 Lean archive | SHA256 `c8f0f8a3920e839718b1343e6781fd80a3e9b1024fbcd7078eb30f54e806b028` |
| BEAM image | `hexpm/elixir@sha256:40a7b841481b948902f293c042089d9e1c30498b123db1650f900c298c51cc4e` |
| Hex build source | v2.7.0 tag `92cb6a1b10c9b008ccb6fa229f5d9916840dc09d`, archive SHA256 `f248381ceb4bef12c990b223a7f998113b1997cb58d29b9883b7d03a0b990f9e` |
| OS/bootstrap dependencies | Exact installed versions in run `os-packages.txt`; apt repositories are mutable, so rebuilding may change image identity and needs requalification |

Lynx has no Mix dependencies (`mix.exs`); its Lake manifest has `packages: []`.
There is no hidden external Lean package graph. The shipped Lean standard
library and Lynx runtime are proof dependencies. Checkers come from the pinned
Lean release, not independently selected latest executables. CI installs the
corresponding **x86_64** Lean archive, SHA256
`7289597a44543246c9227b8cae501767e095ce17f6d448b95fc4a8dc97268f6d`, solely
for build/lint/type checking; CI on that platform is not this ARM64 evidence.

Current distribution strategy is **Git/path dependency only**. `mix hex.build`
rejects the runtime Git Lynx dependency because Hex packages can depend only on
Hex packages. This expected packaging restriction is not suppressed or called a
package pass. A later Hex release requires an approved published/pinned backend
strategy and fresh ordinary package qualification (phase 13); do not mark Lynx
`only: :test` to evade it. `reach` remains strictly test-only and the production
fixture asserts it cannot be loaded. No runtime code was added to `lib/`.

## Claims and controls

The only positive obligation is
`Elixir.Foundation.Laws.laws.«involution/2»`. Its two arguments range over **all
`Lynx.Term` values**, with no `requires` premise. The translated expectation
calls the actual `Foundation.Pair.swap/1` twice on the constructed pair and
must return `Except.ok Lynx.Term.true`. This asserts successful abstract
termination and identity of the two tuple components; it does not equate two
possibly exhausted computations. It says nothing about calling `swap/1` on
non-pairs, allocation/VM limits, practical latency or real archive paths.

The production fixture requires a nonempty report list, every module successful
and uncached, exactly `involution/2` in the theorem inventory, a new nonempty
export, and the exact generated unconditional theorem shape. A runtime example
checks the actual BEAM tuple permutation. A false universal one-swap identity
has an explicit BEAM counterexample and must fail `rfl` elaboration for its named
law, without export. A separate `sorry` admission must be rejected for `sorryAx`,
without export. Finally, malformed JSON must make the **aggregate** paranoid
command exit 1 with actual parser errors, not a sandbox/tool-startup error.
Observed: nanoda, con-leche and con-ron reject it; Lean's default/paranoid
importers and lean4lean accept an empty declaration set. Those individual
successes are **not** sufficient evidence; required theorem binding and the
entire checker/axiom policy remain mandatory. These are backend controls,
not security vulnerabilities.

Fresh `export:` disables the Lynx verification cache at this revision. Cached
reports can legitimately omit all theorem names; accepting them as required
proof evidence would be unsound. Failed verification need not remove a prior
export: the fixture therefore refuses an existing output file and the launcher
requires a new directory. Reports, generated definitions and full export must
remain together. A result from a different build/backend/policy is stale.

## Trust inventory and inspected sources

The following are **source-inspection findings**, except where the retained
controls explicitly exercise them. Paths refer to the pinned Lynx tree or
Lean v4.35.0, not current upstream main.

1. **Reconstruction and capture:** `lib/lynx/translation.ex` loads BEAM
   `:debug_info` / `:compile_info`, invokes the named backend's
   `debug_info(:core_v1, …)`, and feeds Core to `src/lynx_core_to_leanj.erl`.
   These callbacks execute code. They reconstruct Core; they do not recover or
   authenticate the exact compiler intermediate or prove its correspondence to
   the executable BEAM. Mix projects, compilers and macros also execute code.
   Phase 04 must bind captured source/build/debug/Core/BEAM and control resolution.
2. **Translation/runtime:** Lynx translation, purity analysis and dispatch,
   `Lynx.Term`, its exception/result combinators, tuple operations and the
   Erlang `=:=/2` runtime definition are trusted for this claim. Definitions
   under `Lean/Lynx/Modules/Erlang` and `Lean/Lynx/Term` are models, not proofs of OTP/JIT/C
   correspondence. The generated sources retained by the run show the actual
   reached tuple-swap and equality operations. Broader binaries, processes,
   native calls or all OTP 29 operations are not qualified by this tiny law.
3. **Purity and partiality:** `lib/lynx.ex`, translation purity propagation and
   `Lean/Lynx/Runner.lean` distinguish pure, higher-order, sequential and
   concurrent computations. Pure predicates use `Except`; effects use richer
   result forms. Exceptions and uncatchable `Lynx.Exception.exhausted` are not
   success. Cutoffs, recursive partial fixpoints and finite-depth models cannot
   alone establish successful return. This fixture uses none of these escape
   hatches, preludes, postludes or dynamic-call declarations.
4. **Law binding:** `lib/lynx/laws.ex` and Runner generate expectation goals
   (and requirement hypotheses when supplied). A narrowed or false requirement
   could silently exclude inputs. The smoke assertion pins the unconditional
   statement, but a general trusted obligation binder remains phase 06 work.
   No accepted security policy exists in phase 01.
5. **Elaboration and imports:** Runner imports modules with extension loading,
   executes initializers for export, elaborates tactics and writes compiled
   modules. Proof source, elaborators/plugins/imports and BEAM/debug callbacks
   are executable hostile surfaces. Kernel checking is not containment. Both
   compilation and elaboration execute inside the outer offline environment.
6. **Audit/export/cache:** `Lean/Lynx/Runner.lean` collects transitive axioms
   of each generated theorem and allows exactly `propext`, `Classical.choice`,
   `Quot.sound`. `sorryAx` is excluded (tested). Its export includes safe
   declarations of all verified modules and dependencies/private proof data,
   omitting unsafe/partial/meta helpers which safe proofs cannot use. `export:`
   bypasses cache in `Lynx.Laws.verify/2`; no cached success is reused here.
7. **Independent logical check:** Lean's `src/lake/Lake/CLI/Check.lean` runs
   Lean paranoid, lean4lean, nanoda, con-leche, con-ron and Lean default kernels
   over the full export. Nonzero subprocess errors are accumulated and reject
   the check; missing tools fail setup. Lake parses the export and rejects any
   used axiom outside the same three-element policy. Fuel exhaustion, timeout,
   missing tool and unknown output remain failure/unknown, never proof.
   Independent kernels reduce reliance on one implementation; shared parsing,
   definitions, logical foundations and native toolchains remain trust.
8. **Deployment:** Elixir compiler, OTP/JIT, Lean native binaries, OS/VM,
   container engine and filesystem are trusted. Finite BEAM examples are
   conformance bug detectors, not a translation or compiler proof. No independent
   real-BEAM correspondence proof or product evidence-authority policy is claimed.

## Enforced environment and limits

The launcher uses non-root host UID/GID, read-only root and source binds,
no network, no inherited secrets, no engine socket, all capabilities dropped,
`no-new-privileges`, 4 CPUs, 6 GiB RAM+swap cap, 256 processes, 1024 file
descriptors, no core dumps, 4 GiB private scratch and 1 GiB `/tmp`. Whole-run
wall limit is 1800 s, compilation 1200 s, verification 300 s, checking 600 s.
Private caches die with the container. The only writable host bind is the
new output directory. VM swap/engine storage and host output volume are not
independently hard-capped; retained output is reviewed for size. This is a
bounded trusted-fixture bootstrap, not phase 04/06 hostile-submission hardening.

Nested `bwrap --unshare-all` is required by the checker. The tested SELinux VM
needs `label=disable`, `unmask=ALL`, and `seccomp=unconfined` to permit nested
user namespaces and `/proc`. Lake also needs `/run/user` precreated before the
outer read-only root is mounted; the Dockerfile provisions this empty mount
point. The startup probe uses the same hide-home/runtime/tmp layout.
These explicitly remove some outer defense in
depth; the VM, dropped caps, read-only binds, non-root identity, network namespace,
cgroups and the inner checker sandbox remain. No `--privileged`, added
`SYS_ADMIN`, or `--inadvisably-no-sandbox` is used. If these settings do not
work on another engine, stop and qualify that environment rather than bypass
checking. Prefer a dedicated disposable VM for genuinely hostile code.

Executable probes check non-root, absence of the selected credential variables
and engine sockets, loopback-only networking, read-only source/root, and actual
nested namespace creation with Lake's hide-home/runtime/tmp mount layout. They do not prove absence of every credential or
all escape classes; exact launcher/image review is also part of the boundary.
Lake's inner sandbox clears environment, denies networking and writes, and hides
home/runtime/temp locations except explicit read grants. Compilation shares
writable output with elaboration: its reports/hashes are diagnostic run records,
not tamper-proof product receipts. Separate trusted orchestration and protected
artifact finalization remain phase 04/06 obligations.

## Licenses and redistribution

- Pudding: MIT. Lynx: Apache-2.0; Lynx's unmodified `LICENSE` is retained in
  the evidence and by Git/bundle.
- Lean source, standard library and kernel/checker tools: Apache-2.0.
  The release's `LICENSES` explicitly attributes lean4lean/leantar (Mario
  Carneiro), nanoda (Chris Bailey), con-leche/con-ron (Lean FRO), Apache-2.0.
- Lean binaries also bundle LLVM (Apache-2.0 WITH LLVM-exception and third-party
  notices), GNU libc (LGPL-2.1-or-later and embedded BSD/ISC/Sun/CMU notices),
  GMP (LGPL-3.0), and other MIT/BSD components listed in the release's complete
  `LICENSES`. Retain those notices and corresponding-source obligations when
  redistributing binaries; this repo does not relicense or vendor them.
- Hex: Apache-2.0; builds its vendored source under the release's own notices.
  BEAM image: Elixir Apache-2.0, OTP Apache-2.0 and bundled notices; Ubuntu/apt
  packages carry their own licenses (notably bubblewrap LGPL-2.0-or-later,
  Git GPL-2.0, coreutils GPL-3.0, zstd BSD/GPL choices, CA data MPL-2.0).
  The run records exact packages; image redistribution requires their full
  notices/source compliance, not just this inventory.
- No backend/checker binaries or base image are committed here. The qualification
  records include license digests; bootstrap fetches the original distributions.
  Development/test Hex inputs remain identified by root `mix.lock`, and are not
  transitive runtime consumer dependencies.

## Decisions and limits

The owner explicitly approved adding pinned Git Lynx and Lean 4.35.0 before
implementation. Asked for a cumulative phases 01–03 budget and paid-run limits,
the owner replied **“no limits all around”**. This records unrestricted ceiling
and spend authority, not zero effort or authorization to expand the phase's
technical scope. See the handoff ledger for observed effort, failed attempts,
manual proof preparation, unmeasured costs and independent-review coverage.
Only phase 02 may next freeze the security contract; no phase 02 work is included.
