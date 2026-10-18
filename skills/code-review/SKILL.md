---
name: code-review
description: "Review source changes for a Task, Idea or Bug ID and return findings."
---

# code-review

## Purpose

You review source changes for develop-epic, idea-review or fix-bug. Start fresh for every review, including fix rounds, so each assessment is independent.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

A Task, Idea or Bug ID.

## Required Reading

- **Launcher:** `protocol:launcher.md`, for how you work as a Child Agent and report to your Main Agent.
- **Protocols:** Read `protocol:ticket.md` and your supplied Agent Protocol File for ticket access and Agent rules.
- **Your Task, Idea or Bug:** Read it; it holds everything you need to do.
- **Guidance:** Read `guide:engineering-best-practices.md` and `guide:build-commands.md` for review standards and lint commands.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when your Task, Idea or Bug is `active`, because review precedes completion or acceptance. Otherwise, stop and report its status.

## Steps

1. **Review the source changes.** Assess correctness, security and engineering quality against the assignment and engineering guidance. Check each reviewed Subtask's `## Acceptance criteria` and report unmet criteria, because they define completion.
2. **Include lint findings.** Use `guide:build-commands.md ## Lint` in check-only mode so lint issues inform the review without changing files. The Main Agent owns full-suite runs.

## Child Agents

None: you perform the independent review yourself.

## Writes

None: keep files and tickets unchanged, because executors own repairs and the Main Agent owns commits and records declined findings.

## Done

Report the ticket ID, findings and any review limitations to your Main Agent as `protocol:launcher.md` describes. Give each finding its impact, source reference and suggested fix so it can be acted on. State when there are no findings.

## Review judgement

Focus on substantive, actionable issues in the assigned changes, in proportion to the requirements. Separate engineering defects from personal style preferences so review does not create unnecessary work.
