---
name: review-project-issue
description: |-
  Review an epic/task/defect in status:pending-review; post pass, fail, or
  clarification evidence and advance status via enforce-task-workflow-status.
  Use when the user asks to review an issue, approve it for implementation, request
  refinements, or escalate clarification to the product owner.

  Examples:
    - user: "Review #12" → holistic review, comment, gate status
    - user: "Fail review on #8; also impacts #9" → fail #8 and cascade #9 on the user's order
    - user: "Fail review on #8" → fail #8; cascade a blocked-by neighbor only with an implementation or verification deadlock
    - user: "Needs clarification on #3" → questions comment → pending-clarification
---

# Review project issue

Review a typed issue currently in `status:pending-review`.

**Contract:** [`docs/issues/workflow.md`](../../../docs/issues/workflow.md)

**Status gate:** [`enforce-task-workflow-status`](../enforce-task-workflow-status/SKILL.md) and [`status-transitions.md`](../enforce-task-workflow-status/references/status-transitions.md)

## Steps

1. **Load** issue `n`: title, body, labels, parent/sub-issues/siblings as available (`gh issue view`, linking docs under `create-project-task/references/` if needed).
2. **Assert** `status:pending-review` via enforce gate readiness (abort if wrong status).
3. **Review holistically** against the whole issue and parent/sibling relationships (including after prior refinements):
   - Body internally consistent; no major gaps/ambiguities/underspecifications
   - Deliverables and acceptance criteria align with parent goal/scope, or project vision if root-level
   - Acknowledge when the issue is a **new requirement**
   - **If `type:epic`** (addendum — epic granularity; wave coherence is [`audit-project-wave`](../audit-project-wave/SKILL.md)):
     - Goal is an observable outcome, not a task list; Scope has explicit in/out; out-of-scope names sibling epics or other waves when known
     - In-scope qualified IDs (from Notes/Scope) are owned by child tasks when children exist (coverage/ownership — not path-level AC polish)
     - Not a horizontal catch-all; foundation stays substrate-only
     - Main-code epic: no global PoC/promotion gate. If a logged PoC must prove a claim this epic depends on, blocked-by that PoC issue (or call out the missing edge). Product demo mode is ordinary main-tree work when `demo.md` Offering is offered.
   - **Technical elements**: When the title or body names a specific layer, module, component, contract, schema, or sequence, it cites a qualified ID or a `specs/technical/` path that already exists. A cited element ID (such as `CMP-input.R2`) exists in that spec. A file that still contains `<!-- fill in -->` counts. Keys: [`ids.md`](../../specs/rules/technical/ids.md) (`LAY`, `MOD`, `CMP-<name>`, `CTR-<name>`, `SCH-<name>`, `SEQ-<name>`). An issue that never names one of these is unaffected.
     - No such ID or file → **Fail**. Refinement: cite the real ID or path, or make the deliverable authoring that element and drop any implementation of it.
     - Spec-authoring exception: the issue may name an element that does not exist yet when the deliverable is creating it (a new file under `components/`, `contracts/`, `schemata/`, or `sequences/`, or a new ID in `layers.md` or `modules.md`). It must not treat that name as an existing ID, and it must not ask to implement it.
4. **Decide** one outcome:
   - **Pass** — post a clear pass review comment (must be the latest comment when transitioning). Gate: `pending-review` → `pending-implementation`.
   - **Fail** — post problems + refinement direction. Gate this issue: `pending-review` → `pending-refinement`. Cascade another issue only under [Cascade (fail review)](../../../docs/issues/workflow-cascade.md). A user order cascades from any status. An agent cascade needs a native blocked-by edge plus a written reason that the other issue’s implementation or verification cannot be done or judged while this fail stands. Leave an issue whose current step is review, refinement, or clarification unchanged. For each authorized issue, comment (point at this fail; for an agent cascade, include the edge and the deadlock) and apply the fail-review cascade via `enforce-task-workflow-status`, with that issue’s current status as `from`. For each blocked-by neighbor not cascaded, and for any issue the user asked about that was not ordered onto the cascade, comment why the status stays and leave it unchanged.
   - **Clarify** — summarize questions that cannot be inferred from project scope (including material spec ambiguity). Gate: `pending-review` → `pending-clarification`.
5. **Report** URL, outcome, new status(es), and related issues touched.

## Rules

- Do not redefine the state machine; link the workflow doc.
- Authorize a cascade only as [Cascade (fail review)](../../../docs/issues/workflow-cascade.md) describes.
- Evidence is freeform; intent must be clear.
- Call `enforce-task-workflow-status` for every label change.
- Do not file defects from review. Spec/design problems are refinement, clarification, or (if uncovered and material) a **task** — never a defect ([`requirements.md`](../../../docs/issues/requirements.md)). Do not Fail or spawn work for non-material paperwork.
