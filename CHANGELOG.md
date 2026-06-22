# Changelog

All notable changes to HiveMind are documented here. This project follows
[Semantic Versioning](https://semver.org/).

## [0.1.1] - 2026-06-22

### Added

- **KB health check (Phase 0)** — every command (`/prd`, `/dev`, `/ui-draft`, `/gtm`, `/email`) now checks for a valid knowledge base before doing anything. If `~/team-knowledge` is missing or not a git repo, it pauses and launches the setup wizard automatically. After the wizard completes, the original command resumes — no need to re-type it.
- **`/kb-setup` wizard** — interactive first-run guide covering three paths: clone an existing team GitHub repo, create a new repo via `gh` CLI (with fallback instructions if `gh` is not installed), or local-only `git init` mode. Auto-creates the full directory structure (`facts/`, `decisions/`, `features/`, `memory/`, etc.) and pushes an initial commit.
- **Silent structure repair** — if a KB exists but is missing required subdirectories, they are created automatically without interrupting the workflow.
- **Remote-connection nudge** — local-only KBs get a one-time, non-blocking prompt suggesting GitHub connection for team sharing. Shown once, then silent.
- **Automated tests** (`claude-code/scripts/test-kb-setup.sh`) — 8 scenarios, 14 assertions covering: missing directory, non-git directory, valid repo, incomplete structure detection, auto-repair, healthy KB, GitHub remote detection, and `KNOWLEDGE_DIR` env var override.

---

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
