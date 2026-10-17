---
name: teardown-worktree
description: "Merge an Idea's or Epic's completed worktrees, stop its Worker and remove the worktrees, with a worktree-only mode for caller-managed Workers."
---

# teardown-worktree

## Purpose

Brings completed Idea or Epic work into its target branches, then cleans up the worktrees prepared by configure-worktree.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

An Idea or Epic ID. The ticket holds any chosen merge targets and decisions about uncommitted changes. Worktree-only mode merges and removes worktrees after the Managing Intelligence has ended the Workers using them.

## Required Reading

- **Settings files:** `<Project Folder>/.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`. Why: to select `ticket_system` and, outside worktree-only mode, `launcher`.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` in Claude Code, or `~/.apiary/system/protocols/agent-codex.md` in Codex CLI. Why: to ask and report through the Agent.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: to read the Idea or Epic and record merge and cleanup decisions on it.
- **The Idea or Epic:** through the Ticket System Protocol File, using the input ID. Why: to check its status and identify its repos, targets and earlier cleanup decisions.
- **Repo and merge state:** the main checkouts at `<Project Folder>/<repo path>`, ticket worktrees at `<Project Folder>/.worktrees/<ticket id>/<repo path>` and the repos' registered target checkouts. Why: to find branches, uncommitted changes and completed or unfinished merges, including those from an earlier Run.
- **Launcher Protocol File, outside worktree-only mode:** `~/.apiary/system/protocols/launcher-<launcher>.md`, selected by `launcher`. Why: to identify the ticket's Worker, check for other live Workers under its worktrees and stop its Worker after merging.

## Gate

Run only when all of these are true:

- The input Idea or Epic is `done`. Otherwise, stop and report its status, because unfinished work is still being developed.
- The Run starts outside `<Project Folder>/.worktrees/<ticket id>/`. Otherwise, stop and ask the Managing Intelligence to run it elsewhere, because teardown removes this folder.
- Outside worktree-only mode, the Launcher reports no other live Worker under the ticket's worktrees besides the Worker assigned to this ticket. Otherwise, stop for the Managing Intelligence to finish that work.
- In worktree-only mode, the Managing Intelligence confirms that Workers using these worktrees have ended. Otherwise, stop for them to end the Workers before cleanup.

## Steps

1. **Prepare the merges.** For each repo, use the ticket's chosen target or default to its main checkout's branch. Use a clean checkout of that target, with a branch distinct from the ticket's worktree branch. Record the targets and Managing Intelligence decisions on the ticket.
   - If the target needs checking out elsewhere, the Managing Intelligence chooses the checkout.
   - If a target checkout has an unfinished merge from an earlier Run, follow the merge-conflict decision in step 2. For unrelated uncommitted changes, stop for its owner to handle them.
   - If a ticket worktree has uncommitted changes, the Managing Intelligence decides whether to commit them, discard them or stop. Apply only their chosen action.
   - If outside worktree-only mode and the Launcher reports the assigned Worker is still working, stop for the Managing Intelligence to settle that work before merging.

2. **Merge every repo.** Merge each ticket branch into its target, creating a merge commit for new work even when a fast-forward is possible, so the history shows which commits belong to the ticket. On a resumed Run, use the existing merge state to continue the remaining work.
   - If a merge conflicts, stop for the Managing Intelligence to choose whether to abort it or resolve it. Continue only once the merge is committed.

3. **Finish the Worker assignment.** Only after every repo's merge succeeds, so a failed merge can still be fixed in the Worker's session:
   - If worktree-only mode was requested, proceed to cleanup.
   - Otherwise, ask the Launcher to stop the ticket's Worker and confirm it has ended before cleanup. If it has already ended, proceed.

4. **Remove the completed worktrees.** Remove each clean worktree once its branch is fully merged into the target, then delete the merged branch. Remove `<Project Folder>/.worktrees/<ticket id>/` once it is empty.

## Dispatches

None: teardown-worktree merges and removes the worktrees itself.

## Writes

Records merge targets and cleanup decisions on the input Idea or Epic. Commits or discards worktree changes as the Managing Intelligence chooses. Merges into each target branch, removes the ticket's worktrees and deletes their merged branches.

## Done

Report the ticket ID and, per repo, the target branch and checkout, resulting commit, and whether its worktree and branch were removed or remain. Report whether the Worker ended or was managed by the caller in worktree-only mode. If the Run stopped, report completed merges, remaining worktrees and Workers, and what needs resolving before resuming.

Next step: the Managing Intelligence continues from the merged work in the target checkouts.
