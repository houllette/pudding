# Phase 05 — Integrate Lynx reports, support, and conformance

**State:** Blocked — not started. Phase 04's supported-API closure gate has not
passed; see [its handoff](../04-build-capture/HANDOFF.md). Successful fixture-only
retained-BEAM replay does not permit starting this phase.

**Depends on:** Passed phases 01–04 and current prerequisite handoffs.

**Next:** [06 — Authorize exact-contract evidence independently](../06-evidence-checker/README.md).

Read the [shared architecture](../ARCHITECTURE.md), [plan](../README.md), and
[backend/reference sources](../REFERENCES.md) with the prerequisite handoffs.

## Assignment

Provide a thin revision-pinned backend adapter from trusted captures and accepted
contracts to Lynx verification attempts. Detect support gaps and execution
mismatches without recreating Lynx's runtime or treating report success as a receipt.

## Work

1. Construct trusted law modules from the accepted predicates and fixed domain;
   insert proof bodies only in designated positions. Invoke `Lynx.Laws.verify/2`
   with controlled law roots and captured callee/dependency code paths. Record
   exact options, generated source, actual required theorem inventory, and reports.
2. Require every report to succeed and every required claim to be present. Exercise
   empty input/reports, dependency-only success, skipped dependencies, missing or
   renamed laws, duplicate identities, raises, and malformed runner responses.
   Preserve diagnostics and source maps; no parse/error fallback becomes proved.
3. Inventory reachable target/spec operations, modeled OTP functions, argument
   restrictions, errors, purity, recursion/cutoffs, and unsupported domains. Use
   Lynx translation/runtime diagnostics and bounded probes, not a parallel semantic
   allowlist implementation. Fail unresolved closure/dynamic-dispatch ambiguities.
4. Compare captured BEAM outcomes with the same translated implementation on
   deterministic boundary/generated inputs. Prefer generated concrete Lynx laws
   against safe encodings of observed results. Cover binary policy cases, wrappers,
   guard/failure branches, and supported exception class/reason; explain omitted
   stacktraces. No public general evaluator API is assumed.
5. Retain seeds, shrink disagreements, and quarantine affected evidence. Keep
   translation gaps, unresolved mismatches, nonreturning model runs, runtime
   timeout, normal errors, and target exceptions distinguishable. Finite agreement
   does not establish universal translation/runtime correspondence.
6. Inject wrong literal/byte, binding, omitted-error branch, changed captured
   dependency, and law-precondition mutations in controlled test copies. Identify
   what detects each and finite-test blind spots. Never edit production generated
   programs as a route to verification.

## Deliverables

Lynx adapter, required-obligation binding manifest, scoped support inventory,
conformance/mutation corpus, mismatch bundles, and backend interface documentation.

## Validation and handoff gate

- [ ] Fixed full-domain/wrapper obligations and original violation from phase 03
  are reproduced through the adapter using only captured inputs.
- [ ] All required obligations, including names, predicates, and domains, are
  accounted for independently of report count; no vacuous success control passes.
- [ ] Scoped support inventory covers the actual closure; known gaps are unsupported,
  incomplete attempts unknown, and failed proofs are not reported as violations.
- [ ] Selected normal/exception conformance cases agree; injected faults are caught
  at recorded checks and unresolved mismatches quarantine assurance.
- [ ] Adapter uses public APIs where possible and tests any narrow revision-specific
  inspection dependency; `mix precommit` and non-test consumer checks pass.

Write `HANDOFF.md` using the [template](../HANDOFF_TEMPLATE.md), with exact
identities, commands/logs, measured effort, and any unresolved gate items.
A failed or incomplete gate blocks dependent phases; never relabel reduced scope
as the original pass.

## Boundary

No Pudding `proved` receipt until phase 06, no inferred contract acceptance,
no cloned Core semantics, and no claim that differential testing verifies the
translator. Runtime support breadth is not initial product scope.
