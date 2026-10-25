---
name: create-project-task
description: |-
  Create a GitHub Task issue (type:task) from docs/issues/; attach parent via
  sub-issue and wire native blocked-by dependencies.
  Use when the user asks for a concrete unit of agent work or a child of an epic/task.
  Use proactively when breaking an epic into implementable work items.

  Examples:
  - user: "Add a task under epic #3 for the movement controller" → create, sub-issue under #3
  - user: "Task for HUD, blocked by #10, parent #3" → create + parent + blocked-by
  - user: "Draft task only, don't file it" → --no-create
---

# Create project task

Create a repository **Task** (`type:task`).

**Issue contract:** [`docs/issues/`](../../../docs/issues/) (`requirements.md`, `body-shapes.md`, `hierarchy.md`). Do not redefine sections or invent a parallel template in this skill.

**Linking (sub-issues / depth check / blocked-by commands):** [`references/github-issue-linking.md`](references/github-issue-linking.md).

## Steps

1. **Read** Task requirements + body shape docs and the linking reference.
2. **Collect** `title` and content for every required Task section; optional `parent`, `blocked_by`, `blocking`. Ask if required content is missing.
3. If `parent` is set: **validate depth** per `hierarchy.md` and the linking reference; abort if the new task would exceed 3 levels from epic to leaf.
4. **Build** the body exactly as specified in `body-shapes.md`.
5. If `--no-create` / "draft only": print title + body and stop.
6. **Create**: `gh issue create --title "…" --label "type:task" --label "status:pending-review" --label "priority:normal" --body "…"` (use `priority:high` or `priority:critical` only when the human explicitly requests that priority at create time), with parent at create time when supported; otherwise attach sub-issue after create (linking reference).
7. **Blocked-by**: for each blocker, follow the linking reference.
8. **Report** URL, labels (`type:task`, `status:pending-review`, `priority:*`), parent, and dependency wiring.

## Rules

- Apply labels `type:task`, `status:pending-review`, and exactly one `priority:*` (default `priority:normal`).
- Do not change priority after create; only humans set or change priority later.
- Default: create on GitHub.
- Do not invent a parent; only attach when the user names one.
- Draft ACs per [`requirements.md`](../../../docs/issues/requirements.md). If the task touches [`specs/playtest/story-rows.md`](../../../specs/playtest/story-rows.md), require epic/task owners or durable `none` reasons — never “every `none` names a live `type:defect`.”

## Related

- Form: `.github/ISSUE_TEMPLATE/task.yml`
- Contract: `docs/issues/`
- Workflow: `docs/issues/workflow.md`
- Parent skill: `create-project-epic`
