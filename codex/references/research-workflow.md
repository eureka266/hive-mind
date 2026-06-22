# Research Workflow

Use for `/research`, 用户访谈, 需求收集, user research, customer feedback clustering, interview notes, sales/CS feedback, or PRD gap classification.

## Goal

Capture user evidence without turning it into product truth too early. Research is the evidence layer between raw conversations and PRD changes.

## Knowledge Sync

First execute `knowledge-sync.md`, then execute `active-memory.md`.

After sync, load:

- `features/[feature]/context.md` when a feature is known
- relevant PRD from `features/[feature]/prd.md`, `approved-prds/`, `approved_prds/`, or `drafts/`
- `feature-backlog.md`
- existing `memory/research/`
- related `decisions/`, `reviews/`, and `memory/rules/`

## What Belongs Here

Write to `memory/research/` when the source is:

- user interviews
- customer calls
- sales, CS, BD, or solution-engineering feedback
- meeting notes focused on user needs or product gaps
- survey results or feedback clustering
- PRD validation or PRD gap analysis

Do not use `memory/research/` for:

- approved product facts -> `facts/`
- decisions and tradeoffs -> `decisions/`
- reusable rules -> `memory/rules/`
- day-by-day repo timeline -> `memory/journal/`
- one-line idea parking only -> `feature-backlog.md`

## File Naming

Use:

```text
memory/research/[feature]-[method]-[YYYY-MM-DD].md
```

Examples:

- `memory/research/detail-page-optimization-interviews-2026-06-17.md`
- `memory/research/pricing-v3-sales-feedback-2026-06-20.md`

## Required Structure

```markdown
---
type: user_research
feature: [feature-slug]
product: your-product
research_method: [user_interview|sales_feedback|cs_feedback|survey|meeting_notes|feedback_cluster]
interview_count: [N or omit]
recorded_date: [YYYY-MM-DD]
source: codex hive-mind research
related_prd: [path or omitted]
related_backlog: [path#anchor or omitted]
---

# [Feature] - [Research Summary]

## 分类图例

| 标记 | 含义 |
|------|------|
| ✅ 验证 | 验证了当前 PRD 或设计方向 |
| ➕ Gap | PRD 尚未覆盖的新需求 |
| ⚠️ 冲突 | 与当前 PRD、decision 或事实存在分歧，需人工审核 `[CONFLICT]` |
| ❓ 待澄清 | 诉求清楚，但落地方案或优先级待确认 |

## Source Notes

[Keep faithful user conclusions. Omit private customer data and sensitive logs.]

## PRD Gap Classification

| # | 原始结论 | 分类 | 与 PRD / feature context 的关系 |
|---|---------|------|--------------------------------|
| 1 | ... | ➕ Gap | ... |

## Cross-Interview Themes

1. ...

## Backlog Signals

- [marker] [signal] -> `feature-backlog.md#[anchor]`

## [CONFLICT] List

- ...
```

## Maintenance Rules

1. Preserve the user's meaning. Do not polish away the signal.
2. Remove customer-private data, raw sensitive logs, secrets, and unnecessary personal identifiers.
3. Classify each item against the current PRD or feature context with `✅ 验证`, `➕ Gap`, `⚠️ 冲突`, or `❓ 待澄清`.
4. Mark contradictions as `[CONFLICT]` and name the conflicting PRD, decision, fact, or context path.
5. Do not directly update PRDs, facts, or decisions from research. Research can propose changes, not approve them.
6. Net-new actionable demand goes to top-level `feature-backlog.md` as lightweight signals with source links back to `memory/research/`.
7. Feature-specific research should be linked from `features/[feature]/context.md` under a `用户研究` or `User Research` section.
8. If research creates an actual decision after PM review, write that decision to `decisions/` in a separate approved step.

## Output Before Writing

Show a reviewable preview before writing:

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

Will NOT update:
- PRD
- facts/
- decisions/

请审核。输入 all-yes 全部批准，或逐条说明 yes/no/修改内容。
```

Only write after approval unless the user explicitly asks to save directly.

## Write Targets

After approval:

- Create or update `memory/research/[feature]-[method]-[YYYY-MM-DD].md`.
- Create `memory/research/README.md` if missing, describing purpose and format.
- Update `feature-backlog.md` only with lightweight signals for net-new actionable gaps or conflicts.
- Update `features/[feature]/context.md` with links to the research file and backlog group.
- Update `memory/README.md` to list `research/` if missing.

Do not create or append to product-knowledge changelog files.
