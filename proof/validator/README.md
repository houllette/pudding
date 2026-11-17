# Direct validator feasibility proof (Phase 03)

This directory contains hand-written proofs of the **actual ordinary compiled**
archive-path fixture. It is not a general Pudding adapter, capture service,
evidence checker, autonomous repair, or product `proved` receipt. Read the
[handoff](../../implementation/03-validator-proof/HANDOFF.md) and the
[accepted contract](../../test/fixtures/contracts/README.md).

## Proof and exact domain

`lemmas.lean` is passed through public `Lynx.Laws.verify/2`'s `postludes` option.
Lynx translates the compiled implementation, reference and laws, then checks this
postlude and the two law proofs. No generated program body is edited or replaced.
Only `ArchivePathProof.binary_contract` and `nonbinary_wrapper` are public;
auxiliary definitions/lemmas are private to the postlude.

The mathematical specification splits arbitrary finite `List UInt8` at 47,
preserving empties. A good component is neither empty, `[46]`, nor `[46,46]`, and
contains no zero. The result is exactly the ordered original byte components or
exactly `{:error, :invalid_path}`. The reference lemma connects this specification
to the *translated accepted reference*, using Lynx's public split/match lemmas.
The scanner invariant relates arbitrary separated components and a reversed
completed accumulator to the actual translated byte-recursive implementation.
It handles the first NUL, slash, ordinary byte, and end-of-input steps explicitly.
Induction over arbitrary lists/components supplies a normal `.ok` return for both
computations, not equality of two possibly exhausted computations. Consequently
the generated executable equality expectation returns `Except.ok Lynx.Term.true`.
There is no input bound, validity premise, resource-fuel premise or finite-corpus
substitution. Abstract normal termination is not a practical memory/time bound.

The separate wrapper theorem cases over every `Lynx.Term` constructor, including
bitstrings with nonzero final-bit count. Aligned bitstrings belong to the binary
law; all others return exactly `{:error, :not_binary}` under the wrapper law.
This models the accepted nonbinary BEAM domain; it does **not** prove translation
or term-representation correspondence for arbitrary deployed BEAM programs.

### Reached operations and purity

The retained generated `fixed/Elixir/**` and `fixed/Erlang/**` are the authoritative
operation inventory. Reached code uses:

- `is_binary`, `not`, exact `=:=`, ordinary `==`/`/=`, boolean short-circuiting,
  tuple/list/byte-binary construction and comparison;
- byte `matchEnd`, `matchInteger`, `matchTail`, `extract`, `append`, binary and
  integer segments in the scanner;
- `lists.member/2`, translated ordinary `lists.reverse/1,2`;
- public runtime `binary.split/3` (global, singleton slash), `binary.match/2`
  (singleton NUL), with checked `split_global_intercalate`, `match_first`,
  `match_absent`, and byte-comparison lemmas.

There is no filesystem, process state, message passing, random input, I/O,
Unicode conversion, callback or dynamically selected call in the obligations.
The model's fallible `Except` operations must all return normally in the proofs.
No runtime model extension or additional axiom is introduced.

## Run

Use the repository's `.tool-versions` and `lean-toolchain` (for example
`mise exec --` before host Mix commands). Fast host proof regression from root:

```sh
mkdir "$PWD/tmp/validator-host-new"
cd test/fixtures/projects/archive_path
MIX_ENV=prod mix compile --warnings-as-errors
VALIDATOR_OUTPUT="$PWD/../../../../tmp/validator-host-new" \
  MIX_ENV=prod mix run --no-compile proof_qualification_test.exs
```

Expected: **11 passes** (eight ordinary consumer tests and three proof/control
tests), exact two-law inventory, fresh full export in `fixed/proof.ndjson`, no
exports for rejected controls. This is not independent qualification.

For the clean offline Linux ARM64 qualification, bootstrap the unchanged Phase 01
image using [foundation instructions](../../docs/verification/foundation.md),
then from root:

```sh
sh proof/validator/run.sh "$PWD/tmp/validator-linux-new"
```

The output directory **must not exist**. The launcher allowlists sources, carries
the pinned Lynx Git source, and does not mount host dependency/build caches. It
runs nonroot, read-only, networkless with 6 GiB memory, four CPUs, 256 PIDs,
4 GiB scratch, 1 GiB temporary storage, and 1,800-second outer timeout. It probes
these boundaries and the real nested `bwrap` mechanism used by `lake check`.
See versioned scripts for every flag; the enclosing Linux VM is trusted.

The consumer builds under `MIX_ENV=prod` without dependency fetching. Both laws
must freshly verify; exact generated requires/ensures are checked. The complete
export is checked with `lake --dir deps/lynx/Lean check --paranoid --from-export`:
Lean paranoid, lean4lean, nanoda, con-leche, con-ron and Lean default must all
accept, with only `propext`, `Quot.sound`, `Classical.choice`. Malformed JSON and a
syntactically valid tampered binary-theorem proof must be rejected with real
checker diagnostics. Missing/skipped/cached claims do not count. Vulnerable `..`,
reject-all and changed-output witnesses are replayed on BEAM; strengthened
requirements are explicitly disallowed as a different statement. A transitive
`sorryAx` control must not export.

Retained evidence and exact identities are under
[`evidence/linux-arm64-2026-11-16`](evidence/linux-arm64-2026-11-16/MANIFEST.md).
Generated definitions, BEAM/debug/Core bytes, full compressed export, source
archive, reports and all checker outcomes are retained. These manually prepared,
writable-run records are diagnostic feasibility evidence for a trusted fixture,
not hostile-submission-proof receipts. No native macOS or CI x86_64 independent
checking qualification is implied.

## Contract identity

The candidate and acceptance JSON bytes, reference policy, fixed and vulnerable
implementations are unchanged. `contract/initial-laws.ex.txt` retains the exact
initial law source named by the immutable candidate. The identity test compares
old/current `requires`/`expects` ASTs with source metadata removed; proof options
may change but statements may not. `contract/proof-inputs.json` binds the new
proof-bearing source and proof bytes. Retained source/artifact manifests bind
all qualification inputs separately. The checker/translation/compiler/model trust
and sufficient-memory premise are unchanged; there are no product receipts.
