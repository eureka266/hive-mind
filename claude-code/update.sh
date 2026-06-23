#!/bin/bash

# HiveMind Skill - 手动更新脚本

set -e

COLOR_RESET='\033[0m'
COLOR_GREEN='\033[0;32m'
COLOR_BLUE='\033[0;34m'
COLOR_YELLOW='\033[1;33m'
COLOR_RED='\033[0;31m'

SKILL_REPO="${HIVE_MIND_SKILL_REPO:-$HOME/HiveMind}"
KNOWLEDGE_REPO="${HIVE_MIND_KNOWLEDGE_REPO:-$HOME/team-knowledge}"

echo -e "${COLOR_BLUE}HiveMind Skill - Update Manager${COLOR_RESET}"
echo ""

if [ ! -d "$SKILL_REPO/.git" ]; then
    echo -e "${COLOR_RED}✗ Skill 仓库不是 git 安装，无法自动更新${COLOR_RESET}"
    echo "  当前路径: $SKILL_REPO"
    exit 1
fi

cd "$SKILL_REPO"

CURRENT_VERSION=$(cat claude-code/VERSION 2>/dev/null || echo "unknown")
CURRENT_HASH=$(git rev-parse HEAD)

echo "当前版本: $CURRENT_VERSION"
echo "当前提交: ${CURRENT_HASH:0:12}"
echo ""

if ! git diff --quiet || ! git diff --cached --quiet; then
    echo -e "${COLOR_RED}✗ 有未提交的本地修改，已停止更新${COLOR_RESET}"
    echo "请先提交、stash 或放弃本地修改后再更新。"
    git status --short
    exit 1
fi

echo "检查远端更新..."
git fetch origin main --quiet
REMOTE_HASH=$(git rev-parse origin/main)

# 远端比本地多出的提交数。0 表示本地已包含远端全部提交（相同或本地领先），
# 此时无需更新，只重新注册。仅用 HEAD != origin/main 判断会在本地领先时误报。
BEHIND_COUNT=$(git rev-list --count "$CURRENT_HASH..origin/main")

if [ "$BEHIND_COUNT" -eq 0 ]; then
    if [ "$CURRENT_HASH" != "$REMOTE_HASH" ]; then
        echo -e "${COLOR_YELLOW}ℹ 本地领先远端（有未推送的提交），已是最新或更新${COLOR_RESET}"
    else
        echo -e "${COLOR_GREEN}✓ 已是最新版本 (v$CURRENT_VERSION)${COLOR_RESET}"
    fi
    echo ""
    echo "重新注册 skills，确保命令完整..."
    bash "$SKILL_REPO/claude-code/scripts/register-skills.sh"
    exit 0
fi

echo -e "${COLOR_YELLOW}发现新版本可用${COLOR_RESET}"
echo ""
echo "即将更新的提交:"
git log --oneline "$CURRENT_HASH..origin/main" | head -8
echo ""

read -p "是否要更新? (y/n): " UPDATE_CONFIRM
if [ "$UPDATE_CONFIRM" != "y" ]; then
    echo "已取消"
    exit 0
fi

echo -e "${COLOR_YELLOW}更新中...${COLOR_RESET}"
git pull --ff-only origin main --quiet
git submodule update --quiet 2>/dev/null || true

NEW_VERSION=$(cat claude-code/VERSION 2>/dev/null || echo "unknown")

echo ""
echo "重新注册 skills..."
bash "$SKILL_REPO/claude-code/scripts/register-skills.sh"

echo ""
echo -e "${COLOR_BLUE}更新摘要:${COLOR_RESET}"
echo "  Skill: $CURRENT_VERSION → $NEW_VERSION"
echo "  时间: $(date)"

CHANGELOG="$SKILL_REPO/CHANGELOG.md"
if [ -f "$CHANGELOG" ]; then
    echo ""
    echo -e "${COLOR_BLUE}本次更新内容：${COLOR_RESET}"
    awk '/^## \[/{found++} found==1 && !/^## \[/{print} found==2{exit}' "$CHANGELOG" \
        | grep -E "^\*\*|^- " \
        | head -12 \
        | sed 's/^/  /'
fi

if [ -d "$KNOWLEDGE_REPO/.git" ]; then
    echo ""
    echo -e "${COLOR_YELLOW}同步知识库...${COLOR_RESET}"
    cd "$KNOWLEDGE_REPO"
    git pull --ff-only origin main --quiet 2>/dev/null || echo -e "${COLOR_YELLOW}⚠ 知识库同步失败，已跳过${COLOR_RESET}"
fi

echo ""
echo -e "${COLOR_GREEN}✅ 更新完成${COLOR_RESET}"
