---
name: promote-poc
description: |-
  Reimplement one PoC's confirmed keep/adapt list in the main tree. The list
  comes from reconcile-poc. Writes assumptions into specs, covers the code in
  the technical design, then reimplements under SOLID, coding conventions, and
  the normal test bar. The PoC stays unchanged as reference.
  Use after that act has passed, or when a promotion task is ready to build.

  Examples:
    - user: "Promote the movement PoC into the game" → reconcile-poc, then reimplement
    - user: "Promotion task #30 passed review, build it" → implement phase only
---

# Promote PoC

Contract: [Reimplementation in `docs/poc-promotion.md`](../../../docs/poc-promotion.md#reimplementation). The PoC README's Promotion act is the keep/adapt list. Do not restate the gate.

Promotion is a reimplementation in the main tree with the PoC as reference, not a file move.

## Steps

### Prepare

0. **Setup**: run [`ensure-project-setup`](../ensure-project-setup/SKILL.md) unless it already passed in this session. Continue only on Pass.
1. **Act**: run [`reconcile-poc`](../reconcile-poc/SKILL.md) unless it already passed for this PoC in this session. Continue only on pass.
2. **Load** this PoC's Promotion act. If the keep/adapt list is empty, stop. Load its code, related specs/ADRs, and the technical design hub. Skip `specs/adr/archive/` and requirement notes as authority.
3. **Keep list only**: if a kept claim disagrees with the current spec, stop and run `reconcile-poc` again. Do not choose a winner here.
4. **Find spec work** for the keep/adapt list: assumptions needing spec content; technical coverage the code needs; assets used (IDs/handles never change on promotion).
5. **Propose and confirm** that spec work. Wait. Do not re-ask keep/drop/adapt.
6. **Write the specs**: [`audit-spec-tbd`](../audit-spec-tbd/SKILL.md) / [`author-spec`](../author-spec/SKILL.md); open a spec PR per [Spec PRs](../../../docs/pull-requests.md#spec-prs). Remove elements whose assumptions were not confirmed.
7. **Track**: use the given task, or create one with `create-project-task` naming the PoC, elements in scope, the spec PR, and where the code goes. Wait for `status:pending-implementation`.

### Implement

8. **Branch** `task/<n>-<slug>` from `main` after the spec PR has merged.
9. **Approve assets** in scope as needed via [`manage-asset`](../manage-asset/SKILL.md) / [`register-asset`](../register-asset/SKILL.md). Keep asset IDs and handles.
10. **Reimplement** in the main tree per the technical design, [`docs/solid.md`](../../../docs/solid.md), [`docs/coding-conventions.md`](../../../docs/coding-conventions.md), and existing structure. Add tests per the project bar. Do not import from `pocs/` or copy its structure when SOLID/conventions/continuity disagree.
11. **Leave the PoC unchanged**: no edits under `pocs/`.
12. **PR** per [`docs/pull-requests.md`](../../../docs/pull-requests.md). Then run [`implement-project-issue`](../implement-project-issue/SKILL.md).

## Rules

- Spec first for main code: nothing reaches main on an assumption, a losing claim, or a requirement note alone.
- Never resolve an assumption without the user's confirmation.
- One PoC per promotion task; split large promotions so each PR stays small.
