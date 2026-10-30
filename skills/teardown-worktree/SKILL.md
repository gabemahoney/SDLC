---
name: teardown-worktree
description: "Merge an accepted Idea or Bug's branch back into each repo's base branch and remove its worktrees and branches. Takes an Idea or Bug ID."
---

# teardown-worktree

## Purpose

You merge an accepted Idea or Bug's branch into each repo's base branch, then remove the ticket's worktrees and branches.

## Loading SDLC

Read `~/.sdlc/system/workflow.md` first for shared rules, settings and file locations.

## Input

An Idea or Bug ID.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** your Agent Protocol File (`protocol:agent-claude-code.md`, `protocol:agent-codex.md` or `protocol:agent-cursor.md`), `protocol:launcher.md` and `protocol:ticket.md`, for operations.
- **The Idea's Plan or the Bug:** its `## Worktrees` record, for each repo's worktree, branch and base branch, and what earlier Runs already did.

## Gate

Run only when all of these are true:

- The Idea or Bug is `done`, because only accepted work goes back to the base branch. Otherwise, stop and report its status.
- The Idea's Plan or the Bug has a `## Worktrees` record. Otherwise, stop and tell the Managing Intelligence, because there is nothing recorded to merge.
- The main checkouts and worktrees still to merge are on their recorded branches with no uncommitted changes, because merging could otherwise mix in or lose someone's work. Otherwise, stop and tell the Managing Intelligence which ones aren't.
- No agent is still working in the ticket's worktrees, because you remove them. Otherwise, stop and tell the Managing Intelligence.

## Steps

1. **Merge** the ticket's branches into their base branches, and use your judgement to land it cleanly: keep the ticket's work identifiable in history, and don't leave a base branch with only part of the change. If you can't merge cleanly, leave the main checkouts as you found them and tell the Managing Intelligence why, so it can be resolved on the ticket's branch.
2. **Clean up** the ticket's worktrees and branches once everything has merged, without losing any work.

## Child Agents

None: you merge and clean up yourself.

## Writes

- **The Idea's Plan or the Bug:** under `## Worktrees`, what merged, what was removed, and any conflict, so it can be resolved and a later Run can finish.
- **Repos:** merge commits on the local base branches, and the removed worktrees and branches.

## Done

Report the ticket's ID, which repos merged (locally, not pushed), and anything left with the reason. Once every repo has merged, suggest release.
