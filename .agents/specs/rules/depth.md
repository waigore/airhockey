# Authoring rules: spec depth

Read this before editing the **Spec depth** section of `specs/definition/definition.md`, and wherever another rules file says a requirement follows spec depth. Do not copy these rules into a spec.

Spec depth sets how much proof and how many visual artifacts the specs carry. It does not lower the bar for what a spec states. At every depth, specs stay self-contained, precise, traced, and identified, and every section the rules require is present or marked N/A.

## Levels

- **prototype**: a jam entry, a vertical slice, or a test of the core idea.
- **small**: a complete game of modest scope, such as one core loop, a handful of features, and a few screens.
- **full**: everything the rules require. Use it when unsure.

## Same at every depth

Glossaries, element IDs, traceability tables, ADRs, every quality category, and the N/A rules in each rules file.

## Core specs

Each story index (`specs/design/stories.md`, `specs/view/stories.md`, `specs/ux/stories.md`) marks every spec with element IDs as core or not. Core is what a player needs to start a session, play the core loop, and reach an end condition. At least:

- **Design**: every loop, the features its steps use, the flows that contain it, `game-state.md`, and `end-conditions.md`.
- **View**: `spatial-model.md`, `projection.md`, the cameras used during the core loop, and `physics.md` when the core loop has simulated motion.
- **UX**: `navigation.md`, `controls.md`, the screens on the path from launch into play and on to the result, the journeys that walk that path, and every screen those journeys reach.

Mark any other spec core case by case, when a defect there would be costly or hard to notice, such as saving, an economy, or hidden information.

## Story coverage

Each spec in a story index has one coverage level:

- **Full**: every requirement in that layer's `story-coverage.md` rules.
- **Baseline**: every element ID and named item in the spec is proven by at least one scenario that shows its stated outcome. The requirements-by-kind table does not apply. Add scenarios case by case, such as a boundary or edge case the core loop depends on.
- **None — reason**: no story file. The reason names the depth and why the spec is not proven, such as "not core, cosmetic only".

| Depth | Core spec | Other spec |
|-------|-----------|------------|
| full | Full | Full |
| small | Full | Baseline, or None — reason |
| prototype | Baseline | None — reason, or Baseline |

The table sets the minimum. Any spec may take a higher level. Choose per spec.

## Visual artifacts

| Artifact | full | small | prototype |
|----------|------|-------|-----------|
| Screen mockups | Every screen, per platform | Core screens, primary platforms only | None |
| Journey mockups | Every journey | Core journeys | None |
| Open Design binding | Required | Required | None |
| Projection diagram | Required | Required | None |
| Camera diagrams | Every camera | Core cameras that move | None |
| Palette sheet | Required | Required | None |
| Lineup sheet | Every character and entity with a body | Characters and entities in core specs | None |

The table sets the minimum. An artifact beyond it is allowed, and then follows its rules in full. When an artifact is not required and not made, its header field (**Mockup**, **Diagram**, or **Sheet**) reads "None — spec depth \<level\>". When no mockup exists at all, the Mockups topic in `specs/ux/traceability.md` is "N/A — spec depth \<level\>". The same applies to the Diagrams topic in `specs/view/traceability.md` and the Sheets topic in `specs/aesthetics/traceability.md`.

## Other effects

- **Scenarios** (`specs/design/scenarios/`): at full, the scenario rules apply unchanged. At small, at least one scenario walks the core loop to an end condition, and more are optional. At prototype, the Scenarios topic may be N/A citing spec depth.
- **Quality** (`specs/definition/quality.md`): at prototype, an N/A reason may cite spec depth for every category except performance.
- **Asset kinds** (`specs/assets/kinds/`): at prototype, Budgets may read "None — spec depth prototype". Coverage, recipes, and checks apply at every depth.

## Changing depth

Raising the depth raises the minimums for every existing spec. Backfill stories and artifacts before the next spec review passes. Lowering it removes nothing by itself. Keep existing stories and artifacts current, or delete them along with their index entries.
