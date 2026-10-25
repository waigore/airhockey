# Authoring rules: quality

Read this before editing `specs/definition/quality.md` or a category split out of it. Do not copy these rules into the spec.

Also read [definition.md](definition.md). Stay consistent with `specs/vision.md` and with the platforms and constraints in the definition.

Record observable outcomes. Architecture, engines, data formats, and APIs belong in their own specs.

Replace every `<!-- fill in -->`.

## Categories

Each category is **Applies** or **N/A — reason**. An N/A reason cites the vision or the supported platforms. At prototype spec depth, a category other than performance may cite spec depth instead, per [depth.md](depth.md). An Applies row has a measurable target, the platforms it covers, and how it is checked. Those platforms match the definition's supported-platforms table. An N/A row uses "—" for target, platforms, and how checked. Add a row when one category has more than one target. Rows for the same category do not contradict each other, the constraints, or the vision. A target set or limited by an architecture decision cites its ID in the target, such as `(ADR-0003)`.

These seven categories are always present:

- **Performance**: frame rate or frame time during play, including a bound on hitches.
- **Load time / latency**: time until playable, stage or mode transitions, and any response delay outside the frame budget.
- **Reliability**: crash-free play for a stated length, and where play resumes after a failure.
- **Observability**: what must be visible about runtime behavior (logs, errors or crashes, timing or profiling signals, and optional telemetry), at a stated fidelity, and how that visibility is verified. The target scales with the project: from local severity-tagged logs to remote telemetry and detailed timing. Tools, formats, and sinks belong in ADRs.
- **Save durability**: committed progress survives quit, crash, and upgrades in a stated version range. A failed write leaves the previous commit intact.
- **Accessibility**: who can perceive and operate play. Distinguishable channels, adjustable timing or assists, text and audio scale.
- **Localization**: which locales ship, which player-facing content is translated, and a bound on text growth.

## Where an Applies category is carried out

Performance, load time, reliability, and observability stay in this file.

- Accessibility and localization: state the player-facing consequences in `specs/design/experience.md`.
- A rule-changing assist or timing option: a row in `specs/design/configuration.md`.
- Save durability: what is committed, when it becomes permanent, and where play resumes, in `specs/design/progression.md`.
- How the interface presents accessibility, localization, and save failure: `specs/ux/ux.md` and the UX rules that cover those topics.
- Motion comfort and non-audio equivalents of positional sound: `specs/view/perception.md` and `specs/view/audio.md`.

## Splitting

If this file passes 500 words, move the longest category to `specs/definition/quality/<category>.md`. Leave a one-line summary and a link in the table, and add the new file to `specs/README.md`.
