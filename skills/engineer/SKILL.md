---
name: engineer
description: "Implement source changes for assigned Subtask IDs or a Bug ID."
---

# engineer

## Purpose

You implement source changes for develop-epic or fix-bug.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

Assigned Subtask IDs or a Bug ID.

## Required Reading

- **Launcher:** `protocol:launcher.md`, for how you work as a Child Agent and report to your Main Agent.
- **Protocols:** Read `protocol:ticket.md` and your supplied Agent Protocol File for ticket operations and Agent rules.
- **Your Subtask or Bug:** it holds everything you need to do.
- **Guidance:** Read `guide:engineering-best-practices.md` and `guide:build-commands.md` for implementation standards and checks.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when your Subtask is `defined` or `active`, or your Bug is `active`. Otherwise, stop and report its status.

## Steps

1. **Implement.** Complete the assigned source changes and accepted repairs under the engineering guidance so the implementation meets the ticket's requirements.
2. **Check.** Run targeted checks on your changes, because the Main Agent runs the full suites. Check each Subtask's `## Acceptance criteria` before marking it complete, because they define completion.

## Child Agents

None: you perform the assigned implementation yourself.

## Writes

- Change source files only and leave changes uncommitted, because other executors own tests and documentation and the Main Agent owns commits.
- Set each assigned Subtask `active` when starting and `done` when complete, so its status tracks your work.
- On a Subtask, record only deviations with reasons, unfinished work, and effects on documentation or other work under `## Progress`, so the Main Agent can coordinate what remains. On a Bug, report them to fix-bug instead, because several Child Agents work on one Bug at once and fix-bug records them.

## Done

Report the ticket IDs and unresolved work or questions to your Main Agent as `protocol:launcher.md` describes.
