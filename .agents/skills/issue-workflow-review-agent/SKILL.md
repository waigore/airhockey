---
name: issue-workflow-review-agent
description: |-
  Background dispatch for status:pending-review: resolve or discover one typed
  issue, then run review-project-issue (comments + status gate). Use when
  automation dispatches an unattended review agent.

  Examples:
    - dispatch with no issue → discover pending-review, pick one, review
    - dispatch with #12 → review-project-issue on #12
---

# Issue workflow review agent

Thin automation entrypoint for `status:pending-review`.

**Contract / discovery:** [`docs/issues/workflow-dispatch.md`](../../../docs/issues/workflow-dispatch.md)

**Delegates to:** [`review-project-issue`](../review-project-issue/SKILL.md)

## Steps

1. **Resolve** one target issue per the dispatch contract. Agent-orc `Assigned issue: N` is `#n`; `none` or no number means discover `status:pending-review`.
2. **Read and run** `review-project-issue` for that issue.
3. **Report** the underlying skill's outcome (URL, decision, new status).
