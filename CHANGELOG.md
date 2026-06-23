# Changelog

All notable changes to HiveMind are documented here. This project follows
[Semantic Versioning](https://semver.org/).

---

## [0.0.18] - 2026-06-22

### Added

#### 核心功能：`/video` 脚本优先工作流

- **产品视频、教程和动图生成指令**，采用**脚本确认门**设计，灵感来自 Trellis 项目的 token 节省策略：
  - **Phase 1: 脚本生成** — 读取 `workflows/` + PRD，生成纯文本脚本（轻量 ~1300 tokens）
  - **[确认门]** — 用户审视脚本方向，防止错误代码生成（核心创新）
  - **Phase 2: 脚本修订** — 可选，用户可微调脚本（仅改动部分，~600 tokens）
  - **Phase 3: 代码生成** — 脚本确认后注入品牌信息，生成完整 Remotion TypeScript（~2200 tokens，一次性）
  - **Phase 4: 本地渲染** — 用户本地 `npm install + render`，视频沉淀到 `assets/videos/`

- **子命令**：
  - `/video [主题]` — 标准产品演示 (30s)
  - `/video --tutorial [功能]` — 教程视频 (60s+)
  - `/video --comparison` — 竞品对比动画
  - `/video --workflow` — 流程讲解动画
  - `/video --help` — 快速启动指南

- **Token 效率**：脚本与代码分离 + 确认门防止重复生成
  - 单次成功：3500-4100 tokens
  - 迭代场景：节省 ~30% token（相比直接生成）
  - 失败场景：节省 >50% token（防止"错误方向代码"重做）

- **品牌自动化**：自动从 `facts/product.md` 读取品牌色、logo、产品信息；生成代码自动注入 `BRAND` 常量

- **知识库集成**：
  - 脚本基于 `workflows/` 和 PRD 生成（有产品上下文）
  - 脚本保存到 `features/[feature]/script.md`（支持跨 session 续做）
  - 视频沉淀到 `assets/videos/[YYYY-MM-DD-slug]/`（包含视频、脚本、源代码）
  - 自动更新 `assets-index.md`

#### 文档完整性

- **Claude Code Skill 文档**：
  - `claude-code/skills/product-video.md` (19KB) — 完整 4 阶段工作流 + ASCII 流程图 + Phase 详解 + Token 消耗分析
  - `claude-code/skills/product-video-quickstart.md` (11KB) — 10 分钟快速启动指南（面向内容营销团队）
  - `claude-code/skills/README.md` (3.5KB) — Skill 导航中心（新增）

- **Codex / 通用文档**：
  - `codex/references/product-video-workflow.md` (16KB) — Agent 实现参考（完整技术细节）

- **架构与设计文档**：
  - `VIDEO_WORKFLOW_ARCHITECTURE.md` (8.5KB) — 设计文档：分离关注、上下文隔离、确认门、脚本持久化的 5 个核心原则
  - `VIDEO_WORKFLOW_MCP_ANALYSIS.md` (7.3KB) — MCP 可行性分析：3 方案对比（MCP 直接调用 vs 脚本优先 vs 混合）
  - `VIDEO_WORKFLOW_SUMMARY.md` (7.1KB) — 改造总结与文件导航

#### README 补充

- **claude-code/README.md**：
  - 新增完整的 `/video` 工作流说明（4 Phase ASCII 流程图）
  - 新增版本历史说明（v0.0.18）
  - 补充目录结构中的 `/video` 相关文件
  - 更新 Skill 命令计数（9 → 11）

- **codex/SKILL.md**：
  - 更新 description 添加视频生成能力
  - 新增 `/video` Intent Routing（指向 `references/product-video-workflow.md`）
  - 新增 `assets/videos/` 路径定义到 Artifact Map
  - 新增 `features/[feature]/script.md` 定义到 Artifact Map

#### 可行性研究完成

- **MCP 分析结论**：
  - 发现 remotion-media-mcp（Veo 3.1）但限制严格：8 秒 + 品牌难定制
  - 脚本优先方案优势：灵活时长 + 品质完整 + Token 高效 + 知识库集成
  - 建议：保持脚本优先为主方案，中期可增加 `/video --fast` 选项作为快速渲染补充

### Changed

- Updated version from 0.0.17 to 0.0.18 in `package.yaml`
- Enhanced README.md documentation structure for `/video` visibility

---

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
- Install via `npx skills add eureka266/HiveMind`, or clone + `install.sh` for the
  team setup.
