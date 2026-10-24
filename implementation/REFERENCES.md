# Research references

These numbered sources were retained from the October 23, 2026 research brief
when the implementation plan superseded it. Phase reading lists use the same
reference numbers. Original section numbers are mapped in [SOURCE_MAP.md](SOURCE_MAP.md).

The brief recorded a primary-source review on October 23, 2026; the sources
were not rechecked during this document reorganization. Pinned repository links
identify inspected revisions. Unversioned documentation reflects the version
retrieved for that review. Agents must verify relevant source and toolchain
compatibility during implementation. Published external results are not Pudding
validation results, and research thresholds remain proposals until measured.

## Numbered sources

1. Erlang/OTP, **[BeamAsm, the Erlang JIT][1]**. Load-time native generation and interaction with runtime services and shared fragments.
2. Björn Gustavsson, Erlang/OTP, **[The Optimizations in Erlang/OTP 27][2]**, April 23, 2024. Native assembly inspection with `+JDdump true`.
3. Anthropic, **[LLMs are making formal software verification feasible at a much larger scale][3]**, October 22, 2026. Reported 239-entry-point / 123-library experiment and its limitations.
4. Theorem, **[OSS Verify README][4]**, revision `98e995d4daced70a0a4aa2c810854b88720735f1`. Public proof counts, agreement statements, premises, and absence of released halting proofs.
5. Theorem, **[LPS: the Linux process semantics][5]**, same OSS Verify revision. Formal model scope and declared limitations; links to the pinned LPS source and scope document.
6. Péter Bereczky, Dániel Horpácsi, and Simon Thompson, **[A Formalisation of Core Erlang, a Concurrent Actor Language][6]**, 2023 preprint. Machine-checked concurrent semantics and equivalence results.
7. Erlang/OTP, **[beam_core_to_ssa.erl][7]**, tag `OTP-29.0.2`. Compiler implementation and translation stages.
8. **[StreamData documentation][8]**, retrieved v1.4.0. Generation, shrinking, and reproducible seeds; not a coverage-guided search engine by itself.
9. **[Concuerror FAQ][9]** and its [schedule-exploration tutorial](https://concuerror.com/tutorials/concuerring-concuerror-ep-1.html). Systematic concurrency testing, supported operations, exploration bounds, and input limitations. Check its [supported-release policy](https://concuerror.com/download/) before integration.
10. HARP, **[Core Erlang Formalization README][10]**, revision `4a59339cdc5c9cff3a144732397d56dfa7378631`. Build requirements, development structure, interpreter, and license.
11. HARP, **[src/Syntax.v][11]**, same revision. Actual main-language constructors; no binary/bitstring constructors.
12. HARP, **[src/Auxiliaries.v][12]**, same revision, especially `eval` and its dispatcher. Modeled operations and the unknown-function fallback.
13. Erlang/OTP, **[compile documentation][13]**, retrieved OTP 29.1.2. Compiler option behavior and warnings about Core primops and BEAM compatibility.
14. Elixir, **[elixir_erl.erl][14]**, tag `v1.20.2`, `debug_info/4`. Actual implementation of the `:core_v1` reconstruction callback.
15. Erlang/OTP, **[beam_lib documentation][15]**, retrieved OTP 29.1.2. BEAM chunks and debug-information availability.
16. Bereczky, Horpácsi, and Thompson, **[A Frame Stack Semantics for Sequential Core Erlang][16]**, 2023 preprint / IFL 2023 work. Sequential semantics, exceptions, and equivalence concepts.
17. HARP, **[src/Interpreter/Equivalences.v][17]**, inspected revision. Correspondence between relational and executable step definitions, including their conditions.
18. Bereczky, Horpácsi, Judit Kőszegi, Soma Szeier, and Thompson, **[Validating Formal Semantics by Property-Based Cross-Testing][18]**, IFL 2020 proceedings, published 2021, DOI `10.1145/3462172.3462200`. See also the authors' [cross-testing implementation](https://github.com/harp-project/erlang-semantics-testing).
19. Rocq, **[The Rocq Prover commands][19]**, v9.1.0 reference manual. Compilation, proof-skipping interfaces, and standalone `rocqchk` behavior.
20. Rocq, **[Commands: assumptions and typing flags][20]**, v9.1.0 reference manual. Transitive assumption inspection and unsafe checking settings.
21. **[SMTCoq README][21]**, revision `7b870140f2ff7e4547a7db614a305d8b2945afa3`. Certified external-witness checking and the distinction between proof tactics and abduction.
22. **[SMTCoq installation instructions][22]**, same revision. Explicit solver/version requirements and proof-production modes. These require a compatibility test with the pinned proof environment.
23. Elixir/Mix, **[mix compile.elixir][23]**, v1.20.2. Incremental compilation, external resources, and custom recompilation hooks.
24. Elixir, **[Code: compilation tracers][24]**, v1.20.2. Compiler observation hooks and their scope.
25. Elixir, **[Application: compile-time environment][25]**, v1.20.2. Configuration tracking and compile/runtime distinctions.
26. Erlang/OTP maintainers, **[GHSA-9g37-pgj9-wrhc: Absolute Path in Zip Module][26]**, June 16, 2025, CVE-2025-4748. Historical security motivation; not the synthetic defect used in this brief.
27. CutEr authors, **[CutEr README][27]**, revision `79197e286286acfcd4dc253136b34c1ffa481148`. Concolic testing design and the documented OTP 20.0–22.3 support range.
28. Emanuele D'Osualdo, Jonathan Kochems, and C.-H. Luke Ong, **[Automatic Verification of Erlang-Style Concurrency][28]**, 2013. Abstract interpretation and the Soter actor-verification approach.
29. Matthew Neave, **[Verlixir: Verification of Message-Passing Systems][29]**, Imperial College London MEng project, June 17, 2024. Elixir-subset contracts and temporal specifications.
30. Erlang/OTP, **[cover documentation][30]**, retrieved OTP 29.1.2. Executable-line counters, clause-level results, and coverage instrumentation.
31. Theorem, **[How a proof is checked][31]**, inspected OSS Verify revision. Exact-statement wrappers, assumption audits, checker isolation, and optional standalone rechecking. Its checker configuration is a precedent, not Pudding's adopted trust policy.
32. Erlang/OTP, **[cerl_trees.erl][32]**, tag `OTP-29.0.2`. Core tree traversal API and its internal-API compatibility warning.
33. Tahina Ramananandro et al., **[EverParse: Verified Secure Zero-Copy Parsers for Authenticated Message Formats][33]**, USENIX Security 2019. Reusable parser verification and functional security properties in a generated-code workflow.
34. Erlang/OTP, **[Bit Syntax][34]**, retrieved OTP 29.0.6 system documentation. Binary/bitstring distinction and segment interpretation; implementation compatibility still targets OTP 29.0.2.

[1]: https://www.erlang.org/doc/apps/erts/beamasm.html
[2]: https://www.erlang.org/blog/optimizations/
[3]: https://www.anthropic.com/research/formal-verification
[4]: https://github.com/theorem-labs/oss-verify-proofs/blob/98e995d4daced70a0a4aa2c810854b88720735f1/README.md
[5]: https://github.com/theorem-labs/oss-verify-proofs/blob/98e995d4daced70a0a4aa2c810854b88720735f1/docs/semantics.md
[6]: https://arxiv.org/abs/2311.10482
[7]: https://github.com/erlang/otp/blob/OTP-29.0.2/lib/compiler/src/beam_core_to_ssa.erl
[8]: https://stream-data.hexdocs.pm/
[9]: https://concuerror.com/faq/
[10]: https://github.com/harp-project/Core-Erlang-Formalization/blob/4a59339cdc5c9cff3a144732397d56dfa7378631/README.md
[11]: https://github.com/harp-project/Core-Erlang-Formalization/blob/4a59339cdc5c9cff3a144732397d56dfa7378631/src/Syntax.v
[12]: https://github.com/harp-project/Core-Erlang-Formalization/blob/4a59339cdc5c9cff3a144732397d56dfa7378631/src/Auxiliaries.v
[13]: https://www.erlang.org/doc/apps/compiler/compile.html
[14]: https://github.com/elixir-lang/elixir/blob/v1.20.2/lib/elixir/src/elixir_erl.erl
[15]: https://www.erlang.org/doc/apps/stdlib/beam_lib.html
[16]: https://arxiv.org/abs/2308.12403
[17]: https://github.com/harp-project/Core-Erlang-Formalization/blob/4a59339cdc5c9cff3a144732397d56dfa7378631/src/Interpreter/Equivalences.v
[18]: https://kar.kent.ac.uk/89480/
[19]: https://rocq-prover.org/doc/V9.1.0/refman/practical-tools/coq-commands.html
[20]: https://rocq-prover.org/doc/V9.1.0/refman/proof-engine/vernacular-commands.html
[21]: https://github.com/smtcoq/smtcoq/blob/7b870140f2ff7e4547a7db614a305d8b2945afa3/README.md
[22]: https://github.com/smtcoq/smtcoq/blob/7b870140f2ff7e4547a7db614a305d8b2945afa3/INSTALL.md
[23]: https://mix.hexdocs.pm/1.20.2/Mix.Tasks.Compile.Elixir.html
[24]: https://elixir.hexdocs.pm/1.20.2/Code.html#module-compilation-tracers
[25]: https://elixir.hexdocs.pm/1.20.2/Application.html#module-compile-time-environment
[26]: https://github.com/erlang/otp/security/advisories/GHSA-9g37-pgj9-wrhc
[27]: https://github.com/cuter-testing/cuter/blob/79197e286286acfcd4dc253136b34c1ffa481148/README.md
[28]: https://arxiv.org/abs/1303.2201
[29]: https://www.imperial.ac.uk/media/imperial-college/faculty-of-engineering/computing/public/distinguished-projects/2324-ug-projects/Neave%2C-Matt-Verlixir-Verification-of-Message-Passing-Systems.pdf
[30]: https://www.erlang.org/doc/apps/tools/cover.html
[31]: https://github.com/theorem-labs/oss-verify-proofs/blob/98e995d4daced70a0a4aa2c810854b88720735f1/docs/checking.md
[32]: https://github.com/erlang/otp/blob/OTP-29.0.2/lib/compiler/src/cerl_trees.erl
[33]: https://project-everest.github.io/assets/everparse.pdf
[34]: https://www.erlang.org/docs/29/system/bit_syntax.html
