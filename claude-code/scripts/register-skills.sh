#!/bin/bash

# Register HiveMind skills into Claude Code.
# Safe to run repeatedly after install or update.

set -e

COLOR_RESET='\033[0m'
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[1;33m'
COLOR_RED='\033[0;31m'

# 默认从脚本自身位置推导源目录（scripts/ 的上级即 claude-code/），
# 这样无论仓库克隆在何处都能正确注册，不再依赖固定的 ~/.hive-mind/skill 路径。
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_SRC="${HIVE_MIND_SKILL_SRC:-$(dirname "$SCRIPT_DIR")}"
SKILL_DST="${HIVE_MIND_SKILL_DST:-$HOME/.claude/skills}"

mkdir -p "$SKILL_DST"

register_skill() {
    local name="$1"
    local src="$2"

    if [ ! -f "$src" ]; then
        echo -e "${COLOR_RED}✗ /$name 源文件不存在: $src${COLOR_RESET}"
        return 1
    fi

    mkdir -p "$SKILL_DST/$name"
    ln -sf "$src" "$SKILL_DST/$name/SKILL.md"
    echo -e "${COLOR_GREEN}✓ /$name 已注册${COLOR_RESET}"
}

register_skill prd "$SKILL_SRC/skills/prd.md"
register_skill prd-review "$SKILL_SRC/skills/prd-review.md"
register_skill research "$SKILL_SRC/skills/research.md"
register_skill dev "$SKILL_SRC/skills/dev.md"
register_skill ui-draft "$SKILL_SRC/skills/ui-draft.md"
register_skill gtm "$SKILL_SRC/skills/gtm.md"
register_skill email "$SKILL_SRC/skills/email.md"
register_skill hive-mind-update "$SKILL_SRC/skills/hive-mind-update.md"
register_skill hive-mind "$SKILL_SRC/PACKAGE.md"

echo -e "${COLOR_GREEN}✓ HiveMind skills 注册完成${COLOR_RESET}"
