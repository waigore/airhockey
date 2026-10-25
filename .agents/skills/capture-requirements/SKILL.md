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
    - unclear rendering approach during technical capture → propose PoC; log purpose/scope/outcome; offer task
---

# Capture requirements

Interview, then write via [`author-spec`](../author-spec/SKILL.md) and open a spec PR. Do not run `review-spec` or audits unless the user asks separately.

## High-level stage

These files set the big parameters every other spec builds on. Capture them first, in this order:

1. `specs/vision.md`
2. `specs/definition/definition.md`
3. `specs/definition/quality.md`

The stage is **locked in** when none of the three holds a `<!-- fill in -->` placeholder and none holds a **blocking TBD**: a TBD in the elevator pitch, essential qualities, scope, player objectives, supported platforms, engine, or spec depth. Other TBDs may stay open for later.

When the user's input covers more than one uncaptured high-level file, capture those files together in one run: one interview, one combined confirmation, one PR.

## Detailed input

When the user's input goes beyond the target (often a long first prompt), sort every statement before interviewing:

- **High-level**: a statement that answers, or implies an answer to, a vision, definition, or quality field. Design detail counts when it implies one, such as "runs end when you die" for win/lose conditions. Use it as a **proposed answer** in the interview, citing the statement; never write it unconfirmed.
- **Downstream**: design, view, aesthetics, UX, playtest, asset pipeline, ADR, or technical detail. Save it as a [requirement note](../../../docs/requirements/README.md) for its target; do not author downstream specs early.
- **Conflict**: a detail that contradicts or goes beyond the high-level answers (scope, non-goals, platforms, constraints, qualities). Raise it in the interview and ask how to resolve it: change the high-level answer, change or drop the detail, or mark it TBD. Save only the resolved version as a note.

## Steps

0. **Setup**: run [`ensure-project-setup`](../ensure-project-setup/SKILL.md) unless it already passed in this session. Continue only on Pass.
1. **Resolve and confirm the target**:
   - **None named**: the uncaptured high-level files, in order (together when the input covers several). If all three are captured but blocking TBDs remain, run [`audit-spec-tbd`](../audit-spec-tbd/SKILL.md) on them instead. If the stage is locked in, ask which downstream spec to capture.
   - **Downstream named** (design, view, aesthetics, UX, playtest, asset pipeline, ADR, technical) while the stage is not locked in: do not capture it. Say what is missing, keep its detail per **Detailed input**, and offer the high-level stage or the TBD audit.
   - **Ambiguous or several downstream named**: ask which **one** file this run.
2. **Load capture context**: resolve rules the same way [`author-spec`](../author-spec/SKILL.md) does (do not invent a parallel chain). Read each existing target and/or the folder `_template` placeholders, the [requirement notes](../../../docs/requirements/README.md) for each target, and minimal upstream only when those rules require grounding.
3. **Sort and interview**. Sort the input per **Detailed input**. Derive questions from required sections, placeholders, and gaps vs the rules; lead each with its proposed answer from the input or notes when one exists. Prefer few focused rounds over a dump. For already-filled sections, ask only to confirm or revise. Raise conflicts. When the user has not decided something, record it as TBD per [Undecided aspects](../../specs/rules/README.md#undecided-aspects-tbd); do not invent product decisions. In the high-level stage, point out when a TBD would be blocking.
4. **PoC requests**. When a candidate design, ADR, or technical claim rests on an unproven achievability (especially rendering, scene setup, physics feel, tooling), **propose** a PoC, or **accept** one the user requests. Draft purpose, scope, and desired outcome. Same path for both. See [`docs/pocs.md`](../../../docs/pocs.md) and [`docs/requirements/poc-requests.md`](../../../docs/requirements/poc-requests.md). Do not treat a PoC as a global gate for all main code.
5. **Confirm**. Short bullet summary per target of what will be written, each TBD with its open question, the notes to save, PoC requests to log (purpose/scope/outcome/trigger), and the notes consumed or rejected; wait for user OK or corrections.
6. **Author**. Run [`author-spec`](../author-spec/SKILL.md) for each target with the confirmed answers. Save new notes and confirmed PoC request entries; prune consumed or rejected ones.
7. **File PoCs** (optional same run): for each confirmed request, offer [`create-project-task`](../create-project-task/SKILL.md) or [`create-project-epic`](../create-project-epic/SKILL.md) with purpose/scope/outcome in the body, or defer to the planner. Update the log Status/Issue when filed. Dependents may use native blocked-by that issue only.
8. **Open a spec PR** per [Spec PRs](../../../docs/pull-requests.md#spec-prs), covering the specs, notes, and PoC log of this run.
9. **Offer the next target**: per step 1 with none named, and ask whether to continue now. A new target is a new run of these steps. Optionally note `review-spec` and `audit-spec-tbd` when TBDs remain; do not run them unless the user asks.

## Rules

- One `specs/` path per run, except the high-level stage, whose files may share a run. Several runs may follow each other in one session.
- No downstream capture until the high-level stage is locked in.
- Requirement notes and PoC request log entries are not specs: never cite them as authority or build main code on them unconfirmed. The filed PoC issue is the build authority for that exploration.
- Follow `author-spec` rules for writing; do not paste authoring rules into this skill or into `specs/`.
- Do not run `review-spec`, `audit-spec-applicability`, `audit-spec-terminology`, or `audit-spec-tbd` unless the user separately asks, or step 1 offers the TBD audit and the user accepts.
