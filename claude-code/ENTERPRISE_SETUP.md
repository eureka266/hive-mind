# HiveMind - 企业部署指南

**版本**: 0.0.16
**发布日期**: 2026-06-17
**目标受众**: 企业管理员、IT 团队、PM 负责人

---

## 目录

1. [系统要求](#系统要求)
2. [管理员部署](#管理员部署)
3. [团队成员设置](#团队成员设置)
4. [权限和安全](#权限和安全)
5. [故障排除](#故障排除)
6. [维护和更新](#维护和更新)

---

## 系统要求

### 必需
- Git 2.20+
- Bash 4.0+
- GitHub 账户（带 SSH 或 token 访问权限）
- Claude Code 或任何 AI 工具

### 可选
- curl（用于某些功能）
- Slack 集成（用于通知）

---

## 管理员部署

### 第 1 步: 企业初始化

企业管理员运行：

```bash
bash ~/hive-mind/install-enterprise.sh
```

这个向导会：
1. 收集企业信息（组织名称、管理员邮箱）
2. 配置知识库 URL
3. 设置审计日志
4. 生成团队成员安装文档

### 第 2 步: GitHub 团队权限

在 GitHub 中为 PM 团队配置权限：

```
GitHub Organization Settings
  → Teams
    → Create "HiveMind Team"
      → Add Members (所有 PM)
      → Repository Access:
         - hive-mind: Read
         - team-knowledge: Read + Write
```

### 第 3 步: 分发给团队

安装脚本位置：
```
~/.hive-mind-enterprise/scripts/team-install.sh
```

分享给团队成员，或发送文档：
```
~/.hive-mind-enterprise/TEAM_SETUP.md
```

### 第 4 步: 验证部署

```bash
# 查看企业配置
cat ~/.hive-mind-enterprise/config.yaml

# 查看审计日志位置
ls -la ~/.hive-mind-enterprise/logs/
```

---

## 团队成员设置

### 快速开始（PM）

```bash
# 1. 运行安装脚本
bash ~/.hive-mind-enterprise/scripts/team-install.sh

# 2. 配置 Git（一次性）
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

# 3. 设置 SSH（推荐）
ssh-keygen -t ed25519
# 将公钥添加到: https://github.com/settings/keys

# 4. 开始使用
cd ~/hive-mind
# 在 Claude Code 中打开此目录，然后运行: /prd [feature-name]
```

### 验证安装

```bash
cd ~/hive-mind
./scripts/test-setup.sh
```

预期输出：
```
✓ skills/ directory exists
✓ Knowledge repo directory exists
✓ facts/ directory exists
✅ All checks passed! Setup is ready.
```

---

## 权限和安全

### Git 认证方式

**推荐: SSH 密钥**
```bash
ssh-keygen -t ed25519 -C "your-email@example.com"
# 添加公钥到 GitHub → Settings → SSH and GPG keys
```

**备选: GitHub Personal Token**
```bash
# 生成: https://github.com/settings/tokens
# 权限: repo, workflow
# 本地配置会自动提示输入
```

### 权限模型

```
Role        | hive-mind | team-knowledge
─────────────────────────────────────────────────────────────
admin       | Read + Write     | Read + Write (full access)
pm          | Read             | Read + Write (own PRDs)
viewer      | Read             | Read
```

### 审计日志

所有 PRD 生成活动记录在：
```
~/.hive-mind-enterprise/logs/audit.log
```

格式：
```
[2026-04-16 10:30:45] user@example.com prd-write your-product-csv-import success
```

---

## 故障排除

### 问题: Git 权限被拒绝

**症状**: `fatal: could not read from remote repository`

**解决**:
```bash
# 检查 SSH
ssh -T git@github.com

# 或使用 HTTPS token
git config --global credential.helper osxkeychain
```

### 问题: 多人冲突

**症状**: `CONFLICT in facts/your-product.md`

**解决**:
1. Skill 自动检测并报告冲突
2. PM 可以选择：
   - 手动解决并推送
   - 重新讨论（拉取最新 facts）

```bash
# 手动解决
cd ~/team-knowledge
git pull origin main --rebase
# 解决冲突...
git add facts/your-product.md
git rebase --continue
```

### 问题: 安装失败

**症状**: `Git not found` 或其他缺失依赖

**解决**:
```bash
# 检查系统要求
git --version   # Should be 2.20+
bash --version  # Should be 4.0+
curl --version  # Optional

# 安装 Git (macOS)
brew install git

# 安装 Git (Ubuntu)
sudo apt-get install git

# 安装 Git (Windows)
# https://git-scm.com/download/win
```

---

## 维护和更新

### 检查更新

```bash
cd ~/hive-mind
./update.sh
```

输出示例：
```
当前版本: 2.0.0
检查更新...
有新版本可用！

变更记录:
- chore: enhance git workflow for team collaboration
- fix: improve error messages for merge conflicts
```

### 手动更新

```bash
# 更新 Skill
cd ~/hive-mind
git pull origin main

# 更新知识库
cd ~/team-knowledge
git pull origin main
```

### 版本历史

```bash
# 查看 Skill 版本
cat ~/hive-mind/VERSION

# 查看提交历史
cd ~/hive-mind
git log --oneline | head -10
```

---

## 管理员操作

### 查看团队活动

```bash
# 查看所有 PRD（知识库日志）
cd ~/team-knowledge
git log --oneline | grep "auto-committed by HiveMind"

# 统计本周 PRD
git log --since="1 week ago" | grep "auto-committed" | wc -l
```

### 添加新团队成员

1. 在 GitHub 中添加到 "HiveMind Team"
2. 分享安装脚本链接
3. 验证他们的设置：`./scripts/test-setup.sh`

### 移除团队成员

1. 在 GitHub 中从 "HiveMind Team" 移除
2. 或撤销 SSH 密钥访问

### 备份知识库

```bash
# 定期备份
cp -r ~/team-knowledge ~/backups/team-knowledge-$(date +%Y%m%d)

# 或推送到备份仓库
cd ~/team-knowledge
git push backup main
```

---

## 最佳实践

### 对管理员

1. **定期更新** — 每月检查一次更新
2. **监控活动** — 定期查看审计日志
3. **备份** — 每周备份知识库
4. **通信** — 用 Slack #hive-mind 频道共享公告

### 对 PM 团队

1. **保持本地同步** — 每次新 PRD 前 pull 最新版本
2. **清晰的提交信息** — Skill 自动生成，保持一致性
3. **参考历史决策** — 重用过去的事实和决策
4. **协作讨论** — 如有冲突，主动沟通

---

## 企业配置参考

### config.yaml 完整示例

```yaml
organization: "Your Org"
admin_email: "you@example.com"

knowledge_base:
  url: "https://github.com/your-org/team-knowledge.git"
  branch: main

team:
  max_members: unlimited
  permissions:
    - admin      # 完全访问
    - pm         # 可写
    - viewer     # 只读

git:
  author_name: "HiveMind [Your Org]"
  author_email: "you@example.com"
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
  log_path: ~/.hive-mind-enterprise/logs/audit.log
```

---

## 支持

### 资源

- **GitHub Issues**: https://github.com/eureka266/hive-mind/issues
- **文档**: https://github.com/eureka266/hive-mind/
- **管理员邮箱**: you@example.com
- **Slack 频道**: #hive-mind

### 常见问题

**Q: 能否离线使用?**  
A: 不能。Skill 需要访问 GitHub 知识库来读写 PRD。

**Q: 能否自定义 Skill?**  
A: 可以。编辑 `~/hive-mind/claude-code/skills/` 下对应的命令文件，修改后重新运行 `register-skills.sh` 即生效。

**Q: 能否与其他工具集成?**
A: 目前支持 GitHub。未来可添加 Slack、Jira 等集成。

---

**最后更新**: 2026-06-10
**维护者**: HiveMind
**许可证**: MIT
