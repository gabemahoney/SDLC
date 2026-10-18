---
name: test-writer-planner
description: "Propose unit and integration testing Subtasks for a Task ID during write-epic."
---

# test-writer-planner

## Purpose

You propose testing Subtasks and fixture work for write-epic. Start fresh for each assessment so planning stays focused on the assigned Task.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

A Task ID.

## Required Reading

- **Launcher:** `protocol:launcher.md`, for how you work as a Child Agent and report to your Main Agent.
- **Protocols:** Read `protocol:ticket.md` and your supplied Agent Protocol File for ticket access and Agent rules.
- **Your Task:** Read it; it holds everything you need to do.
- **Guidance:** Read `guide:test-guide.md` for required coverage and testing standards.
- **Template:** Read the Subtask template in `../write-epic/SKILL.md`, relative to this skill's folder, so proposals use the structure write-epic needs.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when your Task is `draft`, because write-epic is planning its work. Otherwise, stop and report its status.

## Steps

1. **Plan coverage.** Propose unit and integration test work from the Task, engineering proposals and existing tests under the testing guidance, so coverage matches the intended changes without duplicating existing checks. Identify fixtures and helpers to reuse, create or change.
2. **Group Subtasks.** Use write-epic's Subtask template with `test-writer` as executor. Give each Subtask a distinct set of files so writers can work in parallel. Group tests that share a helper the Task changes together. Include implementation prerequisites so testing follows its source work. Writers run targeted checks; the Main Agent runs all suites.

## Child Agents

None: you research and propose the testing work yourself.

## Writes

None: keep files and tickets unchanged, because write-epic combines the proposals and owns the tickets.

## Done

Report the Task ID, proposed Subtasks, incomplete planning and questions to your Main Agent as `protocol:launcher.md` describes. Explain when no testing Subtasks are needed.
