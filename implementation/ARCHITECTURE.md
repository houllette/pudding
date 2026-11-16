# Shared implementation contract

Read this with [AGENTS.md](../AGENTS.md) for every phase. Paths are proposed
landing zones, not implemented APIs. Pudding owns security policy, controlled
project capture, discovery/replay, evidence, worker isolation, and repair gates.
Lynx owns program translation, runtime models, generated laws, and Lean checking.

## Backend and trust boundary

Use a pinned Lynx Git revision and its declared Lean toolchain. The initial
source baseline is `99a6db764c154207cf3b28c35409d9b56c463357`, selecting Lean
`leanprover/lean4:v4.35.0`; phase 01 must build and qualify it against the exact
Elixir/OTP pins in `.tool-versions`. A local sibling checkout or host default
is not a reproducible dependency. Record transitive inputs, licenses, platform,
actual binaries, and checker identities. Do not patch installed dependencies.

Lynx reconstructs Core from BEAM debug information and translates it into Lean
functions over `Lynx.Term`. Pure law predicates return an `Except` result; a law
proves its expectation returns `true` whenever its requirement returns `true`.
Exceptions and Lynx exhaustion are distinct from success. A successful-return
law includes abstract termination on its stated domain. A `partial_fixpoint`
annotation alone proves neither totality nor the law. Require the executable
expectation to return `.ok Lynx.Term.true`, not raw equality of two computations
that could both be exhausted. Requirements must themselves implement the accepted
domain: a requirement that fails to return true silently removes that input.

Prefer `Lynx.Case` for direct fixture proofs and `Lynx.Laws.verify/2` for the
product adapter. The latter accepts law modules or in-memory law BEAM binaries;
it returns dependency-ordered reports and raises on translation/runner failures.
All reports must succeed, and all required obligations must be present. Neither
an empty report list, dependency-only success, absent law, nor cached empty
`theorems` list establishes a required claim. Root law modules and captured
callee modules are different roles: do not assume passing arbitrary dependency
BEAMs as verification roots is supported. Resolve callees from the controlled
capture workspace, never an incidental host code path.

Use public APIs and ordinary imports. Inspect generated Lean before writing
proofs. A small revision-specific adapter to lower-level Lynx translation data
is permitted only when public reports/debug output cannot supply necessary
provenance or obligation checks; confine, test, and pin that coupling. Do not
build a parallel Core importer, evaluator, BIF-summary engine, or theorem generator
that bypasses Lynx. Proof helpers are allowed only when related by checked lemmas
to the actual translated implementation. Never replace it with a hand-written
safe function or edit generated Lean program bodies.

Report these trust layers separately:

1. Controlled source/build capture and binding to artifacts.
2. BEAM debug backend, Core reconstruction, and Lynx translation.
3. Lynx runtime definitions and modeled OTP operations.
4. Compiler, executable BEAM/JIT, deployment, and environment connection.
5. The accepted contract, theorem binding, Lean kernel, independent checkers,
   and evidence-authority policy.

Reconstructed Core is not the exact intermediate originally compiled. Debug
information is not a proof of executable BEAM correspondence. Differential tests
are finite bug detectors, not translation proofs. Independently checking Lean
exports strengthens logical checking, not compiler/runtime correctness.

## Initial supported scope

Start with deterministic pure sequential functions over finite byte binaries,
lists, tuples, atoms, mathematical integers, and the operations actually reached
by the validator and its executable policy. Reuse Lynx's binary/bitstring and
library models from the beginning. Support is target-, domain-, toolchain-, and
backend-revision-specific, not inferred from the breadth of Lynx's feature list.
Inventory reachable translated calls, modeled BIFs, failure paths, and the law's
purity. Broader Lynx support does not automatically enter Pudding's initial scope.

Missing translation/runtime support is unsupported; incomplete proofs, exhausted
budgets, and undiagnosed mismatches are unknown. Do not classify every Lean error
as unsupported or a real vulnerability. For a genuine Lynx-owned gap, follow
[AGENTS.md's upstream-first policy](../AGENTS.md#lynx-limitations-upstream-first):
minimize and report it upstream, offer a focused fix with regression coverage,
and record the issue/draft in the handoff. Pudding integration bugs stay here;
an unfinished proof is not automatically a backend limitation. Any temporary
adapter/workaround, including private-interface coupling, needs explicit review
and an upstream-linked removal condition rather than becoming a parallel backend.
Scope/budget review precedes upstream implementation. Rebuild, recheck, and
invalidate evidence after any backend/model change.

A `cutoff` is allowed only when the original obligation proves the selected
function unreachable: Lynx makes it raise uncatchable exhaustion, not an assumed
result. Restrict proof configuration, imports, dynamic-call declarations,
termination annotations, preludes, and postludes through trusted preparation.
No custom axiom or conditional summary may silently stand in for real behavior.

Processes, ETS, external filesystem/network/port effects, unmodeled native calls,
dynamic loading, unresolved dispatch, Unicode policy, and practical resource
bounds are outside the initial claim. Existing modeled BIFs remain trusted runtime
definitions even if OTP implements them natively. Use idealized sufficient memory
and arbitrary finite inputs; disclose allocation/VM limits and external termination.
Abstract termination is not a production latency or denial-of-service guarantee.

## Contracts and outcomes

Contract approval is separate from proof generation. Store candidate and accepted
policies separately; only explicit recorded authority can accept or revise one.
Bind identity to executable definitions, domain, quantifiers, expected outcomes,
assumptions, version, and acceptance provenance. A name such as `validate` or a
successful test corpus cannot authorize a security claim.

Use a reviewed executable policy translated alongside the implementation. Prefer
an independent byte-oriented reference algorithm rather than a duplicate of the
target's control flow. Review it against positive and negative policy cases.
Any additional mathematical specification needs a checked connection to that
translated predicate; otherwise disclose specification-translation trust.

| Dimension | Required meaning |
| --- | --- |
| Contract state | Candidate/proposed versus accepted, with authority and identity |
| Evidence outcome | `proved`, `violation_reproduced`, `unsupported`, or `unknown` |
| Assumptions | Visible logical premises, runtime/model trust, environment exclusions |
| Conformance | Tested agreement, observed disagreement, or unassessed |
| Freshness | Current identified build versus stale evidence for an older build |

Preserve AGENTS.md's visible **assumed** category as the assumptions dimension,
not an automatic promotion to proved implementation behavior. Only phase 06's
trusted evidence checker may issue a product `proved` receipt. Earlier direct
Lynx proofs are feasibility artifacts. Require the exact accepted obligations,
successful fresh elaboration/axiom audit, independent checking, current artifact
binding, and no unresolved relevant conformance disagreement.

A `violation_reproduced` needs concrete replay on the captured uninstrumented BEAM
artifact. A model witness alone is diagnostic. No counterexample found, timeout,
checker crash/fuel exhaustion, missing theorem, unknown audit output, or failed
proof is a proof or a reproduced violation. A timeout is not nontermination proof.
Separate build/extraction/checker errors from target exceptions. Required CI claims
fail on any missing, pending, stale, unsupported, unknown, or violated obligation.

## Archive-path policy

For a finite byte-aligned binary `b`, `split_slash(b)` splits at byte `0x2F`,
preserving all empty components, including `split_slash(<<>>) = [<<>>]`.
A path is valid exactly when every component is nonempty, is neither exact `.`
nor exact `..`, and contains no NUL byte.

The binary interface must return exactly `{:ok, split_slash(b)}` when valid,
and exactly `{:error, :invalid_path}` otherwise. Prove exact useful acceptance,
rejection, output preservation, absence of unexpected exceptions/exhaustion,
and termination for every finite binary. Do not assume validity in the main
precondition; that would exclude malicious inputs. The intended direct law shape is:

```elixir
requires: is_binary(input),
expects: ArchivePath.validate(input) === PathPolicy.expected(input)
```

`PathPolicy.expected/1` is the accepted, independently reviewed executable byte
policy, not the implementation under another name. The wrapper separately returns
`{:error, :not_binary}` for every nonbinary term in its declared domain, including
nonbyte-aligned bitstrings when the domain covers all nonbinary terms.

Invalid UTF-8 is allowed. Backslash and colon are ordinary bytes. No Unicode
normalization, percent decoding, filesystem/symlink behavior, Windows-path
interpretation, or safe archive-extraction claim follows. Later consumers need
composition obligations if they reinterpret accepted bytes.

Keep separate synthetic vulnerable and fixed fixtures. The vulnerable one rejects
`../` but accepts `..`; it is not a reproduction of the historical OTP ZIP advisory.
Reject-all, safe-output substitution, hidden stronger preconditions, and divergence
cannot satisfy the full contract. Fixed examples and safety-only lemmas are useful
proof aids but not the universal full-contract gate.

## Checking and worker separation

Trusted preparation rebuilds accepted policy/law modules and selects captured
implementation/dependencies from immutable inputs. It fixes required theorem
names, exact predicates, domains, and allowed proof configuration before workers
run. A worker may submit proof source, not a replacement law or verification request.
Validate that the checked theorem references the expected translated definitions;
a name match or a valid export of a different theorem is insufficient. Generate
an exact-type wrapper or equivalent checked binding from trusted inputs and
compare the required obligation inventory; do not trust worker-supplied theorem text.

Lynx's generated-law audit permits `propext`, `Quot.sound`, and `Classical.choice`.
Pin and verify the actual policy. Reject `sorryAx`, unauthorized axioms, unsafe
checking, substituted compiled artifacts, and uncontrolled imports/plugins. Lean
tactics and elaborators execute code: kernel checking is not OS containment.
Use enforced offline resource-limited environments with read-only trusted inputs,
private scratch/caches, no unrelated credentials, and bounded output for builds,
proof elaboration, independent checking, and target execution. Record platform
limitations; `System.cmd` or a prompt restriction is not isolation.

Call `Lynx.Laws.verify(..., export: fresh_path)` for evidence, which bypasses
Lynx's verification cache at the baseline. Use a new empty per-attempt output
location: a failed run can leave an older export untouched. Check every report,
required declaration, and export binding before invoking the pinned toolchain's
independent checkers. The baseline documented command shape is:

```sh
lake --dir deps/lynx/Lean check --paranoid --from-export "$EXPORT"
```

Qualify the exact command, output interpretation, closure/axiom coverage, and
sandbox in phase 01/06. Linux `bwrap` is the baseline for bundled checker sandboxing;
do not silently opt out on another platform. Outer isolation still covers build
and proof elaboration. Checker fuel/resource limits are incomplete checking,
never success. Rechecking must need neither a solver service nor the agent session.

Patch workers write only allowed implementation/regression paths in isolated
workspaces. They cannot edit accepted contracts, generated program bodies,
backend/toolchain, checker, trusted lemmas, or receipt store. Rebuild and recheck
every patch against the unchanged accepted policy; no automatic publication.

## Build, conformance, and evidence discipline

Fetch declared inputs before offline build/check. Capture source/generated bytes,
lockfile, path/Git dependency contents, actual Elixir/OTP/Lean/Lynx/checker versions,
`MIX_ENV`, `MIX_TARGET`, compiler options, compile-time configuration, external
resources, BEAM/debug chunks, reconstructed Core where captured, translation output,
law inventory, proof source, and source mappings. Runtime configuration is explicit
where relevant. Validate/allowlist every debug backend before Lynx invokes it,
including dependencies; reconstruction callbacks execute code.

Use the exact capture during verification and replay. Initially disable evidence
reuse on identity change. Record unknown build inputs and nondeterminism; Mix's
dependency graph and source hashes alone are insufficient. Pin external Lean
imports and all transitive proof dependencies, not just Lynx's normal cache key.
A worker-writable cache or success JSON is not checker authority.

Conformance compares concrete executions of the captured BEAM with the same
translated implementation, including class/reason of supported exceptions.
Prefer generated concrete Lynx laws against observed values over implementing
a second evaluator. Qualify safe result encodings and any inspection bridge;
exclude stacktrace equality where Lynx omits traces. Keep exhausted model runs,
unsupported forms, and runtime timeouts distinct. Conformance is always finite.

Retain minimized mismatches and quarantine all affected assurance. Undiagnosed
mismatches are unknown; identified missing support is unsupported until corrected.
Do not erase old mathematical theorems, but do not advertise them as current
implementation evidence. A separately replayed real violation remains a violation.

Phase 12 adds separate build/proof dependency nodes, module-level invalidation,
and reviewed reuse. Preserve immutable earlier bundles and offline replay. Hashes
bind artifacts, not semantic correctness. Receipts must list target/build, accepted
contract and exact statements, domains/bounds, assumptions, model/checker policy,
conformance, freshness, export/independent logs, and exclusions.

## Proposed landing zones

| Area | Location |
| --- | --- |
| Project capture and controlled execution | `lib/pudding/project/`, `lib/pudding/execution/` |
| Lynx adapter and scoped support reporting | `lib/pudding/backends/lynx/` |
| Policies, results, evidence | `lib/pudding/contracts/`, `lib/pudding/result.ex`, `lib/pudding/evidence/` |
| Checker and constrained workers | `lib/pudding/checker/`, `lib/pudding/workers/` |
| Candidate discovery and counterexample search | `lib/pudding/discovery/`, `lib/pudding/testing/` |
| Mix task | `lib/mix/tasks/pudding.verify.ex` |
| Owned laws, checked lemmas, replay/bootstrap assets | `proof/` |
| Ordinary consumers and contract cases | `test/fixtures/projects/`, `test/fixtures/contracts/` |
| Evaluation | `bench/` |
| Qualified interfaces and operator instructions | `docs/verification/` |

Keep `reach` out of `lib/`. Add no supervision tree until persistent processes
actually require one. Do not invent a new contract DSL, general backend framework,
or solver integration to avoid the first proof. Package required owned proof assets
deliberately; the current package allowlist does not include `proof/` automatically.
