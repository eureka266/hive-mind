# Memory Review Workflow

Use this at the end of any substantive HiveMind workflow before writing final artifacts. This is the implementation of the Memory Review Gate described in `active-memory.md`.

## When to Run

Run Memory Review after completing any of these workflows:
- `/prd` — after阶段6 (auto-commit), before confirming done
- `/research` — after research capture, before writing research/backlog/context updates
- `/prd-review` — before阶段5 (write to knowledge base)
- `/dev` — after阶段4 (generate assets), before writing files
- `/ui-draft` — after prototype generation
- `/gtm` — after阶段5 output
- `/email` — after阶段5 (save assets)

## Decision Logic

Before showing the Memory Review block, decide:

1. Was there any new durable learning in this session?
   - New product constraint, compliance boundary, or pricing fact → `facts/`
   - Design decision with rejected alternatives → `decisions/`
   - User research, interview findings, or PRD gap evidence → `memory/research/`
   - Reusable standard that should influence future workflows → `memory/rules/`
   - Feature context that helps resume work → `features/[feature]/context.md` or `memory.md`
   - Unresolved question needing an owner → `features/[feature]/open-questions.md` or `decisions/pending-questions/`

2. Was anything discussed that should NOT be saved?
   - Temporary scheduling discussion
   - Unconfirmed competitive guesses
   - Sensitive customer data (never save — store only the product-relevant conclusion)
   - Pure drafting / exploratory thinking that didn't reach a decision
   - Duplicates of existing memory

If nothing durable emerged: show the short no-save decision.

## Output Formats

### When there is something to save

```markdown
=== Memory Review ===

Should save: yes
Reason: [why this affects future PM work — be specific]

Feature workspace updates:
[1] features/[feature]/context.md -> [what changes]
[2] features/[feature]/memory.md -> [session summary]
[3] features/[feature]/handoff-status.md -> [new status]

Durable product memory:
[4] facts/[file].md -> [new fact description]
[5] decisions/decision-[date]-[feature].md -> [decision summary]
[6] memory/research/[feature]-[method]-[date].md -> [research evidence and PRD gap classification]
[7] memory/rules/[category].md -> [rule description]

Open questions:
[8] features/[feature]/open-questions.md -> [question]
[9] decisions/pending-questions/[date]-[feature].md -> [question with owner]

Not saved:
- [reason: temporary / unconfirmed / sensitive / duplicate]

请审核。输入 all-yes 全部批准，或逐条说明 yes/no/修改内容。
```

### When nothing should be saved

```
Memory Review: no durable update recommended.
Reason: [pure drafting / temporary preference / duplicate of existing memory / not confirmed]
```

## Classification Rules

| Candidate Type | Where to Write |
|---|---|
| Resumable feature context | `features/[feature]/context.md` |
| Session summary and candidate learnings | `features/[feature]/memory.md` |
| Lifecycle state change | `features/[feature]/handoff-status.md` |
| Unresolved PM question | `features/[feature]/open-questions.md` |
| Unresolved engineering question | `decisions/pending-questions/[date]-[feature]-engineering.md` |
| Stable product capability or limit | `facts/[product].md` |
| Design decision with alternatives | `decisions/decision-[date]-[feature].md` |
| User research, interview finding, feedback cluster, or PRD gap evidence | `memory/research/[feature]-[method]-[YYYY-MM-DD].md` |
| Lightweight actionable signal from research | `feature-backlog.md` with a source link to `memory/research/` |
| Reusable cross-feature rule | `memory/rules/[category]-[slug].md` |
| Session journal entry | `memory/journal/[YYYY-MM-DD].md` |

## After Approval

Write only items the user approved. Then:

1. For feature workspace updates: create `features/[feature]/` directory if it does not exist.
2. For memory rules: follow the template in `memory-rule-template.md`.
3. For facts and decisions: ensure YAML frontmatter is present (see `prd-workflow.md` for field definitions).
4. Include these files in the next `git add` and `git commit`.

## Conflict Handling

If a new memory candidate conflicts with existing content:

- Mark the candidate with `[CONFLICT]`.
- Name the conflicting file and summarize both versions.
- Ask the user which version survives before writing anything.
- Do not overwrite silently.
