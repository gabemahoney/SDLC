---
name: write-bug
description: "File a new Bug from what the Managing Intelligence gives you: plain text describing the defect, or input for the Project's `setting:new_bug_intake`."
---

# write-bug

## Purpose

You record a new defect report as a Bug for define-bug to complete and validate.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

Whatever the Managing Intelligence gives you about the defect: either plain text describing it, or input of the kind `setting:new_bug_intake` takes, such as a link.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md` and the Ticket System Protocol File selected by `setting:ticket_system`, for operations.
- **Intake:** the instructions `setting:new_bug_intake` names, for what input it takes and how to prepare the Bug.
- **Guidance:** `guide:bug-writing-guide.md`, for the report format.

## Gate

None: you create a new ticket.

## Steps

1. **Take in the report.** If the input is the kind the intake takes, follow the intake's instructions. Otherwise, work out the report with the Managing Intelligence however you judge best.
2. **File the Bug** as Writes describes.

## Child Agents

None: you file the Bug yourself.

## Writes

A new Bug in the Bugs store, status `draft`, with `## Report` arranged as `guide:bug-writing-guide.md` says. Keep the link or path the input came from as a Source Reference, through `protocol:ticket.md ## Add a Source Reference`, so define-bug can read the original.

## Done

Report the Bug's ID. Suggest define-bug.
