---
name: write-idea
description: "File a new Idea, or revise an existing one, from what the Managing Intelligence gives you: plain text describing the work, or input for the Project's `setting:new_idea_intake`."
---

# write-idea

## Purpose

You file a new Idea as the first step of the Idea flow, and revise it when its intent changes.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

Whatever the Managing Intelligence gives you about the work: either plain text describing it, or input of the kind `setting:new_idea_intake` takes, such as a link. To revise, also the Idea's ID.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** your Agent Protocol File (`protocol:agent-claude-code.md`, `protocol:agent-codex.md` or `protocol:agent-cursor.md`) and the Ticket System Protocol File selected by `setting:ticket_system`, for operations.
- **Intake:** the instructions `setting:new_idea_intake` names, for what input it takes and how to prepare the Idea.
- **Research guide:** `guide:research-guide.md`, for where the Project's research is published.
- **Idea:** when revising, its body and attached files, for its current intent.

## Gate

None: you create a new ticket or revise an Idea the Managing Intelligence names.

## Steps

1. **Take in the work.** If the input is the kind the intake takes, follow the intake's instructions. Otherwise, work out the Idea or the change with the Managing Intelligence however you judge best.
2. **File or revise the Idea** as Writes describes.
3. **Check the Idea** against Idea body below, because drift is cheapest to fix before the Managing Intelligence reviews it.

## Child Agents

None: you file the Idea yourself.

## Writes

A new Idea in the Ideas store, status `draft`, holding the Idea body below, with `## Description` saying what the work is. Keep the link or path the input came from as a Source Reference, through `protocol:ticket.md`, so write-prd can read the original.

To revise, rewrite the affected part in place so the body stays the final intended state. Attach a record of how the Idea got there, through `protocol:ticket.md`, and link it under `## Artifacts`, so the history survives outside the intent.

## Done

Report the Idea's ID. Suggest write-prd.

## Idea body

An Idea holds the final intended state at product level, so the Managing Intelligence can approve it and write-prd can build on it:

- What the work is and why, and what the User requires, as concrete outcomes rather than vague ones, so write-prd doesn't have to guess what was meant.
- What it relates to, as Associations that each say why they are linked, so each link can be defended.
- The research done for it, listed under `## Artifacts`: each completed Research Report and each published research page `guide:research-guide.md` names, with a one-line note on what each covers, so write-prd and write-srd start from that evidence. Attach and link reviews and other input there too rather than pasting them, so the body stays the intent.

Leave out:

- Mechanics and term definitions, because the PRD and SRD settle them.
- Research plans, because write-srd runs research.
- Restated engineering principles, because the Guidance Documents carry them.
- Decision history, status notes, pasted reviews, and chat links or timestamps, because they go stale.

Merge sections that cover the same thing, so each concept has one account.
