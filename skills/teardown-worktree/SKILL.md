---
name: teardown-worktree
description: "Merge an Idea's or Epic's completed worktrees, stop its Main Agent and remove the worktrees, with a worktree-only mode for caller-managed Main Agents."
---

# teardown-worktree

## Purpose

Brings completed Idea or Epic work into its target branches, then cleans up the worktrees prepared by configure-worktree.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

An Idea or Epic ID.

## Required Reading

- **Workflow:** `~/.apiary/system/workflow.md`. Why: to follow the shared Run rules.
- **Settings files:** `<Project Folder>/.apiary/project_settings.md` if present, then `~/.apiary/default_project_settings.md`. Why: to select `ticket_system` and, when managing the Main Agent, `launcher`.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` in Claude Code, or `~/.apiary/system/protocols/agent-codex.md` in Codex CLI. Why: to ask and report through the Agent.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: to read the Idea or Epic and record merge and cleanup decisions on it.
- **The Idea or Epic:** through the Ticket System Protocol File, using the input ID. Why: to read its worktree and Main Agent records, merge targets, cleanup choices and earlier results so a resumed Run continues existing work.
- **Repo and merge state:** each main checkout and the ticket's registered worktrees and target checkouts. Why: to verify ownership, branches, uncommitted changes and merges against the ticket's record.

When managing agents, read `launcher.md`, selected by `launcher` as `workflow.md` describes, to inspect and stop the Main Agent and its Child Agents before removing their worktrees.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when all of these are true:

- The input Idea or Epic is `done`. Otherwise, stop and report its status, because unfinished work is still being developed.
- The Run starts outside `<Project Folder>/.worktrees/<ticket id>/`. Otherwise, stop and ask the Managing Intelligence to run it elsewhere, because teardown removes this folder.

## Steps

1. **Settle teardown from the ticket.** Use its repos, merge targets, Main Agent assignment and cleanup choices. Default each target to its main checkout's branch. The Managing Intelligence settles missing choices; record them before changes so another Run can continue. A worktree-only choice means the Managing Intelligence ends the Main Agents and this Run handles only git.
   - In worktree-only mode, require the Managing Intelligence's confirmation that Main Agents and Child Agents using the ticket's worktrees have ended, so cleanup cannot remove a running Main Agent's files.
   - Otherwise, read `launcher.md` and reconcile the recorded Main Agent, its Child Agents and any other live agents using the ticket's worktree folder. If another agent is live, or the assigned Main Agent or any of its Child Agents is pending or working, stop for the Managing Intelligence to settle that work before merging, so the source stays stable.

2. **Prepare and merge each repo.** Follow the Merge guidance below. Record each result as work proceeds, so a failure leaves a usable handoff for the remaining repos. On a resumed Run, reconcile the recorded results with git and continue unfinished work.

3. **Finish the Main Agent assignment.** After every repo's merge succeeds, follow the Launcher Protocol File to stop the assigned Main Agent and its Child Agents and verify they have exited before cleanup. Keep the worktrees if stopping fails, because the Main Agent may still be using them. In worktree-only mode, the Managing Intelligence has already ended the Main Agents. Delaying shutdown until merges succeed preserves the Main Agent's session for fixing conflicts.

4. **Remove the completed worktrees and branches.** Remove each clean worktree once its branch is fully merged into the recorded target, then delete that branch. Keep anything git refuses to remove and record the failure, to preserve work that needs a decision. Remove the ticket's worktree folder once it is empty.

## Child Agents

None: teardown-worktree merges and removes the worktrees itself.

## Writes

- **The input Idea or Epic:** record merge targets and checkouts, cleanup choices, each repo's resulting commit and worktree and branch removal results, and the Main Agent's shutdown result or caller confirmation. Record failures, what remains and what needs resolving so another Run can resume. Ticket statuses stay unchanged because teardown integrates completed work.
- **Repos:** commit or discard worktree changes as the Managing Intelligence chooses, merge into target branches, and remove completed worktrees and their merged branches.

## Done

Report the ticket ID and which repos merged.

- If the Plan is `done` and its worktrees are merged, suggest idea-review.
- If a merge stopped on a conflict, report what the Managing Intelligence needs to decide.

## Merge guidance

- Match each worktree's repo and branch to the ticket's setup record before changing it. If they differ, stop for the Managing Intelligence's decision to protect unrelated work.
- Use a clean checkout of a local target branch distinct from the ticket's branch. The Managing Intelligence chooses a checkout if the target needs one; unrelated changes stay with their owner to handle before merging.
- For uncommitted worktree changes, use the Managing Intelligence's recorded choice to commit, discard or stop. If it is missing, they decide, because cleanup may otherwise lose work.
- Merge with `--no-ff` when the target lacks ticket commits, so history shows which commits belong to the ticket. Preserve completed merges when another repo fails, so resuming continues from recorded progress.
- For a conflict, record the conflicting files on the ticket and stop for the Managing Intelligence to decide whether to abort or resolve it. Resume an unfinished merge only when it belongs to this ticket's teardown; continue only once it is committed, so cleanup preserves the result.
