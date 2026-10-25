---
name: require-demo-promotion
description: |-
  Require the promotion act before main-code work. At least one demo must
  exist; its scope may be minimal. Walk every included element of every demo
  under demos/, default keep, and ask keep or drop. Resolve demo-vs-demo and
  demo-vs-spec conflicts with the user, write the winner into specs, and do
  not promote a losing decision. Record the act in each demo README.
  Use before main-code work, or when the user asks to promote a demo.

  Examples:
    - user: "Start implementing movement" and demos/ is empty → stop; at least one demo is required
    - user: "Promote the demos we have" → walk each element, resolve conflicts, record the act
    - issue-workflow-implement-agent: before edits outside demos/ → run this; continue only on pass
---

# Require demo promotion (facade)

Canonical instructions: [`.agents/skills/require-demo-promotion/SKILL.md`](../../../.agents/skills/require-demo-promotion/SKILL.md).

Read that file and its `references/` as needed, then run the workflow there. Do not invent a parallel process.
