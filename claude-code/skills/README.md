# Claude Code Skills 目录

HiveMind 的所有 skill 命令定义都在这个目录下。

## 快速导航

### 产品知识库与 PRD
- **[prd.md](./prd.md)** — `/prd` 命令定义
  - 讨论和提取 PRD、事实、交互定义、决策
  - 子用法：research、review、docs、prompt、competitor、assets、clean

- **[prd-review.md](./prd-review.md)** — `/prd review` 或 `/prd-review`
  - 从产品负责人视角审查 PRD

### 用户研究
- **[research.md](./research.md)** — `/prd research` 或 `/research`
  - 整理用户访谈、客户反馈、需求信号

### 工程
- **[dev.md](./dev.md)** — `/dev` 命令定义
  - 生成研发准备资产（实现方案、API 契约、测试规格、dev checklist）
  - 工程挑战模式：沉淀技术风险和决策

### 设计与原型
- **[ui-draft.md](./ui-draft.md)** — `/ui-draft` 命令定义
  - 从交互定义生成可点击的 HTML 原型
  - 可选 Figma 同步

### 商业化与营销
- **[gtm.md](./gtm.md)** — `/gtm` 命令定义
  - 生成 GTM 文章、卖点框架、销售表达

### 通信资产
- **[email.md](./email.md)** — `/email` 命令定义
  - 生成产品通知邮件、邮件营销、销售邮件
  - 生成固定模板 HTML，沉淀到 `assets/emails/`

### 视频与动画
- **[product-video.md](./product-video.md)** — `/video` 命令定义（完整版）
  - 脚本优先工作流（4 阶段 + 确认门）
  - 完整的 Phase 1-4 详解、脚本格式、API 契约
  - 面向 Claude Code 用户、设计师、开发者
  - **文件大小**：~19 KB

- **[product-video-quickstart.md](./product-video-quickstart.md)** — `/video` 快速启动指南
  - 10 分钟快速上手
  - 面向内容营销团队、非技术用户
  - Step-by-step 示例、常见改动参考
  - **文件大小**：~11 KB

### 维护与更新
- **[hive-mind-update.md](./hive-mind-update.md)** — `/hive-mind-update` 命令定义
  - 手动检查和更新 HiveMind Skill

---

## `/video` 文档体系

### 用户角色与推荐阅读

| 角色 | 首先读 | 然后读 | 参考 |
|------|--------|--------|------|
| **内容营销团队** (非技术) | [product-video-quickstart.md](./product-video-quickstart.md) (10 min) | [product-video.md](./product-video.md) 中"常见场景" 部分 | — |
| **视频设计师** (需要控制) | [product-video-quickstart.md](./product-video-quickstart.md) (10 min) | [product-video.md](./product-video.md) (15 min) | [VIDEO_WORKFLOW_ARCHITECTURE.md](../VIDEO_WORKFLOW_ARCHITECTURE.md) 了解为什么是脚本优先 |
| **Claude Code 用户** (开发者) | [product-video.md](./product-video.md) (15-20 min) | [../../codex/references/product-video-workflow.md](../../codex/references/product-video-workflow.md) (技术实现) | [VIDEO_WORKFLOW_MCP_ANALYSIS.md](../VIDEO_WORKFLOW_MCP_ANALYSIS.md) 了解 MCP 可行性 |
| **架构设计师** | [VIDEO_WORKFLOW_ARCHITECTURE.md](../VIDEO_WORKFLOW_ARCHITECTURE.md) | [VIDEO_WORKFLOW_MCP_ANALYSIS.md](../VIDEO_WORKFLOW_MCP_ANALYSIS.md) | [../../codex/references/product-video-workflow.md](../../codex/references/product-video-workflow.md) |

### 文档大纲

```
产品视频工作流 (/video)
│
├─ product-video-quickstart.md (11 KB, 5-10 min)
│  ├─ 工作流概览：4 步简化版
│  ├─ Step 1-4：完整端到端示例
│  ├─ 快速参考表：改文案/时长/颜色
│  ├─ 平台适配：16:9, 1:1, 9:16
│  └─ 常见问题 FAQ
│
├─ product-video.md (19 KB, 15-20 min)
│  ├─ 工作流架构图（4 Phase + Token 消耗）
│  ├─ Phase 0-5 详解
│  │  ├─ Phase 0: 知识库健康检查
│  │  ├─ Phase 1: 脚本生成（轻量）
│  │  ├─ Phase 2: 脚本修订（可选）
│  │  ├─ Phase 3: 代码生成（丰富）
│  │  ├─ Phase 4: 本地运行与渲染
│  │  └─ Phase 5: 沉淀与索引（可选）
│  ├─ Token 效率对比（脚本优先 vs 直接代码）
│  ├─ 完整工作流图
│  ├─ 常见场景（快速演示、复杂教程、竞品对比）
│  ├─ 与其他工作流的协作（/gtm → /video → /email）
│  ├─ 故障排除
│  └─ 快速参考
│
├─ codex/references/product-video-workflow.md (16 KB, 20-30 min)
│  ├─ 完整工作流架构（用于 Agent）
│  ├─ Visual Flow Diagram（带 Token 指标）
│  ├─ Phase 1-4 详细实现指南
│  ├─ 脚本格式（YAML 例子）
│  ├─ Token 效率机制表
│  ├─ 与其他 HiveMind 工作流的集成
│  ├─ Interaction Model（Happy Path / Revision Path）
│  ├─ Error Handling
│  └─ Key Principles（脚本优先的 5 个原则）
│
├─ VIDEO_WORKFLOW_ARCHITECTURE.md (8.5 KB, 10-15 min)
│  ├─ 概述：脚本优先确认工作流
│  ├─ 架构对比：传统方式 vs 新方式
│  ├─ 核心设计原则
│  │  ├─ 分离关注 (Separation of Concerns)
│  │  ├─ 上下文隔离 (Context Injection Timing)
│  │  ├─ 确认门 (Approval Gate)
│  │  └─ 脚本持久化 (Script Persistence)
│  ├─ Token 效率分析（详细数字）
│  ├─ 设计灵感：Trellis 项目
│  ├─ 实际工作流示例（2 个场景对比）
│  ├─ 组件架构
│  ├─ 知识库集成
│  ├─ 使用体验（面向设计师、营销团队）
│  ├─ 未来扩展（短期、中期、长期）
│  └─ 总结表格
│
├─ VIDEO_WORKFLOW_MCP_ANALYSIS.md (7.3 KB, 10-15 min)
│  ├─ 现状：已发现的 Remotion MCP
│  ├─ 三种方案深度对比
│  │  ├─ 方案 A：MCP 直接调用
│  │  ├─ 方案 B：脚本优先（当前）
│  │  └─ 方案 C：混合方案
│  ├─ 深度对比表（10+ 维度）
│  ├─ Token 消耗对比（场景分析）
│  ├─ 建议（短期、中期、长期）
│  ├─ 关键结论
│  └─ 参考资源
│
└─ VIDEO_WORKFLOW_SUMMARY.md (7.1 KB, 5-10 min)
   ├─ 改造过程总结
   ├─ 关键决策记录
   ├─ 文件导航指南
   └─ 快速检查清单
```

---

## 典型用法流程

### 场景 1：内容营销团队制作产品演示（15 min）

```bash
# 1. 读快速启动指南
# → product-video-quickstart.md

# 2. 请求脚本
/video dashboard 数据分析，30 秒演示

# 3. 确认脚本
# [用户审视脚本，说"是的，继续"]

# 4. 获得代码
# [Claude 生成 VideoScene.tsx + 启动说明]

# 5. 本地运行
mkdir my-video && cd my-video
npm init -y && npm install remotion ffmpeg-static
# 复制 VideoScene.tsx 到 src/
npx remotion preview src/VideoScene.tsx
npx remotion render src/VideoScene.tsx out.mp4

# 完成！
```

### 场景 2：设计师制作复杂教程视频（25 min）

```bash
# 1. 读完整指南
# → product-video.md

# 2. 请求脚本
/video --tutorial 为 CSV 导入制作 60 秒教程

# 3. 审视 + 微调脚本
# [用户说"改场景 2 的时长"]
# [Claude 重新生成改动部分]

# 4. 最终确认脚本

# 5. 获得代码 + 本地调整 + 渲染

# 完成！
```

### 场景 3：架构师评估设计方案（30 min）

```bash
# 1. 读架构文档
# → VIDEO_WORKFLOW_ARCHITECTURE.md
# → VIDEO_WORKFLOW_MCP_ANALYSIS.md

# 2. 理解：为什么脚本优先 > 直接代码生成
# - 防止"错误方向代码"的浪费
# - Token 效率：迭代时节省 30%
# - 设计师提前确认

# 3. 理解：MCP 为什么不是主方案
# - MCP 限制：8 秒 + 品牌难定制
# - 脚本优先：灵活 + 品质 + 高效

# 完成！
```

---

## 版本历史

- **v0.0.18** (2026-06-22) — `/video` 指令正式发布，脚本优先工作流完整实现
- **v0.0.17** (2026-06-22) — 架构设计文档和 MCP 分析完成
- **v0.0.16** — 初期框架

---

## 反馈与改进

如有建议或发现问题，请提交 Issue：https://github.com/eureka266/HiveMind/issues
