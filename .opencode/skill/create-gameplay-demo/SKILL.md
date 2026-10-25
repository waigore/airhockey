---
name: create-gameplay-demo
description: |-
  Build a gameplay demo under demos/<slug>/ after scope-gameplay-demo passes:
  either a pure engine demo (core rules and feel, no UI) or a full gameplay
  demo with UI/UX. Builds only the confirmed scope as a reference artifact
  that cites its specs. Demo code is exempt from code review but not from
  spec first.
  Use when the user asks for a demo, prototype, vertical slice, or proof of a
  mechanic built from the specs.

  Examples:
    - user: "Build a demo of the core loop" → scope-gameplay-demo, then build an engine demo
    - user: "Gameplay demo with menus and HUD for stage 1" → gameplay type, UX in scope
    - user: "Demo task #21 passed review, build it" → scope check, then build
    - user: "Promote the movement demo into the game" → use require-demo-promotion first
---

# Create gameplay demo (facade)

Canonical instructions: [`.agents/skills/create-gameplay-demo/SKILL.md`](../../../.agents/skills/create-gameplay-demo/SKILL.md).

Read that file and its `assets/` as needed, then run the workflow there. Do not invent a parallel process.
