#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
TARGET_DIR="$CODEX_HOME/skills/hive-mind"
STATE_DIR="${HIVE_MIND_STATE_DIR:-$HOME/.hive-mind}"

mkdir -p "$CODEX_HOME/skills"
rm -rf "$TARGET_DIR"
mkdir -p "$TARGET_DIR"

cp -R "$SOURCE_DIR"/. "$TARGET_DIR"/

mkdir -p "$STATE_DIR"
printf '%s\n' "$(cd "$SOURCE_DIR/.." && pwd)" > "$STATE_DIR/codex-source-repo"
printf '%s\n' "$TARGET_DIR" > "$STATE_DIR/codex-target-dir"

echo "HiveMind Codex skill installed to: $TARGET_DIR"
echo "Source repo recorded in: $STATE_DIR/codex-source-repo"
echo "Restart Codex or start a new thread, then mention HiveMind, /prd, /prd research, /prd review, /prd docs, /prd clean, /dev, /ui-draft, /gtm, /email, or /hive-mind-update."
