# PoC: Space neon aesthetics on physics base

Exploration artifact, not production code. Contract: `docs/pocs.md`, `docs/poc-style-assets.md`.

- **Question**: Does a readable duel still hold when faint starfield + neon glow are layered on the proven PoC 1 physics feel?
- **Type**: engine
- **Issue**: #4
- **Request log**: `docs/requirements/poc-requests.md` → `space-neon-aesthetics-on-physics`
- **Purpose / scope / outcome**: Vision-aligned space tone (faint stars, neon glow, readable minimalist) on the PoC 1 physics/arena baseline; ship multiple glow and starfield approaches with live choose/tune for PO selection; keep/adapt notes for aesthetics/view. Out: new modes, final asset pipeline, overturning #3 physics, retuning/resizing PoC 1 arena or preferred physics defaults.
- **Engine**: Godot 4.7.x / GDScript ([ADR-0001](../../specs/adr/decisions/0001-godot-engine.md))

## Citations (optional)

| Ref | How used |
|-----|----------|
| ADR-0001 | Engine/version/language |
| vision Readable duel / space tone | Claim under test |
| docs/requirements/aesthetics.md | Faint stars + neon glow notes |
| pocs/physics-feel-live-tunables | Physics + arena baseline (copied, not retuned) |

## Style

| Style element | Where it is seen or heard |
|---------------|---------------------------|
| Space backdrop (deep navy) | Full-viewport ColorRect behind playfield |
| Faint starfield (selectable) | Static `_draw()` dots **or** CPUParticles2D twinkle |
| Neon arena / walls | Polygon2D fills + Line2D neon edge / wall rims |
| Neon puck & mallets | Polygon2D disks + selectable glow treatment |
| Glow A — Halo shells | Additive Polygon2D shells + soft aura/rings on puck/mallets/walls |
| Glow B — Env bloom | HDR 2D (`viewport/hdr_2d`) + WorldEnvironment glow on HDR neon colors |
| Shared neon aura | Additive Line2D/Polygon2D aura always on so glow is visible in both modes |

Procedural Godot-native drawing only for this PoC (no Recraft/Fal/imported entity textures). Not a standing project-wide art rule.

## Assets

| Asset ID | Handle | Source type | Kind spec | Coverage rule | Tool role (ADR) | Version | State | Review |
|----------|--------|-------------|-----------|---------------|-----------------|---------|-------|--------|
| None | | | | | | | | |

## Pipeline findings

| ID | Finding | Element | Filed as |
|----|---------|---------|----------|
| PF1 | None | | |

## Physics + arena baseline (PoC 1)

Unchanged from `physics-feel-live-tunables`:

| Constant / param | Value |
|------------------|------:|
| TABLE | Rect2(250, 8, 360, 704) |
| WALL_THICKNESS | 24.0 |
| GOAL_WIDTH | 130.0 |
| puck_mass | 0.35 |
| puck_bounce | 1.0 |
| puck_linear_damp | 0.15 |
| puck_max_speed | 2290 |
| mallet_mass | 1.55 |
| mallet_max_speed | 1440 |
| mallet_drive | 12000 |
| mallet_linear_damp | 15.7 |
| wall_bounce | 1.0 |

Gravity 0; same collision setup. Aesthetics layers on top only.

## Approaches shipped (choose / tune in play)

### Starfield

| ID | Approach | How to select | Tune |
|----|----------|---------------|------|
| S0 | Static draw dots | Left panel → Starfield → **Static draw dots** | density, brightness |
| S1 | Twinkle particles | Left panel → Starfield → **Twinkle particles** | density, brightness, twinkle |

### Neon glow

| ID | Approach | How to select | Tune |
|----|----------|---------------|------|
| G0 | Halo shells (additive rings + aura) | Left panel → Neon glow → **Halo shells** | intensity, saturation |
| G1 | WorldEnvironment bloom (HDR 2D) | Left panel → Neon glow → **Env bloom** | intensity, saturation |

## What was tried

- Copied PoC 1 scene/scripts; locked arena constants and preferred physics defaults.
- Added deep space ColorRect + two starfield implementations and two glow implementations with a left-side aesthetics panel.
- Headless smoke: `godot --headless --path pocs/space-neon-aesthetics-on-physics --quit-after 180` (no script errors).
- First pass was too subtle (low-alpha non-additive shells; bloom without `hdr_2d`). Strengthened: additive aura always on, HDR neon colors, brighter wall/table glow lines, default intensity 0.9. **Readable duel: holds** if intensity stays mid–high; crank bloom to 1.0 only if you want a wash.

### Keep / adapt (aesthetics / view) — draft for reconcile

| Claim or behavior | Suggested | Note |
|-------------------|-----------|------|
| Faint starfield behind playfield | keep | Prefer S0 (static) for calm readability; S1 if more “alive” space |
| Neon rim on arena + cool/warm mallet split | keep | Strong identity; keep contrast high |
| Halo shells (G0) | adapt | Good for 2D-only / mobile; cheap and controllable |
| Env bloom (G1) | adapt | Stronger “neon” but easier to over-bright; needs intensity caps |
| Physics/arena from PoC 1 | keep | Do not resize/retune for aesthetics |

## Promotion act

Filled by `reconcile-poc`. Incomplete until every claim is keep, drop, or adapt and any conflict spec PR has merged.

| Claim or behavior | Choice | Note |
|-------------------|--------|------|
| <!-- fill in --> | <!-- fill in: keep, drop, or adapt --> | <!-- fill in --> |

Act: incomplete

## Run

```bash
# From repo root (Godot 4.7+ on PATH)
godot --path pocs/space-neon-aesthetics-on-physics
```

- **P1 (bottom, cyan)**: mouse
- **P2 (top, coral/magenta)**: WASD or arrow keys
- **Reset puck** (right panel): puck to center, velocity cleared
- **R**: reset puck + mallets
- **Left panel**: starfield approach + glow approach + intensity/density sliders
- **Right panel**: PoC 1 physics live tunables (baseline defaults)

## Known limitations

- No scoring UI; puck soft-resets if it leaves far past a goal.
- Bloom (G1) depends on Forward+ / Environment glow; effect strength varies with HDR threshold.
- Particle stars use the default CPUParticles2D quad (no custom texture) — intentional for this PoC.
- Main tree must not import from `pocs/`.
