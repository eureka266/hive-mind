# Changelog

All notable changes to HiveMind are documented here. This project follows
[Semantic Versioning](https://semver.org/).

## [0.1.0] - 2026-06-17

First public release.

### Added
- **Product knowledge base as a second brain.** Turn product discussions into a
  structured, version-controlled Git knowledge repo (`facts/`, `decisions/`,
  `workflows/`, `features/`, `memory/`).
- **`/prd` namespace** — discuss requirements, then extract facts, decisions, and
  interaction definitions; sub-usages for `research`, `review`, `docs`, `prompt`,
  `competitor`, `assets`, and `clean`.
- **`/prd review`** — review a PRD from a product-lead perspective.
- **`/dev`** — generate engineering handoff assets (implementation plan, API/data
  contracts, test specs, dev checklist) plus an engineering challenge mode.
- **`/ui-draft`** — generate clickable single-file HTML prototypes from interaction
  definitions, with optional Figma sync.
- **`/gtm`** — generate GTM / content-marketing / sales-enablement material from the
  knowledge base.
- **`/email`** — generate ready-to-send HTML emails from fixed templates (content and
  HTML only; never sends mail).
- **Proactive memory** — load a feature workspace on start and run a Memory Review gate
  before finishing to capture reusable rules.
- **Two variants** — native Claude Code slash commands (with auto-update hook and team
  setup) and a generic Codex / SKILL-format skill.
- Install via `npx skills add eureka266/hive-mind`, or clone + `install.sh` for the
  team setup.
