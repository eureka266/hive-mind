---
name: email
description: HiveMind 产品通知邮件与邮件营销命令。基于产品知识库和固定模板生成可直接发送的 HTML 邮件，并在确认后沉淀到 team-knowledge 的 assets/emails 资产库。输入 /email [主题] 使用。
---

# email

HiveMind 的产品邮件命令。用于生成产品通知、邮件营销、newsletter、客户邮件、销售触达、续费提醒和 HTML 邮件资产。

`/email` 只负责内容生成、HTML 合成和资产沉淀；不要发送 Gmail、创建 Gmail 草稿、索要 OAuth 或读取 `.env`。

## 语言规则

- 邮件正文、subject、preheader、HTML 内容按用户指定语言输出；用户要求多语言时分别生成对应语言版本。
- 对话、审批问题、证据说明和保存计划默认中文，除非用户明确要求换语言。
- 用户自己的产品名、功能名、API 名和领域术语保留英文原样，不要翻译或改写；竞品名同样保留原样。
- 如果输出会写入 `customer-knowledge/`，该文件内容必须全部英文；普通邮件资产仍按用户指定语言保存。

## 使用方式

```text
/email 写一封产品更新邮件，中文和英文，生成 HTML 并保存到资产库
/email 给完成 user onboarding 的用户写 follow-up 邮件
/email 面向付费用户写 plan renewal reminder
/email 写一封 dashboard + reporting 的营销邮件
```

`/gtm` 中出现产品通知邮件、邮件营销、newsletter、客户邮件或 HTML 邮件意图时，也应转入本工作流。

## Phase 0: 知识库健康检查（自动）

在执行本命令的任何步骤之前，先确认知识库就绪：

```bash
KB_DIR="${KNOWLEDGE_DIR:-$HOME/team-knowledge}"
if [ -d "$KB_DIR/.git" ]; then
  echo "KB_STATUS: exists"
else
  echo "KB_STATUS: missing"
fi
```

- `KB_STATUS: exists` → 继续阶段 1
- `KB_STATUS: missing` → 暂停，进入 `/kb-setup` 向导（见 `claude-code/skills/kb-setup.md`）；向导完成后自动继续本命令

---

## 阶段 1: 拉取并同步知识库

1. 进入知识库并同步最新内容（Phase 0 已确认目录存在）：

   ```bash
   cd ~/team-knowledge
   git pull --ff-only origin main
   ```

3. 如果 clone 或 pull 因网络、权限或本地变更失败，必须停止读取资料并向用户说明：
   - 失败原因
   - 是否存在本地缓存
   - 可选路径：稍后重试、使用本地缓存、或仅基于用户提供材料产出 chat-only 版本

不要假装已经加载了最新知识库。

## 阶段 1b: Active Memory Setup

同步知识库后，加载与邮件相关的可复用规则：

- 扫描 `memory/rules/` 中标记为 `email / claim / launch / customer-communication` 的规则。
- 如有已有邮件规则（如：外发 claim 证据要求、邮件语气约束、特定受众偏好），在本次输出中自动应用。

报告 memory 摘要：
```
Memory loaded:
- Active email rules: [N rules — claim / launch / customer-communication]
```

---

## 阶段 2: 读取资料

根据邮件主题搜索：

- `facts/`
- `approved-prds/`
- `decisions/`
- `customer-knowledge/faq/`
- `customer-knowledge/user_manual/`
- `customer-knowledge/api_doc/`
- `competitors/`
- `assets-index.md`
- 已有 `assets/emails/`（如果存在）

产品相关邮件还要搜索：`dashboard`、`reporting`、`notifications`、`search`、`billing`、`API`、`user onboarding`、`CSV import` 以及用户自己的产品名、功能名和相关竞品名。

## 阶段 3: 选择邮件场景和模板

支持场景：

- 产品通知邮件：面向现有用户，说明变更、价值、影响和 CTA
- 邮件营销：面向潜在客户或细分行业，突出核心卖点和业务价值
- 销售 enablement：销售触达、跟进、续费、转化

固定模板：

| Template ID | 使用场景 |
|---|---|
| `product_update` | 结构化产品更新邮件 |
| `marketing` | 付费用户营销、教育、采用 |
| `sales` | 售前触达或免费用户转化 |

支持语言：`en`、`zh`、`es`、`ja`、`pt-BR`、`ru`、`zh-Hant`、`ko`。

## 阶段 4: 生成内容

输出必须包含：

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

内容规则：

- 优先写用户价值、商业影响、流程效率或运营洞察。
- 不把重点放在“小 UX 优化”，除非用户明确要求。
- 产品能力、竞品对比、指标和敏感表述必须有来源；缺证据标记 `[待确认]`。
- 外发语气要清晰、克制、可直接使用，避免空泛营销词。

## 阶段 5: 保存资产和合成 HTML

除非用户明确要求“直接保存”，否则先展示内容并等待确认。

确认后：

1. 创建 `~/team-knowledge/assets/emails/{yyyy-mm-dd}-{slug}/`
2. 保存以下文件，**全部放在该目录下，不要写到 `prototypes/`**：
   - `brief.md`
   - `content.{lang}.md`
   - `render-input.{lang}.json`
   - `email.{lang}.html`  ← 最终 HTML 输出，命名为 `email.en.html` 或 `email.zh.html`
   - `metadata.json`
3. 使用 Claude Code 版自带渲染脚本合成 HTML：

   ```bash
   python3 ~/HiveMind/claude-code/email/render_email.py \
     --input ~/team-knowledge/assets/emails/{slug}/render-input.en.json \
     --output ~/team-knowledge/assets/emails/{slug}/email.en.html
   ```

4. 更新 `~/team-knowledge/assets-index.md`，新增邮件资产入口，记录资产路径、模板、受众、语言和证据来源。

`product_update` 使用 `slots` 渲染（sections 结构）；其他模板使用 `body_html` 注入。

> **注意**：`prototypes/` 目录仅用于存放 HTML 邮件模板原型（设计稿）。邮件活动产出（brief、content、HTML）**必须写入 `assets/emails/`**，不得写入 `prototypes/`。

### Memory Review Gate

资产保存后，判断本次邮件工作是否产生了可复用的 claim、发布表达或客户沟通规则。

好的规则候选（来自 email）：
- 外发 claim 证据要求（如：每个产品声明必须绑定 facts 来源）。
- 发布邮件的结构约定（如：产品更新邮件必须包含 CTA 和影响说明）。
- 客户语言偏好（如：面向付费用户的表达语气与潜客不同）。
- 模板选择规则（场景与 Template ID 的对应关系更新）。

发现规则候选时展示：

```markdown
=== Memory Review ===

Should save: yes
Reason: [本次邮件确认了可复用的 claim / 发布规则 / 客户沟通规则]

Durable product memory:
[1] memory/rules/email-claims.md -> [claim 规则描述]
[2] memory/rules/email-launch.md -> [发布邮件约定]

Not saved:
- [功能局部邮件内容 / 一次性促销细节]

请审核。输入 all-yes 全部批准，或逐条说明 yes/no/修改内容。
```

---

## 质量检查

输出前自检：

- 是否已同步知识库，或用户明确选择 fallback？
- 模板是否匹配邮件场景？
- 重要 claim 是否有证据来源或 `[待确认]`？
- HTML 是否来自固定模板？
- 用户要求保存时，是否写入 `assets/emails/` 并更新 `assets-index.md`？
- 是否避免了 Gmail、OAuth、`.env` 和发送逻辑？
