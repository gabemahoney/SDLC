---
name: configure-worktree
description: "Create or reuse a branch and worktree for an Idea in every repo its Plan changes, and record them on the Idea. Takes an Idea ID."
---

# configure-worktree

## Purpose

You create or reuse a branch and worktree for an Idea in every repo the Idea's Plan changes, and record them on the Idea. Every Epic of the Idea is developed in these worktrees, one after another.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

An Idea ID.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md` and `protocol:ticket.md`, for operations.
- **The Idea and its Plan:** for the repos the work changes and any earlier worktree record.
- **Guidance:** `guide:release-guide.md`, for permission to commit in main checkouts.

## Gate

Run only when the Idea is `defined` or `active`, so worktrees serve work that's ready to proceed. Otherwise, stop and report its status.

## Steps

1. **Settle the setup.** Find the repos the Plan changes. Base each branch on its main checkout's current branch unless the Managing Intelligence says otherwise.
2. **Create or reuse the worktrees** under the Worktree rules below.
3. **Record them** on the Idea.

## Child Agents

None: you prepare the worktrees yourself.

## Writes

- **The Idea:** under `## Worktrees`, each repo's path, branch, and base branch and commit, so develop-epic, idea-review and teardown-worktree can find the work. Leave its status unchanged.
- **Repos:** create branches and worktrees. Commit in a main checkout only when the Managing Intelligence asks.

## Done

Report the Idea's ID and its worktree paths.

## Worktree rules

- Name each branch after the Idea's ID with dots replaced by underscores, and put each worktree at the path `~/.apiary/system/workflow.md` defines, so later skills can find them.
- Reuse a worktree only if it's in the right repo on the Idea's branch, and keep its changes, because they're the Idea's work in progress.
- If the path holds other work, or the branch exists without its worktree, stop for the Managing Intelligence, to protect that work.
- If a main checkout has uncommitted changes, ask the Managing Intelligence whether to commit them first, because the new branch would leave them out.
