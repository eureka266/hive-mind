---
name: gtm
description: HiveMind 商业化与内容营销命令。基于产品事实、PRD、决策记录、用户手册、FAQ 和竞品资料，生成 GTM 文章方向、卖点框架、官网/LinkedIn/销售内容表达。输入 /gtm [主题] 使用。
---

# gtm

HiveMind 的商业化和内容营销命令。用于帮助商业化、内容营销、销售 enablement 同事把内部产品知识转成外部可用的市场表达。

`/gtm` 默认产出“文章方向 + 卖点框架”，不是完整 campaign 计划。它必须优先凸显你的产品相比竞品和替代方案的核心优势，而不是把内容写成 UX 优化清单。

如果用户要的是产品通知邮件、邮件营销、newsletter、客户邮件、销售触达邮件、续费提醒或 HTML 邮件，不要在 `/gtm` 内完成邮件生成；转入 `/email` 工作流。`/gtm` 可以先定义定位和卖点，但 `/email` 负责基于固定模板生成可直接发送的 HTML 邮件，并沉淀到 `assets/emails/`。

## 语言规则

- 对话和工作过程默认中文；市场内容按用户指定语言输出，未指定且用户用中文沟通时默认中文。
- 用户自己的产品名、功能名、API 名和领域术语保留英文原样，不要翻译或改写；竞品名同样保留原样。
- 如果输出会写入 `customer-knowledge/`，该文件内容必须全部英文；聊天中的解释、审批问题和证据说明仍默认中文。

## 使用方式

```text
/gtm [topic]
/gtm 写一篇你的产品相比竞品的核心优势文章
/gtm dashboard reporting notifications 这几个能力怎么包装成官网文章
/gtm --battle-angle 你的产品 vs Competitor A
/email 写一封产品更新邮件，中文和英文，生成 HTML 并保存到资产库
```

## 工作流

### Phase 0: 知识库健康检查（自动）

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

### 阶段 1: 拉取并同步知识库

1. 进入知识库并同步最新内容（Phase 0 已确认目录存在）：

2. 进入知识库并同步最新内容：

   ```bash
   cd ~/team-knowledge
   git pull --ff-only origin main
   ```

2. 如果 pull 因网络、权限或本地变更失败，必须停止读取资料并向用户说明：
   - 失败原因
   - 是否存在本地缓存
   - 可选路径：稍后重试、使用本地缓存、或仅基于用户提供材料产出 chat-only 版本

   不要假装已经加载了最新知识库。

### 阶段 1b: Active Memory Setup

同步知识库后，加载 memory/rules/ 中与 GTM 相关的可复用规则：

- 扫描 `memory/rules/` 中标记为 `gtm / claim / competitive / product-copy / customer-language` 的规则。
- 如有已有 GTM 规则（如：竞品对比必须标 `[待确认]`、不能以 UI 优化为主叙事），在本次输出中自动应用。

报告 memory 摘要：
```
Memory loaded:
- Active GTM rules: [N rules — claim / competitive / product-copy / customer-language]
```

---

### 阶段 2: 读取产品相关资料

1. 优先读取：
   - `facts/product.md`
   - `customer-knowledge/faq/competitive-comparison.md`
   - `customer-knowledge/faq/product-faq.md`
   - `customer-knowledge/faq/sales-faq.md`
   - `customer-knowledge/user_manual/product-features.md`
   - `customer-knowledge/user_manual/dashboard-guide.md`
   - `customer-knowledge/user_manual/reporting-guide.md`
   - `customer-knowledge/user_manual/onboarding-guide.md`
   - `customer-knowledge/api_doc/*.md`
   - `competitors/*.md`
   - `approved-prds/*`
   - `decisions/*`

2. 搜索主题词以及以下关键词：
   `dashboard`、`reporting`、`notifications`、`search`、`billing`、`API`、`user onboarding`、`CSV import`、`competitor`、`Competitor A` 以及用户自己的产品名、功能名和竞品名。

### 阶段 3: 提炼商业叙事

必须先形成 3-5 个差异化卖点，再写文章结构。优先考虑：

- dashboard：核心数据视图和状态总览
- reporting：用量、转化或运营分析能力
- notifications：主动提醒、提示、建议和下一步行动
- search：检索、定位和可配置能力
- API / integration：可嵌入业务流程和规模化使用
- 工作流闭环：CSV import、用户 onboarding、billing、dashboard、reporting、notifications

不要把内容中心放在“界面更清楚”“流程更顺”“点击更少”等小 UX 点。可以提到体验，但只能作为核心能力的支撑，不作为主叙事。

### 阶段 4: 证据约束

- 每个主要 claim 都必须绑定证据来源：事实、PRD、decision、用户手册、FAQ、API 文档或竞品资料。
- 不要虚构产品能力或竞品能力。
- 未确认内容标记为 `[待确认]`。
- 竞品对比要精确、公平；如果证据不完整，说明“已知/未知”。

### 阶段 5: 输出

默认输出：

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

如果用户只要大纲，关键段落保持短。若用户要求完整文章，除非他说“直接写”，否则先给定位框架，再写完整稿。

### Memory Review Gate

输出后，判断本次 GTM 工作是否产生了可复用的 claim 规则、竞品对比规则或客户语言规则。

好的规则候选（来自 GTM）：
- 竞品对比的证据要求（如：未经验证的竞品功能断言必须标 `[待确认]`）。
- 主叙事约束（如：不能以 UX 优化为核心差异化点）。
- 产品声明的证据绑定规则（如：每个主要 claim 必须有 facts 或 PRD 来源）。
- 特定受众的语言偏好（如：面向运营负责人的表达方式）。

发现规则候选时展示：

```markdown
=== Memory Review ===

Should save: yes
Reason: [本次 GTM 确认了可复用的 claim / 竞品对比 / 客户语言规则]

Durable product memory:
[1] memory/rules/gtm-claims.md -> [可复用规则描述]
[2] memory/rules/gtm-competitive.md -> [竞品对比规则]

Not saved:
- [功能局部 GTM 细节 / 临时 campaign 内容]

请审核。输入 all-yes 全部批准，或逐条说明 yes/no/修改内容。
```

---

## 质量检查

输出前自检：

- 核心叙事是否聚焦商业价值和产品优势，而不是 UI polish？
- 是否考虑了 dashboard、reporting、notifications、search、API 或工作流闭环？
- 每个重要 claim 是否有来源或 `[待确认]`？
- 商业化同事是否无需阅读 PRD 就能直接使用这份内容？
