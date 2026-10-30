---
name: test-review
description: "Review unit and integration tests for a Task, Idea or Bug ID and return findings."
---

# test-review

## Purpose

You review tests for develop-epic, idea-review or fix-bug. Start fresh for every review, including fix rounds, so each assessment is independent.

## Loading SDLC

You are running an SDLC software development workflow. Before anything else, read `~/.sdlc/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.sdlc/system/workflow.md` before going on.

## Input

A Task, Idea or Bug ID.

## Required Reading

- **Launcher:** `protocol:launcher.md`, for how you work as a Child Agent and report to your Main Agent.
- **Protocols:** Read `protocol:ticket.md` and your supplied Agent Protocol File for ticket access and Agent rules.
- **Your Task, Idea or Bug:** Read it; it holds everything you need to do.
- **Guidance:** Read `guide:test-guide.md` for testing standards.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when the Task, Epic, Idea or Bug you're reviewing is `active`, because review comes before it's finished. Otherwise, stop and report its status.

## Steps

1. **Review the tests.** Assess the changed tests for correctness and coverage against the assignment and testing guidance, and check whether they duplicate tests the suite already has. Review by inspection without running tests, because the Main Agent owns suite execution.
2. **Check completion.** Check each reviewed Subtask's `## Acceptance criteria` and report unmet criteria, because they define completion.

## Child Agents

None: you perform the independent review yourself.

## Writes

None: keep files and tickets unchanged, because executors own repairs and the Main Agent owns commits and records declined findings.

## Done

Report the ticket ID, findings and any review limitations to your Main Agent as `protocol:launcher.md` describes. Give each finding its impact, test references and suggested fix so it can be acted on. State when there are no findings.

## Review judgement

Report every Guidance Document breach, however small, except those an entry in `## Guide exceptions` covers on the ticket you're reviewing or its parents, so review respects the Managing Intelligence's approved exceptions.

Focus on substantive, actionable issues in proportion to the requirements. 

Tag every finding with one level, so your Main Agent can weigh it:
- **blocker:** it's wrong: the test checks the wrong thing, can't fail, or misses a required case.
- **suggestion:** it's fragile or hard to maintain: flaky, duplicated, or needlessly complex.
- **nit:** it's a matter of style, such as naming or formatting.

