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
docs, and the tests. Run it before opening a PR — a green `precommit` means a
green CI. Dialyzer is slow, so it runs in CI only; run `mix dialyzer` locally
when you want it.

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
