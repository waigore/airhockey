# PoC promotion

Optional reconcile of a PoC into specs and main code. [`reconcile-poc`](../.agents/skills/reconcile-poc/SKILL.md) applies it. Do not add gates. Does **not** block unrelated main-code work.

## When

Run when the user asks to promote/reconcile a PoC, or a task explicitly requires it. Skip if no PoC should enter the game.

## Act

- Walk each claim or demonstrated behavior in the PoC README. Default **keep**. Choices: **keep** (land in specs + main), **drop**, or **adapt** (keep intent, change shape to fit design).
- A kept/adapted claim that disagrees with another PoC or the current spec stops for the user. The winner is written into `specs/`. A losing claim is not promoted. PoC behavior stays as it was.
- The act is complete only after any spec PR from those choices has merged.
- Record keep/drop/adapt and conflict choices in the PoC README. Do not walk a completed act again unless a new conflict appears.

## Reimplementation

A non-empty keep/adapt list is reimplemented by [`promote-poc`](../.agents/skills/promote-poc/SKILL.md), one PoC per task. An empty list completes the act and does not start that skill.

That work writes needed assumptions into `specs/` (user-confirmed), adds technical design the code needs, approves draft assets it uses, and passes `review-code` and the normal test bar. Main code never imports from `pocs/`. The PoC folder stays as historical reference.
