# Authoring rules: presentation

Read this before editing `specs/ux/presentation.md`, `specs/ux/mockups/README.md`, or a surfaces file split from the presentation spec. Do not copy these rules into the spec.

Also read [ux.md](ux.md). Screen HTML follows [screen-mockup.md](screen-mockup.md). Journey HTML follows [journey-mockup.md](journey-mockup.md).

How HTML mockups are produced and bound to a visual system.

Mockups are views of the UX, for reading the flow. They are not the implementation. They add no behavior the specs omit. When a mockup and a spec disagree, the spec wins and the mockup changes. HTML under `specs/ux/mockups/` is exempt from the 500-word limit.

Which screens and journeys get a mockup follows spec depth, per [depth.md](../depth.md). When spec depth requires no mockup, write "None — spec depth \<level\>" under Binding and Surfaces, and skip the rest of this file.

## Binding

Record the [Open Design](https://github.com/nexu-io/open-design) choices for this game in `presentation.md`. Do not add `.open-design.json` at the repository root. That file would bind every design task in the repo to one artifact. `presentation.md` is the binding. A root `.open-design.json` does not replace it.

- **Design system**: slug and path, for example `linear` / `design-systems/linear`.
- **Content root**: the Open Design clone the open-design skill reads (`OPEN_DESIGN_ROOT`, or `~/.open-design-skill/repo` when unset). Install or refresh that tree (and the skill wrapper) with `ensure-open-design-skill-setup` — [`docs/open-design-skill-setup.md`](../../../../docs/open-design-skill-setup.md).
- **Aesthetics fit**: how the bound design system realizes `specs/aesthetics/ui-style.md`: which `UIS` elements it meets as is, and which tokens are overridden to meet the rest (colors to `UIS.C` roles, type to `UIS.T`, corners and borders to `UIS.F`). Choose a design system whose overrides stay small. When the two disagree, the aesthetics win.

## Surfaces

| Surface | What to record |
|---------|----------------|
| Meta UI: menus, onboarding, settings, results | The UI keys. Template: `mobile-app` when the primary platform is a phone or tablet; `web-prototype` when it is a desktop or web window. Craft: `state-coverage`, accessibility. |
| Play UI: HUD and in-play overlays | The UI keys. Template: `mockups/screens/_template.html`, using this design system's color, typography, and components. Craft: `state-coverage`, accessibility. |

When the definition lists both a phone platform and a desktop platform, give each platform its own row and its own mockup, named `<screen>.<platform>.html`. At small spec depth, only primary platforms get a row and a mockup.

## Producing a mockup

1. Copy `mockups/screens/_template.html` or `mockups/journeys/_template.html` to the path named in the screen or journey spec.
2. Follow the open-design skill. Read the bound `DESIGN.md`, the chosen template's `SKILL.md` when the surface uses one, and the craft files named in the surfaces table plus any that template requires.
3. Write the filled HTML at the spec's path. The seed's instruction to write `index.html` at the project root does not apply.
4. Keep `data-screen`, `data-region`, `data-control`, and `data-state`, so journey links and stories still match the spec.
5. Link an exception branch to that screen's anchor: `#ex-loading` for `EX.loading`.
6. Use the copy and controls from the screen spec.

## Accessibility and localization

When accessibility Applies in `specs/definition/quality.md`, mockups meet that target, including contrast, text scale, and a path that stays understandable with one sensory channel removed. When localization Applies, mockup strings match the screen's copy table.

## Splitting

If `presentation.md` passes 500 words, move the surfaces table to `presentation/surfaces.md`. Leave a summary and a link, and update `ux.md`.
