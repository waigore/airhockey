---
name: issue-workflow-implement-agent
description: |-
  Background dispatch for status:pending-implementation: resolve or discover one
  typed issue, perform the implementation work, then run implement-project-issue
  (deliverables comment + status gate). Use when automation dispatches an
  unattended implement agent.

  Examples:
    - dispatch with no issue → discover pending-implementation, pick one, implement
    - dispatch with #12 → implement #12, then implement-project-issue
---

# Issue workflow implement agent

Thin automation entrypoint for `status:pending-implementation`.

**Contract / discovery:** [`docs/issues/workflow-dispatch.md`](../../../docs/issues/workflow-dispatch.md)

**Delegates to:** [`implement-project-issue`](../implement-project-issue/SKILL.md) (after doing the work)

## Steps

1. **Resolve** one target issue per the dispatch contract. Agent-orc `Assigned issue: N` is `#n`; `none` or no number means discover `status:pending-implementation`.
2. **Perform** the implementation work required by that issue (branch, code/specs/assets as scoped, PR as appropriate). Respect native **blocked-by** edges (including a PoC task when one must prove a claim). Do **not** require a global PoC or `reconcile-poc` before main-tree edits. `implement-project-issue` records evidence only — it does not replace this step.
3. **Read and run** `implement-project-issue` for that issue.
4. **Report** the underlying skill's outcome (URL, evidence, new status). Stop after `implement-project-issue`. Verification is a later `issue-workflow-verify-agent` run.
