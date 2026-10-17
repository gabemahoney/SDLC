---
name: idea-review
description: "Review an Idea's merged work against its requirements and file a Round Feedback Epic for non-trivial findings."
---

# idea-review

## Purpose

Reviews the whole Idea after its Plan is done and Epic worktrees are merged. Files corrections for write-epic and develop-epic, or hands the result to the Managing Intelligence for testing and acceptance.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

An Idea ID.

## Required Reading

- **Settings:** Project and default settings, resolved as `workflow.md` describes, for this Run's configuration.
- **Agent Protocol File:** `agent-claude-code.md` or `agent-codex.md` under `~/.apiary/system/protocols/`, for the Main Agent's own context readings and skill invocation.
- **Launcher Protocol File:** `launcher.md`, selected as `workflow.md` describes, for Child Agent operations and context readings.
- **Ticket System Protocol File:** selected by `ticket_system` as `workflow.md` describes, to read requirements and progress, record review results and file feedback in the Plan.
- **The Idea, its PRD, SRD, Plan and Epics:** through the Ticket System Protocol File, using the input Idea ID and the Plan's Association to it. Why: to review the requirements, resume round progress and follow earlier findings, fixes, integration results, waivers and Managing Intelligence decisions.
- **Guidance Documents:** `engineering-best-practices.md`, `test-guide.md`, `doc-writing-guide.md` and `build-commands.md` for each reviewed repo, found as `workflow.md` describes, to judge the work against the Project's guidance and demonstrate acceptance criteria.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when all of these are true:

- The Idea's Plan is `done`, or is `active` and this Run only finishes recording an already reviewed round's feedback and handoff. Otherwise, stop and report the unfinished planning or execution work, because a new review needs completed execution.
- The PRD and SRD are `defined`, because the review needs approved requirements. Otherwise, stop and return the requirements to the Managing Intelligence.
- Every Epic worktree has been merged into the checkouts being reviewed, so the review covers the combined product. Otherwise, stop and suggest teardown-worktree from outside the unmerged worktrees.

## Steps

1. **Establish the round.** Resume the Idea's unfinished round, or start the next numbered round, beginning at 1. If only feedback filing or the handoff remains, continue at step 4 from the recorded findings. Record the reviewed checkouts and commits. Reuse recorded checks only for the requirements and files they covered, so a resumed review assesses the current product.

2. **Review the whole Idea.** Launch code-review, test-review and doc-review in parallel for independent checks. Demonstrate each PRD acceptance criterion with tests or scripts; record concrete manual validation instructions where direct demonstration needs the Managing Intelligence. Judge their findings under the shared rule. Save acceptance evidence and declined or unaddressed findings with reasons on the Idea, then launch `product-manager` with the ticket IDs. Each new round covers the whole Idea, because corrections can affect previously working behaviour.

3. **Judge the findings.** Use the Findings guidance below, including unaddressed feedback from develop-epic and the Tasks behind it. Check whether earlier feedback fixes resolved their findings. If an earlier fix failed, record the evidence on that feedback Epic and stop for the Managing Intelligence's decision before filing more work, so a failed fix does not start an automatic loop. Resume from their recorded decision.

4. **Finish the round.** File its non-trivial findings in one `Round <N> Feedback` Epic, using the contents below. Reuse that round's Epic if filing was interrupted, so a restart creates no duplicate work. Record the handoff on the Idea: write-epic for feedback, then develop-epic, merging and another idea-review; or the Managing Intelligence's testing and acceptance when only trivial findings or none remain.

## Child Agents

- **`code-review`:** Start fresh every time so each assessment is independent. Launch in each round for the whole Idea's source changes. Expect correctness, engineering and lint findings with references and suggested fixes, or none.
- **`test-review`:** Start fresh every time so each assessment is independent. Launch in each round for the whole Idea's tests. Expect coverage, quality and duplication findings across the suite, or none.
- **`doc-review`:** Start fresh every time so each assessment is independent. Launch in each round for the whole Idea's documentation. Expect findings on complete touched documents, including breaches anywhere in them and missing or outdated documentation, or none.
- **`product-manager`:** Start fresh every time so each assessment is independent. Launch after the reviewers and acceptance demonstrations in each round. Expect findings against the PRD and SRD on coverage, scope and proportion, including incomplete work, conflicting decisions and unaddressed feedback.

## Writes

- **Idea:** record the round number, reviewed checkouts and commits, acceptance evidence and manual checks, declined or unaddressed findings with reasons, feedback Epic ID and next work as the round progresses, so a later Run can resume it. Its status remains for the Managing Intelligence to decide.
- **Round Feedback Epic:** create one per round with non-trivial findings, as a `draft` child of the Plan. When revising findings, update every feedback Epic they affect, whatever its status, and return it to `draft`, so write-epic replans its affected Tasks and Subtasks. Use Associations to earlier Epics for context; record a Dependency only where the feedback Epic must wait for another ticket to be `done`.
- **Plan:** set it `active` when feedback is filed or revised, because execution has more work.
- **Earlier Round Feedback Epics:** record failed fixes and the Managing Intelligence's decisions on the Epics that held them, so the next review can judge the attempted corrections.

## Done

Report the Idea's ID, and the Round Feedback Epic's ID if one was filed.

- If feedback was filed, suggest write-epic on it, then develop-epic, then idea-review again.
- If an earlier fix failed, report what decision is needed to resume.
- Otherwise, the Idea is ready for the Managing Intelligence's testing.

## Findings guidance

A non-trivial finding is an unmet requirement or acceptance criterion, or a real defect in the Idea's work. Everything else is trivial. Judge by evidence and impact, so review rounds converge on a working product. Combine duplicate findings and explain why each needs work or can be left unaddressed.

Keep corrections within the PRD's requirements and the SRD's choices. Include missing functionality, regressions and excess functionality that conflicts with those requirements. Honour recorded Managing Intelligence decisions. Work outside the Idea follows `workflow.md`'s “Work outside the ticket”.

Keep demonstrated behaviour, observed failures and checks left for manual validation distinct, so testing instructions cannot be mistaken for passing evidence. Reference the Epics' integration results and waivers in the acceptance evidence to show the limits of earlier testing.

## Feedback Epic contents

- **Outcome:** the defects and requirement gaps this round must resolve.
- **Findings and requirements:** each non-trivial finding, its evidence, the requirement it serves, affected repos and files, and the result a correction must achieve. Reference earlier feedback tickets where relevant.
- **Acceptance criteria:** observable checks showing each finding is resolved, including the failing scenario to repeat.
- **Prerequisites:** any work that must finish before these corrections can start, and why.

Size corrections to the findings. Leave Task and Subtask planning to write-epic, so the corrections receive the same planning checks as the original work.
