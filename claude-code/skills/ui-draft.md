---
name: ui-draft
description: HiveMind 原型生成命令。从交互定义（workflows/*.yaml）自动生成可点击的 HTML 原型，并可与 Figma 双向同步。输入 /ui-draft [功能名] 生成原型。
---

# ui-draft

HiveMind 的原型生成命令。从 `/prd` 产出的交互定义，生成可点击 HTML 原型，并通过 Figma MCP 与 Figma 双向同步。

## 使用方式

```
/ui-draft [feature-name]                    # 生成 HTML 原型
/ui-draft edit [feature-name]               # 编辑交互定义后重新生成
/ui-draft view [feature-name]               # 查看原型信息
/ui-draft --figma [feature-name]            # 推送线框图到 Figma（需要 Figma MCP）
/ui-draft --from-figma [figma-url]          # 从 Figma 反向同步回 workflows YAML
```

例如:
```
/ui-draft csv-import
/ui-draft --figma csv-import
/ui-draft --from-figma [你的 Figma 文件链接]
```

## Figma 画布配置

**文件**: 你的 Figma 原型文件  
**fileKey**: `[你的 Figma fileKey]`  
**原型页面**: `HiveMind Prototypes`（pageId: `[你的 pageId]`）  
**命名规范**: `[feature-name] · [YYYY-MM-DD]`（每个功能一个 Section）

---

## 前提条件

需要先有对应的交互定义文件:
`~/team-knowledge/workflows/[feature].yaml`

通过 `/prd-discuss [feature]` 讨论后自动生成。

---

## 工作流

### 生成原型: `/ui-draft [feature]`

1. **同步远端知识库**
   ```bash
   cd ~/team-knowledge
   git pull origin main
   ```

   - 成功：继续读取最新 workflow
   - 有冲突：报告给用户，暂停生成，等待手动解决后重新运行
   - 网络失败：提示无法拉取远端，让用户选择使用本地缓存还是稍后重试

2. **Active Memory Setup**：加载 feature workspace 和可复用 UX 规则：
   - 优先读取 `features/[feature]/workflow.yaml`（如存在），否则回退到 `workflows/[feature].yaml`
   - `features/[feature]/context.md` — 当前功能范围和假设
   - `features/[feature]/memory.md` — 近期会话笔记
   - `memory/rules/` — 与 ux / prototype / interaction 相关的规则

   报告 memory 摘要：
   ```
   Memory loaded:
   - Feature workspace: [found / not found]
   - Workflow YAML: [features/[feature]/workflow.yaml / workflows/[feature].yaml / not found]
   - Active rules: [N rules — ux / prototype]
   ```

3. **读取交互定义**（按优先级）
   ```
   ~/team-knowledge/features/[feature]/workflow.yaml   ← 优先
   ~/team-knowledge/workflows/[feature].yaml           ← 回退
   ```

3. **解析结构**
   - `states` → 每个状态对应一个 UI 视图
   - `components` → select / file_upload / table / button / alert 等
   - `flow` → 状态转移规则（点击后跳转到哪里）
   - `validation` → 表单验证规则

4. **生成输出**（双路径）
   ```
   ~/team-knowledge/features/[feature]/prototype.html   ← 主路径（feature workspace）
   ~/team-knowledge/prototypes/[feature].html           ← 副路径（legacy 兼容）
   ```

5. **确认结果（输出格式）**

   ```
   ✅ UI 原型已生成！
   
   ─── 查看方式 ──────────────────────────────────────
   
   📄 HTML 可交互原型（在浏览器中打开）：
      主路径: ~/team-knowledge/features/[feature]/prototype.html
      副路径: ~/team-knowledge/prototypes/[feature].html
      打开命令: open ~/team-knowledge/features/[feature]/prototype.html
   
      原型包含：
      · 可点击的状态机（按钮点击后切换到下一个状态）
      · 表单验证（上传错误格式 / 超出行数限制时显示错误提示）
      · 模拟数据（结果表格自动填充示例数据）
      · Claude Code 本身不支持预览 HTML，需在浏览器中查看
   
   🎨 推送到 Figma 线框图（可选）：
      运行: /ui-draft --figma [feature]
      查看: 你的 Figma 文件
            → 页面「HiveMind Prototypes」
            → Section「[feature] · [YYYY-MM-DD]」
   
   ─────────────────────────────────────────────────
   状态数: N 个
   组件数: M 个
   ```

### Memory Review Gate

原型生成后，判断是否产生了可复用的 UX 或交互模式规则。

发现规则候选时展示：

```markdown
=== Memory Review ===

Should save: yes
Reason: [本次原型发现了可复用的 UX 模式 / 组件用法 / 状态机设计]

Feature workspace updates:
[1] features/[feature]/prototype.html -> [已生成]
[2] features/[feature]/memory.md -> [prototype notes]

Durable product memory:
[3] memory/rules/ux-[category].md -> [可复用 UX 规则描述]

Not saved:
- [功能局部 UI 细节]

请审核。输入 all-yes 全部批准，或逐条说明 yes/no/修改内容。
```

---

### 编辑: `/ui-draft edit [feature]`

打开交互定义编辑模式，修改后重新生成:

1. 显示当前 `workflows/[feature].yaml` 内容
2. PM 描述需要修改的部分
3. AI 更新 YAML
4. 重新生成 HTML + Figma JSON
5. 保存更新后的 YAML

常见修改:
- 增减字段或列
- 修改验证规则
- 调整状态转移
- 更改按钮文案

---

### 导出: `/ui-draft export [feature]`

生成 Figma 可导入的 JSON 格式:

```
✅ Figma JSON 已生成
文件: prototypes/[feature]-figma.json

导入方法:
1. 复制 JSON 内容
2. 在 Figma 中: 菜单 → Plugins → 粘贴 JSON
或直接用 Figma API 导入
```

---

### 查看: `/ui-draft view [feature]`

```
✅ 原型信息:
功能名: [feature]
创建时间: YYYY-MM-DD
状态数: N
组件数: M
最后更新: YYYY-MM-DD

文件:
- prototypes/[feature].html
- prototypes/[feature]-figma.json
```

---

## 支持的 UI 组件

生成原型时支持以下组件类型:

| 组件类型 | HTML 元素 | 说明 |
|---------|-----------|------|
| `select` | `<select>` | 下拉选择器 |
| `file_upload` | `<input type="file">` | 文件上传 |
| `table` | `<table>` | 结果表格（支持排序） |
| `button` | `<button>` | 操作按钮 |
| `alert` | `<div class="alert">` | 错误/成功提示 |
| `progress_bar` | `<progress>` | 进度条 |
| `text_input` | `<input type="text">` | 文本输入 |
| `textarea` | `<textarea>` | 多行文本 |
| `checkbox` | `<input type="checkbox">` | 多选框 |
| `radio` | `<input type="radio">` | 单选框 |

---

## 生成的 HTML 特性

- ✅ 状态机逻辑 — 点击按钮自动切换状态
- ✅ 表单验证 — 根据 validation 规则提示错误
- ✅ 响应式样式 — 适配不同屏幕宽度
- ✅ 导出功能 — 结果表格可导出 CSV
- ✅ 模拟数据 — 自动生成示例数据展示效果

---

## 交互定义格式参考

`workflows/[feature].yaml` 的标准结构:

```yaml
interaction:
  name: "功能名称"
  feature: "feature-name"
  
  states:
    state_name:
      name: "显示名称"
      display:
        - component: "select|file_upload|table|..."
          name: "字段名"
          label: "用户看到的标签"
          options: [...]     # select 用
          columns: [...]     # table 用
          accept: ".csv"     # file_upload 用
      actions:
        - button: "按钮文字"
          next_state: "下一个状态"
          action: "动作名"   # 或触发函数
  
  flow:
    - from: "state_a"
      to: "state_b"
      on: "event"
  
  validation:
    - field: "字段名"
      rules:
        - type: "required|max_rows_N|must_be_csv|..."
          error: "错误提示文字"
```

---

## Figma 双向同步

### 推送到 Figma：`/ui-draft --figma [feature]`

**前提**：Claude Code 已安装 Figma 插件（`/plugins install figma` 并完成授权）。

工作流：

1. 读取 `workflows/[feature].yaml`
2. 在 `HiveMind Prototypes` 页面创建一个新 Section，命名为 `[feature] · [YYYY-MM-DD]`
3. 按 `states` 逐帧生成线框图：
   - 每个 state → 一个 Frame（1440×900）
   - `display[].component` → 对应 UI 组件（select、table、file_upload 等）
   - `actions[].button` → 底部操作按钮
   - `flow` 中的状态转移 → Frame 之间的连线（Prototype connections）
4. 确认结果：
   ```
   ✅ Figma 线框图已生成！
   
   Section: csv-import · 2026-04-16
   Frames: 4 个（upload → validating → importing → result）
   
   查看方式：
   · 浏览器打开你的 Figma 文件，切换到「HiveMind Prototypes」页面
   · 找到 Section「csv-import · 2026-04-16」即可查看线框图
   · 点击右上角「▶ Present」可进入可交互的 Prototype 模式
   ```

### 从 Figma 反向同步：`/ui-draft --from-figma [figma-url]`

从 Figma 设计稿反向提取交互定义，更新或创建 `workflows/[feature].yaml`：

1. 通过 Figma MCP 读取指定 Frame/Section 的结构
2. 识别：组件类型、层级、标签文字、交互连线
3. 转换为标准 YAML 格式
4. 提示确认后写入 `workflows/[feature].yaml`
5. 可直接运行 `/ui-draft [feature]` 重新生成 HTML 原型

**适用场景**：设计师在 Figma 里改了稿，需要把改动同步回交互定义，让 HTML 原型和知识库保持一致。

---

**属于**: HiveMind Skill v0.0.3  
**配对命令**: `/prd` — 开始产品讨论并生成交互定义
