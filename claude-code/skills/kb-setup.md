---
name: kb-setup
description: HiveMind 知识库连接向导。在任何 HiveMind 命令运行前自动检查知识库是否存在并连接正确。如果本地没有知识库，引导用户连接已有 GitHub 仓库或创建新的知识库。
---

# kb-setup

HiveMind 知识库健康检查与初始化向导。

**通常不需要直接调用此 skill。** 它由 `/prd`、`/dev`、`/ui-draft`、`/gtm`、`/email` 在 Phase 0 自动触发。

也可以直接调用修复知识库连接：
```
/kb-setup
```

---

## 核心检查逻辑（Phase 0 — 所有 HiveMind 命令运行前）

每次运行任何 HiveMind 命令时，先执行此检查。**检查通过后才继续原始命令。**

### 步骤 1：检测知识库

```bash
KB_DIR="${KNOWLEDGE_DIR:-$HOME/team-knowledge}"
echo "KB_DIR: $KB_DIR"

if [ -d "$KB_DIR/.git" ]; then
  echo "KB_STATUS: exists"
  cd "$KB_DIR"
  REMOTE=$(git remote get-url origin 2>/dev/null || echo "")
  echo "KB_REMOTE: ${REMOTE:-none}"
  echo "KB_BRANCH: $(git branch --show-current 2>/dev/null || echo unknown)"
else
  echo "KB_STATUS: missing"
fi
```

根据输出走对应分支：

- `KB_STATUS: exists` → 跳到[步骤 2：结构验证](#步骤-2结构验证)
- `KB_STATUS: missing` → 进入[知识库初始化向导](#知识库初始化向导)

---

### 步骤 2：结构验证

知识库存在后，验证必要目录是否完整：

```bash
KB_DIR="${KNOWLEDGE_DIR:-$HOME/team-knowledge}"
REQUIRED_DIRS="facts decisions features memory/rules memory/research"
MISSING=""

for dir in $REQUIRED_DIRS; do
  if [ ! -d "$KB_DIR/$dir" ]; then
    MISSING="$MISSING $dir"
  fi
done

if [ -n "$MISSING" ]; then
  echo "KB_STRUCTURE: incomplete — missing:$MISSING"
else
  echo "KB_STRUCTURE: ok"
fi
```

- `KB_STRUCTURE: ok` → 检查通过，继续原始命令
- `KB_STRUCTURE: incomplete` → 自动补全缺失目录，不打断用户：

  ```bash
  KB_DIR="${KNOWLEDGE_DIR:-$HOME/team-knowledge}"
  mkdir -p "$KB_DIR/facts" "$KB_DIR/decisions" "$KB_DIR/features" \
           "$KB_DIR/memory/rules" "$KB_DIR/memory/research" \
           "$KB_DIR/approved-prds" "$KB_DIR/drafts" "$KB_DIR/pending" \
           "$KB_DIR/archive" "$KB_DIR/assets/emails"
  echo "✅ 已自动补全缺失目录结构"
  ```

  静默完成后继续原始命令。

---

## 知识库初始化向导

**触发条件：** `KB_STATUS: missing`（目录不存在或不是 git repo）

先说明情况，然后问：

```
未找到 HiveMind 知识库（~/team-knowledge）。

知识库是 HiveMind 沉淀产品事实、决策和 PRD 的地方——
所有 /prd、/dev、/ui-draft、/gtm、/email 命令都写入这里。

我来帮你设置。
```

### 问题 1：已有团队仓库吗？

> **你的团队是否已有一个 HiveMind 知识库仓库（GitHub 或其他 Git 服务）？**
>
> A) 有 — 我来连接已有仓库（推荐，加入现有团队知识库）
> B) 没有 — 帮我新建一个
> C) 本地使用，不需要 GitHub（个人 / 离线模式）

---

#### 分支 A：连接已有仓库

1. 询问仓库地址：

   ```
   请提供仓库地址（例如：your-org/team-knowledge 或完整 URL）：
   ```

2. 执行 clone：

   ```bash
   KB_DIR="${KNOWLEDGE_DIR:-$HOME/team-knowledge}"
   git clone "https://github.com/$REPO_INPUT.git" "$KB_DIR" --depth 1
   ```

   - 成功 → 展示已有内容摘要，继续步骤 2 结构验证
   - 失败（权限/网络）→ 提示：
     ```
     ✗ 克隆失败。可能原因：
       - 仓库地址有误（当前: your-org/team-knowledge）
       - 没有访问权限（私有仓库需要有读取权限）
       - 网络问题

     请确认地址后重试，或选择其他方式（B/C）。
     ```
     返回问题 1。

---

#### 分支 B：新建知识库

1. 询问仓库名和可见性：

   ```
   仓库名（例如：team-knowledge）：
   ```

   > **可见性？**
   >
   > A) 私有（推荐 — 产品信息不公开）
   > B) 公开

2. 检查 `gh` CLI 是否可用：

   ```bash
   command -v gh >/dev/null 2>&1 && echo "GH_AVAILABLE" || echo "GH_NOT_AVAILABLE"
   ```

   **GH_AVAILABLE：**

   ```bash
   VISIBILITY_FLAG="--private"   # 或 --public
   gh repo create "$REPO_NAME" $VISIBILITY_FLAG --description "HiveMind team knowledge base"
   KB_DIR="${KNOWLEDGE_DIR:-$HOME/team-knowledge}"
   git clone "https://github.com/$(gh api user --jq .login 2>/dev/null)/$REPO_NAME.git" "$KB_DIR"
   ```

   **GH_NOT_AVAILABLE（`gh` 未安装）：**

   ```
   未检测到 GitHub CLI（gh）。有两个选项：

   A) 先安装 gh，再继续：
      brew install gh && gh auth login
      装好后重新运行 /kb-setup

   B) 手动创建仓库后告诉我地址，我来 clone
      → 打开 https://github.com/new 新建仓库
      → 创建完成后回来输入地址

   C) 先用本地模式，以后再连 GitHub
   ```

3. 初始化目录结构并推送：

   ```bash
   KB_DIR="${KNOWLEDGE_DIR:-$HOME/team-knowledge}"
   cd "$KB_DIR"

   # 创建目录结构
   mkdir -p facts decisions features memory/rules memory/research \
            approved-prds drafts pending archive assets/emails

   # 创建 README
   cat > README.md << 'EOF'
   # Team Knowledge Base

   This repository is managed by [HiveMind](https://github.com/eureka266/HiveMind).

   Every product discussion, PRD, and decision made with HiveMind is stored here.
   Team members clone this repo to share one brain.
   EOF

   # 创建 .gitignore
   cat > .gitignore << 'EOF'
   local/
   .DS_Store
   *.swp
   EOF

   git add -A
   git commit -m "init: initialize HiveMind team knowledge base"
   git push origin main
   ```

   完成后展示：

   ```
   ✅ 知识库已创建并推送

     本地路径: ~/team-knowledge
     远端仓库: https://github.com/your-org/team-knowledge
     目录结构: facts/ decisions/ features/ memory/ approved-prds/ 已创建

   团队成员加入方式：
     git clone https://github.com/your-org/team-knowledge.git ~/team-knowledge

   → 继续执行原始命令
   ```

---

#### 分支 C：本地模式

```bash
KB_DIR="${KNOWLEDGE_DIR:-$HOME/team-knowledge}"
mkdir -p "$KB_DIR"
cd "$KB_DIR"
git init --quiet

mkdir -p facts decisions features memory/rules memory/research \
         approved-prds drafts pending archive assets/emails

echo "# Team Knowledge Base" > README.md
git add -A
git commit -m "init: initialize local HiveMind knowledge base" --quiet
```

完成后展示：

```
✅ 本地知识库已初始化

  路径: ~/team-knowledge
  模式: 仅本地（无 GitHub 远端）

  之后想连接 GitHub？运行 /kb-setup 选择「连接远端」。

→ 继续执行原始命令
```

---

## 远端连接检查（可选提示）

知识库已存在但没有远端时（`KB_REMOTE: none`），在 Phase 1 结束时**非阻塞地**提示一次（每个知识库只提示一次，之后静默）：

```
💡 你的知识库目前是本地模式（无 GitHub 远端）。
   连接 GitHub 可以让团队共享同一套产品决策和规则。
   运行 /kb-setup 来连接。（输入任意内容跳过此提示）
```

标记文件路径：`$KB_DIR/.hive-mind-remote-prompted`

---

## 错误恢复

| 情况 | 处理方式 |
|------|----------|
| 目录存在但不是 git repo | 询问：初始化为 git repo，还是换个路径 |
| clone 成功但结构不完整 | 静默补全缺失目录 |
| push 失败（权限） | 提示检查 GitHub token / SSH key |
| `gh auth` 未登录 | 提示 `gh auth login` 后重试 |
| 网络不通 | 降级到本地模式，提示稍后连接 |

---

## 给其他 skill 引用的接入点

所有 HiveMind skill 在其 Phase 1 / 阶段 1 的最开始加入以下调用：

```
### Phase 0: 知识库健康检查（自动）

在执行本命令前，先确认知识库就绪：

1. 检测 `${KNOWLEDGE_DIR:-$HOME/team-knowledge}` 是否存在且是有效 git repo
2. 若不存在 → 暂停当前命令，进入 kb-setup 向导
3. 向导完成后 → 自动继续本命令（用户无需重新输入）
4. 若存在 → 验证目录结构，静默补全缺失目录 → 继续
```
