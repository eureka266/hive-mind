---
name: hive-mind-update
description: HiveMind 手动更新命令。检查 hive-mind 是否有新版本，更新后重新注册 /prd、/prd-review、/dev、/ui-draft 等 skill，并展示 changelog。输入 /hive-mind-update 或说更新 HiveMind 时使用。
---

# hive-mind-update

手动检查并更新 HiveMind Skill。

## 使用方式

```
/hive-mind-update
```

适用场景：

- 用户怀疑 `/prd`、`/dev`、`/prd-review` 等命令不是最新
- 新增 skill 后没有出现在 Claude Code
- 自动更新被本地修改、网络或 hook 配置跳过
- 用户明确说“更新 HiveMind Skill”

## 工作流

1. 运行：
   ```bash
   bash ~/HiveMind/claude-code/update.sh
   ```

2. 如果脚本提示有本地未提交修改，停止并解释：
   - 自动更新为了保护本地改动不会覆盖工作区
   - 需要先提交、stash 或放弃本地修改

3. 如果更新成功，确认以下命令已注册：
   ```bash
   ls ~/.claude/skills/prd/SKILL.md
   ls ~/.claude/skills/prd-review/SKILL.md
   ls ~/.claude/skills/dev/SKILL.md
   ls ~/.claude/skills/ui-draft/SKILL.md
   ```

4. 向用户总结：
   - 是否已经是最新
   - 是否完成更新
   - 是否重新注册 skills
   - 是否同步知识库

## 注意

`/hive-mind-update` 是手动更新入口。自动更新仍由 `claude-code/scripts/check-updates.sh` 在 Skill 调用前静默检查。
