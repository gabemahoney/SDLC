---
name: doc-writer-planner
description: "Write documentation Subtasks for a Task ID during write-epic."
---

# doc-writer-planner

## Purpose

You write documentation Subtasks for write-epic.

## Loading SDLC

You are running an SDLC software development workflow. Before anything else, read `~/.sdlc/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.sdlc/system/workflow.md` before going on.

## Input

A Task ID.

## Required Reading

- **Launcher:** `protocol:launcher.md`, for how you work as a Child Agent and report to your Main Agent.
- **Protocols:** Read `protocol:ticket.md` and your supplied Agent Protocol File for ticket access and Agent rules.
- **Your Task:** Read it; it holds everything you need to do.
- **Guidance:** Read `guide:doc-writing-guide.md` for which documents to maintain and what belongs in them.

Also read the Project's existing docs, and the code where the docs must describe it, as the work needs.

## Gate

Run only when your Task is `draft`, because write-epic is planning its work. Otherwise, stop and report its status.

## Steps

1. **Plan documentation.** Following `guide:doc-writing-guide.md`, answer for the Task's changes:
   - Are any new docs needed?
   - Which docs need updating, and which sections?
   - Which docs need trimming, and which sections?
   - Do any docs need deleting?
2. **Write Subtasks.** Create or revise your Subtasks as `draft` children of the Task using the template below. Identify implementation and testing prerequisites so documentation follows the work it describes.
3. **Make edits.** When your Main Agent sends edits, apply them to your Subtasks.

## Child Agents

None: you plan and write the documentation Subtasks yourself.

## Writes

Your Subtask tickets, `draft` only.

## Done

Report the Subtask IDs, incomplete planning and questions to your Main Agent as `protocol:launcher.md` describes. Explain when no documentation Subtasks are needed.

## Subtask template

Every Subtask has these sections, with detail in proportion to the work:

- `## Executor`: `doc-writer`, so develop-epic knows which Child Agent works it.
- `## Context`: explain why the Subtask exists and which code or test work it describes.
- `## Guide exceptions` (only when one applies): quote the matching entries from the Task, so execution preserves approved departures from the guides.
- `## Work`: say which docs to add, change or remove, and why.
- `## Key files`: give concrete paths relative to a named repo's root, or a named code folder under `<Project Folder>` when there is no repo. Identify files to create as new.
- `## Acceptance criteria`: state checkable conditions, for example: the README's setup steps match the new install command, and the old section on manual setup is gone.
