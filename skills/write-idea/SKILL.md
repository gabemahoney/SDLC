---
name: write-idea
description: "File or revise an Idea from what the Managing Intelligence gives you: plain text describing the work, or input for the Project's `setting:new_idea_intake`."
---

# write-idea

## Purpose

You file an Idea as the first step of the Idea flow, and revise it as its intent changes.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

Plain text describing the work, or input of the kind `setting:new_idea_intake` takes, such as a link. To revise, also the Idea's ID.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** your Agent Protocol File (`protocol:agent-claude-code.md`, `protocol:agent-codex.md` or `protocol:agent-cursor.md`) and the Ticket System Protocol File selected by `setting:ticket_system`, for operations.
- **Intake:** the instructions `setting:new_idea_intake` names, for what input it takes and how to prepare the Idea.
- **Research guide:** `guide:research-guide.md`, for where research is published.

## Gate

None: you create or revise an Idea.

## Steps

1. **Take in the work.** Follow the intake's instructions for input it takes; otherwise, work out the Idea or change with the Managing Intelligence as you judge best.
2. **File or revise the Idea** as Writes describes.
3. **Check it** against Idea body, so drift is fixed before approval.

## Child Agents

None: you file the Idea yourself.

## Writes

A new `draft` Idea in the Ideas store, with `## Description` saying what the work is, as Idea body describes. Keep the link or path the input came from as a Source Reference, through `protocol:ticket.md`, so write-prd can read the original.

Revise in place, so the body stays the final state, and attach how it got there under `## Artifacts`, so history stays out of the body.

## Done

Report the Idea's ID. Suggest write-prd.

## Idea body

An Idea holds the final intended state at product level, so it can be approved and built on:

- What the work is and why, and what the User requires, as direction rather than design, but specific enough that write-prd isn't guessing what was meant.
- Associations, each saying why it is linked, so the link can be defended.
- Under `## Artifacts`, each completed Research Report and published research page `guide:research-guide.md` names, with a line on what it covers, so write-prd and write-srd start from that evidence; reviews and other input go there too, linked rather than pasted, so the body stays the intent.

Leave out:

- Anything write-prd or write-srd settles, such as term definitions, mechanics and research, because those documents own it.
- Restated engineering principles, because the Guidance Documents carry them.
- Decision history, status notes, and chat links or timestamps, because they go stale.

Merge sections covering one concept, so it has one account.
