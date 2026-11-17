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

**Universal model proofs now independently replay.** Phase 03 adds checked
postlude proofs for both exact full-domain obligations, fresh export and statement
inspection, BEAM negative-control witnesses, and clean offline Linux ARM64 replay
through all six independent/paranoid checkers. See the
[proof recipe](../../../../proof/validator/README.md) and
[Phase 03 handoff](../../../../implementation/03-validator-proof/HANDOFF.md).
The initial accepted predicates and implementation bytes are unchanged. These are
direct feasibility artifacts, not verified translation or product receipts.
CI also runs the proof/control harness, but is not the qualified independent
checker environment.
