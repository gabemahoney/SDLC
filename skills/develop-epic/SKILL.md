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
- **Settings files:** `<Project Folder>/.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`. Why: to select the Ticket System Protocol File through `ticket_system` and map executor tags and the reviewers' and Product Manager's Thinking Levels through `thinking_levels` and `levels_claude_code` or `levels_codex`.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` in Claude Code, or `~/.apiary/system/protocols/agent-codex.md` in Codex CLI. Why: to dispatch and resume Subagents, check context use and ask and report through the Agent.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: to read requirements and progress, and record results, fix Tasks, Dependencies and statuses.
- **Epic, its Tasks and Subtasks, Plan and sibling Epics:** through the Ticket System Protocol File, using the input Epic ID. Why: to follow Dependencies, resume unfinished work and check Plan completion.
- **Idea and its Docs:** through the Plan's Association to its Idea. Why: to follow the PRD, SRD and decisions recorded on the tickets they concern.
- **Guidance Documents:** `engineering-best-practices.md`, `test-guide.md`, `doc-writing-guide.md`, `build-commands.md` and `release-guide.md` for each affected repo, found as `workflow.md` describes. Why: to judge findings, plan repairs, check builds and tests, and handle documentation, commits and pushing.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when all of these are true:

- The Epic is `defined` or `active`, or is `done` and needs only the Plan completion check in step 4. Otherwise, stop and suggest write-epic.
- Every Epic it depends on is `done`. Otherwise, stop and report the unfinished Dependency.
- Its Plan is `defined` or `active`, or is `done` for a completed Epic's handoff. Otherwise, stop and suggest write-plan.
- The Idea's PRD and SRD are `defined`, because execution follows approved requirements. Otherwise, stop and return the requirements to the Managing Intelligence.
- The Epic has planned Tasks with Subtasks. Every unfinished Task and Subtask is `defined` or `active`, except `draft` fix Tasks and their Subtasks, whose planning this skill resumes so interrupted repairs can continue. Otherwise, stop and suggest write-epic to finish planning.

## Steps

1. **Start or resume the Epic.**
   - If the Epic is `done`, go straight to step 4.
   - Otherwise, set the Idea, Plan and Epic `active`, to show that work has begun. If an earlier Run did some of the work, continue from the progress recorded on the Epic, checked against the tickets and git, so finished work isn't redone. A Task that write-epic reopened counts as unfinished, even if an earlier version was committed.

2. **Work on each Task,** one at a time in Dependency order.
   - **Before it starts:** re-check the Plan. If it's back in `draft`, record progress and stop for write-plan, because an SRD change has paused the work. From the second Task on, check how full your context is, as the Agent Protocol File describes. At 75% or more, or if you can't tell, record progress and stop for a fresh `develop-epic <epic-id>` session, which the Managing Intelligence starts, because an Agent with a nearly full context makes mistakes.
   - **Check and update its instructions:** compare this Task's instructions with the code earlier Tasks committed, such as the files, functions and interfaces the instructions name. Fix any instruction that code made wrong, because every Task was written before any of that code existed.
   - **While it runs:** set the Task `active` and follow the Task pipeline below.
   - **When it's done:** once its Subtasks are `done` and accepted findings are resolved, run `## Compile` and `## Lint` from `build-commands.md` for every affected code folder. The final Test Writer's full `## Unit tests` run must also pass for the completed work. Skip sections marked `none`. Send failures back to the executor who owns the files through the Task pipeline and repeat the checks after repairs. Commit only when all required checks pass, so each Task leaves verified work for the next one.
   - **After its commit:** set the Task `done`, because its work and checks are complete.

3. **Finish the Epic.** Once all Tasks are `done`, run the Integration gate, because the Epic is a complete vertical slice, and catching errors early stops them compounding, even if it costs a little extra time. If an earlier Run already passed the gate, or the Managing Intelligence waived its failures, and no files have changed since, skip it.

   Then dispatch the Product Manager and judge each finding. Turn accepted findings into fix Tasks and complete them through step 2's Task pipeline, so repairs get the same checks and reviews as the original work. If files change, rerun the Integration gate after the fix Tasks finish so it checks the completed repairs. Product questions go to the Managing Intelligence, who decides the expected behaviour. Record only declined findings on the Epic, each with its reason, so idea-review sees what was left.

   Re-check the Plan before setting the Epic `done`, because an SRD revision may have paused execution during the final Task. If the Plan is `draft`, record progress and stop for write-plan. Otherwise, set the Epic `done` once all its Tasks are `done`, accepted findings are resolved and its integration gate is met.

4. **Check Plan completion.** Set the Plan `done` if every Epic is `done`. Record the next work on the Epic: remaining Epics, or merging any Epic worktrees through teardown-worktree from outside them, then idea-review once the work is merged.

## Dispatches

- **Engineer:** launch for source changes, including integration fixes. Expect implementation, targeted checks and any deviations or effects on design and documentation.
- **Test Writer:** launch for testing Subtasks after their source changes, one per Lane and a final Writer after multiple Lanes, and for integration failures caused by tests. Expect unit and integration coverage following `test-guide.md`, fixture changes, test repairs, remaining gaps and assigned test results.
- **Doc Writer:** launch when source and testing Subtasks finish and documentation is affected. Expect updates following `doc-writing-guide.md`, including gaps found in the implementation.
- **Code Reviewer:** launch after source changes, alongside Test Writers. Expect correctness, engineering and lint findings with references and suggested fixes, or none.
- **Test Reviewer:** launch after unit-test or integration-test changes finish. Expect findings on test quality, coverage and duplication across the suite, or none.
- **Doc Reviewer:** launch after documentation changes finish. Expect findings on complete touched documents and missing or outdated documentation, or none.
- **Product Manager:** launch after each Task's executors and reviewers finish, again after fixes affecting product behaviour, and after the Epic's integration gate. Expect findings on requirements, scope and proportion, including incomplete work and decisions needing the Managing Intelligence.

## Writes

- **Idea and Plan:** set `active` when execution starts. Set the Plan `done` in step 4.
- **Epic:** set `active` when execution starts and `done` in step 3. Record execution progress, integration evidence and waivers. Of the end-of-Epic Product Manager findings, record only those declined, each with its reason, so idea-review sees what was left.
- **Tasks and Subtasks:** update instructions made stale by prerequisite work so executors follow the current implementation. Keep decisions, Lane assignments, checks and commits on the Task so a later Run can continue it. Record only declined or unaddressed findings, each with its reason, for idea-review. Set Tasks `active` when starting and `done` after step 2's completion conditions. Executors set their assigned Subtasks `active`, then `done`.
- **Fix Tasks:** create children of this Epic for integration failures and accepted end-of-Epic Product Manager findings, with Subtasks beneath them. Describe the repair and why it is needed so executors have its context. Start the Tasks and Subtasks `draft` and set them `defined` once their descriptions are complete, then execute and complete them through step 2. Give each Task a `thinking_level:<label>` tag suited to its complexity and risk, so executor effort matches the repair. Record Dependencies on prerequisites so execution follows the required order.

## Done

Report the Epic's ID, and any review findings left unaddressed with the reason.

- If it stopped at a Task boundary, suggest re-running develop-epic on this Epic.
- If more Epics remain, suggest the next one: write-epic if it's `draft`, otherwise develop-epic.
- If the Plan is `done`, suggest teardown-worktree for any Epic worktrees, then idea-review.

## Task pipeline

Executors change files; reviewers check them independently. develop-epic coordinates their work, judges findings and commits the result.

Run the Engineer first, then the Code Reviewer and Test Writers in parallel. After the Test Writers finish, run the Test Reviewer and Doc Writer in parallel. Follow the Doc Writer with the Doc Reviewer, then run the Product Manager after all reviews finish, so it sees the whole Task. Use the roles the work needs; every source-changing pass includes unit testing, and every Task gets its initial Product Manager check.

Judge the findings together and have the executors fix the accepted ones in one round. Resume affected executors in source → tests → documentation order so tests and documentation follow the implementation. Give the Doc Writer one pass after the round's code and tests finish. Have fresh reviewers check the repairs and repeat until accepted findings are fixed. Record only declined or unaddressed findings on the Task, each with its reason, so idea-review sees what remains. The Managing Intelligence decides product questions and conflicts with the SRD, because execution follows the defined requirements.

The last Test Writer owns the full `## Unit tests` run from `build-commands.md` for each affected code folder, skipping sections marked `none`. Assign it the Task's final full-unit-suite Subtask: the sole Writer for one Lane, or the final Writer after multiple Lanes. It runs the suite after its changes and fixes and rechecks failures. Each later source- or unit-test-changing pass has the same owner. Other executors work out targeted checks for their changes, so full suites are not repeated by every role. Route unit-test source failures through the Engineer, unit testing and review before completing the Task.

## Test Writer Lanes

A **Lane** is a group of test files one Test Writer can change independently. Adjust the Task's proposed Lanes to the implementation and record their files, behaviours, shared fixtures and helpers on the Task. Record why assignments changed so later Runs can follow them. Keep files together when they share changed setup or cover overlapping behaviour, so Writers avoid conflicting edits and duplicate coverage.

Each Lane owns its files and exclusively used fixtures and helpers, including exclusively used entries in common helper files. Writers record newly discovered shared changes and gaps outside their files on the Task for the final Writer. After multiple Lanes finish, dispatch one final Test Writer to make shared changes, close remaining gaps and run the full unit suite. A sole Writer owns all the Task's tests and helpers. The same ownership applies in fix rounds, so parallel repairs remain independent.

## Executor reuse and progress

Start fresh executors for each Task and retain them for its fix rounds, including each Lane's Test Writer and any final Test Writer. Before resuming an affected executor, read its context fraction as the Agent Protocol File describes: its latest context tokens divided by its own model's applicable context window. Resume it only below 75%. At 75% or more, when the reading is unknown, when a resume fails or when the approach changes, replace it with a fresh executor that reads the Task's progress. A nearly full context causes mistakes, while a resume costs far less than a fresh start. Reviewers and Product Managers start fresh each time for an independent assessment.

Keep the Epic's progress concise: current Task and phase, repo checkouts, integration gate and next work. On each Task, record retained executors' Roles, Lane or final-Writer assignments, Agent IDs, names if available and Thinking Levels after each report, so a later Run can resume them. Dispatches name the assigned repo checkouts so code changes land in the intended worktrees. After compaction, reconcile ticket and git state before dispatching or committing, because a summary may omit completed work.

## Integration gate

After the Epic's last Task, develop-epic runs `## Integration tests` from `build-commands.md` for every affected code folder, following `test-guide.md` and skipping sections marked `none`. Save command output to a file and read only the failures, so long suite output stays out of the skill's context. Record each command, its exit status and the output file on the Epic as evidence. Send failures caused by tests to a Test Writer; source failures become fix Tasks through the Task pipeline.

The gate passes when every affected code folder's Integration Tests pass or its section says `none` with a reason, or the Managing Intelligence explicitly waives the remaining failures. Record evidence and waivers on the Epic and keep it `active` until the gate passes, so completion reflects the integration result.

After a Test Writer repairs tests, get a fresh Test Reviewer check because the tests changed after the Task's review. Have the Test Writer resolve accepted findings, then rerun the affected Integration Tests in develop-epic. Apply step 2's pre-commit checks to these repairs before committing, so the evidence covers the reviewed and committed tests.

For source failures within the Epic's scope, create integration fix Tasks with outcomes, acceptance criteria and prerequisites. Complete recorded draft repairs before executing them so interrupted planning can resume. Each Subtask names its executor and has Context, What Needs to Change, Key Files and Acceptance Criteria sections, so repairs are as executable as the original work. Include the unit and integration coverage `test-guide.md` requires, the final full-unit-suite Subtask, affected documentation and Test Writer Lanes.

Execute the fix Tasks through the full Task pipeline in Dependency order. After all fixes are committed and their Tasks are `done`, rerun Integration Tests in develop-epic over the combined repairs, so the result covers their interactions.

If a failure an earlier fix Task was meant to fix persists, stop for the Managing Intelligence's decision, so failed repairs do not become an automatic loop. If suites cannot run, stop for the environment to be fixed or a waiver. Record the unfinished gate so a later Run resumes there.

A result or waiver applies to the files it covered. Further source or integration-test changes need a new result or explicit waiver, so the Epic is accepted against its final implementation.
