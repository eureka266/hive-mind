<div align="center">

```
   ╔═══════════╗
   ║  HiveMind ║
   ╚═══════════╝
```

**团队的第二大脑。** 每次产品讨论，都自动变成长久、可追溯、可复用的结构化知识。

产品会开了两小时，结论留在几个人的脑子里。三周后再讨论同一个功能，没人记得当时为什么砍了那个方案；新人入职，散落在群聊、文档、口头约定里的「为什么」根本拼不起来。**讨论是即时的，知识却在不断流失。**

HiveMind 把每一次产品讨论沉淀成一个结构化、版本化、团队共享的 Git 知识库——并直接基于它产出 PRD、可点击原型和研发交接物。写文件前永远先给你审核，你批准了才落盘。知识库是你自己的私有仓库，团队 pull 一下就共享同一个大脑。

[中文](#中文) • [English](#english) • [GitHub](https://github.com/eureka266/hive-mind)

[![install](https://img.shields.io/badge/install-npx%20skills%20add-000000?style=flat-square)](https://github.com/eureka266/hive-mind)
[![GitHub Stars](https://img.shields.io/github/stars/eureka266/hive-mind?style=flat-square&color=eab308)](https://github.com/eureka266/hive-mind/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/eureka266/hive-mind?style=flat-square&color=3b82f6)](https://github.com/eureka266/hive-mind/network/members)
[![Last Commit](https://img.shields.io/github/last-commit/eureka266/hive-mind?style=flat-square&color=6b7280)](https://github.com/eureka266/hive-mind/commits)
[![License: MIT](https://img.shields.io/badge/License-MIT-green?style=flat-square)](./LICENSE)

</div>

---

<a name="中文"></a>
## 中文

### 核心能力

| 能力 | 效果 |
|------|------|
| **讨论自动提取** | `/prd` 聊需求，AI 自动拆解成 facts、decisions、workflows。不用手动写 spec。 |
| **结构化知识库** | 所有产出存进 Git repo（facts/、decisions/、features/、memory/ 等），版本化、可追溯、全团队共享。 |
| **主动记忆** | 讨论前自动加载相关规则和决策，讨论后主动提示"这条规则值得沉淀吗"。参考 [Trellis](https://github.com/mindfold-ai/trellis)。 |
| **完整工作流** | 从讨论到 PRD、审查、原型、研发交接、GTM 内容、邮件——一条龙支持。 |
| **团队共享** | 知识库是你自己的私有 Git repo。团队 clone 一下，所有历史决策和规则都在，新人快速上手。 |

### 快速开始

**前置条件**
- [ ] **Node.js**（含 `npx`）—— 用于安装：`node -v`
- [ ] **Git** 2.20+ —— 知识库基于 Git：`git --version`  
- [ ] **Claude Code 或 Codex** —— 任一即可

**安装**
```bash
npx skills add eureka266/hive-mind
```

装好后直接对你的 AI 说话即可。HiveMind 同时支持 **Claude Code** 和 **Codex**。

> 想要原生斜杠命令（`/prd`、`/dev`、`/ui-draft`）、自动更新和团队多人协作？参考 [团队版安装](#团队版安装可选)。

### 怎么用（真实 PM 场景）

```
/prd 批量导入功能                      # 和团队讨论这个需求，自动提取事实和决策
/prd review 批量导入功能               # 发起 PRD 评审，从产品负责人视角逐项把关
/prd research 三月用户流失原因分析      # 结合埋点数据、用户反馈和支持单据，找出流失的关键原因
/dev 批量导入功能                      # 工程评审前准备：方案、接口、测试计划
/ui-draft 支付流程优化                 # 把交互讨论快速变成可点击原型，给设计看
/gtm 我们相比竞品的核心优势            # 自动整理产品优势，生成销售话术和营销素材
/email 付费用户续费邮件                # 套模板生成产品更新通知，一键发送
```

也支持自然语言：「讨论一下批量导入这个功能」「把刚才的会议纪要提取成决策」。

### 讨论一次会发生什么

一句「`/prd 批量导入功能`」开始，讨论完毕时你会得到：

```
✅ 已提交并推送

  ✓ facts/your-product.md              （更新）
  ✓ workflows/csv-import.yaml           （新建）
  ✓ decisions/decision-20260617-csv-import.md
  ✓ features/csv-import/prd.md          （新建）
  ✓ features/csv-import/workflow.yaml   （新建）

下一步: /ui-draft 支付流程优化  → 生成可点击 HTML 原型
```

知识库结构：
- **facts/** — 产品事实、边界、限制（「最多支持 10,000 行」）
- **decisions/** — 设计决策和砍掉的方案，连同理由（三周后还查得到「为什么」）
- **workflows/** — 交互定义（状态机、组件、校验）
- **features/[feature]/** — 每个功能的 PRD、原型、研发资产、会话记忆
- **memory/** — 跨功能可复用的规则、用户研究、会话日志

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

### Core Capabilities

| Capability | Effect |
|------------|--------|
| **Auto-extract discussions** | `/prd` chat about needs → AI auto-splits into facts, decisions, workflows. No manual spec writing. |
| **Structured knowledge base** | All outputs land in Git repo (`facts/`, `decisions/`, `features/`, `memory/`, etc.) — versioned, traceable, team-shared. |
| **Proactive memory** | Auto-load related rules and decisions before discussion. Auto-suggest which rules to save after. Inspired by [Trellis](https://github.com/mindfold-ai/trellis). |
| **Complete workflow** | From discussion to PRD, review, prototype, dev handoff, GTM content, email — end-to-end. |
| **Team sharing** | Knowledge base is your own private Git repo. Team clones it, and every decision, rule, and history is there. New hires onboard 3x faster. |

### Quick Start

**Prerequisites**
- [ ] **Node.js** (with `npx`) — to install: `node -v`
- [ ] **Git** 2.20+ — knowledge base uses Git: `git --version`
- [ ] **Claude Code or Codex** — either works

**Install**
```bash
npx skills add eureka266/hive-mind
```

Works with both **Claude Code** and **Codex** right away. Talk naturally and HiveMind listens.

> Want native slash commands (`/prd`, `/dev`, `/ui-draft`), auto-update, and team setup? See [Team Setup](#team-setup-optional) below.

### How you'll use it (real PM scenarios)

```
/prd bulk-import feature              # discuss needs → extract facts and decisions
/prd review bulk-import               # PRD review from a product lead's angle
/prd research why users churn in March # combine analytics, feedback, and support tickets
/dev bulk-import                      # gen engineering handoff (plan, contracts, tests)
/ui-draft payment flow optimization   # turn interaction discussion into clickable prototype
/gtm how we compare to competitors    # generate positioning, sales talk, marketing assets
/email draft product-update email     # template-based, ready-to-send HTML
```

Natural language also works: "let's discuss bulk import", "extract the key decisions from that meeting".

### What happens in one discussion

One `/prd bulk-import` and your team walks away with:

```
✅ Committed and pushed

  ✓ facts/your-product.md              (updated)
  ✓ workflows/csv-import.yaml           (new)
  ✓ decisions/decision-20260617-csv-import.md
  ✓ features/csv-import/prd.md          (new)
  ✓ features/csv-import/workflow.yaml   (new)

Next: /ui-draft payment optimization  → clickable HTML prototype
```

Knowledge base structure:
- **facts/** — product facts, boundaries, limits (e.g., "max 10k rows per import")
- **decisions/** — design decisions and rejected approaches, with rationale (you'll find "why" three weeks later)
- **workflows/** — interaction specs (state machines, components, validation rules)
- **features/[feature]/** — PRD, prototype, dev assets, session memory all in one place
- **memory/** — reusable cross-feature rules, user research, discussion logs

### Where the knowledge base lives

By default, local-only at `~/team-knowledge` (zero setup, works offline). When you're ready to share, point it to your own private Git repo:

```bash
KNOWLEDGE_REPO=your-org/team-knowledge bash ~/hive-mind/claude-code/install.sh
```

Your data stays yours — HiveMind never uploads, stores, or holds anything.

### Team setup (optional)

Want native slash commands, auto-update via hook, and multi-person collaboration? Clone and run:

```bash
git clone https://github.com/eureka266/hive-mind.git ~/hive-mind
bash ~/hive-mind/claude-code/install.sh      # Claude Code (terminal & VS Code)
# or
bash ~/hive-mind/codex/install.sh            # Codex
```

Details: [`claude-code/README.md`](./claude-code/README.md), [`codex/README.md`](./codex/README.md), [`claude-code/ENTERPRISE_SETUP.md`](./claude-code/ENTERPRISE_SETUP.md).

### Troubleshooting

| Problem | Fix |
|---------|-----|
| `npx skills add` not found | Check Node/npx installed (`npx -v`), network can reach GitHub, command is `npx skills add eureka266/hive-mind` |
| No `/prd` command / commands don't work | `npx skills add` installs a generic skill that listens for natural language. For native `/prd` use [Team Setup](#team-setup-optional) and restart your session |
| Push failed (permission denied) | Ensure you can write to the knowledge repo (your own repo or team org grants access); or skip `KNOWLEDGE_REPO` for local-only mode |
| Lost mid-discussion changes | Re-run `/prd [feature]` — HiveMind auto-detects and offers recovery |
| How do I view the HTML prototype? | Claude Code: `open <knowledge-repo>/features/[feature]/prototype.html`; VS Code: use Live Preview extension |

### Safety & scope

- HiveMind reads/writes **only** your specified local knowledge directory and Git repo; uploads to nowhere.
- You approve all file writes, commits, and pushes before they happen.
- `/email` only generates content and HTML — never sends mail, never reads credentials.

---

Built for [Claude Code](https://claude.com/claude-code) and Codex. Licensed under [MIT](./LICENSE).
