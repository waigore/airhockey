---
name: capture-requirements
description: |-
  Capture requirements via guided questions derived from each spec's authoring
  rules and template placeholders, confirm answers with the user, then hand off
  to author-spec. Starts with the high-level stage (vision, definition,
  quality), which may be captured in one run, and gates downstream specs until
  it is locked in. Sorts detailed prompts: high-level facts become proposed
  answers, design-level detail is saved as requirement notes for later.
  Use when interviewing for any spec, or when the user asks to capture
  requirements, gather requirements, or fill a spec by asking questions.

  Examples:
    - user: "Help me capture requirements" → next high-level file (vision first), interview, author-spec
    - user: long prompt with pitch, platforms, and combat rules → high-level stage in one run; combat rules saved as notes
    - user: "Help me fill definition by asking questions" → specs/definition/definition.md only
    - user: "Interview me for the movement feature" → only once the high-level stage is locked in; uses saved notes
    - user: "Capture requirements for design and view" → ask which one path this session
---

# Capture requirements (facade)

Canonical instructions: [`.agents/skills/capture-requirements/SKILL.md`](../../../.agents/skills/capture-requirements/SKILL.md).

Read that file and its `references/` as needed, then run the workflow there. Do not invent a parallel process.
