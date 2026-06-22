# Active Memory Protocol

Use this protocol for every substantive HiveMind Codex workflow that reads, discusses, reviews, or writes product knowledge.

This protocol adapts Trellis' core memory loop to HiveMind:

- Trellis `spec/` -> HiveMind `memory/rules/`: reusable standards, policies, review rules, UX rules, GTM claim rules, engineering handoff rules.
- Trellis `tasks/` -> HiveMind `features/[feature]/`: one feature workspace containing the working context and all feature-local assets.
- Trellis `workspace/` journal -> HiveMind `memory/journal/`: chronological summaries of meaningful work.
- Trellis finish workflow -> HiveMind Memory Review Gate: at the end of a workflow, proactively decide what should become memory, then ask for approval before writing.

The goal is proactive memory, not silent memory. Codex should notice durable learnings, classify them, and propose memory updates. It must not silently promote unapproved discussion into long-term product truth.

## Directory Model

Use the default knowledge repo from `knowledge-sync.md`.

Preferred new structure:

```text
features/
  [feature]/
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
memory/
  rules/
  journal/
  research/
  indexes/
```

Legacy compatibility:

- Continue reading `drafts/`, `pending/`, `archive/`, `approved-prds/`, `workflows/`, `dev-assets/`, and `prototypes/`.
- For new Codex work, write feature-local assets under `features/[feature]/`.
- Use legacy global folders for official archive copies when the workflow already requires them, such as `approved-prds/`, `reviews/`, `decisions/`, and `facts/`.

## Start Of Workflow

After executing `knowledge-sync.md`:

1. Resolve the feature slug if the request is feature-specific.
2. Load feature workspace context first when present:
   - `features/[feature]/README.md`
   - `features/[feature]/context.md`
   - `features/[feature]/memory.md`
   - `features/[feature]/workflow.yaml`
   - `features/[feature]/open-questions.md`
   - `features/[feature]/handoff-status.md`
3. Load relevant global product context:
   - `facts/`
   - `decisions/`
   - `decisions/pending-questions/`
   - `drafts/`
   - `pending/`
   - `archive/`
   - `approved-prds/`
   - `reviews/`
   - legacy `workflows/`, `dev-assets/`, `prototypes/` when no feature workspace exists
4. Load relevant rules from `memory/rules/`.
5. Load relevant user research from `memory/research/` when the request is feature-specific, mentions user interviews, feedback, research, PRD gaps, or touches an existing PRD.
6. Report a concise memory summary:

```markdown
Memory loaded:
- Feature workspace: [found / not found / created after approval]
- Product context: [facts, decisions, PRDs, reviews, workflows]
- Research context: [N files / none]
- Active rules: [N]
- Open questions: [N]
- Legacy assets used: [yes/no]
```

## During Workflow

Maintain feature-local working memory when any of these are true:

- The conversation spans multiple decisions, user roles, or artifacts.
- The user asks to pause, resume, save context, or continue later.
- New durable facts, constraints, rejected alternatives, or open questions appear.
- A workflow generates or updates PRD, workflow YAML, prototype, dev assets, GTM, or email assets.

Preferred feature-local files:

- `features/[feature]/context.md`: current understanding, scope, assumptions, links to official artifacts.
- `features/[feature]/memory.md`: short session notes and candidate durable learnings.
- `features/[feature]/open-questions.md`: unresolved PM, engineering, design, or GTM questions.
- `features/[feature]/handoff-status.md`: current state such as draft, reviewed, ready-to-dev, blocked, shipped.

Do not write these files before user approval unless the user explicitly asks to save context or the workflow has reached an approved write phase.

## Memory Review Gate

At the end of any substantive workflow, before the final response, proactively decide whether memory should be updated.

Show this block when there is anything worth saving:

```markdown
=== Memory Review ===

Should save: [yes/no]
Reason: [why this affects future PM work]

Feature workspace updates:
[1] features/[feature]/context.md -> ...
[2] features/[feature]/memory.md -> ...
[3] features/[feature]/prototype.html -> ...

Durable product memory:
[4] facts/... -> ...
[5] decisions/... -> ...
[6] memory/rules/... -> ...

Open questions:
[7] decisions/pending-questions/... or features/[feature]/open-questions.md -> ...

Not saved:
- [temporary scheduling / unconfirmed guess / sensitive detail / duplicate]

请审核。输入 all-yes 全部批准，或逐条说明 yes/no/修改内容。
```

Show a short no-save decision when nothing should be saved:

```markdown
Memory Review: no durable update recommended.
Reason: [pure drafting / temporary preference / duplicate of existing memory / not confirmed]
```

Only write approved updates.

## Classification Rules

Classify memory candidates this way:

- `features/[feature]/context.md`: feature-local context that helps resume work.
- `features/[feature]/memory.md`: session summary, important discussion turns, candidate future updates.
- `features/[feature]/workflow.yaml`: feature-local interaction definition.
- `features/[feature]/prototype.html`: feature-local clickable prototype.
- `features/[feature]/dev-assets/*`: feature-local engineering handoff.
- `facts/*.md`: stable product capabilities, limits, pricing, supported regions, data/API constraints.
- `decisions/*.md`: why the team chose an approach or rejected alternatives.
- `decisions/pending-questions/*.md`: unanswered PM or engineering questions that need an owner.
- `drafts/*.md`: active PRD drafts that still need discussion or extraction.
- `pending/*.md`: paused or deferred PRDs that may be revisited.
- `archive/*.md`: abandoned, superseded, or intentionally closed PRDs and feature notes.
- `memory/rules/*.md`: reusable standards or principles that should influence future HiveMind behavior.
- `memory/journal/*.md`: chronological record of meaningful HiveMind sessions.
- `memory/research/*.md`: user research, interview findings, feedback clustering, and PRD gap evidence. Store raw user conclusions and classification here, not approved product truth.
- `feature-backlog.md`: lightweight follow-up signals distilled from research. Every backlog signal created from research must link back to the source `memory/research/*.md` file.

Deprecated destination:

- Do not write knowledge-base updates to `changelog/`, `CHANGELOG.md`, or `meta/CHANGELOG.md` by default. The global changelog is a deprecated historical archive. Use `memory/journal/` for cross-feature timeline notes, `decisions/` for rationale, and `features/[feature]/` for feature-local status.

## Draft Cleanup Review

Trellis-style memory should also keep stale work visible. During PRD, review, dev handoff, or explicit `/prd clean` work, scan `drafts/` for old files when tools allow modification-time inspection.

Default stale threshold:

- 14+ days since last modified: ask whether the draft is still active.
- 30+ days since last modified: strongly suggest moving to `pending/` or `archive/` unless the user confirms it is active.

When stale drafts are found, show:

```markdown
=== Draft Cleanup Review ===

发现长期未更新的 drafts:
[1] drafts/prd-csv-import.md
    Last modified: [date]
    Suggested action: approve / pending / archive
    Reason: [ready-looking / deferred / stale / superseded]

请选择：
- move to approved-prds/
- move to pending/
- move to archive/
- keep in drafts/
- review later
```

Rules:

- Move to `approved-prds/` only when the user confirms the PRD is approved or ready for formal approval.
- Move to `pending/` when the need is valid but paused, deferred, blocked, or waiting for owner input.
- Move to `archive/` when the need is abandoned, superseded, duplicated, or no longer relevant.
- Keep in `drafts/` only when active work is expected soon.
- Never move files silently. Always ask first.
- When moving, preserve git history with `git mv` if possible.
- Add a short status note in `features/[feature]/handoff-status.md` or `memory/journal/[YYYY-MM-DD].md` when a stale draft is moved.

## Rule Promotion Criteria

Promote a candidate to `memory/rules/` only when it is reusable across future work.

Good rule candidates:

- Recurring product policy.
- Product boundary or customer-claim constraint.
- AI insight presentation rule, such as separating facts, inference, and recommendation.
- Batch operation pattern, such as row limits, partial success, retry, and export semantics.
- Engineering handoff rule, such as always specifying permissions, audit, monitoring, and rollback.
- GTM rule, such as unverified competitive claims must be marked `[待确认]`.

Keep one-off feature details out of `memory/rules/`; put them in feature workspace, facts, decisions, or workflows.

## Conflict Handling

If new information conflicts with existing memory or product facts:

- Mark the candidate with `[CONFLICT]`.
- Name the conflicting file path.
- Summarize both versions.
- Ask the user which version survives.
- Do not overwrite the older item silently.

## Research Evidence Handling

Use `memory/research/` when the source is user interviews, customer calls, sales/CS feedback, meeting notes focused on user needs, survey results, or feedback clustering.

Research files should:

- Use `[feature]-[method]-[YYYY-MM-DD].md` naming.
- Include frontmatter: `type: user_research`, `feature`, `product`, `research_method`, `recorded_date`, `source`, and related PRD/backlog paths when known.
- Preserve user conclusions faithfully, but omit customer-private data, raw sensitive logs, secrets, and unnecessary personal identifiers.
- Classify each item against the current PRD or feature context with `✅ 验证`, `➕ Gap`, `⚠️ 冲突`, or `❓ 待澄清`.
- Mark conflicts with `[CONFLICT]` and name the PRD, decision, or context file that conflicts.

Research files must not directly update `facts/`, `approved-prds/`, or `decisions/`. After research is reviewed:

- Net-new actionable signals -> add lightweight entries to top-level `feature-backlog.md` with gap/conflict markers and source links.
- Feature-specific research -> add or update a `用户研究` / `User Research` section in `features/[feature]/context.md` linking to the research file and backlog group.
- Durable decisions made after reviewing research -> write to `decisions/`.
- Reusable research or product rules -> propose `memory/rules/`.

## Privacy And Source

Every memory file should include frontmatter when practical:

```yaml
---
type: [feature_context|feature_memory|rule|journal|pending_questions]
feature: [feature-slug]
source: codex hive-mind
updated_date: [YYYY-MM-DD]
status: [active|approved|archived]
---
```

Do not store secrets, credentials, private customer data, or pasted sensitive logs in memory. Store the product-relevant conclusion instead and note that sensitive details were omitted.
