# HiveMind — Claude Code 版

> Claude Code 专属安装包。提供 `/prd` 命名空间（需求、research、review、docs、prompt、competitor、assets、clean）、`/dev`、`/ui-draft`、`/gtm`、`/email`、`/video` 和 `/hive-mind-update`，将产品讨论、知识库维护、审查结论、研发准备资产、商业化内容框架、邮件 HTML 资产、产品动图视频和可点击原型转化为可追溯知识资产。
> 支持 **终端 Claude Code** 和 **VS Code Claude Code 插件**，安装步骤完全相同。
>
> **v0.0.18 新增**：`/video` 脚本优先工作流 — 产品视频生成指令（4 阶段 Phase + 确认门），采用 Trellis 灵感的 Token 节省设计。生成脚本→用户确认→代码一次性生成→本地渲染，全程支持品牌自动化和知识库集成。
>
> **v0.0.16 新增**：`/prd` 命名空间统一承载 research、review、docs knowledge、prompt、competitor、assets 和 clean 等 PM 知识库维护模式。
>
> **v0.0.15 新增**：主动记忆机制 — 每个命令启动时自动加载 feature workspace，结束前运行 Memory Review Gate 主动提示沉淀规则。所有 PRD、原型、dev assets 汇聚在 `features/[feature]/`。

---

## 安装（终端 & VS Code 通用）

```bash
# 默认安装到 ~/.hive-mind/
git clone https://github.com/eureka266/hive-mind.git ~/.hive-mind/skill
bash ~/.hive-mind/skill/claude-code/install.sh
```

如果已有本地仓库，可以通过环境变量指定路径：

```bash
SKILL_DIR=~/Work/Project/hive-mind \
KNOWLEDGE_DIR=~/Work/Project/team-knowledge \
bash ~/Work/Project/hive-mind/claude-code/install.sh
```

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `INSTALL_DIR` | `~/.hive-mind` | 安装根目录 |
| `SKILL_DIR` | `$INSTALL_DIR/skill` | Skill 仓库目录 |
| `KNOWLEDGE_DIR` | `$INSTALL_DIR/knowledge` | 知识库目录 |

安装脚本自动检测 SSH/HTTPS 协议、克隆仓库、注册 skill 命令并配置自动更新 hook。
安装完成后自动注册 11 个 skill：`/prd`（包含 research、review、docs、prompt、competitor、assets、clean 子用法）、`/prd-review`（alias）、`/research`（alias）、`/dev`、`/ui-draft`、`/gtm`、`/email`、`/video`、`/hive-mind-update` 和 `/hive-mind`。
Skill 存储在 `~/.claude/skills/`，终端和 VS Code 共享同一份，无需重复安装。

---

## 在 VS Code 中使用

### 前提：安装 Claude Code 插件

在 VS Code 扩展市场搜索 **Claude Code** 并安装，或：

```bash
code --install-extension anthropic.claude-code
```

安装后侧边栏出现 Claude 图标，命令行为与终端版完全相同。

### Skill 命令使用方式

在 VS Code 的 Claude Code 面板输入框中直接输入命令，与终端无区别：

```
/prd batch-screening
/prd research detail-page-optimization 整理这 4 个用户访谈，标出 PRD gap 和冲突
/prd review batch-screening
/prd docs notification channels
/prd prompt pricing advisor
/prd competitor "Competitor A"
/prd assets scan
/prd clean
/dev batch-screening
/ui-draft batch-screening
/ui-draft --figma batch-screening
/gtm 写一篇你的产品相比竞品的核心优势文章
/email 写一封产品更新邮件，中文和英文，生成 HTML 并保存到资产库
/video 制作一个 dashboard 新功能的 30 秒演示动图
/video --tutorial 为"导入数据"功能制作 60 秒教程视频
/hive-mind-update
```

### VS Code 专属优势：HTML 原型内嵌预览

终端版需要用浏览器打开 HTML，VS Code 可以通过 **Live Preview 插件**直接在编辑器侧边栏预览：

**第一步：安装 Live Preview**

```bash
code --install-extension ms-vscode.live-server
```

**第二步：打开原型文件预览**

`/ui-draft` 生成原型后，在 VS Code 文件资源管理器中找到：

```
<知识库目录>/features/[feature]/prototype.html   ← 主路径（v0.0.15 起）
<知识库目录>/prototypes/[feature].html            ← legacy 副本
```

右键 → **Open with Live Preview**，原型在编辑器右侧面板实时展示，无需切换到浏览器。

> 也可以按 `Ctrl+Shift+P`（macOS: `Cmd+Shift+P`）→ 搜索 `Live Preview: Show Preview`

### Figma MCP 在 VS Code 中的配置

Figma MCP 插件跟随 Claude Code 全局配置，VS Code 中自动生效。如未生效：

1. 在 VS Code 的 Claude Code 面板中运行 `/plugins install figma`
2. 按提示完成 Figma 账号授权
3. 运行 `/ui-draft --figma [feature]` 验证是否正常

---

## 5 分钟上手

### 第一步：开始讨论

```
/prd batch-screening
```

系统自动加载知识库已有上下文，显示加载结果后进入讨论模式。

### 第二步：自由讨论

和 AI 正常描述功能需求，不会被打断。支持 30+ 分钟长讨论，中断后重新运行命令可恢复草稿。

```
你: 用户需要上传 CSV，最多 10,000 行地址，
    系统对每个地址做合规检查，结果可以下载...

AI: [参与讨论，提出澄清问题]
```

### 第三步：触发提取

讨论结束后，在当前 `/prd` 会话里直接输入：

```
/extract
```

`/extract` 表示“停止自由讨论，开始整理提取结果”。AI 会先展示候选内容给你审核，**审核通过前不会写文件**。

也兼容自然语言触发，例如：“好的，生成交互定义和 PRD”“讨论好了，提取事实”“生成 PRD 吧”“开始提取”。

### 第四步：批量审核

AI 展示所有提取结果，逐条或一键确认：

```
=== 提取结果 ===

事实候选项:
[1] 功能: "支持批量检查最多 10,000 个地址"
[2] 约束: "严格匹配，不支持模糊查询"
[3] 范围: "支持: 美国、欧盟、香港、新加坡"

交互定义:
[4] 状态流: 选择地区 → 上传 → 验证 → 检查 → 结果
[5] 组件: select + file_upload + table

---
输入 'all-yes' 全部批准，或对每个 [N] 输入 'yes'/'no'
```

### 第五步：自动推送

```
✅ 已提交并推送！

  ✓ facts/your-product.md               （更新）
  ✓ workflows/batch-screening.yaml            （新建）
  ✓ decisions/decision-20260416-batch-screening.md
  ✓ approved-prds/prd-batch-screening-20260416.md
  ✓ features/batch-screening/context.md       （新建）
  ✓ features/batch-screening/prd.md           （新建）
  ✓ features/batch-screening/workflow.yaml    （新建）

下一步: /ui-draft batch-screening
```

提交完成后，AI 会展示 **Memory Review**，列出本次讨论中发现的可复用规则候选，逐条或一键批准后写入 `memory/rules/`。

### 第六步（可选）：生成可点击原型

```
/ui-draft batch-screening
```

生成双路径原型（主路径优先）：

```
features/batch-screening/prototype.html   ← 主路径（与 PRD、workflow、dev assets 同一目录）
prototypes/batch-screening.html           ← 副路径（legacy 兼容）
```

**Claude Code 本身不支持预览 HTML**，用以下方式查看：

```bash
# macOS：在默认浏览器中打开（路径根据你的 KNOWLEDGE_DIR 而定）
open <知识库目录>/features/batch-screening/prototype.html
```

原型包含可点击的状态机、表单验证和模拟数据，在浏览器里直接操作。

如需同步到 Figma 线框图：

```
/ui-draft --figma batch-screening
```

同步完成后在你自己的 Figma 文件中查看（首次使用按提示完成 Figma 授权）

---

## 主动记忆机制

每个命令都内置了三段式记忆生命周期：

**启动时**：加载 feature workspace（如已存在），扫描相关 `memory/rules/`，展示记忆摘要：

```
Memory loaded:
- Feature workspace: found
- Active rules: 3 rules — compliance / ux / engineering
- Open questions: 2
```

**工作中**：追踪新发现的产品事实、设计决策、未解决问题和可能需要沉淀的规则。

**结束前**：展示 Memory Review 候选块：

```
=== Memory Review ===

Should save: yes
Reason: 本次讨论确认了一条合规声明约束，影响后续 GTM 和 email

Feature workspace updates:
[1] features/batch-screening/context.md -> ...
[2] features/batch-screening/memory.md -> ...

Durable product memory:
[3] memory/rules/compliance-claims.md -> 竞品对比声明必须绑定 facts 来源

Not saved:
- 临时排期讨论

请审核。输入 all-yes 全部批准，或逐条说明 yes/no/修改内容。
```

只写入用户批准的内容，冲突必须标记 `[CONFLICT]` 由用户裁决。

---

## 保存到哪里？

知识库只有两个存放位置：

| 位置 | 含义 | 会被其他 PRD 引用？ |
|------|------|------------------|
| `drafts/` | 讨论中 / 暂未确认 | 否 |
| `approved-prds/` | 正式确认 | **是** |

### 保存到 drafts/（暂存，下次继续）

讨论进行中，想暂停先存着，直接说：

```
"先存草稿，下次继续"
"暂时保存，还没讨论完"
```

下次运行 `/prd [feature]` 自动提示恢复。

### 保存到 approved-prds/（正式确认）

**方式一（推荐）**：输入 `/extract` → 审核提取结果 → `all-yes` → 自动写入

**方式二**：觉得内容已经够了，直接说：

```
"内容确认了，直接存到 approved-prds"
"这个版本可以，保存为正式 PRD"
```

### 草稿升级为正式 PRD

草稿完善后，说：

```
"把 [feature] 的草稿转为正式 PRD"
```

AI 将草稿整理后写入 `approved-prds/`，并删除草稿文件。

---

## 两个命令详解

### `/prd [feature]`

```bash
/prd batch-screening              # 对话模式：和 AI 讨论需求
/prd --from-meeting [feature]     # 会议纪要模式：粘贴纪要直接提取决策
```

**强制澄清**：对话模式会在正式讨论前先问 4-6 个 PM 版强制问题，确认目标用户、现状替代方案、痛点证据、最小切口、成功指标和风险假设。

**会议纪要模式**：运行后粘贴会议纪要，AI 只提取 `Decisions` 栏中有架构意义的条目，跳过 Open Questions 和 Action Items，审核后写入 `decisions/`。

### `/prd review [feature]`

```bash
/prd review batch-screening              # 自动查找 drafts/ 或 approved-prds/ 中的 PRD
/prd-review batch-screening              # 兼容 alias
/prd-review --draft batch-screening      # 优先审查草稿
/prd-review --approved batch-screening   # 优先审查正式 PRD
```

从 CEO/产品负责人视角审查 PRD 的用户价值、范围取舍、成功指标、风险假设、交互闭环、数据依赖、合规安全、上线运营和测试验收。审查结果写入 `reviews/`，明确产品/设计决策可同步写入 `decisions/`。

### `/prd research [feature]`

```bash
/prd research detail-page-optimization
/prd research detail-page-optimization 整理这 4 个用户访谈，标出 PRD gap 和冲突
/research detail-page-optimization
```

整理用户访谈、客户反馈、销售/CS 反馈和会议纪要中的需求信号，写入 `memory/research/`。每条研究结论按 `✅验证` / `➕Gap` / `⚠️冲突` / `❓待澄清` 分类；可行动的新 gap 或 conflict 会轻量同步到 `feature-backlog.md`，并在 `features/[feature]/context.md` 的 `用户研究` 小节反链研究文档。`/research` 是兼容 alias；主用法是 `/prd research`。

### `/prd docs|prompt|competitor|assets|clean`

```bash
/prd docs notification channels
/prd prompt pricing advisor
/prd competitor "Competitor A"
/prd assets scan
/prd clean
```

这些是 PM 维护知识库的子用法：`/prd docs` 维护 `customer-knowledge/`，`/prd prompt` 维护 `prompts/`，`/prd competitor` 维护 `competitors/`，`/prd assets scan` 刷新 `assets-index.md`，`/prd clean` 做知识库整理和归档。

### `/ui-draft [feature]`

```bash
/ui-draft batch-screening          # 生成原型
/ui-draft edit batch-screening     # 修改交互定义后重新生成
/ui-draft view batch-screening     # 查看原型信息
```

### `/dev [feature]`

```bash
/dev batch-screening                    # 根据 PRD 生成研发准备资产
/dev --challenge batch-screening        # 工程挑战模式，沉淀技术风险和决策
/dev --from-approved batch-screening    # 从 approved-prds/ 读取 PRD
```

`/dev` 关注工程落地：实现方案、API/数据契约、测试规格、开发检查清单、上线风险和 `[待工程确认]` 项。资产主路径写入 `features/[feature]/dev-assets/`（legacy `dev-assets/[feature]/` 保留副本），工程挑战结论写入 `decisions/`。结束前进入 Memory Review Gate，可沉淀工程规则到 `memory/rules/`。

### `/video [topic]` — 脚本优先工作流

```bash
/video 制作一个 dashboard 新功能的 30 秒演示动图
/video --tutorial 为"导入数据"功能制作 60 秒教程视频
/video --comparison 演示你的产品 vs 竞品 A 的对比动图
/video --workflow 制作"生成报告"这个核心流程的讲解动画
```

**核心工作流**（4 阶段 + 确认门）：

```
Phase 1: 脚本生成 (轻量)
  读取: workflows/ + PRD
  输出: 纯文本脚本 (YAML)
  Token: ~1300 | 时间: ~5 min
  
  ↓ [停止] 等用户审视脚本
  
[确认门] 用户选择:
  ✅ 是的，继续
  🔧 改脚本（回到 Phase 1 修改）
  🔄 重新来（新方向）
  
  ↓ (如需改脚本)
  Phase 2: 脚本修订 (可选)
    仅改动指定部分
    Token: ~600 | 时间: ~3 min
    → 再次确认
  
  ↓
Phase 3: 代码生成 (丰富)
  前提: 脚本已确认 ✓
  读取: 脚本 + facts/product.md (品牌) + assets/
  输出: VideoScene.tsx (完整 Remotion 代码)
  Token: ~2200 | 时间: ~2 min
  
  ↓
Phase 4: 本地渲染
  npm install remotion ffmpeg-static
  npx remotion preview       (可选：预览)
  npx remotion render out.mp4
  时间: ~10 min (含渲染)
  
  ↓
完成 ✅ out.mp4 + 沉淀到知识库
```

**Token 效率对比**：
- ❌ 直接生成代码（旧）：单次 3000 tokens，失败需重做 6000+ tokens
- ✅ 脚本优先（新）：3500-4100 tokens，迭代时节省 30%，失败时节省 50%+

**品牌自动化**：
- 自动读取 `facts/product.md` 的品牌色 `#8DC8E8` (蓝)、强调色 `#FF7F32` (橙)、背景色等
- 生成的 Remotion 代码自动注入 `BRAND` 常量，无需手工配置

**文档导航**：
- 🚀 **10 分钟快速启动**：[product-video-quickstart.md](skills/product-video-quickstart.md)
- 📖 **完整工作流指南**：[product-video.md](skills/product-video.md)（含 4 Phase 详解、脚本格式、Asset 清单）
- 🤖 **Agent 实现参考**：[codex/references/product-video-workflow.md](../codex/references/product-video-workflow.md)
- 🏗️ **架构设计文档**：[VIDEO_WORKFLOW_ARCHITECTURE.md](../VIDEO_WORKFLOW_ARCHITECTURE.md)（为什么脚本优先、Token 效率分析、Trellis 启发）
- 🔍 **MCP 方案分析**：[VIDEO_WORKFLOW_MCP_ANALYSIS.md](../VIDEO_WORKFLOW_MCP_ANALYSIS.md)（MCP 对比、可行性评估）

### `/hive-mind-update`

```bash
/hive-mind-update
```

手动检查并更新 HiveMind Skill。更新成功后会重新注册所有 skill 命令，解决新增命令没有出现在 Claude Code 的问题。自动更新仍会在调用 skill 前运行；如果本地有未提交修改，会保护性跳过。

### `/gtm [topic]`

```bash
/gtm 写一篇你的产品相比竞品的核心优势文章
/gtm monitor analytics ai insights 这几个能力怎么包装成官网文章
/gtm --battle-angle 你的产品 vs 某个竞品
```

`/gtm` 面向商业化、内容营销和销售 enablement 同事。它会读取你的产品的产品事实、PRD、decision、用户手册、FAQ、API 文档和竞品资料，生成文章方向、差异化卖点、证据来源和可直接使用的市场/销售表达。输出必须聚焦产品的核心差异化优势，不能把文章主线写成泛泛的页面体验优化。

### `/email [topic]`

```bash
/email 写一封产品更新邮件，中文和英文，生成 HTML 并保存到资产库
/email 给新注册用户写 onboarding follow-up 邮件
/email 面向付费用户写 plan renewal reminder
```

`/email` 面向产品通知、邮件营销、newsletter、客户邮件、销售触达和续费提醒。它会先同步知识库，再读取产品事实、PRD、decision、FAQ、用户手册、API 文档、竞品资料和 `assets-index.md`；确认后把 `brief.md`、`content.{lang}.md`、`render-input.{lang}.json`、`email.{lang}.html` 和 `metadata.json` 保存到 `assets/emails/`，并更新资产索引。`/email` 只生成内容和 HTML，不发送 Gmail、不创建 Gmail 草稿、不读取 OAuth 或 `.env`。

### `/video [topic]`

```bash
/video 制作一个 dashboard 新功能的 30 秒演示动图
/video 产品更新：为新的 AI 分析功能制作推广动图
/video --tutorial 为"导入数据"功能制作 60 秒教程视频
/video --comparison 演示你的产品 vs 竞品 A 的对比动图
/video --workflow 制作"生成报告"这个核心流程的讲解动画
```

`/video` 面向产品演示、内容营销、视频营销和社交媒体。采用**脚本优先确认工作流**，4 个阶段：

1. **Phase 1: 脚本生成（轻量）** — 读 `workflows/` + PRD，生成纯文本脚本（~5 min，~1300 tokens）
2. **[确认门]** — 你审视脚本，确认方向正确（防止浪费 token）
3. **Phase 3: 代码生成（丰富）** — 注入品牌色、logo，生成完整 Remotion TypeScript（~2 min，~2200 tokens，一次性）
4. **Phase 4: 本地渲染** — 你本地 `npm install + render`，视频沉淀到 `assets/videos/`

**核心特点**：
- ✅ 脚本优先，用户提前看到方向
- ✅ 脚本修改轻量（~600 tokens），防止代码重复生成
- ✅ 品牌自动化：自动读取 `facts/product.md` 的品牌色、logo、产品信息
- ✅ Token 高效：迭代场景节省 30%，失败场景节省 50%+
- ✅ 知识库集成：脚本基于 `workflows/` 和 PRD，有上下文

详见：[product-video-quickstart.md](skills/product-video-quickstart.md)（10 分钟快速启动）和 [product-video.md](skills/product-video.md)（完整工作流）。

---

## 知识库

所有产出推送至：`https://github.com/your-org/team-knowledge`（私有）

本地路径：`$KNOWLEDGE_DIR`（默认 `~/.hive-mind/knowledge/`）

```
team-knowledge/
├── features/                  # 功能 workspace（v0.0.15 新增，优先）
│   └── [feature]/
│       ├── context.md         # 当前理解、范围、假设
│       ├── prd.md             # PRD 副本
│       ├── workflow.yaml      # 交互定义（ui-draft 优先读取此处）
│       ├── prototype.html     # HTML 原型（ui-draft 主路径）
│       ├── memory.md          # 近期会话笔记和候选规则
│       ├── open-questions.md  # 未解决 PM / 工程 / 设计问题
│       ├── handoff-status.md  # 当前生命周期状态
│       └── dev-assets/        # 工程资产（dev 主路径）
├── memory/                    # 可复用知识（v0.0.15 新增）
│   ├── rules/                 # 跨功能可复用规则（Memory Review 沉淀）
│   ├── research/              # 用户研究、需求收集和 PRD gap 证据
│   └── journal/               # 会话记录
├── facts/                     # 产品事实（全局）
├── workflows/                 # 交互定义 YAML（legacy）
├── decisions/                 # 设计决策
├── reviews/                   # PRD 审查结论
├── dev-assets/                # 研发准备资产（legacy）
├── approved-prds/             # 已发布 PRD
├── prototypes/                # HTML 原型（legacy）
├── assets/emails/             # 邮件内容、HTML 和元数据
├── drafts/                    # 会话草稿（中断恢复用）
└── pending/                   # 暂停或等待决策的 PRD
```

新功能的产出优先写入 `features/[feature]/`；旧格式（`workflows/`、`dev-assets/`、`prototypes/`）保留为 legacy 路径，继续可读。

权限按角色区分：PM 和需要写入 `decisions/` / `dev-assets/` 的工程贡献者需要 Write；只读取 PRD、原型和测试规格的成员使用 Read 即可。完整权限表见根目录 README。

---

## 目录结构

```
claude-code/
├── skills/
│   ├── prd.md                    # /prd 命令定义
│   ├── research.md               # /research 命令定义
│   ├── prd-review.md             # /prd-review 命令定义
│   ├── dev.md                    # /dev 命令定义
│   ├── gtm.md                    # /gtm 命令定义
│   ├── email.md                  # /email 命令定义
│   ├── product-video.md          # /video 命令定义（完整 4 Phase 工作流）
│   ├── product-video-quickstart.md # /video 快速启动指南（10 分钟上手）
│   ├── hive-mind-update.md       # /hive-mind-update 命令定义
│   └── ui-draft.md               # /ui-draft 命令定义
├── email/                         # /email HTML 合成脚本和完整邮件模板
├── install.sh                     # 一键安装脚本
├── install-enterprise.sh          # 企业多人部署脚本
├── update.sh                      # 更新脚本
├── PACKAGE.md                     # 完整工作流文档（10 个提取规则等）
├── package.yaml                   # 版本和配置元数据
└── scripts/
    ├── check-updates.sh           # Claude Code PreToolUse 自动更新入口
    ├── register-skills.sh         # 安装或更新后重新注册 skill 命令
    └── test-setup.sh              # 验证安装脚本

# 根目录架构和设计文档
├── VIDEO_WORKFLOW_ARCHITECTURE.md # /video 设计文档（为什么脚本优先）
├── VIDEO_WORKFLOW_MCP_ANALYSIS.md # MCP 方案对比分析（MCP vs 脚本优先 vs 混合）
└── VIDEO_WORKFLOW_SUMMARY.md      # 改造总结文档
```

自动更新依赖 `$SKILL_DIR` 是 git clone。`install.sh` 会写入 PreToolUse hook，hook 调用 `scripts/check-updates.sh`；有新版本时脚本会 `git pull` 并调用 `scripts/register-skills.sh`。如果通过复制目录或压缩包离线安装，缺少 `.git` 时自动更新会跳过。

---

## 故障排除

**命令不存在**

重新运行注册脚本：

```bash
bash <SKILL_DIR>/claude-code/scripts/register-skills.sh
```

或手动运行 install.sh 重新安装。

**推送失败（权限错误）**：确认你对知识库远端仓库有写权限（个人仓库或团队组织授权）。

**草稿丢失**：重新运行 `/prd [feature]`，系统会自动检测并提示恢复。

**`/ui-draft` 报错：`python: command not found`**

某些系统上 `python` 命令不存在（macOS 通常只有 `python3`）。创建 symlink 解决：

```bash
sudo ln -sf $(which python3) /usr/local/bin/python
```

验证：`python --version` 应返回 Python 3.x。

---

## 更多

- [PACKAGE.md](./PACKAGE.md) — 完整工作流和 10 个提取规则详解
- [根目录 README](../README.md) — Codex 版本 + 各角色使用说明
