---
name: engineer
description: "Implement source changes for assigned Subtask IDs, a Bug ID or a Tweak ID."
---

# engineer

## Purpose

You implement source changes for develop-epic, fix-bug or build-tweak, and their tests and doc changes too in fix-bug's small pipeline and build-tweak.

## Loading SDLC

You are running an SDLC software development workflow. Before anything else, read `~/.sdlc/install/workflow.md`, then follow this skill. After a compaction, re-read `~/.sdlc/install/workflow.md` before going on.

## Input

Assigned Subtask IDs, a Bug ID or a Tweak ID.

## Required Reading

- **Launcher:** `protocol:launcher.md`, for how you work as a Child Agent and report to your Main Agent.
- **Protocols:** Read `protocol:ticket.md` and your supplied Agent Protocol File for ticket operations and Agent rules.
- **Your Subtask, Bug or Tweak:** it holds everything you need to do.
- **Guidance:** Read `guide:engineering-best-practices.md` and `guide:build-commands.md` for implementation standards and checks, and in fix-bug's small pipeline and build-tweak `guide:test-guide.md` and `guide:doc-writing-guide.md` for its tests and docs.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when your Subtask is `defined` or `active`, or your Bug or Tweak is `active`. Otherwise, stop and report its status.

## Steps

1. **Implement.** Complete the assigned source changes and accepted repairs under the engineering guidance so the implementation meets the ticket's requirements.
2. **Check.** Run targeted checks on your changes, because the Main Agent runs the full suites. Check each Subtask's `## Acceptance criteria`, or a Tweak's `## Description`, before you finish, because they define completion.

## Child Agents

None: you perform the assigned implementation yourself.

## Writes

- Change only source files, plus tests and docs in fix-bug's small pipeline and build-tweak, because other executors own the rest. Leave changes uncommitted, because the Main Agent owns commits.
- In fix-bug's small pipeline, write the regression tests before the fix and report failing-before and passing-after results, commands, revisions and coverage limits to fix-bug, so the tests prove they catch the defect.
- Set each assigned Subtask `active` when starting and `done` when complete, so its status tracks your work.
- On a Subtask, record only deviations with reasons, unfinished work, and effects on documentation or other work under `## Progress`, so the Main Agent can coordinate what remains. On a Bug or Tweak, report them to your Main Agent instead, because it alone writes that ticket while Child Agents work on it.
- In build-tweak, report anything that needs a design decision or grows past one area, because the work would then stop being a Tweak.

## Done

Report the ticket IDs and unresolved work or questions to your Main Agent as `protocol:launcher.md` describes.
