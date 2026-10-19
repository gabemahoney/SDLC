---
name: write-idea
description: "File a new Idea from a description of the work, following the Project's `setting:new_idea_intake`."
---

# write-idea

## Purpose

You file a new Idea as the first step of the Idea flow.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

A description of the work: either freeform, or in the form `setting:new_idea_intake` asks for.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md` and the Ticket System Protocol File selected by `setting:ticket_system`, for operations.
- **Intake:** the instructions `setting:new_idea_intake` names, for what input it takes and how to prepare the Idea.

## Gate

None: you create a new ticket.

## Steps

1. **Take in the work.** If the input is what the intake takes, follow the intake's instructions. Otherwise, use the freeform description. If you still can't tell what the work is, ask the Managing Intelligence.
2. **File the Idea** as Writes describes.

## Child Agents

None: you file the Idea yourself.

## Writes

A new Idea in the Ideas store, status `draft`, with `## Description` holding the account of the work from the intake or the freeform description. Keep the link or path the description came from as a Source Reference, through `protocol:ticket.md ## Add a Source Reference`, so write-prd can read the original.

## Done

Report the Idea's ID and anything left unresolved with reasons. Suggest write-prd.
