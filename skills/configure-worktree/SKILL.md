---
name: configure-worktree
description: "Create or reuse a branch and worktree for an Idea in every repo it changes, and record them on the Idea's Plan. Takes an Idea ID."
---

# configure-worktree

## Purpose

You give an Idea its own branch and worktree in every repo it changes, so its work stays off the base branch until the Managing Intelligence accepts it.

## Loading SDLC

Read `~/.sdlc/install/workflow.md` first for shared rules, settings and file locations.

## Input

An Idea ID, and any repos the caller names.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** your Agent Protocol File (`protocol:agent-claude-code.md`, `protocol:agent-codex.md` or `protocol:agent-cursor.md`) and `protocol:ticket.md`, for operations.
- **The Idea, its Plan (found by the Plan's Association) and Epics:** for the repos the work changes, from the Epics' `## Work`, and any earlier worktree record.

## Gate

Run only when all of these are true:

- The Idea and its Plan are `defined` or `active`. Otherwise, stop and report which isn't.
- Each main checkout that needs a new branch is clean, because the branch would leave uncommitted changes out. Otherwise, stop and tell the Managing Intelligence which ones aren't.

## Steps

1. **Create or reuse the worktrees,** one per repo, with the branch and worktree named after the Idea's ID at the paths `~/.sdlc/install/workflow.md` defines, so every ticket's worktrees are named the same way and anyone can tell whose work it is. Branch from each main checkout's current branch, and reuse any worktree the Idea already has. If something already in the way isn't the Idea's, stop for the Managing Intelligence.
2. **Record them** on the Idea's Plan.

## Child Agents

None: you prepare the worktrees yourself.

## Writes

- **The Idea's Plan:** under `## Worktrees`, each repo's main checkout, worktree path, branch and base branch, so later skills can find the work and teardown-worktree knows where to merge it.
- **Repos:** the Idea's branches and worktrees.

## Retrospective notes

While you work, note under `## Retrospective notes` on your ticket, with evidence, your answers to these questions, because the Managing Intelligence builds the bee's retrospective from them:

- Where did we introduce a quality issue? How could it have been avoided?
- Where did we spend too much time and not gain value? How could it have been avoided?
- Where did we spend too many tokens and not gain value? How could it have been avoided?

## Done

Report the Idea's ID and worktree paths, and suggest the skill that needs them next: write-epic for a new Plan's first `draft` Epic, or develop-epic if it sent you here.
