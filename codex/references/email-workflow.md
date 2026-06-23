# Email Workflow

Use for `/email`, product notification emails, lifecycle emails, email marketing, newsletters, customer emails, HTML emails, sales outreach emails, renewal reminders, and GTM requests that ask for email output.

## Goal

Generate evidence-backed customer-facing email content and fixed-template HTML, then save approved assets into the product knowledge repository asset library.

This workflow produces content and HTML only. Do not create Gmail drafts, send email, or ask for OAuth credentials.

## Knowledge Sync

First execute `knowledge-sync.md`. The workflow must clone or pull `https://github.com/your-org/team-knowledge.git` before reading product, competitor, PRD, decision, FAQ, user manual, or asset context.
Then execute `active-memory.md` to load reusable GTM, email, claim, customer-facing-copy, and product-positioning rules before drafting.

If sync fails, stop and explain the failure. Ask whether to retry, continue from local cache, or produce a chat-only draft. Do not claim the latest knowledge base was loaded.

## Inputs

After sync, search the user topic across:

- `facts/`
- `approved-prds/`
- `decisions/`
- `customer-knowledge/faq/`
- `customer-knowledge/user_manual/`
- `customer-knowledge/api_doc/`
- `competitors/`
- `assets-index.md`
- Existing `assets/emails/` if present
- Relevant `features/[feature]/` workspace context when the email is tied to a feature
- Relevant `memory/rules/` for claims, GTM positioning, marketing copy, and customer communications

For your product's content, also consider: `dashboard`, `analytics`, `reporting`, `the customer-facing AI assistant`, `search`, `API`, `notifications`, `billing`, `user onboarding`, `report`, and relevant competitor names.

## Supported Scenarios

- Product notification: existing users, feature updates, service notices, usage or quota reminders.
- Email marketing: prospects or market segments, newsletter, product advantage, campaign email.
- Sales enablement: sales follow-up, renewal, free-to-paid conversion, or product strategy outreach.

## Template Selection

Use these fixed templates from `email/templates/`:

| Template ID | Use when |
|---|---|
| `product_update` | Structured product update email with feature blocks and CTA |
| `product_notification` | Product or service notification from your team |
| `marketing` | Paid-user marketing, education, adoption, or product value email |
| `paid_users` | Paid-user renewal or plan-related lifecycle email |
| `sales` | Sales outreach or free-user conversion |
| `support` | Support or follow-up email |
| `bd` | Product strategy, BD, partnership, or executive outreach |

Supported languages: `en`, `zh`, `es`, `ja`, `pt-BR`, `ru`, `zh-Hant`, `ko`.

## Content Rules

- Lead with buyer/user value, business impact, risk reduction, confidence, workflow efficiency, or operational clarity.
- Use the language or language list requested by the user for the email artifact. Keep collaboration, approval questions, evidence notes, and progress summaries in Chinese by default when the user chats in Chinese.
- Preserve the user's own product, feature, and API names as they appear in the knowledge base unless the user explicitly provides approved localized wording.
- Do not center the email on small UX improvements unless the user explicitly asks.
- Every product capability, claim, competitor comparison, metric, or legal-sensitive statement must cite source paths or be marked `[待确认]`.
- Keep external copy clear, modest, and usable. Avoid empty hype.
- For email marketing and competitive positioning, use the same evidence discipline as `/gtm`.

## Output Before Saving

Unless the user explicitly asks to save directly, first show:

```markdown
## 邮件 Brief

- 场景:
- 目标受众:
- 触发时机:
- 推荐模板:
- 语言:
- CTA:

## Subject / Preheader

- Subject:
- Preheader:

## 正文

...

## HTML 合成计划

- Template ID:
- Output path after approval:

## 证据来源

- `path/to/source.md`: ...

## 待确认

- [待确认] ...
```

## Saving Assets

When the user approves or explicitly asks to save directly:

1. Create `~/team-knowledge/assets/emails/{yyyy-mm-dd}-{slug}/`.
2. Save:
   - `brief.md`: scenario, audience, trigger, CTA, template, source evidence, pending items.
   - `content.{lang}.md`: subject, preheader, and body for each language.
   - `render-input.{lang}.json`: renderer payload for each language.
   - `email.{lang}.html`: rendered HTML for each language.
   - `metadata.json`: template, languages, status, source paths, created time.
3. Use `email/render_email.py` to render HTML:

```bash
python3 ~/HiveMind/codex/email/render_email.py \
  --input ~/team-knowledge/assets/emails/{slug}/render-input.en.json \
  --output ~/team-knowledge/assets/emails/{slug}/email.en.html
```

If running from an installed Codex skill, use the installed `email/render_email.py` path inside the skill directory.

4. Update `assets-index.md` with a short asset entry that links to the saved folder, records the template, audience, language, and source evidence.
5. Run the Memory Review Gate from `active-memory.md`. If the email creates reusable customer-facing claim rules, launch communication rules, or unresolved product questions, propose memory updates before finishing.

## Structured Product Update Slots

For `product_update`, create `slots` with:

- `email_subject`
- `preheader_text`
- `hero_title`
- `hero_intro_line_1`
- optional `hero_intro_line_2`, `hero_intro_line_3`
- `hero_cta_text`
- `hero_cta_link`
- `features_section_title`
- `features`: 2 to 4 objects with `title`, `desc`, optional `image`, `link`, `link_text`
- `closing_title`
- `closing_cta_text`
- `closing_cta_link`
- `support_text_prefix`
- `help_link_text`
- `support_text_suffix`

For other templates, render with `body_html`.

## Quality Check

Before finalizing:

- Knowledge repo sync happened or fallback was explicitly chosen.
- Template selection matches the scenario.
- Content cites source paths or uses `[待确认]`.
- HTML was rendered from a fixed template.
- Assets were saved under `assets/emails/` when requested.
- Active memory was loaded, and Memory Review was run when the email produced reusable claim, launch, or positioning learnings.
- No Gmail sending, OAuth, `.env`, or credential logic was introduced.
