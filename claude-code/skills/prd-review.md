---
name: prd-review
description: HiveMind PRD 审查命令。借鉴 CEO review 方式，从用户价值、范围取舍、成功指标、风险假设、交付路径、上线运营和测试验收角度审查 drafts/ 或 approved-prds/ 中的 PRD。输入 /prd-review [功能名] 开始。
---

# prd-review

HiveMind 的 PRD 审查命令。用于在 PRD 草稿进入正式确认前，或正式 PRD 进入研发前，做一次 CEO/产品负责人视角的审查。

核心原则：不要只润色文档，要判断计划是否值得做、是否聚焦、是否可交付、是否能被验证。

## 使用方式

```
/prd-review [feature-name]              # 审查指定功能的 PRD
/prd-review --draft [feature-name]      # 优先审查 drafts/ 中的草稿
/prd-review --approved [feature-name]   # 优先审查 approved-prds/ 中的正式 PRD
```

例如：
```
/prd-review csv-import
/prd-review --draft assistant-onboarding
/prd-review --approved user-onboarding
```

---

## 工作流

### 阶段 1: 定位 PRD

1. 进入知识库：
   ```bash
   cd ~/team-knowledge
   git pull origin main
   ```

2. 按优先级查找文件：
   - 指定 `--draft`：优先 `drafts/`
   - 指定 `--approved`：优先 `approved-prds/`
   - 未指定：先找 `drafts/`，再找 `approved-prds/`

3. 同时加载相关上下文：
   - `facts/` 中与 feature 或产品线相关的事实
   - `workflows/[feature].yaml`
   - `decisions/` 中与 feature 相关的历史决策

4. **Active Memory Setup**：加载 feature workspace 和可复用规则：
   - `features/[feature]/context.md` — 当前理解和范围
   - `features/[feature]/memory.md` — 近期会话笔记
   - `features/[feature]/open-questions.md` — 未解决问题
   - `features/[feature]/handoff-status.md` — 当前生命周期状态
   - `memory/research/` — 与该 feature 相关的用户访谈、需求收集和 PRD gap 证据
   - `memory/rules/` — 与 review / launch / compliance / ux 相关的可复用规则

   报告 memory 摘要：
   ```
   Memory loaded:
   - Feature workspace: [found / not found]
   - Active rules: [N rules — review / compliance / launch / ux]
   - Open questions: [N]
   ```

5. 如果找到多个候选 PRD，展示候选列表并让用户选择；如果找不到，说明缺失路径并停止。

---

### 阶段 2: CEO 视角审查

先不要改文档。阅读 PRD 后，从以下维度做判断：

| 维度 | 审查问题 |
|------|---------|
| 用户价值 | 目标用户是否具体？痛点是否真实？有没有现状替代方案对比？ |
| 用户研究证据 | `memory/research/` 是否验证 PRD、揭示 gap、产生 `[CONFLICT]` 或留下待澄清项？ |
| 范围取舍 | MVP 是否足够小？有没有混入可延期能力？非目标是否明确？ |
| 成功指标 | 指标是否能上线后验证？是否有行为、数字或定性反馈口径？ |
| 风险假设 | 最大风险是什么？如果假设错误，哪些方案会失效？ |
| 交互闭环 | 用户路径、状态、错误处理、空态、权限边界是否完整？ |
| 数据与依赖 | 所需数据、API、权限、运营配置、第三方依赖是否明确？ |
| 合规与安全 | 是否涉及隐私、合规、审计、误判、权限滥用或敏感操作？ |
| 交付与上线 | 是否有灰度、回滚、监控、客服/销售/运营准备？ |
| 测试验收 | 验收标准是否可测试？是否覆盖 unhappy paths？ |

审查时必须区分三类结论：

- **Blocker**：不解决会导致 PRD 不能进入开发或不能上线。
- **Should Fix**：建议进入本次 PRD 修正，否则会增加返工或沟通成本。
- **Can Defer**：可以明确延期，但要记录为什么不做。

---

### 阶段 3: 路径选择

如果 PRD 存在明显范围或方案问题，必须提出 2-3 个路径，不要只给一个答案：

```
方案 A: 最小可交付路径
- 保留:
- 删除/延期:
- 适合原因:
- 风险:

方案 B: 理想完整路径
- 保留:
- 增加:
- 适合原因:
- 风险:

方案 C: 折中路径（可选）
- 保留:
- 延期:
- 适合原因:
- 风险:
```

然后必须让用户选择：

- `采用方案 A`
- `采用方案 B`
- `采用方案 C`
- `先不选，继续讨论`

用户未选择前，不得把审查结论写入知识库。

---

### 阶段 4: 审查输出

用户确认路径后，生成审查摘要：

```
=== PRD Review 结果 ===

审查对象: [path]
推荐路径: [方案 A/B/C]

Blockers:
[1] ...

Should Fix:
[2] ...

Can Defer:
[3] ...

建议更新 PRD:
[4] ...

建议写入 decisions/:
[5] ...

建议标记为 [待确认]:
[6] ...
```

随后调用 `AskUserQuestion`：

问题：`请审核以上 PRD Review 结果`

选项：
- `全部批准，写入知识库`
- `逐条审核`
- `取消本次审查`

选择「逐条审核」时，对每条候选项依次调用 `AskUserQuestion`，选项：`批准`、`删除`，内置 Other 供用户修改内容后批准。

---

### Memory Review Gate（强制运行，不可跳过）

每次 `/prd-review` session 结束时必须运行此门控。**不允许跳过整个 Memory Review Gate。**

目的：将审查中发现的可复用规则积累到 `memory/rules/`，让下一次同类功能的审查自动获益。

#### 必须回答的 4 个结构化问题

**Q1 合规与安全规则**
本次审查是否发现了可跨功能复用的合规边界、客户合同约束或安全要求？
- 例：某类数据操作需要审计日志、某类操作需要双重确认、出口管制相关约束
- 如有 → 候选写入 `memory/rules/compliance-[category].md`

**Q2 UX / 交互规则**
本次审查是否发现了跨功能通用的 UX 问题或正确做法？
- 例：空态设计规范、权限提示措辞、错误恢复路径、unhappy path 覆盖标准
- 如有 → 候选写入 `memory/rules/ux-patterns-[category].md`

**Q3 上线 / 运营规则**
本次审查是否确立了上线、灰度、回滚、监控的通用做法？
- 例：灰度比例标准、回滚触发条件、客服培训时机、销售材料准备清单
- 如有 → 候选写入 `memory/rules/launch-operations.md`

**Q4 PRD 审查标准**
本次审查是否发现了某类 PRD 反复缺失的内容（成为下次审查的标准检查项）？
- 例：某类功能 PRD 必须包含权限矩阵、某类交互必须定义离线/降级态
- 如有 → 候选写入 `memory/rules/prd-review-checklist.md`

#### 展示格式（每次必须展示）

```
=== Memory Review Gate（强制）===

Q1 合规与安全规则: [N 条候选 / 无新内容]
  [候选内容...]

Q2 UX / 交互规则: [N 条候选 / 无新内容]
  [候选内容...]

Q3 上线 / 运营规则: [N 条候选 / 无新内容]
  [候选内容...]

Q4 PRD 审查标准: [N 条候选 / 无新内容]
  [候选内容...]

Feature workspace 更新:
  features/[feature]/handoff-status.md → [review completed, recommended path: A/B/C]
  features/[feature]/memory.md → [review summary]

未保存（说明原因）:
- [一次性意见 / 临时建议 / 功能局部细节]
```

对每条有候选的规则，调用 `AskUserQuestion`：
- `批准` → 写入对应 `memory/rules/` 文件
- `跳过` → 不写
- `修改后批准`（Other）→ 用户修改后写入

**如用户说"跳过全部"**，回应："Memory Review Gate 是强制步骤；每条可以选跳过，但不能跳过整个门控。"

---

### 阶段 5: 写入知识库

审核通过后，写入以下文件：

1. 审查报告：
   `reviews/review-[date]-[feature].md`

2. 如果有明确产品/设计决策，写入：
   `decisions/decision-[date]-[feature]-review.md`

   该文件必须包含文件头：
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
   source: /prd-review
   ---
   ```

3. 如果用户明确要求同步修改 PRD，更新对应 `drafts/` 或 `approved-prds/` 文件；否则只输出建议，不直接改 PRD。

如果 `reviews/` 目录不存在，先创建目录。

同时更新 feature workspace：

4. 更新 `features/[feature]/handoff-status.md`：记录审查结论（Go / Conditional Go / No-Go）和推荐路径。
5. 更新 `features/[feature]/memory.md`：追加本次审查简要摘要。
6. 如有可复用规则获批，写入 `memory/rules/[category].md`。

写入后执行：

```bash
git add reviews/ decisions/ drafts/ approved-prds/ features/ memory/
git commit -m "docs(review): add [feature] PRD review"
git push origin main
```

---

## 审查报告模板

```markdown
# PRD Review: [Feature]

**Date**: [YYYY-MM-DD]
**Source PRD**: [path]
**Reviewer**: HiveMind /prd-review
**Recommended Path**: [A/B/C]

## Executive Summary

[1-3 句话总结是否可进入下一阶段，以及最大问题是什么。]

## Decision

- Recommendation:
- Why:
- What to cut:
- What to keep:
- What to defer:

## Blockers

- [ ] ...

## Should Fix

- [ ] ...

## Can Defer

- ...

## PRD Update Suggestions

- ...

## Decisions to Record

- ...

## Open Questions

- [待确认] ...

## Go / No-Go

- Status: Go / Conditional Go / No-Go
- Conditions:
```

---

## 质量标准

必须指出这些问题：

- 用户或使用场景过泛
- 成功指标不可验证
- MVP 过大或非目标缺失
- 只有 happy path，没有错误和边界状态
- 没有说明数据、权限、依赖或运营配置
- 涉及合规、安全、审计但没有处理策略
- 验收标准不可测试
- 上线、灰度、回滚、监控缺失

不要为了显得有帮助而制造问题。如果 PRD 已经足够清楚，明确说“未发现 Blocker”，只列出小的改进建议和剩余风险。
