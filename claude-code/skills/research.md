---
name: research
description: HiveMind 用户研究与需求收集兼容命令。主用法为 /prd research [feature]；/research [feature] 作为 alias 保留。用于整理用户访谈、客户反馈、销售/CS 反馈、会议纪要中的需求信号，写入 memory/research/，并把可行动 gap 反链到 feature-backlog.md 和 features/[feature]/context.md。
---

# research

HiveMind 的用户研究和需求收集命令。它是证据收集层，不是 PRD 写作命令。

主用法：`/prd research [feature]`。`/research [feature]` 是兼容 alias，行为一致。

## 使用方式

```text
/research detail-page-optimization
/prd research detail-page-optimization
/research 整理这 4 个用户访谈，标出 PRD gap 和冲突
/prd research 整理这 4 个用户访谈，标出 PRD gap 和冲突
/research 把这段 sales feedback 归档到 pricing-v3
```

## 维护路径

- `memory/research/*.md`: 用户访谈、用户研究、需求收集、feedback clustering、PRD gap 分类。
- `feature-backlog.md`: 从研究中提取的轻量待跟进信号，必须反向链接到 `memory/research/*.md`。
- `features/[feature]/context.md`: 增加 `用户研究` 小节，链接研究文档和 backlog 分组。
- `memory/README.md`: 登记 `research/` 路径。

## 规则

1. 如实记录用户原始结论，不把研究结论直接升级为产品事实。
2. 不存客户隐私数据、原始敏感日志、secret 或不必要的个人身份信息。
3. 每条结论必须和当前 PRD / feature context 做关系分类：
   - `✅ 验证`: 验证当前 PRD 或设计方向
   - `➕ Gap`: PRD 尚未覆盖的新需求
   - `⚠️ 冲突`: 与当前 PRD、decision 或 facts 冲突，标记 `[CONFLICT]`
   - `❓ 待澄清`: 诉求清楚但落地方案或优先级待确认
4. 不直接改 PRD、`facts/` 或 `decisions/`。研究只提出证据和 gap；真正改 PRD 走 `/prd` 或 `/prd-review`，真正形成决策走 `decisions/`。
5. 可行动的新需求信号必须同步到 `feature-backlog.md`，格式轻量，带 gap/冲突标记和来源链接。

## 文件命名

```text
memory/research/[feature]-[method]-[YYYY-MM-DD].md
```

示例：

```text
memory/research/detail-page-optimization-interviews-2026-06-17.md
```

## 文件模板

```markdown
---
type: user_research
feature: [feature-slug]
product: your-product
research_method: [user_interview|sales_feedback|cs_feedback|survey|meeting_notes|feedback_cluster]
interview_count: [N or omit]
recorded_date: [YYYY-MM-DD]
source: /research
related_prd: [path or omitted]
related_backlog: [path#anchor or omitted]
---

# [功能] - 用户研究结论沉淀

## 分类图例

| 标记 | 含义 |
|------|------|
| ✅ 验证 | 验证当前 PRD 或设计方向 |
| ➕ Gap | PRD 尚未覆盖的新需求 |
| ⚠️ 冲突 | 与当前 PRD、decision 或 facts 冲突，需人工审核 `[CONFLICT]` |
| ❓ 待澄清 | 诉求清楚，但落地方案或优先级待确认 |

## 原始结论

| # | 原始结论 | 分类 | 与 PRD / feature context 的关系 |
|---|---------|------|--------------------------------|
| 1 | ... | ➕ Gap | ... |

## 跨访谈主题归纳

1. ...

## Backlog Signals

- ...

## 需人工审核的冲突 [CONFLICT]

- ...
```

## 写入前预览

除非用户明确要求直接保存，否则先展示：

```markdown
=== Research Capture Preview ===

Research file:
- `memory/research/[feature]-[method]-[date].md`

分类统计:
- ✅ 验证: N
- ➕ Gap: N
- ⚠️ 冲突: N
- ❓ 待澄清: N

Backlog signals:
[1] `feature-backlog.md#[anchor]` -> ...

Feature context link:
[2] `features/[feature]/context.md` -> add/update 用户研究 section

不会直接更新:
- PRD
- facts/
- decisions/
```

用户批准后再写入。
