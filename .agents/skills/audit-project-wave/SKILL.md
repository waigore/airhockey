---
name: audit-project-wave
description: |-
  Audit a filed wave (milestone) against the waves contract: epics and defined
  tasks for coherence, focus, completeness, and quality. Propose changes;
  confirm before mutating. Use after plan-project-waves, when a wave looks
  bloated or incomplete, or before expanding leaves.

  Examples:
    - user: "Audit wave 1" → load wave, findings + proposed changes, wait
    - user: "Draft wave audit only" → --no-create, print package
    - user: "Apply the wave 2 fixes" → confirm then mutate
---

# Audit project wave

Judge a **filed** wave against the contract in [`docs/issues/waves.md`](../../../docs/issues/waves.md). Bodies: [`docs/issues/`](../../../docs/issues/). Do not redefine headings or restate the contract here.

**Delegates (after confirm):** [`create-project-epic`](../create-project-epic/SKILL.md), [`create-project-task`](../create-project-task/SKILL.md) when new issues are needed; `gh` for milestone description, assignment, and moves. Per-issue body polish: [`review-project-issue`](../review-project-issue/SKILL.md).

## Principles

- **Contract bar** — Expected deliverable (milestone description), foundation-before-verticals, vertical slices, optional PoCs (local blocked-by only): as in `docs/issues/waves.md`. Soft size: **≤2–3 epics / wave**, **~10 implementation tasks / epic**. Prefer smaller focused waves over large scopes that hide complexity.
- **Coherent and consistent** — Epics (and tasks where filed) clearly serve the milestone deliverable; no overlaps, contradictions, or mis-membership.
- **Focused implementation** — No work that enlarges effort without benefit to this wave’s deliverable. Drop, defer, or move noise elsewhere.
- **In / out of scope** — The wave must state what is in, what is out, and what is deferred or assigned to other waves. Prefer **split or move** over stuffing this wave when completeness would bloat it.
- **Quality and completeness** — The epic+task set must be enough to ship the stated deliverable without gaps that fit no owner.

## Workflow

1. **Resolve** — Milestone (ask if unclear). Load description + `type:epic` issues on it, and their child tasks where defined.
2. **Judge** — Against the principles above and the waves contract. Vague/missing milestone description → propose one from epic goals + specs (do not invent product scope); do not mutate until confirmed.
3. **Propose** — Findings and proposed changes (description edit, new/moved epics, task add/drop/defer, set-level scope/Notes). `--no-create` / draft-only: print and stop.
4. **Confirm**, then **apply** agreed mutations only. Do not build PoCs or game code here.
5. **Report** — Milestone URL, what changed, remaining risks.

## Rules

- Confirm before every mutation. Do not invent scope the user rejected.
- Requirement notes under `docs/requirements/` are not authority.
