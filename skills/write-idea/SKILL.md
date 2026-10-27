---
name: write-idea
description: "File or revise an Idea from what the Managing Intelligence gives you: plain text describing the work, or input for the Project's `setting:new_idea_intake`."
---

# write-idea

## Purpose

You file an Idea as the first step of the Idea flow, and revise it.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

Plain text describing the work, or input of the kind `setting:new_idea_intake` takes, such as a link. To revise, also the Idea's ID.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** your Agent Protocol File (`protocol:agent-claude-code.md`, `protocol:agent-codex.md` or `protocol:agent-cursor.md`) and the Ticket System Protocol File selected by `setting:ticket_system`, for operations.
- **Intake:** the instructions `setting:new_idea_intake` names, for what input it takes and how to prepare the Idea.
- **Research guide:** `guide:research-guide.md`, for where the Project's research lives.

## Gate

None: you create or revise an Idea.

## Steps

1. **Take in the work.** Follow the intake's instructions for input it takes; otherwise, work out the Idea or change with the Managing Intelligence.
2. **File or revise the Idea** as Writes describes.
3. **Check it** against Idea body, so drift is fixed before approval.

## Child Agents

None: you file the Idea yourself.

## Writes

A new `draft` Idea in the Ideas store, with `## Description` saying what the work is. Keep the link or path the input came from as a Source Reference, through `protocol:ticket.md`, so write-prd can read the original.

Revise in place, so the body shows only the current direction, and link its history under `## Artifacts`, so it survives.

## Done

Report the Idea's ID. Suggest write-prd.

## Idea body

An Idea holds the direction the User and the Managing Intelligence agreed, at product level, without the decisions or rejected options behind it, so it can be approved and built on:

- What the work is and why, and what the User requires, specific enough that write-prd isn't guessing what was meant.
- Associations, each saying why it is linked, so the link can be defended.
- Under `## Artifacts`, completed Research Reports, research the Project keeps elsewhere (`guide:research-guide.md`), reviews and other input, each linked with a line on what it covers, so later skills start from that evidence.

Leave out:

- Anything write-prd or write-srd settles, because they own it.
- Restated engineering principles, because the Guidance Documents carry them.
- Status notes, chat links and timestamps, because they go stale.

Merge sections covering one concept, so it has one account.
