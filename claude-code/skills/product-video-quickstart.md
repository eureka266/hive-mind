---
name: product-video-quickstart
description: Quick start guide for /video command — script-first workflow with confirmation gate. For content marketing teams to generate product demo videos in 10 minutes.
---

# `/video` 快速启动：脚本优先工作流

为内容营销团队设计的简明指南。脚本确认后才生成代码，确保方向正确。

## 工作流概览（4 步）

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃          请求脚本: /video 你的需求              ┃
┗━━━━━━━━━━━━━━━━━━━┬━━━━━━━━━━━━━━━━━━━━━━━━━━┛
                     ↓
┌───────────────────────────────────────────────┐
│     Phase 1: Claude 生成脚本（~5 min）        │
│     输出: 纯文本脚本 YAML                      │
│     Token: ~1300                              │
└───────────────────┬───────────────────────────┘
                    ↓
┌───────────────────────────────────────────────┐
│  🎬 你审视脚本，选择:                          │
│  ├─ ✅ 是的，继续                             │
│  ├─ 🔧 改这些：[修改要求]                     │
│  └─ 🔄 重新来：[新方向]                       │
└───────────────────┬───────────────────────────┘
                    ↓ (如需改脚本)
        ┌───────────────────────┐
        │  Phase 2: 修订脚本    │
        │  (~3 min)            │
        │  Token: ~600         │
        └───────────┬───────────┘
                    ↓
        ┌───────────────────────┐
        │  [再次确认脚本]       │
        │  → 继续到 Phase 3     │
        └───────────┬───────────┘
                    ↓
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃    Phase 3: Claude 生成代码（~2 min）        ┃
┃    输出: VideoScene.tsx                      ┃
┃    Token: ~2200                              ┃
┗━━━━━━━━━━━━━━━━━━━┬━━━━━━━━━━━━━━━━━━━━━━━┛
                     ↓
┌───────────────────────────────────────────────┐
│   本地渲染（~10 min）                         │
│   $ npm install remotion ffmpeg-static       │
│   $ npx remotion preview                     │
│   $ npx remotion render out.mp4              │
└───────────────────┬───────────────────────────┘
                    ↓
        ┏━━━━━━━━━━━━━━━━━━━━┓
        ┃  完成 ✅ out.mp4   ┃
        ┃  总耗时: 10-20 min ┃
        ┗━━━━━━━━━━━━━━━━━━━┛
```

---

## Step 1: 请求脚本（不生成代码）

```bash
/video 制作一个 dashboard 数据分析的 30 秒演示动图
```

Claude 会做什么：
✅ 读取知识库中的交互流程（workflows/）  
✅ 读取产品 PRD  
✅ **生成纯文本脚本**（不生成代码）  
✅ 提供确认提示  

你会看到这样的脚本：
```yaml
video_metadata:
  title: "Dashboard 数据分析演示"
  duration_seconds: 30
  fps: 30
  scene_count: 4

scenes:
  - id: 1
    name: "opening"
    duration_seconds: 3
    text: "Dashboard 数据分析"
    animation: "fade_in, scale"
    notes: "大标题，居中"
  
  - id: 2
    name: "demo"
    duration_seconds: 20
    text: "一键生成 50+ 维度分析"
    animation: "slide_left"
    action: "展示数据钻取"
  
  - id: 3
    name: "benefit"
    duration_seconds: 5
    text: "3 倍性能提升"
    animation: "highlight"
  
  - id: 4
    name: "closing"
    duration_seconds: 2
    text: "立即体验"
    animation: "fade_out"

design_notes: |
  整体色调：现代科技感
  场景 2 关键：展示流畅度
  考虑背景音乐
```

---

## Step 2: 确认脚本

Claude 会问：
```
🎬 脚本已生成。现在：
□ 是的，继续生成代码
□ 改这些：[你的修改要求]
□ 重新来：[新方向]
```

### 选项 A：同意（最快）
```
你: 是的，继续
Claude: [跳到 Step 3]
```

### 选项 B：微调脚本
```
你: 改这些：
   - 场景 2 改成 25 秒
   - 添加 "AI 推荐" 功能介绍
   - 调整最后的 CTA 文案

Claude: [重新生成改动的部分]
[再次确认]

你: 好了，继续
Claude: [跳到 Step 3]
```

### 选项 C：重新来
```
你: 重新来，这次强调数据安全性而不是性能

Claude: [重新生成整个脚本，不同的重点]
```

---

## Step 3: 获得代码（自动注入脚本）

一旦你确认脚本，Claude 自动生成：

✅ 完整的 `VideoScene.tsx`  
✅ 品牌色自动应用（从知识库）  
✅ Logo 路径自动注入  
✅ 资产清单  
✅ 启动说明  

你会得到一个完整的项目结构：
```
VideoScene.tsx       ← 完整的 Remotion 代码
├─ Import 语句
├─ BRAND 常量（自动填充）
├─ Scene1, Scene2, Scene3, Scene4 组件
├─ 主 Composition
└─ 导出

Asset Checklist:
□ logo.png (可选)
□ 产品截图 (可选)

启动指令:
npm init -y && npm install remotion
npx remotion preview src/VideoScene.tsx
npx remotion render src/VideoScene.tsx out.mp4
```

---

## Step 4: 本地渲染（10 分钟）

### 4.1 创建项目
```bash
mkdir my-video && cd my-video
npm init -y
npm install remotion ffmpeg-static
```

### 4.2 添加代码和资产
```bash
mkdir src assets

# 复制 Claude 生成的代码
# → src/VideoScene.tsx

# 放置 logo（可选）
cp ~/Downloads/logo.png assets/
```

### 4.3 本地预览
```bash
npx remotion preview src/VideoScene.tsx

# 浏览器自动打开 http://localhost:3000
# 可以播放、调整速度、看每帧
```

### 4.4 调整（可选）
在编辑器中打开 `src/VideoScene.tsx`：

**改文案**：
```typescript
<Text fontSize={48} fill={BRAND.colorPrimary}>
  你的新文案  // ← 改这里
</Text>
```
保存 → 预览自动刷新

**改时长**：
```typescript
durationInFrames={900}  // 30 秒 @ 30fps
// 改为 450 = 15 秒
// 改为 1800 = 60 秒
```

**改颜色**：
```typescript
const BRAND = {
  colorPrimary: '#你的颜色',  // ← 改这里
}
```

### 4.5 最终渲染
```bash
npx remotion render src/VideoScene.tsx out.mp4 \
  --codec h264 --crf 20 --fps 30

# 等待 1-3 分钟
# → out.mp4 生成完成！
```

---

## 快速参考：常见改动

| 需求 | 位置 | 怎么改 |
|------|------|------|
| 改文案 | `<Text>` 组件 | 直接改文字内容 |
| 改时长 | `durationInFrames` | 改成 `秒数 * 30` |
| 改颜色 | `BRAND` 对象 | 改 HEX 色值 |
| 换 logo | `logoPath` | 改文件路径 |
| 改动画速度 | `interpolate()` | 改参数范围 |

---

## 脚本修改示例

假设脚本出来后，你想改：

```
原脚本：
场景 1: "Dashboard 数据分析" (3s)
场景 2: "一键生成 50+ 维度" (20s)
场景 3: "3 倍性能提升" (5s)
场景 4: "立即体验" (2s)

改要求:
/video 改脚本：场景 2 改成 25 秒，加入 "支持 AI 推荐" 的演示

新脚本：
场景 1: "Dashboard 数据分析" (3s) [不变]
场景 2: "一键生成 50+ 维度，支持 AI 推荐" (25s) [改了]
场景 3: "3 倍性能提升" (5s) [不变]
场景 4: "立即体验" (2s) [不变]

[确认后直接生成代码，不会重复问]
```

---

## 平台适配（渲染不同尺寸）

生成代码后，在代码中改 Composition 的 width/height：

```typescript
<Composition
  width={1920}   // 改这两个
  height={1080}
  ...
/>
```

| 平台 | 尺寸 | 用途 |
|------|------|------|
| 官网 / LinkedIn | 1920×1080 | 标准 16:9 |
| Twitter / 正方形 | 1080×1080 | 社交媒体 |
| TikTok / 竖屏 | 1080×1920 | 竖屏短视频 |

然后重新渲染：
```bash
npx remotion render src/VideoScene.tsx out-1080-1080.mp4 \
  --width 1080 --height 1080
```

---

## 常见问题

**Q: 脚本不满意怎么办？**
A: 第 2 步告诉 Claude"改这些："，重新生成脚本。确认后再生代码。

**Q: 代码生成后想改脚本？**
A: 可以。脚本是锁定的（为了效率），但你可以直接编辑代码中的文案。

**Q: 如何多语言版本？**
A: 修改代码中的 `<Text>` 文案，改成英文后重新渲染一次。

**Q: 渲染太慢？**
A: 降低 FPS 到 24，或用 `--concurrency 1` 单线程渲染。

**Q: 可以在 CI/CD 中自动渲染吗？**
A: 可以。Remotion CLI 支持无头渲染，适合 GitHub Actions。

---

## 端到端示例（10 分钟）

### 分钟 0-1：请求脚本
```bash
/video dashboard 数据分析功能，30 秒演示，强调实时性
```

### 分钟 1-3：确认脚本
```
Claude: [脚本输出]

你: 是的，继续
```

### 分钟 3-4：获得代码和启动说明
```bash
mkdir demo && cd demo
npm init -y && npm install remotion ffmpeg-static
# 复制 VideoScene.tsx 到 src/
```

### 分钟 4-6：本地预览
```bash
npx remotion preview src/VideoScene.tsx
# 预览 + 微调（可选）
```

### 分钟 6-10：渲染输出
```bash
npx remotion render src/VideoScene.tsx out.mp4
# → out.mp4 完成
```

**总耗时**：约 10 分钟，其中 4 分钟是本地渲染。

---

## 与其他 HiveMind 指令的配合

### 搭配 `/gtm`：市场定位 → 脚本
```
/gtm dashboard 的核心竞争力
  ↓ [GTM 生成营销角度]

/video dashboard 演示，基于上面的卖点
  ↓ [脚本融合 GTM 的定位]
```

### 搭配 `/email`：视频 → 公告邮件
```
/video dashboard 新功能
  ↓ [生成 out.mp4]

/email 产品更新公告，配合这个视频
  ↓ [邮件 HTML 配上视频预览]
```

---

## 工作流优势总结

| 优势 | 原因 |
|------|------|
| **快速确认** | 脚本优先，不费力生成错误代码 |
| **节省 token** | 脚本轻量（文本），代码集中（一次生成） |
| **设计师友好** | 非技术人员可以理解脚本，提前反馈 |
| **易迭代** | 脚本改动快，代码改动也快 |
| **可复用** | 脚本保存到知识库，日后可快速重用 |

---

## 下一步

1. **第一个视频**：按上面步骤尝试一个简单的 30 秒演示
2. **保存脚本**：把生成的脚本保存到知识库 `features/[feature]/script.md`
3. **收集反馈**：问团队对脚本和视频的看法
4. **优化模板**：为你的产品建立一套脚本模板

---

祝你制作愉快！有问题查看完整指南：`product-video.md`

🎬 **一分钟快速开始**：
```
/video 你的需求
[确认脚本]
[本地 npm install + render]
[完成]
```
