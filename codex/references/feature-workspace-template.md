# Feature Workspace Template

Every feature in `features/[feature]/` follows this structure. Codex should create or update these files during the relevant workflow phases.

## Directory Layout

```text
features/
  [feature-slug]/
    README.md           — one-paragraph overview: what this feature does, current status, owner
    context.md          — current understanding, scope, assumptions, links to official artifacts
    prd.md              — feature-local PRD copy (synced from approved-prds/ when approved)
    workflow.yaml       — feature-local interaction definition (primary source for /ui-draft)
    prototype.html      — clickable HTML prototype (primary output of /ui-draft)
    open-questions.md   — unresolved PM, engineering, design, compliance, GTM questions
    handoff-status.md   — current lifecycle state
    memory.md           — short session notes and candidate durable learnings
    dev-assets/
      implementation-plan.md
      api-and-data-contract.md
      test-spec.md
      dev-checklist.md
```

## File Templates

### context.md

```markdown
---
type: feature_context
feature: [feature-slug]
source: codex hive-mind
updated_date: [YYYY-MM-DD]
status: [active|approved|archived]
---

# [Feature Name] — Context

## Current Understanding

[One paragraph describing what we know about this feature's scope, user value, and constraints.]

## Scope

- In scope:
- Out of scope:
- Deferred:

## Key Assumptions

- [assumption 1] [待确认]
- [assumption 2]

## Links to Official Artifacts

- PRD: `approved-prds/...`
- Review: `reviews/...`
- Decisions: `decisions/...`
- Workflow: `features/[feature]/workflow.yaml`
```

### memory.md

```markdown
---
type: feature_memory
feature: [feature-slug]
source: codex hive-mind
updated_date: [YYYY-MM-DD]
status: active
---

# [Feature Name] — Session Memory

## Session Notes

### [YYYY-MM-DD] — [workflow that ran]

[2-3 sentence summary of what was discussed or decided. Include any candidate durable learnings not yet promoted to memory/rules/.]

## Candidate Memory Updates

- [ ] [candidate rule or fact — waiting for approval to promote to memory/rules/ or facts/]
```

### open-questions.md

```markdown
---
type: pending_questions
feature: [feature-slug]
source: codex hive-mind
updated_date: [YYYY-MM-DD]
---

# [Feature Name] — Open Questions

## PM Questions [待确认]

- [ ] ...

## Engineering Questions [待工程确认]

- [ ] ...

## Design Questions

- [ ] ...

## Compliance / Legal Questions

- [ ] ...
```

### handoff-status.md

```markdown
---
type: feature_context
feature: [feature-slug]
source: codex hive-mind
updated_date: [YYYY-MM-DD]
---

# [Feature Name] — Handoff Status

## Current Status

- [ ] draft
- [ ] reviewed
- [ ] ready-to-dev
- [ ] blocked
- [ ] in-development
- [ ] shipped

## Blockers

- [None]

## Last Activity

- [YYYY-MM-DD] [workflow] — [one line summary]
```

## Creation Rules

- Create `features/[feature]/` only after user approves the first write from any workflow.
- Never create feature workspace files silently — always show what will be written in Memory Review before writing.
- When migrating from legacy structure (`workflows/`, `dev-assets/`, `prototypes/`), keep the legacy copy for compatibility.
- Prefer `git mv` when relocating legacy files to preserve git history.
