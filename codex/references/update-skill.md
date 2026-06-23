# Codex Skill Update Workflow

Use this when the user says `/hive-mind-update`, asks to update HiveMind, asks to install the latest Codex skill, or suspects the local Codex skill is stale.

## What This Does

Run the bundled update script:

```bash
bash ~/.codex/skills/hive-mind/scripts/update-skill.sh
```

The script reads the recorded source repository from `~/.hive-mind-skill/codex-source-repo`, updates that git clone from its current upstream remote/branch, reinstalls the Codex skill into `~/.codex/skills/hive-mind`, and syncs the product knowledge repository.

## Required Behavior

1. Run the update script from the shell.
2. If the script stops because the source repo has uncommitted changes, do not discard them. Show the changed files and ask the user whether to commit, stash, or stop.
3. If the script reports that the knowledge repo has local changes, explain that the skill was updated but knowledge sync was skipped to protect work in progress.
4. After a successful reinstall, tell the user to start a new Codex thread or restart Codex so the updated skill metadata and instructions are reloaded.

## Boundaries

- Codex does not have Claude Code's PreToolUse hook. This is an explicit update workflow, not a guaranteed silent self-update before every PM workflow.
- The source repo must be a git clone at the path recorded in `~/.hive-mind-skill/codex-source-repo`, or `~/HiveMind` as a fallback.
- By default, the script follows the source repo's current upstream remote/branch. Override with `HIVE_MIND_SKILL_REMOTE` and `HIVE_MIND_SKILL_BRANCH` only when intentionally updating from a different remote.
- Never remove local changes automatically.
