---
name: configure-worktree
description: "Create or reuse a branch and worktree for an Idea or Bug in every repo it changes, and record them on the Idea's Plan or the Bug. Takes an Idea, Epic or Bug ID."
---

# configure-worktree

## Purpose

You give an Idea or Bug its own branch and worktree in every repo it changes, so its work stays off the base branch until the Managing Intelligence accepts it.

## Loading SDLC

Read `~/.sdlc/install/workflow.md` first for shared rules, settings and file locations.

## Input

An Idea or Bug ID, and any repos the caller names. Given an Epic ID instead, give that Epic its own worktrees, as `~/.sdlc/install/workflow.md`'s Flows say.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** your Agent Protocol File (`protocol:agent-claude-code.md`, `protocol:agent-codex.md` or `protocol:agent-cursor.md`) and `protocol:ticket.md`, for operations.
- **The Idea, its Plan (found by the Plan's Association) and Epics:** for the repos the work changes, from the Epics' `## Work`, and any earlier worktree record.
- **Or the Bug:** its `## Reproduction`, for the repos the fix is likely to change, and any earlier `## Worktrees` record.

## Gate

Run only when the Idea and its Plan, or the Bug, are `defined` or `active`, or an Epic input is unpaused during an SRD revision, because only work ready to build needs a branch. Otherwise, stop and report which isn't.

## Steps

1. **Create or reuse the worktrees and record them** on the Idea's Plan or the Bug, or record `none` when the work changes no repo, as `~/.sdlc/install/workflow.md`'s Worktrees rule says.

## Child Agents

None: you prepare the worktrees yourself.

## Writes

- **The Idea's Plan or the Bug:** its `## Worktrees` record.
- **Repos:** the Idea's or Bug's branches and worktrees.

## Retrospective notes

While you work, note under `## Retrospective notes` on your ticket, with evidence, your answers to these questions, because the Managing Intelligence builds the Idea's or Bug's retrospective from them:

- Where did we introduce a quality issue? How could it have been avoided?
- Where did we take too long and not gain value? How could it have been avoided?

## Done

Report the Idea's or Bug's ID and worktree paths, or `none`, and suggest the skill that needs them next: write-epic for a new Plan's first `draft` Epic, develop-epic if it sent you here, or fix-bug for a Bug.

End with Tool feedback, as `~/.sdlc/install/workflow.md` says.
