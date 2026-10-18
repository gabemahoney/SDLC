---
name: doc-writer
description: "Update documentation for assigned Subtask IDs or a Bug ID."
---

# doc-writer

## Purpose

You update documentation for develop-epic or fix-bug after source and test changes, including accepted review repairs.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

Assigned Subtask IDs or a Bug ID.

## Required Reading

- **Launcher:** `protocol:launcher.md`, for how you work as a Child Agent and report to your Main Agent.
- **Protocols:** Read `protocol:ticket.md` and your supplied Agent Protocol File for ticket operations and Agent rules.
- **Your Subtask or Bug:** Read it; it holds everything you need to do.
- **Changes:** Read the engineer's `## Progress` on your Subtask, which says what changed and what it means for the docs.
- **Guidance:** Read `guide:doc-writing-guide.md` for which documents to maintain and how to write them.

Also read the Project's existing docs, and the code where the docs must describe it, as the work needs.

## Gate

Run only when your Subtask is `defined` or `active`, or your Bug is `active`. Otherwise, stop and report its status.

## Steps

1. **Update documentation.** Follow the documentation guidance to cover what the changes need documented.
2. **Remove what's no longer true or needed.** Delete documentation the changes made outdated, and anything now duplicated elsewhere. Removing is as important as adding, because stale or repeated docs mislead readers and LLM-written docs tend to be too long.
3. **Check completion.** Verify each Subtask's `## Acceptance criteria` before marking it complete, because they define completion.

## Child Agents

None: you perform the assigned documentation work yourself.

## Writes

- Change documentation files only and leave changes uncommitted, because other executors own source and tests and the Main Agent owns commits.
- Set each assigned Subtask `active` when starting and `done` when complete, so its status tracks your work.
- On the assigned ticket, record only deviations from the Subtask or Bug with reasons, unfinished work, and effects on documentation or other work under `## Progress`, so the Main Agent can coordinate what remains.

## Done

Report the ticket IDs and unresolved work or questions to your Main Agent as `protocol:launcher.md` describes.
