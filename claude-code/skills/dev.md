---
name: dev
description: HiveMind 研发准备命令。根据 ready-to-dev/ 或 approved-prds/ 中的 PRD 生成实现方案、接口/数据建议、测试用例框架和开发检查清单；支持 /dev --challenge 让工程师在开发前挑战 PRD 并沉淀工程决策。
---

# dev

HiveMind 的研发准备命令。用于 PRD 完成产品审查后，帮助研发把需求转成可执行的工程准备资产。

`/dev` 不负责判断这个需求值不值得做；那是 `/prd-review` 的职责。`/dev` 关注的是：这个 PRD 能不能实现、怎么拆、哪些技术边界需要确认、测试和上线怎么准备。

同时支持 `/dev --ask`，让工程师把阅读 PRD 后产生的技术疑问结构化记录下来，供 PM 后续集中回答并沉淀到知识库。

## 使用方式

```
/dev [feature-name]                    # 根据 PRD 生成开发准备资产
/dev --ask [feature-name]              # 记录工程师技术疑问，供 PM 批量回答
/dev --challenge [feature-name]        # 工程挑战模式：指出技术风险和 PRD 不可执行之处
/dev --from-approved [feature-name]    # 从 approved-prds/ 读取，而不是 ready-to-dev/
/dev --preview [feature-name]          # 只在聊天中预览，不写文件
```

例如：
```
/dev csv-import
/dev --ask assistant-onboarding
/dev --challenge assistant-onboarding
/dev --from-approved user-onboarding
```

---

## 工作流一：生成开发准备资产

### 阶段 1: 定位 PRD

1. 进入知识库：
   ```bash
   cd ~/team-knowledge
   git pull origin main
   ```

2. 按优先级查找 PRD：
   - 默认优先 `ready-to-dev/[feature].md`
   - 如果不存在，再查找 `approved-prds/` 中匹配 feature 的最新 PRD
   - 指定 `--from-approved` 时，优先使用 `approved-prds/`

3. 同时加载相关上下文：
   - `facts/` 中的产品事实和 `[待工程确认]` 条目
   - `workflows/[feature].yaml` 交互定义
   - `decisions/` 中相关产品和工程决策
   - `reviews/` 中最新 PRD Review 结果

4. **Active Memory Setup**：加载 feature workspace 和可复用工程规则：
   - `features/[feature]/context.md` — 当前范围和假设
   - `features/[feature]/memory.md` — 近期会话笔记
   - `features/[feature]/open-questions.md` — 未解决的工程问题
   - `features/[feature]/handoff-status.md` — 当前生命周期状态
   - `memory/rules/` — 与 engineering / data-contract / test / rollout / monitoring 相关的可复用规则

   报告 memory 摘要：
   ```
   Memory loaded:
   - Feature workspace: [found / not found]
   - Active rules: [N rules — engineering / test / rollout / monitoring]
   - Open engineering questions: [N]
   ```

5. 如果找不到 PRD，停止并提示：
   ```
   PRD 文件未找到。请先用 /prd 生成 PRD，或让 PM 将 PRD 放入 ready-to-dev/。
   ```

---

### 阶段 2: 工程确认点

如果发现 `[待工程确认]`，必须先逐条确认，不要直接生成资产。

展示格式：

```
发现 N 条待工程确认项：
[1] API 是否支持批量返回？
[2] 用户状态是否已有稳定字段？

请先确认这些技术事实，再生成开发资产。
```

调用 `AskUserQuestion`，选项：
- `逐条确认`
- `跳过，先生成资产并保留待确认标记`
- `停止，回去补 PRD`

逐条确认时，每项用 `确认当前描述`、`需要修改`、`此项不可行` 处理；修改或不可行的结论写入本次开发准备摘要。

---

### 阶段 3: 生成 4 类开发资产

输出目录（双路径）：

- 全局路径（legacy，保持兼容）：`~/team-knowledge/dev-assets/[feature]/`
- Feature workspace 路径（新，优先）：`~/team-knowledge/features/[feature]/dev-assets/`

两个路径生成相同文件，legacy 路径方便现有工作流读取。

生成文件：

1. `implementation-plan.md`
   - 分阶段实现计划
   - 前后端/数据/权限/配置拆分
   - 依赖和阻塞项
   - 灰度、回滚、监控建议

2. `api-and-data-contract.md`
   - API 端点建议
   - 请求/响应字段
   - 数据来源和状态流转
   - 权限、审计、错误码

3. `test-spec.md`
   - 主流程用例
   - 边界和错误场景
   - 权限/合规/安全测试
   - 基于 `workflows/*.yaml` 的状态机测试

4. `dev-checklist.md`
   - 可执行 checklist
   - PRD 对齐项
   - 代码、测试、上线、监控、文档完成项

不要生成与真实项目框架强绑定的代码文件，除非 PRD 或用户明确指定技术栈和目标仓库。默认先生成工程准备文档，避免伪造不可用代码。

---

### 阶段 4: 审核与写入

生成后先展示摘要，不要立即写文件：

```
=== Dev 资产预览 ===

实现方案:
[1] ...

API / 数据契约:
[2] ...

测试规格:
[3] ...

开发检查清单:
[4] ...
```

调用 `AskUserQuestion`：

问题：`是否写入 dev-assets/[feature]/？`

选项：
- `写入 dev-assets`
- `只预览，不写入`
- `需要修改`

只有用户选择写入后，才创建或更新文件。

同时更新 feature workspace：

- 更新 `features/[feature]/handoff-status.md`：将状态标记为 `ready-to-dev` 或 `blocked`。

写入后执行：

```bash
git add dev-assets/ features/ decisions/
git commit -m "docs(dev): add [feature] development assets"
git push origin main
```

### Memory Review Gate（强制运行，不可跳过）

每次 `/dev` session 结束时必须运行此门控。**不允许跳过整个 Memory Review Gate。**

目的：将工程 handoff 产出的可复用工程规则积累到 `memory/rules/`，让后续功能的工程准备自动获益。

#### 必须回答的 4 个结构化问题

**Q1 API 与数据契约规则**
本次 handoff 是否确立了可跨功能复用的 API 约定或数据结构规范？
- 例：批量接口 partial success 语义、状态机枚举命名约定、敏感字段处理方式、分页标准
- 如有 → 候选写入 `memory/rules/engineering-api-contracts.md`

**Q2 权限、审计与安全规则**
本次 handoff 是否确立了权限验证、操作审计或安全控制的通用模式？
- 例：高风险操作必须二次确认、所有写操作必须记录操作人 + 时间戳、批量导出必须有速率限制
- 如有 → 候选写入 `memory/rules/engineering-security-audit.md`

**Q3 监控与上线规则**
本次 handoff 是否确立了可标准化的监控指标、回滚条件或 feature flag 使用方式？
- 例：新 API 上线前必须配置 P99 延迟告警、DB migration 必须先在 staging 跑满 24h
- 如有 → 候选写入 `memory/rules/engineering-rollout.md`

**Q4 测试覆盖标准**
本次 handoff 是否确立了某类功能的测试边界共识（哪些必须覆盖、哪些可跳过）？
- 例：批量操作必须有 partial failure 测试、外部 API 集成必须有 mock + real 两套测试
- 如有 → 候选写入 `memory/rules/engineering-test-standards.md`

#### 展示格式（每次必须展示）

```
=== Memory Review Gate（强制）===

Q1 API 与数据契约规则: [N 条候选 / 无新内容]
  [候选内容...]

Q2 权限、审计与安全规则: [N 条候选 / 无新内容]
  [候选内容...]

Q3 监控与上线规则: [N 条候选 / 无新内容]
  [候选内容...]

Q4 测试覆盖标准: [N 条候选 / 无新内容]
  [候选内容...]

Feature workspace 更新:
  features/[feature]/handoff-status.md → ready-to-dev
  features/[feature]/memory.md → [handoff summary]
  features/[feature]/open-questions.md → [工程待确认项]

未保存（说明原因）:
- [功能局部技术细节 / 临时排期估算]
```

对每条有候选的规则，调用 `AskUserQuestion`：
- `批准` → 写入对应 `memory/rules/` 文件
- `跳过` → 不写
- `修改后批准`（Other）→ 用户修改后写入

**如用户说"跳过全部"**，回应："Memory Review Gate 是强制步骤；每条可以选跳过，但不能跳过整个门控。"

---

## 工作流二：记录技术疑问

`/dev --ask [feature]` 用于工程师阅读 PRD 后记录技术疑问，避免问题散落在 Slack 或口头沟通里。

### 适用场景

- 工程师需要 PM 确认 API、数据、权限、性能、边界条件
- 问题暂时不构成工程挑战，但需要结构化记录
- PM 希望下次 `/prd` 或 `/prd-review` 时集中处理工程反馈

### 工作流

1. 工程师运行：
   ```bash
   /dev --ask [feature]
   ```

2. AI 提示工程师逐条输入问题，完成后输入 `done`。问题可带优先级：
   - `阻塞`：不澄清无法开始开发
   - `重要`：影响架构设计或时间估算
   - `可选`：不影响启动，但有助于减少返工

3. AI 整理成候选列表，并进入批量审核：
   ```
   === 技术疑问候选 ===
   [1] 阻塞: API 是否支持批量返回？如果支持，单次最多多少条？
   [2] 重要: 超时时限是多少？超时后是否需要重试？
   [3] 可选: 是否需要支持第三方认证？
   ```

4. 审核通过后写入：
   `decisions/pending-questions/[date]-[feature]-engineering-questions.md`

文件头：

```yaml
---
type: pending_questions
feature: [feature-name]
authored_by: engineering
audience:
  - pm
  - engineering
created_date: [YYYY-MM-DD]
source: /dev --ask
---
```

PM 后续运行 `/prd [feature]` 或 `/prd-review [feature]` 时，应加载这些 pending questions，并将已回答的问题沉淀到 `decisions/`。

---

## 工作流三：工程挑战模式

`/dev --challenge [feature]` 用于研发在 PRD 进入开发前提出技术挑战。

### 适用场景

- PRD 的范围在工程上过大
- API、数据、权限、性能或合规边界不清楚
- 现有系统能力不支持 PRD 中的假设
- 测试或上线风险被低估
- 需要把工程视角沉淀进 `decisions/`

### 挑战维度

| 维度 | 问题 |
|------|------|
| 可实现性 | PRD 是否依赖不存在或不稳定的系统能力？ |
| 数据契约 | 字段、状态、错误码、审计日志是否明确？ |
| 性能与规模 | 批量、并发、时延、成本是否可接受？ |
| 权限与安全 | 是否有越权、误操作、敏感数据暴露风险？ |
| 测试可行性 | 验收标准是否能被自动化或手动验证？ |
| 上线风险 | 是否有灰度、回滚、监控和告警策略？ |

### 输出格式

```
=== 工程挑战结果 ===

Blockers:
[1] ...

Engineering Risks:
[2] ...

PRD Clarifications Needed:
[3] ...

Recommended Decisions:
[4] ...
```

随后进入批量审核。审核通过后写入：

`decisions/decision-[date]-[feature]-engineering.md`

工程挑战写入的 `decisions/` 文件必须包含文件头：

```yaml
---
type: decision
feature: [feature-name]
authored_by: engineering
audience:
  - pm
  - engineering
  - qa
decision_date: [YYYY-MM-DD]
source: /dev --challenge
---
```

如果有需要 PM 回答的问题，标记为 `[待确认]`；如果是工程事实待验证，标记为 `[待工程确认]`。

---

## 与其他命令的边界

| 命令 | 关注点 | 输出 |
|------|--------|------|
| `/prd` | PM 讨论、提取产品事实、交互和 PRD | `facts/`、`workflows/`、`decisions/`、`approved-prds/` |
| `/prd-review` | 产品负责人审查方向、范围、指标、风险 | `reviews/`、必要时 `decisions/` |
| `/dev` | 研发准备、接口数据、测试、上线和工程挑战 | `dev-assets/`、必要时 `decisions/` |
| `/ui-draft` | 从交互定义生成可点击原型 | `prototypes/` |

推荐顺序：

```text
/prd → /extract → /prd-review → /dev → /ui-draft
```

实际项目中 `/ui-draft` 可以在 `/dev` 前后都运行；如果研发需要先看交互状态机，建议先生成原型。
