# PoC requests

Logged exploration requests (not specs). Contract: [`docs/pocs.md`](../pocs.md), notes overview: [README.md](README.md).

Each open request should become a GitHub task or epic before build. Status `filed` once `#n` exists.

## Entries

### space-neon-aesthetics-on-physics

- **Purpose**: Set vision-aligned space tone (faint stars, neon glow, readable minimalist) on top of the proven physics feel.
- **Scope**: In — starts from `physics-feel-live-tunables` with the same arena dimensions (`TABLE Rect2(250, 8, 360, 704)`, wall thickness 24, goal width 130) and PoC 1 preferred physics defaults; starfield backdrop; neon glow on arena, puck, and mallets; readability check under that look; draw entities with Godot-native 2D tools only (no Recraft/Fal/other image generation; PoC-scoped); multiple neon-glow and starfield approaches with in-PoC tune/choose for PO selection. Out — new game modes; final asset pipeline; replacing physics conclusions from PoC 1; retuning/resizing the PoC 1 baseline for aesthetics; project-wide ban on textures/image gen beyond this PoC.
- **Desired outcome**: Keep/adapt list for aesthetics/view; confirm readable duel under neon/space look; PO-chosen glow and starfield approach from alternatives shipped in the PoC.
- **Trigger**: user-requested
- **Related**: `specs/vision.md`; `docs/requirements/aesthetics.md`; `docs/requirements/view.md`; depends on `physics-feel-live-tunables`
- **Status**: built — `pocs/space-neon-aesthetics-on-physics/` (Godot-native starfield ×2 + neon glow ×2 on PoC 1 physics/arena baseline; awaiting verification/acceptance)
- **Issue**: #4
