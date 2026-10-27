---
name: configure-worktree
description: "Create or reuse a branch and worktree for an Idea or Bug in every repo it changes, and record them on the Idea's Plan or the Bug. Takes an Idea or Bug ID."
---

# configure-worktree

## Purpose

You give an Idea or Bug its own branch and worktree in every repo it changes, so its work stays off the base branch until the Managing Intelligence accepts it.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

An Idea or Bug ID, and any repos the caller names.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** your Agent Protocol File (`protocol:agent-claude-code.md`, `protocol:agent-codex.md` or `protocol:agent-cursor.md`) and `protocol:ticket.md`, for operations.
- **The Idea, its Plan (found by the Plan's Association) and Epics, or the Bug:** for the repos the work changes, and any earlier worktree record. An Idea's repos come from its Epics' `## Work`; a Bug's from its `## Reproduction`.

## Gate

Run only when all of these are true:

- The Idea and its Plan are `defined` or `active`, or the Bug is `defined` or `active`. Otherwise, stop and report which isn't.
- Each main checkout that needs a new branch is clean, because the branch would leave uncommitted changes out. Otherwise, stop and tell the Managing Intelligence which ones aren't.

## Steps

1. **Create or reuse the worktrees,** one per repo, with the branch and worktree named after the Idea's or Bug's ID at the paths `~/.apiary/system/workflow.md` defines, so every ticket's worktrees are named the same way and anyone can tell whose work it is. Branch from each main checkout's current branch, and reuse any worktree the Idea or Bug already has. If something already in the way isn't the ticket's, stop for the Managing Intelligence.
2. **Record them** on the Idea's Plan or the Bug.

## Child Agents

None: you prepare the worktrees yourself.

## Writes

- **The Idea's Plan or the Bug:** under `## Worktrees`, each repo's main checkout, worktree path, branch and base branch, so later skills can find the work and teardown-worktree knows where to merge it.
- **Repos:** the ticket's branches and worktrees.

## Done

Report the ticket's ID and worktree paths, and suggest the skill that needs them next: write-epic for a new Plan's first `draft` Epic, develop-epic or fix-bug if one sent you here.
