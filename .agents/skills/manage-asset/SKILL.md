---
name: manage-asset
description: |-
  Generate, import, update, or deprecate game assets by running the asset
  pipeline procedures in specs/assets/ against the style in specs/aesthetics/,
  record every change in the catalog's entry files, get each draft reviewed with
  review-asset, and open a PR. Spec first: only assets a coverage rule
  requires, through tool roles realized by Accepted ADRs or ADR-free tools in
  docs/asset-tools.md (Recraft for visual gen/edit/touch-up and style series;
  Cheaper Inference ADR-free for non-series visual gen/reference via locked
  steps + cheaperinference_image.py; ElevenLabs CLI for music/SFX/voice and
  audio style series — never MCP; fal needs an ADR and is not used when the
  kind series is active). Never a banned tool.
  Use when the user asks to create, generate, source, regenerate, replace,
  touch up, or retire art, animation, interface art, fonts, or audio.
  For establishing a kind's style series, use establish-asset-style.

  Examples:
    - user: "Generate the player run sprites" → APR.generate from the kind recipe, checks, review, PR
    - user: "Generate the menu theme with the music series" → ElevenLabs CLI + finetune_id
    - user: "Use this licensed tileset for the forest" → APR.import, license check, catalog, review
    - user: "Regenerate the slime with the new palette" → APR.update, version bump, re-review
    - user: "Retire the old HUD icons" → APR.deprecate with successor IDs
    - user: "Remove the background on the slime sprite" → APR.touch-up, re-check, re-review
---

# Manage asset

Procedures: [`specs/assets/procedures.md`](../../../specs/assets/procedures.md). Style: [`specs/aesthetics/`](../../../specs/aesthetics/aesthetics.md). Review: [`review-asset`](../review-asset/SKILL.md). Style series: [`establish-asset-style`](../establish-asset-style/SKILL.md).

## Steps

1. **Gate**. Stop, say what is missing, and offer `capture-requirements`, `author-spec`, `audit-spec-tbd`, or `establish-asset-style` when any of these fails:
   - The asset hub's **Catalog** names a catalog root and asset root (no TBD), and **Approval** is filled.
   - The target kind spec exists. Its coverage rule, specification, recipe, checks, and Style series hold no placeholder or TBD for the work requested.
   - Every aesthetics element the kind cites exists and holds no TBD.
   - The recipe's tool role in `specs/assets/tools.md` is realized by an **Accepted** ADR, or by an ADR-free tool named in [`docs/asset-tools.md`](../../../docs/asset-tools.md). Prefer tools per that doc. When the kind Style series is `active`, use Recraft (visual) or the ElevenLabs CLI (music / SFX / voice; never MCP); do not use fal or Cheaper Inference for series-active work.
   - Full series generate/update needs Style series `active` with the modality binding (hard id or soft anchors for SFX). If `none` or `bootstrapping`, only bootstrap seed runs (or hand off to `establish-asset-style`). If `stale`, refresh via `establish-asset-style` first.
2. **Resolve the request** to one procedure (`APR.generate`, `APR.import`, `APR.update`, `APR.deprecate`, or `APR.touch-up`), the kind spec, coverage rules, and asset IDs. If no coverage rule requires the asset, stop: spec first.
3. **Confirm scope** with the user when the request spans more than one coverage rule or would exceed a cost or quota limit in `tools.md`.
4. **Track and branch** per [`docs/pull-requests.md`](../../../docs/pull-requests.md): use the given task, or branch `chore/assets-<slug>` when the user asks for no issue.
5. **Run the procedure** as `procedures.md` states:
   - **Generate**: pick bootstrap vs series prompt template from the recipe; compose with Style series `prompt_policy` (master + negative, cite-by-ID); pass modality binding when `active` and hard (`input_style_id` / `finetune_id` / `voice_id`); for music, attach Audio Reference when series policy requires or allows it; soft SFX uses anchors + policy only. Do not invent a parallel style. Prefer prior `generation.prompt` as a guide on amend paths.
   - **Cheaper Inference** (when the recipe/tool role selects it, or preference allows and series is not `active`): follow [`docs/asset-tools-cheaperinference-steps.md`](../../../docs/asset-tools-cheaperinference-steps.md) exactly — prefer `python3 .github/scripts/cheaperinference_image.py` (`generate` or `reference`). Do not call `/v1/images/edits` for `flux-2-max` or invent model display names.
   - **Update**: append `history` before overwriting `generation`; keep series binding; guide from prior prompt unless Fail/aesthetics/series refresh requires a rewrite.
   - Use style anchors and `REF`s the recipe names; follow settings and seed policy (`n/a` when the tool has no seed); post-process; save per **Naming**.
6. **Check**: run every check in the kind spec. Retry within the limit in `procedures.md`, then stop and ask the user.
7. **Touch up (optional)**: `APR.touch-up` with a Recraft option from `docs/asset-tools.md` for visuals. Respect series negatives; do not clear `series`. Record each operation in `touchups` (`CAT.F19`) including prompt/inputs/settings when used. Rerun step 6.
8. **Catalog**: write or update `<catalog-root>/<asset-id>.json` with every field [`catalog/fields.md`](../../../specs/assets/catalog/fields.md) requires, including structured `generation` (`prompt`, `tool`, `operation`, `settings`, `seed`, `inputs`, `series` copy, `steps`, `negative_prompt` when composed) and optional `guidance`. New asset IDs only from `python3 .github/scripts/new_asset_id.py`. Confirm handle uniqueness on `main` and open PRs.
9. **Review**: run `review-asset` (`APR.review`). On Fail, fix through step 5 or 7 within the limit. On Pass, approve per hub **Approval**. Exemptions only when a person grants `CAT.F17`.
10. **PR**: per [`docs/pull-requests.md`](../../../docs/pull-requests.md). Authority cites kind, coverage, aesthetics, style series, and tool ADRs (`adr-free` when applicable). Test plan: checks, touch-ups, `asset_catalog.py`, `review-asset` verdict. If the work delivers a typed issue, run [`implement-project-issue`](../implement-project-issue/SKILL.md).

## Rules

- Never invent a recipe, prompt, setting, style choice, coverage rule, or style-binding id. Missing ones go into specs or `establish-asset-style` first.
- Use only Accepted ADR tools, ADR-free / touch-up options in `docs/asset-tools.md`, or the modality-required tool for active series. Audio via ElevenLabs is CLI-only ([`docs/asset-tools-elevenlabs.md`](../../../docs/asset-tools-elevenlabs.md)); never an ElevenLabs MCP. Never a banned tool. Credentials never enter the repository.
- Do not import a third-party asset whose license is unclear; stop and ask.
- Main code uses only approved assets. Do not wire a draft into main code.
- Person-supplied assets go through [`register-asset`](../register-asset/SKILL.md). Style series establish goes through [`establish-asset-style`](../establish-asset-style/SKILL.md).
- Never change or reuse an asset ID; rename a handle only on request, per `catalog.md`.
