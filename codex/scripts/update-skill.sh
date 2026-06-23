#!/usr/bin/env bash
set -euo pipefail

COLOR_RESET='\033[0m'
COLOR_GREEN='\033[0;32m'
COLOR_BLUE='\033[0;34m'
COLOR_YELLOW='\033[1;33m'
COLOR_RED='\033[0;31m'

STATE_DIR="${HIVE_MIND_STATE_DIR:-$HOME/.hive-mind}"
SOURCE_FILE="$STATE_DIR/codex-source-repo"
SKILL_REPO="${HIVE_MIND_SKILL_REPO:-}"
KNOWLEDGE_REPO="${HIVE_MIND_KNOWLEDGE_REPO:-$HOME/team-knowledge}"
KNOWLEDGE_REMOTE="${HIVE_MIND_KNOWLEDGE_REMOTE:-https://github.com/your-org/team-knowledge.git}"
REMOTE="${HIVE_MIND_SKILL_REMOTE:-}"
BRANCH="${HIVE_MIND_SKILL_BRANCH:-}"

if [ -z "$SKILL_REPO" ]; then
    if [ -f "$SOURCE_FILE" ]; then
        SKILL_REPO="$(cat "$SOURCE_FILE")"
    else
        SKILL_REPO="$HOME/HiveMind"
    fi
fi

echo -e "${COLOR_BLUE}HiveMind Codex Skill - Update Manager${COLOR_RESET}"
echo ""
echo "Skill source: $SKILL_REPO"
echo "Knowledge repo: $KNOWLEDGE_REPO"
echo ""

if [ ! -d "$SKILL_REPO" ]; then
    echo -e "${COLOR_RED}✗ Skill source repo not found${COLOR_RESET}"
    echo "  Expected: $SKILL_REPO"
    echo "  Clone it first, for example:"
    echo "  git clone https://github.com/eureka266/HiveMind.git ~/HiveMind"
    exit 1
fi

if [ ! -d "$SKILL_REPO/.git" ]; then
    echo -e "${COLOR_RED}✗ Skill source is not a git clone, cannot update safely${COLOR_RESET}"
    echo "  Path: $SKILL_REPO"
    echo "  Reinstall from a git clone to enable updates."
    exit 1
fi

cd "$SKILL_REPO"

if ! git diff --quiet || ! git diff --cached --quiet; then
    echo -e "${COLOR_RED}✗ Source repo has uncommitted changes; update stopped${COLOR_RESET}"
    echo "Commit, stash, or resolve these changes before updating:"
    git status --short
    exit 1
fi

CURRENT_HASH="$(git rev-parse HEAD)"
CURRENT_VERSION="$(cat VERSION 2>/dev/null || cat codex/VERSION 2>/dev/null || echo unknown)"
CURRENT_BRANCH="$(git branch --show-current)"

if [ -z "$REMOTE" ] || [ -z "$BRANCH" ]; then
    UPSTREAM="$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || true)"
    if [ -n "$UPSTREAM" ]; then
        REMOTE="${REMOTE:-${UPSTREAM%%/*}}"
        BRANCH="${BRANCH:-${UPSTREAM#*/}}"
    else
        REMOTE="${REMOTE:-origin}"
        BRANCH="${BRANCH:-${CURRENT_BRANCH:-main}}"
    fi
fi

echo "Current version: $CURRENT_VERSION"
echo "Current commit: ${CURRENT_HASH:0:12}"
echo "Update source: $REMOTE/$BRANCH"
echo ""

echo "Checking remote updates..."
git fetch "$REMOTE" "$BRANCH" --quiet
REMOTE_HASH="$(git rev-parse "$REMOTE/$BRANCH")"

if [ "$CURRENT_HASH" = "$REMOTE_HASH" ]; then
    echo -e "${COLOR_GREEN}✓ Skill source already up to date${COLOR_RESET}"
else
    echo -e "${COLOR_YELLOW}Updating skill source...${COLOR_RESET}"
    git pull --ff-only "$REMOTE" "$BRANCH" --quiet
fi

NEW_HASH="$(git rev-parse HEAD)"
NEW_VERSION="$(cat VERSION 2>/dev/null || cat codex/VERSION 2>/dev/null || echo unknown)"

echo ""
echo "Reinstalling Codex skill..."
bash "$SKILL_REPO/codex/install.sh"

echo ""
if [ ! -d "$KNOWLEDGE_REPO" ]; then
    echo -e "${COLOR_YELLOW}Knowledge repo not found; cloning...${COLOR_RESET}"
    git clone "$KNOWLEDGE_REMOTE" "$KNOWLEDGE_REPO" --quiet || {
        echo -e "${COLOR_YELLOW}⚠ Knowledge repo clone failed; skill update still completed${COLOR_RESET}"
        echo "  Remote: $KNOWLEDGE_REMOTE"
        exit 0
    }
elif [ -d "$KNOWLEDGE_REPO/.git" ]; then
    cd "$KNOWLEDGE_REPO"
    if ! git diff --quiet || ! git diff --cached --quiet; then
        echo -e "${COLOR_YELLOW}⚠ Knowledge repo has local changes; sync skipped${COLOR_RESET}"
        git status --short
    else
        echo "Syncing knowledge repo..."
        git pull --ff-only origin main --quiet || echo -e "${COLOR_YELLOW}⚠ Knowledge repo sync failed; local cache remains available${COLOR_RESET}"
    fi
else
    echo -e "${COLOR_YELLOW}⚠ Knowledge path exists but is not a git repo; sync skipped${COLOR_RESET}"
    echo "  Path: $KNOWLEDGE_REPO"
fi

echo ""
echo -e "${COLOR_GREEN}✅ HiveMind Codex skill update complete${COLOR_RESET}"
echo "  Commit: ${CURRENT_HASH:0:12} -> ${NEW_HASH:0:12}"
echo "  Version: $CURRENT_VERSION -> $NEW_VERSION"
echo ""
echo "Start a new Codex thread or restart Codex to reload updated skill instructions."
