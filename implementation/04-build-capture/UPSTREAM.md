# Upstream request — supported translation-only API

**Status:** posted with owner approval as
[josevalim/lynx#20](https://github.com/josevalim/lynx/issues/20).
The published title/body were verified against the text below. This replaces the
earlier, broader request. No PR was opened or Lynx code/dependency changed.

## Published issue

### Supported API for translating selected functions without verifying laws

I'm building Pudding, a security-verification tool that captures compiled Elixir
projects and uses Lynx for proofs. We'd like to translate selected functions and
inspect the generated definitions and imports before writing their laws or
running Lean.

Would you be open to a supported entry point for this? The operation already
exists in `Lynx.Translation`, but that module has `@moduledoc false`.

At `99a6db764c154207cf3b28c35409d9b56c463357`:

- `Lynx.Translation.add/2` accepts BEAM binaries or `{file, core}` inputs.
- `translate/3` translates selected functions and their local/remote callees.
- `assemble/2` returns the translation data consumed by the Lean runner.
- The test "verify raises when a module declares no laws" demonstrates that
  `translate/3` followed by `assemble/2` works on the same law-free module.
- `Lynx.Laws.verify/2` requires laws and invokes Lean. Its rejection of a law-free
  module is expected; this is not a bug report.

The proposed entry point would accept compiled inputs and MFA roots, reuse the
existing translation/assembly path and options such as `cutoffs` and `dynamic`,
and return the assembled translation without invoking Lean. Existing translation
errors could continue to raise. I don't need the private translation struct to
become public, or new analysis of dynamic calls.

Build capture, input validation, code-path isolation, hashing and evidence
storage would stay in Pudding. No custom artifact resolver or provenance-report
schema is part of this request.

I can open a draft PR with a wrapper around the existing implementation,
documentation, and tests for a law-free root, reachable local/remote functions,
and existing translation failures. Would you prefer that approach, documenting
a subset of the current API, or keeping translation internal?

## Local assessment — not part of the issue text

### What belongs upstream

A documented translation-only entry point is a Lynx API decision. The traversal,
runtime-model selection and assembly already live there. A wrapper and its tests
would reuse that implementation; no new translator is needed. Whether this API
is useful enough to maintain is for the maintainer to decide.

The absence of a public wrapper does **not** prevent ordinary verification through
`Lynx.Laws.verify/2`. Calling the existing internal functions is technically
possible. Avoiding that dependency is Pudding's integration policy, not a Lynx
correctness requirement. Real law modules referring to consumer functions are
also a valid downstream use of the existing public API; generated wrappers are
not inherently unsound. They do not provide the requested law-free entry point.

### What stays downstream

- Capturing builds, restricting the worker environment/code path, and inventorying
  permitted BEAM inputs. A dedicated VM can control the files available to Lynx's
  current code-path lookup. A mandatory closed resolver has not been justified as
  necessary for the initial upstream request.
- Rejecting duplicate inputs, validating debug backends, and binding source,
  BEAM, Core and tool versions to Pudding's manifests.
- Hashes, reproducibility checks, evidence schemas, caching policy and receipts.
- Pudding-specific support summaries and its phase gates. If assembled outputs
  prove insufficient for a required observation, identify that specific missing
  observation separately rather than requesting a complete reporting framework.

The earlier draft bundled these concerns into a closed resolver, a versioned
provenance/support report and a complete dependency inventory. That was too broad.
The narrowed API alone does not discharge Pudding's closure or mutation gates;
Phase 04 remains blocked and Phase 05 may not begin.

### Source checks

All links are pinned to the revision inspected:

- [Translation entry points](https://github.com/josevalim/lynx/blob/99a6db764c154207cf3b28c35409d9b56c463357/lib/lynx/translation.ex#L64-L184).
- [Model selection and module lookup](https://github.com/josevalim/lynx/blob/99a6db764c154207cf3b28c35409d9b56c463357/lib/lynx/translation.ex#L202-L349).
- [Assembly](https://github.com/josevalim/lynx/blob/99a6db764c154207cf3b28c35409d9b56c463357/lib/lynx/translation.ex#L413-L595).
- [Public verification path](https://github.com/josevalim/lynx/blob/99a6db764c154207cf3b28c35409d9b56c463357/lib/lynx/laws.ex#L84-L169).
- [Law-free translation test](https://github.com/josevalim/lynx/blob/99a6db764c154207cf3b28c35409d9b56c463357/test/lynx/translation_test.exs#L479-L499).

On 2026-11-17 UTC, upstream main still matched this pin. The installed checkout
was clean. All 13 open/closed issue titles were rechecked; no equivalent request
was found. [#18](https://github.com/josevalim/lynx/issues/18) concerns in-memory
modules and was resolved by its author using `Translation.add/2`; it is not
evidence that a new loader is required.

The [public boundary example](../../proof/capture/public_inspection_repro.exs)
was rerun with Elixir 1.20.2, OTP 29.0.2 / ERTS 17.0.2. It produced
`EXPECTED PUBLIC API BOUNDARY: nofile: module PlainInspectionTarget declares no laws`.
This confirms `verify/2`'s documented contract, not the need for a translator fix.
No Lean process is needed for that rejection. The pinned Lean toolchain is 4.35.0.

Only the issue text above was published, with the owner's explicit approval.
The local assessment was not published. No draft PR has been opened; the offer
above is not a claim of maintainer approval or authority to implement upstream.
