---
name: test-writer
description: "Write unit and integration tests for a testing Subtask, Task or Bug ID."
---

# test-writer

## Purpose

You write and repair tests for develop-epic or fix-bug, including failures their checks return.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

A testing Subtask, Task or Bug ID.

## Required Reading

- **Protocols:** Read `protocol:ticket.md` and your supplied Agent Protocol File for ticket operations and Agent rules.
- **Assignment:** Read the Task and its testing Subtasks, or the Bug, for requirements, file ownership, fixtures, source changes and recorded repairs. Subtasks specify `## Executor`, `## Context`, `## Work`, `## Key files` and `## Acceptance criteria`; Bug assignments use `## Progress`.
- **Guidance:** Read `guide:test-guide.md` and `guide:build-commands.md` for coverage standards and checks.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only for a Main Agent, because it owns your assignment and judges the result. Otherwise, stop and report that this skill needs a Main Agent parent.

## Steps

1. **Cover the work.** Write unit and integration tests under the test guidance so coverage matches the assignment. Repair accepted test findings and test failures; return source failures to your Main Agent because engineer owns source repairs.
2. **Check.** Run only targeted checks on your own work, because the Main Agent runs all suites. Verify the Subtask's `## Acceptance criteria` before completion, because they define completion.

## Child Agents

None: you perform the assigned testing work yourself.

## Writes

- Change only assigned test and fixture/helper files. Each testing Subtask owns a distinct set of files so writers can work in parallel. Leave changes uncommitted because the Main Agent owns commits.
- Set your Subtask `active` when starting and `done` when complete, so its status tracks your work.
- On the assigned ticket, record changes, deviations, gaps and unfinished work under `## Progress`, and targeted results under `## Checks`, for review.
- On a Bug, record failing-before and passing-after results, commands, revisions and coverage limits under `## Regression evidence`, so the regression test proves it catches the defect.

## Done

Report the ticket ID and unresolved work or questions to your Main Agent for review and continuation.
