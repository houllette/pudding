# Follow-on research

These are ordered follow-on directions after the initial prototype's gates,
not assignments that a current phase must silently absorb. Use phase 16's
measurements and actual target demand to select one bounded new phase. Each
needs an accepted contract, support matrix, trust update, negative controls,
independent replay, and its own budget before implementation.

| Direction | Entry evidence | First bounded experiment and handoff |
| --- | --- | --- |
| Checked import/translation | Stable importer plus measured trust/normalization costs | Check one normalization or translation certificate against captured Core; show that a wrong literal/binding/branch is rejected and state exactly which importer trust was removed |
| More sequential library contracts | Repeated unsupported operations in evaluation | Audit maps already present upstream or one frequently used BIF/exception family; bind summaries to implementation identities and rerun old proofs |
| Richer binaries and Unicode | A selected target needing more than the byte subset | Specify exact segment sizes, units, signs, endian/UTF/error behavior; prove representation/semantic lemmas and differential cases before broadening support |
| Reusable parser/decoder claims | Successful byte-domain reuse on held-out functions | Prove consumed-input/output, rejection, round-trip, or canonicality for one existing implementation; EverParse is a methodological precedent, not a drop-in verifier |
| Checked SMT certificates | Repeated expensive goals inadequately served by ordinary tactics | Test a pinned SMTCoq/toolchain/theory combination and encoding; retain certificates and reject unsupported theories, bare `unsat`, and abducted premises |
| Stateful OTP and concurrency | Explicit process/mailbox/state/scheduler contract | One supported actor property with stated fairness/exploration bounds; separately assess Concuerror or Soter suitability and modern-OTP compatibility |
| Framework authorization | Explicit identity, ownership, state, and effect model | One route/plug/policy composition, including bypass paths; a pure helper theorem is insufficient |
| Native/NIF/compiler/JIT assurance | A selected lower-layer target and model | Choose one translation-validation step or native entry point; account for runtime helpers, platform/memory/environment assumptions and termination separately |
| Resource guarantees | Checked totality and a defined abstract cost model | Bound steps, allocation, or output for one target, then separately justify any relationship to production limits |
| Static-analyzer discovery | A demonstrated discovery bottleneck | Add one optional Sobelow-style candidate source, preserving the distinction between finding, accepted contract, and proof |
| Historical ZIP benchmark | Audited operation coverage and recoverable original policy | Reproduce the actual advisory's vulnerable/fixed behavior; do not relabel the synthetic `..` fixture or a validator theorem as extractor safety |
| Distributed workers and finer reuse | Measured single-worker/CI bottleneck and stable identities | Introduce one bounded worker pool or checked function-level linking design; add an Application deliberately if long-lived processes require supervision |

Do not substitute these directions for a failed initial gate without a written
decision identifying the blocker, changed assurance claim, and alternative cost.
The research brief's assembly motivation and broader application-security goal
remain long-term work, with independent evidence requirements.
