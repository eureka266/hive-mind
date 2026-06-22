# PRD Workflow

Use for product discussion, `/prd`, meeting-note extraction, and PRD drafting.

## Modes

- Discussion mode: clarify, discuss, draft, extract knowledge assets.
- Meeting-note mode: extract durable decisions from pasted notes.
- Push/update mode: write approved local changes to the knowledge repo after user approval.

## Phase 0: Hard Discovery

Before free discussion, ask 4 to 6 focused questions. Skip only when the user explicitly asks to skip or provides enough detail.

Core questions:

1. Who is the target user? Include role, permission level, scenario, and frequency.
2. How do they solve this today? Include manual flow, competitor, internal tool, or workaround.
3. Where exactly is the pain? Ask for evidence: time cost, error rate, risk, revenue loss, support burden, or real example.
4. What is the smallest shippable scope? What must be cut from this version?
5. What success metric proves this worked after launch?
6. What is the largest risky assumption? If false, what part of the PRD breaks?

If answers remain vague, push once for specificity. If the user chooses to proceed anyway, mark missing items as `[待确认]`.

Add a discovery block to the draft:

```markdown
## 阶段 0 强制澄清

- 目标用户:
- 现状替代方案:
- 核心痛点证据:
- 最小切口:
- 成功指标:
- 最大风险假设:
- 暂未确认:
```

## Phase 1: Initialize Knowledge Context

First execute `knowledge-sync.md`. The workflow must try to clone or pull `https://github.com/your-org/team-knowledge.git` before loading context.
Then execute `active-memory.md` before drafting or asking follow-up questions.

After sync:

1. Check `git status --short`.
2. Load relevant files from `features/`, `facts/`, `workflows/`, `decisions/`, `decisions/pending-questions/`, `drafts/`, `pending/`, `archive/`, `approved-prds/`, and `approved_prds/`.
3. Load matching `memory/research/`, `memory/rules/`, and resumable `memory/sessions/` notes for the feature.
4. Scan for stale drafts following `active-memory.md` Draft Cleanup Review. If stale drafts exist, ask whether to move them to `approved-prds/`, `pending/`, `archive/`, keep them in `drafts/`, or review later.
5. Scan for `[待确认]`, `[待工程确认]`, and `[CONFLICT]`.
6. Report the active memory summary before continuing discussion.

## Phase 2: Discussion

During free discussion:

- Do not extract and write facts mid-discussion.
- Keep a working draft if the user asks to pause or save.
- Keep approved session memory when the discussion is long, interrupted, or produces reusable decisions.
- Challenge scope, metrics, dependencies, unhappy paths, permissions, and policy boundaries.
- When new unresolved facts appear, mark them as `[待确认]`.

## Phase 3: Extraction

Trigger extraction when the user says `/extract`, "生成 PRD", "开始提取", "讨论好了", or equivalent.

Prepare candidates but do not write files yet:

- Facts: capabilities, limits, supported regions, pricing, API/data constraints, permissions.
- Workflows: states, UI components, transitions, validation, empty/error/loading states.
- Decisions: selected approach, rejected alternatives, tradeoffs, conditions to revisit.
- PRD: markdown using `prd-template.md`.
- Research: user interview or feedback evidence that should be saved to `memory/research/`, with PRD gap classification.
- Memory: session summary, durable rules, and open questions following `active-memory.md`.

Show the candidates in a reviewable list:

```markdown
=== 提取结果 ===

事实候选项（facts/）:
[1] ...

交互定义（workflows/）:
[2] ...

设计决策（decisions/）:
[3] ...

PRD 草稿（drafts/ 或 approved-prds/）:
[4] ...

记忆候选项（memory/）:
[5] ...

用户研究候选项（memory/research/）:
[6] ...

请审核。输入 all-yes 全部批准，或逐条说明 yes/no/修改内容。
```

## Phase 4: Write Approved Files

After approval:

- Create or update `features/[feature]/README.md` as the feature workspace index. Link the PRD, workflow, prototype, dev assets, session memory, open questions, and handoff status when they exist.
- Write drafts to `drafts/[YYYY-MM-DD]-[feature].md` unless the user explicitly says it is approved.
- Write official PRDs to `approved-prds/prd-[feature]-[YYYYMMDD].md` unless the active knowledge repo already uses `approved_prds/`, in which case preserve that convention.
- Move paused or deferred PRDs to `pending/[YYYY-MM-DD]-[feature].md` after approval.
- Move abandoned, superseded, or intentionally closed PRDs to `archive/[YYYY-MM-DD]-[feature].md` after approval.
- Write the primary workflow to `features/[feature]/workflow.yaml`. For legacy compatibility, update `workflows/[feature].yaml` only when the user asks for the old layout or the repo already depends on it.
- Write a lightweight PRD snapshot or link file to `features/[feature]/prd.md` so the workspace is navigable without searching global folders.
- Write decisions to `decisions/decision-[YYYYMMDD]-[feature].md`.
- Update facts in the most relevant `facts/*.md`, preserving existing content and conflict markers.
- Write approved active memory to `memory/sessions/`, `memory/journal/`, or `memory/rules/` according to `active-memory.md`.
- Do not create or append to `changelog/`, `CHANGELOG.md`, or `meta/CHANGELOG.md`. For a high-level record of the approved PRD or knowledge repo change, write an approved summary to `memory/journal/[YYYY-MM-DD].md` instead.

Use structured YAML for workflows:

```yaml
interaction:
  name: "功能名称"
  feature: "feature-name"
  states:
    upload:
      name: "上传"
      display:
        - component: "file_upload"
          name: "csv_file"
          label: "上传 CSV"
      actions:
        - button: "开始检查"
          next_state: "validating"
  flow:
    - from: "upload"
      to: "validating"
      on: "submit"
  validation:
    - field: "csv_file"
      rules:
        - type: "required"
          error: "请先上传 CSV 文件"
```

Commit/push only when the user asked for it and approved the files.

## Meeting-Note Mode

For pasted meeting notes, extract only durable decisions by default.

Keep:

- Architecture, product, and interaction decisions.
- Tradeoffs and selected alternatives.
- Constraints that affect future design.

Skip:

- Open questions.
- Action items.
- Pure scheduling notes.

Write approved output to `decisions/decision-[YYYYMMDD]-[feature]-meeting.md`.
If the meeting reveals reusable rules or resumable context, propose approved memory writes using `active-memory.md`.
