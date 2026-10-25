# PoC requests

Logged exploration requests (not specs). Contract: [`docs/pocs.md`](../pocs.md), notes overview: [README.md](README.md).

Each open request should become a GitHub task or epic before build. Status `filed` once `#n` exists.

## Entries

### physics-feel-live-tunables

- **Purpose**: Prove puck/mallet collisions feel believable in Godot 2D, and that live parameter tweaks clearly change that feel.
- **Scope**: In — one table, two mallets, puck, walls/goals; engine-style debug UI; live tunables that apply immediately in play: puck (mass, bounce, linear damp, max speed), mallet (mass, max speed, follow/drive strength, linear damp), walls (bounce). Gravity fixed at 0; physics tick not exposed unless debugging. Out — modes/scoring UI, full aesthetics pass, online, AI polish, per-side mallet values, spin/angular damp, goal suction.
- **Desired outcome**: Go/no-go on default vs custom tuning; a short preferred parameter set for later design/view.
- **Trigger**: user-requested (agent-proposed physics feel; user required live tunables)
- **Related**: `specs/vision.md` (Physical feel); `specs/definition/definition.md` (Godot 2D physics); `docs/requirements/view.md`; `docs/requirements/design.md`
- **Status**: open
- **Issue**: none

### space-neon-aesthetics-on-physics

- **Purpose**: Set vision-aligned space tone (faint stars, neon glow, readable minimalist) on top of the proven physics feel.
- **Scope**: In — extends `physics-feel-live-tunables` scene; starfield backdrop; neon glow on arena, puck, and mallets; readability check under that look. Out — new game modes; final asset pipeline; replacing physics conclusions from PoC 1.
- **Desired outcome**: Keep/adapt list for aesthetics/view; confirm readable duel under neon/space look.
- **Trigger**: user-requested
- **Related**: `specs/vision.md`; `docs/requirements/aesthetics.md`; `docs/requirements/view.md`; depends on `physics-feel-live-tunables`
- **Status**: open
- **Issue**: none
