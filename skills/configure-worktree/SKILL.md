---
name: configure-worktree
description: "Create or reuse a branch and worktree for an Idea in every repo it changes, and record them on the Idea's Plan, or give an Epic built alongside another its own. Takes an Idea or Epic ID."
---

# configure-worktree

## Purpose

You give an Idea its own branch and worktree in every repo it changes, so its work stays off the base branch until the Managing Intelligence accepts it. You give an Epic its own when its develop-epic Run would otherwise share the Idea's worktrees with another Run.

## Loading SDLC

Read `~/.sdlc/install/workflow.md` first for shared rules, settings and file locations.

## Input

An Idea or Epic ID, and any repos the caller names.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** your Agent Protocol File (`protocol:agent-claude-code.md`, `protocol:agent-codex.md` or `protocol:agent-cursor.md`) and `protocol:ticket.md`, for operations.
- **The Idea, its Plan (found by the Plan's Association) and Epics:** for the repos the work changes, from the Epics' `## Work`, and any earlier worktree record.

## Gate

Run only when the Idea and its Plan are `defined` or `active`, and for an Epic, when the Plan's `## Worktrees` names the Idea's worktrees, because the Epic's branches start from them. Otherwise, stop and report which isn't.

## Steps

1. **Create or reuse the worktrees and record them** on the Idea's Plan, or record `none` when the Idea changes no repo, as `~/.sdlc/install/workflow.md`'s Worktrees rule says. For an Epic, record them on the Epic, only for the repos it changes.

## Child Agents

None: you prepare the worktrees yourself.

## Writes

- **The Idea's Plan or the Epic:** its `## Worktrees` record.
- **Repos:** the Idea's or Epic's branches and worktrees.

## Retrospective notes

While you work, note under `## Retrospective notes` on your ticket, with evidence, your answers to these questions, because the Managing Intelligence builds the Idea's or Bug's retrospective from them:

- Where did we introduce a quality issue? How could it have been avoided?
- Where did we spend too much time and not gain value? How could it have been avoided?
- Where did we spend too many tokens and not gain value? How could it have been avoided?

## Done

Report the Idea's or Epic's ID and worktree paths, or `none`, and suggest the skill that needs them next: write-epic for a new Plan's first `draft` Epic, or develop-epic for an Epic or if it sent you here.
