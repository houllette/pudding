# Agent Guidelines

## Project overview

Pudding is an Elixir security verification toolkit that integrates with Mix to
discover security properties, find counterexamples, and generate independently
checked formal proofs tied to actual implementations. It is built on precise
execution semantics and a growing collection of reusable lemmas and verified
library contracts, with the aim of making increasingly complex code practical
to verify. The long-term goal is autonomous analysis and patch generation, with
incremental verification in CI and explicit reporting of what is proved,
assumed, unsupported, or unknown.

It's a library (`mix new`, no supervision tree): other projects pull it in as a
dependency and drive it through Mix. If it grows long-lived processes (solver
or checker pools, caches for incremental runs), add an `Application` module
deliberately rather than starting processes ad hoc.

[`reach`](https://hexdocs.pm/reach) (program dependence graphs) is a
**test-only** dependency. Tests may use it; `lib/` code must not. `precommit`
and CI both run under `MIX_ENV=test`, so a `Reach` call in `lib/` would pass
every check and then fail for anyone using Pudding outside its own test suite.

Those four result categories are a contract, not a formatting choice. Code that
can't establish a property must say so — never let an unhandled case, a
timeout, or an unsupported construct fall through to "proved".

## Commands

Everything below is bundled into one alias. **Run `mix precommit` when you
think you're done** — it runs the same checks CI runs, so a green `precommit`
means a green PR.

| Task | Command |
| --- | --- |
| Everything (run this before you're done) | `mix precommit` |
| Install deps | `mix deps.get` |
| Compile (warnings are errors in CI) | `mix compile --warnings-as-errors` |
| Run all tests | `mix test` |
| Run one test file | `mix test test/path/to/file_test.exs` |
| Run one test | `mix test test/path/to/file_test.exs:LINE` |
| Format | `mix format` |
| Lint | `mix credo --strict` |
| Compile-time dependency check | `mix xref graph --label compile-connected --fail-above 0` |
| Type check (slow; runs in CI, not in `precommit`) | `mix dialyzer` |
| Dependency vulnerabilities | `mix deps.audit` |
| Retired packages | `mix hex.audit` |
| Refresh AGENTS.md usage rules | `mix usage_rules.sync --yes` |
| Check those rules are current | `mix usage_rules.sync --check` |
| Search dependency docs | `mix usage_rules.search_docs "term" -p package` |
| Start the Tidewave MCP server (dev, port 4000) | `mix tidewave` |

Some of these only exist once the matching dep is installed; the `precommit`
alias in `mix.exs` is the authoritative list for this project.

## Conventions

- **Run `mix precommit` before declaring work finished.** Fix what it reports
  rather than narrowing the check or adding a suppression. If a check is
  genuinely wrong for this project, change the config in a separate commit and
  say why.
- **Format before committing.** CI enforces `mix format --check-formatted`.
- **No compiler warnings.** CI compiles with `--warnings-as-errors`, and tests
  run with `--warnings-as-errors` too — test files are held to the same bar.
- **Test-first when practical.** Add or update an ExUnit test that captures the
  behavior change, watch it fail, then implement. Use `async: true` in test
  modules unless they share global state (named processes, the database outside
  the SQL sandbox, Application env).
- **A test must be able to fail.** No test without an assertion, and no
  assertion that holds regardless of the code under test (`assert x == x`,
  or `assert is_map(result)` where every return value passes). If you can't
  write an assertion that would have failed before the change, the test isn't
  earning its keep.
- **Don't add dependencies to solve small problems.** The standard library
  covers date and time (`Date`, `Time`, `DateTime`, `Calendar`), and every new
  dep is one more thing CI has to audit. Ask before adding one.
- **Pattern match at function heads** rather than with nested `case`/`cond`
  where it reads naturally; use `with` for chains of fallible calls. Never
  write a `case` whose only clauses are `true` and `false` — that's an `if`.
- **Let it crash where appropriate.** Don't defensively rescue exceptions in
  supervised processes; reserve `try/rescue` for genuine boundary concerns.
  Never `rescue` an exception only to log it and continue.
- **Typespecs on public functions** of library-style modules; Dialyzer runs in
  CI when `dialyxir` is installed. Name the arguments in the spec —
  `@spec fetch(user_id :: integer()) :: {:ok, t()} | {:error, term()}`.
- **Keep runtime deps out of compile time.** `mix xref graph --label
  compile-connected --fail-above 0` fails the build when a module edit starts
  triggering wide recompiles. The fix is usually to stop invoking a macro or
  referencing a struct at compile time across a context boundary.
- **Don't edit generated or vendored files** (`deps/`, `_build/`,
  `priv/static/assets/`, migration files that have already shipped).

## Framework and library guidelines

Anything between the `usage-rules-start` and `usage-rules-end` comment markers
at the end of this file is **generated from the installed dependencies** by
`mix usage_rules.sync`. (Don't quote those markers verbatim in prose here: the
task finds the block by string-matching them, and a quoted copy breaks it.) Never hand-edit inside those markers:
the next sync overwrites it, and CI fails when the block is out of date. Put
your own guidance above the markers instead. After changing dependencies, run
`mix usage_rules.sync --yes` and commit the result.

That task prompts for confirmation, so it hangs if you run it bare in a
non-interactive shell. Always pass `--yes` (write the changes) or `--check`
(exit non-zero if stale, without writing).

## Versions

Erlang/Elixir versions are pinned in `.tool-versions` (used by asdf/mise
locally and by `erlef/setup-beam` in CI). Bump versions there, nowhere else.

<!-- usage-rules-start -->
<!-- usage_rules-start -->
## usage_rules usage
_A config-driven dev tool for Elixir projects to manage AGENTS.md files and agent skills from dependencies_

## Using Usage Rules

Many packages have usage rules, which you should *thoroughly* consult before taking any
action. These usage rules contain guidelines and rules *directly from the package authors*.
They are your best source of knowledge for making decisions.

## Modules & functions in the current app and dependencies

When looking for docs for modules & functions that are dependencies of the current project,
or for Elixir itself, use `mix usage_rules.docs`

```
# Search a whole module
mix usage_rules.docs Enum

# Search a specific function
mix usage_rules.docs Enum.zip

# Search a specific function & arity
mix usage_rules.docs Enum.zip/1
```


## Searching Documentation

You should also consult the documentation of any tools you are using, early and often. The best 
way to accomplish this is to use the `usage_rules.search_docs` mix task. Once you have
found what you are looking for, use the links in the search results to get more detail. For example:

```
# Search docs for all packages in the current application, including Elixir
mix usage_rules.search_docs Enum.zip

# Search docs for specific packages
mix usage_rules.search_docs Req.get -p req

# Search docs for multi-word queries
mix usage_rules.search_docs "making requests" -p req

# Search only in titles (useful for finding specific functions/modules)
mix usage_rules.search_docs "Enum.zip" --query-by title
```


<!-- usage_rules-end -->
<!-- usage_rules:elixir-start -->
## usage_rules:elixir usage
# Elixir Core Usage Rules

## Pattern Matching
- Use pattern matching over conditional logic when possible
- Prefer to match on function heads instead of using `if`/`else` or `case` in function bodies
- `%{}` matches ANY map, not just empty maps. Use `map_size(map) == 0` guard to check for truly empty maps

## Error Handling
- Use `{:ok, result}` and `{:error, reason}` tuples for operations that can fail
- Avoid raising exceptions for control flow
- Use `with` for chaining operations that return `{:ok, _}` or `{:error, _}`

## Common Mistakes to Avoid
- Elixir has no `return` statement, nor early returns. The last expression in a block is always returned.
- Don't use `Enum` functions on large collections when `Stream` is more appropriate
- Avoid nested `case` statements - refactor to a single `case`, `with` or separate functions
- Don't use `String.to_atom/1` on user input (memory leak risk)
- Lists and enumerables cannot be indexed with brackets. Use pattern matching or `Enum` functions
- Prefer `Enum` functions like `Enum.reduce` over recursion
- When recursion is necessary, prefer to use pattern matching in function heads for base case detection
- Using the process dictionary is typically a sign of unidiomatic code
- Only use macros if explicitly requested
- There are many useful standard library functions, prefer to use them where possible

## Function Design
- Use guard clauses: `when is_binary(name) and byte_size(name) > 0`
- Prefer multiple function clauses over complex conditional logic
- Name functions descriptively: `calculate_total_price/2` not `calc/2`
- Predicate function names should not start with `is` and should end in a question mark.
- Names like `is_thing` should be reserved for guards

## Data Structures
- Use structs over maps when the shape is known: `defstruct [:name, :age]`
- Prefer keyword lists for options: `[timeout: 5000, retries: 3]`
- Use maps for dynamic key-value data
- Prefer to prepend to lists `[new | list]` not `list ++ [new]`

## Mix Tasks

- Use `mix help` to list available mix tasks
- Use `mix help task_name` to get docs for an individual task
- Read the docs and options fully before using tasks

## Testing
- Run tests in a specific file with `mix test test/my_test.exs` and a specific test with the line number `mix test path/to/test.exs:123`
- Limit the number of failed tests with `mix test --max-failures n`
- Use `@tag` to tag specific tests, and `mix test --only tag` to run only those tests
- Use `assert_raise` for testing expected exceptions: `assert_raise ArgumentError, fn -> invalid_function() end`
- Use `mix help test` to for full documentation on running tests

## Debugging

- Use `dbg/1` to print values while debugging. This will display the formatted value and other relevant information in the console.

<!-- usage_rules:elixir-end -->
<!-- usage_rules:otp-start -->
## usage_rules:otp usage
# OTP Usage Rules

## GenServer Best Practices
- Keep state simple and serializable
- Handle all expected messages explicitly
- Use `handle_continue/2` for post-init work
- Implement proper cleanup in `terminate/2` when necessary

## Process Communication
- Use `GenServer.call/3` for synchronous requests expecting replies
- Use `GenServer.cast/2` for fire-and-forget messages.
- When in doubt, use `call` over `cast`, to ensure back-pressure
- Set appropriate timeouts for `call/3` operations

## Fault Tolerance
- Set up processes such that they can handle crashing and being restarted by supervisors
- Use `:max_restarts` and `:max_seconds` to prevent restart loops

## Task and Async
- Use `Task.Supervisor` for better fault tolerance
- Handle task failures with `Task.yield/2` or `Task.shutdown/2`
- Set appropriate task timeouts
- Use `Task.async_stream/3` for concurrent enumeration with back-pressure

<!-- usage_rules:otp-end -->
<!-- usage-rules-end -->
