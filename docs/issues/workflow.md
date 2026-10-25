# Issue workflow status

Applies equally to Epic, Task, and Defect. Source of truth for status labels and transitions. Skills must follow this — do not invent parallel statuses. Background dispatch: [workflow-dispatch.md](workflow-dispatch.md).

## Labels

Exactly **one** `status:*` label per typed issue. Skills swap via `enforce-task-workflow-status`.

| Label | Meaning |
|-------|---------|
| `status:pending-review` | Awaiting review (default on create) |
| `status:pending-refinement` | Reviewed; refinements needed |
| `status:pending-clarification` | Needs product-owner clarification |
| `status:pending-implementation` | Passed review; ready or in progress |
| `status:pending-verification` | Implemented; awaiting verification |
| `status:pending-acceptance` | Verified; awaiting acceptance testing |
| `status:accepted` | Accepted; acceptance skills **leave open**. [`project-planner-agent`](../../.agents/skills/project-planner-agent/SKILL.md) may **close** accepted issues (leaves first, then parents when children are closed/catered for). |

Catalog: [`docs/labels.md`](../labels.md).

## Priority

Exactly one `priority:*` label (`critical` / `high` / `normal`). Create applies `priority:normal`. Unlabeled is treated as normal. Selection order when discovering work: [workflow-dispatch.md](workflow-dispatch.md). Humans only set or change priority; agents may only drop lower duplicates (hygiene).

## Transitions and evidence

Evidence is freeform prose; intent must be clear. Post evidence as an issue comment (except refinement, which also edits the body). Then call `enforce-task-workflow-status` to apply the next label.

| From | Action / evidence | To |
|------|-------------------|-----|
| pending-review | Pass review (latest comment); body consistent; deliverables/AC align with parent or project vision; note new requirements | pending-implementation |
| pending-review | Fail review: problems + refinement direction. Cascade another issue only when [workflow-cascade.md](workflow-cascade.md) authorizes it | pending-refinement (self; others only when cascade is authorized) |
| pending-review | Gaps that cannot be inferred from project scope: clarification questions | pending-clarification |
| pending-refinement | Refined issue body + summary comment | pending-review |
| pending-clarification | PO clarification comment | pending-review, or pending-refinement if refine still needed |
| pending-implementation | Comment summarizing deliverables (PRs/commits) | pending-verification |
| pending-verification | Independent pass: checked each deliverable; standards followed; adequate tests | pending-acceptance |
| pending-verification | Fail: detail issues | pending-implementation |
| pending-acceptance | Accept: repo-locatable test evidence per AC; related PRs | accepted (acceptance leaves open; planner may close later) |
| pending-acceptance | Fail (game/interface): link created defect | pending-implementation |
| pending-acceptance | Spec/ambiguity blocks testing (no defect) | pending-clarification |
| pending-acceptance | Cannot test without PO input | pending-clarification |

Reviews are holistic against the whole issue and its parent/sibling relationships, including after prior refinements.

Fail-review cascades: [workflow-cascade.md](workflow-cascade.md).

## Skills

| Skill | Role |
|-------|------|
| `enforce-task-workflow-status` | Gate transitions; audit/repair status labels |
| `review-project-issue` | Review pass / fail / clarify |
| `refine-project-issue` | Body refine → pending-review |
| `clarify-project-issue` | Record PO clarification |
| `implement-project-issue` | Implementation summary → pending-verification |
| `verify-project-issue` | Independent verify pass / fail |
| `accept-project-issue` | Accept / fail / clarify |

Create skills always apply `status:pending-review`, `priority:normal`, and the type label. Dispatch agents: [workflow-dispatch.md](workflow-dispatch.md).
