---
name: create-project-epic
description: |-
  Create a GitHub Epic issue (type:epic) from docs/issues/, then wire native
  blocked-by dependencies when provided.
  Use when the user asks for an epic, a broad orchestration outcome, or a parent for multiple tasks.
  Use proactively when planning work that should be split into linked tasks.

  Examples:
  - user: "Create an epic for player movement" → collect per docs/issues/, create, report URL
  - user: "Draft an epic body only" → --no-create, print markdown body
  - user: "Epic for audio, blocked by #4" → create + native blocked-by
---

# Create project epic

Create a repository **Epic** (`type:epic`).

**Issue contract:** [`docs/issues/`](../../../docs/issues/) (`requirements.md`, `body-shapes.md`, `hierarchy.md`). Do not redefine sections or invent a parallel template in this skill.

**Linking (sub-issues / blocked-by commands):** [`../create-project-task/references/github-issue-linking.md`](../create-project-task/references/github-issue-linking.md).

## Steps

1. **Read** Epic requirements + body shape docs.
2. **Collect** `title` and content for every required Epic section; optional notes, `blocked_by`, `blocking`. Ask if required content is missing.
3. **Build** the body exactly as specified in `body-shapes.md`.
4. If `--no-create` / "draft only": print title + body and stop.
5. **Create**: `gh issue create --title "…" --label "type:epic" --label "status:pending-review" --label "priority:normal" --body "…"` (use `priority:high` or `priority:critical` only when the human explicitly requests that priority at create time).
6. **Blocked-by**: for each blocker, follow the linking reference.
7. **Report** URL, labels (`type:epic`, `status:pending-review`, `priority:*`), and dependency wiring.

## Rules

- Apply labels `type:epic`, `status:pending-review`, and exactly one `priority:*` (default `priority:normal`).
- Do not change priority after create; only humans set or change priority later.
- Default: create on GitHub.
- Do not create child tasks unless asked; use `create-project-task` for children.

## Related

- Form: `.github/ISSUE_TEMPLATE/epic.yml`
- Contract: `docs/issues/`
- Workflow: `docs/issues/workflow.md`
