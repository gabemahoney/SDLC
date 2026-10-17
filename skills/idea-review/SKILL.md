---
name: idea-review
description: "Review a finished Idea, demonstrate its acceptance criteria, and file one Round Feedback Epic for non-trivial findings."
---

# idea-review

## Purpose

Follows develop-epic once the Plan is done and Epic worktrees are merged. Reviews the whole Idea before the Managing Intelligence's testing. Findings go through write-epic and develop-epic before another review round.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

An Idea ID.

## Required Reading

- **Workflow:** `~/.apiary/system/workflow.md`. Why: to follow the shared Run rules.
- **Settings files:** `<Project Folder>/.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`. Why: to select the Ticket System Protocol File through `ticket_system`, and the reviewers' and Product Manager's Thinking Levels through `thinking_levels` and `levels_claude_code` or `levels_codex`.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` in Claude Code, or `~/.apiary/system/protocols/agent-codex.md` in Codex CLI. Why: to dispatch Subagents and ask and report through the Agent.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: to read requirements and progress, record review results, and file feedback in the Plan.
- **Idea, its Docs, Plan and Epics:** through the Ticket System Protocol File, using the input Idea ID, including Tasks and Subtasks behind findings. Why: to review the PRD and SRD requirements, earlier review reports, unacted-on findings, commits, integration results and waivers, and Managing Intelligence decisions.
- **Round progress and earlier feedback:** on the Idea and its Plan's Round Feedback Epics. Why: to resume an unfinished round, check earlier fixes and choose the next round number.
- **Resolver:** `~/.apiary/system/resolvers/<resolver>.md`, selected by each Source Reference's kind. Why: to read supporting source material.
- **Finished product and git history:** the affected repos under `<Project Folder>`, or the Idea's worktrees at `<Project Folder>/.worktrees/<idea-id>/<repo path>`. Why: to identify the checkouts containing all completed Epic work and review the combined changes at their recorded commits.
- **Guidance Documents:** `engineering-best-practices.md`, `test-guide.md`, `doc-writing-guide.md`, `maintained-docs.md` and `build-commands.md` for each reviewed repo, found as `workflow.md` describes. Include the documents `maintained-docs.md` lists. Why: to judge findings against the Project's guidance and demonstrate acceptance criteria with its build and test commands.
- **Subagent reports:** returned during this round or recorded in its progress. Why: to combine independent reviews and give the Product Manager their findings and the acceptance evidence.

## Gate

Run only when both of these are true:

- The Idea's Plan is `done`. If it isn't, stop and report the unfinished planning or execution work.
- Every Epic worktree has been merged into the checkouts being reviewed. If any remains unmerged, stop and suggest teardown-worktree from outside that worktree.

## Steps

1. **Establish the round.** Use the Idea's round progress to resume unfinished review work, or start the next numbered round, beginning at 1. Identify the reviewed checkouts and commits across all affected repos.

2. **Review the whole Idea.** Dispatch the Code, Test and Doc Reviewers in parallel. Demonstrate each PRD acceptance criterion against the combined product using tests or scripts. For a criterion needing manual testing, give the Managing Intelligence concrete validation instructions. Record the evidence and any unmet criteria. Then dispatch the Product Manager with the requirements, reviewer reports and acceptance evidence. Repeat this whole-Idea check in every round, including rounds after feedback fixes.

3. **Judge the findings.** Combine the current reports with unacted-on feedback recorded by develop-epic. Use the Findings guidance below. Check whether each earlier feedback fix solved its finding.
   - If a finding an earlier Round Feedback Epic was meant to fix still stands, record the failed fix and evidence, then stop for the Managing Intelligence's decision before filing more work. Record the decision on that Epic and resume this round from it.

4. **Record the round's outcome.**
   - If non-trivial findings remain, file all of them as one `Round <N> Feedback` Epic in the Idea's Plan, using the Feedback Epic contents below. Create it `draft`, set the Plan from `done` to `active`, and stop with the handoff to write-epic.
   - If findings are only trivial, or there are none, finish the review and list any trivial findings in the final report. The next step is the Managing Intelligence's testing.

## Dispatches

- **Code Reviewer:** launch in every round for the whole Idea's source changes. Expect findings on correctness, engineering guidance and lint results, with references and suggested fixes, or no findings.
- **Test Reviewer:** launch in every round for the whole Idea's tests. Expect findings on coverage, quality and duplication across the suite, with references and suggested fixes, or no findings.
- **Doc Reviewer:** launch in every round for the whole Idea's documentation. Expect findings on complete touched documents, including breaches anywhere in them and documentation made wrong or left missing, or no findings.
- **Product Manager:** launch after the reviewers and acceptance demonstrations in every round. Expect a check against the Idea, PRD and SRD for requirements coverage, scope and proportion, including incomplete work, conflicting decisions and unacted-on reviewer feedback.

## Writes

- The Idea holds round progress: the round number, reviewed repos and commits, reviewer reports, acceptance evidence or manual checks, findings and their disposition, the feedback Epic ID if filed, and the next work. Update this record as the round progresses so a later Run can resume it.
- Create one Round Feedback Epic per round with non-trivial findings, as a `draft` child of the Idea's Plan in the Plans store. Filing it sets the Plan from `done` to `active`.
- A failed earlier fix and the Managing Intelligence's decision are recorded on the feedback Epic that held it.

## Done

Report the Idea ID, round number, reviewed commits, reviewer results, acceptance evidence and manual validation instructions, integration results or waivers from the Epics, and any incomplete review work. List trivial findings and suggestions for problems outside the Idea separately from filed findings.

- If feedback was filed, report its Epic ID and the Plan's status. Suggest write-epic, then develop-epic, merging any Epic worktrees, and idea-review again.
- If an earlier fix failed, report the finding, attempted fix and decision needed to resume the round.
- If the review finished with only trivial findings or none, hand off for the Managing Intelligence's testing and decision to mark the Idea `done`.

## Findings guidance

A non-trivial finding is an unmet requirement or acceptance criterion, or a real defect in the Idea's work. Everything else is trivial. Judge by evidence and impact, so review rounds converge on a working product. Combine duplicate findings and cite the affected requirement, repo and file or observed behaviour, explaining the problem and the result a fix must achieve.

Keep the work within the Idea's requirements and the SRD's choices. Include missing functionality, regressions and excess functionality that conflicts with those requirements. Honour recorded Managing Intelligence decisions when judging findings. Problems outside the Idea become suggestions for write-bug or write-idea in the report.

Keep demonstrated behaviour, observed failures and checks left for manual validation clearly apart. Include relevant earlier integration results and waivers so the Managing Intelligence can see what was tested.

## Feedback Epic contents

- **Outcome:** state the defects and requirement gaps this round must resolve.
- **Findings and requirements:** give each non-trivial finding, its evidence, the requirement it serves, the affected repos and files, and the expected correction. Include earlier feedback references when relevant.
- **Acceptance criteria:** describe observable checks that show each finding is resolved, including the failing scenario to repeat.
- **Dependencies:** name the Epic work these corrections build on and any ordering the fixes require.

Keep the Epic ready for write-epic to plan its Tasks and Subtasks. Size the proposed corrections to the findings.
