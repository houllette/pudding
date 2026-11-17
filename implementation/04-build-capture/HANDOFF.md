# Phase 04 handoff — isolated capture, closure gate blocked

## Shelved draft — start here

The owner requested shelving this partial delivery in a **draft Pudding PR**, on
branch `phase04-isolated-capture-draft`. It is not ready to merge and does not
complete Phase 04. The PR records the published commit and current CI status;
retained local qualification is identified separately below.

To resume: verify the evidence checksums/source bindings using the
[evidence manifest][evidence], read [the upstream request](UPSTREAM.md) and
[josevalim/lynx#20](https://github.com/josevalim/lynx/issues/20), then follow
[Next entry point](#next-entry-point). Reconfirm the integration decision before
changing the Lynx pin or implementing upstream. **Resume Phase 04, not Phase 05.**

## State and identities

- **State: blocked (partial delivery). Gate: not passed. Phase 05 and dependent
  phases may not begin.** The owner selected supported upstream inspection first
  and declined a private revision-pinned `Lynx.Translation` bridge. The owner
  approved delivery of capture/isolation/manifests/BEAM/debug, a public reproducer
  and upstream draft without relabelling this as completion of Phase 04.
- Base `main`: `079f0b049b7689838013b185f2603b043ab72e85`; this base does **not**
  identify the added bytes. Review branch `phase04-isolated-capture-draft`
  against that base; use the draft PR's head commit for the published snapshot.
  [Source digests][sources] and [source archive][source] bind implementation,
  drivers, tests, configuration and plan inputs; the handoff and evidence index
  are excluded to avoid self-reference. [SHA256SUMS][sums] binds retained evidence,
  not external authority or authenticity.
- Accepted contract remains `pudding.archive_path.bytes/v1`. Candidate SHA256
  `f576679bad86234b75c59241be674e2cfab0bf0c704cdef8845f516057ea8d7f`;
  accepted record `a5e98649589a7ef637e672871af17de018a2a0854749cb589e0e4a33fdf72663`;
  executable `Pudding.Contracts.PathPolicy.expected/1` source SHA256
  `ce441a804adfa0e91b2cb26b707408db7ae1921d573ed5e76edae8b74af5d8b5`.
  Phase 02's explicit owner acceptance is unchanged; capture does not approve
  contracts. Accepted record, candidate, proof-input record and postlude must be
  retained regular inputs, not merely paths mentioned in configuration.
- Required claims remain `ArchivePath.Laws.binary_contract/1` (all finite byte
  binaries, exact fixed-validator/reference equality) and `nonbinary_wrapper/1`
  (all nonbinary terms, exact `{:error, :not_binary}`). Required generated names
  are `Elixir.ArchivePath.Laws.laws.«binary_contract/1»` and
  `Elixir.ArchivePath.Laws.laws.«nonbinary_wrapper/1»`, with their matching
  `«NAME:requires/1»` and `«NAME:ensures/1»` definitions. The retained fixture
  harness checks domains, statements, nonempty fresh reports and complete
  theorem presence, not report count alone. No contract, lemma or model change.
- Final run: `tmp/phase04-capture-review-20261117T155738Z`, retained losslessly in
  [capture.tar.gz][capture]. Input bundle ID
  `d48ea6b765ab91132f6f8de3718cbc82e141a409daf0a2ef75b7d4ba3d04e5db`;
  build 1 `ffffd3bce480fc4feb0524d79ff4b8036ac3d502142c74fcf465f6bc0aeca672`;
  build 2 `a6b1857c2bc42feaed6b854b43e8fe6334effbac7e9fc3d0e5aafaecb753c624`.
  These IDs bind exact schema-1 canonical JSON metadata plus named object hashes
  and lengths. Bundle object files are chmod 0444, not tamper-proof storage.
  Build manifests identify BEAM/debug/compile/Core ETF and pretty-printed Core
  objects; no proof-free Lynx translation or resolved closure is claimed.
- Pinned Lynx `99a6db764c154207cf3b28c35409d9b56c463357`, clean trusted source;
  Elixir 1.20.2, OTP 29.0.2 / ERTS 17.0.2, Lean 4.35.0 commit
  `eb6cafb7290e8bd5f2937522d8d804f58f02bafc`. Lean has no external Lake packages.
  Host commands use `mise exec --`, not the different host defaults.
- Qualified Linux ARM64 image
  `sha256:a9a8fdbf73d3b787505b55a6f366959aca929725da359abd0b400c2b1b2a3758`,
  recipe `proof/foundation/Dockerfile`. macOS ARM64 host, Podman applehv Linux VM,
  cgroup v2, 8 CPUs/8 GiB. Image/VM/engine remain trusted, not independently
  reproducible image attestation. Capture records actual compiler/backend/tool
  hashes and versions; checker identities and license notices inherit the
  unchanged [Phase 01 qualification][foundation]. Only Linux ARM64 is qualified;
  neither native macOS checking nor x86_64 checking is established here.
- Checker policy unchanged: Lean paranoid, lean4lean, nanoda, con-leche, con-ron,
  Lean default; transitive axioms only `propext`, `Quot.sound`, `Classical.choice`.
  There is **no Pudding receipt**, signing identity or evidence-authority policy
  implementation. Only Phase 06 may authorize product receipts.
- Prerequisite handoff SHA256s: Phase 01
  `f274e5cace1120c7e6816a84ebd250f17fb51cf4cbc792cea132d0df16132a77`;
  Phase 02 `e5e2d290c7152650c28cf88278ee17d728124c5578634ba1d96b03bd4cf82606`;
  Phase 03 `2ca81b97ddd956d6c96ccc4e4dd9a420ead2bc53db80c5569f3c7f002175e1ec`.
  Shared architecture SHA256
  `b0d7bdc379506bcb228d73ddc78fd9424c3f9b4c3f69670b562d3f1b463f3a2d`.
  Current updated phase status/plan bytes are bound by source digests.

## Delivered behavior

- `Pudding.Project.Inputs`: closed declarative request, bounded staging of
  authorized source and fetched path/Git dependencies, no host consumer Mix
  evaluation. Input inventory binds bytes, regular/directory types, permissions
  and empty directories. Symlinks/special files, output aliases, overlaps,
  Git worktree indirection, alternate stores and missing referenced inputs fail.
  Consumer Git objects are parsed only in the sandbox with sanitized configuration
  and bounded revision/clean-tree checks. Host Git is used only for trusted Lynx.
- `Pudding.Execution.Container`: bounded engine output/time; fail without an
  engine, never fall back to unisolated local execution. Digest-pinned image,
  offline nonroot workers, read-only inputs/root, no capabilities or forwarded
  host environment, memory/CPU/pids/file-descriptor/storage bounds. Consumer
  build runs under nested bwrap; trusted tooling and request are hidden from it.
- `Pudding.Project.Capture`: trusted tools built separately; two ordinary fresh
  offline `MIX_ENV=prod MIX_TARGET=host` compilations. Destroy each build container
  before a separate inspector reads its output volume read-only. Named bounded
  tmpfs volumes survive between workers via a trusted holder, then are removed.
  Export JSON/base64 is read through engine tar output **in memory**, never
  extracted onto the host. Per-worker logs/configuration/timing are retained.
- `Pudding.Project.Beam` / `Inspection`: preflight all ebin BEAMs before any
  debug callback, positive compiler-option checks, allow only `elixir_erl` and
  `erl_abstract_code`; reject indirect transforms. Bind requested root exports,
  source paths, external resource hashes against the actual generated mount
  view, raw debug/compile chunks, reconstructed Core and toolchain versions.
  Reject duplicate modules/chunk identifiers and selected-file/loaded-code
  substitution (full artifact SHA256 plus OTP executable MD5). The bundled
  OTP `lists` BEAM is a **fixture proof candidate**, not a discovered OTP closure.
- `Pudding.Project.Manifest`: new immutable-by-convention content-addressed
  bundles, streaming verification of object length/digest, reject unexpected
  entries/layout links. Exact comparison, no semantic normalization, no cache or
  cross-build proof reuse. A capture is `captured_not_proved` with blocked closure.
- `priv/capture/` is packaged, not PLTs/caches. `:crypto` is explicitly started;
  no new dependencies, Reach stays test-only. `.formatter.exs` covers the drivers.
- `proof/capture/run.exs`, `isolation.exs` and fixture-only `replay.*`: explicit
  ordinary fixture authorization, actual isolation probes, and public
  `Lynx.Laws.verify/2` replay against retained BEAMs **without consumer rebuild**.
  Trusted Lynx is rebuilt from sealed source. Ten selected consumer/predicate
  modules are byte-checked on the scratch code path; sticky OTP `lists` must
  already have the exact captured image hash. Only static application metadata
  is loaded; no consumer application callback runs. This is not a general adapter.

## Gate checklist and validation

Commands below ran from the repository root. Durable logs/bundles are indexed in
[the evidence manifest][evidence]. Existing exports were not reused as proof runs.

- [ ] **Ordinary consumers capture with every reachable dependency bound:** both
  fixed/vulnerable implementations, policy and laws are captured automatically;
  all build outputs, requested Core and versions retained. General reachable
  compiled/modelled/dynamic/cutoff closure is **blocked on supported Lynx API**.
- [ ] **Changed inputs/options/backend/path change identity or refuse reuse:**
  named input/metadata/content identity, config/resource staging, permissions,
  directories, accepted references, backend/directive and path substitution
  regressions pass. Exact inventories cover staged inputs, not a proof that all
  possible build observations were declared; general macro/config/compiler
  mutation campaign and closure-wide source mapping are not complete. No reuse
  path exists, and undeclared clock/entropy/kernel/scheduling inputs are explicit.
- [x] **Stripped/malformed debug, unknown backend and substituted modules fail:**
  ExUnit controls exercise these errors and unexecuted unexpected callbacks,
  output/nonzero/timeout errors and unavailable engine. Errors remain non-success.
  Missing required roots/exports fail inspection; malformed artifacts may have
  generic extraction diagnostics rather than a normalized per-module taxonomy.
- [x] **Isolation/limits and two clean builds have retained executable results:**
  final [isolation bundle][isolation], `ISOLATION_PROBES_PASSED`, all probe
  containers absent after cleanup. Nonroot UID 1000, no inherited sentinel/tokens
  or engine sockets, only loopback, denied public-IP TCP, denied root/input writes,
  nested namespace restrictions. Session-detached child with `setsid` starts, then
  a 2 s wall timeout removes the container (12,178 ms including bounded engine
  teardown, **not** a 2 s total latency guarantee). Output flood exceeds 4096 B;
  128 MiB cgroup allocation exits 137; 1 MiB tmpfs rejects 4 MiB write; pids=32
  produces fork refusal. OOM state is not retained because `--rm` removes probes;
  the limit print and exit 137 are evidence, not an OOM inspector receipt.
  Final bundles all validate: **1,140 input names, 71 artifact names/build,
  66 equal artifacts, all 39 BEAM objects equal** (including duplicate requested
  copies and OTP candidate). Five artifact names differ: three `.mix/compile.elixir`
  files, `build-inventory.json`, `inspection.json`. Classification is
  `nondeterministic_or_undeclared_input`, **not reproducible build**. No differences
  are normalized away. `.mix` metadata is not proof-relevant executable equality
  evidence beyond this pair; cause is not established.
- [x] **Project checks and fixture proof replay against captured fixed artifact:**
  `mise exec -- mix precommit` exit 0: audits, compile, format, strict Credo
  (34 source files), usage rules, compile-connected xref, docs, **38 root checks
  (1 doctest/37 tests)** and **8 ordinary production consumer tests**. Separate
  targeted command `mise exec -- mix test test/pudding/project test/pudding/execution
  --warnings-as-errors`: 24 pass. `mise exec -- mix dialyzer`: zero errors/skips.
  Retained fixed-byte replay is detailed below; it does not discharge closure.

Actual commands:

```sh
mise exec -- mix test test/pudding/project test/pudding/execution --warnings-as-errors
mise exec -- mix precommit
mise exec -- mix dialyzer
mise exec -- mix hex.build --unpack --output tmp/phase04-checks/package
mise exec -- elixir -pa _build/dev/lib/lynx/ebin proof/capture/public_inspection_repro.exs
PHASE04_HOST_SENTINEL=must-not-enter-guest mise exec -- mix run proof/capture/isolation.exs NEW_ISOLATION
mise exec -- mix run proof/capture/run.exs NEW_CAPTURE
mise exec -- mix run proof/capture/replay.exs CAPTURE NEW_REPLAY
```

Meaningful failure-before logs retained: intermediate symlink/budget and missing
policy/resource regressions; equal input inventories despite changed permissions
and added empty directory. The latter prompted directory/mode identity binding;
final inspector export filters directories rather than reading them as files.
The review fixes and expanded upstream outline are described below; current
targeted/precommit checks cover 24/38 root checks respectively.
An interrupted intermediate capture was cancelled and its exact named resources
cleaned, then final capture restarted. Earlier replay failed on Elixir
`Application.load(tuple)`; fixed to Erlang `:application.load(tuple)` for static
metadata, not a consumer rebuild or callback workaround.

**Package check remains failed** (exit 1): `Dependencies excluded from the package
(only Hex packages can be dependencies): lynx`. This is inherited from Phases 01/03;
no distributable Hex package is claimed. The task's file listing includes the
capture scripts and excludes PLT/Reach/tests/tmp. No ignore-excluded-deps flag,
pin weakening or dependency patch disguises the release blocker. Non-test source
compilation/ordinary consumer succeeds, but does not replace a successful package
install. These retained qualification logs are local, not remote CI evidence;
consult the draft Pudding PR for its current hosted checks.

## Claims and trust

- Both captured target roots have capture provenance, **not** product `proved`.
  Universal fixed binary equality and the nonbinary wrapper remain direct model
  theorem qualification on all their accepted inputs with `.ok Lynx.Term.true`
  expectations, not raw equality of exhausted computations. Vulnerable `..` and
  negative-control examples are checked concretely by the existing harness;
  finite conformance checks do not establish universal translation agreement.
- The fixed-byte replay retains newly elaborated required definitions/theorems,
  complete export, reports, all six checker outcomes, the exact three-axiom audit,
  malformed and valid-format theorem-value tamper rejection. Final replay wall
  time: **150,308 ms**; cgroup CPU: **166,642,912 µs**; peak memory:
  **3,214,589,952 bytes**; peak processes: **149**, no OOM events. Fresh export
  SHA256 `e8b428eb115775ccadf8f98c2e484423078e9ba3a491aabb36d53e6572935da2`
  (34,351,530 bytes). This does not
  establish general support inventory, full captured dependency closure, or
  independently authorized receipt issuance. See evidence for measured results.
- Trust remains: accepted policy authority, source preparation, image/VM/kernel
  and engine, compilers/JIT/runtime, allowed OTP/Elixir debug callbacks, Core
  reconstruction, Lynx translation/runtime models, Lean export/elaboration and
  checker builds, plus manual reviewed manifests. Debug/Core authenticity does
  not prove correspondence to executable BEAM. No custom axioms, alternate
  evaluator, hand-edited translation or private Lynx interface is used.
- Freshness: only the identified captured artifacts; `unknown_inputs` remains
  visible. Excluded source directories (`.git`, `_build`, `deps`, `.lake`, editor
  caches, node_modules, tmp, doc) are not ambient build inputs: declare dependency
  roots explicitly. Writable mounts hide staged paths. Inputs must remain
  quiescent through staging/sealing; this is not a filesystem snapshot or
  hostile concurrent-mutation protocol. Directory creation normalizes modes in
  staging; inventory binds the staged view, not original directory metadata.
  Timestamps/ownership/ACLs and clock/entropy/kernel observations are not bound.
- Host staging limits: 128 MiB, 20,000 entries, depth 64, including Git metadata.
  Worker defaults: 20 min/2 MiB stdout, 6 GiB memory, 4 CPUs, pids 256, fd 1024,
  4 GiB workspace, bounded tmpfs/export. Artifact tree scan has additional byte,
  depth/count/path/link constraints; inspector export has a fixed 90 MB ceiling
  distinct from the 128 MiB engine artifact ceiling. Lake outputs (713 entries,
  365,880,692 bytes in this fixture) have exact inventory hashes only, not retained
  cache bytes; replay builds tools afresh. No reusable cache is delivered.
- Isolation is the qualified Linux VM/container/bwrap policy, not a claim of
  perfect sandboxing. It deliberately uses seccomp-unconfined/label-disable/
  unmask-ALL for nested bwrap; the enclosing VM/kernel is a material trust layer.
  Forced session termination can bypass normal cleanup; ordinary capture/replay
  and probes were checked for removal, while generic cleanup API results are not
  themselves attestations. Host port/mailbox/concurrent-file and hostile parser
  robustness beyond the exercised bounds remain hardening work.

## Review follow-up

A second review against the original Phase 04 assignment reconfirmed that the
closure and broad mutation gates remain incomplete. Upstream main and all 13
open/closed issues were rechecked; main still matches the pinned Lynx revision,
with no equivalent public inspection feature found. A subsequent ownership review
narrowed the [upstream draft](UPSTREAM.md) to a supported translation-only entry
point around existing translation/assembly, with documentation and focused tests.
The prior mandatory closed resolver and provenance/support-report schema were
removed: build capture, input validation, code-path isolation and evidence binding
belong downstream. The existing internal API already translates law-free roots;
this is an API-extension request, not a translator bug or a requirement for normal
law verification. With owner approval, the issue text was published as
[josevalim/lynx#20](https://github.com/josevalim/lynx/issues/20), including the offer
to open a draft PR. Published title/body were verified against the approved text;
no PR was opened.

Two local defects were reproduced with failing regression tests, then fixed:

- **Duplicate BEAM chunks:** OTP decoded lookup could select the first `Dbgi` or
  `CInf` while `Map.new` retained the last. Preflight now rejects duplicate chunk
  identifiers before decoding, so reconstructed data and retained raw evidence
  cannot disagree by that ambiguity. The reproducer did not execute an
  unapproved debug callback; the defect was accepted ambiguous provenance.
- **Already-loaded code substitution:** an expected filename and unchanged disk
  SHA256 did not identify code loaded with `code.load_binary` under that filename.
  The binding helper now also compares OTP's loaded executable MD5 with the
  captured BEAM's OTP MD5, via `erlang:get_module_info/2` rather than a consumer
  callback. Replay explicitly loads its preflighted fixed-fixture modules and
  checks loaded identity, including sticky image `lists`. Full-file SHA256 still
  binds debug/metadata bytes; OTP MD5 binds executable identity only. This is not
  protection against deliberate MD5 collisions, concurrent hostile code loading,
  or a universal executable/debug correspondence attestation.

Both new regressions failed before the fixes and pass afterward. Fresh capture
and retained-byte replay both passed their fixture checks against the updated
library; only the new identities above qualify these bytes. No dependency,
accepted contract, translator semantics, theorem, axiom/checker policy or allowed
debug backend was changed. The review fixes do not pass the unresolved original
closure/mutation gates.

The subsequent upstream-scope validation exposed an undefined-module warning in
the dynamically loaded fixture test on a fresh compilation. Its invocation now
uses `Function.capture/3` rather than a statically inferred remote call; the same
replacement-value and substitution assertions remain. The focused five BEAM
tests and full `mix precommit` pass with warnings-as-errors (38 root checks,
8 production-consumer tests). This test-only adjustment and the narrowed
upstream documentation do not change captured library/worker or fixture-proof
bytes; their source/handoff evidence bindings were refreshed.

**Draft shelving review:** capture orchestration, input staging, manifests,
container policy, BEAM inspection and fixture replay were reviewed again within
their stated partial scope; no additional must-fix defect was identified. Only
shelving documentation and evidence bindings changed. A fresh local
`mise exec -- mix precommit` passed (38 root checks and 8 production-consumer
tests); [the retained log][draft-precommit] is separate from hosted CI. Capture
and six-kernel replay were not rerun for these documentation-only changes.

## Effort and budget

Phase 01–03's earlier uncapped authority and cumulative accounting remain in
those handoffs; they are not a new paid-run authorization. This phase used the
owner's explicit end-to-end request plus the upstream-first/partial-delivery
choices. No provider/paid model experiments, dependency additions, upstream
implementation, policy review changes, new handwritten proof, repair or checker
policy change were performed here. Agent/manual work comprised public-interface
investigation, declarative staging, isolation/export orchestration, debug gating,
manifest and filesystem regressions, fixture replay and evidence curation.

Individual worker elapsed times are in capture execution JSON; replay cgroup CPU,
peak memory/processes and total wall time are retained separately from limits.
Isolation elapsed times include engine teardown. There were repeated capture and
replay attempts after review fixes; superseded outputs under ignored `tmp/` are
not the final evidence. Full session start/duration, human labor, complete token
usage/billing, per-kernel CPU/wall allocation, and total cost are **not measured**;
do not infer them from timeout bounds. No phase-specific dollar ceiling or paid
upstream-work allowance was recorded. Scope/budget review precedes upstream work.

## Blockers and deviations

1. **No supported translation-only entry point at the pin.** Public
   `Lynx.Laws.verify/2` correctly requires laws; the existing internal
   `Lynx.Translation` API is not the approved integration surface.
   [UPSTREAM.md](UPSTREAM.md) records the narrow API request, source checks and
   downstream responsibilities. The [public example](../../proof/capture/public_inspection_repro.exs)
   confirms the documented no-laws rejection, not a correctness defect. Normal
   verification of real law modules remains possible through the public API.
   The draft offers a wrapper/documentation/test PR; it does not require a custom
   resolver or evidence schema in Lynx. The issue was posted with owner approval
   as [josevalim/lynx#20](https://github.com/josevalim/lynx/issues/20); no draft PR
   was opened. Upstream implementation needs separate approval. No temporary
   internal API bridge was approved or retained.
2. Original Phase 04 gate has **not passed**, even with successful fixture replay.
   General closure, complete dependency-source support inventory and full input
   mutation qualification remain unresolved. Phase 05 and later gates stay blocked.
3. Full ordinary build artifacts differ across two runs. Preserve exact diagnosis
   and unknown inputs; no cross-build reuse, no normalization-based promotion.
4. Hex release packaging remains blocked by the Git Lynx dependency. Keep the
   pin; a release/dependency strategy needs separate review.
5. No backend/toolchain/contract/axiom/protocol upgrade. Implementation changes
   during review required fresh capture; only the final IDs above are current.
   Any future code/backend/image/policy change requires reidentification,
   requalification and invalidation of dependent evidence.

## Next entry point

- Resume **Phase 04**, not Phase 05. Read this handoff, evidence manifest,
  `UPSTREAM.md`, `lib/pudding/project/*`, `priv/capture/*` and fixture replay
  drivers before editing. Verify retained integrity and source digests first.
- Smoke: targeted 24-test command above plus public repro; expect explicit
  no-laws boundary, not a closure result. For stronger replay, extract the retained
  capture into a new directory and run `proof/capture/replay.exs` with a new output;
  expect `CAPTURED_FIXTURE_REPLAY_PASSED_NOT_PHASE04_CLOSURE`, six accepting kernels,
  exact three-axiom audit and both tamper controls rejected. No consumer rebuild.
- Preserve accepted policy/required theorem identities, pinned image/Lynx,
  allowed backends, exact code-path/hash binding, blocked closure and no-reuse
  policy. Do not revive the rejected private bridge or synthetic-law inspection.
- Owner options: authorize a bounded upstream public-API patch after interface
  agreement on [#20](https://github.com/josevalim/lynx/issues/20), reconsider the
  integration approach, or leave the gate blocked. Posting the issue does not
  authorize implementation. A public upstream fix/upgrade requires pinning,
  requalification and fresh dependent evidence. The owner authorized the shelved
  Pudding draft PR, not merging it or implementing the offered upstream patch.

[draft-precommit]: ../../proof/capture/evidence/linux-arm64-2026-11-17/checks/draft-pr-precommit.log.gz
[evidence]: ../../proof/capture/evidence/linux-arm64-2026-11-17/MANIFEST.md
[capture]: ../../proof/capture/evidence/linux-arm64-2026-11-17/capture.tar.gz
[isolation]: ../../proof/capture/evidence/linux-arm64-2026-11-17/isolation.tar.gz
[sources]: ../../proof/capture/evidence/linux-arm64-2026-11-17/source-digests.txt
[source]: ../../proof/capture/evidence/linux-arm64-2026-11-17/source.tar.gz
[sums]: ../../proof/capture/evidence/linux-arm64-2026-11-17/SHA256SUMS
[foundation]: ../../proof/foundation/evidence/linux-arm64-2026-11-16/MANIFEST.md
