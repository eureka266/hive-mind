# Real-World Use Cases

> **The core mechanic, illustrated.**
>
> You type `/prd bulk-import`. Before asking a single question, HiveMind loads everything relevant from your knowledge base — existing facts about the product, prior decisions that touched similar scope, any reusable rules from `memory/`. Only then does it start asking — one question at a time, with no sycophancy, no "that's interesting!", and no moving on until you've answered concretely.
>
> This is the pattern every scenario below demonstrates.

---

**Questioning logic** is inspired by [gstack](https://github.com/garrytan/gstack)'s `/office-hours` — product interrogation that pushes for behavioral evidence, names specific people, and takes a position on every answer. `/prd review` is inspired by gstack's `/plan-ceo-review` — premise challenge, scope risk, and the "6-month regret scenario" applied to product decisions.

---

| # | Scenario | Use when |
|---|----------|----------|
| 1 | [Ship a conversion-upsell feature](#1-ship-a-conversion-upsell-feature) | Designing upgrade prompts for a gated feature |
| 2 | [Redesign a pricing model](#2-redesign-a-pricing-model) | Complex plan restructure across billing, checkout, and quota |
| 3 | [Build an embedded AI assistant knowledge base](#3-build-an-embedded-ai-assistant-knowledge-base) | Creating a RAG knowledge base for an in-product AI chatbot |
| 4 | [Track cross-feature product decisions](#4-track-cross-feature-product-decisions) | Preventing repeated debates and rationale drift across features |
| 5 | [Research-driven churn diagnosis](#5-research-driven-churn-diagnosis) | Combining analytics, support tickets, and user interviews into actionable findings |

---

## 1. Ship a conversion-upsell feature

**Use this when** a gated feature has adoption potential but free users never see a compelling upgrade prompt — you need to design the reveal sequence without annoying new users.

### 1.1 Example situation

Your SaaS has a monitoring/alert feature (think "get notified when X changes") that is subscription-only. Free-plan users can trigger it by accident (e.g., hovering a button) but hit a paywall with no context. You've noticed repeat behavior from the same users — they keep revisiting the same record — which is a strong signal that they want persistent tracking but don't know the product offers it.

The PM needs to design a three-layer progressive-disclosure upsell.

### 1.2 Starting prompt

```
/prd monitor-upsell

Users who screen the same record 2+ times in a week are our best upgrade signal.
Right now they hit a raw paywall. I want a 3-layer progressive-disclosure upsell.
```

### 1.3 What happens first: knowledge base load

Before asking anything, HiveMind loads:

- `facts/[product].md` → current plan tiers and which tier has the monitoring feature
- `decisions/` → any prior decisions about this feature (e.g., why the paywall was hard vs. soft)
- `memory/rules/` → any reusable rules about conversion copy or suppression windows

Only after loading this context does it start asking — and it already knows what's been decided, so it doesn't re-open closed questions.

### 1.4 How the questioning goes (one at a time)

```
AI: "Before we design the layers — who are we targeting first:
     free-plan users, usage-credits users, or both?
     Existing decisions don't specify a split. If you say 'both',
     I'll flag where the copy diverges."

PM: "Both, but credits users need a different message."

AI: "Got it. What's your suppression window after a user dismisses a prompt?
     I see decision-20250312-quota-exhaustion uses 30 days for a similar nudge.
     Should we match that or set something different here?"

PM: "30 days is fine."

AI: "One more: for Layer 2 (the repeat-visit trigger) — do you define
     'repeat' as 2 visits to the same record within 7 days?
     Or is it any 2 visits to any record in 7 days?
     This changes the backend counter scope significantly."
```

Questions stop when the PM has enough context specified to write a non-ambiguous PRD. HiveMind does not ask questions it can answer itself from the knowledge base.

### 1.5 What gets committed

After discussion, HiveMind stages for your approval:

```
✅ Ready to commit — please review:

  features/monitor-upsell/prd.md          (new — layer logic, trigger table, copy variants)
  features/monitor-upsell/workflow.yaml   (new — 3-layer state machine)
  features/monitor-upsell/prototype.html  (new — clickable demo of all 3 layers)
  decisions/decision-YYYYMMDD-monitor-upsell.md  (new — why 7-day window, why 24h new-user threshold)
  memory/rules/conversion-suppression.md  (new — "30-day dismissal rule")
```

Nothing is written until you approve.

### 1.6 Done means

- Prototype demonstrates all 3 layer transitions
- Dismissal suppression logic is documented with edge cases
- Engineering handoff includes ≥ 8 analytics events covering the full conversion funnel
- The "why 7 days" is in `decisions/`, not just in Slack

---

## 2. Redesign a pricing model

**Use this when** you're restructuring plans (new tier names, quota changes, legacy user migration) and need multiple sub-PRDs to ship together without contradicting each other.

### 2.1 Example situation

Your product has outgrown its original 3-tier pricing model. The team is moving to a new structure with a separate high-value feature add-on. This involves 6 interconnected sub-PRDs: Pricing page, Checkout, Billing, Quota enforcement, Legacy migration, and Email triggers.

### 2.2 Starting prompt

```
/prd pricing-v3

We're launching a redesigned pricing model with a separate add-on for monitoring.
I need sub-PRDs for: Pricing page, Checkout, Billing, Quota enforcement,
legacy user migration, and email triggers (quota warnings + plan changes).

Core constraint: legacy users must never see a price increase without explicit opt-in.
```

### 2.3 What happens first: knowledge base load

HiveMind loads:

- `facts/[product].md` → current plan names, quotas, and exact pricing numbers
- `decisions/` → any prior decisions on downgrade behavior, top-up logic, and billing cycle rules
- `memory/rules/product-facts-pricing.md` → authoritative pricing rules

Any inconsistency between what you say and what's in `facts/` gets flagged as `[CONFLICT]` before the PRD is written.

### 2.4 How the questioning goes (one at a time)

```
AI: "The current facts say legacy Growth-plan users have 500 screenings/month.
     Your new Essential tier has 300. If we're saying 'no price increase without opt-in,'
     does that mean legacy Growth users keep 500, or do they get grandfathered
     at the old price for the new 300-limit tier? These are different migration paths."

PM: "They keep their quota at the old price for 6 months, then we prompt them."

AI: "Got it. Does the 6-month grace period start on launch day for all legacy users,
     or on each user's next renewal date? The billing page UI differs depending on this."

PM: "Next renewal date."

AI: "One more before I start the Pricing page: you mentioned a monitoring add-on.
     Is it available on all plans, or only on paid plans? This affects the Pricing page
     feature comparison table."
```

### 2.5 What gets committed

```
✅ Ready to commit — please review:

  features/pricing-v3/prd.md                    (new — master doc, links all sub-PRDs)
  features/pricing-v3/sub-prds/pricing-page.md  (new)
  features/pricing-v3/sub-prds/checkout.md      (new)
  features/pricing-v3/sub-prds/billing.md       (new)
  features/pricing-v3/sub-prds/quota.md         (new)
  features/pricing-v3/sub-prds/migration.md     (new — mapping table, grace period)
  features/pricing-v3/sub-prds/emails.md        (new — 3 trigger scenarios)
  decisions/decision-YYYYMMDD-pricing-v3-migration.md  (new)
  facts/[product].md                            (updated — new tier names and quotas)
```

### 2.6 Done means

- All sub-PRDs cross-reference consistently (same tier names, same quota numbers)
- Migration table covers 100% of legacy plan types
- `facts/[product].md` is updated — it's now the authoritative source for the new pricing

---

## 3. Build an embedded AI assistant knowledge base

**Use this when** your product has (or will have) an in-product AI chatbot that needs a RAG knowledge base — and that knowledge base needs to stay accurate as the product evolves.

### 3.1 Example situation

Your SaaS has added an embedded AI assistant that answers user questions in-app. The knowledge base was written at launch and is now 3 months out of date — wrong pricing, references to deprecated features, contradictions with current help docs.

### 3.2 Starting prompt

```
/prd ai-assistant-kb

Our embedded AI knowledge base is 3 months stale. I need to rebuild it systematically.
Sections: user_manual/, pricing/, faq/ (~40 Q&A from real tickets), api_doc/.

Hard rules: nothing unshipped, no internal implementation details,
every claim must trace to facts/ or an approved PRD.
```

### 3.3 What happens first: knowledge base load

HiveMind loads:

- `facts/[product].md` → what's currently live and confirmed
- `approved-prds/` → sources for any specific behavior claims
- `memory/rules/rag-kb-authoring.md` → if it exists, the team's established KB authoring rules

It will not generate any KB content that can't be traced to one of these sources.

### 3.4 How the questioning goes (one at a time)

```
AI: "The current facts file doesn't specify the data export field count.
     I see two different numbers across older PRDs: 13 fields and 22 fields.
     Which is current? I won't write the export guide until this is confirmed."

PM: "22 fields — that's the current version."

AI: "Understood. For the FAQ section: do you want me to extract Q&A pairs
     from the support tickets you paste, or should I draft FAQs based on
     the existing facts file? The first approach is more grounded in real user confusion;
     the second is faster but may miss what users actually ask."

PM: "From tickets — I'll paste 20 samples now."
```

### 3.5 What gets committed

```
✅ Ready to commit — please review:

  ai-kb/user_manual/feature-guide.md     (new — step-by-step, user-facing)
  ai-kb/pricing/plans-and-billing.md     (new — current tiers only, no strategy info)
  ai-kb/faq/common-faq.md               (new — 40 Q&A extracted from tickets)
  ai-kb/api_doc/reference.md            (new — REST/webhook/auth)
  memory/rules/rag-kb-authoring.md      (new — "each H2 = independent retrieval unit")
  decisions/decision-YYYYMMDD-ai-kb-scope.md  (new — what was excluded and why)
```

### 3.6 Done means

- Every section traces to an authoritative source in `facts/` or `approved-prds/`
- Authoring rules saved to `memory/rules/` so future updates follow the same standard
- AI assistant answers a representative set of 10 test questions without hallucinating

---

## 4. Track cross-feature product decisions

**Use this when** multiple features share the same underlying policy (quota rules, permissions, pricing behavior) and you keep re-debating the same questions because the original rationale isn't written down.

### 4.1 Example situation

Your PM team has shipped 6 features over the past year, three of them touching quota enforcement. But nobody remembers why the free plan gets 10 queries/month (not 5 or 20), why quota exhaustion triggers a hard block rather than a soft warning, or why downgrading doesn't take effect until end of billing cycle. These questions come up every sprint.

### 4.2 Starting prompt

```
/prd decisions-audit

I want a formal decision log for 4 open questions in our quota and permission system:
1. Why 10/month for the free plan, not another number
2. Hard block on exhaustion vs. soft warning + auto-upgrade
3. Downgrade effective date: immediate vs. end-of-cycle
4. Why feature access is tied to quota balance, not plan tier alone

Pull any relevant history from decisions/ before we discuss each one.
```

### 4.3 What happens first: knowledge base load

HiveMind scans `decisions/` for any prior mention of quota, permissions, or plan logic, then tells you upfront:

```
AI: "Found 2 relevant prior decisions:
     - decision-20250312-quota-exhaustion.md: hard block was chosen for legal/compliance reasons.
       This answers question 2 — do you want to re-open it, or just confirm and document it?
     - decision-20250601-downgrade-policy.md: end-of-cycle was chosen to avoid proration complexity.
       This answers question 3.

     Questions 1 and 4 have no prior decision record. Starting with question 1."
```

### 4.4 How the questioning goes (one at a time)

```
AI: "For the free plan 10/month limit — was this number set based on
     a cost model, a competitive benchmark, or a gut feel at the time?
     I'm asking because if it was cost-based, the decision log should record the assumption
     so we know when to revisit it."

PM: "Gut feel, mostly — we wanted a number that felt generous enough to activate users
     but low enough to push conversions."

AI: "Then I'll document the assumption as: '10/month is a conversion-optimization guess,
     not a cost-derived floor. Should be revisited with activation and conversion data
     after 6 months.' Does that capture it accurately?"
```

### 4.5 What gets committed

```
✅ Ready to commit — please review:

  decisions/decision-YYYYMMDD-free-quota-10.md       (new)
  decisions/decision-YYYYMMDD-feature-permission-binding.md  (new)
  memory/rules/quota-policy.md                       (new — distilled policy for future PRDs)
```

### 4.6 Done means

- Each question has a written "why", not just a "what"
- Cross-links between related decisions are in place
- The next PM who asks "why is it 10/month?" can find the answer in under 30 seconds

---

## 5. Research-driven churn diagnosis

**Use this when** you're seeing a metric drop and need to synthesize multiple data sources — usage analytics, support tickets, user interviews — into a structured set of hypotheses and next actions.

### 5.1 Example situation

You notice a month-over-month drop in 7-day retention for new free users. You have funnel data (60% drop-off between first action and day-3 return visit), a sample of support tickets tagged "confusing", and notes from 5 user interviews with churned users.

### 5.2 Starting prompt

```
/prd research churn-new-users-march

Diagnose why new free users are churning in the first week.

Sources:
1. Funnel data: 60% drop-off between "first action" and "day-3 return visit" (I'll paste)
2. Support tickets: 20 samples tagged "confusing" (I'll paste)
3. Interview notes: 5 churned users from last month (I'll paste)

Goal: rank top 3 root causes, pick the highest-leverage fix, write a shareable research summary.
```

### 5.3 What happens first: knowledge base load

HiveMind loads any prior research in `memory/research/` and any decisions that touch onboarding or activation, then tells you what's already known:

```
AI: "Found one prior research note: memory/research/activation-drop-q3.md.
     It identified 'empty state on day 1' as a hypothesis but marked it unverified.
     If your new data confirms or refutes this, we can close it.
     Pasting your funnel data now — I'll start there."
```

### 5.4 How the questioning goes (one at a time)

```
AI: "The funnel shows 60% drop between first action and day-3 return.
     Does 'first action' mean completing a full task, or just starting one?
     If users are starting but not finishing, that's a different problem
     than users finishing but not coming back."

PM: "Starting one — most don't complete their first task."

AI: "That changes the hypothesis. Looking at the support tickets you pasted,
     7 of 20 mention 'didn't understand the result' rather than 'couldn't do the action.'
     That pattern points to result interpretation, not task flow.
     Do you have data on which specific result type confused them most?"
```

### 5.5 What gets committed

```
✅ Ready to commit — please review:

  memory/research/churn-new-users-march.md              (new — ranked hypotheses, evidence, confidence)
  decisions/decision-YYYYMMDD-churn-fix-priority.md     (new — why fix A before B)
```

### 5.6 Done means

- Top 3 hypotheses each have evidence from ≥ 2 independent sources
- The chosen fix has a falsifiable success metric ("7-day retention improves by X% in 3 weeks")
- Research summary is ≤ 1 page — readable by a PM who wasn't in the discussion

---

*Have a scenario that doesn't fit these patterns? Open an [issue](https://github.com/eureka266/HiveMind/issues) or PR.*
