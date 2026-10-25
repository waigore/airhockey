---
name: scope-gameplay-demo
description: |-
  Decide which spec gaps block a gameplay demo from what that demo must show
  or apply. The gate lives in docs/demos.md Before building.
  Use when scoping a demo, or when create-gameplay-demo starts its scope phase.

  Examples:
    - user: "Demo only the HUD; combat rules can stay TBD" → combat does not block
    - user: "What has to be decided before a movement demo?" → apply the gate to that scope
    - create-gameplay-demo: Scope → run this; do not restate the gate
---

# Scope gameplay demo (facade)

Canonical instructions: [`.agents/skills/scope-gameplay-demo/SKILL.md`](../../../.agents/skills/scope-gameplay-demo/SKILL.md).

Read that file and its `references/` as needed, then run the workflow there. Do not invent a parallel process.
