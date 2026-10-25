---
name: issue-workflow-verify-agent
description: |-
  Background dispatch for status:pending-verification: resolve or discover one
  typed issue, then run verify-project-issue (independent check, comments + status
  gate). Use when automation dispatches an unattended verify agent.

  Examples:
    - dispatch with no issue → discover pending-verification, pick one, verify
    - dispatch with #12 → verify-project-issue on #12
---

# Issue workflow verify agent

Thin automation entrypoint for `status:pending-verification`.

**Contract / discovery:** [`docs/issues/workflow-dispatch.md`](../../../docs/issues/workflow-dispatch.md)

**Delegates to:** [`verify-project-issue`](../verify-project-issue/SKILL.md)

## Steps

1. **Resolve** one target issue per the dispatch contract. Agent-orc `Assigned issue: N` is `#n`; `none` or no number means discover `status:pending-verification`.
2. **Read and run** `verify-project-issue` for that issue (independence is enforced by that skill and the dispatch contract).
3. **Report** the underlying skill's outcome (URL, pass/fail, new status).
