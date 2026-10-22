---
name: write-idea
description: "File a new Idea from what the Managing Intelligence gives you: plain text describing the work, or input for the Project's `setting:new_idea_intake`."
---

# write-idea

## Purpose

You file a new Idea as the first step of the Idea flow.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

Whatever the Managing Intelligence gives you about the work: either plain text describing it, or input of the kind `setting:new_idea_intake` takes, such as a link.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** your Agent Protocol File (`protocol:agent-claude-code.md`, `protocol:agent-codex.md` or `protocol:agent-cursor.md`) and the Ticket System Protocol File selected by `setting:ticket_system`, for operations.
- **Intake:** the instructions `setting:new_idea_intake` names, for what input it takes and how to prepare the Idea.

## Gate

None: you create a new ticket.

## Steps

1. **Take in the work.** If the input is the kind the intake takes, follow the intake's instructions. Otherwise, work out the Idea with the Managing Intelligence however you judge best.
2. **File the Idea** as Writes describes.

## Child Agents

None: you file the Idea yourself.

## Writes

A new Idea in the Ideas store, status `draft`, with `## Description` saying what the work is. Keep the link or path the input came from as a Source Reference, through `protocol:ticket.md`, so write-prd can read the original.

## Done

Report the Idea's ID. Suggest write-prd.
