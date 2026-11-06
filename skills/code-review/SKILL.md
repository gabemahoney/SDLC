---
name: code-review
description: "Review source changes for a Task, Idea, Tweak or Bug ID and return findings."
---

# code-review

## Purpose

You review source changes for develop-epic, idea-review or fix-bug, and the whole change in fix-bug's small pipeline and build-tweak, because you are then its only reviewer.

## Loading SDLC

You are running an SDLC software development workflow. Before anything else, read `~/.sdlc/install/workflow.md`, then follow this skill. After a compaction, re-read `~/.sdlc/install/workflow.md` before going on.

## Input

A Task, Idea, Tweak or Bug ID.

## Required Reading

- **Launcher:** `protocol:launcher.md`, for how you work as a Child Agent and report to your Main Agent.
- **Protocols:** Read `protocol:ticket.md` and your supplied Agent Protocol File for ticket access and Agent rules.
- **Your Task, Idea, Tweak or Bug:** Read it; it holds everything you need to do.
- **Guidance:** Read `guide:engineering-best-practices.md` for review standards, and in fix-bug's small pipeline and build-tweak `guide:test-guide.md` and `guide:doc-writing-guide.md` for its tests and docs.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when the Task, Epic, Idea, Tweak or Bug you're reviewing is `active`, because review comes before it's finished. Otherwise, stop and report its status.

## Steps

1. **Review the source changes and the code around them.** Assess correctness, security and engineering quality against the assignment and engineering guidance. Also review the code that calls the changed code and the code it calls, because a change can break its neighbours without breaking itself. Check each reviewed Subtask's `## Acceptance criteria`, or a Tweak's `## Description`, and report what's unmet, because they define completion. In fix-bug's small pipeline and build-tweak, also review the tests and docs against their guides, including docs the change leaves wrong.

## Child Agents

None: you perform the independent review yourself.

## Writes

None: keep files and tickets unchanged, because executors own repairs and the Main Agent owns commits and records declined findings.

## Done

Report the ticket ID, findings and any review limitations to your Main Agent as `protocol:launcher.md` describes. Report each kind of problem as one finding with its impact, suggested fix and every place you find it, so it can be fixed everywhere in one round. State when there are no findings.

## Review judgement

Report every Guidance Document breach, however small, except those an entry in `## Guide exceptions` covers on the ticket you're reviewing or its parents, so review respects the Managing Intelligence's approved exceptions.

Focus on substantive, actionable issues in the assigned changes, in proportion to the requirements. Separate engineering defects from personal style preferences so review does not create unnecessary work.

Tag every finding with one level, so your Main Agent can weigh it:
- **blocker:** it's wrong: broken, insecure, or it breaks a contract.
- **suggestion:** it's fragile or hard to maintain: misses a case, duplicated, or needlessly complex.
- **nit:** it's a matter of style, such as naming or formatting.

