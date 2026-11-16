# Ordinary archive-path consumer

A standalone Mix project depending on Pudding by path and pinned Lynx transitively.
Both implementations remain ordinary Elixir/BEAM code. `ArchivePath.Fixed` scans
raw bytes incrementally; `ArchivePath.Vulnerable` intentionally rejects `../` but
accepts `..`. This is a **synthetic defect**, not an OTP ZIP advisory reproduction.
The vulnerable implementation also overrejects some safe substrings; its behavior
is not the specification.

The separately reviewed reference is `Pudding.Contracts.PathPolicy.expected/1`.
See the [accepted byte contract](../../contracts/README.md) and its immutable
candidate/acceptance records. The law requirements cover the full binary domain,
and a separate wrapper obligation covers every nonbinary term including nonbyte
bitstrings. Reject-all, sanitized-output and hidden-validity-precondition controls
are intentionally wrong, retained to test contract strength.

From this directory, with the repository's pinned toolchain:

```sh
MIX_ENV=prod mix deps.get
MIX_ENV=prod mix compile --warnings-as-errors
MIX_ENV=prod mix run qualification.exs
```

Qualification asserts eight ExUnit tests, including finite boundary/differential
checks, executable law assertions, exact law inventory and no Reach at runtime.
It exits nonzero on failures. `mix test --warnings-as-errors` is also supported;
root test discovery deliberately does not load this standalone project's tests.
Root `mix precommit` and CI run production qualification explicitly.

**No universal proof yet.** The initial `Lynx.Laws` definitions use the default
initial proof attempt, not completed proofs. Phase 02 runs their executable BEAM
assertions only; no `Lynx.Laws.verify/2`, exports or independent checker runs are
claimed. Phase 03 must inspect generated Lean statements, prove total successful
expectation return, qualify both promised domains and independently replay the
complete required proof closure. This fixture does not create product receipts.
