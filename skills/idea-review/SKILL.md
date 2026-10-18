---
name: idea-review
description: "Review an Idea's merged work and file one feedback Epic per round."
---

# idea-review

## Purpose

You review the whole Idea before the Managing Intelligence's acceptance. Each Run is one numbered round.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

An Idea ID.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md`, `protocol:launcher.md` and the Ticket System Protocol File selected by `setting:ticket_system`, for operations.
- **Idea, PRD, SRD, Plan and Epics:** for requirements, decisions and completed work.
- **Guidance:** `guide:engineering-best-practices.md`, `guide:test-guide.md`, `guide:doc-writing-guide.md` and `guide:build-commands.md` for review standards in each repo.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when all of these are true:

- The Plan is `done`, because execution must finish first. Otherwise, report unfinished work.
- The PRD and SRD are `defined`, to review approved requirements. Otherwise, return them to the Managing Intelligence.
- Every Epic worktree is merged into the reviewed checkouts, to review the combined product. Otherwise, suggest teardown-worktree.

## Steps

1. **Start the round.** Number it one more than the last recorded on the Idea, starting at 1. Record checkouts and commits to identify the reviewed work.
2. **Review the whole Idea.** Launch Child Agents and handle their feedback as below.
3. **Hand off.** Hand off feedback for write-epic, develop-epic, merging and another idea-review. With nothing worth fixing, hand off for the Managing Intelligence's testing and acceptance.

## Child Agents

- **`code-review`:** Start fresh every time for independence. Launch across the Idea's source changes. Expect correctness, engineering and lint findings.
- **`test-review`:** Start fresh every time for independence. Launch across the Idea's tests. Expect quality, coverage and duplication findings.
- **`doc-review`:** Start fresh every time for independence. Launch across the Idea's documentation. Expect incomplete, missing or outdated documentation findings.
- **`product-manager`:** Start fresh every time for independence. Launch after those reviewers so it sees the combined result. Expect requirements, scope and proportion findings against the PRD and SRD.

## Handling Reviewer Feedback

For each finding:

- **Fix it:** group all findings worth fixing into one `Round <N> Feedback` Epic for write-epic and develop-epic, so corrections receive planning and review. A non-trivial finding is an unmet PRD requirement or acceptance criterion, or a real defect in the Idea's work.
- **Decline it:** when minor, record why on the Idea for the Managing Intelligence.
- **Ask the Managing Intelligence:** for product questions or PRD/SRD conflicts, because they own those decisions.

## Writes

- **Idea:** record the round, checkouts, commits, declined findings with reasons and feedback Epic ID or testing handoff.
- **Round Feedback Epic:** create a `draft` Plan child with outcome, findings with evidence and the requirement each serves, acceptance criteria and prerequisites. Leave Task planning to write-epic.
- **Plan:** set it `active` when filing feedback, because work remains.

## Done

Report the Idea ID, round, declined findings with reasons, and next step: write-epic (feedback Epic ID) or the Managing Intelligence's testing.
