---
name: verify-project-issue
description: |-
  Independently verify an epic/task/defect in status:pending-verification against
  its deliverables; post pass or fail and advance or return status. When linked
  PRs contain code changes, run review-code and treat a Fail as verify Fail.
  Use when checking implemented work (smoke test) before acceptance.

  Examples:
    - user: "Verify #12" → independent checks, pass/fail comment, gate status
    - user: "Verification failed on #12: missing tests" → fail → pending-implementation
---

# Verify project issue

Independent verification (smoke test) for a typed issue in `status:pending-verification`.

**Contract:** [`docs/issues/workflow.md`](../../../docs/issues/workflow.md)

**Status gate:** [`enforce-task-workflow-status`](../enforce-task-workflow-status/SKILL.md)

**Delegates when applicable:** [`review-code`](../review-code/SKILL.md) · [`review-asset`](../review-asset/SKILL.md) · [Verification in `docs/pocs.md`](../../../docs/pocs.md#verification) · [`docs/poc-style-assets.md`](../../../docs/poc-style-assets.md#verification)

**Type routing:** [`docs/issues/requirements.md`](../../../docs/issues/requirements.md) (When to file what).

## Steps

1. **Load** issue `n`, implementation comment, and linked PRs/commits/paths.
2. **Assert** `status:pending-verification`.
3. **Check** (smoke-level, independent of the implementor’s claim):
   - Deliverables align with what the issue demands
   - Coding/architecture/spec/doc standards closely followed where applicable
   - No major gaps/ambiguities/underspecifications requiring revision
   - If coding: unit test coverage adequate; tests sensibly cover program logic
   - **If any linked PR contains code changes:** run [`review-code`](../review-code/SKILL.md) on those PR diffs. Include its report. A Fail from that skill fails verification.
   - **If any linked PR adds or changes cataloged assets:** run [`review-asset`](../review-asset/SKILL.md) on those catalog entries. Include its report. A Fail from that skill fails verification.
   - **If the deliverable is a PoC** (`pocs/<slug>/`): check per [Verification in `docs/pocs.md`](../../../docs/pocs.md#verification) and [`docs/poc-style-assets.md`](../../../docs/poc-style-assets.md#verification) instead of code review and unit-test coverage. A Fail there fails verification.
   - **If the deliverable is product demo mode** (main tree): verify against [`specs/design/demo.md`](../../../specs/design/demo.md) and normal code review/tests ([`docs/demo.md`](../../../docs/demo.md)).
4. **Hygiene / non-material gaps** (stale issue IDs in maps / [`story-rows.md`](../../../specs/playtest/story-rows.md), soft AC wording, paperwork with no effect on implementation or functional outcome): **attempt to repair** in the deliverable or a focused follow-up commit/PR on this work. Do **not** Fail solely for that, and **never** file a defect. A story-row `none` with a durable reason (no live defect link) is valid. If repair cannot land here and the gap is **material** with no open owner, create a **task** via `create-project-task`, note it, and still Pass when game/implementation checks hold.
5. **Outcome:**
   - **Pass** — comment summarizing what was checked against each deliverable (include delegated review Pass when run; note any hygiene repair or material follow-up task). Gate: `pending-verification` → `pending-acceptance`.
   - **Fail** — detail **material** implementation/behavior/standards gaps (include delegated review findings when that review failed). Gate: `pending-verification` → `pending-implementation`. No defect for spec/doc/map problems — repair, clarify on this issue, or a task per routing.
6. **Report** URL, outcome, new status.

## Rules

- Check the deliverables themselves. Do not treat the implementation comment as the verdict.
- Freeform evidence; intent must be clear.
- Call `enforce-task-workflow-status` for the label change.
- Do not skip `review-code` when linked PRs include implementation files.
- Do not raise or Fail on non-material paperwork. Defects are in-game/interface only.
