---
name: hive-mind
description: 从产品讨论自动沉淀知识资产（事实、决策、交互流程），生成可复用的 UI 原型
---

# HiveMind Skill v0.0.3

**核心价值**: 从 PRD 讨论中自动沉淀产品知识（事实、决策、交互），为未来 PRD 和原型生成提供复用资产。

**关键命令**:
- `/prd-discuss` — 开始讨论，自动沉淀知识
- `/ui-draft` — 从交互定义生成可点击的 UI 原型

---

## 📋 快速开始

```
1. /prd-discuss csv-import
   [自由讨论产品功能 30+ 分钟，支持断点保存]

2. 讨论完成时说: "好的，生成交互定义和 PRD"

3. 系统自动提取:
   ✅ facts/your-product.md (产品事实)
   ✅ decisions/decision-[date].md (设计决策)
   ✅ workflows/csv-import.yaml (交互定义)
   ✅ approved-prds/prd-[date].md (PRD 文档)

4. /ui-draft csv-import
   → 生成 prototypes/csv-import.html (可点击原型)
```

---

## 🏗️ 架构

### 双仓库设计

```
Repo A: hive-mind (此目录)
  ├─ 稳定的 Skill 逻辑
  ├─ 更新频率: 很少
  └─ 部署目标: Claude Code

Repo B: team-knowledge (知识库)
  ├─ facts/ .......... 产品事实（哪些功能支持、限制等）
  ├─ decisions/ ...... 设计决策日志（为什么这样设计）
  ├─ workflows/ ...... 交互流程定义（YAML，GPT/Figma 友好）
  ├─ approved-prds/ .. 已发布的 PRD 文档
  ├─ prototypes/ .... 生成的 UI 原型（HTML + Figma JSON）
  └─ 更新频率: 每次 PRD
```

**为什么分离?**
- Skill 代码稳定，知识库频繁变化
- 不同的治理模式（代码审查 vs PM 工作流）
- 支持异步更新

### 知识资产权威层级

讨论功能时，参考优先级:

```
1. facts/ (事实源)
   ├─ 产品边界、功能列表
   ├─ 约束和限制
   └─ 支持范围（地区、币种等）

2. workflows/ (交互流程)
   ├─ 核心用户流程
   ├─ 状态转移
   └─ 错误处理

3. decisions/ (历史决策)
   ├─ 为什么采用这个设计
   ├─ 考虑过的替代方案
   └─ 将来的改进条件

4. approved-prds/ (示例参考)
   └─ 优秀 PRD 的构成方式

5. 当前讨论 (新想法)
   └─ 今天的提案和反馈
```

---

## 📖 工作流

### 阶段 1: 初始化讨论

**用户命令**: `/prd-discuss [feature-name]`

**系统做什么**:
```
0. 同步远端知识库:
   git pull origin main
   (有冲突则暂停，等 PM 手动解决；网络失败则提示并询问是否用本地缓存继续)

1. 从知识库加载:
   ✓ facts/your-product.md
   ✓ workflows/ (已有的交互流程)
   ✓ decisions/ (历史决策)

2. 展示权威层级:
   "已加载 your-product 知识库。
    事实: 23 条（其中 N 条待确认）
    决策: 8 条
    交互流程: 5 个
    准备好讨论了。"

3. **扫描待确认事实**：加载完成后，扫描所有 `facts/` 文件中包含 `[待确认]` 标记的条目。

   - 若**没有**待确认项：跳过此步，直接进入讨论。
   - 若**有**待确认项：调用 `AskUserQuestion` 工具，问题为"发现 N 条待确认事实，现在处理还是稍后？"，选项：
     - `现在逐条确认`
     - `跳过，直接开始讨论`

   选择「现在逐条确认」后，对每条待确认项**依次**调用 `AskUserQuestion` 工具提问：

   **二元判断类**（是/否可以覆盖答案）：
   - 问题：`[待确认内容描述]？`
   - 选项：`[选项 A]`、`[选项 B]`
   - 内置 Other 选项供用户输入自定义答案或修订

   **需要补充值的类**（答案无法枚举）：
   - 问题：`[待确认内容描述]？`
   - 选项：`确认当前描述`、`此项不适用，删除`
   - 内置 Other 选项供用户直接输入具体值

   每条确认后，立即更新 `facts/` 文件：移除 `[待确认]` 标记，写入确认值。跳过的项保持原状不动。

   全部处理完后显示摘要：
   ```
   ✅ 待确认事实处理完毕
   - 已确认: N 条（已写入 facts/）
   - 已跳过: M 条（仍标记为 [待确认]）
   ```

4. 创建会话草稿文件:
   drafts/[date]-[feature]-[pm].md
   (支持讨论中断时恢复)
```

**输出示例**:
```
✅ 已初始化讨论会话: csv-import

权威参考:
- 事实: 支持的地区、API 限制等
- 决策: 为什么只支持精确匹配
- 流程: 类似的批量操作如何设计

会话已保存，可随时中断。
下次运行 /prd-discuss csv-import 即可恢复。
```

---

### 阶段 2: 不间断讨论

**这个阶段** (30+ 分钟)：
- PM 描述功能需求
- AI 提出澄清问题，参考已有知识
- **不中断** — 事实提取发生在讨论结束后
- 支持随时中断，下次恢复

**PM 可以说什么**:
```
"我们想做一个 CSV 批量导入功能。用户选择地区，上传 CSV 文件，
系统验证格式后调用导入 API，返回结果表格。如果验证失败则显示错误。"

"限制: 单次最多 10,000 行（因为性能原因）"

"必须支持: 美国、欧盟、香港、新加坡、日本"

"不支持: 模糊匹配（为了数据一致性）"
```

**AI 的回应** (举例):
```
我看到你想支持的地区。根据现有事实库，your-product 
已经支持这些地区吗？还是需要新增？

关于 10,000 行限制，这个是因为 API 超时吗？
还是考虑了成本因素？

讨论完成后，我会自动提取这些信息。
```

**会话保存**:
- 每 5 分钟自动保存到 `drafts/[date]-[feature].md`
- 讨论中断时，下次恢复从上次位置继续
- 用户可以随时说 "保存进度" 或 "中断讨论"

---

### 阶段 3: 讨论结束标记

**用户说**: 
```
"好的，生成交互定义和 PRD"

或类似表述:
"讨论好了，提取事实"
"生成 PRD 吧"
"该生成了"
```

**系统检测**: 模式匹配关键词 ("生成" + "PRD"/"事实"/"交互") 或明确的结束信号

**输出**:
```
正在分析讨论内容...

发现讨论的核心要素:
✓ 功能: CSV 批量导入
✓ 用户流程: 选择地区 → 上传 → 验证 → 导入 → 结果
✓ 数据: CSV 格式，最多 10,000 行
✓ 支持地区: 5 个
✓ 约束: 精确匹配，不支持模糊

开始提取...
```

---

### 阶段 4: 自动提取和转化

**4.1 事实提取**

使用 10 个规则自动识别事实候选项:

#### 写入位置判断表

提取前，先用这张表判断每条结论应该写到哪个文件：

| 类型 | 判断标准 | 例子 | 写入位置 |
|------|---------|------|--------|
| 产品能力边界 | 描述产品"能做/不能做什么"，跨版本稳定 | "不支持自动删除记录" | `facts/` |
| 配额/数量限制 | 具体的数字限制，影响产品定义 | "仪表盘最多展示 500 个数据源" | `facts/` |
| 定价档位 | 套餐名称、价格、额度等定价事实 | "Essential 套餐含 10,000 次导入" | `facts/` |
| 支持范围 | 支持的地区、币种、司法管辖区 | "支持美国、欧盟、香港" | `facts/` |
| 功能设计决策 | "为什么这样设计"，有替代方案被否决 | "升级弹窗在用量 ≥80% 时触发，而非 ≥90%" | `decisions/` |
| 交互流程 | 用户操作步骤、状态转移、错误处理 | "点击升级 → 选套餐 → Checkout" | `workflows/` |
| UI 形态决策 | 组件选择、布局决定及原因 | "用抽屉而非弹窗，因为内容较长" | `decisions/` |

**判断口诀**：
- 问"这个功能的边界或数字是什么" → `facts/`
- 问"为什么这样设计而不是那样" → `decisions/`
- 问"用户怎么一步步操作" → `workflows/`

---

#### **规则 1-7：产品事实** (来自讨论)

| # | 规则 | 识别模式 | 例子 | 提取到 |
|---|------|---------|------|--------|
| 1 | 功能 | "系统[支持/不支持] X" | "支持批量导入" | facts |
| 2 | 约束 | "我们[限制/要求] X 为 Y" | "限制 10,000 行" | facts |
| 3 | 范围 | "支持[地区/币种]: [列表]" | "支持: 美国、欧盟..." | facts |
| 4 | 依赖 | "[功能] 需要 [条件]" | "导入需要先验证格式" | facts |
| 5 | API | "端点[: /path or 调用]" | "调用 /api/import/check" | facts |
| 6 | 定价 | "定价[模型/费用]: [描述]" | "按导入数收费" | facts |
| 7 | 边界 | "[X] 不[支持/包括] [Y]" | "不支持模糊匹配" | facts |

#### **规则 8-10：交互流程** (新增)

| # | 规则 | 识别模式 | 例子 | 提取到 |
|---|------|---------|------|--------|
| 8 | 状态流 | "用户 [动作], 然后 [系统响应]" or "流程: [步骤 1] → [步骤 2]" | "用户上传，系统验证，显示结果" | workflows |
| 9 | UI 组件 | "组件"/"选择器"/"按钮"/"表格"/"对话框" | "下拉选择器"/"CSV 上传"/"结果表格" | workflows |
| 10 | 错误处理 | "如果 [情况], [响应]" or "[X] 失败" | "如果验证失败，显示错误" | workflows |

---

**4.2 自动生成交互定义** (YAML 格式)

系统自动生成 `workflows/csv-import.yaml`:

```yaml
interaction:
  name: "CSV 批量导入"
  feature: "csv-import"
  created_at: "2026-04-16"
  
  # 从讨论自动提取的状态定义
  states:
    initial:
      name: "地区选择"
      display:
        - component: "select"
          name: "region"
          label: "选择导入地区"
          options: ["美国", "欧盟", "香港", "新加坡", "日本"]
          required: true
      actions:
        - button: "下一步"
          next_state: "upload"
    
    upload:
      name: "文件上传"
      display:
        - component: "file_upload"
          name: "file"
          accept: ".csv"
          label: "上传数据列表 (CSV)"
          help_text: "最多 10,000 行"
          required: true
      actions:
        - button: "开始导入"
          action: "validate_and_process"
        - button: "返回"
          next_state: "initial"
    
    processing:
      name: "导入中"
      display:
        - component: "progress_bar"
          label: "正在导入数据..."
          indeterminate: true
      # 自动转移到 result 状态
    
    result:
      name: "导入结果"
      display:
        - component: "table"
          name: "results"
          label: "数据导入结果"
          columns:
            - name: "row"
              label: "记录"
              type: "string"
            - name: "status"
              label: "导入结果"
              type: "enum"
              values: ["成功", "失败", "需审核"]
            - name: "level"
              label: "优先级"
              type: "enum"
              values: ["低", "中", "高"]
      actions:
        - button: "导出 CSV"
          action: "download_csv"
        - button: "新增导入"
          next_state: "initial"
    
    error:
      name: "验证失败"
      display:
        - component: "alert"
          type: "error"
          message: "{{ error_message }}"
          help_text: "请检查 CSV 格式或行数"
      actions:
        - button: "返回上传"
          next_state: "upload"
  
  # 状态转移规则
  flow:
    - from: "initial"
      to: "upload"
      on: "next_step"
    
    - from: "upload"
      to: ["processing", "error"]
      on: "validate"
      condition:
        - "file_format == csv"
        - "row_count <= 10000"
    
    - from: "processing"
      to: "result"
      on: "api_success"
    
    - from: "result"
      to: ["initial", "upload"]
      on: "new_check"
    
    - from: "error"
      to: "upload"
      on: "retry"
  
  # 数据验证规则 (从讨论的约束提取)
  validation:
    - field: "file"
      rules:
        - type: "must_be_csv"
          error: "请上传 CSV 文件"
        - type: "max_rows_10000"
          error: "超过 10,000 行限制"
        - field: "region"
          rules:
            - type: "required"
              error: "请选择地区"
  
  # 事实引用 (连接到 facts/)
  facts_used:
    - "支持的地区: 美国、欧盟、香港、新加坡、日本"
    - "单次批量限制: 10,000 行"
    - "支持的格式: CSV"
    - "不支持: 模糊匹配"
```



---

**4.3 生成 PRD**

同步生成 `approved-prds/your-product/prd-csv-import-[date].md`:

```markdown
# PRD: CSV 批量导入

**日期**: 2026-04-16
**产品**: Your Product
**作者**: [PM 名称]

## 概述
用户可以上传 CSV 文件，批量导入多条记录。
支持 5 个地区，单次最多 10,000 行。

## 问题
手动逐条录入数据耗时，用户需要批量操作能力。

## 解决方案
提供批量导入界面：
1. 用户选择导入地区
2. 上传 CSV 文件（最多 10,000 行）
3. 系统验证格式
4. 调用导入 API
5. 显示结果表格（可导出）

## 已确认的产品事实
- ✅ 支持地区: 美国、欧盟、香港、新加坡、日本
- ✅ 单次限制: 10,000 行
- ✅ 文件格式: CSV only
- ✅ 匹配模式: 精确匹配（不支持模糊）
- ✅ 必须先验证格式，再调用 API

## 交互流程
见 `workflows/csv-import.yaml` (机器可读格式)

关键流程:
```
选择地区 → 上传 CSV → 验证格式 → 调用 API → 显示结果 → 导出或重新导入
                          ↓
                    [验证失败] → 返回上传
```

## 实现备注
- API 端点: POST /api/import/batch
- 性能: 10k 行 ~5 秒
- 超时: 30 秒（需异步处理大批量）

## 待定问题
- 是否需要支持超过 10k 的异步处理？
- 是否需要进度通知（邮件/通知）？

---
**关联决策**: `decisions/decision-2026-04-16-csv-import.md`
```

---

**4.4 生成决策日志**

同步生成 `decisions/decision-[date]-csv-import.md`:

```markdown
# 决策日志: CSV 批量导入

**日期**: 2026-04-16
**功能**: CSV 批量导入 API
**决策者**: [PM 名称]

## 核心决策

### 1. 单次限制 10,000 行

**选项 A**: 无限制
  ❌ 性能问题（100k 行会超时）
  ❌ 成本问题（API 配额不支持）
  ❌ UX 问题（大批次难以调试失败）

**选项 B**: 10,000 行 ← **选中**
  ✅ 平衡性能和功能
  ✅ 5 秒内返回结果
  ✅ 可管理的重试成本

**选项 C**: 更小（如 1,000）
  ✅ 更快响应
  ❌ 用户需要拆分多次，体验差

**权衡**: 选择 10,000 是性能、成本、UX 的平衡点

**如果...**:
  - 优化了后端异步处理 → 可以支持 100k+ (v2.1)
  - 业务要求实时性能 → 改为 5,000 (遵从)

---

### 2. 只支持精确匹配，不支持模糊匹配

**选项 A**: 支持模糊匹配
  ❌ 准确度只有 80-85%
  ❌ 数据一致性风险（对账需要 100% 确定）
  ✅ 用户友好，容错强

**选项 B**: 只支持精确匹配 ← **选中**
  ✅ 准确度 100%，数据可靠
  ✅ 清晰的产品边界
  ❌ 用户需要精确输入

**权衡**: 选择一致性和准确性，牺牲部分便利

**将来**: 如果业务放松或用户强烈要求，可以在 v2.2 添加一个"容错模式"

---

## 不在范围内
- 异步处理（超过 10k 行）
- 模糊匹配
- 实时 webhook 通知

---

**相关 PRD**: `approved-prds/your-product/prd-csv-import-[date].md`
```

---

### 阶段 5: 批量审核

⚠️ **MANDATORY STOP（强制暂停）**: 提取完成后，必须先向用户展示候选列表，**等待用户明确输入审核结果后**，才能写入任何文件。不得跳过此步骤直接写文件。

**系统展示**:
```
=== 自动提取的事实和交互定义 ===

✓ 事实候选项:
  [1] 功能: 支持批量导入最多 10,000 行
  [2] 约束: 限制精确匹配，不支持模糊匹配
  [3] 范围: 支持地区: 美国、欧盟、香港、新加坡、日本
  [4] 依赖: 导入前必须验证 CSV 格式

✓ 生成的交互定义:
  [5] 状态流: 选择地区 → 上传 → 验证 → 导入 → 结果
  [6] UI 组件: select(地区) + file_upload(CSV) + table(结果)
  [7] 错误处理: 验证失败 → 显示错误并返回上传

✓ 生成的决策权衡:
  [8] 为什么 10,000? 性能/成本/UX 的平衡
  [9] 为什么不模糊匹配? 数据一致性要求

```

展示完成后，**调用 `AskUserQuestion` 工具**，问题为"请审核以上提取结果"，选项：
- `全部批准，写入知识库`
- `逐条审核`
- `取消本次提取`

选择「逐条审核」时，对每条候选项**依次**调用 `AskUserQuestion`，选项：`批准`、`删除`，内置 Other 供用户修改内容后批准。

**PM 操作示例**:
```
点击 [全部批准，写入知识库]

或点击 [逐条审核] 后逐条确认：
[1] 批准 / 删除
[2] 批准 / 删除
...
5: yes
6: no (需要调整 UI 组件的字段)
7: yes
8: yes
9: yes

6 不批准。请修改:
[系统调整交互定义]
6: yes now
```

---

### 阶段 6: 自动提交 + 推送

**系统做什么**:

```bash
cd ~/team-knowledge

# 步骤 1: 拉取最新版本（防止冲突）
git pull origin main

# 步骤 2: 检查冲突
if [ 冲突 ]; then
  报告给 PM，询问是否手动解决或重新讨论
  exit
fi

# 步骤 3: 创建文件
git add approved-prds/your-product/prd-csv-import-[date].md
git add decisions/decision-2026-04-16-csv-import.md
git add workflows/csv-import.yaml
git add facts/your-product.md (更新，追加新事实)

# 步骤 4: 提交
git commit -m "chore: add csv-import PRD and workflows

Features:
- CSV batch import (10k limit)
- Support 5 regions (US, EU, HK, SG, JP)
- Exact matching only (no fuzzy match)

Interactions:
- workflows/csv-import.yaml

Decisions:
- decision-2026-04-16-csv-import.md

Auto-committed by HiveMind Skill v3"

# 步骤 5: 推送
git push origin main

# 如果推送失败（远程有新提交）
if [ 失败 ]; then
  git pull origin main --rebase
  git push origin main
fi
```

**输出成功**:
```
✅ 已提交并推送！

生成的资产:
  ✓ facts/your-product.md (更新)
  ✓ workflows/csv-import.yaml (新)
  ✓ decisions/decision-2026-04-16-csv-import.md (新)
  ✓ approved-prds/your-product/prd-csv-import-2026-04-16.md (新)

下一步: 运行 /ui-draft csv-import 生成可交互原型
```

---

### 阶段 7: 生成 UI 原型 (新功能)

**用户命令**: `/ui-draft csv-import`

**系统做什么**:

1. **读取交互定义**
   - 从 `workflows/csv-import.yaml` 读取完整定义
   - 验证所有必要字段存在

2. **生成 HTML 原型**
   - 每个 `state` → HTML 页面/模式窗口
   - 每个 `component` → HTML 表单元素
   - 每个 `action` 按钮 → 状态转移逻辑
   - 自动生成 CSS (简单而专业的样式)
   - 自动生成 JavaScript (状态机 + 交互逻辑)

3. **输出文件**
   ```
   prototypes/csv-import.html       ← 可直接打开的原型
   prototypes/csv-import-figma.json ← 导入 Figma
   prototypes/csv-import-code.json  ← 开发者参考代码结构
   ```

**生成的 HTML 示例**:

```html
<!DOCTYPE html>
<html>
<head>
  <title>CSV Batch Import</title>
  <style>
    /* 自动生成的简洁 UI 样式 */
    body { font-family: -apple-system, BlinkMacSystemFont, sans-serif; }
    .state { padding: 2rem; max-width: 600px; margin: 0 auto; }
    .select, .file-upload, .button { padding: 0.75rem; margin: 0.5rem 0; }
    .table { width: 100%; border-collapse: collapse; }
    .table th, .table td { padding: 0.75rem; text-align: left; border-bottom: 1px solid #ddd; }
  </style>
</head>
<body>
  <div id="app">
    <!-- 初始状态: 地区选择 -->
    <div id="state-initial" class="state">
      <h2>CSV 批量导入</h2>
      <label for="region">选择导入地区</label>
      <select id="region" name="region" class="select" required>
        <option value="">-- 请选择 --</option>
        <option value="us">美国</option>
        <option value="eu">欧盟</option>
        <option value="hk">香港</option>
        <option value="sg">新加坡</option>
        <option value="jp">日本</option>
      </select>
      <button class="button" onclick="nextState('upload')">下一步</button>
    </div>

    <!-- 上传状态 -->
    <div id="state-upload" class="state" style="display:none">
      <h2>上传数据列表</h2>
      <p>最多 10,000 行</p>
      <input type="file" id="file" accept=".csv" class="file-upload" />
      <div id="error-message" style="color: red; margin: 0.5rem 0;"></div>
      <button class="button" onclick="validateAndProcess()">开始导入</button>
      <button class="button" onclick="nextState('initial')">返回</button>
    </div>

    <!-- 处理状态 -->
    <div id="state-processing" class="state" style="display:none">
      <h2>导入中...</h2>
      <progress id="progress-bar" value="0" max="100"></progress>
    </div>

    <!-- 结果状态 -->
    <div id="state-result" class="state" style="display:none">
      <h2>导入结果</h2>
      <table class="table" id="results-table">
        <thead>
          <tr>
            <th>记录</th>
            <th>导入结果</th>
            <th>优先级</th>
          </tr>
        </thead>
        <tbody id="results-body">
          <!-- 动态填充 -->
        </tbody>
      </table>
      <button class="button" onclick="downloadCSV()">导出 CSV</button>
      <button class="button" onclick="nextState('initial')">新增导入</button>
    </div>

    <!-- 错误状态 -->
    <div id="state-error" class="state" style="display:none">
      <h2>验证失败</h2>
      <div id="error-detail" style="color: red; padding: 1rem; background: #ffe0e0; border-radius: 4px;"></div>
      <button class="button" onclick="nextState('upload')">返回上传</button>
    </div>
  </div>

  <script>
    // 自动生成的状态机逻辑
    const interaction = {
      currentState: 'initial',
      data: {
        region: null,
        file: null,
        results: []
      }
    };

    function nextState(newState) {
      // 隐藏所有状态
      document.querySelectorAll('.state').forEach(el => el.style.display = 'none');
      // 显示新状态
      document.getElementById(`state-${newState}`).style.display = 'block';
      interaction.currentState = newState;
    }

    function validateAndProcess() {
      const region = document.getElementById('region').value;
      const file = document.getElementById('file').files[0];
      const errorDiv = document.getElementById('error-message');

      // 验证逻辑（自动生成）
      if (!file) {
        errorDiv.textContent = '请选择文件';
        return;
      }

      if (!file.name.endsWith('.csv')) {
        errorDiv.textContent = '请上传 CSV 文件';
        return;
      }

      // 这里会有实际的 CSV 验证逻辑
      interaction.data.region = region;
      interaction.data.file = file;

      nextState('processing');

      // 模拟 API 调用
      setTimeout(() => {
        // 实际项目中这里会调用真实 API
        interaction.data.results = [
          { row: 'Row 1', status: '成功', level: '低' },
          { row: 'Row 2', status: '失败', level: '高' },
          { row: 'Row 3', status: '需审核', level: '中' }
        ];
        showResults();
        nextState('result');
      }, 2000);
    }

    function showResults() {
      const tbody = document.getElementById('results-body');
      tbody.innerHTML = interaction.data.results.map(row => `
        <tr>
          <td>${row.row}</td>
          <td>${row.status}</td>
          <td>${row.level}</td>
        </tr>
      `).join('');
    }

    function downloadCSV() {
      const csv = [
        ['记录', '导入结果', '优先级'],
        ...interaction.data.results.map(r => [r.row, r.status, r.level])
      ].map(row => row.join(',')).join('\n');

      const blob = new Blob([csv], { type: 'text/csv' });
      const url = window.URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = 'results.csv';
      a.click();
    }

    // 初始化
    nextState('initial');
  </script>
</body>
</html>
```

**输出**:
```
✅ UI 原型已生成！

📄 输出文件:
  ✓ prototypes/csv-import.html (1.2 KB)
    → 直接在浏览器打开即可交互测试
  
  ✓ prototypes/csv-import-figma.json (0.8 KB)
    → 可导入 Figma 作为设计稿
  
  ✓ prototypes/csv-import-code.json (0.5 KB)
    → 开发者参考，已包含代码结构

下一步: 在浏览器打开 HTML 原型进行交互测试
```

---

## 🔄 其他命令

### `/ui-draft edit [feature]`

编辑交互定义，重新生成原型:

```bash
/ui-draft edit csv-import

# 系统打开交互定义编辑模式
# 你可以修改:
# - 字段名、标签、验证规则
# - 状态、转移逻辑
# - UI 组件类型
# - 错误提示文案

# 修改后重新生成:
# "好的，更新原型"
# → 自动重新生成 HTML 和 Figma JSON
```

### `/ui-draft export [feature] --format=figma`

导出为 Figma 设计稿:

```bash
/ui-draft export csv-import --format=figma

✅ 已生成 Figma JSON
   可以复制粘贴到 Figma 中，或用 figma-api 直接导入
```

### `/ui-draft view [feature]`

查看已生成的原型:

```bash
/ui-draft view csv-import

✅ 原型信息:
   创建时间: 2026-04-16 14:30
   状态数: 5
   组件数: 8
   大小: 1.2 KB
   
   查看原型: [打开链接]
```

---

## 💾 草稿保存机制

### 讨论中断恢复

```
会话 1 (下午 2:00):
  /prd-discuss csv-import
  [讨论 20 分钟]
  → 自动保存到 drafts/2026-04-16-csv-import-[pm-name].md

网络断线或用户离开

会话 2 (下午 3:00):
  /prd-discuss csv-import
  
  [系统检测到草稿]
  📋 发现之前的讨论草稿 (20 分钟)
  是否恢复? (yes/no)
  
  yes
  
  [从上次位置继续讨论]
  [继续 30 分钟]
  
  "好的，生成交互定义和 PRD"
  
  ✅ 已提交 (包含全部 50 分钟的讨论内容)
```

### 草稿文件格式

```markdown
# 讨论草稿: csv-import

**开始时间**: 2026-04-16 14:00
**PM**: 王五
**功能**: CSV 批量导入

---

## 讨论历史

### [14:00-14:10] PM 初始需求
王五: "我们想做一个 CSV 批量导入功能..."

### [14:10-14:15] 澄清问题
AI: "支持的地区是固定的吗？"
王五: "是的，这 5 个地区"

### [14:15-14:20] 限制讨论
王五: "限制 10,000 因为..."

...

---

## 待提取的信息 (自动汇总)
- 产品事实: [...]
- 决策权衡: [...]
- 交互流程: [...]

---

**状态**: 进行中
**最后更新**: 2026-04-16 14:25

下次运行 /prd-discuss csv-import 即可继续
```

---

## 🎯 设计原则

1. **知识优先** — 所有讨论的目标是沉淀可复用的知识（事实、决策、交互）
2. **不中断讨论** — 事实提取发生在讨论结束后，保留 PM 的思路
3. **多种输出** — 同一个讨论生成 PRD、事实库、交互定义、原型
4. **快速迭代** — 交互定义可编辑，快速调整后重新生成原型
5. **标准化格式** — YAML 交互定义，GPT/Figma 都能理解
6. **双仓库分离** — Skill 稳定，知识库灵活更新

---

## 📊 知识复用示例

### 第一次 PRD: CSV 批量导入

```
讨论 → 提取 → 生成 workflows/csv-import.yaml
          → 生成 UI 原型 (HTML)
          → 保存到知识库
```

### 第二次 PRD: 批量用户邀请 (类似功能)

```
参考 workflow/csv-import.yaml
↓
复用交互逻辑 (选择 → 上传 → 验证 → 导入 → 结果)
↓
只需要修改:
  - 上传类型 (用户邮箱列表而非数据行)
  - 结果字段 (邀请状态而非导入状态)
↓
快速生成新原型 (/ui-draft batch-invite)
```

---

## ❌ 有意不实现的功能

这些选择是**设计决策**，不是遗忘:

- ❌ **跨产品复用** — 每个产品的工作流是独立的，不共享
- ❌ **AI 自学新规则** — 新的提取规则需要人工审查，不自动扩展
- ❌ **所见即所得 UI 编辑器** — 交互定义在 Figma/代码中编辑，不在这里

---

## 📋 快速参考

| 需求 | 命令 | 输出 |
|------|------|------|
| 开始讨论 | `/prd [feature]` | 先 git pull，再开启讨论会话 |
| 完成讨论 | "好的，生成交互定义和 PRD" | 5 个文件 (facts/decisions/workflows/prds) + git push |
| 本地改完推送 | `/prd push [feature]` 或 "推送到 GitHub" | git pull → 展示 diff → 确认 → git push |
| 生成原型 | `/ui-draft [feature]` | HTML + Figma JSON |
| 编辑交互 | `/ui-draft edit [feature]` | 编辑模式 |
| 查看原型 | `/ui-draft view [feature]` | 原型信息和链接 |

---

## 🔗 关键文件

**知识库 (Repo B)** 中:
- `facts/your-product.md` — 所有产品事实
- `workflows/*.yaml` — 交互定义（可生成原型）
- `decisions/*.md` — 设计决策日志
- `approved-prds/` — 已发布 PRD
- `prototypes/` — 生成的 HTML 原型
- `drafts/` — 讨论进行中的草稿

**Skill (Repo A)** 中:
- `SKILL.md` — 这个文件
- `skill.yaml` — 配置
- `agents/` — 可选的 AI 代理配置

---

## 👨‍💼 维护

**更新 Skill**:
1. 编辑 `SKILL.md`
2. 本地测试
3. 提交到 Repo A

**更新知识库**:
1. 通过 `/prd-discuss` 添加新知识
2. 或直接编辑 `facts/`, `workflows/` 等
3. 不需要更新 Skill 代码

---

**Skill 版本**: 0.0.3  
**最后更新**: 2026-04-16  
**维护**: HiveMind
