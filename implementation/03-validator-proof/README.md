# Phase 03 — Prove the actual binary validator directly with Lynx

**State:** Complete — [handoff and qualification evidence](HANDOFF.md).
The five gates below passed for the full accepted contract on Linux ARM64.

**Depends on:** Passed phases 01–02 and current prerequisite handoffs.

**Next:** [04 — Capture isolated builds and implementation provenance](../04-build-capture/README.md).

Read the [shared architecture](../ARCHITECTURE.md), [plan](../README.md), and
[backend/reference sources](../REFERENCES.md) with the prerequisite handoffs.

## Assignment

Hand-prove the fixed fixture's full accepted contract through Lynx before
building Pudding's general capture or adapter layers. The implementation under
proof must come from the ordinary compiled fixture, not a proof-friendly rewrite.
This is the first feasibility gate, including independent replay.

## Work

1. Compile the accepted reference and fixed implementation under the qualified
   environment. Retain BEAM/debug bytes, versions/options, reconstructed/translated
   artifacts available through Lynx, and exact law definitions. Manual manifest
   preparation is acceptable here if explicit; product capture belongs to 04.
2. Inspect generated Lean and inventory the actually reached operations and law
   purity. Reuse existing binary split/match, byte representation, recursion,
   failure, and termination support. Do not schedule a general bitstring extension.
3. Prove, for every binary input, that the executable equality expectation
   returns true: exactly `{:ok, split_slash(input)}` on success and exactly
   `{:error, :invalid_path}` on rejection. It must evaluate target and accepted
   reference normally, not merely equate two potentially exhausted computations.
   Add intermediate lemmas and a checked connection to any mathematical spec.
   Explain the normal-return/totality implication, not a practical runtime bound.
4. Prove the separate nonbinary wrapper law over its accepted domain. Use ordinary
   public Lynx/Erlang imports; expose needed proof interfaces deliberately rather
   than importing implementation internals. Keep auxiliary proof helpers private
   unless a reusable public API is justified.
5. Reproduce `..` on the original BEAM fixture, and show the intended universal
   law does not verify for it. Exercise reject-all, wrong-component output, missing
   required law, and strengthened-precondition controls. A failed proof alone is
   not a counterexample; concrete replay supplies the violation evidence.
6. Export to a new empty location with caching disabled, retain the statement and
   transitive assumption audit, and independently check the full declaration
   closure. Replay the fixed proof in a clean consumer using the retained inputs.
   These are direct feasibility artifacts, not Pudding product receipts.
7. Record wall/kernel/checker time, human proof/contract/setup effort, manual
   preparation, backend gaps, and failed attempts against the cumulative budget.
   Write a go/no-go decision. A gap needs a minimal reproducer and reviewed,
   bounded upstream fix or explicit blocker; never weaken the law to get green.

## Deliverables

Direct fixture proof sources and checked lemmas, exact artifact/export bundle,
independent replay recipe/logs, negative controls, and first feasibility decision.

## Validation and handoff gate

- [x] The actual fixed binary interface satisfies the accepted full-domain law;
  exact acceptance/output and rejection are proved, with totality accounted for.
- [x] The accepted nonbinary wrapper obligation independently checks, including
  its stated bitstring coverage. No domain is silently reduced.
- [x] The original `..` violation replays on identified BEAM bytes; reject-all and
  changed output cannot satisfy the original policy; missing/weakened laws do
  not count as completion.
- [x] Fresh exports, statement identities, assumptions, and independent-check logs
  replay from a clean environment without editing generated program bodies.
- [x] Explicit feasibility decision and cumulative effort/budget are recorded;
  blockers stop downstream phases; `mix precommit` passes.

Write `HANDOFF.md` using the [template](../HANDOFF_TEMPLATE.md), with exact
identities, commands/logs, measured effort, and any unresolved gate items.
A failed or incomplete gate blocks dependent phases; never relabel reduced scope
as the original pass.

## Boundary

No general adapter, autonomous proof worker, Pudding evidence authority, or
claim of verified translation/deployed extraction. A finite binary corpus or a
nonbinary helper theorem does not pass this gate.
