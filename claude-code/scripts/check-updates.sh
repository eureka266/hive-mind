#!/bin/bash

# HiveMind Skill - 自动检查更新脚本
# 通过 Claude Code PreToolUse hook 在 skill 命令前自动执行。
# 默认静默、节流检查；发现更新后自动 pull 并重新注册 skills。

COLOR_RESET='\033[0m'
COLOR_GREEN='\033[0;32m'
COLOR_BLUE='\033[0;34m'
COLOR_YELLOW='\033[1;33m'

SKILL_REPO="${SKILL_REPO:-$HOME/.hive-mind/skill}"
STATE_DIR="${STATE_DIR:-$HOME/.hive-mind/state}"
CACHE_FILE="$STATE_DIR/last-update-check"
MARKER_FILE="$STATE_DIR/just-updated-from"
CHECK_TTL_MINUTES="${HIVE_MIND_UPDATE_TTL_MINUTES:-60}"
FORCE=false

if [ "${1:-}" = "--force" ]; then
    FORCE=true
    rm -f "$CACHE_FILE"
fi

# 跳过条件
[ "$SKIP_AUTO_UPDATE" = "true" ] && exit 0
[ ! -d "$SKILL_REPO/.git" ] && exit 0

cd "$SKILL_REPO" || exit 0

# 有本地未提交修改时跳过，保护用户工作
git diff --quiet 2>/dev/null || exit 0
git diff --cached --quiet 2>/dev/null || exit 0

mkdir -p "$STATE_DIR"

# 刚更新过的下一次运行，提示一次版本变化
if [ -f "$MARKER_FILE" ]; then
    OLD_VERSION=$(cat "$MARKER_FILE" 2>/dev/null || true)
    rm -f "$MARKER_FILE"
    NEW_VERSION=$(cat claude-code/VERSION 2>/dev/null || echo "unknown")
    if [ -n "$OLD_VERSION" ]; then
        echo ""
        echo -e "${COLOR_GREEN}HiveMind Skill 当前版本: $NEW_VERSION（刚从 $OLD_VERSION 更新）${COLOR_RESET}"
        echo ""
    fi
fi

# 节流：默认 60 分钟内不重复访问远端
if [ "$FORCE" != "true" ] && [ -f "$CACHE_FILE" ]; then
    STALE=$(find "$CACHE_FILE" -mmin +"$CHECK_TTL_MINUTES" 2>/dev/null || true)
    if [ -z "$STALE" ]; then
        exit 0
    fi
fi

# 获取本地版本
LOCAL_HASH=$(git rev-parse HEAD 2>/dev/null) || exit 0
LOCAL_VERSION=$(cat claude-code/VERSION 2>/dev/null || echo "unknown")

# 拉取远端信息（静默，失败就跳过）
git fetch origin main --quiet 2>/dev/null || {
    echo "FETCH_FAILED $(date +%s)" > "$CACHE_FILE"
    exit 0
}

REMOTE_HASH=$(git rev-parse origin/main 2>/dev/null) || exit 0

# 已是最新，不打印任何内容
if [ "$LOCAL_HASH" = "$REMOTE_HASH" ]; then
    echo "UP_TO_DATE $LOCAL_VERSION $(date +%s)" > "$CACHE_FILE"
    exit 0
fi

# 有更新——先拉取
git pull origin main --quiet 2>/dev/null || exit 0

REMOTE_VERSION=$(cat claude-code/VERSION 2>/dev/null || echo "unknown")

# 更新后重新注册 skills，确保新增命令立即生效
HIVE_MIND_SKILL_SRC="$SKILL_REPO/claude-code" bash "$SKILL_REPO/claude-code/scripts/register-skills.sh" >/dev/null 2>&1 || true
echo "UPDATED $LOCAL_VERSION $REMOTE_VERSION $(date +%s)" > "$CACHE_FILE"

# 展示更新通知（这段输出会出现在 Claude Code 对话里）
echo ""
echo -e "${COLOR_YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${COLOR_RESET}"
echo -e "${COLOR_YELLOW}  📦 HiveMind Skill 已自动更新${COLOR_RESET}"
echo -e "${COLOR_YELLOW}  $LOCAL_VERSION  →  $REMOTE_VERSION${COLOR_RESET}"
echo -e "${COLOR_YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${COLOR_RESET}"

# 从 CHANGELOG.md 提取最新版本的更新内容
CHANGELOG="$SKILL_REPO/CHANGELOG.md"
if [ -f "$CHANGELOG" ]; then
    echo ""
    echo -e "${COLOR_BLUE}本次更新内容：${COLOR_RESET}"
    # 提取第一个 ## [...] 到第二个 ## [...] 之间的内容（最新版本块）
    awk '/^## \[/{found++} found==1 && !/^## \[/{print} found==2{exit}' "$CHANGELOG" \
        | grep -E "^\*\*|^- " \
        | head -8 \
        | sed 's/^/  /'
fi

echo ""
echo -e "${COLOR_GREEN}  ✅ 继续执行命令...${COLOR_RESET}"
echo -e "${COLOR_YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${COLOR_RESET}"
echo ""
