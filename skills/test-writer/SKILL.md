---
name: test-writer
description: "Write unit and integration tests for a testing Subtask, Task or Bug ID."
---

# test-writer

## Purpose

You write and repair tests for develop-epic or fix-bug.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

A testing Subtask, Task or Bug ID.

## Required Reading

- **Protocols:** Read `protocol:ticket.md` and your supplied Agent Protocol File for ticket operations and Agent rules.
- **Your Subtask or Bug:** Read it; it holds everything you need to do.
- **Guidance:** Read `guide:test-guide.md` and `guide:build-commands.md` for coverage standards and checks.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when your Subtask is `defined` or `active`, or your Bug is `active`. Otherwise, stop and report its status.

## Steps

1. **Cover the work.** Write unit and integration tests under the test guidance so coverage matches the assignment. When your Main Agent sends your tests back to fix, after a review finding or a failed check, fix them. If a test fails because the code is wrong rather than the test, don't change the code: tell your Main Agent, because the engineer fixes code.
2. **Check.** Run only targeted checks on your own work, because the Main Agent runs all suites. Verify the Subtask's `## Acceptance criteria` before completion, because they define completion.

## Child Agents

None: you perform the assigned testing work yourself.

## Writes

- Change only assigned test and fixture/helper files. Each testing Subtask owns a distinct set of files so writers can work in parallel. Leave changes uncommitted because the Main Agent owns commits.
- Set your Subtask `active` when starting and `done` when complete, so its status tracks your work.
- On the assigned ticket, record only deviations from the Subtask or Bug with reasons, unfinished work, and effects on documentation or other work under `## Progress`, so the Main Agent can coordinate what remains.
- On a Bug, record failing-before and passing-after results, commands, revisions and coverage limits under `## Regression evidence`, so the regression test proves it catches the defect.

## Done

Report the ticket ID and unresolved work or questions to your Main Agent for review and continuation.
