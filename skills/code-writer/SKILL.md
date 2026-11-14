---
name: code-writer
description: "Implement source changes for assigned Subtask IDs, or Bug or Tweak IDs."
---

# code-writer

## Purpose

You implement source changes for develop-epic or fix-bug, and in fix-bug's small pipeline its regression tests and doc changes too.

In build-tweak, work as in fix-bug's small pipeline, reading the Tweak as your Bug, writing the tests `guide:test-guide.md` asks for in place of regression tests, and report any design decision or growth past one area.

## Loading SDLC

You are running an SDLC software development workflow. Before anything else, read `~/.sdlc/install/workflow.md`, then follow this skill. After a compaction, re-read `~/.sdlc/install/workflow.md` before going on.

## Input

Assigned Subtask IDs, or Bug or Tweak IDs.

## Required Reading

- **Launcher:** `protocol:launcher.md`, for how you work as a Child Agent and report to your Main Agent.
- **Protocols:** Read `protocol:ticket.md` and your supplied Agent Protocol File for ticket operations and Agent rules.
- **Your Subtask, Bug or Tweak:** it holds everything you need to do.
- **Guidance:** Read `guide:engineering-best-practices.md` and `guide:build-commands.md` for implementation standards and checks, and in fix-bug's small pipeline `guide:test-guide.md` and `guide:doc-writing-guide.md` for its tests and docs.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when your Subtask is `defined` or `active`, or your Bug or Tweak is `active`. Otherwise, stop and report its status.

## Steps

1. **Implement.** Complete the assigned source changes and accepted repairs under the engineering guidance so the implementation meets the ticket's requirements.
2. **Check.** Run targeted checks on your changes, because the Main Agent runs the commit checks and full suites. Check each Subtask's `## Acceptance criteria`, or a Tweak's `## Description`, before marking it complete, because they define completion.

## Child Agents

None: you perform the assigned implementation yourself.

## Writes

- Change only source files, plus tests and docs in fix-bug's small pipeline, because other executors own the rest. Leave changes uncommitted, because the Main Agent owns commits.
- In fix-bug's small pipeline, write the regression tests before the fix and report failing-before and passing-after results, commands, revisions and coverage limits to fix-bug, so the tests prove they catch the defect.
- Set each assigned Subtask `active` when starting and `done` when complete, so its status tracks your work.
- On a Subtask, record only deviations with reasons, unfinished work, and effects on documentation or other work under `## Progress`, so the Main Agent can coordinate what remains. On a Bug, report them to fix-bug instead, because several Child Agents work on one Bug at once and fix-bug records them.

## Done

Report the ticket IDs and unresolved work or questions to your Main Agent as `protocol:launcher.md` describes.
