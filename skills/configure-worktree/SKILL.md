---
name: configure-worktree
description: "Create or reuse a branch and worktree for an Idea in every repo it changes, and record them on the Idea's Plan. Takes an Idea or Epic ID."
---

# configure-worktree

## Purpose

You give an Idea its own branch and worktree in every repo it changes, so its work stays off the base branch until the Managing Intelligence accepts it.

## Loading SDLC

Read `~/.sdlc/install/workflow.md` first for shared rules, settings and file locations.

## Input

An Idea ID, and any repos the caller names. Given an Epic ID instead, give that Epic its own worktrees, as `~/.sdlc/install/workflow.md`'s Flows say.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** your Agent Protocol File (`protocol:agent-claude-code.md`, `protocol:agent-codex.md` or `protocol:agent-cursor.md`) and `protocol:ticket.md`, for operations.
- **The Idea, its Plan (found by the Plan's Association) and Epics:** for the repos the work changes, from the Epics' `## Work`, and any earlier worktree record.

## Gate

Run only when the Idea and its Plan are `defined` or `active`, or an Epic input is unpaused during an SRD revision. Otherwise, stop and report which isn't.

## Steps

1. **Create or reuse the worktrees and record them** on the Idea's Plan, or record `none` when the Idea changes no repo, as `~/.sdlc/install/workflow.md`'s Worktrees rule says.

## Child Agents

None: you prepare the worktrees yourself.

## Writes

- **The Idea's Plan:** its `## Worktrees` record.
- **Repos:** the Idea's branches and worktrees.

## Retrospective notes

While you work, note under `## Retrospective notes` on your ticket, with evidence, your answers to these questions, because the Managing Intelligence builds the Idea's or Bug's retrospective from them:

- Where did we introduce a quality issue? How could it have been avoided?
- Where did we take too long and not gain value? How could it have been avoided?

## Done

Report the Idea's ID and worktree paths, or `none`, and suggest the skill that needs them next: write-epic for a new Plan's first `draft` Epic, or develop-epic if it sent you here.
