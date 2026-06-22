<div align="center">

<img src="./docs/assets/hivemind-title.png" alt="HiveMind" width="320" />

<p style="font-size: 14px; color: #666;">
团队的第二大脑。每次产品讨论，都自动变成长久、可追溯、可复用的结构化知识。
</p>

<p style="font-size: 14px; color: #666;">
产品会开了两小时，结论留在几个人的脑子里。三周后再讨论同一个功能，没人记得当时为什么砍了那个方案；新人入职，散落在群聊、文档、口头约定里的「为什么」根本拼不起来。
</p>

<p style="font-size: 14px; color: #666;">
<strong>讨论是即时的，知识却在不断流失。</strong>HiveMind 把每一次产品讨论沉淀成一个结构化、版本化、团队共享的 Git 知识库——并直接基于它产出 PRD、可点击原型和研发交接物。
</p>

[English](./README.md) • [GitHub](https://github.com/eureka266/hive-mind) • [使用案例](./docs/use-cases.zh.md)

[![install](https://img.shields.io/badge/install-npx%20skills%20add-000000?style=flat-square)](https://github.com/eureka266/hive-mind)
[![GitHub Stars](https://img.shields.io/github/stars/eureka266/hive-mind?style=flat-square&color=eab308)](https://github.com/eureka266/hive-mind/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/eureka266/hive-mind?style=flat-square&color=3b82f6)](https://github.com/eureka266/hive-mind/network/members)
[![Last Commit](https://img.shields.io/github/last-commit/eureka266/hive-mind?style=flat-square&color=6b7280)](https://github.com/eureka266/hive-mind/commits)
[![License: MIT](https://img.shields.io/badge/License-MIT-green?style=flat-square)](./LICENSE)

</div>

---

## 核心能力

| 能力 | 效果 |
|------|------|
| **讨论自动提取** | `/prd` 聊需求，AI 自动拆解成 facts、decisions、workflows。不用手动写 spec。 |
| **结构化知识库** | 所有产出存进 Git repo（facts/、decisions/、features/、memory/ 等），版本化、可追溯、全团队共享。 |
| **主动记忆** | 讨论前自动加载相关规则和决策，讨论后主动提示"这条规则值得沉淀吗"。参考 [Trellis](https://github.com/mindfold-ai/trellis)。 |
| **完整工作流** | 从讨论到 PRD、审查、原型、研发交接、GTM 内容、邮件——一条龙支持。 |
| **团队共享** | 知识库是你自己的私有 Git repo。团队 clone 一下，所有历史决策和规则都在，新人快速上手。 |

## 快速开始

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

## 各角色怎么用

**产品经理**
```
/prd 批量导入功能                      # 讨论需求，AI 自动提取事实、决策、交互定义
/prd review 支付流程                   # PRD 评审：挑战范围、前提假设、「六个月后会不会后悔」
/prd research 三月用户流失原因分析      # 综合埋点数据、支持工单、访谈记录，找出流失根因
/prd docs 导出功能                     # 从 PRD 生成面向用户的帮助文档
/prd competitor 竞品名称               # 结构化竞品分析，保存到知识库
```

**研发工程师**
```
/dev 批量导入功能                      # 生成研发交接资产：实现方案、接口契约、测试规格、开发 checklist
/dev 批量导入功能 challenge            # 对抗性评审：挖掘边界情况和缺失的错误处理
```

**设计师**
```
/ui-draft 支付流程优化                 # 把交互讨论快速变成可点击的单文件 HTML 原型
/ui-draft 批量导入功能 --figma         # 生成原型并同步到 Figma
```

**市场 / 增长**
```
/gtm 我们相比竞品的核心优势            # 生成定位文档、销售话术、产品一页纸
/email 五月产品更新                    # 起草产品更新邮件，输出可直接发送的 HTML
/email 免费用户升级引导                # 触发式邮件：配额预警、升级引导文案
```

也支持自然语言：「讨论一下批量导入这个功能」「把刚才的会议纪要提取成决策」「从知识库写一篇产品博客」。

## 沉淀几个月后，知识库长什么样

HiveMind 的每条指令都会往一个结构化 Git 仓库里写内容。以下是一个产品团队持续使用几个月后，知识库的真实形态：

```
team-knowledge/
│
├── facts/                           # 产品事实权威来源（人工维护）
│   ├── your-product.md              #   功能边界、限制、已确认的行为
│   ├── glossary.md                  #   共享术语表——防止命名混乱
│   ├── guardrails.md                #   AI 绝不能声称的内容（未上线功能等）
│   ├── customer-profiles.md         #   目标用户画像和 ICP 定义
│   └── internal/                    #   内部实现细节（不用于对外内容）
│
├── features/                        # 每个需求一个 workspace——所有上下文集中在一处
│   ├── bulk-import/
│   │   ├── README.md                #   入口，链接所有产物
│   │   ├── prd.md                   #   /prd → 完整 PRD，含事实、范围、待确认问题
│   │   ├── workflow.yaml            #   /prd → 状态机、组件、校验规则
│   │   ├── bulk-import-prototype.html  # /ui-draft → 可点击单文件原型
│   │   ├── dev-assets/              #   /dev → 实现方案、接口契约、测试规格、开发 checklist
│   │   ├── memory.md                #   会话摘要 + 候选沉淀规则
│   │   ├── open-questions.md        #   等待 PM / 研发 / 设计确认的问题
│   │   └── handoff-status.md        #   当前状态：draft | pending | ready-to-dev | shipped
│   ├── pricing-v3/
│   │   ├── prd.md
│   │   ├── sub-prds/                #   复杂需求按模块拆子 PRD
│   │   │   ├── pricing-page.md
│   │   │   ├── checkout.md
│   │   │   ├── billing.md
│   │   │   ├── quota-enforcement.md
│   │   │   ├── migration.md
│   │   │   └── email-triggers.md
│   │   └── prototypes/
│   └── monitor-upsell/
│       ├── prd.md
│       ├── workflow.yaml
│       └── monitor-upsell-prototype.html
│
├── decisions/                       # /prd 会话结束后自动生成
│   ├── decision-20260617-bulk-import-limits.md     # 决定了什么 + 原因 + 假设条件
│   ├── decision-20260423-monitor-upsell-layers.md  # 被否掉的方案及理由
│   └── decision-20260521-pricing-terminology.md    # 命名选择、定义锁定
│
├── memory/                          # 主动记忆——从会话 Memory Review Gate 中晋升
│   ├── rules/
│   │   ├── pm-process.md            #   跨功能 PM 流程规则
│   │   ├── product-facts-pricing.md #   定价策略规则，供未来 PRD 自动加载
│   │   └── rag-kb-authoring.md      #   AI 助手知识库的撰写规范
│   ├── research/
│   │   └── churn-new-users-march.md # /prd research → 假设排名 + 证据来源
│   └── journal/                     # 重要知识库变更的时间线记录
│
├── approved-prds/                   # 已批准的 PRD（权威引用来源）
│   ├── [20260410]-pricing-v3/
│   └── [20260303]-bulk-import/
│
├── drafts/                          # 仍在讨论中的 PRD 草稿
├── pending/                         # 暂停、阻塞或等待输入的需求
├── archive/                         # 已放弃或被替代——永不删除，只移动
│
├── assets/
│   └── emails/                      # /email → 每次邮件任务一个文件夹
│       ├── 2026-05-25-product-update-may/
│       │   ├── brief.md             #   邮件 brief 和确认记录
│       │   ├── content.md           #   已审核的正文
│       │   └── email.html           #   可直接发送的 HTML
│       └── 2026-06-02-quota-exhausted-nudge/
│           ├── content.md
│           └── email.html
│
├── ai-kb/                           # /prd lumi → 嵌入式 AI 助手的 RAG 知识库
│   ├── user_manual/
│   │   ├── onboarding.md            #   新用户最需要了解的 4 件事
│   │   ├── feature-guide.md         #   各功能的分步使用指引
│   │   ├── data-export-guide.md     #   导出字段和格式说明
│   │   └── notification-channels.md
│   ├── pricing/
│   │   ├── plans-and-billing.md     #   当前套餐、配额、账单 FAQ
│   │   └── payment-methods.md
│   ├── faq/
│   │   ├── product-qa.md            #   从真实支持工单提取的 40+ 条 Q&A
│   │   └── presales-guidance.md     #   售前 FAQ
│   └── api_doc/
│       ├── reference.md             #   REST / Webhook / 鉴权 / 速率限制
│       └── error-messages.md
│
├── competitors/                     # /prd competitor → 结构化竞品调研
│   ├── competitor-a.md
│   └── competitor-b.md
│
└── scripts/                         # 自动化脚本（配额表生成、原型刷新等）
```

这个仓库完全属于你——HiveMind 负责写入，不会远程读取或上传任何内容。团队 clone 下来；新人读 `facts/` 和 `decisions/` 就能快速了解产品背景，不需要专门的交接会议。

## 讨论一次会发生什么

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

## 知识库放哪

默认在本地 `~/team-knowledge` 维护，不连任何远端，开箱即用。想团队协作时，把它指向你自己的私有 Git 仓库即可：

```bash
KNOWLEDGE_REPO=your-org/team-knowledge bash ~/hive-mind/claude-code/install.sh
```

知识库完全是你自己的——HiveMind 不持有、不上传你的任何数据。

## 团队版安装（可选）

想要原生斜杠命令、PreToolUse 自动更新 hook、多人协作权限模型？clone 仓库跑安装脚本：

```bash
git clone https://github.com/eureka266/hive-mind.git ~/hive-mind
bash ~/hive-mind/claude-code/install.sh      # Claude Code（终端 & VS Code 通用）
# 或
bash ~/hive-mind/codex/install.sh            # Codex
```

详见 [`claude-code/README.md`](./claude-code/README.md)、[`codex/README.md`](./codex/README.md) 和 [`claude-code/ENTERPRISE_SETUP.md`](./claude-code/ENTERPRISE_SETUP.md)。

## 常见问题

| 问题 | 解决 |
|------|------|
| `npx skills add` 找不到 skill | 确认 Node/npx 已安装（`npx -v`），网络可访问 GitHub，命令为 `npx skills add eureka266/hive-mind` |
| 命令不生效 / 没有 `/prd` | `npx skills` 装的是通用 skill，靠自然语言触发；要原生斜杠命令请用[团队版安装](#团队版安装可选)并重开会话 |
| 推送知识库失败（权限错误） | 确认你对知识库远端仓库有写权限（个人仓库或团队组织授权）；或先不设 `KNOWLEDGE_REPO`，纯本地使用 |
| 草稿/讨论中断丢失 | 重新运行 `/prd [feature]`，HiveMind 会自动检测并提示恢复 |
| HTML 原型怎么看 | Claude Code 用 `open <知识库>/features/[feature]/prototype.html`；VS Code 可用 Live Preview 插件 |

## 致谢

**主动记忆机制**参考了 [Trellis](https://github.com/mindfold-ai/Trellis/tree/main) 的 spec → task workspace → journal → finish 循环：结构化上下文在每次会话开始时自动注入，新发现的规律在会话结束后被提升回持久规则库。HiveMind 把这套模式映射到 PM 的产品管理工作流：

- **会话开始** — 自动加载 `memory/rules/`（可复用的产品规则）和对应的 `features/[feature]/` workspace 作为上下文
- **讨论过程中** — 追踪本次发现的新事实、设计决策和可复用原则
- **Memory Review Gate（结束前）** — 向 PM 展示候选规则，PM 批准前什么都不写入
- **批准后的规则** — 保存到 `memory/rules/`，之后对这个产品的每次会话都会自动加载

效果：每次 `/prd` 都比上一次更了解你的产品约束和决策背景，PM 不需要反复重申同样的前提。

**追问逻辑**——每次只问一个问题、先加载知识库再追问、拒绝模糊回答、不轻易放过没答清楚的问题——参考了 [gstack](https://github.com/garrytan/gstack) 的 `/office-hours`。`/prd review` 的逻辑参考了 gstack 的 `/plan-ceo-review`：前提挑战、范围风险、以及"六个月后你会不会后悔"式的反向追问，用在产品决策评审上。感谢 [@garrytan](https://github.com/garrytan)。

## 安全与边界

- HiveMind 只读写**你指定的**本地知识库目录和 Git 仓库；不上传数据到任何第三方。
- 写文件、提交、推送前都会先让你审核确认。
- `/email` 只生成内容和 HTML，**不发送邮件**、不读取你的邮箱凭证或 `.env`。

---

基于 [Claude Code](https://claude.com/claude-code) 和 Codex 开发。遵循 [MIT](./LICENSE) 协议。
