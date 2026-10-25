---
name: promote-gameplay-demo
description: |-
  Reimplement one demo's confirmed keep list in the main tree. The list comes
  from require-demo-promotion. Writes assumptions into specs, covers the code
  in the technical design, then reimplements it under SOLID, the coding
  conventions, and the normal test bar. The demo stays unchanged as the reference.
  Use after that act has passed, or when a promotion task is ready to build.

  Examples:
    - user: "Promote the movement demo into the game" → require-demo-promotion, then reimplement its keep list
    - user: "Promotion task #30 passed review, build it" → implement phase only
---

# Promote gameplay demo (facade)

Canonical instructions: [`.agents/skills/promote-gameplay-demo/SKILL.md`](../../../.agents/skills/promote-gameplay-demo/SKILL.md).

Read that file and its `references/` as needed, then run the workflow there. Do not invent a parallel process.
