# Game Definition

Authoring rules: [`.agents/specs/rules/definition.md`](../../.agents/specs/rules/definition.md).

## Scope

### In scope

- Local 1P vs AI on desktop and mobile
- Local 2P on desktop only
- One space-themed table and look
- Score-to-N matches with N in {7, 11, 21}
- Rematch after a match ends

### Out of scope

- Online play
- Campaigns or meta progression
- Power-ups
- Customization beyond the one space/neon look
- Timed matches

## Objectives

### Player objectives

- **Goal**: Score more goals than the opponent.
- **Win / lose conditions**: First side to reach the chosen N (7, 11, or 21) wins; the other loses. No timed match.
- **Progression**: None — rematch only.

### Product objectives

- Ship a playable Godot build of the core duel on desktop and mobile.
- Prove believable puck and mallet physics as the main hook of that build.

## Supported platforms

| Platform | Primary input | Priority |
|----------|---------------|----------|
| Desktop | Mouse or keyboard | primary |
| Mobile | Touch (drag / flick) | primary |

## Engine

- **Engine**: Godot — chosen for 2D physics and desktop/mobile export for this duel.
- **Implications**: Play is 2D top-down; desktop and mobile are both reachable export targets.

## Constraints

### Design

- Mobile offers 1P vs AI only; desktop may offer 1P vs AI or local 2P — matches platform input and session shape.

### Technical

- Puck and mallet motion use Godot 2D physics — grounds the physical-feel quality.

### Market

- None

## Spec depth

- **Depth**: small — modest complete game with one core loop.

## Quality expectations

[`quality.md`](quality.md).
