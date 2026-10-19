---
name: teardown-worktree
description: "Merge an accepted Idea or Bug's branch back into each repo's base branch and remove its worktrees and branches. Takes an Idea or Bug ID."
---

# teardown-worktree

## Purpose

You merge an accepted Idea or Bug's branch into each repo's base branch, then remove the ticket's worktrees and branches.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

An Idea or Bug ID.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md`, `protocol:launcher.md` and `protocol:ticket.md`, for operations.
- **The Idea or Bug:** its `## Worktrees` record, for each repo's worktree, branch and base branch, and what earlier Runs already did.

## Gate

Run only when all of these are true:

- The Idea or Bug is `done`, because only accepted work goes back to the base branch. Otherwise, stop and report its status.
- The main checkouts and worktrees still to merge are on their recorded branches with no uncommitted changes, because merging could otherwise mix in or lose someone's work. Otherwise, stop and tell the Managing Intelligence which ones aren't.
- No agent is still working in the ticket's worktrees, because you remove them. Otherwise, stop and tell the Managing Intelligence.

## Steps

1. **Merge** each recorded branch into its base branch, keeping a merge commit so history shows the ticket's work. If a merge conflicts, leave the main checkout clean, carry on with the other repos, and tell the Managing Intelligence the conflicting files, so it can be resolved on the ticket's branch.
2. **Clean up.** Once every repo has merged, remove the ticket's worktrees and branches, keeping anything git won't remove so no work is lost.

## Child Agents

None: you merge and clean up yourself.

## Writes

- **The Idea or Bug:** under `## Worktrees`, what merged and what was removed, so a later Run can finish the rest. Leave its status unchanged.
- **Repos:** merge commits on the local base branches, and the removed worktrees and branches.

## Done

Report the ticket's ID, which repos merged (locally, not pushed), and anything left with the reason. Once every repo has merged, suggest release.
