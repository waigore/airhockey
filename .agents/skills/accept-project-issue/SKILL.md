---
name: accept-project-issue
description: |-
  Accept, fail, or escalate clarification for an epic/task/defect in
  status:pending-acceptance using test evidence against acceptance criteria.
  Use when running acceptance testing after verification.

  Examples:
    - user: "Accept #12 with evidence in docs/playtest/evidence/..." → accept comment, status:accepted, leave open (planner may close later)
    - user: "Acceptance failed; file defect" → create defect (game/interface only), link, → pending-implementation
    - user: "Need PO input to finish acceptance on #12" → pending-clarification
    - user: "Headless accept on #12; screenshots still waiting" → stay pending-acceptance, no defect
---

# Accept project issue

Acceptance testing for a typed issue in `status:pending-acceptance`.

**Contract:** [`docs/issues/workflow.md`](../../../docs/issues/workflow.md)

**Status gate:** [`enforce-task-workflow-status`](../enforce-task-workflow-status/SKILL.md)

**Type routing:** [`docs/issues/requirements.md`](../../../docs/issues/requirements.md) (When to file what).

**Playtesting:** [`specs/playtest/playtest.md`](../../../specs/playtest/playtest.md) — required only when deliverables change playable behavior (see step 4).

## Steps

1. **Load** issue `n`, acceptance criteria, verification comment, related PRs.
2. **Assert** `status:pending-acceptance`.
3. **Test** against each acceptance criterion. Evidence must be locatable in the repo (logs, screenshots, paths).
   When the issue's deliverables change playable behavior (game or code), also run AI-agent playtesting per [`specs/playtest/playtest.md`](../../../specs/playtest/playtest.md) and cite evidence under [`docs/playtest/evidence/`](../../../docs/playtest/evidence/) (story IDs, pass/fail, notes, logs, and screenshots when required). Spec-only, docs-only, or other non-playable deliverables do not require playtesting.
   A headless playtest run may judge and record pass/fail, notes, and logs. Acceptance still needs screenshots from a graphical re-run of that same build for every protocol that requires them. A protocol that says none may be accepted from the headless run alone.
4. **Outcome:**
   - **Accept** — comment summarizing evidence per criterion and related PRs, including the graphical-run screenshot paths when playtesting required them. Gate: `pending-acceptance` → `accepted`. **Do not close** the issue (only [`project-planner-agent`](../project-planner-agent/SKILL.md) closes accepted work).
   - **Waiting on screenshots** — headless judgement is recorded and required screenshots are not in the repo yet. Comment with the evidence path and that acceptance waits on a graphical re-run of the same build. Stay on `pending-acceptance`. Do not file a defect. Do not call the status gate.
   - **Fail** — a protocol failed for a **game or interface** reason. Create a Defect via `create-project-defect` when appropriate; link it in the comment. Gate: `pending-acceptance` → `pending-implementation`. Missing screenshots alone are not this outcome. Never file a defect for a spec/doc/map problem.
   - **Clarify** — tests cannot proceed without PO input, **or** a wrong/ambiguous **spec** blocks judging the AC. Summarize questions. Gate: `pending-acceptance` → `pending-clarification`. No defect.
5. **Report** URL, outcome, new status (and defect URL if any).

## Rules

- Leave `status:accepted` issues open; do not close on accept. Closure is planner-only.
- Evidence paths should be in-repo; summarize where to find them.
- Call `enforce-task-workflow-status` for the label change.
- Do not require playtest evidence when the issue does not change playable behavior.
- Do not file a defect, and do not move status, when the only gap is screenshots from a headless run.
- Defects are in-game/interface only; spec problems are clarification or a task ([`requirements.md`](../../../docs/issues/requirements.md)).
