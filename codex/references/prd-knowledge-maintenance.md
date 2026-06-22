# PRD Knowledge Maintenance

Use this for `/prd research`, `/prd review`, `/prd docs`, `/prd prompt`, `/prd competitor`, `/prd interactions`, `/prd assets scan`, and `/prd clean`.

These are product-manager-owned knowledge maintenance modes. They share one `/prd` namespace because they all maintain the product knowledge base, but each mode has a typed destination and different approval rules.

Compatibility aliases remain valid:

- `/research` -> `/prd research`
- `/prd-review` -> `/prd review`

## Command Map

| Command | Primary user | Purpose | Writes |
|---|---|---|---|
| `/prd [feature]` | PM | Discuss a product idea and create/update PRD artifacts | `features/`, `drafts/`, `approved-prds/`, `facts/`, `decisions/`, `workflows/`, `memory/` |
| `/prd research [feature]` | PM, user researcher, review owner | Capture user interviews, customer feedback, and PRD gap evidence | `memory/research/`, `feature-backlog.md`, `features/[feature]/context.md`, `memory/README.md` |
| `/prd review [feature]` | PM lead, review owner | Review PRD value, scope, metrics, risks, and readiness | `reviews/`, `decisions/`, `memory/rules/` when approved |
| `/prd docs [topic]` | PM, customer support PM, growth PM | Maintain the customer-facing AI assistant RAG knowledge | `customer-knowledge/` only, plus source links to `facts/`, PRDs, decisions, and docs |
| `/prd prompt [prompt-name]` | PM, AI product owner | Maintain the customer-facing AI assistant or pricing advisor prompt assets | `prompts/`, with test examples and source paths |
| `/prd competitor [vendor/topic]` | PM, GTM PM, sales enablement PM | Maintain competitor research and claim boundaries | `competitors/`, optionally `memory/rules/` for reusable claim rules |
| `/prd interactions [feature]` | PM, UX PM | Maintain or migrate legacy interaction records | Prefer `features/[feature]/workflow.yaml`; read legacy `interactions/` and `workflows/` |
| `/prd assets scan` | PM, content/GTM PM | Refresh asset inventory from PRDs and competitor notes | `assets-index.md`; use `scripts/scan-assets.py` when available |
| `/prd clean` | PM repo maintainer | Clean stale drafts, indexes, old aliases, and deprecated paths | `pending/`, `archive/`, `memory/journal/`, README/index files |

## Routing Rules

1. If the request is about creating or changing a product requirement, use `/prd [feature]`.
2. If the source is interviews, customer calls, sales/CS feedback, or feedback clustering, use `/prd research`.
3. If the target is `customer-knowledge/`, use `/prd docs`. All generated content under this path must be English.
4. If the target is `prompts/`, use `/prd prompt`. Include expected inputs, outputs, examples, failure cases, and source paths.
5. If the target is `competitors/`, use `/prd competitor`. Record source, observed date, confidence, and what claims are safe to reuse.
6. If the target is legacy `interactions/`, prefer migration into `features/[feature]/workflow.yaml` unless the user explicitly asks to keep a legacy file.
7. If the request is repo cleanup, stale drafts, deprecated folders, index refresh, or directory consistency, use `/prd clean`.

## Write Discipline

- Always run `knowledge-sync.md` and `active-memory.md` first.
- Preview writes before changing files unless the user explicitly asks to write directly.
- Keep facts, decisions, research, customer-facing knowledge, and prompts separate.
- Never let `customer-knowledge/` inherit internal-only facts, draft PRDs, competitor attack language, or decision rationale.
- Preserve the user's own product, feature, and API names exactly as they appear in the knowledge base.
- Mark uncertain items as `[待确认]`; mark contradictions as `[CONFLICT]`.

## Mode-Specific Rules

### `/prd docs`

Use when maintaining the customer-facing AI assistant user-facing knowledge:

- Content must be English.
- Write user-facing FAQ, user manual, pricing, API doc, and product know-how.
- Do not include internal pricing strategy, roadmap rationale, draft features, private customer data, competitor attack language, or implementation details.
- Cite source paths from `facts/`, `approved-prds/`, `decisions/`, `features/`, or external docs when known.
- If source evidence is insufficient, write `[待确认]` in the preview and ask before saving.

### `/prd prompt`

Use when maintaining AI product prompts:

- Write the prompt objective, input contract, output contract, examples, refusal/uncertainty behavior, and test cases.
- Link to supporting product facts and customer-facing knowledge files.
- Treat prompt changes as behavior changes. Preview sample before/after outputs when possible.
- Do not bury product facts inside prompts if they belong in `facts/` or `customer-knowledge/`.

### `/prd competitor`

Use when maintaining competitor notes:

- Record vendor/topic, source URL or meeting source, observed date, confidence, and summary.
- Separate observed facts from interpretation.
- Add a "Reusable Claims" section only for claims that can be safely used by `/gtm` or `/email`.
- Mark outdated or conflicting notes with `[CONFLICT]` instead of overwriting silently.

### `/prd interactions`

Use when maintaining legacy interaction records:

- Prefer `features/[feature]/workflow.yaml` for new interaction definitions.
- Use `interactions/` only as a legacy source or when the user explicitly asks for that path.
- If migrating, keep source links and note the migration in `features/[feature]/context.md` or `memory/journal/`.

### `/prd assets scan`

Use when refreshing asset inventory:

- Prefer existing scripts such as `scripts/scan-assets.py`.
- Preview what paths will be scanned and what `assets-index.md` entries will change.
- Do not invent asset metadata. Mark missing title, source, or status as `[待确认]`.

### `/prd clean`

Use when cleaning the knowledge repo:

- Scan stale `drafts/`, deprecated changelog files, duplicate PRD aliases, legacy prototypes/workflows, and missing README/index entries.
- Suggest moves to `pending/` or `archive/`; do not delete product knowledge by default.
- Write a short summary to `memory/journal/[YYYY-MM-DD].md` when cleanup changes repository structure.
- Do not rewrite unrelated content while cleaning.
