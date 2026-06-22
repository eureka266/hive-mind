# GTM Content Workflow

Use for `/gtm`, GTM content, commercialization content, content marketing, sales enablement, website copy, marketing articles, competitive positioning, or your product's core advantage narratives.

If the request asks for product notification email, email marketing, newsletter, customer email, sales outreach email, renewal reminder, or HTML email output, use `email-workflow.md` instead. `/gtm` can define the positioning, but `/email` owns email content, template rendering, and `assets/emails/` persistence.

## Goal

Help commercialization, content marketing, and sales enablement teammates turn verified product knowledge into market-facing content. Default output is an article direction plus value-proposition framework, not a full campaign plan.

## Knowledge Sync

First execute `knowledge-sync.md`. The workflow must clone or pull `https://github.com/your-org/team-knowledge.git` before reading product or competitor context.
Then execute `active-memory.md` to load reusable positioning, competitive-claim, marketing-copy, GTM, and customer-facing rules before framing the content.

If sync fails, do not pretend the latest knowledge base was loaded. Tell the user the failure reason and ask whether to continue with local cache or a chat-only artifact.

## Inputs

After the knowledge repo is synced, prioritize these sources in `~/team-knowledge`:

- `facts/your-product.md`
- `customer-knowledge/faq/competitive-comparison.md`
- `customer-knowledge/faq/your-product-faq.md`
- `customer-knowledge/faq/sales-faq.md`
- `customer-knowledge/user_manual/product-features.md`
- `customer-knowledge/user_manual/dashboard-guide.md`
- `customer-knowledge/user_manual/reporting-guide.md`
- `customer-knowledge/user_manual/search-guide.md`
- `customer-knowledge/api_doc/*.md`
- `competitors/your-product/*.md`
- `approved-prds/your-product/*`
- `decisions/*`
- relevant `features/[feature]/` workspace context when the GTM request is tied to a feature
- relevant `memory/rules/` for positioning, competitive claims, product boundaries, and customer-facing language

Search for topic terms plus: `dashboard`, `analytics`, `reporting`, `the customer-facing AI assistant`, `search`, `API`, `notifications`, `competitor`, `Competitor A`.

## Positioning Rules

- Use the language requested by the user for the market-facing artifact. If not specified and the user chats in Chinese, default the collaboration and framework output to Chinese.
- Preserve the user's own product, feature, API, and competitor names exactly as they appear in the knowledge base, including capabilities, workflow nouns, and source terminology.
- Do not center the content on small UX improvements such as smoother pages, clearer screens, or fewer clicks.
- Lead with strategic advantages versus alternatives: dashboard, analytics, reporting, the customer-facing AI assistant, search, API integration, notifications, end-to-end workflows, and explainability.
- Every major claim must have evidence from a fact, PRD, decision, user manual, FAQ, API doc, or competitor note.
- Do not invent product or competitor capabilities. Mark uncertain claims as `[待确认]`.
- Translate internal product decisions into buyer-facing value: risk reduction, faster operations, lower manual review burden, better prioritization, stronger audit readiness, or scalable workflows.
- Keep competitor comparisons precise and fair. If evidence is asymmetric, say what is known and what remains unknown.

## Output Format

```markdown
## GTM 内容方向

- 目标受众:
- 内容目的:
- 推荐角度:
- 核心商业论点:

## 差异化卖点

1. **[卖点名称]**
   - 买家价值:
   - 证据来源:
   - 可用表达:

## 文章大纲

1. ...

## 标题候选

- ...

## 可直接使用的关键段落

...

## 证据来源

- `path/to/source.md`: ...

## 待确认

- [待确认] ...
```

If the user asks for only an outline, keep the key paragraphs short. If the user asks for a finished article, produce a complete draft after showing the positioning frame unless they explicitly ask to move fast.

## Quality Check

Before finalizing, verify:

- The core narrative is about business and product advantage, not UI polish.
- Dashboard, analytics, reporting, the customer-facing AI assistant, search, API, or end-to-end workflows were considered.
- Claims cite source paths or are marked `[待确认]`.
- The output can be used by a commercial, marketing, or sales colleague without reading the PRDs.
- Memory Review was run when the work produced reusable positioning, claim, launch, or customer-language rules.
