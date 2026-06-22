# Real-World Use Cases

These scenarios are drawn from actual production usage of HiveMind-style knowledge repos. All company names and product specifics have been generalized to apply to any SaaS PM workflow.

| # | Scenario | Use when |
|---|----------|----------|
| 1 | [Ship a conversion-upsell feature](#1-ship-a-conversion-upsell-feature) | Designing upgrade prompts for a gated feature |
| 2 | [Redesign a pricing model](#2-redesign-a-pricing-model) | Complex plan restructure across billing, checkout, and quota |
| 3 | [Build an embedded AI assistant knowledge base](#3-build-an-embedded-ai-assistant-knowledge-base) | Creating a RAG knowledge base for an in-product AI chatbot |
| 4 | [Track cross-feature product decisions](#4-track-cross-feature-product-decisions) | Preventing repeated debates and rationale drift across features |
| 5 | [Research-driven churn diagnosis](#5-research-driven-churn-diagnosis) | Combining analytics, support tickets, and user feedback into actionable findings |

---

## 1. Ship a conversion-upsell feature

**Use this when** a gated feature has adoption potential but free users never see a compelling upgrade prompt — you need to design the reveal sequence without annoying new users.

### 1.1 Example situation

Your SaaS has a monitoring/alert feature (think "get notified when X changes") that is subscription-only. Free-plan users can trigger the feature by accident (e.g., hovering a button) but hit a paywall with no context. You've noticed repeat behavior from the same users — they keep revisiting the same record — which is a strong signal that they want persistent tracking but don't know the product offers it.

The PM needs to design a three-layer progressive-disclosure upsell:
- **Layer 1** — first impression (new users, ≤ 24h old): lightweight tooltip, no hard sell
- **Layer 2** — repeat-signal (same user revisits the same item 2+ times in 7 days): full upsell card with plan details
- **Layer 3** — explicit intent (user clicks the locked feature button): upgrade modal, max conversion

### 1.2 Starting prompt

```
/prd monitor-upsell

Context: Users who screen the same address 2+ times in a week are our best upgrade signal. 
Right now they hit a raw paywall. I want a 3-layer progressive-disclosure upsell:
- Layer 1 (new users, account < 24h): hover popover, soft awareness
- Layer 2 (repeat-screen signal): full upsell card, show plan comparison and price
- Layer 3 (explicit click on locked button): full modal, maximize conversion

Constraints:
- 30-day dismissal suppression after user closes a prompt
- Free-plan and usage-credits-plan users see different messaging
- No auto-triggering modals; only on explicit user action
```

### 1.3 Workflow

1. **AI** loads `facts/[product].md` → confirms which plan tiers have the feature, which don't
2. **AI** reads existing decisions → "did we ever decide why the paywall is hard vs. soft?"
3. **PM + AI** discuss: trigger logic for each layer, suppression window, per-user-tier copy variants
4. **AI** drafts `features/monitor-upsell/prd.md` with trigger table, UX copy variants, and analytics event list
5. **PM** reviews — approves or adjusts suppression window and messaging
6. **AI** generates `features/monitor-upsell/workflow.yaml` — state machine for the 3 layers
7. **AI** generates `features/monitor-upsell/monitor-upsell-prototype.html` — clickable prototype showing all 3 layers
8. **AI** writes `decisions/decision-YYYYMMDD-monitor-upsell.md` — records the "why 7-day window, why 24h new-user threshold"
9. **PM** confirms → `git commit`

### 1.4 What gets captured in the knowledge base

- `decisions/` — layer trigger logic and thresholds (so the next PM doesn't re-debate "should Layer 2 fire at 2 visits or 3?")
- `memory/rules/` — "repeat-visit is valid conversion signal; do not confuse with accidental clicks"
- `features/monitor-upsell/` — full PRD, state machine, prototype, open questions

### 1.5 Done means

- Prototype demonstrates all 3 layer transitions
- Dismissal suppression logic is documented with edge cases
- Engineering handoff includes ≥ 8 analytics events covering the full conversion funnel

---

## 2. Redesign a pricing model

**Use this when** you're restructuring plans (new tier names, quota changes, legacy user migration) and need multiple sub-PRDs to ship together without contradicting each other.

### 2.1 Example situation

Your product has outgrown its original 3-tier pricing model (Starter / Growth / Pro). The team has decided to move to a new structure with clearer value separation and a separate usage add-on for a high-value feature (monitoring). This involves:

- A new Pricing Plans page (new tier names, feature comparison table)
- A revised Checkout page (handle upgrade, downgrade, and first-purchase flows)
- A new Billing page (show current plan, usage breakdown, add-on management)
- Quota enforcement logic (enforce new limits without surprising existing users)
- A legacy-user migration plan (old plan → new plan mapping, grace period, notifications)
- Automated email triggers (quota 80% warning, quota exhausted, plan upgrade confirmation)

### 2.2 Starting prompt

```
/prd pricing-v3

We're launching a redesigned pricing model. I need sub-PRDs for:
1. Pricing Plans page — new tier structure, feature comparison table
2. Checkout flow — upgrade / first-purchase / downgrade paths
3. Billing page — current plan display, usage bar, add-on management
4. Quota enforcement — graceful degradation when limits hit
5. Legacy user migration — mapping old plans to new tiers, grace period
6. Email triggers — quota warnings (80%, exhausted), plan change confirmations

Core constraint: legacy users must never see a price increase without explicit opt-in.
```

### 2.3 Workflow

1. **AI** reads `facts/[product].md` → loads current plan names, quotas, pricing
2. **AI** surfaces any prior pricing decisions from `decisions/` ("did we decide why downgrade isn't self-serve?")
3. **PM + AI** work through each sub-PRD in sequence, starting with the Pricing page (anchor for all others)
4. For each sub-PRD, **AI** flags if a decision conflicts with `facts/` and marks it `[CONFLICT]`
5. **AI** generates `features/pricing-v3/prd.md` — master document with links to each sub-PRD
6. **AI** generates a migration mapping table: old plan → new plan → delta for each user type
7. **PM** approves sub-PRDs one at a time
8. **AI** auto-generates email copy for each trigger (quota warning, exhausted, upgrade confirmation)
9. **AI** generates prototype HTML for Pricing page and Checkout flow
10. **AI** commits and records decisions about migration rules

### 2.4 What gets captured in the knowledge base

- `facts/[product].md` updated — new tier names and quotas become the authoritative source
- `decisions/` — legacy user migration rules, why downgrade requires support, why the add-on is sold separately
- `features/pricing-v3/` — all 6 sub-PRDs, prototypes, email copy, dev assets

### 2.5 Done means

- All sub-PRDs cross-reference consistently (same tier names, same quota numbers)
- Migration table covers 100% of legacy plan types
- Email copy for all 3 trigger scenarios is approved

---

## 3. Build an embedded AI assistant knowledge base

**Use this when** your product has (or will have) an in-product AI chatbot that needs a RAG knowledge base — and that knowledge base needs to stay accurate as the product evolves.

### 3.1 Example situation

Your SaaS product has added an embedded AI assistant that answers user questions in-app ("How do I export my results?", "What's included in the Pro plan?", "Why did this transaction get flagged?"). The assistant pulls answers from a structured knowledge base you own and maintain.

The problem: the knowledge base was written once at launch and now has 3-month-old pricing, references deprecated features, and contradicts the current help docs. The PM needs to systematically rebuild and maintain it.

The knowledge base needs sections for:
- **User manual** — how to use each feature (step-by-step, user-facing)
- **Pricing and plans** — current tiers, billing FAQ
- **Common FAQ** — 40+ Q&A pairs from actual support tickets
- **API reference** — for technical users and integration questions

### 3.2 Starting prompt

```
/prd ai-assistant-knowledge-base

I need to build and maintain a RAG knowledge base for our embedded AI assistant.
It's structured by section — each H2 heading is an independent retrieval unit.

Sections needed:
- user_manual/ — feature how-to guides (plain English, no internal jargon)
- pricing/ — current plans, billing FAQ, payment methods
- faq/ — ~40 Q&A pairs drawn from real support tickets
- api_doc/ — REST/webhook reference, auth, rate limits, error codes

Hard rules for all content:
- Never mention unshipped features or pricing not yet live
- Never document internal implementation (score algorithms, provider names, cost structure)
- Every claim must trace to facts/ or approved-prds/ — no creative writing
```

### 3.3 Workflow

1. **AI** reads `facts/[product].md` → builds a list of what's currently live and confirmed
2. **PM + AI** go section by section, starting with the highest-traffic section (usually FAQ)
3. For FAQ: **PM** pastes a batch of real support tickets; **AI** extracts Q&A pairs and formats them
4. **AI** flags any answer that would require claiming an unconfirmed feature → marks as `[NEEDS VERIFICATION]`
5. For pricing: **AI** reads `facts/pricing.md` and generates the pricing section — no interpretation
6. For user manual: **AI** generates step-by-step guides per feature, cross-referenced against the feature PRDs
7. **PM** reviews each section for accuracy and tone
8. **AI** commits to `lumi-knowledge/` (or your equivalent path) with a CHANGELOG note per section
9. **AI** generates a maintenance rule: "this section must be updated whenever `facts/pricing.md` changes"

### 3.4 What gets captured in the knowledge base

- `lumi-knowledge/` (or `ai-kb/`) — the published RAG content
- `memory/rules/rag-kb-authoring.md` — authoring rules ("each H2 = independent retrieval unit", "no internal impl details")
- `decisions/` — what gets excluded from the AI KB and why (pricing strategy, internal algorithms, unshipped features)

### 3.5 Done means

- Every section traces to an authoritative source (`facts/` or `approved-prds/`)
- Authoring rules are saved to `memory/rules/` so future updates follow the same standard
- AI assistant answers a representative set of 10 test questions without hallucinating

---

## 4. Track cross-feature product decisions

**Use this when** multiple features share the same underlying policy (quota rules, permissions, pricing behavior) and you keep re-debating the same questions because the original rationale isn't written down.

### 4.1 Example situation

Your PM team has shipped 6 features over the past year. Three of them touch quota enforcement; two touch plan permissions. But nobody remembers:

- Why the free plan gets 10 queries/month (not 5 or 20)
- Why power users who exhaust their quota see a hard block (not a soft warning + auto-upgrade)
- Why downgrading doesn't take effect until end of billing cycle

These questions come up every sprint when engineers ask for "the rule" and PMs have to reconstruct the decision from memory or Slack search.

### 4.2 Starting prompt

```
/prd decisions-audit

I want to run a systematic decision audit for our quota and permission system.
For each of these 4 questions, I want a formal decision log capturing
the decision, the reason, the assumptions, and the edge cases:

1. Free plan quota: why 10/month, not a different number
2. Hard block on quota exhaustion vs. soft warning + auto-upgrade
3. Downgrade effective-date policy (immediate vs. end-of-cycle)
4. Permission binding: why feature access is tied to quota balance, not to plan tier alone

Pull any relevant history from existing decisions/ files before we discuss each one.
```

### 4.3 Workflow

1. **AI** scans `decisions/` for any prior mentions of quota, permissions, or plan logic
2. **AI** surfaces what's already decided vs. what was never formally recorded
3. **PM + AI** work through each question — PM provides the original intent; AI asks clarifying questions
4. For each decision, **AI** drafts a `decisions/decision-YYYYMMDD-[topic].md` with the standard template
5. **PM** reviews — adjusts assumptions and open questions
6. **AI** cross-links related decisions ("this quota decision assumes the same hard-block logic as decision-20250312-quota-exhaustion")
7. **AI** generates a `memory/rules/quota-policy.md` — distilled, reusable policy rules for future PRDs
8. Commit

### 4.4 What gets captured in the knowledge base

- `decisions/` — 4 formal decision logs with rationale, assumptions, and edge cases
- `memory/rules/quota-policy.md` — extracted policy rules that future PRDs auto-load
- Future: when any feature touches quota, AI loads this rule set automatically

### 4.5 Done means

- Each question has a written decision with the "why", not just the "what"
- Cross-links between decisions are in place
- The next PM who asks "why is it 10/month?" can find the answer in under 30 seconds

---

## 5. Research-driven churn diagnosis

**Use this when** you're seeing a metric drop (signups, activation, retention) and need to synthesize multiple data sources — usage analytics, support tickets, user interviews — into a structured set of hypotheses and next actions.

### 5.1 Example situation

You notice that a month-over-month drop in 7-day retention for new free users. You have:

- **Instrumentation data** — a funnel report showing where users drop off (signup → first action → return visit)
- **Support tickets** — 3 months of tickets tagged "confusing" or "didn't understand how to"
- **User interviews** — notes from 5 recent interviews with users who churned after their first week

You want to synthesize these into: a ranked list of root causes, a decision about which one to address first, and a proposed fix.

### 5.2 Starting prompt

```
/prd research churn-new-users-march

I need to diagnose why new free users are churning in the first week.

Sources available:
1. Funnel data: 60% drop-off between "first action" and "return visit on day 3" (I'll paste the numbers)
2. Support tickets: 3 months of tickets tagged "confusing" — I'll paste a sample of 20
3. Interview notes: 5 churned users from last month — I'll paste the notes

Goal: rank the top 3 root causes, pick the highest-leverage fix, and write a research summary
I can share with the team.
```

### 5.3 Workflow

1. **PM** pastes funnel data; **AI** identifies the steepest drop-off step and frames hypotheses
2. **PM** pastes support ticket sample; **AI** clusters them by theme ("didn't find X", "confused by Y"), quantifies
3. **PM** pastes interview notes; **AI** extracts direct quotes and maps them to the hypothesis list
4. **AI** ranks hypotheses by evidence weight: quantitative signal + qualitative signal + user quote
5. **PM + AI** discuss the top hypothesis — rule out confounders, identify the simplest test
6. **AI** writes `memory/research/churn-new-users-march.md` — structured research summary
7. **AI** generates a `decisions/decision-YYYYMMDD-churn-fix-priority.md` — records why Hypothesis 1 was chosen over Hypothesis 2
8. Commit

### 5.4 What gets captured in the knowledge base

- `memory/research/` — structured research summary (hypothesis, evidence, confidence level)
- `decisions/` — prioritization rationale (why fix A before B, what signals drove the call)
- Future: when working on onboarding, AI auto-loads this research as context

### 5.5 Done means

- Top 3 hypotheses are ranked with evidence from at least 2 independent sources each
- The chosen fix has a falsifiable success metric ("7-day retention improves by X% in 3 weeks")
- Research summary is ≤ 1 page — readable by a PM who wasn't in the discussion

---

*Have a scenario that doesn't fit these patterns? Open an [issue](https://github.com/eureka266/hive-mind/issues) or PR with your workflow.*
