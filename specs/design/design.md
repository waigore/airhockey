# Game Design

Authoring rules: [`.agents/specs/rules/design/design.md`](../../.agents/specs/rules/design/design.md).

## Genre and platform profile

- **Genre(s)**: Arcade sports / air hockey duel.
- **Conventions adopted**: Two sides, one puck, goals at opposite ends; a side scores by putting the puck in the opponent’s goal. Mallets stay on their half; the puck travels the full table.
- **Conventions rejected or changed**: Sports-sim authenticity — arcade physical feel instead of a real-table ruleset (vision: Physical feel, not a sports sim). Online or ranked play — local only (vision non-goal). Timed periods — score-to-N only (definition objectives).
- **Platform implications**: Desktop → design supports 1P vs AI and local 2P; sessions stay short. Mobile → 1P vs AI only; sessions fit short touch play.

## Traceability

[`traceability.md`](traceability.md).

## Index

Global specs: [`glossary.md`](glossary.md), [`traceability.md`](traceability.md), [`ids.md`](ids.md), [`stories.md`](stories.md), [`story-coverage.md`](story-coverage.md), [`game-state.md`](game-state.md), [`configuration.md`](configuration.md), [`demo.md`](demo.md), [`difficulty.md`](difficulty.md), [`progression.md`](progression.md), [`end-conditions.md`](end-conditions.md), [`world.md`](world.md), [`experience.md`](experience.md).

- **Characters**: None
- **Entities**: Planned — `puck`, `mallet`, `table` (not yet authored)
- **Loops**: Planned — `match` (not yet authored)
- **Features**: Planned — `mallet-control`, `puck-physics`, `scoring`, `ai-opponent`, `match-rules` (not yet authored)
- **Flows**: Planned — `play-match` (not yet authored)
- **Stages**: Planned — `space-arena` (not yet authored)
- **Scenarios**: TBD — core first-to-N match scenario not yet authored
- **Sub-games**: None
