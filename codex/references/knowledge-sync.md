# Knowledge Repository Sync

Use this before any HiveMind workflow reads or writes product context.

## Defaults

- Local path: `~/team-knowledge`
- Remote: `https://github.com/your-org/team-knowledge.git`
- Branch: `main`

## Language Boundary

- `customer-knowledge/` is an English-only knowledge area. Any new or updated file under `customer-knowledge/` must be written in English, including headings, examples, metadata descriptions, FAQ answers, user manual text, and API docs.
- In chat, use Chinese by default when the user chats in Chinese. When reporting about `customer-knowledge/`, explain the plan and evidence in Chinese, but keep any proposed `customer-knowledge/` content itself in English.
- Preserve the user's own product, feature, and API terms in English across all knowledge repo reads and writes.

## Required Behavior

1. If `~/team-knowledge` does not exist, clone the repository:

   ```bash
   git clone https://github.com/your-org/team-knowledge.git ~/team-knowledge
   ```

2. If the directory exists, confirm it is a git repository.

3. Before loading context, sync the latest remote state:

   ```bash
   cd ~/team-knowledge
   git pull --ff-only origin main
   ```

4. If the worktree has local changes and `--ff-only` cannot proceed safely, do not discard them. Tell the user which files are changed and ask whether to continue with local cache, stash/commit manually, or stop.

5. If clone or pull fails because of network or permissions, say so clearly and ask whether to continue with local cache or chat-only artifacts.

6. After sync, load only relevant files from:
   - `facts/`
   - `features/`
   - `workflows/`
   - `decisions/`
   - `decisions/pending-questions/`
   - `drafts/`
   - `pending/`
   - `archive/`
   - `reviews/`
   - `approved-prds/`
   - `approved_prds/`
   - `ready-to-dev/`
   - `dev-assets/`
   - `prototypes/`
   - `assets/emails/`
   - `assets-index.md`
   - `customer-knowledge/`
   - `prompts/`
   - `competitors/`
   - `interactions/`
   - `scripts/` when the workflow explicitly invokes repo maintenance scripts
   - `memory/sessions/`
   - `memory/journal/`
   - `memory/research/`
   - `memory/rules/`
   - `memory/indexes/`

7. For substantive PM workflows, immediately continue with `active-memory.md` so relevant reusable rules and resumable session notes are loaded before reasoning.

## Reporting

Briefly report:

- Whether the repo was cloned, pulled, or local cache was used.
- The local path.
- Any sync failure or local-change risk.
- Whether active memory directories were found or absent.
