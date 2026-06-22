---
name: product-video
description: HiveMind 产品视频工作流指令。分阶段生成视频脚本（让视频设计师确认）→ 脚本确认后自动生成 Remotion 代码 → 本地渲染/沉淀资产。基于交互流程知识库生成完整的视频脚本和动画代码。输入 /video [主题] 使用。
---

# product-video

HiveMind 的产品视频工作流指令。采用**脚本先行确认模式**：视频设计师确认脚本后再生成代码，确保方向正确，避免重复生成。

---

## 🎬 工作流架构图

### 完整 4 阶段流程

```
┌─────────────────────────────────────────────────────────────────┐
│                      用户请求：/video [主题]                      │
└──────────────────────────┬──────────────────────────────────────┘
                           │
        ╔══════════════════▼════════════════════╗
        ║      Phase 1: 脚本生成（轻量）       ║
        ║  ─────────────────────────────────  ║
        ║  输入: workflows/*.yaml              ║
        ║       approved-prds/[feature]        ║
        ║       decisions/                     ║
        ║                                      ║
        ║  流程:                               ║
        ║  • 提取交互流程                      ║
        ║  • 生成场景时序                      ║
        ║  • 自动文案提议                      ║
        ║                                      ║
        ║  输出: script.yaml/md               ║
        ║  Token: ~1300                       ║
        ║  时间: ~5 min                       ║
        ╚════════════════┬═════════════════════╝
                         │
        ╔════════════════▼═════════════════════╗
        ║      [确认门] 用户审视脚本           ║
        ║  ─────────────────────────────────  ║
        ║  用户选择:                           ║
        ║  ├─ ✅ 同意 → 继续 Phase 3          ║
        ║  ├─ 🔧 微调 → 回到 Phase 1         ║
        ║  └─ 🔄 重来 → 新方向重新 Phase 1   ║
        ║                                      ║
        ║  关键: 不在确认前生成代码           ║
        ║       防止浪费 token                ║
        ╚════════════════╤═════════════════════╝
                         │
        ╔════════════════▼═════════════════════╗
        ║      Phase 2: 脚本修订（可选）     ║
        ║  ─────────────────────────────────  ║
        ║  仅在用户要求修改时执行             ║
        ║                                      ║
        ║  输入: 用户的修改要求               ║
        ║  输出: 修改后的脚本                 ║
        ║  Token: ~600（仅改动部分）         ║
        ║  时间: ~3 min                       ║
        ║                                      ║
        ║  返回确认门，再次审视               ║
        ╚════════════════╤═════════════════════╝
                         │
        ╔════════════════▼═════════════════════╗
        ║      Phase 3: 代码生成（丰富）     ║
        ║  ─────────────────────────────────  ║
        ║  前提: 脚本已确认 ✓                ║
        ║                                      ║
        ║  输入: • 已确认脚本                  ║
        ║       • facts/product.md（品牌）   ║
        ║       • assets/（资产库）           ║
        ║       • 相关 PRD                    ║
        ║                                      ║
        ║  流程:                               ║
        ║  • 提取脚本时序（不重新生成）       ║
        ║  • 注入品牌色、logo                ║
        ║  • 构建 React 场景组件              ║
        ║  • 组装 Remotion Composition       ║
        ║                                      ║
        ║  输出: VideoScene.tsx               ║
        ║  Token: ~2200（一次性）            ║
        ║  时间: ~2 min                       ║
        ╚════════════════╤═════════════════════╝
                         │
        ╔════════════════▼═════════════════════╗
        ║     Phase 4: 本地运行 & 沉淀        ║
        ║  ─────────────────────────────────  ║
        ║  用户本地操作:                       ║
        ║  $ npm init -y                      ║
        ║  $ npm install remotion ffmpeg     ║
        ║  $ npx remotion preview             ║
        ║  $ npx remotion render out.mp4      ║
        ║                                      ║
        ║  然后保存到知识库:                   ║
        ║  ~/team-knowledge/assets/videos/   ║
        ║                                      ║
        ║  时间: ~10 min（含渲染）           ║
        ╚════════════════╤═════════════════════╝
                         │
        ╔════════════════▼═════════════════════╗
        ║         完成 ✅ out.mp4              ║
        ║                                      ║
        ║  总耗时: ~10-20 min                 ║
        ║  总 Token: 3500-4100                ║
        ║  品牌精度: ✅ 完全定制              ║
        ║  可迭代性: ✅ 高                    ║
        ╚═══════════════════════════════════════╝
```

### Token 消耗流程

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Phase 1: 脚本生成
  加载: workflows/ + PRD (小)
  输出: 纯文本脚本
  耗时: ~1300 tokens
  
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[用户确认] ← 无 token 消耗的关键点
  
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Phase 2: 脚本修订（如需要）
  加载: 仅修改部分
  输出: 新脚本
  耗时: ~600 tokens（仅改动的）
  
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[脚本确认后锁定] ← 防止重新生成脚本
  
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Phase 3: 代码生成
  加载: 脚本(已有) + 品牌 + 资产 (中)
  输出: Remotion TypeScript 代码
  耗时: ~2200 tokens
  
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
总计: 3500-4100 tokens（取决于是否修订脚本）

vs 直接生成代码: 
  成功: 3000 tokens（省 500，但无确认）
  失败: 6000 tokens（多 2000+，因为需要重新生成）
  
脚本优先优势: 防止失败，迭代时高效 ✅
```

### 对比：旧方案 vs 新方案

```
❌ 直接生成代码
   /video 需求
   ↓
   Claude: [一步生成 Remotion 代码]
   ↓
   用户发现方向不对
   ↓
   重新调用 → 又读一遍全量知识库 → 重新生成代码 ← Token 浪费！


✅ 脚本优先（新方案）
   /video 需求
   ↓
   Phase 1: [轻量脚本生成]
   ↓
   [用户提前确认方向] ← 便宜且快速的反馈
   ↓
   Phase 3: [脚本锁定 → 代码一次生成] ← 无浪费
   ↓
   Token 消耗 < 直接方案（在迭代时）
```

---

## 架构特点

**三阶段工作流 + 中间态持久化**
- ✅ **Phase 1: 脚本生成与确认**（轻量 agent，仅读交互流程）
- ✅ **Phase 2: 脚本确认**（人工审视，快速迭代）
- ✅ **Phase 3: 代码生成**（注入已确认脚本，自动填充品牌/资产）
- ✅ **Phase 4: 渲染与沉淀**（输出视频 + 更新知识库）

**Token 节省设计**
- 脚本与代码分离，避免重复上下文加载
- 脚本确认后才生成代码，不走错方向
- 中间状态保存到 `features/[video-name]/script.md`，支持断点续做
- 轻量 agent 负责脚本，专业 agent 负责代码

## 语言规则

- 对话和工作过程默认中文；脚本内容和代码注释按用户指定语言输出
- 用户自己的产品名、功能名、API 名和领域术语保留英文原样
- 脚本中的文案、标题、旁白按用户指定语言，未指定时默认中文

## 使用方式

```text
/video [主题描述]
/video 制作一个 dashboard 数据分析功能的 30 秒演示动图
/video --tutorial 为"导入数据"功能制作教程视频
/video --comparison 演示你的产品 vs 竞品 A 的对比动图
/video --workflow 制作"生成报告"流程讲解动画
```

## Phase 0: 知识库健康检查（自动）

```bash
KB_DIR="${KNOWLEDGE_DIR:-$HOME/team-knowledge}"
if [ -d "$KB_DIR/.git" ]; then
  echo "KB_STATUS: exists"
else
  echo "KB_STATUS: missing"
fi
```

- `KB_STATUS: exists` → 继续阶段 1
- `KB_STATUS: missing` → 暂停，进入 `/kb-setup` 向导；完成后自动继续

---

## Phase 1: 脚本生成与确认（轻量上下文）

**目标**：基于交互流程生成纯文本脚本，**不生成代码**，不加载品牌/资产信息。

**上下文隔离**（只加载这些）：
- `workflows/*.yaml` — 交互流程定义
- `approved-prds/[feature].md` — 功能 PRD
- `decisions/` — 相关决策
- 用户指定的功能名和场景

**输出**：纯文本脚本（YAML 或 Markdown）

### 脚本格式示例

```yaml
video_metadata:
  title: "Dashboard 数据分析演示"
  duration_seconds: 30
  fps: 30
  scene_count: 4

scenes:
  - id: 1
    name: "opening"
    duration: 3
    text: "Dashboard 数据分析"
    animation: "fade_in, scale_up"
    notes: "产品名称大标题，居中"
    
  - id: 2
    name: "demo_main"
    duration: 20
    text: "一键生成 50+ 维度数据分析报告"
    animation: "slide_left, grow"
    action: "演示数据钻取"
    notes: "展示主要功能，3 个关键操作步骤"
    
  - id: 3
    name: "benefit"
    duration: 5
    text: "3 倍性能提升，实时数据更新"
    animation: "pulse, highlight"
    notes: "核心卖点，统计数据强调"
    
  - id: 4
    name: "closing"
    duration: 2
    text: "立即体验"
    animation: "fade_out"
    notes: "品牌 logo + CTA 按钮"

notes_for_designer: |
  - 整体色调：现代科技感
  - 场景 2 关键：需要展示数据钻取的流畅度
  - 考虑添加背景音乐和过渡音效
```

### 脚本确认流程

Claude 在 Phase 1 输出脚本后，**停止并等待用户反馈**：

```
生成的脚本：
[完整的脚本内容]

请确认脚本方向：
□ 完全同意，继续 Phase 3 生成代码
□ 微调脚本（告诉我改哪些）
□ 重新生成（告诉我改变方向）
```

**不要**在用户确认前开始 Phase 3。

---

## Phase 2: 脚本修订（可选，轻量）

如果用户说"微调脚本"，重新运行 Phase 1 的脚本生成，但：
- 只重新生成修改的场景
- 保留已确认的部分
- 再次输出新脚本供确认

**Token 节省**：不加载品牌/资产，避免重复。

---

## Phase 3: 代码生成（需脚本已确认）

**前提**：用户已确认脚本，标记为 APPROVED。

**目标**：基于确认的脚本生成完整的 Remotion TypeScript 代码。

**上下文注入**（在脚本基础上）：
- ✅ 已确认的脚本内容
- ✅ `facts/product.md` — 品牌色、logo、产品信息
- ✅ `assets/` — 可用图片、logo 路径
- ✅ 相关 PRD 和 workflows

**输出**：`VideoScene.tsx` 完整的生产级代码

### 代码生成步骤

1. **提取脚本信息**（不重复生成）
   ```
   从脚本读取：
   - 每个场景的时长、文案、动画
   - 整体时序和节奏
   - 设计师备注
   ```

2. **注入品牌常量**
   ```typescript
   // 自动从 facts/product.md 提取
   const BRAND = {
     colorPrimary: '#8DC8E8',
     colorAccent: '#FF7F32',
     background: '#F8F6F3',
     logoPath: './assets/logo.png',
   };
   ```

3. **构建场景组件**
   ```typescript
   // 每个脚本场景 → 一个 React 组件
   const SceneOpening = () => { /* 场景 1 */ }
   const SceneDemo = () => { /* 场景 2 */ }
   // ...
   ```

4. **组装时序**
   ```typescript
   export const ProductVideo: React.FC = () => (
     <Composition
       component={MainVideo}
       durationInFrames={900}  // 30s @ 30fps
       fps={30}
       width={1920}
       height={1080}
     />
   );
   ```

5. **提供资产清单**
   ```
   需要的文件：
   - logo.png (1920x1080, 可选)
   - 背景图或截图 (可选)
   ```

---

## Phase 4: 本地运行与渲染

用户获得代码后：

```bash
# 1. 项目初始化（首次）
npm init -y && npm install remotion ffmpeg-static

# 2. 添加资产
cp 你的logo.png ./assets/

# 3. 预览
npx remotion preview src/VideoScene.tsx
# 浏览器打开，视频可实时预览

# 4. 调整（可选）
# 修改 src/VideoScene.tsx 中的参数
# - 改文案：直接改 <Text> 内容
# - 改时序：改 durationInFrames
# - 改颜色：改 BRAND 常量

# 5. 渲染输出
npx remotion render src/VideoScene.tsx out.mp4 --codec h264 --crf 20
# 生成 out.mp4
```

---

## Phase 5: 沉淀与索引（可选）

生成视频后，保存到知识库资产库：

```bash
# 保存视频
mkdir -p ~/team-knowledge/assets/videos/$(date +%Y-%m-%d)-dashboard-demo
cp out.mp4 ~/team-knowledge/assets/videos/$(date +%Y-%m-%d)-dashboard-demo/
cp src/VideoScene.tsx ~/team-knowledge/assets/videos/$(date +%Y-%m-%d)-dashboard-demo/

# 保存脚本（作为文档）
cp script.md ~/team-knowledge/assets/videos/$(date +%Y-%m-%d)-dashboard-demo/

# 更新索引
echo "- Dashboard Demo (30s, 2025-06-22): [video](assets/videos/2025-06-22-dashboard-demo/out.mp4)" \
  >> ~/team-knowledge/assets-index.md
```

---

## 完整工作流图

```
用户: /video 制作 dashboard 演示
  ↓
Phase 1: 脚本生成（轻量 agent，读 workflows + PRD）
  ├─ 基于交互流程提取关键场景
  ├─ 自动生成场景时序和文案
  └─ 输出脚本 YAML/Markdown
  
  ↓ [停止] 等待用户确认
  
用户: ✅ 确认脚本 / 或微调要求
  ↓
Phase 2: 脚本修订（可选）
  ├─ 只改动指定部分
  └─ 再次输出脚本确认
  
用户: ✅ 脚本已确认
  ↓
Phase 3: 代码生成（专业 agent，读脚本 + 品牌 + 资产）
  ├─ 直接从脚本提取时序（不重复）
  ├─ 注入品牌色和 logo
  ├─ 生成 TypeScript 代码
  └─ 提供启动说明和资产清单
  
用户: 本地运行 / 调整 / 渲染
  ↓
Phase 4-5: 输出视频 + 沉淀资产库
  └─ 更新 assets-index.md
```

---

## Token 节省的关键设计

| 设计点 | 节省机制 |
|--------|---------|
| **分离脚本和代码** | 脚本生成不加载品牌/资产，只读 workflows；代码生成时直接注入脚本，避免重复上下文 |
| **确认点设置** | Phase 1 后停止，让用户确认方向，避免生成错误代码 |
| **中间态持久化** | 脚本保存到知识库 `features/[video]/script.md`，支持跨 session 继续（无需重新描述） |
| **上下文隔离** | 脚本用轻量 agent（少量上下文），代码用专业 agent（丰富上下文但只运行一次） |
| **避免重复生成** | 脚本确认后就不再改，代码直接读脚本，不问同样问题两次 |

---

## 常见场景

### 场景 1: 快速演示视频（15s）
```
/video 快速演示 notification 功能，15 秒
→ Phase 1 生成脚本
→ 用户确认（或直接说继续）
→ Phase 3 生成代码
→ 本地渲染
→ 完成
```
**总耗时**：5-10 分钟（包括本地运行）

### 场景 2: 复杂教程视频（60s）
```
/video --tutorial 为 CSV 导入制作详细教程，60 秒，包含 5 个步骤
→ Phase 1 生成脚本（5 个场景）
→ 用户微调：改场景 3 的时长和文案
→ Phase 2 修订脚本
→ Phase 3 生成代码
→ 本地预览，微调动画（可选）
→ 渲染输出
```
**总耗时**：15-20 分钟

### 场景 3: 竞品对比动画（30s）
```
/video --comparison 演示你的产品 vs Competitor A
→ Phase 1 读 competitors/ + 自己的 PRD，生成对比脚本
→ 用户确认对比维度和措辞
→ Phase 3 生成代码（并排布局）
→ 渲染
```
**总耗时**：10-15 分钟

---

## 与其他工作流的协作

```
情景 1: 想要先有营销文案框架
┌─ /gtm [主题] → 生成卖点框架
└─ /video --script-from-gtm → 基于 GTM 框架生成脚本

情景 2: 视频已生成，要发邮件
┌─ /video [主题] → 生成视频
└─ /email 产品更新邮件，配合 [video.mp4] → 生成邮件 HTML

情景 3: 需要多语言版本
┌─ /video [主题] → 生成脚本 + 代码（中文）
└─ 修改代码中的文案 → 再渲染一遍英文版本
```

---

## 故障排除

### 脚本生成卡住？
- 检查 workflows/ 是否有相关交互流程
- 检查 PRD 是否明确功能描述
- 试试提供更具体的场景描述：`/video 为 dashboard 数据钻取交互制作脚本`

### 脚本确认后想改代码？
- 可以，生成的 `VideoScene.tsx` 是源文件，直接编辑
- 改文案：找到 `<Text>` 元素改内容
- 改时序：改 `durationInFrames` 或 `Sequence` 的 `from` 属性
- 改动画：修改 `interpolate()` 函数

### 渲染很慢？
- 降低 FPS：改为 24 或 20
- 简化动画：减少 `interpolate()` 复杂度
- 压缩输入图片（< 2MB 最佳）

---

## 快速参考

```bash
# 完整流程
/video 你的需求
  ↓ 确认脚本
  ↓ 获得代码
  ↓
mkdir video-project && cd video-project
npm init -y && npm install remotion ffmpeg-static
# 复制 VideoScene.tsx 到 src/
npx remotion preview src/VideoScene.tsx
  ↓ 可选：调整代码
  ↓
npx remotion render src/VideoScene.tsx out.mp4
  ↓
完成！
```
