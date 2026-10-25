---
name: issue-workflow-accept-agent
description: |-
  Background dispatch for status:pending-acceptance: resolve or discover one
  typed issue, then run accept-project-issue (acceptance evidence, comments +
  status gate). Use when automation dispatches an unattended accept agent.

  Examples:
    - dispatch with no issue → discover pending-acceptance, pick one, accept
    - dispatch with #12 → accept-project-issue on #12
---

# Issue workflow accept agent

Thin automation entrypoint for `status:pending-acceptance`.

**Contract / discovery:** [`docs/issues/workflow-dispatch.md`](../../../docs/issues/workflow-dispatch.md)

**Delegates to:** [`accept-project-issue`](../accept-project-issue/SKILL.md)

## Steps

1. **Resolve** one target issue per the dispatch contract. Agent-orc `Assigned issue: N` is `#n`; `none` or no number means discover `status:pending-acceptance`.
2. **Read and run** `accept-project-issue` for that issue (independence is enforced by that skill and the dispatch contract).
3. **Report** the underlying skill's outcome (URL, accept/fail/clarify/waiting on screenshots, new status). Waiting on screenshots stays `pending-acceptance` and is not a defect.
