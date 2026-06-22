# PRD Review Workflow

Use for `/prd-review`, PRD critique, product-lead review, CEO-style review, or readiness review.

## Goal

Judge whether the PRD is worth doing, focused enough, shippable, and verifiable. Do not just copyedit.

## Locate Inputs

First execute `knowledge-sync.md`. The workflow must try to clone or pull `https://github.com/your-org/team-knowledge.git` before locating inputs.
Then execute `active-memory.md` to load relevant review, launch, compliance, workflow, and product rules before judging the PRD.

In `~/team-knowledge`, locate the PRD:

- If the user says draft, prefer `drafts/`.
- If the user says approved, prefer `approved-prds/`.
- Otherwise search `drafts/`, then `approved-prds/`, then `ready-to-dev/`.

Also load relevant context:

- `facts/`
- `workflows/[feature].yaml`
- `decisions/`
- latest `reviews/`
- matching `memory/research/`, `memory/rules/`, and `memory/sessions/`

If multiple PRDs match, show candidates and ask the user to choose. If none match, stop and explain the paths checked.

## Review Dimensions

Assess:

- User value: specific user, real pain, current alternative.
- Research evidence: whether `memory/research/` validates the PRD, reveals gaps, creates conflicts, or leaves questions unresolved.
- Scope tradeoff: small MVP, explicit non-goals, postponed abilities.
- Success metrics: behavior, numeric metric, qualitative signal, guardrail.
- Risk assumptions: what breaks if assumptions are false.
- Interaction closure: happy path, unhappy paths, empty/loading/error states, permissions.
- Data and dependencies: API, data source, configuration, operational setup.
- Compliance and security: privacy, audit, false positives, permission abuse, sensitive action.
- Delivery and launch: rollout, rollback, monitoring, support, sales/CS/ops prep.
- Testability: acceptance criteria and edge cases.

Classify findings:

- Blocker: must fix before development or launch.
- Should Fix: should fix in this PRD to reduce rework.
- Can Defer: can postpone if explicitly recorded.

## Alternatives

If the PRD has material scope or solution risk, propose 2 to 3 paths:

```markdown
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

方案 C: 折中路径
- 保留:
- 延期:
- 适合原因:
- 风险:
```

Ask the user to choose a path before writing review files.

## Review Output

After path selection, produce:

```markdown
=== PRD Review 结果 ===

审查对象: [path]
推荐路径: [A/B/C]

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

建议写入 memory/research/ 或 memory/:
[7] ...
```

Ask for approval before writing.

## Files

Write approved review to `reviews/review-[YYYYMMDD]-[feature].md`.

If there are durable decisions, also write `decisions/decision-[YYYYMMDD]-[feature]-review.md` with frontmatter:

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
source: codex hive-mind prd-review
---
```

Only update the PRD itself if the user explicitly approves PRD edits.
Write approved session notes, review journal entries, or reusable review rules to `memory/` according to `active-memory.md`.
