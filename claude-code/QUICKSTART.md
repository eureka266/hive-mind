# HiveMind — 快速开始指南

**TL;DR**: 输入 `/prd`，自由讨论，说"好的，生成PRD和facts"，批准事实，完成。

---

## 一分钟概览

HiveMind Skill 帮助你更快地写 PRD，通过：
1. 首先读取你的产品事实
2. 和你讨论功能（无中断）
3. 讨论结束时自动提取事实
4. 请你批准每个事实
5. 发布 PRD + 决策日志到 GitHub（无需手动 git）

---

## 工作流（5 步）

### 步骤 1: 开始
```
你: /prd
Claude: [从知识库加载事实]
Claude: 准备好了。你想写哪个功能的 PRD？
```

### 步骤 2: 讨论
```
你: 我们想要支持 CSV 批量导入，最多 10,000 行...
Claude: [提出澄清问题]
你: [回答问题，继续讨论]
你: ...最后一次讨论...
```

### 步骤 3: 结束讨论
```
你: 好的，生成PRD和facts
Claude: 正在从讨论中提取事实和 PRD...
```

### 步骤 4: 审核事实
```
Claude:
=== 事实候选项 ===

[1] 系统支持单次最多 10,000 行的批量导入
    → 添加到 facts/your-product.md ? (yes/no)

[2] 仅支持精确匹配，不支持模糊匹配
    → 添加到 facts/your-product.md ? (yes/no)

[3] 支持的地区：美国、欧盟、香港、新加坡
    → 添加到 facts/your-product.md ? (yes/no)

你: yes
你: yes
你: yes
```

### 步骤 5: 完成
```
Claude: ✅ 已提交并推送
生成的文件:
  • approved-prds/your-product/prd-csv-import-20260415.md
  • facts/your-product.md (已更新)
  • decisions/decision-20260415-csv-import.md
```

---

## 你需要知道的命令

| 命令 | 作用 |
|---------|-------------|
| `/prd` | 开始新的 PRD 会话 |
| `好的，生成PRD和facts` | 结束讨论，提取事实 |
| `yes` | 批准事实候选项 |
| `no` | 拒绝事实候选项 |
| `all-yes` | 一次性批准所有事实 |

就这么简单。不需要其他命令。

---

## 什么算"事实"？

任何其他 PRD 会需要知道的东西：

✅ **事实** (自动提取):
- "系统支持 X"
- "我们限制 Y 为 Z"
- "API 端点: [列表]"
- "支持的地区: [列表]"
- "定价模型: [描述]"

❌ **不是事实** (被过滤掉):
- "我认为我们应该..."
- "这类似于某个竞品"
- "这需要 2 个工程师"
- "让我们下个月发布"

**经验法则**: "如果另一个 PRD 应该参考这个，那它就是事实。"

---

## 常见场景

### "我想为 CSV 批量导入 API 写一个 PRD"

```
你: /prd
Claude: 准备好了。什么功能？
你: CSV 批量导入 API，支持 10,000 行
你: 使用精确匹配
你: 支持美国、欧盟、香港、新加坡
你: 响应时间预期 2-3 分钟
你: 不支持实时处理，仅支持批处理
好的，生成PRD和facts
[审核事实]
yes
yes
yes
Claude: 完成！
```

### "我们的一个事实有问题"

不要在 PRD 讨论期间编辑。而是：

```
1. 用"好的，生成PRD和facts"结束 PRD
2. 事实被批准并提交
3. 然后去 ~/team-knowledge/facts/your-product.md
4. 直接编辑事实
5. 手动提交: git add facts/your-product.md && git commit
6. 下一个 PRD 会使用更正后的事实
```

### "我需要更新事实而不写 PRD"

直接编辑事实：

```bash
cd ~/team-knowledge
vim facts/your-product.md
git add facts/your-product.md
git commit -m "chore: update [事实类别]"
git push
```

下一个使用 `/prd` 的 PM 会加载更新后的事实。

### "我想参考一个过去的决策"

在 PRD 讨论期间，问我：

```
你: Claude，我想参考 4 月 10 日关于匹配规则的决策
Claude: [从决策日志读取]
Claude: 那个决策是关于精确匹配。这意味着这次的导入校验也应该...
```

所有决策日志都在 `decisions/decision-YYYYMMDD-[功能].md`。

---

## 自动保存什么

你批准事实后，Claude 自动保存 3 样东西：

### 1. 你的 PRD
**文件**: `approved-prds/your-product/prd-[功能]-[日期].md`

```markdown
# PRD: CSV 批量导入 API

**日期**: 2026-04-15
**产品**: Your Product

## 问题
用户需要高效导入大量数据

## 解决方案
支持每次最多 10,000 行的批量 API

## 已确认事实
- 支持单次最多 10,000 行
- 仅精确匹配，无模糊
- 支持地区: [列表]
- ...
```

### 2. 更新的事实
**文件**: `facts/your-product.md` (追加)

新事实添加到现有事实文件中。下一个 PM 自动读取这些。

### 3. 决策日志
**文件**: `decisions/decision-[日期]-[功能].md`

为什么做出这个决策，你假设了什么，不包括什么。

---

## 生成后的记录方式

知识库全局 changelog 已废弃，不再创建或追加 `changelog/`、`CHANGELOG.md`、`meta/CHANGELOG.md`。

- 跨需求时间线或知识库级变更摘要 → `memory/journal/[YYYY-MM-DD].md`
- 决策原因和取舍 → `decisions/`
- 单需求状态和上下文 → `features/[feature]/`

PRD 发布、事实保存和决策沉淀不依赖 changelog。

---

## 故障排除

**问: "找不到知识库"**
A: 知识库在 ~/team-knowledge。确保它在 GitHub 上，HiveMind 能访问。

**问: "Git 推送失败"**
A: 网络问题或权限拒绝。检查你的 git 凭证。Claude 如果自动提交失败会要求你手动 `git push`。

**问: "我说的某句话不应该是事实"**
A: 如果事实被批准：编辑 facts/your-product.md，手动提交。如果还未批准：说"no"，Claude 不会添加它。

**问: "需要回滚 PRD"**
A: 在知识库中手动运行 `git revert`。下一个 PRD 会看到回滚后的状态。

---

## 风格建议

### 这样写
- "我们支持 X"
- "用户可以做 Y"
- "系统要求 Z"

### 不要这样写
- "我们可能支持 X"（太不确定）
- "让我们允许 Y"（意见，不是事实）
- "我认为 Z 会很好"（反馈，不是事实）

事实是你**已经决定**的东西，不是你**正在考虑**的东西。

---

## 一件事

**不要害怕错误的事实反馈。** 如果事实提取有误，就说"no"。Claude 无法伤害任何东西：

- 错误事实被拒绝 → 不添加到 facts/
- 好事实被批准 → 添加到 facts/
- 无论哪种方式 → PRD 仍被发布

试试看，迭代，优化。你写的每个 PRD 都让系统对下一个 PM 更聪明。

---

**准备写你的第一个 PRD?**

```
/prd
```

加油！🚀

---

**版本**: 2.0  
**最后更新**: 2026-04-15
