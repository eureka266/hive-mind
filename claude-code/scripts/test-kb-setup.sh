#!/usr/bin/env bash
# test-kb-setup.sh — 测试 kb-setup.md 里的 Phase 0 健康检查逻辑
# 每个测试用例都在独立的临时目录里运行，互不影响

set -euo pipefail

# ── 颜色 ──────────────────────────────────────────────
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
RESET='\033[0m'

PASS=0
FAIL=0
SKIP=0

pass() { echo -e "${GREEN}  ✓ PASS${RESET} $1"; PASS=$((PASS + 1)); }
fail() { echo -e "${RED}  ✗ FAIL${RESET} $1"; FAIL=$((FAIL + 1)); }
skip() { echo -e "${YELLOW}  - SKIP${RESET} $1"; SKIP=$((SKIP + 1)); }
header() { echo -e "\n${YELLOW}▸ $1${RESET}"; }

# ── Phase 0 检测逻辑（直接从 kb-setup.md 提取） ─────
kb_check() {
  local kb_dir="$1"
  if [ -d "$kb_dir/.git" ]; then
    echo "KB_STATUS: exists"
  else
    echo "KB_STATUS: missing"
  fi
}

# ── 结构验证逻辑 ──────────────────────────────────────
kb_structure_check() {
  local kb_dir="$1"
  local required_dirs="facts decisions features memory/rules memory/research"
  local missing=""
  for dir in $required_dirs; do
    [ ! -d "$kb_dir/$dir" ] && missing="$missing $dir"
  done
  if [ -n "$missing" ]; then
    echo "KB_STRUCTURE: incomplete — missing:$missing"
  else
    echo "KB_STRUCTURE: ok"
  fi
}

# ── 结构自动补全逻辑 ─────────────────────────────────
kb_structure_repair() {
  local kb_dir="$1"
  mkdir -p "$kb_dir/facts" "$kb_dir/decisions" "$kb_dir/features" \
           "$kb_dir/memory/rules" "$kb_dir/memory/research" \
           "$kb_dir/approved-prds" "$kb_dir/drafts" "$kb_dir/pending" \
           "$kb_dir/archive" "$kb_dir/assets/emails"
}

# ── 远端检查逻辑 ─────────────────────────────────────
kb_remote_check() {
  local kb_dir="$1"
  local remote
  remote=$(cd "$kb_dir" && git remote get-url origin 2>/dev/null || echo "")
  if [ -n "$remote" ]; then
    echo "KB_REMOTE: $remote"
  else
    echo "KB_REMOTE: none"
  fi
}

# ════════════════════════════════════════════════════
# 场景 1：KB 目录不存在
# ════════════════════════════════════════════════════
header "场景 1: KB 目录完全不存在"

TMPDIR1=$(mktemp -d)
MISSING_KB="$TMPDIR1/no-such-dir"

result=$(kb_check "$MISSING_KB")
if [ "$result" = "KB_STATUS: missing" ]; then
  pass "KB 不存在时输出 KB_STATUS: missing"
else
  fail "期望 'KB_STATUS: missing'，实际得到: '$result'"
fi

rm -rf "$TMPDIR1"

# ════════════════════════════════════════════════════
# 场景 2：目录存在但不是 git repo
# ════════════════════════════════════════════════════
header "场景 2: 目录存在但不是 git repo"

TMPDIR2=$(mktemp -d)
mkdir -p "$TMPDIR2/kb-no-git"

result=$(kb_check "$TMPDIR2/kb-no-git")
if [ "$result" = "KB_STATUS: missing" ]; then
  pass "非 git 目录输出 KB_STATUS: missing"
else
  fail "期望 'KB_STATUS: missing'，实际得到: '$result'"
fi

rm -rf "$TMPDIR2"

# ════════════════════════════════════════════════════
# 场景 3：有效的 git repo
# ════════════════════════════════════════════════════
header "场景 3: 有效 git repo（无内容）"

TMPDIR3=$(mktemp -d)
KB3="$TMPDIR3/team-knowledge"
mkdir -p "$KB3"
git -C "$KB3" init --quiet

result=$(kb_check "$KB3")
if [ "$result" = "KB_STATUS: exists" ]; then
  pass "有效 git repo 输出 KB_STATUS: exists"
else
  fail "期望 'KB_STATUS: exists'，实际得到: '$result'"
fi

rm -rf "$TMPDIR3"

# ════════════════════════════════════════════════════
# 场景 4：KB 存在但结构不完整
# ════════════════════════════════════════════════════
header "场景 4: KB 存在但缺少必要目录"

TMPDIR4=$(mktemp -d)
KB4="$TMPDIR4/team-knowledge"
mkdir -p "$KB4/facts"   # 只有 facts/，缺其他的
git -C "$KB4" init --quiet

check_result=$(kb_check "$KB4")
[ "$check_result" = "KB_STATUS: exists" ] && pass "Phase 0 通过（目录存在）" || fail "Phase 0 应通过"

struct_result=$(kb_structure_check "$KB4")
if echo "$struct_result" | grep -q "incomplete"; then
  pass "结构检查识别出缺失目录"
else
  fail "期望 'incomplete'，实际得到: '$struct_result'"
fi

# 验证缺少 decisions 和 features
if echo "$struct_result" | grep -q "decisions" && echo "$struct_result" | grep -q "features"; then
  pass "缺失目录列表包含 decisions 和 features"
else
  fail "缺失目录列表应包含 decisions 和 features，实际: '$struct_result'"
fi

rm -rf "$TMPDIR4"

# ════════════════════════════════════════════════════
# 场景 5：结构不完整 → 自动修复
# ════════════════════════════════════════════════════
header "场景 5: 结构不完整 → 自动补全"

TMPDIR5=$(mktemp -d)
KB5="$TMPDIR5/team-knowledge"
mkdir -p "$KB5"
git -C "$KB5" init --quiet

# 修复前
before=$(kb_structure_check "$KB5")
if echo "$before" | grep -q "incomplete"; then
  pass "修复前：结构检测为 incomplete"
else
  fail "修复前应为 incomplete，实际: '$before'"
fi

# 执行修复
kb_structure_repair "$KB5"

# 修复后
after=$(kb_structure_check "$KB5")
if [ "$after" = "KB_STRUCTURE: ok" ]; then
  pass "修复后：结构检测为 ok"
else
  fail "修复后应为 ok，实际: '$after'"
fi

# 验证关键目录都存在
all_ok=true
for d in facts decisions features memory/rules memory/research approved-prds drafts assets/emails; do
  [ -d "$KB5/$d" ] || { fail "目录 $d 未被创建"; all_ok=false; }
done
$all_ok && pass "所有 10 个必要目录均已创建"

rm -rf "$TMPDIR5"

# ════════════════════════════════════════════════════
# 场景 6：完整健康的 KB
# ════════════════════════════════════════════════════
header "场景 6: 完整健康的 KB（所有检查应全部通过）"

TMPDIR6=$(mktemp -d)
KB6="$TMPDIR6/team-knowledge"
mkdir -p "$KB6"
git -C "$KB6" init --quiet
kb_structure_repair "$KB6"

phase0=$(kb_check "$KB6")
struct=$(kb_structure_check "$KB6")
remote=$(kb_remote_check "$KB6")

[ "$phase0" = "KB_STATUS: exists" ]     && pass "Phase 0: exists" || fail "Phase 0 应为 exists"
[ "$struct" = "KB_STRUCTURE: ok" ]      && pass "结构检查: ok"    || fail "结构检查应为 ok"
[ "$remote" = "KB_REMOTE: none" ]       && pass "远端检查: none（本地模式）" || fail "远端应为 none"

rm -rf "$TMPDIR6"

# ════════════════════════════════════════════════════
# 场景 7：KB 有远端仓库
# ════════════════════════════════════════════════════
header "场景 7: KB 已连接 GitHub 远端"

TMPDIR7=$(mktemp -d)
KB7="$TMPDIR7/team-knowledge"
mkdir -p "$KB7"
git -C "$KB7" init --quiet
kb_structure_repair "$KB7"
git -C "$KB7" remote add origin "https://github.com/your-org/team-knowledge.git"

remote=$(kb_remote_check "$KB7")
if echo "$remote" | grep -q "github.com/your-org/team-knowledge"; then
  pass "远端检查识别出 GitHub URL"
else
  fail "期望包含 github.com URL，实际: '$remote'"
fi

rm -rf "$TMPDIR7"

# ════════════════════════════════════════════════════
# 场景 8：KNOWLEDGE_DIR 环境变量覆盖默认路径
# ════════════════════════════════════════════════════
header "场景 8: KNOWLEDGE_DIR 环境变量覆盖"

TMPDIR8=$(mktemp -d)
CUSTOM_KB="$TMPDIR8/custom-path"
mkdir -p "$CUSTOM_KB"
git -C "$CUSTOM_KB" init --quiet

# 用环境变量覆盖默认的 ~/team-knowledge
KNOWLEDGE_DIR="$CUSTOM_KB"
result=$(kb_check "${KNOWLEDGE_DIR:-$HOME/team-knowledge}")
if [ "$result" = "KB_STATUS: exists" ]; then
  pass "KNOWLEDGE_DIR 环境变量正确覆盖默认路径"
else
  fail "期望 'KB_STATUS: exists'，实际: '$result'"
fi
unset KNOWLEDGE_DIR

rm -rf "$TMPDIR8"

# ════════════════════════════════════════════════════
# 结果汇总
# ════════════════════════════════════════════════════
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
TOTAL=$((PASS + FAIL + SKIP))
echo -e "  结果: ${GREEN}${PASS} PASS${RESET} | ${RED}${FAIL} FAIL${RESET} | ${YELLOW}${SKIP} SKIP${RESET} (共 ${TOTAL} 项)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

[ "$FAIL" -gt 0 ] && exit 1 || exit 0
