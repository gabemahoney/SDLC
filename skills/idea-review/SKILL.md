---
name: idea-review
description: "Review an Idea's work in its worktrees and file one feedback Epic per round."
---

# idea-review

## Purpose

You review the Idea before the Managing Intelligence's acceptance. Each Run is one numbered round.

## Loading SDLC

Read `~/.sdlc/install/workflow.md` first for shared rules, settings and file locations.

## Input

An Idea ID.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** your Agent Protocol File (`protocol:agent-claude-code.md`, `protocol:agent-codex.md` or `protocol:agent-cursor.md`), `protocol:launcher.md` and the Ticket System Protocol File selected by `setting:ticket_system`, for operations.
- **Idea, PRD, SRD, Plan and Epics:** for requirements, decisions and completed work. The Plan's `## Worktrees` says where the work is, and where your Child Agents review it.
- **Model Docs' `## Checks`:** for during-build checks that haven't passed against the current SRD, because your handoff lists them.
- **Guidance:** `guide:engineering-best-practices.md`, `guide:test-guide.md`, `guide:doc-writing-guide.md` and `guide:build-commands.md` for review standards in each repo.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when all of these are true:

- The Plan is `done` and every Epic merged, because execution must finish first. Otherwise, report unfinished work.
- The Plan has a `## Worktrees` record, because it tells your Child Agents where to review the work, and `none` means no repo changed. Otherwise, stop and tell the Managing Intelligence, because there is no recorded work to review.
- The Idea's PRD and SRD are `defined`, because you review the work against them. Otherwise, stop and tell the Managing Intelligence which one isn't approved.

## Steps

1. **Start the round.** Number it one more than the last recorded on the Idea, starting at 1. Record the round, checkouts and commits under `## Review rounds` on the Idea to identify the reviewed work.
2. **Review the round's work.** A round with no finished round before it reviews the whole Idea. Every other round reviews only the changes made since the last finished round, plus the code and docs they touch, because develop-epic already reviewed those changes. Launch Child Agents, telling each in any other round which changes it covers, and handle their feedback as below.
3. **Hand off.** If any findings are worth fixing, create one Epic titled `Round <N> Feedback` in the Idea's Plan, with contents as Writes describes, and set the Plan `active` because work remains. If any finding went to write-srd, hand off to the Managing Intelligence for write-srd before write-epic or acceptance, because the requirement gap must close first. Otherwise, hand off to write-epic if you filed feedback, or hand the Idea to the Managing Intelligence for testing and acceptance, listing any Model Docs whose during-build checks haven't passed against the current SRD, because acceptance waits on them.

## Child Agents

In a round that reviews the whole Idea, launch every Child Agent below at `xhigh`, overriding its fixed level, because it's the Idea's one full review. Other rounds use the fixed levels, because they only check fixes.

- **`code-review`:** Start fresh every time for independence. Launch across the round's source changes. Expect correctness and engineering findings.
- **`test-review`:** Start fresh every time for independence. Launch across the round's tests. Expect quality, coverage and duplication findings.
- **`doc-review`:** Start fresh every time for independence. Launch across the round's documentation. Expect incomplete, missing or outdated documentation findings.
- **`product-manager`:** Start fresh every time for independence. Launch after those reviewers so it sees the combined result. Expect requirements, scope and proportion findings against the PRD and SRD.

## Handling Reviewer Feedback

For each finding:

- **Fix it:** group all findings worth fixing, including any merge conflict teardown-worktree reported in the Plan's `## Worktrees`, into one `Round <N> Feedback` Epic for write-epic and develop-epic, so corrections receive planning and review. A non-trivial finding is an unmet PRD requirement or acceptance criterion, a real defect in the Idea's work, or a broken Guidance Document rule.
- **Route it to write-srd:** send an unmet PRD requirement that no SRD requirement covers to the Managing Intelligence, to route through write-srd, because the SRD must define the software before it's planned.
- **Decline it:** use your judgement to decline findings that are minor or trivial, and record each one with its reason under `## Declined findings` on the Idea for the Managing Intelligence.
- **Ask the Managing Intelligence:** for product questions or PRD/SRD conflicts, because they own those decisions.

## Writes

- **Idea:** under `## Review rounds`, record the round, checkouts and commits when it starts, any feedback Epic ID and its handoff when it finishes (a round that doesn't finish doesn't count), and each finding sent to write-srd with its evidence and PRD requirement, so write-srd reads the gap from the ticket. Under `## Declined findings`, record declined or unaddressed findings with reasons.
- **Round Feedback Epic:** when findings are worth fixing, create one `draft` child of the Idea's Plan titled `Round <N> Feedback`, with `## Outcome` for the correction's outcome, `## Findings` for findings with evidence and the requirement or Guidance Document rule each serves or the merge conflict it resolves, `## Acceptance criteria` for observable checks, and `## Dependencies` for prerequisites. Leave Task planning to write-epic.
- **Plan:** set it `active` when filing feedback, because work remains.

## Retrospective notes

While you work, note under `## Retrospective notes` on your ticket, with evidence, your answers to these questions, because the Managing Intelligence builds the Idea's or Bug's retrospective from them:

- Where did we introduce a quality issue? How could it have been avoided?
- Where did we spend too much time and not gain value? How could it have been avoided?
- Where did we spend too many tokens and not gain value? How could it have been avoided?

## Done

Report the Idea ID, round, declined findings with reasons, findings routed to write-srd, and next step: write-srd through the Managing Intelligence (with any feedback Epic ID), write-epic (feedback Epic ID) or the Managing Intelligence's testing.
