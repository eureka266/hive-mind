# PM Collaborative Memory

This document explains how to adapt the Trellis Codex skill framework into HiveMind's collaborative active memory mechanism. It is intentionally written as an implementation brief that can be handed to another coding agent.

## Trellis Ideas To Reuse

Trellis is useful for HiveMind because it treats memory as an operating loop rather than a static folder:

- Project standards are kept in a spec-like layer and injected into future work.
- Each task has a task workspace so in-progress context does not disappear.
- A workspace journal records what happened over time.
- A finish workflow reviews completed work and promotes durable learnings back into reusable memory.

HiveMind should reuse that loop, but map it to product-management artifacts instead of software tasks.

## HiveMind Mapping

| Trellis concept | HiveMind Codex equivalent | Purpose |
|---|---|---|
| Spec memory | `memory/rules/` | Reusable product, UX, GTM, and engineering handoff rules |
| Task workspace | `features/[feature]/` | One place for each requirement's context, PRD snapshot, workflow, prototype, dev assets, open questions |
| Workspace journal | `memory/journal/` | Chronological summary of meaningful HiveMind sessions |
| Finish workflow | Memory Review Gate | Proactively decide what should be saved, then request approval |
| Task context | `features/[feature]/context.md` and `memory.md` | Resumable discussion state and candidate durable updates |

## Target Knowledge Repo Shape

```text
team-knowledge/
  features/
    csv-import/
      README.md
      context.md
      prd.md
      workflow.yaml
      prototype.html
      dev-assets/
        implementation-plan.md
        api-and-data-contract.md
        test-spec.md
        dev-checklist.md
      memory.md
      open-questions.md
      handoff-status.md
  facts/
  decisions/
  decisions/pending-questions/
  drafts/
  pending/
  archive/
  approved-prds/
  reviews/
  memory/
    rules/
    journal/
    indexes/
```

Keep old folders such as `workflows/`, `dev-assets/`, and `prototypes/` readable for compatibility, but new Codex output should prefer `features/[feature]/`.

Use `drafts/`, `pending/`, `archive/`, and `approved-prds/` as PRD lifecycle lanes:

- `drafts/`: active PRDs still being shaped.
- `pending/`: paused, deferred, blocked, or waiting for owner input.
- `archive/`: abandoned, superseded, duplicate, or intentionally closed.
- `approved-prds/`: approved PRDs that can be referenced as product truth.

## Workflow Behavior

### 1. Start

Every substantive workflow should:

1. Run `knowledge-sync.md`.
2. Run `active-memory.md`.
3. Resolve the feature slug when possible.
4. Load `features/[feature]/` before global folders.
5. Load relevant `memory/rules/`.
6. Report a short memory summary before producing artifacts.

### 2. Work

During PRD, review, dev handoff, UI draft, GTM, or email work, Codex should keep track of:

- New product facts.
- Decisions and rejected alternatives.
- Open PM/engineering/design questions.
- UX/workflow patterns.
- Rules that should affect future HiveMind behavior.
- Temporary details that should not be saved.

### Workflow Coverage

The active-memory entry must be explicit in each workflow document, not only implied by `codex/SKILL.md`. This prevents a future agent from reading a single workflow file and skipping memory setup.

Required coverage:

- `/prd`: run `active-memory.md` after `knowledge-sync.md`; perform Draft Cleanup Review; write feature workspace files after approval.
- `/prd-review`: run `active-memory.md` before judging the PRD; propose reusable review, launch, and UX rules when found.
- `/dev`: run `active-memory.md` before handoff; propose reusable engineering, data-contract, test, rollout, and monitoring rules.
- `/ui-draft`: run `active-memory.md` before reading workflow YAML; write prototypes to `features/[feature]/prototype.html`.
- `/gtm`: run `active-memory.md` before framing positioning; propose reusable claim, competitive, copy, and customer-language rules.
- `/email`: run `active-memory.md` before drafting; run Memory Review after saving assets when reusable claim, launch, or customer-communication rules emerge.

### 3. Finish

Before finalizing any substantive workflow, Codex should run a Memory Review Gate:

```markdown
=== Memory Review ===

Should save: yes
Reason: 本次讨论确认了一个跨功能产品规则，会影响未来 PRD、GTM 和 email claim。

Feature workspace updates:
[1] features/csv-import/context.md -> ...
[2] features/csv-import/prototype.html -> ...

Durable product memory:
[3] memory/rules/product-claims.md -> ...
[4] decisions/decision-20260609-csv-import.md -> ...

Open questions:
[5] features/csv-import/open-questions.md -> ...

Not saved:
- 临时排期讨论
- 未确认竞品猜测
```

Codex should write only approved updates.

### 4. Draft Cleanup

Trellis-style memory should surface stale work, not just save new work. During PRD workflows and `/prd clean`, Codex should inspect `drafts/` for files that have not changed recently.

Recommended default:

- 14+ days untouched: ask whether the draft is still active.
- 30+ days untouched: strongly recommend `pending/` or `archive/` unless the PM confirms it is still active.

Codex should ask the user to choose one of:

- Move to `approved-prds/` if the PRD is truly approved.
- Move to `pending/` if it is deferred, blocked, or waiting for a decision.
- Move to `archive/` if it is abandoned, superseded, or duplicated.
- Keep in `drafts/` if active work will continue soon.
- Review later if the user is not ready.

No movement should happen without approval.

## Why Feature Workspace Matters

For your product, a requirement is rarely just a PRD. It usually has:

- User context.
- Workflow YAML.
- Prototype HTML.
- Review notes.
- Engineering questions.
- API/data/test handoff.
- GTM or customer-facing claim constraints.

Putting the HTML prototype in `features/[feature]/prototype.html` keeps it next to the workflow and PRD context. This is better than a global `prototypes/` folder because PM, design, frontend, QA, and sales can all open one feature workspace and understand the current state.

## Guardrails

- Never silently promote conversation into long-term memory.
- Always classify memory as feature context, fact, decision, rule, journal, or open question.
- Mark uncertain items `[待确认]`.
- Mark engineering-dependent items `[待工程确认]`.
- Mark contradictions `[CONFLICT]`.
- Do not store secrets, customer-private data, or sensitive logs.
- Prefer source-linked claims for GTM and email outputs.

## Codex Files To Update

Already covered or expected in Codex:

- `codex/SKILL.md`
- `codex/references/knowledge-sync.md`
- `codex/references/active-memory.md`
- `codex/references/prd-workflow.md`
- `codex/references/prd-review-workflow.md`
- `codex/references/dev-workflow.md`
- `codex/references/ui-draft-workflow.md`
- `codex/references/gtm-workflow.md`
- `codex/references/email-workflow.md`

Recommended next additions:

- `codex/references/feature-workspace-template.md`
- `codex/references/memory-rule-template.md`
- `codex/references/memory-review-workflow.md`

Those can stay separate if the team wants more explicit templates, but the core behavior should remain centralized in `active-memory.md`.
