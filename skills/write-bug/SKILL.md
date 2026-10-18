---
name: write-bug
description: "File a new Bug from a report or intake input such as an issue URL, following the Project's `setting:new_bug_intake`."
---

# write-bug

## Purpose

You record a new defect report as a Bug for define-bug to complete and validate.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

A defect report or intake input such as an issue URL, because you create the Bug ticket.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md` and the Ticket System Protocol File selected by `setting:ticket_system`, for operations.
- **Intake:** interview instructions or the Source Reference Resolver named by `setting:new_bug_intake`, for input requirements and Bug preparation.
- **Guidance:** `guide:bug-writing-guide.md`, for the report format.

## Gate

Run only when all of these are true:

- The request is to file a new Bug. For an existing Bug, stop and report its ID; suggest define-bug if it is `draft`, because that skill owns completing and validating the report.
- The input fits `setting:new_bug_intake`. If it doesn't, stop and ask the Managing Intelligence for the required input.

## Steps

1. **Prepare the report.** Follow the selected intake and `guide:bug-writing-guide.md`, using the supplied information. With interview intake, the Managing Intelligence supplies the initial report and decides what to add.

2. **File the Bug** as described under Writes.

## Child Agents

None: you file the Bug yourself.

## Writes

A new Bug in the Bugs store, with the supplied report in its body and status `draft`, because define-bug still needs to complete and validate it. If the intake names a Resolver, save the input as a Source Reference so define-bug can read the original report.

## Done

Report the Bug's ID. Next step: define-bug.

## Writing guidance

Preserve the reporter's exact symptom and any supplied reproduction, including inputs, setup and expected and actual behaviour, so define-bug investigates the reported failure.
