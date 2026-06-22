# HiveMind — Codex 版

> Codex 专用 skill。支持 `/prd` 命名空间（需求、research、review、docs、prompt、competitor、assets、clean）、`/dev`、`/ui-draft`、`/gtm`、`/email` 和 `/hive-mind-update` 作为 intent label，把产品讨论、知识库维护、商业化内容、基于固定模板的可发送 HTML 邮件、研发交接和原型沉淀到团队产品知识库。

## 安装

打开 Codex，把下面这句话发给它：

```text
帮我安装这个 Codex skill：https://github.com/eureka266/hive-mind 。请把完整仓库 clone 到 ~/hive-mind，运行 ~/hive-mind/codex/install.sh 安装到 ~/.codex/skills/hive-mind。安装完成后提醒我重启 Codex 或开启新会话。
```

安装后 skill 会复制到：

```text
~/.codex/skills/hive-mind
```

Codex 不注册真实 slash command。你可以自然语言触发，也可以输入团队习惯的 intent label：

```text
/prd csv-import
/prd research detail-page-optimization 整理这 4 个用户访谈，标出 PRD gap 和冲突
/prd review csv-import
/prd docs notification channels
/prd prompt onboarding assistant
/prd competitor "Competitor A"
/prd assets scan
/prd clean
/dev csv-import
/ui-draft csv-import
/gtm 写一篇你的产品相比竞品的核心优势文章
/email 写一封产品更新邮件，中文和英文，生成 HTML 并保存到资产库
/hive-mind-update
```

## 知识库

HiveMind 把所有产出沉淀到一个团队产品知识库（默认本地 `~/team-knowledge`）。你可以让它只在本地维护，也可以把知识库指向你自己的私有 Git 仓库以便团队协作：

```bash
KNOWLEDGE_REPO=your-org/team-knowledge bash ~/hive-mind/codex/install.sh
```

不设置 `KNOWLEDGE_REPO` 时，安装脚本会在本地 `git init` 一个全新的知识库，不连接任何远端。

## 更新

如需更新，输入 `/hive-mind-update`。Codex 版没有 Claude Code 的自动更新 hook；这个命令会显式运行已安装 skill 内的 `scripts/update-skill.sh`，跟随源仓库当前 upstream remote/branch 更新并重新安装。更新后需要重启 Codex 或开启新会话，让新版 skill 重新加载。
