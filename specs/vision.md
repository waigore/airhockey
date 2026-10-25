# Game Vision

Authoring rules: [`.agents/specs/rules/vision.md`](../.agents/specs/rules/vision.md).

## Elevator pitch

A space-themed 2D air hockey game where you slam a puck with a mallet under realistic physics to score on your opponent.

## High-level description

Players face off in a top-down arcade duel suspended in zero-G. Matches are short score-to-N contests on a single neon table against a starfield backdrop. Motion and collisions feel physical and responsive; the arena, puck, and mallets stay readable and minimalist. Sessions end quickly and invite an immediate rematch. The hook is believable puck and mallet physics in a compact space duel, not simulation depth or online play.

## Target audience and player fantasy

- **Audience**: Casual desktop and mobile players; short sessions, rematch-friendly.
- **Player fantasy**: An arcade duel in zero-G.

## Essential qualities

| # | Quality | Description | Supports it if… |
|---|---------|-------------|-----------------|
| 1 | Physical feel | Collisions and motion read as believable and responsive | A reviewer can tell mallet hits and wall bounces from floaty or rubbery motion |
| 2 | Readable duel | Puck, mallets, goals, and score stay clear at a glance | A viewer can track the puck and both sides without clutter |
| 3 | Arcade brevity | A match is short and rematch-friendly | A full match finishes in a few minutes and restart is one clear action |

## Tradeoffs

1. Physical feel over ornate visuals — when decoration would muddy collisions or clarity, keep feel and a minimalist readable look.

## Non-goals

- Not a sports simulation of real air hockey.
- Not online multiplayer.
- Not a 3D game.
