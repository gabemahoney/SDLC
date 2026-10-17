---
name: write-bug
description: "File a new Bug from a report or intake input such as an issue URL, following the Project's new_bug_intake setting."
---

# write-bug

## Purpose

Files a new Bug in `draft`. It is the first step of the Bug flow; define-bug comes next.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

A report of a defect, or intake input such as an issue URL.

## Required Reading

- **Settings files:** `<Project Folder>/.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`. Why: to select the intake through `new_bug_intake` and the Ticket System Protocol File through `ticket_system`.
- **Intake instructions:** `~/.apiary/system/intakes/interview.md` for the interview intake, or `~/.apiary/system/resolvers/<resolver>.md` for the Source Reference resolver named by `new_bug_intake`. Why: to check the input and prepare the Bug according to that intake.
- **Your Agent's Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` in Claude Code, or `~/.apiary/system/protocols/agent-codex.md` in Codex CLI. Why: to ask the Managing Intelligence questions and report through this Agent.
- **The Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: to create the Bug and store its body and any Source Reference.
- **Bug writing guidance:** `bug-writing-guide.md`, found as `workflow.md` describes. Why: to write the supplied report in the Project's format.

## Gate

None: write-bug creates a new ticket.

## Steps

1. **Check the input.** Follow the intake named by `new_bug_intake`.
   - If the input doesn't fit, stop and ask the Managing Intelligence for what's needed.
2. **Prepare the Bug.**
   - If the intake names a Source Reference resolver, store the input as the Bug's Source Reference.

   Follow the intake's instructions for the Bug's body and `bug-writing-guide.md`, using what the input supplies. Preserve the reporter's exact symptom and any supplied reproduction. define-bug fills out the report from its Source References and validates it.
3. **File the Bug.** Create it in the Bugs store with status `draft`.

## Dispatches

None: write-bug files the Bug itself.

## Writes

- A new Bug in the Bugs store, status `draft`.

## Done

Print the Bug's ID. Next step: "define-bug".
