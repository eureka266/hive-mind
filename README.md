<div align="center">

<img src="./docs/assets/hivemind-title.png" alt="HiveMind" width="600" />

**Turn every product discussion into a structured, version-controlled, team-shared knowledge base.**

A two-hour meeting ends, conclusions live in a few heads. Three weeks later, nobody remembers *why* you cut that approach. New hires can't piece together the "why" from scattered chats and agreements.

**Discussions are real-time; knowledge leaks away.** HiveMind captures it: every product chat becomes traceable, durable, reusable facts, decisions, and workflows — versioned in Git, shared with your team.

[中文](./README.zh.md) • [GitHub](https://github.com/eureka266/hive-mind) • [Use Cases](./docs/use-cases.md)

[![install](https://img.shields.io/badge/install-npx%20skills%20add-000000?style=flat-square)](https://github.com/eureka266/hive-mind)
[![GitHub Stars](https://img.shields.io/github/stars/eureka266/hive-mind?style=flat-square&color=eab308)](https://github.com/eureka266/hive-mind/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/eureka266/hive-mind?style=flat-square&color=3b82f6)](https://github.com/eureka266/hive-mind/network/members)
[![Last Commit](https://img.shields.io/github/last-commit/eureka266/hive-mind?style=flat-square&color=6b7280)](https://github.com/eureka266/hive-mind/commits)
[![License: MIT](https://img.shields.io/badge/License-MIT-green?style=flat-square)](./LICENSE)

</div>

---

## Core Capabilities

| Capability | Effect |
|------------|--------|
| **Auto-extract discussions** | `/prd` chat about needs → AI auto-splits into facts, decisions, workflows. No manual spec writing. Inspired by [gstack](https://github.com/garrytan/gstack). |
| **Structured knowledge base** | All outputs land in Git repo (`facts/`, `decisions/`, `features/`, `memory/`, etc.) — versioned, traceable, team-shared. |
| **Proactive memory** | Auto-load related rules and decisions before discussion. Auto-suggest which rules to save after. Inspired by [Trellis](https://github.com/mindfold-ai/trellis). |
| **Complete workflow** | From discussion to PRD, review, prototype, dev handoff, GTM content, email — end-to-end. |
| **Team sharing** | Knowledge base is your own private Git repo. Team clones it, and every decision, rule, and history is there. New hires onboard 3x faster. |

## Quick Start

**Prerequisites**
- [ ] **Node.js** (with `npx`) — to install: `node -v`
- [ ] **Git** 2.20+ — knowledge base uses Git: `git --version`
- [ ] **Claude Code or Codex** — either works

**Install**
```bash
npx skills add eureka266/hive-mind
```

Works with both **Claude Code** and **Codex** right away. Talk naturally and HiveMind listens.

> Want native slash commands (`/prd`, `/dev`, `/ui-draft`), auto-update, and team setup? See [Team Setup](#team-setup-optional) below.

## How your team uses it

**Product Manager**
```
/prd bulk-import feature              # discuss requirements → AI extracts facts, decisions, workflows
/prd review payment-flow              # PRD review: challenge scope, premises, and "6-month regret" risks
/prd research why users churn in March # synthesize analytics, support tickets, and interview notes
/prd docs export-feature              # generate user-facing help docs from PRD
/prd competitor chainalysis           # structured competitive analysis saved to knowledge base
```

**Engineer**
```
/dev bulk-import                      # generate handoff: implementation plan, API contracts, test specs, checklist
/dev bulk-import challenge            # adversarial review: find edge cases and missing error handling
```

**Designer**
```
/ui-draft payment flow optimization   # turn interaction discussion into a clickable single-file HTML prototype
/ui-draft bulk-import --figma         # generate prototype and sync frames to Figma
```

**Marketing / GTM**
```
/gtm how we compare to competitors    # generate positioning doc, sales talk tracks, one-pagers
/email product-update May             # draft product update email as ready-to-send HTML
/email free-user-upgrade-nudge        # trigger-based email: quota warning, upsell copy
```

Natural language also works: "let's discuss bulk import", "extract the key decisions from that meeting", "write a product blog post from the knowledge base".

## What your knowledge base looks like after a few months

Every HiveMind command writes into a structured Git repo. Here's what a real product team's knowledge base looks like after steady use:

```
team-knowledge/
│
├── facts/                          # Authoritative product truth (human-maintained)
│   ├── your-product.md             #   Feature boundaries, limits, confirmed behaviors
│   ├── glossary.md                 #   Shared terminology — prevents naming drift
│   ├── guardrails.md               #   What AI must never claim (unshipped features, etc.)
│   ├── customer-profiles.md        #   Target segments and ICP definitions
│   └── internal/                   #   Internal impl details (never used in external copy)
│
├── features/                       # One workspace per feature — all context in one place
│   ├── bulk-import/
│   │   ├── README.md               #   Entry point, links to all artifacts
│   │   ├── prd.md                  #   /prd → full PRD with facts, scope, open questions
│   │   ├── workflow.yaml           #   /prd → state machine, components, validation rules
│   │   ├── bulk-import-prototype.html  # /ui-draft → clickable single-file prototype
│   │   ├── dev-assets/             #   /dev → impl plan, API contracts, test specs, checklist
│   │   ├── memory.md               #   Session summary + candidate rules to promote
│   │   ├── open-questions.md       #   Unresolved items for PM / eng / design sign-off
│   │   └── handoff-status.md       #   Current state: draft | pending | ready-to-dev | shipped
│   ├── pricing-v3/
│   │   ├── prd.md
│   │   ├── sub-prds/               #   Complex features get sub-PRDs per component
│   │   │   ├── pricing-page.md
│   │   │   ├── checkout.md
│   │   │   ├── billing.md
│   │   │   ├── quota-enforcement.md
│   │   │   ├── migration.md
│   │   │   └── email-triggers.md
│   │   └── prototypes/
│   └── monitor-upsell/
│       ├── prd.md
│       ├── workflow.yaml
│       └── monitor-upsell-prototype.html
│
├── decisions/                      # Auto-generated after every /prd session
│   ├── decision-20260617-bulk-import-limits.md     # What was decided + why + assumptions
│   ├── decision-20260423-monitor-upsell-layers.md  # Alternatives considered, rationale
│   └── decision-20260521-pricing-terminology.md    # Naming choices, definitions locked
│
├── memory/                         # Proactive memory — promoted from session reviews
│   ├── rules/
│   │   ├── pm-process.md           #   Cross-feature PM process rules
│   │   ├── product-facts-pricing.md #  Pricing policy rules for future PRDs
│   │   └── rag-kb-authoring.md     #   Rules for maintaining the AI assistant KB
│   ├── research/
│   │   └── churn-new-users-march.md # /prd research → ranked hypotheses + evidence
│   └── journal/                    # Timeline of significant knowledge base changes
│
├── approved-prds/                  # Finalized PRDs (authoritative reference source)
│   ├── [20260410]-pricing-v3/
│   └── [20260303]-bulk-import/
│
├── drafts/                         # In-progress PRDs still being discussed
├── pending/                        # Paused, blocked, or waiting for input
├── archive/                        # Abandoned or superseded — never deleted, just moved
│
├── assets/
│   └── emails/                     # /email → one folder per campaign
│       ├── 2026-05-25-product-update-may/
│       │   ├── brief.md            #   Campaign brief and approval notes
│       │   ├── content.md          #   Approved copy
│       │   └── email.html          #   Ready-to-send HTML
│       └── 2026-06-02-quota-exhausted-nudge/
│           ├── content.md
│           └── email.html
│
├── ai-kb/                          # /prd lumi → RAG knowledge base for embedded AI assistant
│   ├── user_manual/
│   │   ├── onboarding.md           #   First 4 things new users need to know
│   │   ├── feature-guide.md        #   Step-by-step how-to per feature
│   │   ├── data-export-guide.md    #   Export fields and formats
│   │   └── notification-channels.md
│   ├── pricing/
│   │   ├── plans-and-billing.md    #   Current tiers, quotas, billing FAQ
│   │   └── payment-methods.md
│   ├── faq/
│   │   ├── product-qa.md           #   40+ Q&A extracted from real support tickets
│   │   └── presales-guidance.md    #   Sales FAQ for pre-purchase questions
│   └── api_doc/
│       ├── reference.md            #   REST / webhook / auth / rate limits
│       └── error-messages.md
│
├── competitors/                    # /prd competitor → structured competitive research
│   ├── competitor-a.md
│   └── competitor-b.md
│
└── scripts/                        # Automation (quota tables, prototype refresh, etc.)
```

The repo is fully yours — HiveMind writes to it, but never reads it remotely or uploads anything. Your team clones it; new hires read `facts/` and `decisions/` to get up to speed without onboarding calls.

## What happens in one discussion

One `/prd bulk-import` and your team walks away with:

```
✅ Committed and pushed

  ✓ facts/your-product.md              (updated)
  ✓ workflows/csv-import.yaml           (new)
  ✓ decisions/decision-20260617-csv-import.md
  ✓ features/csv-import/prd.md          (new)
  ✓ features/csv-import/workflow.yaml   (new)

Next: /ui-draft payment optimization  → clickable HTML prototype
```

Knowledge base structure:
- **facts/** — product facts, boundaries, limits (e.g., "max 10k rows per import")
- **decisions/** — design decisions and rejected approaches, with rationale (you'll find "why" three weeks later)
- **workflows/** — interaction specs (state machines, components, validation rules)
- **features/[feature]/** — PRD, prototype, dev assets, session memory all in one place
- **memory/** — reusable cross-feature rules, user research, discussion logs

## Where the knowledge base lives

By default, local-only at `~/team-knowledge` (zero setup, works offline). When you're ready to share, point it to your own private Git repo:

```bash
KNOWLEDGE_REPO=your-org/team-knowledge bash ~/hive-mind/claude-code/install.sh
```

Your data stays yours — HiveMind never uploads, stores, or holds anything.

## Team setup (optional)

Want native slash commands, auto-update via hook, and multi-person collaboration? Clone and run:

```bash
git clone https://github.com/eureka266/hive-mind.git ~/hive-mind
bash ~/hive-mind/claude-code/install.sh      # Claude Code (terminal & VS Code)
# or
bash ~/hive-mind/codex/install.sh            # Codex
```

Details: [`claude-code/README.md`](./claude-code/README.md), [`codex/README.md`](./codex/README.md), [`claude-code/ENTERPRISE_SETUP.md`](./claude-code/ENTERPRISE_SETUP.md).

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `npx skills add` not found | Check Node/npx installed (`npx -v`), network can reach GitHub, command is `npx skills add eureka266/hive-mind` |
| No `/prd` command / commands don't work | `npx skills add` installs a generic skill that listens for natural language. For native `/prd` use [Team Setup](#team-setup-optional) and restart your session |
| Push failed (permission denied) | Ensure you can write to the knowledge repo (your own repo or team org grants access); or skip `KNOWLEDGE_REPO` for local-only mode |
| Lost mid-discussion changes | Re-run `/prd [feature]` — HiveMind auto-detects and offers recovery |
| How do I view the HTML prototype? | Claude Code: `open <knowledge-repo>/features/[feature]/prototype.html`; VS Code: use Live Preview extension |

## Acknowledgements

**Proactive memory** is inspired by [Trellis](https://github.com/mindfold-ai/Trellis/tree/main)'s spec → task workspace → journal → finish loop: structured context flows *into* each session automatically, and new learnings are promoted *back* into persistent rules after the session ends. HiveMind applies this pattern to the PM workflow:

- **Session start** — load `memory/rules/` (reusable product rules) and the relevant `features/[feature]/` workspace into context automatically
- **During discussion** — track newly discovered facts, decisions, and reusable principles
- **Memory Review Gate (before finishing)** — present candidate rules to the PM; nothing is written until approved
- **Approved rules** — saved to `memory/rules/`, available as context in every future session on this product

The result: each `/prd` session gets smarter about your product's constraints and decisions without the PM having to repeat them.

**Questioning logic** in `/prd` — one question at a time, knowledge base loaded before asking, no sycophancy, no moving on until you've answered concretely — is inspired by [gstack](https://github.com/garrytan/gstack)'s `/office-hours`. The `/prd review` command draws from gstack's `/plan-ceo-review`: premise challenge, scope risk, and adversarial "would you regret this in 6 months?" framing applied to product decisions. Thank you [@garrytan](https://github.com/garrytan).

## Safety & scope

- HiveMind reads/writes **only** your specified local knowledge directory and Git repo; uploads to nowhere.
- You approve all file writes, commits, and pushes before they happen.
- `/email` only generates content and HTML — never sends mail, never reads credentials.

---

Built for [Claude Code](https://claude.com/claude-code) and Codex. Licensed under [MIT](./LICENSE).
