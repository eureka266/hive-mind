---
name: prd
description: HiveMind 产品知识库维护入口。从讨论或会议纪要自动沉淀产品事实、设计决策、交互流程到知识库，也支持 /prd research、/prd review、/prd docs、/prd prompt、/prd competitor、/prd interactions、/prd assets scan、/prd clean 等 PM 维护模式。输入 /prd [功能名] 开始。支持自动检查和更新（无需用户交互）。
---

# prd

HiveMind 的产品讨论命令。支持多种工作模式和自动更新：

- **对话模式**：与 AI 自由讨论功能需求，结束后自动提取
- **会议纪要模式**：粘贴已有会议纪要，直接提取 Decisions 并写入知识库
- **快速推送模式**：本地编辑后一句话推送到 GitHub
- **PM 知识库维护模式**：`/prd research`、`/prd review`、`/prd docs`、`/prd prompt`、`/prd competitor`、`/prd interactions`、`/prd assets scan`、`/prd clean`
- **开发者模式**：研发根据 ready-to-dev PRD 快速生成开发资产
- **用户研究衔接**：读取 `memory/research/` 中的访谈和反馈证据，把 gap / conflict 纳入 PRD 讨论，但不把研究结论直接当产品事实
- **强制澄清**：正式讨论前先问 4-6 个 PM 版强制问题，逼清用户、现状、痛点、最小切口、成功指标、风险假设
- **自动更新**：执行命令前自动检查 GitHub 并更新（可配置）

## 语言规则

- Claude Code 对话默认用中文；用户明确指定语言时，产物内容按用户指定语言输出。
- 用户自己的产品、功能、API/字段名、工作流名、证据术语和竞品名保留原文，不翻译。
- `customer-knowledge/` 下的所有知识库内容必须使用英文。即使本次对话是中文，写入 `customer-knowledge/` 的 user manual、FAQ、API doc、示例、标题和 metadata 描述也必须是英文。

## 🔄 自动更新机制（可选配置）

为了确保所有用户使用最新版本的 skill 和知识库，可以启用自动检查和更新。

### 快速启用（推荐）

在 Claude Code 中运行：
```
/update-config
```

然后：
1. 选择 "Add Hook"
2. 选择 "Before Command Execution"  
3. 输入命令: `bash ~/hive-mind/claude-code/scripts/check-updates.sh`

这样每次执行 `/prd`、`/dev` 等命令前，都会自动检查并更新。

### 详细配置

详细配置说明：
- 工作原理
- 多种配置方式
- 如何禁用或定制
- 性能考虑
- 团队最佳实践

## 使用方式

```
/prd [feature-name]                   # 对话模式（默认）
/prd --from-meeting [feature-name]    # 会议纪要模式
/prd push [feature-name]              # 快速推送到 GitHub
/prd research [feature-name]          # 整理用户访谈/客户反馈，写入 memory/research/
/prd review [feature-name]            # 产品负责人视角审查 PRD；/prd-review alias 仍可用
/prd docs [topic]                     # 维护面向用户的英文知识库，写入 customer-knowledge/
/prd prompt [prompt-name]             # 维护 the assistant / pricing advisor prompt，写入 prompts/
/prd competitor [vendor/topic]        # 维护竞品资料，写入 competitors/
/prd interactions [feature-name]      # 整理旧交互资料，优先迁移到 features/[feature]/workflow.yaml
/prd assets scan                      # 刷新 assets-index.md
/prd clean                            # 知识库整理：stale drafts、索引、deprecated 路径
/dev [feature-name]                   # 研发专用：根据 ready to dev PRD 生成开发资产
```

例如:
```
/prd csv-import
/prd user-onboarding
/prd --from-meeting assistant-onboarding
/prd research detail-page-optimization
/prd docs notification channels
/prd prompt pricing advisor
/prd competitor Competitor A
/prd clean
/dev assistant-onboarding              # 研发根据 ready-to-dev 的 PRD 生成实现方案
```

## PM 知识库维护子用法

这些子用法都由产品经理维护，统一挂在 `/prd` 下。顶层 alias 保留：`/research` 等同于 `/prd research`，`/prd-review` 等同于 `/prd review`。

| 子用法 | 主要使用者 | 维护内容 | 主要路径 |
|--------|------------|----------|----------|
| `/prd research` | PM、用户研究、Review Owner | 用户访谈、客户反馈、PRD gap 证据 | `memory/research/`、`feature-backlog.md`、`features/[feature]/context.md` |
| `/prd review` | PM Lead、Review Owner | PRD 价值、范围、指标、风险审查 | `reviews/`、`decisions/`、`memory/rules/` |
| `/prd docs` | PM、客服 PM、Growth PM | 面向用户的知识库 | `customer-knowledge/`，必须英文 |
| `/prd prompt` | PM、AI 产品负责人 | the assistant / pricing advisor prompt | `prompts/` |
| `/prd competitor` | PM、GTM PM、销售 enablement | 竞品资料、来源、可信度、claim 边界 | `competitors/` |
| `/prd interactions` | PM、UX PM | legacy 交互资料整理或迁移 | `interactions/`、`features/[feature]/workflow.yaml` |
| `/prd assets scan` | PM、GTM PM、内容营销 | 资产索引刷新 | `assets-index.md` |
| `/prd clean` | PM repo maintainer | stale drafts、目录索引、deprecated 路径整理 | `pending/`、`archive/`、`memory/journal/`、README/index 文件 |

规则：
- `/prd docs` 写入的所有内容必须是英文，且不能包含内部决策原因、未上线草稿、私有客户信息或竞品攻击性话术。
- `/prd prompt` 必须包含 prompt 目标、输入/输出契约、示例、失败/不确定处理和测试样例。
- `/prd competitor` 必须区分观察事实和主观判断，记录 source、observed date、confidence，以及可复用 claim 边界。
- `/prd clean` 默认移动或归档，不默认删除知识；结构性整理要写入 `memory/journal/[YYYY-MM-DD].md`。

---

## 会议纪要模式（`--from-meeting`）

适用场景：已有结构化会议纪要，不需要再讨论，直接提取决策写入知识库。

### 使用步骤

```
/prd --from-meeting assistant-onboarding
```

运行后粘贴会议纪要内容，AI 自动执行以下逻辑：

**提取规则（只处理 Decisions 栏）**：

| 保留 | 跳过 |
|------|------|
| 有架构/产品意义的决策（影响后续设计） | Open Questions（未决定） |
| 选型决策（为什么选 A 不选 B） | Action Items（任务追踪） |
| 形态/交互决策 | Constraints 中的排期信息 |

**输出格式**（进入批量审核）：

```
=== 会议纪要提取结果 ===
来源: assistant-onboarding 会议（[日期]）

决策候选项:
[1] 架构: "chatbot 支持意图分类与路由，不做单一统一 agent 处理"
[2] 形态: "主动唤起消息采用两层形态：气泡提示 + 完整聊天窗口"

跳过项（不写入知识库）:
- Open Questions: chatbot 入口形态（待定）
- Action Items: PM 定义 agent 分层（任务）

---
输入 'all-yes' 全部批准，或对每个 [N] 输入 'yes'/'no'
```

审核通过后写入 `decisions/decision-[date]-[feature].md`，**不生成 PRD 和 workflows**（会议纪要不包含交互定义）。

---

## 写作规范（References）

讨论和生成 PRD 时，必须遵循以下两份规范：

1. **PRD 格式规范** — `references/rules-prd-format.md`：语言、格式、章节结构、PM 范围 vs UI/UX 范围
2. **产品设计规范** — `references/rules-product-design.md`：用户身份多样性、字段命名、metadata 设计、多输入字段等通用设计原则

在阶段 2（讨论）和阶段 4（提取生成 PRD）中，自动应用这两份规范。不需要逐条提示用户，但生成的 PRD 内容必须符合规范要求。

---

## 对话模式工作流

### 阶段 0: PM 强制澄清

正式进入自由讨论前，先完成一轮短而硬的 discovery。目标不是写方案，而是判断这个需求是否足够清楚，避免后续 PRD 建在模糊假设上。

#### 触发时机

- 仅对 `/prd [feature-name]` 对话模式默认启用。
- `/prd --from-meeting` 跳过此阶段，因为会议纪要模式只提取既有 Decisions。
- `/prd push` 跳过此阶段，因为它只处理本地变更推送。
- 如果用户明确说“跳过强制澄清，直接讨论”，可以跳过，但必须在草稿中记录：`本次跳过阶段 0，以下问题未完全确认`。

#### 执行方式

1. 先用一句话说明：
   ```
   在正式讨论前，我先问 4-6 个强制澄清问题，确保后面生成的 PRD 不会建立在空泛假设上。
   ```

2. 根据用户已有输入和知识库上下文，选择 4-6 个最关键的问题逐个追问。每个问题都要求具体答案，不接受“用户”“更高效”“体验更好”这类泛化表述。

3. 优先使用以下 6 个问题：

   | # | 强制问题 | 追问目标 |
   |---|---------|---------|
   | 1 | 目标用户是谁？他们的权限、使用场景、频率是什么？ | 用户与场景 |
   | 2 | 现在他们怎么解决？替代方案、人工流程、竞品或内部工具是什么？ | 现状与替代方案 |
   | 3 | 最痛的点具体发生在哪一步？有什么证据说明它真的痛？ | 痛点与证据 |
   | 4 | 最小可交付切口是什么？哪些能力这版必须删掉？ | MVP 与非目标 |
   | 5 | 成功指标是什么？上线后看哪个行为、数字或反馈判断有效？ | 成功标准 |
   | 6 | 最大风险假设是什么？如果它是错的，PRD 哪部分会失效？ | 风险假设 |

4. 如果用户回答含糊，必须追问一次具体化问题，例如：
   - “这里的用户是运营、销售、管理员还是终端客户？”
   - “现在线下怎么做？能否给一个真实例子？”
   - “这个痛点是耗时、误判、风险、成本，还是转化损失？”
   - “这版如果只能做一个闭环，你会保留哪一步？”
   - “成功指标要能验收，不能只写体验更好。”

5. 阶段 0 结束时输出一个短摘要，并写入草稿开头：
   ```
   ## 阶段 0 强制澄清
   - 目标用户:
   - 现状替代方案:
   - 核心痛点证据:
   - 最小切口:
   - 成功指标:
   - 最大风险假设:
   - 暂未确认:
   ```

6. 只有当以上至少 4 项有可执行答案后，才进入阶段 1。若仍缺关键答案，给用户两个选择：
   - `继续补齐关键问题`
   - `带假设进入讨论`

选择“带假设进入讨论”时，必须把假设标记为 `[待确认]`，后续阶段 1 的待确认事实扫描可以继续处理。

---

### 阶段 1: 初始化

运行命令后，系统自动:

1. **同步远端知识库**（确保本地是最新版本）:
   ```bash
   cd ~/team-knowledge
   git pull origin main
   ```
   - 成功: 继续加载
   - 有冲突: 报告给 PM，暂停初始化，等待手动解决后重新运行
   - 网络失败: 提示 "无法拉取远端，将使用本地缓存继续"，PM 确认后继续

2. 从知识库加载已有知识:
   - `facts/` — 已有的产品事实
   - `workflows/` — 已有的交互流程
   - `decisions/` — 历史设计决策

3. **加载 Feature Workspace（如果已存在）**：解析 feature slug 后，优先加载：
   - `features/[feature]/context.md` — 当前理解、范围和假设
   - `features/[feature]/memory.md` — 近期会话笔记和候选记忆更新
   - `features/[feature]/open-questions.md` — 未解决的 PM / 工程 / 设计问题
   - `features/[feature]/handoff-status.md` — 功能当前生命周期状态
   - `features/[feature]/workflow.yaml` — 功能本地交互定义（如存在）

4. **加载 memory/rules/**：扫描与当前功能或类别（prd / ux / engineering）相关的可复用规则。
5. **加载 memory/research/**：如果存在当前 feature 相关用户研究，读取访谈结论、gap、conflict 和待澄清项；这些内容只作为证据输入，不直接覆盖 PRD、facts 或 decisions。

6. 展示加载结果:
   ```
   ✅ 已初始化讨论会话: [feature-name]
   
   📥 已同步远端知识库 (git pull origin main)
   已加载 your-product 知识库:
   - 事实: X 条（其中 N 条待确认）
   - 决策: Y 条
   - 交互流程: Z 个
   
   Memory loaded:
   - Feature workspace: [found / not found / will create after approval]
   - Active rules: [N rules from memory/rules/]
   - Open questions: [N]

   会话已保存，可随时中断恢复。
   ```

7. **Draft Cleanup Review**：在初始化时扫描 `drafts/` 中长期未更新的文件。

   - 14+ 天未修改：询问草稿是否仍在推进。
   - 30+ 天未修改：强烈建议移到 `pending/` 或 `archive/`，除非用户确认仍在活跃开发。

   发现陈旧草稿时，展示：

   ```
   === Draft Cleanup Review ===

   发现长期未更新的 drafts:
   [1] drafts/prd-[feature].md
       最后修改: [date]
       建议操作: approved-prds / pending / archive
       原因: [ready-looking / deferred / stale / superseded]

   请选择：
   - move to approved-prds/
   - move to pending/
   - move to archive/
   - keep in drafts/
   - review later
   ```

   不得在未经用户确认前移动任何文件。移动时优先使用 `git mv`。

8. **扫描待确认事实**：加载完成后，扫描所有 `facts/` 文件中包含 `[待确认]` 标记的条目。

   - 若**没有**待确认项：跳过此步，直接进入讨论。
   - 若**有**待确认项：调用 `AskUserQuestion` 工具，问题为"发现 N 条待确认事实，现在处理还是稍后？"，选项：
     - `现在逐条确认`
     - `跳过，直接开始讨论`

   选择「现在逐条确认」后，对每条待确认项**依次**调用 `AskUserQuestion` 工具提问：

   **二元判断类**（是/否可以覆盖答案）：
   - 问题：`[待确认内容描述]？`
   - 选项：`[选项 A]`、`[选项 B]`
   - 内置 Other 选项供用户输入自定义答案或修订

   **需要补充值的类**（答案无法枚举）：
   - 问题：`[待确认内容描述]？`
   - 选项：`确认当前描述`、`此项不适用，删除`
   - 内置 Other 选项供用户直接输入具体值

   每条确认后，立即更新 `facts/` 文件：移除 `[待确认]` 标记，写入确认值。跳过的项保持原状不动。

   全部处理完后显示摘要：
   ```
   ✅ 待确认事实处理完毕
   - 已确认: N 条（已写入 facts/）
   - 已跳过: M 条（仍标记为 [待确认]）
   ```

9. **扫描待工程确认事项**：类似地扫描所有 `facts/` 文件中包含 `[待工程确认]` 标记的条目。

   这类标记用于标识**需要工程师验证的技术事实**，例如：
   - "API 是否支持批量返回？" `[待工程确认]`
   - "超时时限是多少？" `[待工程确认]`
   - "数据库支持并发更新吗？" `[待工程确认]`

   **区分已有标记**：
   - `[待确认]` — PM 内部决策待定（会在此步骤1中处理）
   - `[待工程确认]` — 需要工程师验证的技术边界（工程师可运行 `/dev --ask` 记录疑问）
   - `[CONFLICT]` — 与已有 facts 矛盾（保持原样，需人工审核）

   **处理方式**：
   - 扫描发现后，显示待工程确认项的列表
   - PM 可以选择：
     - `现在保留标记` — 工程师后续通过 `/dev --ask` 来确认
     - `现在确认` — PM 直接补充信息，移除标记
     - `删除此项` — 发现标记错误，直接删除

   ```
   发现 3 个待工程确认项:
   [1] API 是否支持批量返回？
   [2] 超时时限和重试机制？
   [3] 数据库并发更新支持？
   
   处理方式：(1-3 对应选项，或 'skip' 跳过)
   > skip
   ```

   选择 `skip` 后，待工程确认项保留为 `[待工程确认]` 标记，工程师运行 `/dev --ask` 时会自动检测并提示确认。

10. 创建草稿文件:
   `~/team-knowledge/drafts/[date]-[feature]-[pm].md`

---

### 阶段 2: 不间断讨论

PM 自由描述功能需求，AI 提出澄清问题并参考已有知识库。

**不打断** — 事实提取发生在讨论结束后，保留思路连贯。

支持长讨论（30+ 分钟），每 5 分钟自动保存草稿。

**中断恢复**: 下次重新运行 `/prd [feature-name]`，自动检测草稿并提示恢复。

#### 阶段 2 回复规范

每次回答用户需求讨论时，结尾都要保留一个非常短的下一步提示，避免用户不知道如何进入提取：

```
继续补充需求即可；如果已经讨论完，直接输入 `/extract`，我会整理提取结果给你审核。
```

如果当前信息明显还不够生成 PRD，提示要更具体：

```
现在还缺 [目标用户/成功指标/错误路径]。补齐后输入 `/extract`，我会进入提取和审核。
```

---

### 阶段 3: 触发提取

#### 推荐触发方式

讨论完成后，用户输入固定指令：

```
/extract
```

`/extract` 是 `/prd` 会话内的结束指令，不是独立 skill。它表示：停止自由讨论，开始从当前会话和草稿中提取事实、决策、交互定义和 PRD。

#### 兼容自然语言触发

如果用户没有输入 `/extract`，但说出以下任意句子，也视为触发提取：

```
"好的，生成交互定义和 PRD"
"讨论好了，提取事实"
"生成 PRD 吧"
"该生成了"
"开始提取"
"进入审核"
```

#### 触发后的确认

收到触发后，先不要写文件。必须先展示一个确认块：

```
收到 `/extract`。我将从本次讨论中提取：
- facts/ 产品事实
- workflows/ 交互定义
- decisions/ 设计决策
- approved-prds/ PRD 草稿

接下来会先展示候选结果，等你审核通过后才写入知识库。
```

如果缺少关键内容，先提醒缺口，并调用 `AskUserQuestion`：

问题：`当前信息还缺 [缺口列表]，是否仍然开始提取？`

选项：
- `继续提取，用 [待确认] 标记缺口`
- `先补充信息`
- `只保存草稿，不提取`

只有用户选择继续提取后，才进入阶段 3.5。

---

### 阶段 3.5: 结构化讨论摘要（Scoped Context Preparation）

**目的**：在提取前将本次对话蒸馏为一份干净的结构化摘要，避免提取时被对话历史、澄清往返、已否定方向"污染"。**阶段 4 的所有提取都基于此摘要，而非原始对话上下文。**

从本次对话生成以下摘要，然后展示给用户确认：

```
## Discussion Summary — [feature-name] ([date])

### 目标用户与核心场景
- 用户：
- 场景：
- 频率：

### 已确认的产品事实
- [每条一行，格式：系统 [支持/不支持/限制] X]

### 已确认的设计决策
- 决策：[内容]
  原因：[为什么这样，而不是什么替代方案]

### 交互流程关键节点
- [步骤 → 步骤 → 步骤]
- 错误路径：
- 空态：

### 边界与 non-goals（本版明确不做）
-

### 未解决问题
- [待确认] ...
- [待工程确认] ...

### 数据与依赖
-
```

生成摘要后，调用 `AskUserQuestion`：

问题：`以上是本次讨论的结构化摘要，将作为后续提取的唯一来源。是否准确？`

选项：
- `准确，开始提取`
- `需要补充或修正`（用户可直接在 Other 输入补充内容）

如果用户补充或修正，将修正内容合并进摘要后继续。**提取环节不再回看原始对话，只使用此摘要。**

---

### 阶段 4: 自动提取（10 个规则）

> **重要**：本阶段基于阶段 3.5 产出的结构化摘要进行提取，不回看原始对话历史。摘要是唯一的提取输入源。

#### 写入位置判断表

提取前，先用这张表判断每条结论应该写到哪个文件：

| 类型 | 判断标准 | 例子 | 写入位置 |
|------|---------|------|--------|
| 产品能力边界 | 描述产品"能做/不能做什么"，跨版本稳定 | "不支持自动删除用户" | `facts/` |
| 配额/数量限制 | 具体的数字限制，影响产品定义 | "Dashboard 最多保存 500 个看板" | `facts/` |
| 定价档位 | 套餐名称、价格、额度等定价事实 | "Essential 套餐含 10,000 次 CSV import" | `facts/` |
| 支持范围 | 支持的地区、语言、币种、司法管辖区 | "支持美国、欧盟、香港" | `facts/` |
| 功能设计决策 | "为什么这样设计"，有替代方案被否决 | "升级弹窗在用量 ≥80% 时触发，而非 ≥90%" | `decisions/` |
| 交互流程 | 用户操作步骤、状态转移、错误处理 | "点击升级 → 选套餐 → Checkout" | `workflows/` |
| UI 形态决策 | 组件选择、布局决定及原因 | "用抽屉而非弹窗，因为内容较长" | `decisions/` |

**判断口诀**：
- 问"这个功能的边界或数字是什么" → `facts/`
- 问"为什么这样设计而不是那样" → `decisions/`
- 问"用户怎么一步步操作" → `workflows/`

---

**产品事实（规则 1-7）**:

| # | 规则 | 模式 | 例子 |
|---|------|------|------|
| 1 | 功能 | "系统[支持/不支持] X" | "支持批量导入" |
| 2 | 约束 | "我们[限制/要求] X 为 Y" | "限制 10,000 行" |
| 3 | 范围 | "支持[地区/币种]: [列表]" | "支持: 美国、欧盟..." |
| 4 | 依赖 | "[功能] 需要 [条件]" | "导入需要先验证格式" |
| 5 | API | "端点: /path" | "调用 /api/import" |
| 6 | 定价 | "定价[模型]: [描述]" | "按导入数收费" |
| 7 | 边界 | "[X] 不[支持] [Y]" | "不支持模糊匹配" |

**交互流程（规则 8-10）**:

| # | 规则 | 模式 | 例子 |
|---|------|------|------|
| 8 | 状态流 | "用户 X，然后 Y" | "上传后系统验证" |
| 9 | UI 组件 | "选择器/按钮/表格" | "下拉选择器" |
| 10 | 错误处理 | "如果 X，则 Y" | "验证失败显示错误" |

#### facts/ 和 decisions/ 文件头元数据

写入或新建 `facts/*.md`、`decisions/*.md` 时，必须在文件顶部加入 YAML front matter。更新旧文件时，如果文件头不存在，应补齐；如果已存在，应保留已有字段并补充缺失字段。

`facts/*.md` 文件头：

```yaml
---
type: facts
feature: [feature-name 或 product-line]
authored_by: pm
audience:
  - pm
  - engineering
  - qa
last_updated: [YYYY-MM-DD]
source: /prd
---
```

`decisions/*.md` 文件头：

```yaml
---
type: decision
feature: [feature-name]
authored_by: pm
audience:
  - pm
  - engineering
  - design
  - qa
decision_date: [YYYY-MM-DD]
source: /prd
---
```

字段含义：

| 字段 | 含义 | 常见值 |
|------|------|--------|
| `type` | 文件类型 | `facts` / `decision` |
| `feature` | 关联功能或产品线 | `csv-import`、`your-product` |
| `authored_by` | 主要作者角色，不是具体人名 | `pm`、`engineering`、`design`、`qa`、`ai-assisted` |
| `audience` | 主要读者角色 | `pm`、`engineering`、`design`、`qa`、`support`、`sales` |
| `source` | 由哪个命令生成或更新 | `/prd`、`/prd --from-meeting`、`/prd-review`、`/dev --challenge` |

`authored_by` 只能写角色，不写个人姓名，避免把个人信息沉淀进知识库。若文件由 AI 根据 PM 讨论整理，默认 `authored_by: pm`；若由研发挑战写入工程决策，使用 `authored_by: engineering`。

---

### 阶段 5: 批量审核

⚠️ **MANDATORY STOP（强制暂停）**: 提取完成后，必须先向用户展示候选列表，**等待用户明确输入审核结果后**，才能写入任何文件。不得跳过此步骤直接写文件。

先以 markdown 展示候选列表（供用户阅读）：

```
=== 提取结果 ===

事实候选项:
[1] 功能: "支持批量导入最多 10,000 行"
[2] 约束: "严格匹配，不支持模糊"
[3] 范围: "支持: 美国、欧盟、香港、新加坡、日本"

交互定义:
[4] 状态流: 选择地区 → 上传 → 验证 → 导入 → 结果
[5] 组件: select + file_upload + table

决策权衡:
[6] 10,000 限制原因: 性能/成本/UX 权衡
```

展示完成后，**调用 `AskUserQuestion` 工具**，问题为"请审核以上提取结果"，选项：
- `全部批准，写入知识库`
- `逐条审核`
- `取消本次提取`

选择「逐条审核」时，对每条候选项**依次**调用 `AskUserQuestion`，问题为该条目内容，选项：`批准`、`删除`，内置 Other 供用户修改内容后批准。

收到审核结果后，方可进入阶段 6。

---

### 阶段 6: 自动提交

审核通过后，自动写入知识库并 git commit + push。

写入路径包含：

- 全局路径（legacy，保持兼容）：`facts/`、`workflows/`、`decisions/`、`approved-prds/`
- Feature workspace 路径（新，优先）：`features/[feature]/context.md`、`features/[feature]/prd.md`、`features/[feature]/workflow.yaml`

不要创建或追加 `changelog/`、`CHANGELOG.md`、`meta/CHANGELOG.md`。知识库全局 changelog 已废弃，仅作为历史档案保留。新的写入归类如下：

- 跨需求时间线或知识库级变更摘要 → `memory/journal/[YYYY-MM-DD].md`
- 产品、设计、GTM、上线或工程决策及理由 → `decisions/`
- 单需求状态、上下文、会话笔记 → `features/[feature]/`
- 可复用规则 → `memory/rules/`

```
✅ 已提交并推送！

生成的资产:
  ✓ facts/your-product.md (更新)
  ✓ workflows/[feature].yaml (新)
  ✓ decisions/decision-[date]-[feature].md (新)
  ✓ approved-prds/prd-[feature]-[date].md (新)
  ✓ features/[feature]/context.md (新)
  ✓ features/[feature]/prd.md (新)
  ✓ features/[feature]/workflow.yaml (新)

下一步: 运行 /ui-draft [feature] 生成可交互原型
```

### Memory Review Gate（强制运行，不可跳过）

每次 `/prd` session 结束时必须运行此门控，无论内容多少、会话长短。**不允许跳过整个 Memory Review Gate。**

目的：主动将本次 session 产出的可复用知识积累到 `memory/rules/`，防止规则散落在单次 session 中无法跨次复用。这是 spec evolution 机制的核心——每次 session 是知识库的一次"训练"，不是一次性消耗。

#### 必须回答的 4 个结构化问题

逐一扫描本次 session（基于阶段 3.5 产出的结构化摘要），对每类规则判断是否有候选：

**Q1 产品事实规则**
本次 session 是否确认或精化了可在其他功能中复用的产品约束？
- 例：某类合规边界、配额规则、支持范围说明、API 限制、定价逻辑
- 如有 → 候选写入 `memory/rules/product-facts-[category].md`

**Q2 UX / 交互规则**
本次 session 是否确立了可跨功能复用的 UX 模式或交互原则？
- 例：空态处理规范、权限提示格式、错误信息措辞、多步骤确认机制、上传流程标准
- 如有 → 候选写入 `memory/rules/ux-patterns-[category].md`

**Q3 PM 流程规则**
本次 session 是否发现了值得沉淀的 PM 工作方式？
- 例：某类功能的强制澄清问题模板、PRD 范围判断原则、某类需求的拆分方式
- 如有 → 候选写入 `memory/rules/pm-process.md`

**Q4 工程接口规则**
本次 session 是否出现了工程确认点的通用模式？
- 例：数据契约规范、并发/幂等假设、API 设计边界、第三方依赖说明模板
- 如有 → 候选写入 `memory/rules/engineering-constraints.md`

#### 展示格式（每次必须展示，无论有无候选）

```
=== Memory Review Gate（强制）===

Q1 产品事实规则: [N 条候选 / 无新内容]
  [候选内容...]

Q2 UX / 交互规则: [N 条候选 / 无新内容]
  [候选内容...]

Q3 PM 流程规则: [N 条候选 / 无新内容]
  [候选内容...]

Q4 工程接口规则: [N 条候选 / 无新内容]
  [候选内容...]

Feature workspace 更新:
  features/[feature]/context.md → [变更摘要]
  features/[feature]/memory.md → [本次 session 摘要追加]

未保存（说明原因）:
- [临时排期 / 一次性意见 / 与已有 rules 重复]
```

对每条有候选的规则，调用 `AskUserQuestion`：
- `批准` → 写入对应 `memory/rules/` 文件
- `跳过` → 不写，本次 session 记为"未采纳"
- `修改后批准`（Other）→ 用户修改后写入

**如用户说"跳过全部"**，回应："Memory Review Gate 必须逐条处理候选规则；如每条都选跳过也可以，但不能跳过整个门控。"

只写入用户批准的更新。

#### decisions/ 文件元数据字段说明

所有写入 `decisions/` 的文件都包含以下 YAML 元数据，便于快速筛选和识别：

```yaml
---
title: 功能或决策的简短描述
feature: [feature-name]
date: 2026-05-11

# 元数据字段（帮助快速定位内容）
authored_by: PM                    # 作者角色：PM / Engineer / Design / QA
audience: All                      # 目标读者：PM / Engineering / Design / QA / All
category: Product Decision         # 记录类型：Product Decision / Engineering Constraint / Design Decision / QA Plan
---
```

**元数据字段使用指南**：

| 字段 | 可选值 | 何时填写 |
|------|--------|---------|
| `authored_by` | PM / Engineer / Design / QA | 总是填写，表示作者身份 |
| `audience` | PM / Engineering / Design / QA / All | 总是填写，表示主要读者 |
| `category` | Product Decision / Engineering Constraint / Design Decision / QA Plan | 总是填写，便于分类查询 |

**示例**：

- PM 的产品决策 → `authored_by: PM, audience: All, category: Product Decision`
- 工程师提出的技术约束 → `authored_by: Engineer, audience: PM, category: Engineering Constraint`
- 设计师的设计决策 → `authored_by: Design, audience: All, category: Design Decision`

---

## 保存指令速查

知识库只有两个存放位置：

| 位置 | 含义 | 会被其他 PRD 引用？ |
|------|------|------------------|
| `drafts/` | 讨论中 / 暂未确认 | 否 |
| `approved-prds/` | 正式确认 | **是** |

### 保存到 drafts/（暂存草稿）

讨论中途想暂停，说任意一种：

```
"先存草稿，下次继续"
"暂时保存，还没讨论完"
"存到草稿就好"
```

AI 会将当前讨论内容保存到：
`drafts/[date]-[feature]-[pm].md`

下次运行 `/prd [feature]` 自动提示恢复。

---

### 保存到 approved-prds/（正式确认）

**方式一：正常完成讨论流程**（推荐）

输入 `/extract` → 审核提取结果 → 输入 `all-yes` 或逐条确认 → 自动写入 `approved-prds/`

**方式二：直接确认当前内容**

讨论进行中，觉得已经足够了，说：

```
"内容确认了，直接存到 approved-prds"
"这个版本可以，保存为正式 PRD"
```

---

### 将草稿升级为正式 PRD

草稿讨论完善后，说：

```
"把 [feature] 的草稿转为正式 PRD"
"草稿确认了，移到 approved-prds"
```

AI 会将 `drafts/[date]-[feature]-[pm].md` 的内容整理后写入 `approved-prds/`，并删除草稿文件。

---

## 知识资产权威层级

讨论时参考优先级:

1. **facts/** — 产品事实（哪些功能支持、限制等）
2. **workflows/** — 已有的交互流程
3. **decisions/** — 历史设计决策（为什么这样做）
4. **approved-prds/** — 已发布的 PRD 示例
5. **当前讨论** — 今天的新想法

---

## 快速推送（本地编辑后）

适用场景：你在本地直接编辑了知识库文件（PRD、facts、decisions 等），不需要重新讨论，只想一句话推送到 GitHub。

### 使用方式

```
/prd push [feature-name]          # 推送指定功能相关文件
/prd push                         # 推送所有未提交的变更
```

或直接说：
```
"推送到 GitHub"
"把 csv-import 的修改推上去"
"本地改好了，push 一下"
```

### 执行逻辑

```bash
cd ~/team-knowledge

# 步骤 1: 先拉取远端最新，防止冲突
git pull origin main

# 步骤 2: 如有冲突，停止并提示
# 如无冲突，继续

# 步骤 3: 展示将要提交的变更，等待确认
git diff --stat HEAD

# 步骤 4: PM 确认后 add + commit
git add [相关文件]
git commit -m "docs: update [feature-name] PRD/decisions/workflows

Auto-committed by HiveMind /prd push"

# 步骤 5: 推送
git push origin main

# 如推送被拒绝（远端有新提交）
git pull origin main --rebase
git push origin main
```

### 输出示例

```
📤 准备推送到 GitHub...

变更文件:
  M  approved-prds/your-product/prd-csv-import-2026-04-22.md
  M  facts/your-product.md

确认推送？(yes/no)
> yes

✅ 已推送到 origin/main！

提交: a3f1c2d  docs: update csv-import PRD/decisions/workflows
链接: https://github.com/your-org/team-knowledge
```

---

## 知识库路径

知识库位于: `~/team-knowledge/`
远端仓库: `https://github.com/your-org/team-knowledge`（私有）

参考文件:
- `facts/your-product.md`
- `workflows/`
- `decisions/`
- `approved-prds/your-product/`
- `drafts/` (会话草稿)

---

## 开发者模式（`/dev`）— 根据 PRD 生成开发资产

`/dev` 现在是独立 skill，完整规则见 `claude-code/skills/dev.md`。本节只保留与 `/prd` 的衔接说明。

适用场景：PM 已完成功能定义，PRD 已进入 `ready-to-dev/` 或 `approved-prds/`，研发人员需要快速获取开发准备资产，或在开发前挑战 PRD 中的技术假设。

### 使用方式

```
/dev [feature-name]                    # 生成研发准备资产
/dev --challenge [feature-name]        # 工程挑战模式
/dev --from-approved [feature-name]    # 从 approved-prds/ 读取
```

### 与 `/prd` 的衔接


- `/prd` 生成产品事实、交互定义、设计决策和 PRD。
- `/prd-review` 从产品负责人视角审查方向、范围、指标和风险。
- `/dev` 从研发视角审查实现、接口、数据、测试、上线和工程挑战。
- 如果 `/prd` 过程中遇到技术不确定项，标记为 `[待工程确认]`，交给 `/dev` 阶段处理。

推荐顺序：

```
/prd → /extract → /prd-review → /dev → /ui-draft
```

---

**属于**: HiveMind Skill v0.0.16
**相关命令**: 
- `/prd` — PM 讨论和创建功能定义
- `/prd-review` — 产品负责人视角审查 PRD
- `/dev` — 研发准备、工程挑战和开发资产生成
- `/ui-draft` — 从交互定义生成 HTML 原型
