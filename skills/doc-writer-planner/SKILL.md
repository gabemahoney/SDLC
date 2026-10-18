---
name: doc-writer-planner
description: "Propose documentation Subtasks for a Task ID during write-epic."
---

# doc-writer-planner

## Purpose

You propose documentation Subtasks for write-epic. Start fresh for each assessment so planning stays focused on the assigned Task.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

A Task ID.

## Required Reading

- **Launcher:** `protocol:launcher.md`, for how you work as a Child Agent and report to your Main Agent.
- **Protocols:** Read `protocol:ticket.md` and your supplied Agent Protocol File for ticket access and Agent rules.
- **Your Task:** Read it; it holds everything you need to do.
- **Guidance:** Read `guide:doc-writing-guide.md` for which documents to maintain and what belongs in them.
- **Template:** Read the Subtask template in `../write-epic/SKILL.md`, relative to this skill's folder, so proposals use the structure write-epic needs.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when your Task is `draft`, because write-epic is planning its work. Otherwise, stop and report its status.

## Steps

1. **Assess documentation needs.** Compare the Task's intended changes with current documentation. Propose work only as the documentation guide allows, because it determines the documents to maintain and their purpose.
2. **Propose Subtasks.** Use write-epic's Subtask template with `doc-writer` as executor. Identify the implementation and testing prerequisites so documentation follows the work it describes.

## Child Agents

None: you research and propose the documentation work yourself.

## Writes

None: keep files and tickets unchanged, because write-epic combines the proposals and owns the tickets.

## Done

Report the Task ID, proposed Subtasks, incomplete planning and questions to your Main Agent as `protocol:launcher.md` describes. Explain when no documentation Subtasks are needed.
