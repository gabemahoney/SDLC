---
name: write-bug
description: "File a new Bug from a report or intake input such as an issue URL, following the Project's new_bug_intake setting."
---

# write-bug

## Purpose

Records a new defect report as a Bug for define-bug to complete and validate.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

A defect report or intake input such as an issue URL, because this skill creates the Bug ticket.

## Required Reading

- **Settings:** Project and default settings, resolved as `workflow.md` describes, for this Run's configuration.
- **Intake instructions:** `~/.apiary/system/intakes/interview.md` for the interview intake, or `~/.apiary/system/resolvers/<resolver>.md` for the Source Reference resolver named by `new_bug_intake`. Why: to check the input and prepare the Bug according to that intake.
- **Agent Protocol File:** `agent-claude-code.md` or `agent-codex.md` under `~/.apiary/system/protocols/`, for the Main Agent's own context readings and skill invocation.
- **Ticket System Protocol File:** selected by `ticket_system` as `workflow.md` describes, to create the Bug and store its body and any Source Reference.
- **Bug writing guidance:** `bug-writing-guide.md`, found as `workflow.md` describes, to write the supplied report in the Project's format.

## Gate

Run only when all of these are true:

- The request is to file a new Bug. For an existing Bug, stop and report its ID; suggest define-bug if it is `draft`, because that skill owns completing and validating the report.
- The input fits `new_bug_intake`. If it doesn't, stop and ask the Managing Intelligence for the required input.

## Steps

1. **Prepare the report.** Follow the selected intake and `bug-writing-guide.md`, using the supplied information. With interview intake, the Managing Intelligence supplies the initial report and decides what to add.

2. **File the Bug** as described under Writes.

## Child Agents

None: write-bug files the Bug itself.

## Writes

A new Bug in the Bugs store, with the supplied report in its body and status `draft`, because define-bug still needs to complete and validate it. If the intake names a Resolver, save the input as a Source Reference so define-bug can read the original report.

## Done

Report the Bug's ID. Next step: define-bug.

## Writing guidance

Preserve the reporter's exact symptom and any supplied reproduction, including inputs, setup and expected and actual behaviour, so define-bug investigates the reported failure.
