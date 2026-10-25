# Architecture

Authoring rules: [`.agents/specs/rules/adr/adr.md`](../../.agents/specs/rules/adr/adr.md).

## Overview

The game is a Godot 4.7.x 2D project (GDScript) using built-in 2D physics and desktop/mobile export (ADR-0001). Further stack choices (frameworks, libraries, storage, integrations, game architecture) land as separate Accepted ADRs when decided.

## Stack

| Area | Choice | ADR |
|------|--------|-----|
| Engine | Godot 4.7.x, GDScript, 2D physics | [ADR-0001](decisions/0001-godot-engine.md) |
| Frameworks | N/A — none beyond the engine yet | — |
| Libraries | N/A — none chosen yet | — |
| Data storage | N/A — no persistent progress (rematch only) | — |
| Integrations | N/A — none chosen yet | — |
| Game architecture | N/A — not decided yet | — |

## Traceability

[`traceability.md`](traceability.md).

## Index

Global specs: [`traceability.md`](traceability.md). Superseded and deprecated decisions: [`archive/`](archive/README.md).

- **Decisions**: [ADR-0001: Godot 4 engine](decisions/0001-godot-engine.md) — Accepted
