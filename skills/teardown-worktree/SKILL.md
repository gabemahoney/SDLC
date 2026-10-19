---
name: teardown-worktree
description: "Merge an accepted Idea's branch back into each repo's base branch and remove its worktrees. Takes an Idea ID."
---

# teardown-worktree

## Purpose

You merge an accepted Idea's branch into each repo's base branch, then remove the Idea's worktrees and branches.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

An Idea ID.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md` and `protocol:ticket.md`, for operations.
- **The Idea:** its `## Worktrees` record, for each repo's main checkout, worktree, branch and base branch, and what earlier Runs already did.

## Gate

Run only when all of these are true:

- The Idea is `done`, because only accepted work goes back to the base branch. Otherwise, stop and report its status.
- Each main checkout is on its recorded base branch and clean. Otherwise, stop and tell the Managing Intelligence which ones aren't, because merging into uncommitted changes can mix them with the Idea's work or lose them.
- Each worktree not yet merged is clean and on the branch recorded for it. Otherwise, stop and tell the Managing Intelligence, because uncommitted or unexpected changes are someone's work.
- You started outside the Idea's worktrees, because you remove them. Otherwise, stop and say so.

## Steps

Skip any repo the record shows is already merged and cleaned up.

1. **Merge.** In each main checkout, merge the recorded branch into its base branch with `--no-ff`, so history shows which commits were the Idea's. Record each merge as it lands. On a conflict, abort the merge so main stays clean, and tell the Managing Intelligence the files: the conflict gets fixed on the Idea's branch, then this skill runs again.
2. **Clean up.** Once every repo has merged, remove each worktree and delete its branch. Keep anything git refuses to remove, so no work is lost.

## Child Agents

None: you merge and clean up yourself.

## Writes

- **The Idea:** under `## Worktrees`, each repo's merge commit and cleanup result, so a later Run can finish anything left. Leave its status unchanged.
- **Repos:** merge commits on local base branches, without pushing; removed worktrees and branches.

## Done

Report the Idea's ID, which repos merged, and anything left with the reason.
