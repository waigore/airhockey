---
name: refine-project-issue
description: |-
  Refine an epic/task/defect in status:pending-refinement by editing the issue
  body, posting a summary comment, and returning it to pending-review.
  Use when the user asks to apply review feedback or refine an issue body.

  Examples:
    - user: "Refine #12 per the fail review" → edit body, summary comment, gate status
    - user: "Apply refinements to the movement task" → same for that issue number
---

# Refine project issue

Apply refinements to a typed issue in `status:pending-refinement`.

**Contract:** [`docs/issues/workflow.md`](../../../docs/issues/workflow.md)

**Status gate:** [`enforce-task-workflow-status`](../enforce-task-workflow-status/SKILL.md)

## Steps

1. **Load** issue `n` and the latest fail/review feedback.
2. **Assert** `status:pending-refinement`.
3. **Edit the issue body** (not only a comment) so required sections stay valid per `docs/issues/`.
4. **Comment** summarizing what changed.
5. **Gate** via `enforce-task-workflow-status`: `pending-refinement` → `pending-review`.
6. **Report** URL and new status.

## Rules

- Refinements belong in the body proper.
- Keep body shapes from `docs/issues/body-shapes.md`.
- Call `enforce-task-workflow-status` for the label change.
- Strip or rewrite ACs that require story-row `none` cells to name a live `type:defect`; align with [`requirements.md`](../../../docs/issues/requirements.md) and [`story-rows.md`](../../../specs/playtest/story-rows.md).
