# Research brief coverage

The implementation plan supersedes the October 23, 2026 research brief, whose
original file has been removed. This map preserves its section headings and
identifies where its requirements become implementation work. Its numbered
sources and inspected revisions are retained in [REFERENCES.md](REFERENCES.md).
External sources were not re-researched for this transformation; agents must
consult the pinned sources relevant to their implementation rather than treating
the brief's source review as a successful build or compatibility test.

## Sections and milestones

| Brief section | Implementation destination | Required preservation |
| --- | --- | --- |
| Initial decisions; 1 — Objective | Index, architecture; phases 07, 11, 14, 16 | Implementation-bound, independently checked claims; measured research gates |
| 2 — Assembly motivation | Architecture; deferred native/compiler work | Core claims exclude compiler/runtime/native correctness; published results are not Pudding results |
| 3 — Intended product | 02, 03, 12, 17, 18 | Ordinary Mix consumer, discovery, accepted contracts, precise reports and dependency-bound reuse |
| 4 — Evidence distinctions | Architecture; 02, 05–07, 11–16 | Testing, bounded checking, proof, totality, and acceptance remain distinct |
| 5 — Backend selection | 01, 03–07; deferred translation validation | HARP/Rocq conditional recommendation; reconstructed Core trust |
| 5.1 — Actual upstream support | 01, 04, 08–10 | No binary syntax upstream; maps present; unsupported BIFs cannot inherit `undef` |
| 5.2 — Extraction route | 03, 04, 17 | Backend allowlist, BEAM/debug/Core/toolchain binding; reconstruction disclosure |
| 5.3 — Prior work | 01, 05, 12, 15; DEFERRED.md | Reuse methods selectively; no automatic dependency selection or modern-OTP compatibility claim |
| 6 — Architecture/checking boundary | 02–07, 12–14, 17–18 | Trusted expected theorem, immutable inputs, assumption audit, independent dependency rechecking |
| 7 — Initial subset | 04, 05, 08–11 | Closed call closure, exact errors/guards, binary representation relation, idealized resources |
| 8 — First experiment | 02, 07–14 | Nonbinary gate first, exact byte policy, vulnerable/fixed pair, wrapper and totality obligations |
| 9 — Milestones | All phases; explicit decisions at 07 and 11 | Ten-engineer-day first gate; independent binary budget; no orchestration in place of proof |
| 10 — Autonomous execution/reuse | 02, 03, 06, 12–14, 17–18 | Four evidence outcomes, visible assumptions, complete graph, worker authority limits |
| 11 — Evaluation | 05–07, 12–16 | Negative controls, three comparable-budget arms, full denominator, held-out packages, intervention/cost |
| 12 — Later expansion | DEFERRED.md | Demand-driven follow-on work, separate assurance claims |
| 13 — Nine research answers | Table below | Confidence and proposed measurements remain hypotheses until measured |
| 14 — Next action | 01–07, then 08–14, then 15–18 | Import/check before binary extension; evaluate before general incremental orchestration |
| References 1–34 | REFERENCES.md; phase-specific reading lists | Retain numbered sources, pinned identities, research context, and licenses |

## Nine research questions

| Question | Phases and decisive evidence |
| --- | --- |
| 13.1 Representation choice | 01, 03–07: emitted-code inventory, useful imported theorem, measured blockers before reconsidering the layer |
| 13.2 Modern-output compatibility | 04–05, 08–10: 10–20-function inventory, guard/error cases, binary operation matrix, differential results |
| 13.3 Trusted boundary | 01, 04–07: trust manifest, binding/literal/branch mutation controls, exact checker; later checked-translation pilot in DEFERRED.md |
| 13.4 Contract acceptance effort | 02, 15–16: explicit acceptance records, misleading-policy/reject-all traps, oracle/predicate connection, timed unfamiliar-target review |
| 13.5 Automation portfolio | 07, 11, 13: ordinary checked tactics first; solver output never authority; optional certificate integration deferred until justified |
| 13.6 Per-package effort | 15–16: frozen package-held-out split, cold/warm effort, failed targets, adaptation categories and costs |
| 13.7 Reliable incrementality | 03, 17–18: captured build identities, mutation matrix, module dependency invalidation and fail-closed required claims |
| 13.8 Value versus fuzzing | 12–16: same contracts/examples, three arms, actual budgets/cost, bugs and additional assurance separately |
| 13.9 Honest unsupported/mismatch reporting | 02, 04–06, 10, 12, 17–18: explicit failure taxonomy, paired replay, quarantine, denominators and current evidence checks |

## Deliberate sequencing choices

The brief has seven broad research milestones. They are split here so that
syntax import, empirical conformance, logical checking, and a useful theorem
each have an observable handoff. Binary values/construction, binary matching,
and binary import are also separate assignments because they affect the trusted
semantics in different ways.

Phase 11 proves a fixed reference validator before phase 14 measures automated
repair. This prepares reusable lemmas without pretending the later patch was
autonomously derived. Retain and report all manual preparation. Phase 12 adds
the first Mix command, while phase 03 already uses an ordinary-project adapter.
Phase 17 adds reuse only after evaluation; earlier bundles always require an
exact identity match and a fresh capture when inputs change.

The shared architecture makes the repository's `assumed` reporting requirement
visible alongside the brief's primary evidence outcomes. No assumption is
silently promoted to an implementation proof.
