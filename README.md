<div align="center">

![HiveMind](./docs/assets/hivemind-logo.png)

# HiveMind

<p style="font-size: 14px; color: #666;">
Turn every product discussion into a structured, version-controlled, team-shared knowledge base.
</p>

<p style="font-size: 14px; color: #666;">
A two-hour meeting ends, conclusions live in a few heads. Three weeks later, nobody remembers <i>why</i> you cut that approach. New hires can't piece together the "why" from scattered chats and agreements.
</p>

<p style="font-size: 14px; color: #666;">
<strong>Discussions are real-time; knowledge leaks away.</strong> HiveMind captures it: every product chat becomes traceable, durable, reusable facts, decisions, and workflows — versioned in Git, shared with your team.
</p>

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
| **Auto-extract discussions** | `/prd` chat about needs → AI auto-splits into facts, decisions, workflows. No manual spec writing. |
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

## How you'll use it (real PM scenarios)

```
/prd bulk-import feature              # discuss needs → extract facts and decisions
/prd review bulk-import               # PRD review from a product lead's angle
/prd research why users churn in March # combine analytics, feedback, and support tickets
/dev bulk-import                      # gen engineering handoff (plan, contracts, tests)
/ui-draft payment flow optimization   # turn interaction discussion into clickable prototype
/gtm how we compare to competitors    # generate positioning, sales talk, marketing assets
/email draft product-update email     # template-based, ready-to-send HTML
```

Natural language also works: "let's discuss bulk import", "extract the key decisions from that meeting".

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

## Safety & scope

- HiveMind reads/writes **only** your specified local knowledge directory and Git repo; uploads to nowhere.
- You approve all file writes, commits, and pushes before they happen.
- `/email` only generates content and HTML — never sends mail, never reads credentials.

---

Built for [Claude Code](https://claude.com/claude-code) and Codex. Licensed under [MIT](./LICENSE).
