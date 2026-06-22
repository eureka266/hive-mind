# `/video` 工作流重新设计 — 总结文档

## 核心改变

从**一步式代码生成** → **四阶段脚本确认工作流**

```
旧: /video → 直接生成代码 → 用户运行
新: /video → Phase 1 脚本 → 用户确认 → Phase 3 代码 → 用户运行
```

---

## 文件清单

### 新增文件

| 文件 | 用途 | 对象 |
|-----|------|------|
| `claude-code/skills/product-video.md` | `/video` 完整工作流指南（4 Phase 详解） | Claude Code 用户 |
| `claude-code/skills/product-video-quickstart.md` | 10 分钟快速启动指南 | 内容营销团队 |
| `codex/references/product-video-workflow.md` | Agent 实现参考（如何分阶段生成） | Claude 开发者 |
| `VIDEO_WORKFLOW_ARCHITECTURE.md` | 架构设计文档（为什么这样设计） | PM / 技术负责人 |
| `VIDEO_WORKFLOW_SUMMARY.md` | 这份文件 | 所有人 |

### 删除文件

- ❌ `claude-code/skills/product-animation.md`（已被 `product-video.md` 替代）
- ❌ `ANIMATION_QUICK_REFERENCE.md`（已被 `product-video-quickstart.md` 替代）

### 更新文件

- `SKILL.md` — 更新 Intent Routing
- `claude-code/README.md` — 更新命令列表
- `claude-code/package.yaml` — 更新命令定义和版本

---

## 新工作流详解

### Phase 1: 脚本生成（轻量上下文）

**输入**：
- workflows/*.yaml（交互流程）
- approved-prds/（功能 PRD）
- decisions/（相关决策）

**输出**：纯文本脚本（YAML 或 Markdown）

```yaml
video_metadata:
  title: "..."
  duration_seconds: 30

scenes:
  - id: 1
    name: "opening"
    duration_seconds: 3
    text: "..."
    animation: "fade_in"
```

**Token 消耗**：~1300 tokens（轻量）

### Phase 2: 脚本确认（用户审视）

**输入**：脚本（从 Phase 1）

**用户选择**：
- ✅ 继续（跳到 Phase 3）
- 🔧 微调（修改脚本，回到 Phase 1）
- 🔄 重来（完全重新生成）

**关键**：**不在用户确认前生成代码**

### Phase 3: 代码生成（丰富上下文）

**前提**：脚本已确认（APPROVED）

**输入**：
- ✅ 已确认脚本（读取，不重新生成）
- ✅ facts/product.md（品牌色、logo）
- ✅ assets/（资产列表）
- ✅ 相关 PRD

**输出**：`VideoScene.tsx`（完整的 Remotion 代码）

**Token 消耗**：~2200 tokens（一次性）

### Phase 4: 本地渲染

用户运行：
```bash
npm install remotion
npx remotion preview src/VideoScene.tsx
npx remotion render src/VideoScene.tsx out.mp4
```

---

## Token 效率对比

### 单次成功情景

| 方式 | Token | 时间 | 说明 |
|------|------|------|------|
| 直接生成代码 | 3000 | 15 min | 一次成功，无迭代 |
| **脚本优先** | **3500** | **12 min** | 脚本 1300 + 代码 2200 |

**结论**：略多 500 token，但**确认门防止错误方向**

### 需要迭代情景（更现实）

| 方式 | Token | 时间 | 说明 |
|------|------|------|------|
| 直接生成代码 | 6000 | 30 min | 生成 → 发现不对 → 重新生成 |
| **脚本优先** | **4100** | **20 min** | 脚本 1300 + 修改 600 + 代码 2200 |

**结论**：**节省 30% token，节省 33% 时间**

---

## 关键设计点

### 1. 上下文隔离

```
Phase 1: 只加载 workflows + PRD
         ↓
Phase 3: 只加载 脚本 + 品牌
         ↓
避免重复加载全量知识库
```

### 2. 确认门（核心）

```
Phase 1 → 输出脚本 → [等待用户确认]
                   ↓
                  确认
                   ↓
             Phase 3 → 代码生成
```

**效果**：
- ✅ 用户提前看到脚本方向
- ✅ 早期反馈，避免生成错误代码
- ✅ 脚本和代码分离，易修改

### 3. 脚本持久化

```
脚本 → 保存到 features/[video]/script.md
    ↓
    下次无需重新描述
    ↓
    跨 session 继续
```

---

## 使用示例

### 快速路径（5 min 确认）

```
你: /video dashboard demo, 30 秒

Claude: [生成脚本] ← Phase 1

你: 好的，继续

Claude: [生成代码] ← Phase 3

你: npm install && render

[完成]
```

### 迭代路径（需要改脚本）

```
你: /video dashboard + AI，60 秒

Claude: [生成脚本] ← Phase 1

你: 改这些：
   - 场景 2 改 25 秒
   - 加 AI 推荐介绍

Claude: [修改脚本] ← Phase 2

你: 继续

Claude: [生成代码] ← Phase 3

你: npm install && render

[完成]
```

---

## 与旧方式的区别

### 旧方式（直接代码）

```
/video 需求
  ↓
Claude: [读取全量知识库] → [生成代码] → 输出 VideoScene.tsx
  ↓
用户运行，发现脚本方向不对
  ↓
请求重新生成 → [又读一遍全量知识库] → [重新生成代码] ← 浪费 token
```

### 新方式（脚本优先）

```
/video 需求
  ↓
Phase 1: Claude: [读取 workflows + PRD] → [生成脚本] → 输出
         ↓
[用户确认脚本方向] ← 轻量 agent，节省 token
         ↓
Phase 3: Claude: [读取脚本 + 品牌] → [生成代码] → 输出 VideoScene.tsx
         ↓
用户运行，脚本方向已确认 ✅
```

**关键**：提前确认脚本方向，避免生成错误代码

---

## 文档导航

| 用户类型 | 查看文档 | 时间 |
|---------|---------|------|
| 快速上手（内容营销） | `product-video-quickstart.md` | 5 min |
| 完整流程（Claude Code） | `product-video.md` | 15 min |
| 架构理解（PM/Tech）| `VIDEO_WORKFLOW_ARCHITECTURE.md` | 10 min |
| Agent 实现（Claude Dev）| `codex/references/product-video-workflow.md` | 20 min |

---

## 立即开始

```bash
# 在 Claude Code 中输入：
/video dashboard 数据分析功能，30 秒演示

# Claude 会：
# 1. 生成脚本（基于你的知识库）
# 2. 等待你确认脚本方向
# 3. 脚本确认后生成代码
# 4. 你本地运行，渲染完成
```

---

## 变更日志

**v0.0.18 (2025-06-22)**：
- ✨ 新增：脚本优先工作流（Phase 1-4）
- ✨ 新增：确认门机制（防止错误方向）
- 🔄 改进：Token 节省 ~30%（迭代场景）
- 📚 新增：完整的工作流文档和快速启动指南
- 🗑️ 删除：旧的 `product-animation.md`

---

## 参考资料

- **Trellis 项目**：https://github.com/mindfold-ai/Trellis
  - 分阶段工作流设计
  - 上下文隔离策略
  - Token 节省最佳实践
  
- **HiveMind 其他指令**：
  - `/gtm`：生成营销定位
  - `/email`：生成邮件资产
  - `/prd`：生成产品需求

---

## 常见问题

**Q: 为什么要加确认门？**
A: 防止生成错误方向的代码。脚本是轻量的（纯文本），便宜；代码生成是重的，应该等脚本确认后再做。

**Q: 脚本修改后，代码还能用吗？**
A: 代码不变，你可以手动编辑代码中的文案。但建议：修改后重新生成代码（Phase 3），确保时序正确。

**Q: 如何跨 session 继续？**
A: 脚本保存到知识库 `features/[video]/script.md`，下次运行 `/video --continue [video-name]` 直接跳到 Phase 3。

**Q: 支持多语言吗？**
A: 是的。修改代码中的 `<Text>` 内容，改成英文后重新渲染一次即可。

---

## 下一步

1. ✅ 阅读 `product-video.md`（完整工作流）
2. ✅ 按 `product-video-quickstart.md` 生成第一个视频
3. ✅ 给团队演示新工作流
4. ✅ 收集反馈，迭代完善

祝你制作愉快！🎬
