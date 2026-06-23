# 部署指南：HiveMind Skill v2

**当前状态**: Repo B（知识库）已设置，Repo A（Skill）已部署  
**下一步**: 在 Claude Code 中测试和部署

---

## 部署前检查清单

### Repo B (team-knowledge)
- [ ] 仓库已在 GitHub 上创建
- [ ] 目录结构: `facts/`、`workflows/`、`decisions/`、`approved-prds/`
- [ ] 文件已填充: `facts/your-product.md`、`CLAUDE.md`
- [ ] Git 已初始化: `git init`、远程已添加、main 分支已推送
- [ ] 读取权限已验证: 可以从此机器 clone/pull

### Repo A (hive-mind)
- [ ] 此仓库已在 GitHub 上创建
- [ ] `SKILL.md` 已编写且内容完整
- [ ] `references/knowledge-repo-url` 已配置正确的 URL
- [ ] `README.md` 已准备好供文档使用

---

## 步骤 1: 验证 Repo B 设置

检查 Repo B 是否存在且可访问：

```bash
# Repo B 的当前位置
ls -la ~/team-knowledge/

# 应该显示:
# facts/
# workflows/
# decisions/
# approved-prds/
# CLAUDE.md
```

如果尚未在 GitHub 上，推送它：

```bash
cd ~/team-knowledge
git remote add origin https://github.com/your-org/team-knowledge.git
git branch -M main
git push -u origin main
```

---

## 步骤 2: 更新 Skill 参考

更新 Repo A 以指向 Repo B：

```bash
cd ~/HiveMind
echo "https://github.com/your-org/team-knowledge.git" > references/knowledge-repo-url
git add references/knowledge-repo-url
git commit -m "chore: set knowledge repo URL"
git push
```

---

## 步骤 3: 在 GitHub 上初始化 Repo A（如果还没有）

如果部署 Skill 为单独的仓库：

```bash
cd ~/HiveMind
git init
git add .
git commit -m "chore: initialize HiveMind skill v2"
git remote add origin https://github.com/eureka266/HiveMind.git
git branch -M main
git push -u origin main
```

---

## 步骤 4: 部署到 Claude Code

### 选项 A: 本地 Skill（推荐用于测试）

1. 打开 Claude Code
2. 进入 `/Users/eureka266/HiveMind/`
3. 输入 `/prd-write`
4. Skill 使用本地 SKILL.md 运行

### 选项 B: 注册为 Claude Code Skill

1. 创建 `.claude/skills/hive-mind/SKILL.md`
2. 从 `~/HiveMind/SKILL.md` 复制内容
3. 用 `/hive-mind-write` 命令测试

## 步骤 5: 端到端测试

```
1. 打开 Claude Code
2. 输入: /prd-write
3. 说: "帮我写一个关于 CSV 批量导入的 PRD"
4. 自由讨论（3-5 轮对话）
5. 说: "好的，生成PRD和facts"
6. 审核事实候选项（yes/no 每个）
7. 验证 GitHub: approved-prds/、decisions/ 中有新文件
```

---

## 部署故障排除

### 问: 找不到知识库
**解决方案**: 
```bash
# 验证 URL 是否正确
cat ~/HiveMind/references/knowledge-repo-url

# 验证 GitHub 仓库是否存在
gh repo view your-org/team-knowledge
```

### 问: Skill 运行期间 Git clone 失败
**可能原因**:
- SSH 密钥未设置
- GitHub token 过期
- 网络无法访问

**解决方案**:
```bash
# 验证 git 访问
ssh -T git@github.com

# 如果失败，设置 SSH 或使用 HTTPS token
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

### 问: 自动提交失败
**可能原因**:
- Git 权限被拒绝
- 知识库中有合并冲突
- 网络问题

**解决方案**:
- 检查 git 凭证: `git credential-osxkeychain`
- 验证分支是最新的: `git pull origin main`
- 手动重试自动提交

---

## 生产前检查清单

在使用真实 PRD 之前：

- [ ] 两个仓库都在 GitHub 上（Repo A + Repo B）
- [ ] 知识库 URL 在 `references/knowledge-repo-url` 中验证
- [ ] E2E 测试完成（完整的 /prd-write 周期）
- [ ] Git 自动提交测试并正常工作
- [ ] 团队已训练 `/prd-write` 工作流
- [ ] facts/ 已备份，以防万一
- [ ] 决策日志正在正确生成

---

## 监控

### 健康检查（每周做一次）

```bash
# 检查知识库是否可访问
cd /tmp && git clone $(cat ~/HiveMind/references/knowledge-repo-url) test-clone

# 检查 Skill 是否可读取事实
cat ~/team-knowledge/facts/your-product.md | wc -l

# 检查决策日志是否在创建
ls -l ~/team-knowledge/decisions/
```

### 日志

Skill 将日志写入:
- `~/.claude/hive-mind.log` (Skill 执行)
- Git 操作日志到: `~/team-knowledge/.git/logs/`

---

## 支持

**Skill 问题**: 直接编辑 `SKILL.md`，本地测试，推送到 Repo A

**知识库问题**: 在 Repo B（`~/team-knowledge/`）中工作，Skill 自动读取更改

**部署问题**: 检查 `.claude/logs/` 和 git 凭证

---

**版本**: 2.0  
**最后更新**: 2026-04-15  
**由以下人部署**: [你的名字]  
**部署日期**: [YYYY-MM-DD]
