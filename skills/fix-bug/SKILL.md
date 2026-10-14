---
name: fix-bug
description: Fix a bug described in a Bee ticket
---

## Overview

The user will either call without arguments or with a Bug id
- If called without arguments, find all Bug bees for this repo that are not `done` and present them, asking which one to fix. No-questions mode: list them and end with `fix-bug: needs input: which Bug should I fix? Reply with its ID`.
- If called with a Bee id, find it in the Bugs hive. If its not in the Bugs hive, tell the user and ask them if they want to continue. No-questions mode: end with `fix-bug: needs input: <id> is not in the Bugs hive — reply "continue" to fix it anyway`. With `continue` after the ID, go on without asking.

You will ultimately get the Bug ID you need to work on.

### Arguments

| Form | Meaning |
|---|---|
| `/fix-bug` | List the Bug bees that are not `done` and ask which one to fix. |
| `/fix-bug <bug-id>` | Work the Bug from its current status. |
| `/fix-bug <bug-id> <answer>` | Continue after a `fix-bug: needs input:` stop. The answer follows the ID: `continue` (not in the Bugs hive), `fix` or `invalid` (bug could not be confirmed), `resume` or `restart` (worktree left by an interrupted run; `resume` after a merge conflict), `waive` or guidance (integration gate). |
| `--no-questions` | Never use AskUserQuestion (see No-questions mode). |

**No-questions mode**: on when you are given `--no-questions`, or when you run as an agent-director worker (`AGENT_DIRECTOR_INSTANCE_ID` is set in your environment; such workers usually cannot use AskUserQuestion). In this mode never use AskUserQuestion. Wherever this skill asks the User or the caller — with AskUserQuestion or in plain text — stop instead. Put what you know in your output, end it with exactly one `fix-bug: needs input:` line as given in the steps, and end your turn. The driver answers in this session, or starts a fresh session and gives the answer after the ID (e.g. `/fix-bug b.xxx fix`). Outside this mode, ask with AskUserQuestion.

New bugs are filed in the Bugs hive as `draft`. This skill first confirms the bug is real, then fixes it. Bug work is blanket approved: one run takes a real bug from `draft` through `defined` and `active` to `done` with no stop in between, unless a step below says to stop.

### Execution model

You are the **calling agent**. Role players are **subagents** — named agent definitions installed in `.claude/agents/`, spawned via the Agent tool: `Agent(subagent_type: "<agent-name>", prompt: <bug-specific dispatch prompt>)`.

Rules that apply to every dispatch in this skill:

- **Background dispatch**: if the Agent tool schema accepts `run_in_background`, pass `run_in_background: true`; otherwise omit it — background is the harness default under Claude Code fork-subagents mode. Every dispatch in this skill is a background dispatch.
- **Cold start**: subagents are never named, reused, or messaged mid-flight. Every dispatch is a fresh spawn with a self-contained prompt. Dispatch prompts name the Bug ID; subagents read the ticket from the bees CLI themselves.
- **Hub-and-spoke**: subagents never talk to each other. The working tree diff plus the returned report is the handoff. You serialize dependent roles and thread each report into the next role's dispatch prompt.
- **Reconciliation loop**: drive the work event-driven, not as one big blocking turn. Each tick: (1) observe current state — ticket store, working tree, in-flight Agent status; (2) reconcile — dispatch whatever fresh Agent invocations the delta requires; (3) yield the turn. The harness fires a completion notification when each background Agent finishes; that notification triggers the next tick. No polling, no sleep loops, no blocking waits inside a turn.
- **Compaction recovery**: when a compaction/summarization marker is visible in your conversation, everything before it is non-authoritative. Before dispatching the next tick's work after a compaction, re-read the authoritative sources in full — the bees CLI for ticket state, git for code state, and the filesystem for any state files. Conversation memory is never a substitute for these sources.
- **Delegate discipline**: you must not do role work yourself. You dispatch subagents, route reports on completion, and commit. Confirming the bug is real (step 1) is triage, not role work: you do it yourself, read only.

#### In Codex CLI

The rules above name Claude Code's tools. In Codex CLI, keep the rules and use these instead:

- **Dispatch**: for `Agent(subagent_type: "<agent-name>", prompt: <P>)`, call `spawn_agent` with `agent_type: "<agent-name>"` (pass it even if the tool does not list it; the agent is defined in `~/.codex/agents/<agent-name>.toml` or the repo's `.codex/agents/`), `message: <P>`, `fork_turns: "none"` (the cold start; where `spawn_agent` has no `fork_turns`, do not fork) and a unique `task_name` of lowercase letters, digits and underscores (e.g. `engineer_bugfix_b_abc`). Pass no `model` or `reasoning_effort`: the agent file sets them.
- **Ticks**: Codex sends no completion notification. Spawn every dispatch of the tick, then call `wait_agent` (prefer long waits, minutes): it ends the tick, and is the one blocking wait allowed. Each finished agent's report starts the next tick. Never end your turn while an agent you spawned is still running: Codex will not wake you when it finishes, so wait for it with `wait_agent` instead. Close a finished agent with `close_agent` where that tool exists.
- **Concurrency**: Codex runs a few agents at once (`agents.max_concurrent_threads_per_session`, 4 by default, you included). When no slot is free, wait for an agent to finish before spawning the next, so parallel dispatches (e.g. the reviewers) may run in batches.
- **Questions**: there is no AskUserQuestion. Ask in plain text in your reply and end your turn. No-questions mode is unchanged.
- **Skills and agents**: "invoke the /x skill" or the Skill tool means: read `~/.agents/skills/x/SKILL.md` (or the repo's `.agents/skills/x/SKILL.md`) and follow it. Agent definitions are `.codex/agents/apiary-*.toml`, not `.claude/agents/apiary-*.md`.

### Setup:
There must be a hive called "Bugs". If it does not exist, ask the user where you can create one. No-questions mode: end with `fix-bug: needs input: there is no Bugs hive — run /apiary-setup to create it, then re-run /fix-bug`.
It must have no child tiers and the following valid status values:
- `draft` — filed, not yet validated
- `defined` — confirmed real, not yet being fixed
- `active` — being fixed
- `done` — fixed and merged, or closed as invalid (tagged `invalid`)

If it has other values (e.g. the old `open`, `larva`, `pupa`, `worker` or `finished`), tell the user to run `/apiary-setup`, which migrates the hive, and stop. No-questions mode: end with `fix-bug: needs input: the Bugs hive is on old status values — run /apiary-setup to migrate it, then re-run /fix-bug`.

### 1. Validate Bug

```bees
show_ticket(ticket_id="$1")
```

#### Check status

Act on the Bug's status:
- `draft` → check blocked, then confirm the bug is real (below). With the answer `fix` or `invalid` after the ID, skip the confirmation and act on the answer as for **Real** or **Invalid** below (for `invalid`, the `## Invalid` note says it was closed on that answer).
- `defined` → already confirmed, e.g. by an earlier run that was interrupted before fixing began. Check blocked, skip the confirmation, set `active` and go to step 2.
- `active` → an earlier run was interrupted while fixing, or stopped at a question. Check blocked, then look for its worktree (`{repo_root}/../{normalized_bug_id}`, named as in step 2):
  - If it exists, do not create another. With an answer after the ID, act on it:
    - `resume` → skip step 2's `git worktree add` and pick up where the work had reached, judging from the worktree's diff and branch commits. If its branch is already merged into the main branch (e.g. the user resolved a merge conflict), go to step 7 item 3. If unsure, start at step 4 so the existing changes are reviewed.
    - `restart` → remove the worktree and its branch (`git worktree remove {worktree_path} --force`, `git branch -D {normalized_bug_id}`) and start the fix again from step 2.
    - `waive` or guidance → the answer to a step 5 integration gate stop, in that worktree: for `waive`, record the waiver as the integration result and go to step 6; for guidance, re-dispatch the integration Test Writer with it.
  - Without an answer, report its path, whether it has uncommitted changes (`git -C {worktree_path} status`) and the commits on its branch. Interactive: ask with AskUserQuestion (options: Resume / Restart) and act as above. No-questions mode: end with `fix-bug: needs input: <bug-id> has a worktree from an interrupted run at <path> (uncommitted changes: <yes|no>; <n> commits on <branch>) — reply "resume" to continue there or "restart" to discard it and start over`.
  - If it does not exist and the main branch has the commit `Merge worktree {bug_id} into {main_branch}`, the fix was merged before the status was set: set `done`, report it and stop.
  - Otherwise, start the fix again from step 2. The bug is already confirmed.
- `done` → report that the Bug is done, and whether it is tagged `invalid`, and stop.
- Any other status → stop and report it. If it is an old value (`open`, `larva`, `pupa`, `worker` or `finished`), the hive is on old values: tell the user to run `/apiary-setup`.

#### Check blocked

Check the `up_dependencies` array for any blockers. Each must be `done`.

If blocked:
- Output blocking IDs and titles
- Exit with message: "Cannot start Bug $1. It is blocked by: [list]"
- Leave the Bug's status unchanged

#### Confirm the bug is real (`draft` only)

Before any fixing, confirm the bug is real. Do this yourself in the main repo tree, before the worktree exists, and change no files in the repo:
- Reproduce it: follow the bug's steps, or run the existing tests or commands that show it. Put any scratch script outside the repo (e.g. a temp directory).
- If it cannot be reproduced, or reproducing it would mean changing the repo, review the code to confirm the reported behaviour is real.

Then:
- **Real** → set `defined`, then straight away set `active` and go to step 2. Do not stop in between.
- **Invalid** (the reported behaviour cannot happen, or is intended) → set `done`, add the tag `invalid`, and append an `## Invalid` section to the Bug saying why, with the evidence (what you ran, or the `path:line` you reviewed):
  ```bash
  bees append-ticket-body --ticket-id $1 --chunk "

  ## Invalid
  <why, with evidence>"
  bees update-ticket --ids $1 --status done --add-tags '["invalid"]'
  ```
  Nothing else changes: no worktree, no subagents, no commit. Output this summary and stop:
  ```markdown
  ## Bug [x] closed as invalid: [bug-title]

  **Bug**: <bug-id>
  **Why**: <one or two lines>
  ```
- **Cannot tell** → leave it `draft` and append a `## Validation` section to the Bug (as for `## Invalid` above) saying what you ran or reviewed and why it is inconclusive. Interactive: ask with AskUserQuestion (options: Fix / Close as invalid) and act on the answer as for **Real** or **Invalid**. No-questions mode: end with `fix-bug: needs input: <bug-id> could not be confirmed — <one-line why>; reply "fix" or "invalid"`.

### 2. Create an isolated worktree

**This step is required, not optional.** fix-bug's reconciliation loop dispatches multiple subagents across several ticks — real wall-clock time during which the main working tree would otherwise be exposed to collision with other concurrent work, with no clean rollback point. All subsequent work in this skill (subagent dispatch, edits, the final commit) happens inside this worktree, never in the main repo tree.

Normalize the Bug ID: replace dots with underscores (e.g., `b.8df` → `b_8df`). Call this `{normalized_bug_id}`.

Determine the repo root from the current working directory:
```bash
git rev-parse --show-toplevel
```

Always create a new worktree as a sibling directory of the repo root (this auto-creates a branch named `{normalized_bug_id}`), matching configure_worktree's and do-bee's precedent — no existence check, no reuse (except when the user chose in step 1 to resume an interrupted run in its existing worktree):
```bash
git worktree add {repo_root}/../{normalized_bug_id}
```

Copy the gitignored `auto_approve.sh` into the worktree if it is present in the main repo (`docker/` and `.claude/` are tracked and already present in the worktree):
```bash
if [ -f "{repo_root}/auto_approve.sh" ]; then
    cp "{repo_root}/auto_approve.sh" "{repo_root}/../{normalized_bug_id}/auto_approve.sh"
fi
```

Call the resulting path `{worktree_path}` (`{repo_root}/../{normalized_bug_id}`). Do **not** launch a worker session — fix-bug runs as the calling agent in the main repo's session and only needs the worktree itself.

### 3. Dispatch Subagents to Fix Bug

Analyze the bug, the source code, the tests and the docs. Understand the likely scope of the bug fix.
If the fix requires modifications to the source code, you will need to dispatch `apiary-engineer-bugfix`.
If the fix changes source code or unit tests, you will need to dispatch `apiary-test-writer-bugfix`; it also owns the regression test (step 5) and the full unit-suite run.
Always dispatch `apiary-doc-writer-bugfix` so that it can determine if any docs need updating based on the changes.
Always dispatch one `apiary-test-writer` as the integration Test Writer at the end of the fix (step 5).

Each full test suite has exactly one owner:
- **Full unit suite**: the Test Writer of each pass — `apiary-test-writer-bugfix` in the initial and re-work passes, or the integration Test Writer after an integration fix (step 5) — runs it once and fixes failures.
- **Integration suites**: the integration Test Writer, once at the end of the fix (step 5).
- No one else — not you, the Engineer, the Doc Writer or the reviewers — runs either full suite; roles may run targeted tests for the code they touched.

Determine the scope and dispatch the appropriate role subagents as background dispatches. Do not ask for confirmation.

**IMPORTANT: All work happens in the worktree.** Every role subagent dispatch prompt must direct the subagent to operate in `{worktree_path}` — all reads, edits, and any commands run against the source must target that directory, not the main repo tree. Thread `{worktree_path}` into each dispatch prompt explicitly.

**IMPORTANT: You must not do role work yourself. Dispatch subagents, route their reports, and commit.**

Each role's Responsibilities and Instructions live in its agent definition (`.claude/agents/apiary-*-bugfix.md`, plus `apiary-test-writer.md` for the integration run). Your dispatch prompt supplies the job-specific context: the Bug ID and any threaded reports from prior roles. Sequencing you own across ticks: on the Engineer's completion tick, dispatch the Test Writer with the Engineer's report threaded into its prompt — it reviews the Engineer's work as part of its instructions. Dispatch the Doc Writer once code and tests have settled — on the Test Writer's completion tick, or on the Engineer's when no Test Writer is needed — with the Engineer and Test Writer reports threaded into its prompt. After dispatching a tick's work, yield; completion notifications drive the next tick.

#### 4. Review Loop

Once the role subagents are done, dispatch the applicable reviewer subagents as parallel background dispatches in a single reconciliation tick.
If you dispatched the Engineer, dispatch `apiary-code-reviewer`.
If you dispatched the Test Writer, dispatch `apiary-test-reviewer`.
If you dispatched the Doc Writer, or the change touched a README or any doc the repo's doc-writing guide governs (whoever edited it), dispatch `apiary-doc-reviewer`.

Each reviewer subagent invokes its corresponding review skill (/code-review, /test-review, /doc-review) and returns a numbered list of freeform findings (an explicit "no findings" statement when there are none). Include this line in each reviewer's dispatch prompt: "Your review skill is a read-only operation — invoke it via the Skill tool; do not decline the invocation."

- Get the feedback, and make a judgement call about whether that work must be done
  - If so, **spawn fresh role subagents** to do the work
    - **IMPORTANT** Do not do the work yourself — dispatch, route reports, and commit.
    - If the feedback was minor enough, you may choose to **NOT** dispatch the Product Manager on this iteration 
    - Dispatch any role subagents required to do the work you deem necessary from the reviewer findings
    - Batch the re-work in the same order as the initial pass: the Engineer, then the Test Writer, then the Doc Writer, each dispatched after the previous role's re-work completes, with the earlier re-work reports threaded into its prompt. Skip any role with no findings and no upstream changes to follow. Make at most **one** Doc Writer dispatch for that review round, carrying all doc-affecting findings batched together. Skip the doc pass entirely if nothing doc-affecting changed.
  - If not, move on to Final Review but you MUST share the ignored feedback for review
  - Note: This could create an infinite loop so you may ignore feedback so long as you present it in Final Review

#### 5. Testing the bug
- Ensure there is at least one unit test that fails before the bug fix and passes after
  - This ensures we will not introduce this particular regression again in the future
- Run the integration suites once, after code and tests have settled (the review loop's re-work is done), never alongside another role:
  - Dispatch one `apiary-test-writer` as the integration Test Writer, naming the Bug ID and `{worktree_path}`. It finds the integration test command (configured in the project's CLAUDE.md, otherwise discovered from the repo's docs or CI config), runs the integration suites, fixes and re-runs failures caused by the tests without editing source, and reports exactly one result: `passed` (or `passed after fixing: <summary>`), `source failures: <list>`, `could not run: <reason>` or `no integration suite found`. You do not run the suites yourself.
  - `source failures`: dispatch `apiary-engineer-bugfix` with the failures threaded into its prompt, then re-dispatch the integration Test Writer with the Engineer's report threaded in (it covers the fix in unit tests and runs the full unit suite itself). Repeat, but stop and ask the user if an Engineer round does not reduce the failures, or after 3 Engineer rounds, whichever comes first.
  - `could not run`: ask the user straight away; never dispatch the Engineer for it.
  - No-questions mode: instead of asking, leave the Bug `active` with the fix uncommitted in `{worktree_path}` and end with `fix-bug: needs input: <bug-id> integration suites <could not run: <reason> | still failing: <list>>; fix is uncommitted in <worktree_path> — reply with guidance, or "waive" to waive the gate`. The answer comes back as `/fix-bug <bug-id> <answer>` (step 1, `active`).
  - After you ask, one of three things happens: the User fixes the environment or gives guidance and you re-dispatch the integration Test Writer; the User explicitly waives the gate for this Bug — record the waiver as its result; or execution stops with the Bug left `active`, and you tell the User the fix is uncommitted in `{worktree_path}`.
  - **Gate**: the Bug is not done until its last integration run reported `passed` or `no integration suite found`, or the User waived the gate. Do not start step 6 until then.


#### 6. After Bug is fixed

Once the bug is fixed and the step 5 integration gate is met:

1. Create one git commit for the Bug **inside the worktree** — commit via `git -C {worktree_path}` (or with `{worktree_path}` as the working directory), never in the main repo tree. Use system or project defined guidance on git usage.
2. Output the summary below to the screen:

```markdown
## Bug [x] done: [bug-title]

**Bug**: <bug-id>
**Files Changed**: [count] files ([list key filenames if < 5, otherwise just count])
**Reviews**: [Code review: X issues found/None needed | Docs review: Y issues found/None needed]
**Integration Suites**: [passed | passed after fixing: <summary> | no integration suite found | waived by User: <last result>] (command: <command>, configured or discovered)
**Ignored Review Feedback**: [list items that were flagged but not addresses, or "None"]
```

### 7. Merge the worktree back and clean up

**This step is required.** After the summary is posted, merge the worktree back into the main branch and remove it, mirroring `teardown_worktree`'s mechanics. You are the calling agent running in the main repo's session, so you can perform the teardown directly (or invoke the `teardown_worktree` skill). There is **no tmux session to kill** in fix-bug's case — skip that step.

Run all of the following from the main repo (`{repo_root}`), not from inside the worktree:

1. Handle any uncommitted changes in the worktree, excluding the gitignored `auto_approve.sh`:
   ```bash
   git -C {worktree_path} status
   # if anything remains uncommitted:
   git -C {worktree_path} add -A -- ':!auto_approve.sh'
   git -C {worktree_path} commit -m "uncommitted changes from {bug_id}"
   ```
2. Merge the worktree branch (named `{normalized_bug_id}`) into the main branch with `--no-ff`:
   ```bash
   git merge {normalized_bug_id} --no-ff -m "Merge worktree {bug_id} into {main_branch}"
   ```
   If merge conflicts occur, report the conflicting files and stop so the user can resolve them before re-running teardown. The Bug stays `active`. No-questions mode: end with `fix-bug: needs input: merging {normalized_bug_id} into {main_branch} conflicts in <files> — resolve and commit the merge, then reply "resume"`.
3. Once the merge succeeds, set the Bug to `done`:
   ```bash
   bees update-ticket --ids {bug_id} --status done
   ```
4. Remove the worktree and delete the branch:
   ```bash
   git worktree remove {worktree_path} --force
   git branch -d {normalized_bug_id}
   ```
   If the branch delete fails as unmerged, warn the user rather than force-deleting silently.

Output the summary, perform the teardown, and exit. Do not ask for confirmation.
