# Archive-path byte contract, version 1

- Immutable proposal: [candidates/archive-path-v1.json](candidates/archive-path-v1.json).
- Separate owner acceptance: [accepted/archive-path-v1.json](accepted/archive-path-v1.json).
- Contract ID: `pudding.archive_path.bytes/v1`.
- Accepted candidate SHA256:
  `f576679bad86234b75c59241be674e2cfab0bf0c704cdef8845f516057ea8d7f`.

The candidate is deliberately still marked candidate. Acceptance points to its
exact bytes rather than rewriting the proposal. The acceptance is a transcription
of the owner's explicit session answer, not an authenticated signature or proof.
`Pudding.Contracts.IdentityTest` checks the record linkage and current reference
and initial-law digests; it cannot establish human authority by itself.

## Exact behavior

For **every finite byte-aligned binary**, split at byte `0x2F` (`/`), preserving
all empty components. The empty binary splits into `[<<>>]`. A path is valid iff
every component is nonempty, is not exact `.` or `..`, and contains no NUL byte.
Valid input returns exactly `{:ok, original_components}` in order; invalid input
returns exactly `{:error, :invalid_path}`. Unexpected exceptions, exhaustion,
sanitized output and divergence do not satisfy the contract. No input length
bound or validity premise is permitted.

For **every nonbinary BEAM term**, including nonbyte-aligned bitstrings, the
separate wrapper obligation returns exactly `{:error, :not_binary}`. Abstract
termination assumes idealized sufficient memory; no practical resource, latency
or denial-of-service guarantee follows. Phase 03 must check the model's actual
coverage of both promised domains, not silently narrow them.

| Input | Exact result |
| --- | --- |
| `"a/b"` | `{:ok, ["a", "b"]}` |
| `".../.hidden"` | `{:ok, ["...", ".hidden"]}` |
| `<<255, 47, 192, 128>>` | `{:ok, [<<255>>, <<192, 128>>]}` |
| `"C:/%2e%2e"` | `{:ok, ["C:", "%2e%2e"]}` |
| `<<97, 92, 98>>` (backslash) | `{:ok, [<<97, 92, 98>>]}` |
| `""`, `"."`, `".."`, `"../"`, `"/a"`, `"a/"`, `"a//b"` | `{:error, :invalid_path}` |
| `<<97, 0, 98>>` | `{:error, :invalid_path}` |
| `<<1::1>>`, `nil`, `[97]` | `{:error, :not_binary}` |

Invalid UTF-8 is valid byte content. Backslash, colon and percent sequences have
no special interpretation. There is no Unicode, normalization, decoding,
filesystem/symlink, Windows-path, ZIP or safe-extraction claim. A downstream
consumer that reinterprets these bytes needs its own composition contract.

## Implementations and obligations

The oracle is `Pudding.Contracts.PathPolicy.expected/1`, which splits first and
checks complete components. The ordinary [archive_path consumer](../projects/archive_path)
contains a separate incremental byte-recursive fixed implementation and an
intentionally flawed check that rejects `../` but accepts `..`. This is a
**synthetic defect**, not a historical OTP ZIP advisory reproduction.

The required law inventory is exactly:

1. `ArchivePath.Laws.binary_contract/1`: requires only `is_binary(input)`;
   expects exact fixed/oracle equality on valid **and invalid** input.
2. `ArchivePath.Laws.nonbinary_wrapper/1`: requires `not is_binary(input)`;
   expects the exact wrapper error.

Law statements are executable initial obligations, **not completed proofs**.
The candidate's expected Lean names must be checked against generated statements
in phase 03. The eventual expectation must successfully return
`Except.ok Lynx.Term.true`; equal exhausted computations do not suffice.

Reject-all and sanitized-output controls fail useful-acceptance/output obligations.
The deliberately stronger requirement fails to return true on `..`, demonstrating
how it hides an in-domain malicious input. Passing concrete cases does not prove
universal equivalence, model conformance or executable BEAM correspondence.

## Changes and authority

Do not edit this accepted candidate to accommodate a proof. Policy/source-predicate,
domain, quantifier, required expectation, output, assumption or exclusion changes
need a new separately retained candidate and explicit owner acceptance. Pure
implementation/proof changes require fresh artifact identities, unchanged-predicate
review and all dependent rechecking. The initial-law digest records Phase 02's
bytes; extending proof source in Phase 03 requires updating the source-identity
check with explicit statement review, not weakening any obligation. Schema v1
records contract state descriptively; it cannot authenticate acceptance or issue
`proved` receipts.
