---
name: test-review
description: "Review unit and integration tests for a Task, Idea or Bug ID and return findings."
---

# test-review

## Purpose

You review tests for develop-epic, idea-review or fix-bug. Start fresh for every review, including fix rounds, so each assessment is independent.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

A Task, Idea or Bug ID.

## Required Reading

- **Launcher:** `protocol:launcher.md`, for how you work as a Child Agent and report to your Main Agent.
- **Protocols:** Read `protocol:ticket.md` and your supplied Agent Protocol File for ticket access and Agent rules.
- **Your Task, Idea or Bug:** Read it; it holds everything you need to do.
- **Guidance:** Read `guide:test-guide.md` for testing standards.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when your Task, Idea or Bug is `active`, because review precedes completion or acceptance. Otherwise, stop and report its status.

## Steps

1. **Review the tests.** Read the whole test suite to assess changed tests for correctness, coverage and duplication against the assignment and testing guidance. Review by inspection without running tests, because the Main Agent owns suite execution.
2. **Check completion.** Check each reviewed Subtask's `## Acceptance criteria` and report unmet criteria, because they define completion.

## Child Agents

None: you perform the independent review yourself.

## Writes

None: keep files and tickets unchanged, because executors own repairs and the Main Agent owns commits and records declined findings.

## Done

Report the ticket ID, findings and any review limitations to your Main Agent as `protocol:launcher.md` describes. Give each finding its impact, test references and suggested fix so it can be acted on. State when there are no findings.

## Review judgement

Your job is to interpret the Guidance Documents very strictly: report every breach of them as a finding, however small, because your Main Agent decides which findings are worth fixing.

Focus on substantive, actionable issues in proportion to the requirements. Give cross-file duplication and unnecessary test complexity particular attention, because they increase maintenance without improving coverage. Cite the overlapping tests when reporting duplication so the correction is clear.

Tag every finding with one level, so your Main Agent can weigh it:
- **blocker:** what's there is wrong: false, broken, or it breaks a contract. Someone relying on it would be misled or fail.
- **suggestion:** it works, but it will go wrong in a case it doesn't cover, or it's hard to maintain, for example duplicated or needlessly complex.
- **nit:** it works and is easy to maintain; the fix is cosmetic, such as wording or naming.

