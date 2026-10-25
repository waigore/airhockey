# PoC: Physics feel with live tunables

Exploration artifact, not production code. Contract: `docs/pocs.md`, `docs/poc-style-assets.md`.

- **Question**: Can Godot 2D puck/mallet/wall collisions feel believable at gravity 0, and do live parameter tweaks clearly change that feel?
- **Type**: engine
- **Issue**: #3
- **Request log**: `docs/requirements/poc-requests.md` → `physics-feel-live-tunables`
- **Purpose / scope / outcome**: Prove believable collisions + immediate live tunables; go/no-go on default vs custom tuning and a short preferred parameter set. Out of scope: modes/scoring UI, aesthetics pass, online, AI polish, per-side mallet values, spin/angular damp, goal suction.
- **Engine**: Godot 4.7.x / GDScript ([ADR-0001](../../specs/adr/decisions/0001-godot-engine.md))

## Citations (optional)

| Ref | How used |
|-----|----------|
| ADR-0001 | Engine/version/language |
| vision Physical feel | Claim under test |
| definition 2D physics | Gravity 0 duel motion |

## Style

| Style element | Where it is seen or heard |
|---------------|---------------------------|
| None | Debug shapes only; no aesthetics pass |

## Assets

| Asset ID | Handle | Source type | Kind spec | Coverage rule | Tool role (ADR) | Version | State | Review |
|----------|--------|-------------|-----------|---------------|-----------------|---------|-------|--------|
| None | | | | | | | | |

## Pipeline findings

| ID | Finding | Element | Filed as |
|----|---------|---------|----------|
| PF1 | None | | |

## What was tried

- RigidBody2D puck + mallets, StaticBody2D walls with goal gaps, project gravity 0.
- Live debug panel applies mass/bounce/damp/max-speed (puck), mass/max-speed/drive/damp (mallet), wall bounce immediately via `PhysicsMaterial` + forces.
- Mallet follow uses velocity tracking + target smoothing + settle deadzone (no spring; avoids jitter and double-image ghosting).
- Headless smoke: `godot --headless --path . --quit-after 180` (no script errors). Interactive: collisions read clearly; raising puck bounce / lowering damp makes the table livelier; drive strength changes mallet snap.

**Verdict: go** — custom tuning is clearly needed; engine defaults alone are too floaty or dead. Preferred set below is a solid starting point for later design/view.

### Preferred parameter set

| Param | Value |
|-------|------:|
| puck_mass | 0.35 |
| puck_bounce | 1.0 |
| puck_linear_damp | 0.15 |
| puck_max_speed | 2290 |
| mallet_mass | 1.55 |
| mallet_max_speed | 1440 |
| mallet_drive | 12000 |
| mallet_linear_damp | 15.7 |
| wall_bounce | 1.0 |

## Promotion act

Filled by `reconcile-poc`. Incomplete until every claim is keep, drop, or adapt and any conflict spec PR has merged.

| Claim or behavior | Choice | Note |
|-------------------|--------|------|
| <!-- fill in --> | <!-- fill in: keep, drop, or adapt --> | <!-- fill in --> |

Act: incomplete

## Run

```bash
# From repo root (Godot 4.7+ on PATH)
godot --path pocs/physics-feel-live-tunables
```

- **P1 (bottom, cyan)**: mouse
- **P2 (top, coral)**: WASD or arrow keys
- **Reset puck** (panel button): puck to center, velocity cleared
- **R**: reset puck + mallets
- Right-side panel: drag sliders; feel updates without restart

## Known limitations

- No scoring UI; puck soft-resets if it leaves far past a goal.
- Shared mallet tunables (not per-side).
- No spin / angular damp / goal suction (out of scope).
- Puck flight bleed is explicit from **Puck linear damp** only (`0` = no damp bleed). Wall/mallet bounce use physics materials again (custom contact bounce was killing rebounds).
- Main tree must not import from `pocs/`.
