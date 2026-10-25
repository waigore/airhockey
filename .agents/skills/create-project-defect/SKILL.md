---
name: create-project-defect
description: |-
  Create a GitHub Defect issue (type:defect) from docs/issues/; wire related
  links and native blocked-by when provided.
  Use when the user reports wrong game or interface behavior vs expected play.
  Do not use for specs, docs, story maps, AC hygiene, or planning gaps (those
  are tasks or clarification — see docs/issues/requirements.md).

  Examples:
  - user: "File a defect: jump input ignored on web" → collect per docs/issues/, create
  - user: "Defect related to #15, blocked by #9" → related section + blocked-by
  - user: "Draft defect body only" → --no-create
---

# Create project defect

Create a repository **Defect** (`type:defect`) for an **in-game or interface** bug only.

**Issue contract:** [`docs/issues/`](../../../docs/issues/) (`requirements.md`, `body-shapes.md`, `hierarchy.md`). Do not redefine sections or invent a parallel template in this skill.

**Linking (sub-issues / blocked-by commands):** [`../create-project-task/references/github-issue-linking.md`](../create-project-task/references/github-issue-linking.md).

## Steps

1. **Read** Defect requirements + body shape docs. Abort and redirect if the report is a spec/design/doc/planning problem: use clarification on an owning open issue, or `create-project-task` when material and uncovered — never a defect.
2. **Collect** `title` and content for every required Defect section; optional reproduction, context, `related`, `parent`, `blocked_by`, `blocking`. Ask if required content is missing.
3. **Build** the body exactly as specified in `body-shapes.md`.
4. If `--no-create` / "draft only": print title + body and stop.
5. **Create**: `gh issue create --title "…" --label "type:defect" --label "status:pending-review" --label "priority:normal" --body "…"` (use `priority:high` or `priority:critical` only when the human explicitly requests that priority at create time).
6. If `parent` is set: attach as sub-issue (linking reference); enforce depth rules from `hierarchy.md` when nesting under a task chain.
7. **Blocked-by**: for each true blocker, follow the linking reference. Related-only issues stay in `## Related tasks or defects` per the docs.
8. **Report** URL, labels (`type:defect`, `status:pending-review`, `priority:*`), parent (if any), related links, and dependency wiring.

## Rules

- Apply labels `type:defect`, `status:pending-review`, and exactly one `priority:*` (default `priority:normal`).
- Do not change priority after create; only humans set or change priority later.
- Default: create on GitHub.
- Never file a defect for specs, docs, maps, or non-material hygiene ([`requirements.md`](../../../docs/issues/requirements.md) — When to file what).

## Related

- Form: `.github/ISSUE_TEMPLATE/defect.yml`
- Contract: `docs/issues/`
- Workflow: `docs/issues/workflow.md`
