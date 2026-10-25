---
name: issue-workflow-refine-agent
description: |-
  Background dispatch for status:pending-refinement: resolve or discover one
  typed issue, then run refine-project-issue (body edit, summary comment, status
  gate). Use when automation dispatches an unattended refine agent.

  Examples:
    - dispatch with no issue → discover pending-refinement, pick one, refine
    - dispatch with #8 → refine-project-issue on #8
---

# Issue workflow refine agent

Thin automation entrypoint for `status:pending-refinement`.

**Contract / discovery:** [`docs/issues/workflow-dispatch.md`](../../../docs/issues/workflow-dispatch.md)

**Delegates to:** [`refine-project-issue`](../refine-project-issue/SKILL.md)

## Steps

1. **Resolve** one target issue per the dispatch contract. Agent-orc `Assigned issue: N` is `#n`; `none` or no number means discover `status:pending-refinement`.
2. **Read and run** `refine-project-issue` for that issue.
3. **Report** the underlying skill's outcome (URL, summary, new status).
