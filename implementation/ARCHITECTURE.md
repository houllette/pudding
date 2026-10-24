# Shared implementation contract

Read this with [AGENTS.md](../AGENTS.md) for every phase. These are constraints
derived from the research brief, with proposed file locations for planning.
No module or command below should be described as implemented until it exists
and its phase has passed.

## Representation and trust

Start with compiler-derived Core Erlang and HARP's sequential frame-stack
semantics in Rocq. Initial HARP revision:
`4a59339cdc5c9cff3a144732397d56dfa7378631`. Phase 01 must actually build it;
the brief only audited source. Start from its Rocq 9.1 requirement and select an
exact compatible stdpp version (upstream requires at least 1.12.0). Pin all
transitive proof dependencies and execution environments. The upstream OTP 23
tooling requirement does not imply OTP 29 compatibility.

Pudding's build pins live in `.tool-versions`: Elixir 1.20.2 / OTP 29.0.2 at
planning time. Use that file as the authority and verify the invoked binaries.
HARP tooling and the host's default `PATH` are different environments. Do not
silently update project pins to make a spike pass.

The initial extraction route reads BEAM `:debug_info` and invokes its recorded,
allowlisted backend's `:core_v1` callback. It reconstructs Core; it does not
recover the exact intermediate originally compiled into the BEAM. Bind the
BEAM bytes, debug backend, options, reconstructed Core, importer output, and
toolchain in the evidence. Missing debug information is a diagnostic failure.
An alternative capture hook needs an explicit recorded design decision.

Import actual syntax under the formal evaluator/execution relation. Check
binding, scope, arity, literals, evaluation order, failure branches, and the
whole reachable call closure. A separately written mathematical function is a
specification or proof aid until a checked relation connects it to that syntax.
No LLM-authored replacement program may stand in for the imported implementation.

Report five distinct trust layers: build capture; reconstruction/import;
semantic definitions and BIF models; compiler/BEAM/runtime connection; and
logical checking/policy. Differential agreement detects bugs but proves none of
those layers universally correct. A theorem at Core is not a theorem about
deployed BEAM/JIT execution. Keep HARP license obligations distinct from
Pudding's MIT license and do not hand-edit a fetched dependency.

## Supported-language policy

The first subset is deterministic sequential lists, tuples, atoms, mathematical
integers, statically resolved recursion, matching, and audited exceptions/BIFs.
Binary values and operations enter only through phases 08–10. Maps exist
upstream but are excluded until their behavior is audited for a selected target.

Classify every reachable node, call, and primop. Allowlist by module, function,
arity, argument domain, return/error behavior, and semantic-rule version.
Upstream's `BNothing`/`undef` fallback must never give an unsupported OTP call
an invented meaning. Statically resolve/import a cross-module body or bind a
reviewed conditional summary to its implementation; otherwise report unsupported.
Initially an unsupported operation anywhere in the reachable closure blocks
the target. Excluding a branch later requires a checked reachability argument.

Processes, mailboxes, ETS, filesystem effects, NIFs, dynamic loading, unresolved
dynamic dispatch, richer bit syntax, Unicode semantics, and practical resource
bounds are outside the initial backend. Use idealized sufficient memory,
arbitrary finite bytes, and arbitrary-precision integers. Disclose excluded
allocation failure, VM size limits, external termination, and scheduling
starvation. Abstract totality is not a production denial-of-service bound.

## Result and contract model

Keep contract workflow state, evidence outcome, assumptions, conformance, and
freshness distinct. Phase 02 must document their schema and presentation.

| Dimension | Required meaning |
| --- | --- |
| Contract state | Candidate/proposed and accepted policies have different authority; acceptance has an identity and provenance |
| Evidence outcome | `proved`, `violation_reproduced`, `unsupported`, or `unknown`, following brief section 10 |
| Assumptions | Explicit logical axioms, conditional library premises, trusted implementations, and environment exclusions |
| Conformance | Tested agreement, observed disagreement, or unassessed; none means universal equivalence |
| Freshness | Bound to the identified current build or stale; rechecking an old bundle proves only its old claim |

Preserve AGENTS.md's explicit **proved**, **assumed**, **unsupported**, and
**unknown** reporting contract. Display **assumed** premises as a separate,
visible dimension alongside the brief's four evidence outcomes. An assumed
summary cannot silently become a proved library implementation. Phase 02 must
include examples of unconditional and conditional proofs, reproduced
violations, unsupported code, and unknown attempts to make this distinction
reviewable.

Only the independent checker can authorize a proved outcome. A violation needs
concrete replay on the identified uninstrumented BEAM artifact. A model-only
witness is diagnostic until replay succeeds. Timeouts, exhausted fuel, missing
proofs, checker errors, and unrecognized audit output never become success.
Keep build/extraction failures separate from target exceptions in diagnostics;
they yield no proved claim. A timeout is not proof of nontermination.

Record the exact target/build, accepted contract and quantifiers, domain and
bounds, normal/error outcomes, model/importer/checker versions, trusted
operations, assumptions, checker result, exclusions, and evidence links.
Conditional proofs display their premises beside the claim. Bounded proofs
state the bounds in their theorem; exhaustive execution alone remains testing.

Contracts include useful acceptance and totality where specified. Tests and
inference nominate policy but do not accept it. Freeze accepted definitions,
examples, versions, and acceptance provenance outside worker write authority.
Connect executable oracles to formal predicates through shared restricted
definitions or checked equivalence; otherwise disclose that additional trust.

## The archive policy to carry forward

For a binary `b`, `split_slash(b)` splits on byte `0x2F`, preserving all empty
components, including `split_slash(<<>>) = [<<>>]`. It is valid exactly when each
component is nonempty, is neither exact `.` nor exact `..`, and has no NUL.

For every finite byte-aligned binary, the required result is exactly
`{:ok, split_slash(b)}` when valid and `{:error, :invalid_path}` otherwise.
Establish safety, exact positive acceptance, rejection, absence of unexpected
exceptions/stuck states, and termination. The nonbinary wrapper returns
`{:error, :not_binary}` and needs a separate obligation over its declared
caller domain. Improper/nonbinary bitstrings are outside the binary theorem.

Invalid UTF-8 is allowed. Backslash and colon are ordinary bytes. No Unicode
normalization, percent decoding, filesystem operation, symlink reasoning, or
Windows-path guarantee is implied. Later reinterpretation needs composition.
Retain the deliberately vulnerable fixture that rejects `../` but accepts `..`.
It is synthetic; it is not a reproduction of the OTP ZIP advisory.

## Checker and worker separation

The checker receives immutable captured/imported programs, accepted contracts,
semantics, and policy from a trusted preparation path. Workers submit proof
source and proposed source patches in separate workspaces. They cannot replace
the expected theorem, contracts, generated program, checker scripts, or trusted
dependencies. At checking time recompute/validate hashes and regenerate the
expected theorem from those inputs; hashes alone cannot detect a wrong importer.

Compile proof source into ordinary objects. Generate an exact-type wrapper,
audit transitive `Print Assumptions` against an explicit allowlist, enforce
guard/positivity/universe checking, and run standalone `rocqchk` over the entire
dependency closure without skip options. Reject unknown audit output,
unfinished proofs, unauthorized axioms, worker-supplied plugins, and unsafe
conversion. Start without `native_compute`. Record trusted conversion machinery.
Rechecking must work without a model, solver service, or original agent session.

Use deterministic computation, simplification, rewriting, induction, `lia`, and
reusable tactics first. Optional solver integrations require a demonstrated
repeated need, compatible checked certificates, and justified encoding. `unsat`
alone is not proof, and abduction cannot authorize new premises.

Patch workers can change allowed target source/test files only. Preserve original
regressions and valid-input behavior. Rebuild, extract, and independently check
the patch against the same accepted contract. A semantic or policy change is a
separate reviewed change that invalidates evidence, never part of a repair.

## Build and evidence discipline

Compilation, macros, proof compilation, and target execution run in isolated,
bounded environments without unrelated credentials. Fetch declared inputs
first; disable network during the controlled build/check steps. Do not pretend
that `System.cmd` alone provides isolation. Record actual enforcement and gaps.

Initially store immutable per-build bundles and refuse reuse on identity change.
Phase 17 adds a content-addressed graph with separate build and proof nodes.
Capture source/generated contents, lockfile, path/Git dependency contents,
toolchain/options, `MIX_ENV`, `MIX_TARGET`, compile-time configuration, macro and
external resources, BEAM/debug data, Core, and imported terms. Proof dependencies
include contracts, model, BIF summaries, lemmas, checker image/configuration, and
assumption policy. Runtime configuration is an explicit input/assumption where
relevant. Mix's dependency graph alone is insufficient.

Start invalidation at module granularity and propagate through dependent proofs,
including runtime callees. Unknown build inputs disable cross-build cache reuse.
Retain original artifacts even if source is unchanged. A semantic mismatch
quarantines affected assurance: unknown while undiagnosed, unsupported pending
correction once the gap is known. A separately replayed real violation remains
a violation. Do not erase the old mathematical theorem or reassign it to a new
build without a validated binding.

## Proposed landing zones

These paths guide scope; reconcile them with actual code in each handoff.
No new dependency is selected merely by listing it here.

| Area | Proposed location |
| --- | --- |
| Project/build capture and extraction | `lib/pudding/project/`, `lib/pudding/extraction/` |
| Support analysis, import, executable-model bridge | `lib/pudding/core/`, `lib/pudding/backends/core_erlang/` |
| Contracts, reports, evidence identities | `lib/pudding/contracts/`, `lib/pudding/result.ex`, `lib/pudding/evidence/` |
| Checker and untrusted workers | `lib/pudding/checker/`, `lib/pudding/workers/` |
| Discovery, generation, replay, shrinking | `lib/pudding/discovery/`, `lib/pudding/testing/` |
| Mix entry points | `lib/mix/tasks/pudding.verify.ex` and narrowly scoped supporting tasks |
| Owned proof extension, locks, build scripts | `proof/`; keep upstream source/license boundaries explicit |
| Ordinary consumer fixtures and contract cases | `test/fixtures/projects/`, `test/fixtures/contracts/` |
| Evaluation | `bench/` |
| Design records, support matrix, replay instructions | `docs/verification/` |

Keep `reach` out of `lib/` and production code. Do not add an application or
supervision tree until long-lived processes actually need one. Public library
functions need named-argument typespecs, meaningful tests, and warning-free
compilation. Use root AGENTS.md for checks and generated-rule handling.
