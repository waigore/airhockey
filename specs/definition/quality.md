# Quality Expectations

Authoring rules: [`.agents/specs/rules/quality.md`](../../.agents/specs/rules/quality.md).

## Categories

| Category | Applicability | Target | Platforms | How checked |
|----------|---------------|--------|-----------|-------------|
| Performance | Applies | 60 fps during play; no multi-frame hitches | Desktop, Mobile | Frame-time sampling in a match on each primary platform |
| Load time / latency | Applies | Cold start to playable under 3 s | Desktop, Mobile | Timed cold launch into first match-ready state |
| Reliability | Applies | Crash-free play for a 30-minute session | Desktop, Mobile | Continuous play session without crash or forced quit |
| Observability | Applies | Local severity-tagged logs for errors and key play events | Desktop, Mobile | Confirm logs appear with severity for a forced error and a goal |
| Save durability | N/A — no persistent progress (rematch only) | — | — | — |
| Accessibility | Applies | Neon channels stay distinguishable; UI text readable on both platforms | Desktop, Mobile | Side-by-side check of table/UI contrast and text size on each platform |
| Localization | N/A — English only | — | — | — |
