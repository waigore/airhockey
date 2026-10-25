# Proofs of concept (PoCs)

A **PoC** is a freer exploration of a technical or functional claim. It lives under `pocs/<slug>/`, apart from the main tree. It is **not** bound by `specs/` (it may draw on design, ADRs, or notes already decided). Main code never imports from `pocs/`.

Product **demo mode** is different: [`demo.md`](demo.md).

## Request → track → build

1. **Request**: during [`capture-requirements`](../.agents/skills/capture-requirements/SKILL.md) (or later ADR/technical work), the agent proposes or the user asks for a PoC when achievability is unclear.
2. **Log**: write purpose, scope, and desired outcome in [`requirements/poc-requests.md`](requirements/poc-requests.md).
3. **File**: create a task (or epic) whose body carries those fields; dependents may use native **blocked-by** that issue only.
4. **Scope / build**: [`scope-poc`](../.agents/skills/scope-poc/SKILL.md), then [`create-poc`](../.agents/skills/create-poc/SKILL.md) when `status:pending-implementation`.

There is **no** global “PoC before main code” gate. Promotion is optional ([`poc-promotion.md`](poc-promotion.md)).

## Types

| Type | Explores |
|------|----------|
| Engine | Rules, state, feel, camera; no UI screens. Debug overlay allowed. |
| Gameplay | Playable slice with screens and input |

Default to engine unless the question is UI/flow or the user asks otherwise.

## Before building

[`scope-poc`](../.agents/skills/scope-poc/SKILL.md) applies this. Always: [`ensure-project-setup`](../.agents/skills/ensure-project-setup/SKILL.md) passed; high-level stage locked; Engine ADR Accepted when the PoC needs the project engine; task `pending-implementation`; purpose/scope/outcome confirmed (from the issue and log).

Style and assets only when the PoC chooses to show them ([`poc-style-assets.md`](poc-style-assets.md)).

## What is relaxed

- [SOLID](solid.md), [coding conventions](coding-conventions.md), and structure continuity do not apply. `review-code` skips `pocs/`.
- Unit tests optional. Spec-first does **not** apply.
- Playtesting per `specs/playtest/` optional, on request.

## Traceability (lightweight)

The PoC README records the exploration question, purpose/scope/outcome, optional design/ADR citations used, what was tried, and promotion status. Assumptions do not authorize main code.

## Verification

`verify-project-issue` checks the PoC against the task’s purpose/outcome and README run instructions. Style/assets per [`poc-style-assets.md`](poc-style-assets.md#verification). No code review.
