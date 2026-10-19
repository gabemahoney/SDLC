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
- **The Idea:** its `## Worktrees` record, for each repo's worktree, branch and base branch.

## Gate

Run only when all of these are true:

- The Idea is `done`, because only accepted work goes back to the base branch. Otherwise, stop and report its status.
- Each main checkout is on its recorded base branch and clean. Otherwise, stop and tell the Managing Intelligence which ones aren't, because merging into uncommitted changes can mix them with the Idea's work or lose them.
- You started outside the Idea's worktrees, because you remove them.

## Steps

1. **Check the worktrees.** Each worktree in the record must be clean and on the branch recorded for it. Stop for the Managing Intelligence on anything else, because uncommitted or unexpected changes are someone's work.
2. **Merge.** In each main checkout, merge the recorded branch into its base branch with `--no-ff`, so history shows which commits were the Idea's. On a conflict, stop and tell the Managing Intelligence the files, leaving the merge for them to resolve or abort.
3. **Clean up.** Remove each merged worktree and delete its branch. Keep anything git refuses to remove, so no work is lost.

## Child Agents

None: you merge and clean up yourself.

## Writes

- **The Idea:** under `## Worktrees`, each repo's merge commit and cleanup result, so a later Run can finish anything left. Leave its status unchanged.
- **Repos:** merge commits on base branches; removed worktrees and branches.

## Done

Report the Idea's ID, which repos merged, and anything left with the reason.
