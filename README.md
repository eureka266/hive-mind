# HiveMind 🧠

> 团队的第二大脑。每次产品讨论，都自动变成长久、可搜索、可复用的结构化知识。
> A second brain for your team — every product discussion becomes durable, structured, reusable knowledge.

**[中文](#中文) · [English](#english)**

[![install](https://img.shields.io/badge/install-npx%20skills%20add-000000)](https://github.com/eureka266/hive-mind)
[![Stars](https://img.shields.io/github/stars/eureka266/hive-mind?style=flat)](https://github.com/eureka266/hive-mind/stargazers)
[![Forks](https://img.shields.io/github/forks/eureka266/hive-mind?style=flat)](https://github.com/eureka266/hive-mind/network/members)
[![Last commit](https://img.shields.io/github/last-commit/eureka266/hive-mind)](https://github.com/eureka266/hive-mind/commits)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)

```bash
npx skills add eureka266/hive-mind
```

---

<a name="中文"></a>
## 中文

### 你是不是也这样

产品会开了两小时，结论留在几个人的脑子里。三周后再讨论同一个功能，没人记得当时为什么砍了那个方案；新人入职，散落在群聊、文档、口头约定里的「为什么」根本拼不起来。**讨论是即时的，知识却在不断流失。**

### HiveMind 怎么解决

HiveMind 是一个产品管理 AI 副驾，它把每一次产品讨论**沉淀成一个结构化、版本化、团队共享的知识库**——并直接基于这个知识库产出 PRD、可点击原型和研发交接物。

你只管正常聊需求，它在背后把讨论拆解成可追溯的知识：

- **facts/** — 产品事实、边界、限制（「最多支持 10,000 行 CSV」）
- **decisions/** — 设计决策和被否掉的方案，连同理由（三周后还查得到「为什么」）
- **workflows/** — 交互定义（状态机、组件、校验规则）
- **features/[feature]/** — 每个功能的 PRD、原型、研发资产、会话记忆，集中一处
- **memory/** — 跨功能可复用的规则、用户研究、会话日志

写文件前永远先给你审核，你批准了才落盘、才提交 Git。知识库是你自己的私有 Git 仓库——团队 pull 一下，就共享同一个大脑。

### 你会得到什么

一句「`/prd csv-import`」开始讨论，结束时你会拿到：

```
✅ 已提交并推送

  ✓ facts/your-product.md              （更新）
  ✓ workflows/csv-import.yaml           （新建）
  ✓ decisions/decision-20260617-csv-import.md
  ✓ features/csv-import/prd.md          （新建）
  ✓ features/csv-import/workflow.yaml   （新建）

下一步: /ui-draft csv-import   → 生成可点击 HTML 原型
```

### 安装

```bash
npx skills add eureka266/hive-mind
```

装好后直接对你的 AI 说话即可——HiveMind 同时支持 **Claude Code** 和 **Codex**。

> 想要原生 `/prd`、`/dev`、`/ui-draft` 等斜杠命令、自动更新和团队多人协作？见 [团队版安装](#团队版安装可选)。

### 怎么用（你会真实说出的话）

```
/prd csv-import                       # 讨论一个新功能，沉淀成 PRD + 知识
/prd review csv-import                # 用产品负责人视角审查 PRD
/prd research onboarding              # 整理用户访谈，标出 gap 和冲突
/dev csv-import                       # 生成研发交接物：方案、接口、测试、检查清单
/ui-draft csv-import                  # 从交互定义生成可点击 HTML 原型
/gtm 写一篇产品核心优势的文章          # 基于知识库产出 GTM 内容
/email 写一封产品更新邮件             # 套固定模板生成可发送 HTML 邮件
```

也支持自然语言：「讨论一下批量导入这个功能」「把刚才的会议纪要提取成决策」。

### 前置条件

- [ ] **Node.js**（含 `npx`）—— 用于安装：`node -v`
- [ ] **Git** 2.20+ —— 知识库基于 Git：`git --version`
- [ ] **Claude Code 或 Codex** —— 任一即可
- [ ] （可选）**Figma MCP** —— 需要把原型同步到 Figma 时

### 知识库放哪

默认在本地 `~/team-knowledge` 维护，不连任何远端，开箱即用。想团队协作时，把它指向你自己的私有 Git 仓库即可：

```bash
KNOWLEDGE_REPO=your-org/team-knowledge bash ~/hive-mind/claude-code/install.sh
```

知识库完全是你自己的——HiveMind 不持有、不上传你的任何数据。

### 团队版安装（可选）

想要原生斜杠命令、PreToolUse 自动更新 hook、多人协作权限模型？clone 仓库跑安装脚本：

```bash
git clone https://github.com/eureka266/hive-mind.git ~/hive-mind
bash ~/hive-mind/claude-code/install.sh      # Claude Code（终端 & VS Code 通用）
# 或
bash ~/hive-mind/codex/install.sh            # Codex
```

详见 [`claude-code/README.md`](./claude-code/README.md)、[`codex/README.md`](./codex/README.md) 和 [`claude-code/ENTERPRISE_SETUP.md`](./claude-code/ENTERPRISE_SETUP.md)。

### 常见问题

| 问题 | 解决 |
|------|------|
| `npx skills add` 找不到 skill | 确认 Node/npx 已安装（`npx -v`），网络可访问 GitHub，命令为 `npx skills add eureka266/hive-mind` |
| 命令不生效 / 没有 `/prd` | `npx skills` 装的是通用 skill，靠自然语言触发；要原生斜杠命令请用[团队版安装](#团队版安装可选)并重开会话 |
| 推送知识库失败（权限错误） | 确认你对知识库远端仓库有写权限（个人仓库或团队组织授权）；或先不设 `KNOWLEDGE_REPO`，纯本地使用 |
| 草稿/讨论中断丢失 | 重新运行 `/prd [feature]`，HiveMind 会自动检测并提示恢复 |
| HTML 原型怎么看 | Claude Code 用 `open <知识库>/features/[feature]/prototype.html`；VS Code 可用 Live Preview 插件 |

### 安全与边界

- HiveMind 只读写**你指定的**本地知识库目录和 Git 仓库；不上传数据到任何第三方。
- 写文件、提交、推送前都会先让你审核确认。
- `/email` 只生成内容和 HTML，**不发送邮件**、不读取你的邮箱凭证或 `.env`。

---

<a name="english"></a>
## English

### The problem

A two-hour product meeting ends, and the conclusions live in a few people's heads. Three weeks later you revisit the same feature and nobody remembers *why* you cut that approach. A new hire can't reassemble the "why" from scattered chat threads and verbal agreements. **Discussions are real-time; the knowledge keeps leaking away.**

### What HiveMind does

HiveMind is a product-management AI copilot that turns every product discussion into a **structured, version-controlled, team-shared knowledge base** — and generates PRDs, clickable prototypes, and engineering handoff assets straight from it.

You just talk through requirements; it quietly breaks the discussion into traceable knowledge:

- **facts/** — product facts, limits, constraints
- **decisions/** — design decisions *and rejected alternatives, with rationale*
- **workflows/** — interaction definitions (state machines, components, validation)
- **features/[feature]/** — each feature's PRD, prototype, dev assets, and session memory in one place
- **memory/** — reusable cross-feature rules, user research, session journals

It always shows extracted content for your approval before writing anything, and only commits to Git after you confirm. The knowledge base is your own private Git repo — your team pulls it and shares one brain.

### Install

```bash
npx skills add eureka266/hive-mind
```

Works with both **Claude Code** and **Codex**. Want native `/prd`, `/dev`, `/ui-draft` slash commands, auto-update, and team collaboration? See the team install in the Chinese section above.

### How you'll use it

```
/prd csv-import              # discuss a feature → PRD + knowledge
/prd review csv-import       # review a PRD as a product lead
/dev csv-import              # generate dev handoff: plan, contracts, tests, checklist
/ui-draft csv-import         # generate a clickable HTML prototype
/gtm write a positioning article from the knowledge base
/email draft a product-update email as ready-to-send HTML
```

Natural language works too: "let's discuss the bulk-import feature", "extract decisions from these meeting notes".

### Prerequisites

- [ ] **Node.js** (with `npx`) — `node -v`
- [ ] **Git** 2.20+ — `git --version`
- [ ] **Claude Code or Codex** — either one
- [ ] *(optional)* **Figma MCP** — only to sync prototypes to Figma

### Notes & boundaries

- HiveMind only reads/writes the local knowledge directory and Git repo **you point it at**; it uploads nothing to third parties.
- It asks for your approval before writing files, committing, or pushing.
- `/email` only generates content and HTML — it never sends mail or reads your credentials.

---

Built for [Claude Code](https://claude.com/claude-code) and Codex. Licensed under [MIT](./LICENSE).
