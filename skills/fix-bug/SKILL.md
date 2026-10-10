---
name: fix-bug
description: Fix a bug described in a Bee ticket
---

## Overview

The user will either call without arguments or with a Bug id
- If called without arguments, find all Bug bees for this repo that are not `finished` and present them, asking which one to fix
- If called with a Bee id, find it in the Bugs hive. If its not in the Bugs hive, tell the user and ask them if they want to continue

You will ultimately get the Bug ID you need to work on.

New bugs are filed in the Bugs hive as `larva`. This skill first confirms the bug is real, then fixes it. Bug work is blanket approved: one run takes a real bug from `larva` through `pupa` and `worker` to `finished` with no stop in between, unless a step below says to stop.

### Execution model

You are the **calling agent**. Role players are **subagents** — named agent definitions installed in `.claude/agents/`, spawned via the Agent tool: `Agent(subagent_type: "<agent-name>", prompt: <bug-specific dispatch prompt>)`.

Rules that apply to every dispatch in this skill:

- **Background dispatch**: if the Agent tool schema accepts `run_in_background`, pass `run_in_background: true`; otherwise omit it — background is the harness default under Claude Code fork-subagents mode. Every dispatch in this skill is a background dispatch.
- **Cold start**: subagents are never named, reused, or messaged mid-flight. Every dispatch is a fresh spawn with a self-contained prompt. Dispatch prompts name the Bug ID; subagents read the ticket from the bees CLI themselves.
- **Hub-and-spoke**: subagents never talk to each other. The working tree diff plus the returned report is the handoff. You serialize dependent roles and thread each report into the next role's dispatch prompt.
- **Reconciliation loop**: drive the work event-driven, not as one big blocking turn. Each tick: (1) observe current state — ticket store, working tree, in-flight Agent status; (2) reconcile — dispatch whatever fresh Agent invocations the delta requires; (3) yield the turn. The harness fires a completion notification when each background Agent finishes; that notification triggers the next tick. No polling, no sleep loops, no blocking waits inside a turn.
- **Compaction recovery**: when a compaction/summarization marker is visible in your conversation, everything before it is non-authoritative. Before dispatching the next tick's work after a compaction, re-read the authoritative sources in full — the bees CLI for ticket state, git for code state, and the filesystem for any state files. Conversation memory is never a substitute for these sources.
- **Delegate discipline**: you must not do role work yourself. You dispatch subagents, route reports on completion, and commit. Confirming the bug is real (step 1) is triage, not role work: you do it yourself, read only.

### Setup:
There must be a hive called "Bugs". If it does not exist, ask the user where you can create one.
It must have no child tiers and the following valid status values:
- `larva` — filed, not yet validated
- `pupa` — confirmed real, not yet being fixed
- `worker` — being fixed
- `finished` — fixed and merged, or closed as invalid (tagged `invalid`)

If it has other values (e.g. the old `open`), tell the user to run `/apiary-setup`, which migrates the hive, and stop.

### 1. Validate Bug

```bees
show_ticket(ticket_id="$1")
```

#### Check status

Act on the Bug's status:
- `larva` → check blocked, then confirm the bug is real (below).
- `pupa` → already confirmed, e.g. by an earlier run that was interrupted before fixing began. Check blocked, skip the confirmation, set `worker` and go to step 2.
- `worker` → an earlier run was interrupted while fixing. Check blocked, then look for its worktree (`{repo_root}/../{normalized_bug_id}`, named as in step 2):
  - If it exists, do not create another. Report its path, its `git -C {worktree_path} status` and the commits on its branch, and ask the user whether to resume there (skip step 2's `git worktree add` and pick up from the step the work had reached) or remove the worktree and its branch and start the fix again from step 2.
  - If it does not exist and the main branch has the commit `Merge worktree {bug_id} into {main_branch}`, the fix was merged before the status was set: set `finished`, report it and stop.
  - Otherwise, start the fix again from step 2. The bug is already confirmed.
- `finished` → report that the Bug is finished, and whether it is tagged `invalid`, and stop.
- Any other status → stop and report it. If it is `open`, the hive is on old values: tell the user to run `/apiary-setup`.

#### Check blocked

Check the `up_dependencies` array for any blockers. Each must be `finished`.

If blocked:
- Output blocking IDs and titles
- Exit with message: "Cannot start Bug $1. It is blocked by: [list]"
- Leave the Bug's status unchanged

#### Confirm the bug is real (`larva` only)

Before any fixing, confirm the bug is real. Do this yourself in the main repo tree, before the worktree exists, and change no files in the repo:
- Reproduce it: follow the bug's steps, or run the existing tests or commands that show it. Put any scratch script outside the repo (e.g. a temp directory).
- If it cannot be reproduced, or reproducing it would mean changing the repo, review the code to confirm the reported behaviour is real.

Then:
- **Real** → set `pupa`, then straight away set `worker` and go to step 2. Do not stop in between.
- **Invalid** (the reported behaviour cannot happen, or is intended) → set `finished`, add the tag `invalid`, and append an `## Invalid` section to the Bug saying why, with the evidence (what you ran, or the `path:line` you reviewed):
  ```bash
  bees append-ticket-body --ticket-id $1 --chunk "

  ## Invalid
  <why, with evidence>"
  bees update-ticket --ids $1 --status finished --add-tags '["invalid"]'
  ```
  Nothing else changes: no worktree, no subagents, no commit. Output this summary and stop:
  ```markdown
  ## Bug [x] closed as invalid: [bug-title]

  **Bug**: <bug-id>
  **Why**: <one or two lines>
  ```
- **Cannot tell** → leave it `larva`, report what you found, and ask the user whether to fix it or close it as invalid.

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
If you dispatched the Doc Writer, dispatch `apiary-doc-reviewer`.

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
  - After you ask, one of three things happens: the User fixes the environment or gives guidance and you re-dispatch the integration Test Writer; the User explicitly waives the gate for this Bug — record the waiver as its result; or execution stops with the Bug left `worker`, and you tell the User the fix is uncommitted in `{worktree_path}`.
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
   If merge conflicts occur, report the conflicting files and stop so the user can resolve them before re-running teardown. The Bug stays `worker`.
3. Once the merge succeeds, set the Bug to `finished`:
   ```bash
   bees update-ticket --ids {bug_id} --status finished
   ```
4. Remove the worktree and delete the branch:
   ```bash
   git worktree remove {worktree_path} --force
   git branch -d {normalized_bug_id}
   ```
   If the branch delete fails as unmerged, warn the user rather than force-deleting silently.

Output the summary, perform the teardown, and exit. Do not ask for confirmation.
