---
name: write-bug
description: File a new Bug from a report or intake input such as an issue URL, following the Project's `setting:new_bug_intake`.
---

# write-bug

## Purpose

You record a new defect report as a Bug for define-bug to complete and validate.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

A defect report: either freeform, or in the form `setting:new_bug_intake` asks for.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md` and the Ticket System Protocol File selected by `setting:ticket_system`, for operations.
- **Intake:** the instructions `setting:new_bug_intake` names, for what input it takes and how to prepare the Bug.
- **Guidance:** `guide:bug-writing-guide.md`, for the report format.

## Gate

None: you create a new ticket.

## Steps

1. **Take in the report.** If the input is what the intake takes, follow the intake's instructions. Otherwise, use the freeform report as given. If you still can't tell what goes wrong, ask the Managing Intelligence.
2. **File the Bug** as Writes describes, keeping the reporter's symptom and reproduction, so define-bug investigates the failure they reported.

## Child Agents

None: you file the Bug yourself.

## Writes

A new Bug in the Bugs store, status `draft`, with `## Report` arranged as `guide:bug-writing-guide.md` says. Keep any link or path the input points to as a Source Reference, through `protocol:ticket.md ## Add a Source Reference`, so define-bug can read the original.

## Done

Report the Bug's ID and anything left unresolved with reasons. Suggest define-bug.
