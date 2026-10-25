---
name: clarify-project-issue
description: |-
  Record product-owner clarification on an epic/task/defect in
  status:pending-clarification, then move to pending-review or pending-refinement.
  Use when the PO answers open questions or the user provides clarification to post.

  Examples:
    - user: "PO clarified #5: jump height is 2 tiles" → comment + gate to pending-review
    - user: "Clarification on #5 still needs a body rewrite" → comment + pending-refinement
---

# Clarify project issue

Record product-owner clarification for a typed issue in `status:pending-clarification`.

**Contract:** [`docs/issues/workflow.md`](../../../docs/issues/workflow.md)

**Status gate:** [`enforce-task-workflow-status`](../enforce-task-workflow-status/SKILL.md)

## Steps

1. **Load** issue `n` and outstanding clarification questions.
2. **Assert** `status:pending-clarification`.
3. **Collect** the PO clarification (ask if missing). Do not invent answers.
4. **Comment** with the clarification (attribute the PO when known).
5. **Choose next status:**
   - Body still needs edits → gate `pending-clarification` → `pending-refinement` (then use `refine-project-issue` if refining now).
   - Otherwise → gate `pending-clarification` → `pending-review`.
6. **Report** URL and new status.

## Rules

- Clarification evidence is a comment from/with the PO answer.
- Do not skip review after clarification unless the user explicitly continues into refine/review skills.
- Call `enforce-task-workflow-status` for the label change.
