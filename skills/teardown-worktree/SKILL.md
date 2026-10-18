---
name: teardown-worktree
description: "Merge an Idea's or Epic's completed worktrees, stop its Main Agent and remove the worktrees, with a worktree-only mode for caller-managed Main Agents."
---

# teardown-worktree

## Purpose

You bring completed Idea or Epic work into its target branches, then clean up the worktrees prepared by configure-worktree.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

An Idea or Epic ID.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md` and the Ticket System Protocol File selected by `setting:ticket_system`, for operations.
- **Idea or Epic and its Plan:** for completion, worktree and Main Agent records, merge targets, cleanup choices and earlier results.
- **Guidance:** `guide:release-guide.md` for permissions on source and merge commits.

Read `protocol:launcher.md` when managing agents.

## Gate

Run only when all of these are true:

- An Epic is `done`, or an Idea's Plan is `done`. Otherwise, stop and report unfinished work. Idea work is merged before idea-review and acceptance, so the Idea itself can still be `active`.
- The Run starts outside `<Project Folder>/.worktrees/<ticket id>/`. Otherwise, stop and ask the Managing Intelligence to run it elsewhere, because you remove this folder.

## Steps

1. **Settle teardown.** Use the ticket's repos, merge targets and cleanup choices. Default each target to its main checkout's branch. The Managing Intelligence settles missing choices.
   - In worktree-only mode, require their confirmation that all agents using the worktrees have exited, because they own agent shutdown.
   - Otherwise, use `protocol:launcher.md` to confirm the assigned Main Agent and its Child Agents are idle or have exited, and no other live agent uses the worktrees. Stop for the Managing Intelligence if this isn't true, so the source stays stable during merging.

2. **Merge each repo** under the Merge rules below. Preserve completed merges if another repo fails, so a later Run can finish the remaining work.

3. **End the assignment.** Once all merges succeed, use `protocol:launcher.md` to stop the assigned Main Agent and its Child Agents and verify exit. Keep the worktrees if shutdown fails, because agents may still use them. Delaying shutdown until merges succeed preserves the session for conflict repairs. In worktree-only mode, shutdown is already complete.

4. **Remove merged work.** Remove each clean worktree whose branch is fully merged into its recorded target, then delete that branch. Keep anything git refuses to remove, to protect remaining work. Remove the ticket's worktree folder only when empty.

## Child Agents

None: you merge and remove the worktrees yourself.

## Writes

- **The input Idea or Epic:** under `## Worktrees`, record targets and checkouts, cleanup choices, each repo's resulting commit and removal results, agent shutdown or caller confirmation, and unfinished work with reasons. This record lets a later Run continue partial merges or cleanup. Ticket statuses stay unchanged because you integrate completed work.
- **Repos:** commit or discard worktree changes as the Managing Intelligence chooses, merge into target branches, and remove completed worktrees and their merged branches.

## Done

Report the ticket ID, which repos merged and any unfinished cleanup.

- If the Plan is `done` and its worktrees are merged, suggest idea-review.
- If a merge stopped on a conflict, report what the Managing Intelligence needs to decide.

## Merge rules

- Match each worktree's repo and branch to the ticket's setup record before changing it. If they differ, stop for the Managing Intelligence's decision to protect unrelated work.
- Merge into a clean local target branch distinct from the ticket's branch, so unrelated changes stay with their owner.
- For uncommitted worktree changes, use the Managing Intelligence's recorded choice to commit, discard or stop. If it is missing, they decide, because cleanup may otherwise lose work.
- Merge with `--no-ff` when the target lacks ticket commits, so history shows which commits belong to the ticket.
- For a conflict, record the files under `## Worktrees` and stop for the Managing Intelligence to decide whether to abort or resolve it. Continue only a merge belonging to this teardown, and finish its commit before cleanup, to preserve its result and unrelated work.
