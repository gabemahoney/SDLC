---
name: develop-epic
description: "Build, review and commit one Epic's Tasks and pass its integration gate, resuming from recorded progress when needed."
---

# develop-epic

## Purpose

Builds one Epic's planned work through executors and independent reviewers. Commits the completed Tasks and checks their integration before handing the Epic back to the Managing Intelligence.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

An Epic ID.

## Required Reading

- **Workflow:** `~/.apiary/system/workflow.md`. Why: to follow the shared Run rules.
- **Settings files:** `<Project Folder>/.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`. Why: to select the Ticket System Protocol File through `ticket_system`, and map Task tags and the reviewers', Product Manager's and Integration Tester's Thinking Levels through `thinking_levels` and `levels_claude_code` or `levels_codex`.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` in Claude Code, or `~/.apiary/system/protocols/agent-codex.md` in Codex CLI. Why: to dispatch and resume Subagents, check context use and ask and report through the Agent.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: to read requirements and progress, and write execution results, integration fix Tasks, Dependencies and statuses.
- **Epic, its Tasks and Subtasks, Plan and sibling Epics:** through the Ticket System Protocol File, using the input Epic ID. Why: to follow Dependencies, resume unfinished work and check Plan completion.
- **Idea and its Docs:** through the Plan's Association to its Idea. Why: to follow the PRD, SRD and decisions recorded on the tickets they concern.
- **Guidance Documents:** `engineering-best-practices.md`, `test-guide.md`, `doc-writing-guide.md`, `build-commands.md` and `release-guide.md` for each affected repo, found as `workflow.md` describes. Why: to judge findings, plan integration fixes, check builds and tests, and handle documentation, commits and pushing.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when all of these are true:

- The Epic is `defined` or `active`, or is `done` and needs only the Plan completion check in step 4. Otherwise, stop and suggest write-epic.
- Every Epic it depends on is `done`. Otherwise, stop and report the unfinished Dependency.
- Its Plan is `defined` or `active`, or is `done` for a completed Epic's handoff. Otherwise, stop and suggest write-plan.
- The Idea's PRD and SRD are `defined`, because execution follows approved requirements. Otherwise, stop and return the requirements to the Managing Intelligence.
- The Epic has planned Tasks with Subtasks. Every unfinished Task and Subtask is `defined` or `active`, except recorded `draft` integration fixes whose planning this skill resumes. Otherwise, stop and suggest write-epic to finish planning.

## Steps

1. **Resume the Epic.** Reconcile recorded progress with tickets and git, including any unfinished integration gate, so a restart continues from the work already done. Update stale paths and descriptions to reflect completed prerequisites while following the SRD's choices. A Task reopened by write-epic needs its revised work executed even if its earlier version was committed. Set the Idea, Plan and Epic `active` when work starts; a `done` Epic goes straight to step 4.

2. **Complete the Tasks in Dependency order.** Before each Task, including an integration fix Task, re-check the Plan. If it returned to `draft`, record progress and stop for write-plan, because an SRD revision has paused execution. Apply the Context boundary guidance below.
   - Set the Task `active` and follow the Task pipeline.
   - Once its Subtasks are `done`, accepted findings are resolved and required checks pass, commit the Task's work.
   - A Task with a `## Run Integration After This Task` section stays `active` until the Integration gate passes. Other Tasks become `done` after their commit. The last Task uses the end-of-Epic gate, so the same files are tested once. Integration fix Tasks use the combined repair check described below.

3. **Finish the Epic.** Run the Integration gate after the last Task's commit, unless the current files already have a passing result or an applicable waiver. Then dispatch the Product Manager for the end-of-Epic check and save its findings on the Epic for idea-review. This check informs idea-review rather than blocking completion, because idea-review assesses the whole product. Re-check the Plan before completion, because an SRD revision may have paused execution during the final Task. If it is `draft`, record progress and stop for write-plan. Otherwise, set the Epic `done` once all its Tasks are `done` and its integration gate is met.

4. **Check Plan completion.** Set the Plan `done` if every Epic is `done`. Record the next work on the Epic: remaining Epics, or merging any Epic worktrees through teardown-worktree from outside them, then idea-review once the work is merged.

## Dispatches

- **Engineer:** launch for source changes, including integration fixes. Expect implementation, targeted checks and any deviations or effects on design and documentation.
- **Test Writer:** launch after source changes or for unit-test work, one per Lane and a final Writer after multiple Lanes. Expect unit coverage, fixture changes, remaining gaps and assigned test results.
- **Doc Writer:** launch after source and unit-test work finishes when documentation is affected. Expect updates following `doc-writing-guide.md`, including gaps found in the implementation.
- **Code Reviewer:** launch after source changes, alongside Test Writers. Expect correctness, engineering and lint findings with references and suggested fixes, or none.
- **Test Reviewer:** launch after unit-test or integration-test changes finish. Expect findings on test quality, coverage and duplication across the suite, or none.
- **Doc Reviewer:** launch after documentation changes finish. Expect findings on complete touched documents and missing or outdated documentation, or none.
- **Product Manager:** launch after each Task's executors and reviewers finish, again after fixes affecting product behaviour, and after the Epic's integration gate. Expect findings on requirements, scope and proportion, including incomplete work and decisions needing the Managing Intelligence.
- **Integration Tester:** launch at each integration gate after all file-changing Subagents finish. Expect integration-test changes and a result for each affected repo: `passed`, `source failures`, `could not run` or `no suites found`, with commands and evidence.

## Writes

- **Idea and Plan:** set `active` when execution starts. Set the Plan `done` in step 4.
- **Epic:** set `active` when execution starts and `done` in step 3. It holds execution progress, integration evidence and waivers, and the end-of-Epic Product Manager findings for idea-review.
- **Tasks and Subtasks:** update descriptions whose implementation details became stale after prerequisite work. Record Task findings, decisions, Lane assignments, checks and commits on the Task. Set Tasks `active` when starting and `done` after step 2's completion conditions. Executors set their assigned Subtasks `active`, then `done`.
- **Integration fix Tasks:** create as children of this Epic, with Subtasks beneath them, initially `draft`. Set them `defined` when their descriptions are complete, then execute them through step 2 and complete them as the Integration gate describes. Give each Task a `thinking_level:<label>` tag suited to its complexity and risk. Record a Dependency from each waiting Task or Subtask to its prerequisite so execution follows the required order.

## Done

Report the Epic's ID, and any review findings left unaddressed with the reason.

- If it stopped at a Task boundary, suggest re-running develop-epic on this Epic.
- If more Epics remain, suggest the next one: write-epic if it's `draft`, otherwise develop-epic.
- If the Plan is `done`, suggest teardown-worktree for any Epic worktrees, then idea-review.

## Task pipeline

Executors change files; reviewers check them independently. develop-epic coordinates their work, judges findings and commits the result.

Run the Engineer first, then the Code Reviewer and Test Writers in parallel. After the Test Writers finish, run the Test Reviewer and Doc Writer in parallel. Follow the Doc Writer with the Doc Reviewer, then run the Product Manager after all reviews finish, so it sees the whole Task. Use the roles the work needs; every source-changing pass includes unit testing, and every Task gets its initial Product Manager check.

Collect findings before a batched fix round, so executors address them together. Resume affected executors in source → unit tests → documentation order, with one Doc Writer pass after that round's code and tests finish. Re-review changed work with fresh reviewers and repeat for findings worth fixing. Record each finding's disposition and reason on its Task for idea-review. The Managing Intelligence decides product questions and conflicts with the SRD, because execution follows the defined requirements.

The last Test Writer owns the full unit-suite run in each affected repo with unit tests. Assign it the Task's final full-unit-suite Subtask: the sole Writer for one Lane, or the final Writer after multiple Lanes. It runs the suite after its changes and fixes and rechecks failures. Each later source- or unit-test-changing pass has the same owner. Other roles use targeted checks, so full suites are not repeated by every role. Route unit-test source failures through the Engineer, unit testing and review before completing the Task.

## Test Writer Lanes

A **Lane** is a group of unit-test files one Test Writer can change independently. Start from the Task's `## Test Writer Lanes` suggestions and adjust them to the implementation. Record the assignments and reasons for adjustments on the Task, including each Lane's files and behaviours and shared fixtures or helpers, so Writers can avoid overlapping changes and coverage. Keep files together when they share a fixture or helper being changed or cover overlapping behaviour.

Each Lane owns its files and exclusively used fixtures and helpers, including exclusively used entries in common helper files. Writers record newly discovered shared changes and gaps outside their files on the Task for the final Writer. After multiple Lanes finish, dispatch one final Test Writer to make shared changes, close remaining gaps and run the full unit suite. A sole Writer owns all the Task's tests and helpers. The same ownership applies in fix rounds, so parallel repairs remain independent.

## Executor reuse and progress

Start fresh executors for each Task and retain them for its fix rounds, so fixes reuse their knowledge. Keep each Lane's Test Writer and the final Test Writer where there are multiple Lanes. Resume the executors whose work is affected; replace an unavailable executor with a fresh one reading the Task's progress. Reviewers, Product Managers and Integration Testers start fresh each time for an independent assessment.

Keep the Epic's progress concise: current Task and phase, repo checkouts, integration gate and next work. On each Task, record retained executors' Roles, Lane or final-Writer assignments, Agent IDs, names if available and Thinking Levels after each report, so a later Run can resume them. Dispatches name the assigned repo checkouts so code changes land in the intended worktrees. After compaction, reconcile ticket and git state before dispatching or committing, because a summary may omit completed work.

## Context boundary

Before each Task after the first in a Run, read how full the context is, as the Agent Protocol File describes. At 75% or more, record progress and stop for a fresh `develop-epic <epic-id>` session, because an Agent with a nearly full context makes mistakes. The Managing Intelligence arranges the restart. If no reading can be made, stop the same way and report it, because project-setup should have ensured one.

## Integration gate

Run integration after each flagged Task and after the Epic's last Task. The gate passes when each affected repo reports `passed` or `no suites found`, or the Managing Intelligence explicitly waives the remaining failures. Record evidence and any waiver on the Epic and the flagged Task. Keep the Epic and gated Tasks `active` until then, and commit the gate's integration-test changes before continuing to the next planned Task.

If integration tests change, get a Test Reviewer check because these tests were written after the Task's review. Resolve accepted findings with a fresh Integration Tester and obtain a suite result for the resulting files.

For source failures within the Epic's scope, create integration fix Tasks describing the outcome, acceptance criteria and prerequisites. On resume, finish any recorded draft repairs before executing them, so interruptions during repair planning are recoverable. Each Subtask names its executor and has Context, What Needs to Change, Key Files and Acceptance Criteria sections, so the fix is as executable as the original planning. Include unit coverage and the final full-unit-suite Subtask, documentation where affected, Test Writer Lanes and the integration flag for interface changes.

Execute fix Tasks through the full Task pipeline in Dependency order and mark each `done` after its checks, reviews and commit. Defer their flagged integration runs to one check over the combined repairs, so dependent fixes can proceed. Keep the original gated Task and Epic `active` until that check passes. Use the original Task's committed implementation as repair context; Dependencies between fix Tasks order their execution.

If a failure an earlier fix Task was meant to fix persists, stop for the Managing Intelligence's decision, so failed repairs do not become an automatic loop. If suites cannot run, stop for the environment to be fixed or a waiver. Record the unfinished gate so a later Run resumes there.

A result or waiver applies to the files it covered. Further source or integration-test changes need a new result or explicit waiver, so the Epic is accepted against its final implementation.
