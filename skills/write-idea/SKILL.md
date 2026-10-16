---
name: write-idea
description: "File a new Idea from a description of the work or intake input such as an issue URL, following the Project's new_idea_intake setting."
---

# write-idea

## Purpose

Files a new Idea in `draft`. It is the first step of the Idea flow; write-prd comes next.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

A description of the work, or intake input such as an issue URL.

## Reads

- **Settings files:** `<Project Folder>/.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`. Why: to select the intake and the Ticket System Protocol File.
- **Intake instructions:** `~/.apiary/system/intakes/interview.md` for the interview intake, or `~/.apiary/system/resolvers/<resolver>.md` for the Source Reference resolver named by `new_idea_intake`. Why: to check the input and prepare the Idea according to that intake.
- **Your Agent's Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` in Claude Code, or `~/.apiary/system/protocols/agent-codex.md` in Codex CLI. Why: to ask the Managing Intelligence questions and report through this Agent.
- **The Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: to create the Idea and store its body and any Source Reference.

## Gate

None: write-idea creates a new ticket.

## Steps

1. **Check the input.** Follow the intake named by `new_idea_intake`.
   - If the input doesn't fit, stop and ask the Managing Intelligence for what's needed.
2. **Prepare the Idea.**
   - If the intake names a Source Reference resolver, store the input as the Idea's Source Reference.

   Follow the intake's instructions for the Idea's body.
3. **File the Idea.** Create it in the Ideas store with status `draft`.

## Dispatches

None: write-idea files the Idea itself.

## Writes

- A new Idea in the Ideas store, status `draft`.

## Done

Print the Idea's ID. Next step: "write-prd".
