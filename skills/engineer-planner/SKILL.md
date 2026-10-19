---
name: engineer-planner
description: "Write implementation Subtasks for a Task ID during write-epic."
---

# engineer-planner

## Purpose

You write source implementation Subtasks for write-epic.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

A Task ID.

## Required Reading

- **Launcher:** `protocol:launcher.md`, for how you work as a Child Agent and report to your Main Agent.
- **Protocols:** Read `protocol:ticket.md` and your supplied Agent Protocol File for ticket access and Agent rules.
- **Your Task:** Read it; it holds everything you need to do.
- **Guidance:** Read `guide:engineering-best-practices.md` for implementation constraints.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when your Task is `draft`, because write-epic is planning its work. Otherwise, stop and report its status.

## Steps

1. **Plan the implementation.** Ground the source changes in the Task, its requirements and current code. Follow the SRD so execution stays within the agreed design.
2. **Ask before choosing.** When the SRD leaves open a design choice the Subtasks must commit to, ask your Main Agent, because design choices belong to the Managing Intelligence.
3. **Write Subtasks.** Create or revise your Subtasks as `draft` children of the Task using the template below. Identify prerequisites so write-epic can order the work. Also report any rule this Task sets up that later Tasks must follow, such as an ordering, a shared resource or an invariant, so your Main Agent can add it to those Tasks.
4. **Make edits.** When your Main Agent sends edits, apply them to your Subtasks.

## Child Agents

None: you plan and write the implementation Subtasks yourself.

## Writes

Your Subtask tickets, `draft` only.

## Done

Report the Subtask IDs, incomplete planning and questions to your Main Agent as `protocol:launcher.md` describes. Flag product questions or conflicts with the SRD for the Managing Intelligence, because they own those decisions. Explain when no implementation Subtasks are needed.

## Subtask template

Every Subtask has these sections, with detail in proportion to the work:

- `## Executor`: `engineer`, so develop-epic knows which Child Agent works it.
- `## Context`: explain why the Subtask exists and what preconditions it assumes. For code, name what depends on the code it changes and what that code depends on, so the executor sees what a change could break.
- `## Work`: describe the work and requirements for that executor's part of the Task.
- `## Key files`: give concrete paths relative to a named repo's root, or a named code folder under `<Project Folder>` when there is no repo. Identify files to create as new.
- `## Acceptance criteria`: state observable, testable conditions for completion. For example, a CSV export's fields are correctly quoted and its existing JSON export still works.
