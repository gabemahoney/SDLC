---
name: idea-review
description: "Review an Idea's work in its worktrees and file one feedback Epic per round."
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
- **Protocols:** your Agent Protocol File (`protocol:agent-claude-code.md`, `protocol:agent-codex.md` or `protocol:agent-cursor.md`), `protocol:launcher.md` and the Ticket System Protocol File selected by `setting:ticket_system`, for operations.
- **Idea, PRD, SRD, Plan and Epics:** for requirements, decisions and completed work. The Plan's `## Worktrees` says where the work is, and where your Child Agents review it. Read an Idea's own record when its Plan has none, because older Runs kept it there.
- **Guidance:** `guide:engineering-best-practices.md`, `guide:test-guide.md`, `guide:doc-writing-guide.md` and `guide:build-commands.md` for review standards in each repo.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when all of these are true:

- The Plan is `done`, because execution must finish first. Otherwise, report unfinished work.
- The Idea's PRD and SRD are `defined`, because you review the work against them. Otherwise, stop and tell the Managing Intelligence which one isn't approved.

## Steps

1. **Start the round.** Number it one more than the last recorded on the Idea, starting at 1. Record the round, checkouts and commits under `## Review rounds` on the Idea to identify the reviewed work.
2. **Review the whole Idea.** Launch Child Agents and handle their feedback as below.
3. **Hand off.** If any findings are worth fixing, create one Epic titled `Round <N> Feedback` in the Idea's Plan, with contents as Writes describes, and set the Plan `active` because work remains. If any finding went to write-srd, hand off to the Managing Intelligence for write-srd before acceptance, because the requirement gap must close first. Otherwise, hand off to write-epic if you filed feedback, or hand the Idea to the Managing Intelligence for testing and acceptance.

## Child Agents

- **`code-review`:** Start fresh every time for independence. Launch across the Idea's source changes. Expect correctness, engineering and lint findings.
- **`test-review`:** Start fresh every time for independence. Launch across the Idea's tests. Expect quality, coverage and duplication findings.
- **`doc-review`:** Start fresh every time for independence. Launch across the Idea's documentation. Expect incomplete, missing or outdated documentation findings.
- **`product-manager`:** Start fresh every time for independence. Launch after those reviewers so it sees the combined result. Expect requirements, scope and proportion findings against the PRD and SRD.

## Handling Reviewer Feedback

For each finding:

- **Fix it:** group all findings worth fixing, including any merge conflict teardown-worktree reported in the Plan's `## Worktrees`, into one `Round <N> Feedback` Epic for write-epic and develop-epic, so corrections receive planning and review. A non-trivial finding is an unmet PRD requirement or acceptance criterion, or a real defect in the Idea's work.
- **Route it to write-srd:** send an unmet PRD requirement that no SRD requirement covers to the Managing Intelligence, to route through write-srd, because the SRD must define the software before it's planned.
- **Decline it:** use your judgement to decline findings that are minor or trivial, and record each one with its reason under `## Declined findings` on the Idea for the Managing Intelligence.
- **Ask the Managing Intelligence:** for product questions or PRD/SRD conflicts, because they own those decisions.

## Writes

- **Idea:** under `## Review rounds`, record the round, checkouts, commits, any feedback Epic ID, and the write-srd or testing handoff. Under `## Declined findings`, record declined or unaddressed findings with reasons.
- **Round Feedback Epic:** when findings are worth fixing, create one `draft` child of the Idea's Plan titled `Round <N> Feedback`, with `## Outcome` for the correction's outcome, `## Findings` for findings with evidence and the requirement or Guidance Document rule each serves or the merge conflict it resolves, `## Acceptance criteria` for observable checks, and `## Dependencies` for prerequisites. Leave Task planning to write-epic.
- **Plan:** set it `active` when filing feedback, because work remains.

## Done

Report the Idea ID, round, declined findings with reasons, findings routed to write-srd, and next step: write-srd through the Managing Intelligence (with any feedback Epic ID), write-epic (feedback Epic ID) or the Managing Intelligence's testing.
