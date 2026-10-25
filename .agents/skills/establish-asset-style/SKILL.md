---
name: establish-asset-style
description: |-
  Establish or refresh a kind's Style series: bootstrap approved style
  anchors, create the modality binding (Recraft style for visual;
  ElevenLabs finetune for music, voice id for voice; soft anchors for
  SFX), write the kind registry (binding, prompt_policy, state active),
  and open a PR. Identity needs enforced styling, master/negative
  prompting, and review (look or listen). Recraft is required for
  visual series; ElevenLabs CLI for music/SFX/voice (docs/asset-tools.md).
  Use when starting a kind's consistent generation, after anchors change,
  when the series is stale, or the user asks to create/refresh the style
  for sprites, tiles, music, SFX, or voice.

  Examples:
    - user: "Set up the character-sprite style series" → APR.establish-style (Recraft)
    - user: "Establish the battle-music finetune from these anchors" → music series
    - user: "Refresh the tile style after new anchors" → recreate binding, update SS1
---

# Establish asset style

Procedure: [`specs/assets/procedures/establish-style.md`](../../../specs/assets/procedures/establish-style.md) (`APR.establish-style`). Kind Style series: kind specs under [`specs/assets/kinds/`](../../../specs/assets/kinds/). Tools: [`docs/asset-tools.md`](../../../docs/asset-tools.md). Related: [`manage-asset`](../manage-asset/SKILL.md), [`review-asset`](../review-asset/SKILL.md).

## Steps

1. **Gate**. Stop and offer `author-spec` / `capture-requirements` when the kind Style series section or cited aesthetics hold TBD, or the modality tool is unavailable and no person can run the binding step in the web app (Recraft MCP `create_style`; ElevenLabs CLI finetune / voice clone — `elevenlabs` on PATH, `ELEVENLABS_API_KEY` in env).
2. **Resolve** the kind spec and its `SS1` series. Confirm state, **modality** (`visual` | `music` | `sfx` | `voice`), and **enforce** (`hard` | `soft`).
3. **Bootstrap anchors** if `style_anchors` is empty or the user is replacing them:
   - Generate seeds with `manage-asset` using the **bootstrap** prompt template + `prompt_policy`, or register person-supplied assets with `register-asset`.
   - Require `review-asset` Pass (or person exemption). Confirm with the user which approved asset IDs are anchors. Set state `bootstrapping` until then.
4. **Create style binding** per modality (see `docs/asset-tools.md`):
   - **visual (hard)**: upload anchors; Recraft `create_style`; record `recraft_style_id` + model/base.
   - **music (hard)**: upload anchors; create Music Finetune via the ElevenLabs CLI; record `elevenlabs_finetune_id` + model; set Audio Reference policy (`required` | `optional` | `none`).
   - **voice (hard)**: clone or select voice from anchors via the ElevenLabs CLI; record `elevenlabs_voice_id`.
   - **sfx (soft)**: no product style id; keep anchors + `prompt_policy` only until a durable binding exists.
5. **Write the registry** in the kind Style series (`SS1`): modality, enforce, `style_anchors`, style binding, `built_from` (anchor IDs + `YYYY-MM-DD`), aesthetics cites, `prompt_policy` (compose, master, negative citing `PAL`/`FRM` or `SND.*` as applicable). Set state `active`.
6. **Refresh** when `stale`: recreate binding from current anchors; replace the hard id (never keep the old id silently) or reaffirm soft anchors. Note assets that need `APR.update` via `manage-asset`.
7. **PR** per [`docs/pull-requests.md`](../../../docs/pull-requests.md). Authority cites the kind Style series and aesthetics IDs. Test plan: anchors Pass, binding created (or soft affirmed), kind registry updated. If the work delivers a typed issue, run [`implement-project-issue`](../implement-project-issue/SKILL.md).

## Rules

- Recraft is required for visual establish and style-constrained generate. ElevenLabs (CLI only; see [`docs/asset-tools-elevenlabs.md`](../../../docs/asset-tools-elevenlabs.md)) is required for music / SFX / voice. Do not use fal, Cheaper Inference, or an ElevenLabs MCP as a substitute.
- Do not invent anchors, prompt_policy clauses, or aesthetics IDs. Missing ones go to specs first.
- Three pillars: enforced styling, master/negative prompting, review (look or listen). Establishing style alone does not approve series members.
- Credentials never enter the repository.
