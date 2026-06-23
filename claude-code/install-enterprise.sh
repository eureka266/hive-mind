#!/bin/bash

# HiveMind Skill - 企业管理员安装脚本
# Enterprise Administrator Setup Script

set -e

COLOR_RESET='\033[0m'
COLOR_GREEN='\033[0;32m'
COLOR_BLUE='\033[0;34m'
COLOR_YELLOW='\033[1;33m'
COLOR_RED='\033[0;31m'

echo -e "${COLOR_BLUE}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "   HiveMind - Enterprise Setup Wizard"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${COLOR_RESET}\n"

# ============ 企业配置 ============
echo -e "${COLOR_YELLOW}企业配置${COLOR_RESET}"
echo ""

read -p "企业/组织名称: " ORG_NAME
read -p "PM 团队负责人邮箱: " ADMIN_EMAIL
read -p "知识库 GitHub 仓库 URL (默认: https://github.com/your-org/team-knowledge.git): " REPO_URL

REPO_URL=${REPO_URL:-"https://github.com/your-org/team-knowledge.git"}

# 创建企业配置文件
mkdir -p ~/.hive-mind-enterprise

cat > ~/.hive-mind-enterprise/config.yaml << EOF
# HiveMind Enterprise Configuration
# Generated: $(date)

organization: "$ORG_NAME"
admin_email: "$ADMIN_EMAIL"

knowledge_base:
  url: "$REPO_URL"
  branch: main

team:
  max_members: unlimited
  permissions:
    - admin
    - pm
    - viewer

git:
  author_name: "HiveMind [$ORG_NAME]"
  author_email: "$ADMIN_EMAIL"
  auto_commit: true
  auto_pull: true

features:
  fact_extraction: true
  decision_logging: true
  changelog_generation: false  # deprecated; use memory/journal/ + decisions/ instead
  multi_person_collaboration: true
  audit_log: true

security:
  require_ssh: true
  enable_audit_log: true
  log_path: ~/.hive-mind-enterprise/audit.log
EOF

echo -e "${COLOR_GREEN}✓ 企业配置已保存${COLOR_RESET}"

# ============ 安装脚本分发 ============
echo ""
echo -e "${COLOR_YELLOW}安装脚本分发${COLOR_RESET}"
echo ""

mkdir -p ~/.hive-mind-enterprise/scripts
cp install.sh ~/.hive-mind-enterprise/scripts/

# 创建团队安装脚本
cat > ~/.hive-mind-enterprise/scripts/team-install.sh << 'EOF'
#!/bin/bash
# 团队成员快速安装脚本

echo "HiveMind Skill - Team Member Setup"
echo ""

# 自动调用主安装脚本
bash ~/HiveMind/install.sh
EOF

chmod +x ~/.hive-mind-enterprise/scripts/team-install.sh

echo -e "${COLOR_GREEN}✓ 安装脚本已准备${COLOR_RESET}"

# ============ 权限设置 ============
echo ""
echo -e "${COLOR_YELLOW}GitHub 团队权限配置${COLOR_RESET}"
echo ""

echo "请按以下步骤配置 GitHub 团队权限:"
echo ""
echo "1. 进入: https://github.com/your-org/settings/teams"
echo "2. 创建团队: \"HiveMind Team\""
echo "3. 添加成员（所有 PM）"
echo "4. 权限设置:"
echo "   - hive-mind: Read"
echo "   - team-knowledge: Read + Write"
echo ""

read -p "已配置完成? (y/n): " GITHUB_CONFIRM

if [ "$GITHUB_CONFIRM" != "y" ]; then
    echo -e "${COLOR_YELLOW}⚠ 请先配置 GitHub 团队权限${COLOR_RESET}"
    exit 1
fi

# ============ 审计日志设置 ============
echo ""
echo -e "${COLOR_YELLOW}审计日志配置${COLOR_RESET}"
echo ""

mkdir -p ~/.hive-mind-enterprise/logs

cat > ~/.hive-mind-enterprise/logs/.gitkeep << EOF
# HiveMind Enterprise Audit Log
# 记录所有 PRD 生成活动

# 格式: [timestamp] user action prd_name status
EOF

echo -e "${COLOR_GREEN}✓ 审计日志已启用${COLOR_RESET}"

# ============ 文档生成 ============
echo ""
echo -e "${COLOR_YELLOW}生成企业文档${COLOR_RESET}"
echo ""

cat > ~/.hive-mind-enterprise/TEAM_SETUP.md << EOF
# HiveMind - 团队成员设置指南

## 企业信息
- **组织**: $ORG_NAME
- **管理员**: $ADMIN_EMAIL
- **知识库**: $REPO_URL

## 快速开始（团队成员）

### 1. 安装
\`\`\`bash
bash ~/.hive-mind-enterprise/scripts/team-install.sh
\`\`\`

### 2. 配置 Git
\`\`\`bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

# 配置 SSH（推荐）
ssh-keygen -t ed25519
# 然后将公钥添加到 GitHub: https://github.com/settings/keys
\`\`\`

### 3. 开始使用
\`\`\`bash
cd ~/HiveMind
# 在 Claude Code 中打开此目录
# 然后运行: /prd-write
\`\`\`

## 工作流
1. 输入 \`/prd-write\` 开始 PRD 编写
2. 自由讨论功能（不会被打断）
3. 说 "好的，生成PRD和facts"
4. 审核事实候选项（yes/no）
5. 自动提交到 GitHub 知识库

## 文档
- **QUICKSTART.md**: 5 分钟快速指南
- **README.md**: 完整说明
- **SKILL.md**: 工作流详细规范

## 支持
- GitHub Issues: https://github.com/eureka266/HiveMind/issues
- 管理员邮箱: $ADMIN_EMAIL
- Slack: #hive-mind

---
Generated: $(date)
EOF

echo -e "${COLOR_GREEN}✓ 企业文档已生成${COLOR_RESET}"

# ============ 完成信息 ============
echo ""
echo -e "${COLOR_GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${COLOR_RESET}"
echo -e "${COLOR_GREEN}✅ HiveMind Enterprise 已部署！${COLOR_RESET}"
echo -e "${COLOR_GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${COLOR_RESET}"
echo ""

echo -e "${COLOR_BLUE}配置位置:${COLOR_RESET}"
echo "  ~/.hive-mind-enterprise/config.yaml"
echo ""

echo -e "${COLOR_BLUE}分享给团队成员:${COLOR_RESET}"
echo "  1. 发送安装链接: bash ~/.hive-mind-enterprise/scripts/team-install.sh"
echo "  2. 或直接发送: ~/.hive-mind-enterprise/TEAM_SETUP.md"
echo ""

echo -e "${COLOR_BLUE}管理:${COLOR_RESET}"
echo "  - 查看审计日志: cat ~/.hive-mind-enterprise/logs/audit.log"
echo "  - 更新配置: vim ~/.hive-mind-enterprise/config.yaml"
echo "  - 查看版本: cat ~/HiveMind/VERSION"
echo ""

echo -e "${COLOR_BLUE}下一步:${COLOR_RESET}"
echo "  1. 邀请 PM 加入 GitHub 团队"
echo "  2. 分享 TEAM_SETUP.md 给他们"
echo "  3. 他们运行安装脚本"
echo "  4. 开始使用！"
echo ""
