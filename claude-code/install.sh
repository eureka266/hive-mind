#!/bin/bash

# HiveMind Skill - 企业级安装脚本
# Enterprise Installation Script
#
# 用法:
#   bash install.sh                                                           # 默认安装到 ~/.hive-mind/
#   SKILL_DIR=~/Work/Project/hive-mind bash install.sh                 # 自定义 Skill 目录
#   KNOWLEDGE_DIR=~/Work/Project/team-knowledge bash install.sh   # 自定义知识库目录
#   SKILL_DIR=~/a KNOWLEDGE_DIR=~/b bash install.sh                           # 都自定义

set -e  # 任何错误都停止执行

# macOS 兼容的 timeout 替代（macOS 没有 coreutils timeout）
run_with_timeout() {
    local secs="$1"; shift
    "$@" &
    local pid=$!
    ( sleep "$secs" && kill "$pid" 2>/dev/null ) &
    local watchdog=$!
    wait "$pid" 2>/dev/null
    local ret=$?
    kill "$watchdog" 2>/dev/null
    wait "$watchdog" 2>/dev/null
    return $ret
}

COLOR_RESET='\033[0m'
COLOR_GREEN='\033[0;32m'
COLOR_BLUE='\033[0;34m'
COLOR_YELLOW='\033[1;33m'
COLOR_RED='\033[0;31m'

# ============ 可配置变量 ============
INSTALL_DIR="${INSTALL_DIR:-$HOME/.hive-mind}"
SKILL_DIR="${SKILL_DIR:-$INSTALL_DIR/skill}"
KNOWLEDGE_DIR="${KNOWLEDGE_DIR:-$INSTALL_DIR/knowledge}"
SKILL_REPO="eureka266/HiveMind"
# 知识库仓库默认为空：未显式提供 KNOWLEDGE_REPO 时，本地新建一个空知识库
KNOWLEDGE_REPO="${KNOWLEDGE_REPO:-}"

echo -e "${COLOR_BLUE}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "   HiveMind Skill - Enterprise Package v2.0"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${COLOR_RESET}"
echo -e "  Skill 目录: ${COLOR_BLUE}$SKILL_DIR${COLOR_RESET}"
echo -e "  知识库目录: ${COLOR_BLUE}$KNOWLEDGE_DIR${COLOR_RESET}"
echo ""

# ============ 步骤 1: 系统检查 ============
echo -e "${COLOR_YELLOW}[1/7] 系统要求检查...${COLOR_RESET}"

if ! command -v git &> /dev/null; then
    echo -e "${COLOR_RED}✗ Git 未安装${COLOR_RESET}"
    echo "  请先安装 Git: https://git-scm.com/download"
    exit 1
fi
GIT_VERSION=$(git --version | awk '{print $3}')
echo -e "${COLOR_GREEN}✓ Git 已安装 (v$GIT_VERSION)${COLOR_RESET}"

if [ -z "$BASH_VERSION" ]; then
    echo -e "${COLOR_RED}✗ 需要 Bash 4.0+${COLOR_RESET}"
    exit 1
fi
echo -e "${COLOR_GREEN}✓ Bash 已就绪${COLOR_RESET}"

if ! command -v curl &> /dev/null; then
    echo -e "${COLOR_YELLOW}⚠ curl 未安装，某些功能可能受限${COLOR_RESET}"
fi

echo ""

# ============ 步骤 2: Git 凭证与协议检测 ============
echo -e "${COLOR_YELLOW}[2/7] Git 凭证配置...${COLOR_RESET}"

if [ -z "$(git config --global user.name)" ]; then
    echo -e "${COLOR_YELLOW}  未检测到 Git 用户名，请输入:${COLOR_RESET}"
    read -p "  Git 用户名: " GIT_NAME
    git config --global user.name "$GIT_NAME"
fi

if [ -z "$(git config --global user.email)" ]; then
    echo -e "${COLOR_YELLOW}  未检测到 Git 邮箱，请输入:${COLOR_RESET}"
    read -p "  Git 邮箱: " GIT_EMAIL
    git config --global user.email "$GIT_EMAIL"
fi

echo -e "${COLOR_GREEN}✓ Git 用户配置完成${COLOR_RESET}"

# 自动检测 Git 协议: SSH 可用则用 SSH，否则 fallback 到 HTTPS
echo -n "  检查 GitHub SSH 访问... "
if ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=accept-new -T git@github.com 2>&1 | grep -qi "successfully authenticated"; then
    echo -e "${COLOR_GREEN}✓ SSH 可用，使用 SSH 协议${COLOR_RESET}"
    REPO_PREFIX="git@github.com:"
    REPO_SUFFIX=".git"
else
    echo -e "${COLOR_YELLOW}✗ SSH 不可用，使用 HTTPS 协议${COLOR_RESET}"
    REPO_PREFIX="https://github.com/"
    REPO_SUFFIX=".git"
fi

echo ""

# ============ 步骤 3: 创建目录 ============
echo -e "${COLOR_YELLOW}[3/7] 准备安装目录...${COLOR_RESET}"

mkdir -p "$INSTALL_DIR"
mkdir -p "$(dirname "$KNOWLEDGE_DIR")"

echo -e "${COLOR_GREEN}✓ 目录已就绪${COLOR_RESET}"
echo ""

# ============ 步骤 4: 仓库克隆 ============
echo -e "${COLOR_YELLOW}[4/7] 克隆仓库...${COLOR_RESET}"

# 克隆/更新 Skill 仓库
if [ -d "$SKILL_DIR/.git" ]; then
    echo -e "${COLOR_GREEN}✓ Skill 已存在，更新中...${COLOR_RESET}"
    cd "$SKILL_DIR"
    run_with_timeout 15 git pull origin main --quiet 2>/dev/null || echo -e "${COLOR_YELLOW}  ⚠ 更新失败或超时，继续${COLOR_RESET}"
else
    echo "  克隆 Skill..."
    if ! run_with_timeout 120 git clone "${REPO_PREFIX}${SKILL_REPO}${REPO_SUFFIX}" "$SKILL_DIR" --progress 2>&1; then
        echo -e "${COLOR_RED}✗ Skill 仓库克隆失败${COLOR_RESET}"
        echo -e "${COLOR_RED}  仓库: ${REPO_PREFIX}${SKILL_REPO}${REPO_SUFFIX}${COLOR_RESET}"
        echo ""
        echo "  可能原因:"
        echo "    - 没有仓库访问权限"
        echo "    - 网络无法连接 GitHub"
        echo "    - 仓库地址不正确"
        echo "    - 克隆超时（120秒）"
        exit 1
    fi
    echo -e "${COLOR_GREEN}✓ Skill 已克隆${COLOR_RESET}"
fi

# 克隆/更新/初始化知识库
if [ -d "$KNOWLEDGE_DIR/.git" ]; then
    echo -e "${COLOR_GREEN}✓ 知识库已存在，更新中...${COLOR_RESET}"
    cd "$KNOWLEDGE_DIR"
    run_with_timeout 15 git pull origin main --quiet 2>/dev/null || echo -e "${COLOR_YELLOW}  ⚠ 更新失败或超时，继续${COLOR_RESET}"
elif [ -n "$KNOWLEDGE_REPO" ]; then
    echo "  克隆知识库..."
    if ! run_with_timeout 120 git clone "${REPO_PREFIX}${KNOWLEDGE_REPO}${REPO_SUFFIX}" "$KNOWLEDGE_DIR" --progress 2>&1; then
        echo -e "${COLOR_RED}✗ 知识库克隆失败${COLOR_RESET}"
        echo -e "${COLOR_RED}  仓库: ${REPO_PREFIX}${KNOWLEDGE_REPO}${REPO_SUFFIX}${COLOR_RESET}"
        echo ""
        echo "  可能原因:"
        echo "    - 没有仓库访问权限"
        echo "    - 网络无法连接 GitHub"
        echo "    - 仓库地址不正确"
        echo "    - 克隆超时（120秒）"
        exit 1
    fi
    echo -e "${COLOR_GREEN}✓ 知识库已克隆${COLOR_RESET}"
else
    echo "  未提供 KNOWLEDGE_REPO，初始化本地空知识库..."
    mkdir -p "$KNOWLEDGE_DIR"
    cd "$KNOWLEDGE_DIR"
    if [ ! -d "$KNOWLEDGE_DIR/.git" ]; then
        git init --quiet
    fi
    mkdir -p facts workflows decisions approved-prds reviews dev-assets drafts prototypes ready-to-dev decisions/pending-questions memory/journal memory/research
    if [ ! -f CLAUDE.md ]; then
        printf '%s\n' "# Team Knowledge Base" > CLAUDE.md
    fi
    echo -e "${COLOR_GREEN}✓ 本地知识库已初始化${COLOR_RESET}"
    echo -e "${COLOR_YELLOW}  提示: 如需使用远程知识库，请设置 KNOWLEDGE_REPO 后重新运行${COLOR_RESET}"
fi

echo ""

# ============ 步骤 5: 验证设置 ============
echo -e "${COLOR_YELLOW}[5/7] 验证设置...${COLOR_RESET}"

cd "$SKILL_DIR/claude-code"

for file in PACKAGE.md README.md QUICKSTART.md DEPLOY.md; do
    if [ -f "$file" ]; then
        echo -e "${COLOR_GREEN}✓ $file${COLOR_RESET}"
    else
        echo -e "${COLOR_RED}✗ $file 缺失${COLOR_RESET}"
        exit 1
    fi
done

cd "$KNOWLEDGE_DIR"
for dir in facts workflows decisions approved-prds; do
    if [ -d "$dir" ]; then
        echo -e "${COLOR_GREEN}✓ $dir/ 目录${COLOR_RESET}"
    else
        echo -e "${COLOR_RED}✗ $dir/ 目录缺失${COLOR_RESET}"
        exit 1
    fi
done

for dir in reviews dev-assets drafts prototypes ready-to-dev decisions/pending-questions; do
    if [ -d "$dir" ]; then
        echo -e "${COLOR_GREEN}✓ $dir/ 目录${COLOR_RESET}"
    else
        mkdir -p "$dir"
        echo -e "${COLOR_GREEN}✓ $dir/ 目录已创建${COLOR_RESET}"
    fi
done

echo ""

# ============ 步骤 6: 注册 Skills 到 Claude Code ============
echo -e "${COLOR_YELLOW}[6/7] 注册 Skills 到 Claude Code...${COLOR_RESET}"

HIVE_MIND_SKILL_SRC="$SKILL_DIR/claude-code" bash "$SKILL_DIR/claude-code/scripts/register-skills.sh"

echo ""

# ============ 步骤 7: 配置自动更新 Hook ============
echo -e "${COLOR_YELLOW}[7/7] 配置自动更新 Hook...${COLOR_RESET}"

SETTINGS_FILE=~/.claude/settings.json
HOOK_CMD="SKILL_REPO=$SKILL_DIR bash $SKILL_DIR/claude-code/scripts/check-updates.sh"

if [ ! -f "$SETTINGS_FILE" ]; then
    mkdir -p ~/.claude
    echo '{}' > "$SETTINGS_FILE"
fi

python3 - <<PYEOF
import json, os

path = os.path.expanduser('~/.claude/settings.json')
with open(path) as f:
    s = json.load(f)

hooks = s.setdefault('hooks', {})
pre = hooks.setdefault('PreToolUse', [])

cmd = '$HOOK_CMD'

for entry in pre:
    if entry.get('matcher') == 'Skill':
        for h in entry.get('hooks', []):
            if h.get('command') == cmd:
                print('  已配置，跳过')
                exit(0)

pre.append({'matcher': 'Skill', 'hooks': [{'type': 'command', 'command': cmd}]})
with open(path, 'w') as f:
    json.dump(s, f, indent=2, ensure_ascii=False)
print('  Hook 已写入')
PYEOF

echo -e "${COLOR_GREEN}✓ 自动更新已配置${COLOR_RESET}"
echo ""

# ============ 安装完成 ============
echo -e "${COLOR_GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${COLOR_RESET}"
echo -e "${COLOR_GREEN}  HiveMind Skill 已准备就绪！${COLOR_RESET}"
echo -e "${COLOR_GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${COLOR_RESET}"
echo ""
echo -e "  Skill:  ${COLOR_BLUE}$SKILL_DIR${COLOR_RESET}"
echo -e "  知识库:   ${COLOR_BLUE}$KNOWLEDGE_DIR${COLOR_RESET}"
echo -e "  协议:     ${COLOR_BLUE}${REPO_PREFIX%%:*}${COLOR_RESET}"
echo ""
echo -e "${COLOR_BLUE}下一步:${COLOR_RESET}"
echo ""
echo "1. 阅读快速指南:"
echo "   cat $SKILL_DIR/QUICKSTART.md"
echo ""
echo "2. 验证设置:"
echo "   cd $SKILL_DIR/claude-code && ./scripts/test-setup.sh"
echo ""
echo "3. 开始第一个 PRD:"
echo "   cd $SKILL_DIR/claude-code"
echo "   # 在 Claude Code 中打开此目录，然后运行: /prd-write"
echo ""
echo -e "${COLOR_BLUE}可选 - Figma MCP（原型图同步）:${COLOR_RESET}"
echo "  1. 在 Claude Code 中运行: /plugins install figma"
echo "  2. 按提示完成 Figma 账号授权"
echo ""
