# ADR-0001: Godot 4 engine

Authoring rules: [`.agents/specs/rules/adr/decision.md`](../../../.agents/specs/rules/adr/decision.md).

- **Status**: Accepted
- **Date**: 2026-10-25
- **Category**: Engine
- **Supersedes**: None
- **Informed by**: vision Physical feel; definition Engine (Godot), 2D physics, Desktop/Mobile; quality Performance, Load time / latency, Reliability, Observability, Accessibility

## Context

Definition names Godot for a 2D air hockey duel on desktop and mobile. Physical feel needs believable puck/mallet collisions. Version, language, and physics boundaries were unset.

## Purpose

Which Godot build and scripting surface realize the definition’s engine choice, and what goes through it?

In: version, primary language, 2D physics/export. Out: game architecture, asset tools, addons (other ADRs).

## Decision

- **Godot 4.7.x** stable; compatible with **4.7+** on the 4.x line.
- Primary code (game/PoCs): **GDScript**.
- Motion/collisions: Godot **2D physics** (gravity may be 0).
- Desktop/mobile: Godot built-in export for definition platforms.
- No second engine; runtime stays Godot scenes/nodes/physics/input/render/export.

## Reasoning

1. Physical feel / 2D physics constraint — Godot 2D physics is the hook; 4.7.x pins the API.
2. Platforms — one engine covers desktop and mobile export.
3. Maintainability — GDScript fits a small 2D Godot project.

## Rejected alternatives

| Alternative | Why rejected |
|-------------|--------------|
| None — different engine | Engine set in the definition |
| Godot 3.x | Lacks 4.x 2D/API baseline |
| C# as primary | Heavier for this GDScript-native duel; supersede later if needed |



## Non-functional requirements

### Quality expectations

| Category | Effect | How this decision meets or limits the target |
|----------|--------|----------------------------------------------|
| Performance | Affects | 60 fps achievable in Godot 2D; keep VFX lean |
| Load time / latency | Affects | Cold start under 3 s needs lean scenes/assets |
| Reliability | Affects | Stable 4.7.x only; no unreleased forks |
| Observability | Affects | Godot logs with severity for play events |
| Save durability | N/A in quality.md | — |
| Accessibility | Affects | UI scale/contrast supported; neon is content |
| Localization | N/A in quality.md | — |

### Engineering qualities

| Quality | Assessment |
|---------|------------|
| Licensing and cost | MIT; no engine fee |
| Maintainability | Mature 4.x; prefer in-line upgrades |
| Testability | GUT / built-in; headless unit runs OK |
| Portability | Desktop/mobile export match definition |
| Security and privacy | Local game; no network by this ADR |

## Imposes

| Spec or element | Constraint |
|-----------------|------------|
| None | Realizes definition Engine; no new product limits |



## Validation

| Check | Method | When |
|-------|--------|------|
| Runs on Godot 4.7.x | Editor/CLI smoke | First engine-task acceptance |
| 60 fps / hitch | Frame-time sampling (quality.md) | Release |
| Cold start under 3 s | Timed cold launch | Release |
| Crash-free 30 min | Continuous play | Release |
| Severity-tagged logs | Forced error + goal | Observability work |
| Contrast/text readable | Side-by-side platforms | Release |
