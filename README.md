# Pudding

An Elixir security verification toolkit that integrates with Mix to discover
security properties, find counterexamples, and generate independently checked
formal proofs tied to actual implementations.

Pudding is built on precise execution semantics and a growing collection of
reusable lemmas and verified library contracts, with the aim of making
increasingly complex code practical to verify. The long-term goal is autonomous
analysis and patch generation, with incremental verification in CI and explicit
reporting of what is **proved**, **assumed**, **unsupported**, or **unknown**.

> Status: early development. There is no stable API yet.

The [implementation plan](implementation/README.md) organizes the work into ordered
phases for dedicated agent runs, with validation gates and handoff requirements.

## Completed phases and interfaces

**Phases 01–03 are complete.** The
[accepted archive-path byte contract](test/fixtures/contracts/README.md) has
an independent executable reference, `Pudding.Contracts.PathPolicy.expected/1`,
and [ordinary vulnerable/fixed consumer fixtures](test/fixtures/projects/archive_path/README.md).
The fixed validator's full-domain binary law and separate nonbinary wrapper law
are now [proved and independently replayed through six checkers](https://github.com/houllette/pudding/blob/main/implementation/03-validator-proof/HANDOFF.md).
[Proof sources, controls and replay instructions](https://github.com/houllette/pudding/blob/main/proof/validator/README.md) retain
the exact accepted policy, normal-return obligations and artifact identities.
These are direct model proofs, not verified compiler/translation correspondence,
a filesystem or safe-extraction guarantee, or product `proved` receipts.

[`Pudding.Result`](docs/verification/results.md) defines a versioned observation
schema with separate outcome, assumed premises, approval, conformance and freshness.
It cannot issue `proved` receipts. General build capture begins in Phase 04;
trusted product evidence checking remains Phase 06. Phases 04–13 are not started.

## Development

Erlang and Elixir versions are pinned in [`.tool-versions`](https://github.com/houllette/pudding/blob/main/.tool-versions);
install them with `mise install` (or `asdf install`).

```sh
mix deps.get
iex -S mix        # load the library in a shell
```

## Tests and checks

```sh
mix test                              # the suite
mix test test/path/to/file_test.exs   # one file
mix precommit                         # everything CI checks, in one go
```

`mix precommit` runs the dependency audits, a warnings-as-errors compile,
formatting, Credo, the usage-rules sync, the compile-time dependency check,
docs, the root tests, and ordinary production archive-path consumer qualification.
Run it before opening a PR; CI also runs Dialyzer and platform-specific checks,
so a local pass alone does not establish a green remote CI run. Dialyzer is slow,
so it runs in CI only by default; run `mix dialyzer` locally when you want it.

## Agent tooling

[`AGENTS.md`](https://github.com/houllette/pudding/blob/main/AGENTS.md) holds the guidance for coding agents (`CLAUDE.md`
points at it). The block at its end is generated from dependencies — refresh it
with `mix usage_rules.sync --yes` after changing deps.

[Tidewave](https://github.com/tidewave-ai/tidewave_phoenix) lets an agent work
against the running project: evaluate code in it, read its logs, and pull docs
pinned to the exact locked dependency versions. Start it with:

```sh
mix tidewave      # serves the MCP endpoint on http://localhost:4000/tidewave/mcp
```

`.mcp.json` registers that endpoint for Claude Code. It stays pending until you
approve it in an interactive `claude` session, and it only answers while
`mix tidewave` is running. `/mcp` confirms the connection.

## License

MIT — see [LICENSE](https://github.com/houllette/pudding/blob/main/LICENSE).
