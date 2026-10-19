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
- **Intake:** interview instructions or the Source Reference Resolver named by `setting:new_bug_intake`, for input requirements and Bug preparation.
- **Guidance:** `guide:bug-writing-guide.md`, for the report format.

## Gate

Run only when all of these are true:

- The request is to file a new Bug. For an existing Bug, stop and report its ID; suggest define-bug if it is `draft`, because that skill owns completing and validating the report.
- The report says what goes wrong, whether freeform or through `setting:new_bug_intake`. Otherwise, stop and ask the Managing Intelligence for it.

## Steps

1. **File the report.** Use `setting:new_bug_intake` when the input is in its form; otherwise take the freeform report as given. Create the Bug as described below. Preserve the reporter's symptom and supplied reproduction, including inputs, setup and expected and actual behaviour, so define-bug investigates the reported failure.

## Child Agents

None: you file the Bug yourself.

## Writes

A new Bug in the Bugs store, with `## Report` structured by `guide:bug-writing-guide.md`. Set it `draft`, because define-bug completes and validates it. If the intake names a Resolver, keep its input as a Source Reference so define-bug can read the original report.

## Done

Report the Bug's ID and anything left unresolved with reasons. Suggest define-bug.
