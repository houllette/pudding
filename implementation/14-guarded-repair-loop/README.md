# Phase 14 — Complete the guarded discovery and repair demonstration

**State:** Not started.

**Depends on:** Passed phases 01–13, unchanged accepted path policy, and any
required model-run authorization.

**Next:** [15 — Evaluation preparation](../15-evaluation-preparation/README.md).

**Brief:** Sections 6, 8–11, 13.4–13.6, and 14.

## Assignment

Run the complete ordinary-Mix-project workflow: discover/reproduce the vulnerable
validator, minimize a violation, generate a regression, propose a source patch,
rebuild/import it, and independently check safety, exact acceptance, and totality.
This is the first end-to-end repair evidence, distinct from the prepared reference.

## Work

1. Begin from the retained vulnerable fixture and frozen accepted policy. Use
   phase 12 discovery/search to retain the real `..` violation and regression
   before editing. Bind every artifact to the original build.
2. Implement a patch job with writes limited to allowed target source/regression
   paths in an isolated workspace. Preserve original tests and valid-input
   requirements. Deny access to accepted policies, model/importer output,
   semantics, checker scripts/configuration, and trusted libraries.
3. Add `--propose-patches` to the minimal Mix workflow. Generate reviewable diffs,
   not automatic publication or dependency-wide rewrites. Record attempts,
   author/model, manual interventions, limits, and all preparation from phase 11.
4. Compile/capture/import each candidate anew. Run regression/valid-behavior
   tests and paired execution, then phase 13 proof search and phase 06 independent
   checking against the unchanged original accepted contract. Reusable lemmas
   are allowed with provenance; copied reference patches must be disclosed.
5. Refuse reject-all, unrelated-safe-path substitution, nontermination, hidden
   stronger preconditions, and edits to policy/semantics/checker boundaries.
   Retain failures and refuse stale original receipts on new code.
6. Build a complete demonstration bundle preserving vulnerable/fixed source and
   artifacts, concrete violation, minimized input, regression, patch, theorem
   statements/proofs, assumptions, budgets, checking logs, and replay instructions.
   Have a clean runner replay it without the original agent/model session.

## Deliverables

Bounded patch-worker path, Mix demonstration command, hostile patch controls,
reviewable source diff, independent end-to-end bundle, and
`docs/verification/repair-demo.md` with actual intervention and cost.

## Validation and handoff gate

- [ ] The actual original defect independently replays; the synthetic example is
  not relabeled as the historical OTP ZIP advisory.
- [ ] Regression fails for the vulnerable implementation and passes for the
  newly captured patch, alongside original tests and valid-input acceptance.
- [ ] The patched imported program receives exact checked safety, acceptance,
  rejection, and totality receipts under the unchanged accepted policy.
- [ ] Hostile reject-all/substitution/nontermination/weakened-policy edits are
  refused or fail the full contract; unauthorized writes are blocked.
- [ ] A clean offline checker replays the bundle; original and patched identities
  remain distinct and all manual/model work is reported.
- [ ] `mix precommit`, ordinary non-test consumer use, and proof closure pass.

Write `HANDOFF.md` with reproduction commands, patch scope/diff, exact receipts,
intervention accounting, preserved vulnerable/fixed artifacts, and all exclusions.

## Boundary

Do not claim autonomy beyond the actual recorded run. A manually supplied repair
can validate plumbing but does not pass an autonomous-repair claim. This phase
does not authorize publishing patches to third-party projects or changing policy.
