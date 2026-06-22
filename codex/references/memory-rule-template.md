# Memory Rule Template

Rules in `memory/rules/` are reusable standards that should influence future HiveMind behavior across multiple features or workflows.

## When to Promote a Rule

Promote a candidate to `memory/rules/` only when it meets these criteria:

- It applies across more than one feature or workflow (not just the current task).
- It represents a decision the team would make the same way again in a new context.
- It is concrete enough to constrain future outputs (not a vague preference).

Good candidates from each workflow:

| Workflow | Good Rule Candidates |
|---|---|
| `/prd` | Recurring compliance boundaries, batch operation patterns, metadata field conventions |
| `/prd-review` | Review gate standards, launch readiness checklist items, scope decision principles |
| `/dev` | API naming conventions, permission/audit/rollback checklist items, data contract standards |
| `/ui-draft` | Component selection patterns, state machine design principles, validation rule conventions |
| `/gtm` | Claim evidence requirements, competitive comparison standards, audience language conventions |
| `/email` | External claim rules, launch email structure conventions, template selection logic |

## File Naming

`memory/rules/[category]-[slug].md`

Suggested categories: `product`, `compliance`, `ux`, `engineering`, `gtm`, `email`, `data-contract`, `testing`, `launch`

Examples:
- `memory/rules/compliance-claims.md`
- `memory/rules/engineering-api-contract.md`
- `memory/rules/gtm-competitive.md`
- `memory/rules/ux-batch-operations.md`

## File Template

```markdown
---
type: rule
category: [product|compliance|ux|engineering|gtm|email|data-contract|testing|launch]
source: codex hive-mind
applies_to: [prd|prd-review|dev|ui-draft|gtm|email|all]
updated_date: [YYYY-MM-DD]
status: active
---

# [Rule Title]

## Rule

[One or two sentences stating the rule clearly and actionably.]

## Why

[The reason this rule exists — a past incident, a product constraint, a compliance requirement, or a confirmed team principle.]

## When to Apply

[The workflows, feature types, or contexts where this rule fires. Be specific enough that a future agent can judge whether to apply it.]

## Examples

Good:
- [example that follows the rule]

Avoid:
- [example that violates the rule]

## Exceptions

[Optional. When can this rule be overridden, and by whom?]
```

## Rule Maintenance

- Review rules during periodic `/prd clean` passes.
- Mark outdated rules with `status: archived` rather than deleting them — archived rules still carry useful context about why we tried something and moved on.
- If a rule conflicts with a newer one, mark the older with `[CONFLICT: see memory/rules/[newer-rule].md]` and ask the user to resolve.
