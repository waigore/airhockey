# PoC requests

Logged exploration requests (not specs). Contract: [`docs/pocs.md`](../pocs.md), notes overview: [README.md](README.md).

Each open request should become a GitHub task or epic before build. Status `filed` once `#n` exists.

## Entries

### space-neon-aesthetics-on-physics

- **Purpose**: Set vision-aligned space tone (faint stars, neon glow, readable minimalist) on top of the proven physics feel.
- **Scope**: In — extends `physics-feel-live-tunables` scene; starfield backdrop; neon glow on arena, puck, and mallets; readability check under that look; draw entities with Godot-native 2D tools only (no Recraft/Fal/other image generation; PoC-scoped); multiple neon-glow and starfield approaches with in-PoC tune/choose for PO selection. Out — new game modes; final asset pipeline; replacing physics conclusions from PoC 1; project-wide ban on textures/image gen beyond this PoC.
- **Desired outcome**: Keep/adapt list for aesthetics/view; confirm readable duel under neon/space look; PO-chosen glow and starfield approach from alternatives shipped in the PoC.
- **Trigger**: user-requested
- **Related**: `specs/vision.md`; `docs/requirements/aesthetics.md`; `docs/requirements/view.md`; depends on `physics-feel-live-tunables`
- **Status**: filed
- **Issue**: #4
