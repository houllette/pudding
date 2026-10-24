# Phase 06 — Build the independent exact-theorem checker

**State:** Not started.

**Depends on:** Passed phases 01–05; contract/import/trust identities fixed.

**Next:** [07 — First implementation theorem](../07-first-implementation-theorem/README.md).

**Brief:** Sections 6, 9–11, 13.3, 13.5, and 14; references 19–20 and 31.

## Assignment

Create the only path that can issue a proved result: an isolated checker that
regenerates the expected theorem and accepts proof source only against that
exact statement and an audited transitive assumption policy.

## Work

1. Define trusted preparation inputs: captured/imported-program identity,
   accepted contract/domain, semantics, BIF summaries, and checker policy.
   Validate immutable bindings and generate the expected theorem outside worker
   write authority. A claimed submission theorem name/type is never authority.
2. Accept proof source in a separate workspace with bounded CPU/memory/time and
   output. Mount trusted inputs read-only; expose no credentials/network. Reject
   arbitrary plugins and artifact replacement, including forged compiled objects.
3. Compile ordinary proof objects from source and an exact-type wrapper that
   assigns the submitted proof to the trusted expected theorem. Ensure the
   audited theorem is the wrapper actually checked for the claimed implementation.
4. Audit transitive `Print Assumptions` with a reviewed explicit allowlist.
   Separate logical axioms, theorem premises, and trusted semantic operations.
   Reject unknown audit syntax and disabled guard/positivity/universe checking.
   Inspect dependencies/flags, not just source tokens such as `Admitted`.
5. Run standalone `rocqchk` on the theorem and complete dependency closure, with
   no dependency-skipping options. Start without `native_compute` or worker
   extensions; record trusted conversion/plugin machinery and recheck cost.
6. Produce durable checker records and an offline replay command requiring
   neither a model, solver service, nor the original proof-search transcript.
   Record unsupported audit cases and failures as non-success.

## Deliverables

Checker module/runner, pinned checker environment and policy, exact-statement
generation, hostile submission corpus, and `docs/verification/checking.md`.
Use a small checker test theorem for harness development; phase 07 must still
establish the useful imported-helper theorem.

## Validation and handoff gate

- [ ] A valid ordinary proof is accepted in a clean checker environment and
  linked to the exact immutable program/contract/model.
- [ ] Weakened contract, stronger precondition, wrong target/build, replaced
  importer output, and forged/stale object substitutions are refused.
- [ ] Direct admission, hidden dependency axiom, unauthorized premise, unsafe
  flags, unknown audit output, worker plugin, and missing dependency recheck
  fail for the expected reason.
- [ ] Checker timeout/crash and exhausted resource budgets remain unknown with
  retained diagnostics; no partial receipt authorizes a proved result.
- [ ] Assumption audit and full `rocqchk` records can be replayed without the agent.
- [ ] `mix precommit` and non-test library compilation pass.

Write `HANDOFF.md` with checker/policy hashes, hostile-case results, trust
inventory, exact wrapper template, replay commands, and measured recheck cost.

## Boundary

The checker cannot establish that an arbitrary wrong import matches the BEAM.
That remains trusted/tested through prior phases. Do not present hash validation
or a valid theorem about substituted syntax as implementation correspondence.
