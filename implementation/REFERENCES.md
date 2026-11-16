# Implementation references

Use primary source at the selected revision before relying on behavior. The Lynx
baseline below was inspected for this roadmap; it is not proof that Pudding's
pinned environment builds it or that any Pudding validator has been proved.
Phase 01 must qualify dependencies, exact commands, and independent checkers.
External research is context, not local validation or a dependency decision.

## Lynx: primary implementation map

Repository: [josevalim/lynx](https://github.com/josevalim/lynx), baseline
`99a6db764c154207cf3b28c35409d9b56c463357`. Paths below refer to that revision;
re-audit coupling on any upgrade. Its `lean-toolchain` selects
`leanprover/lean4:v4.35.0`. Do not pin a moving branch or assume the sibling
checkout is this exact source.

| Source | What to inspect | Phases |
| --- | --- | --- |
| [README.md][lynx-readme], `AGENTS.md`, [lib/lynx.ex][lynx-api] | Build, laws, purity, recursion, public proof interfaces, exports, independent check instructions | 01–03, 06, 13 |
| [lib/lynx/case.ex][lynx-case], [lib/lynx/laws.ex][lynx-laws] | Direct ExUnit laws; `verify/2` roots/options/reports/raises; export bypasses cache | 01–03, 05–08 |
| [lib/lynx/translation.ex][lynx-translation] | BEAM/debug-info callback execution, reconstruction, closure/translation, purity, normal cache keys | 01, 04–06, 12 |
| [src/lynx_core_to_leanj.erl][lynx-core] | Core-to-JSON translation and generated law metadata; no compiler-equivalence claim | 03–06 |
| [Lean/Lynx/Runner.lean][lynx-runner] | Generated theorem types, elaboration, transitive axiom audit, exports, response/cache handling | 01, 03, 05–06, 12 |
| `lib/lynx/commands.ex` | Lake/tool resolution, inherited execution context, process lifecycle and failure surface | 01, 04, 06, 08 |
| [Lean/Lynx/Term.lean][lynx-term], `Lean/Lynx/Term/`, `Lean/Lynx/Modules/Erlang/` | Runtime representation, results/exhaustion, supported operation semantics and proof lemmas | 01, 03, 05 |
| [Lean/Lynx/Modules/Erlang/binary.lean][lynx-binary] | Byte split/match models and public decomposition lemmas | 02–03, 05 |
| `Lean/LynxTest/Modules/Binary.lean`, `Lean/LynxTest/PublicApi.lean`, `Lean/LynxTest/ProofAudit.lean` | Runtime probes, exported interfaces, proof/axiom audits; these are upstream tests, not Pudding policy proofs | 01, 03, 05–06 |
| `test/lynx/laws_test.exs`, `test/lynx/runner_test.exs`, translation fixtures | Report/error/export/audit regression patterns | 01, 05–06 |
| `examples/elixir/string.exs`, `examples/sum.exs`, `examples/otp/binary.exs` | Existing universal binary/list proof and termination patterns; reuse interfaces, not implementation substitutes | 01, 03 |

At this baseline, `Lynx.Laws.verify/2` returns reports with `:ok`, `:error`, or
`:skipped`; errors in translation/process execution may raise. Dependency reports
are included, and cached reports can omit theorem lists. Establish the exact
required claims separately. Exporting disables normal verification cache use,
but failure does not remove an export left at a reused path. Always start with
an empty unique output location.

The generated-law axiom audit permits `propext`, `Quot.sound`, and
`Classical.choice`. Independent checking uses the selected Lean toolchain's
`lake check --paranoid --from-export`; validate complete output and sandbox
requirements. A checker that exhausts fuel has not finished checking. Valid
exports do not by themselves bind the theorem to an externally accepted policy
or executable BEAM bytes. The roadmap's checker and provenance layers own that
additional authority.

[lynx-readme]: https://github.com/josevalim/lynx/blob/99a6db764c154207cf3b28c35409d9b56c463357/README.md
[lynx-api]: https://github.com/josevalim/lynx/blob/99a6db764c154207cf3b28c35409d9b56c463357/lib/lynx.ex
[lynx-case]: https://github.com/josevalim/lynx/blob/99a6db764c154207cf3b28c35409d9b56c463357/lib/lynx/case.ex
[lynx-laws]: https://github.com/josevalim/lynx/blob/99a6db764c154207cf3b28c35409d9b56c463357/lib/lynx/laws.ex
[lynx-translation]: https://github.com/josevalim/lynx/blob/99a6db764c154207cf3b28c35409d9b56c463357/lib/lynx/translation.ex
[lynx-core]: https://github.com/josevalim/lynx/blob/99a6db764c154207cf3b28c35409d9b56c463357/src/lynx_core_to_leanj.erl
[lynx-runner]: https://github.com/josevalim/lynx/blob/99a6db764c154207cf3b28c35409d9b56c463357/Lean/Lynx/Runner.lean
[lynx-term]: https://github.com/josevalim/lynx/blob/99a6db764c154207cf3b28c35409d9b56c463357/Lean/Lynx/Term.lean
[lynx-binary]: https://github.com/josevalim/lynx/blob/99a6db764c154207cf3b28c35409d9b56c463357/Lean/Lynx/Modules/Erlang/binary.lean

## Elixir/OTP build and runtime boundary

- Pudding's `.tool-versions` is authoritative (currently Elixir `1.20.2-otp-29`,
  Erlang `29.0.2`). Verify invoked binaries; host availability is not qualification.
- [Elixir `debug_info/4`, v1.20.2][elixir-debug]: actual `:core_v1` reconstruction
  callback. Executable callback dispatch is part of the isolation/trust boundary.
- [OTP `beam_lib`][beam-lib] and [compiler documentation][compile]: debug/compile
  chunks, Core reconstruction options, and compiler-internal compatibility caveats.
  These URLs are unversioned; inspect source at the actual pinned OTP for edge cases.
- [Mix compilation, v1.20.2][mix-compile], [compilation tracers][tracers], and
  [compile-time environment][compile-env]: build dependency and configuration inputs;
  none alone supplies a complete hermetic-build or freshness guarantee.
- [OTP bit syntax][bit-syntax]: binary/bitstring distinction. Runtime model claims
  require matching the actual pinned OTP implementation, not just documentation.
- [GHSA-9g37-pgj9-wrhc / CVE-2025-4748][zip-advisory]: historical archive-path
  motivation only. The initial `..` fixture is intentionally synthetic.

[elixir-debug]: https://github.com/elixir-lang/elixir/blob/v1.20.2/lib/elixir/src/elixir_erl.erl
[beam-lib]: https://www.erlang.org/doc/apps/stdlib/beam_lib.html
[compile]: https://www.erlang.org/doc/apps/compiler/compile.html
[mix-compile]: https://mix.hexdocs.pm/1.20.2/Mix.Tasks.Compile.Elixir.html
[tracers]: https://hexdocs.pm/elixir/1.20.2/Code.html#module-compilation-tracers
[compile-env]: https://hexdocs.pm/elixir/1.20.2/Application.html#module-compile-time-environment
[bit-syntax]: https://www.erlang.org/docs/29/system/bit_syntax.html
[zip-advisory]: https://github.com/erlang/otp/security/advisories/GHSA-9g37-pgj9-wrhc

## Selective methodological background

- [Validating Formal Semantics by Property-Based Cross-Testing][cross-testing],
  Bereczky et al.: empirical disagreement-finding, not universal equivalence.
- [OSS Verify checking notes][checking], revision
  `98e995d4daced70a0a4aa2c810854b88720735f1`: exact statement, assumptions,
  checker isolation, and independent replay as precedents, not adopted machinery.
- [StreamData][stream-data]: generation/shrinking design reference, not an approved
  dependency or coverage-guided engine. Start with existing facilities.
- [EverParse][everparse]: useful functional parser contracts and reusable proof
  structure; generated-code results do not transfer automatically to Elixir.

[cross-testing]: https://kar.kent.ac.uk/89480/
[checking]: https://github.com/theorem-labs/oss-verify-proofs/blob/98e995d4daced70a0a4aa2c810854b88720735f1/docs/checking.md
[stream-data]: https://stream-data.hexdocs.pm/
[everparse]: https://project-everest.github.io/assets/everparse.pdf
