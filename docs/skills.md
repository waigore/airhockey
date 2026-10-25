# Project skills

Canonical skill bodies live under [`.agents/skills/`](../.agents/skills/) (one folder per skill). That tree is the only source of truth.

## Native wiring (required)

Whenever a project skill is created or renamed, add thin facades for OpenCode, Cursor, and Grok. Facades carry the same `name` / `description` frontmatter and point at the canonical body — they must not duplicate the workflow.

| Agent | Facade path |
|-------|-------------|
| Cursor | `.cursor/skills/<skill-name>/SKILL.md` |
| OpenCode | `.opencode/skill/<skill-name>/SKILL.md` |
| Grok | `.grok/skills/<skill-name>/SKILL.md` |

### Facade template

```markdown
---
name: <skill-name>
description: |-
  <same description as the canonical skill>
---

# <Title> (facade)

Canonical instructions: [`.agents/skills/<skill-name>/SKILL.md`](../../../.agents/skills/<skill-name>/SKILL.md).

Read that file and its `references/` as needed, then run the workflow there. Do not invent a parallel process.
```

### Rules

- Edit the body only under `.agents/skills/<skill-name>/`.
- Keep facade frontmatter in sync when you change the canonical `name` or `description`.
- Do not replace a facade with a full copy of the skill.
- Do not use directory-wide symlinks for Cursor/OpenCode/Grok in this repo; use per-skill facades so each agent’s native path stays explicit.

## Invoke, don't restate

Orchestrators name the delegate skill and **when** to call it. They do not copy its Steps, Pass/Fail semantics, transition tables, or procedure narrative.

- Contract detail lives in `docs/`, `specs/`, or the leaf skill. Callers link; they do not paraphrase.
- Pattern: [`ensure-project-setup`](../.agents/skills/ensure-project-setup/SKILL.md) — “Do not restate their steps here.”
- Dispatch agents (`issue-workflow-*-agent`) resolve one issue per [`docs/issues/workflow-dispatch.md`](issues/workflow-dispatch.md), then run the mapped `*-project-issue` skill. An agent-orc line `Assigned issue: N` is that `#n`; `none` means discover. Discovery, queue, and independence rules stay in that doc and the delegates.

### Cross-cutting hooks

- **`ensure-project-setup`**: any skill that opens a PR runs it unless it already passed this session; continue only on Pass.
- **`implement-project-issue`**: when the work delivers a typed issue (`type:epic` / `type:task` / `type:defect`), end by running that skill after the PR (or equivalent deliverable evidence).

## Add a skill checklist

1. Create `.agents/skills/<skill-name>/SKILL.md` (`name` must match the folder).
2. Add optional `scripts/`, `references/`, or `assets/` next to that `SKILL.md`.
3. Add Cursor, OpenCode, and Grok facades using the template above.
4. List the skill in [`.agents/skills/README.md`](../.agents/skills/README.md) (catalog). Do not maintain a full skill list in `AGENTS.md`.
