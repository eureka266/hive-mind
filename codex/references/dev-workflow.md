# Dev Workflow

Use for `/dev`, engineering handoff, ready-to-dev assets, technical questions, or engineering challenge.

## Scope

`dev` does not judge whether the product is worth doing. That is PRD review. It answers whether the PRD is implementable, how to split it, what contracts are needed, and what to test.

## Locate Inputs

First execute `knowledge-sync.md`. The workflow must try to clone or pull `https://github.com/your-org/team-knowledge.git` before locating inputs.
Then execute `active-memory.md` to load reusable engineering handoff, test, data-contract, launch, and compliance rules.

In `~/team-knowledge`:

- Default source: `ready-to-dev/[feature].md`.
- Fallback: latest matching `approved-prds/*.md`.
- If the user says `--from-approved`, prefer `approved-prds/`.

Load related:

- `facts/`, especially `[待工程确认]`.
- `workflows/[feature].yaml`.
- `decisions/`.
- Latest `reviews/`.
- Matching `memory/rules/` and prior `memory/sessions/` notes.

If no PRD exists, ask the user to provide one or run the PRD workflow.

## Engineering Confirmation

If `[待工程确认]` items exist, surface them first:

```markdown
发现 N 条待工程确认项：
[1] ...
[2] ...

请选择：逐条确认 / 跳过并保留标记 / 停止补 PRD
```

Do not silently remove pending markers.

## Generate Dev Assets

Create four documents under `features/[feature]/dev-assets/` after approval.

Legacy fallback: if the knowledge repo has no `features/[feature]/` workspace and the user asks to preserve the old structure, write under `dev-assets/[feature]/`.

1. `implementation-plan.md`
   - Phased implementation plan.
   - Frontend, backend, data, permission, configuration splits.
   - Dependencies and blockers.
   - Rollout, rollback, monitoring.

2. `api-and-data-contract.md`
   - Suggested endpoints.
   - Request/response fields.
   - Data sources and state transitions.
   - Permissions, audit, error codes.

3. `test-spec.md`
   - Main flow tests.
   - Boundary and error scenarios.
   - Permission, compliance, and security tests.
   - State-machine tests from `workflows/*.yaml`.

4. `dev-checklist.md`
   - Executable checklist.
   - PRD alignment items.
   - Code, tests, launch, monitoring, docs.

Default to documents, not code, unless the user identifies a target codebase and asks for implementation.

Also propose active memory updates when the handoff creates reusable engineering rules, rollout lessons, or unresolved questions that should survive beyond the four dev asset files.

## Preview Before Write

Show a concise preview:

```markdown
=== Dev 资产预览 ===

实现方案:
[1] ...

API / 数据契约:
[2] ...

测试规格:
[3] ...

开发检查清单:
[4] ...

记忆候选项:
[5] ...
```

Ask whether to write `features/[feature]/dev-assets/`.

## Engineering Questions Mode

Use when an engineer wants to record questions for PM.

Collect questions with priority:

- 阻塞: cannot start without answer.
- 重要: affects architecture or estimate.
- 可选: useful but not blocking.

After approval, write to `decisions/pending-questions/[YYYYMMDD]-[feature]-engineering-questions.md`:

```yaml
---
type: pending_questions
feature: [feature-name]
authored_by: engineering
audience:
  - pm
  - engineering
created_date: [YYYY-MM-DD]
source: codex hive-mind dev-ask
---
```

## Engineering Challenge Mode

Use when engineering wants to challenge the PRD before build.

Assess:

- Feasibility.
- Data contract clarity.
- Performance and scale.
- Permissions and security.
- Testability.
- Launch risk.

Write approved durable conclusions to `decisions/decision-[YYYYMMDD]-[feature]-engineering-challenge.md`.
If the challenge reveals reusable rules or repeated engineering constraints, propose writes to `memory/rules/` using `active-memory.md`.
