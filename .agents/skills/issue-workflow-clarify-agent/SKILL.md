---
name: issue-workflow-clarify-agent
description: |-
  Background dispatch for status:pending-clarification: resolve or discover one
  typed issue, then run clarify-project-issue when PO answers are available.
  Use when automation dispatches an unattended clarify agent.

  Examples:
    - dispatch with PO answer for #5 → clarify-project-issue on #5
    - dispatch with no PO answer → stop and report; do not invent clarification
---

# Issue workflow clarify agent

Thin automation entrypoint for `status:pending-clarification`.

**Contract / discovery:** [`docs/issues/workflow-dispatch.md`](../../../docs/issues/workflow-dispatch.md)

**Delegates to:** [`clarify-project-issue`](../clarify-project-issue/SKILL.md)

## Steps

1. **Resolve** one target issue per the dispatch contract. Agent-orc `Assigned issue: N` is `#n`; `none` or no number means discover `status:pending-clarification`. Skip candidates that need PO input you do not have.
2. If no PO clarification is available in the dispatch context, **stop and report** — do not invent answers.
3. Otherwise **read and run** `clarify-project-issue` for that issue.
4. **Report** the underlying skill's outcome (URL, new status), or that clarification was unavailable.
