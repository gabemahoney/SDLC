---
name: configure-worktree
description: "Create or reuse a branch and worktree for an Idea or Bug in every affected repo, and record them on the ticket. Takes an Idea or Bug ID."
---

# configure-worktree

## Purpose

You create or reuse a branch and worktree for an Idea or Bug in every affected repo, and record them on the ticket. Every Epic of an Idea is developed in these worktrees, one after another; a Bug's repair uses them through acceptance.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

An Idea or Bug ID.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md` and `protocol:ticket.md`, for operations.
- **The Idea and its Plan, or the Bug:** for the repos the work changes and any earlier worktree record. A Bug's repos come from define-bug's `## Reproduction` record or the Managing Intelligence.

## Gate

Run only when all of these are true:

- For an Idea, it and its Plan are `defined` or `active`, because the Plan says which repos change. For a Bug, it is `defined` or `active`, because define-bug confirms the defect. Otherwise, stop and report which isn't.
- Each main checkout that needs a new branch is clean. Otherwise, stop and tell the Managing Intelligence which ones aren't, because the new branch would leave their uncommitted changes out.

## Steps

1. **Settle the setup.** Find the repos the Plan changes, or those recorded in the Bug's `## Reproduction` or supplied by the Managing Intelligence. Base each new branch on its main checkout's current branch unless the Managing Intelligence says otherwise.
2. **Create or reuse the worktrees** under the Worktree rules below.
3. **Record them** on the Idea or Bug.

## Child Agents

None: you prepare the worktrees yourself.

## Writes

- **The Idea or Bug:** under `## Worktrees`, each repo's main checkout path, worktree path, branch, and base branch and commit. The base branch is where teardown-worktree merges the work back. This record is how develop-epic, idea-review, fix-bug and teardown-worktree find the work. Leave its status unchanged.
- **Repos:** create branches and worktrees.

## Done

Report the Idea or Bug ID and its worktree paths, and suggest develop-epic for the Plan's first ready Epic or fix-bug for the Bug.

## Worktree rules

- Name each branch after the Idea or Bug ID with dots replaced by underscores, and put each worktree at the path `~/.apiary/system/workflow.md` defines, so later skills can find them.
- Reuse a worktree only if it's in the right repo on the ticket's branch, and keep its changes, because they're the ticket's work in progress.
- If the path holds other work, or the branch exists without its worktree, stop for the Managing Intelligence, to protect that work.
