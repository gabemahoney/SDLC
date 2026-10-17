---
name: develop-epic
description: "Build one Epic's Tasks, review and commit the work, and pass its integration gate, resuming from recorded progress when needed."
---

# develop-epic

## Purpose

Follows write-epic and executes one Epic. It coordinates executors and independent reviewers, then hands completed work back to the Managing Intelligence. Once the Plan is done and its work merged, idea-review checks the whole Idea.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

An Epic ID.

## Required Reading

- **Workflow:** `~/.apiary/system/workflow.md`. Why: to follow the shared Run rules.
- **Settings files:** `<Project Folder>/.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`. Why: to select the Ticket System Protocol File through `ticket_system`, and map Task tags and the reviewers', Product Manager's and Integration Tester's `thinking_levels` through `levels_claude_code` or `levels_codex`.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` in Claude Code, or `~/.apiary/system/protocols/agent-codex.md` in Codex CLI. Why: to dispatch and resume Subagents, read context use and its freshness window, and ask and report through the Agent.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: to read requirements, dependencies and progress, and write execution results, fix Tasks and statuses.
- **Epic, its Tasks and Subtasks, Plan and sibling Epics:** through the Ticket System Protocol File, using the input Epic ID. Why: to establish readiness, follow dependencies, read Task tags, lane plans and integration flags, resume unfinished work and check Plan completion.
- **Idea and its Docs:** through the Idea reference on the Plan and the Ticket System Protocol File. Why: to follow the PRD, SRD and decisions recorded on the tickets they concern.
- **Repo checkouts and changes:** the affected repos under `<Project Folder>`, or their worktrees at `<Project Folder>/.worktrees/<ticket id>/<repo path>`. Why: to reconcile planned work with completed dependencies, verify the work being committed and resume from actual git state.
- **Guidance Documents:** `engineering-best-practices.md`, `test-guide.md`, `doc-writing-guide.md`, `maintained-docs.md`, `build-commands.md` and `release-guide.md` for each affected code folder, found as `workflow.md` describes. Include the documents `maintained-docs.md` lists. Why: to judge findings, define integration fixes, check required build and test results, identify documentation affected by changes, and commit and push as permitted.
- **Subagent reports and Epic progress:** reports returned during execution and the progress recorded on the Epic. Why: to coordinate reviews and fixes and recover the unfinished phase and retained executors.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when all of these are true:

- The Epic is `defined` or `active`. If it is `draft`, stop and suggest write-epic. A `done` Epic may only finish the Plan completion check in step 4.
- Every Epic it depends on is `done`. If any isn't, stop and report the dependency.
- Its Plan is `defined` or `active`. If it is `draft`, stop and suggest write-plan. For a `done` Epic's completion check, a `done` Plan is also valid.
- The Epic has Tasks with Subtasks, and every unfinished Task and Subtask is `defined` or `active`. If planning is incomplete, stop and return it to the Managing Intelligence for write-epic.

## Steps

1. **Establish the work to resume.** Reconcile the Epic's progress with ticket and git state. Update stale paths and descriptions in its unfinished work to reflect completed dependencies, while following the SRD's settled choices. Name each affected repo and checkout in dispatches. Set the Idea, Plan and Epic `active` when starting work.

2. **Complete Tasks in dependency order.** Before each Task, including an integration fix Task, re-check the Plan. If it returned to `draft`, record progress and stop at that boundary for replanning. Before each Task after the first in this Run, check context use through the Agent Protocol File. At 75% or more, or with a reading older than its freshness window, record progress and stop, naming `develop-epic <epic-id>` in a fresh session. The Managing Intelligence arranges the restart. With no reading, continue and report that it was unavailable.

   a. **Execute and review.** Set the Task `active`. Follow the Task pipeline below, using its Subtasks, acceptance criteria and `thinking_level:<label>` tag.

   b. **Commit the Task.** Once its Subtasks are `done`, accepted findings are resolved and required checks pass, commit its changes. If the Task has a `## Run Integration After This Task` section, run the Integration gate below before setting it `done`. For the Epic's last Task, use the end-of-Epic run for this same gate. Otherwise, set the Task `done` after its commit.

3. **Finish integration and the Epic check.** After the last Task's commit, run the Integration gate unless its current changes already passed that gate or received a waiver. Once integration passes or is waived, get the Product Manager's end-of-Epic check against the requirements and all completed Tasks. Record its report on the Epic for idea-review. It informs idea-review rather than blocking the Epic. Set the Epic `done` when all its Tasks are `done` and the integration gate is met.

4. **Check Plan completion and hand off.** If every Epic in the Plan is `done`, set the Plan `done`. Record the Epic's final progress and report the next work to the Managing Intelligence.

## Dispatches

- **Engineer:** launch for a Task's source changes, including integration fixes. Expect the implementation, its checks, deviations and changes affecting design or documentation.
- **Test Writer:** launch after source changes settle, or for unit-test work, one per Lane and a final Writer after multiple Lanes. Expect unit-test coverage, fixture changes, remaining gaps and assigned test results.
- **Doc Writer:** launch after code and tests settle when documentation is affected. Expect updates to the maintained user, contributor and design documents, including gaps found in the actual changes.
- **Code Reviewer:** launch after source changes, while Test Writers work. Expect findings on correctness, engineering guidance and lint results, with references and suggested fixes, or no findings.
- **Test Reviewer:** launch after the Test Writers finish when unit tests changed, while the Doc Writer works. Also launch after integration-test changes settle. Expect findings on test quality, coverage and duplication across the suite, or no findings.
- **Doc Reviewer:** launch after documentation changes settle. Expect findings on complete touched documents and missing or outdated documentation, or no findings.
- **Product Manager:** launch last in each Task's initial review, after the executors and reviewers finish. Repeat after fixes affecting product behaviour. Launch again after the Epic's integration gate. Expect a requirements, scope and proportion check, with incomplete work and decisions needing the Managing Intelligence.
- **Integration Tester:** launch on the settled changes at each integration gate. Expect integration tests written or updated as needed, test-side fixes and a result for each affected repo: `passed`, `source failures`, `could not run` or `no suites found`, with commands and failure evidence.

## Writes

- The Idea and Plan become `active` when Epic work starts. The Plan becomes `done` when all its Epics are `done`.
- The Epic becomes `active`, then `done` after step 3. It holds progress, commits, integration results and waivers, retained executor records, unacted-on findings and the end-of-Epic Product Manager report.
- Unfinished Task and Subtask descriptions are reconciled with completed dependencies. Tasks become `active`, then `done` after their Subtasks, reviews, checks, commits and any flagged integration gate finish. Executors set their own Subtasks `active`, then `done`.
- Integration fix Tasks and their Subtasks are created `draft` in this Epic, then set `defined` when written. Each fix Task receives a `thinking_level:<label>` tag and follows the same execution statuses.
- Executors and the Integration Tester change files in the assigned repo checkouts. develop-epic commits their work and records findings and Managing Intelligence decisions on the tickets they concern.

## Done

Report the Epic and Plan statuses, completed Tasks and commits per repo, integration results or waivers, the Product Manager's end-of-Epic result, and incomplete work or decisions needed. Identify the Epic record holding unacted-on findings. Report changes to planned Lanes and their reasons.

- If stopping at a Task boundary, name the unfinished phase and the re-run needed.
- If more Epics remain, identify the next ready work for write-epic or develop-epic.
- If the Plan is `done`, suggest merging any Epic worktrees through teardown-worktree from outside them, then idea-review once they are merged.

## Task pipeline

Executors do the file work; reviewers provide independent checks. The skill coordinates their reports, decides which findings need action and commits the result.

Run the Engineer first. After it finishes, start the Code Reviewer and Test Writers in parallel. After the last Test Writer finishes, start the Test Reviewer and Doc Writer in parallel. After the Doc Writer finishes, start the Doc Reviewer. Run the Product Manager after all of them finish. Skip roles whose work is unaffected, except that every source-changing pass has a Test Writer and every Task gets its initial Product Manager check.

Collect all findings before one batched fix round. Resume each affected executor once, in the same source → unit tests → documentation order. Include accepted findings and the preceding executors' reports. Batch all documentation changes into that round's single Doc Writer pass. Re-review changed work with fresh reviewers using the same pipeline, and repeat for findings still worth fixing. Record unacted-on findings and their reasons on the Epic for idea-review. A product decision or conflict with the SRD goes to the Managing Intelligence and is recorded on the affected ticket.

The last Test Writer owns the full unit-suite run in every affected repo with unit tests: the sole Writer for one Lane, or the final Writer after multiple Lanes. Assign it the Task's final full-unit-suite Subtask. It runs the suite once after its changes and fixes and rechecks failures. Each later source- or unit-test-changing pass has the same owner. Other roles use targeted checks; the Integration Tester owns integration-suite runs. Route source failures from unit tests to the Engineer, then back through unit testing and review before completing the Task.

## Test Writer Lanes

A **Lane** is a group of unit-test files one Test Writer can change independently of the other Test Writers for the Task. Start from the Task's `## Test Writer Lanes` suggestions and adjust them to the actual implementation. Record the reason for a different grouping. Keep files together when they share a fixture or helper the Task creates or changes, or cover overlapping behaviour.

Give each Lane its Subtasks, test files and behaviours, the other Lanes' files and behaviours, and the shared fixture/helper list. Each Lane owns its files and exclusively used fixtures and helpers, including exclusively used entries in common helper files. Newly discovered shared changes and gaps outside its files go in its report for the final Writer.

After multiple Lanes finish, dispatch one final Test Writer with all their reports to make shared changes and close remaining gaps. The final suite Subtask follows the parallel Lanes. A sole Writer owns all the Task's tests and helpers. Apply the same rule to a fix round using multiple Lanes.

## Executor reuse and progress

Start a fresh Engineer, Test Writer per Lane and Doc Writer for each Task as their work requires; retain them for that Task's fix rounds. Retain the final Test Writer too when multiple Lanes need one. Resume only the executors affected by a round. They keep their Guidance Documents and add those for newly assigned repos. If an executor cannot continue, replace it with a fresh one carrying the findings and work so far. Reviewers, Product Managers and Integration Testers start fresh on every dispatch.

On the Epic, maintain a concise progress record with the current Task and phase, repo checkouts and commits, pending findings, integration gate and results, and the next work. For each retained executor, record its Role, Task, Lane or final-Writer assignment, Agent ID, name if available and dispatch Thinking Level. Update it after each report. After compaction or a re-run, resume recorded executors by name if available, otherwise by ID, using ticket and git state to resolve disagreements with progress notes.

## Integration gate

Run the Integration Tester across the affected repos on settled code, unit tests and documentation. The gate passes when each repo reports `passed` or `no suites found`, or the Managing Intelligence explicitly waives its remaining failures. Record the evidence and any waiver on the Epic and the flagged Task. Keep the Epic and any gated Task `active` until then. Commit integration-test changes for this gate before setting its gated Tasks `done` and proceeding to the next planned Task.

- If integration tests change, get a Test Reviewer check, because these changes follow the Task's test review. Resolve accepted test findings with a fresh Integration Tester and record a final suite result for the resulting files before accepting the gate.
- If source fixes are needed, group the failures into fix Tasks in this Epic. Describe each Task's outcome, acceptance criteria and dependencies. Give its Subtasks an executor and the same Context, What Needs to Change, Key Files and Acceptance Criteria sections write-epic supplies. Include unit coverage and the final full-unit-suite Subtask, documentation where affected, lane suggestions and interface flags. Set a Thinking Level suited to each Task's complexity and risk. Save them `draft`, then `defined`, and execute them through the full Task pipeline.
- Run the fix Tasks in dependency order, then run the Integration gate once over all of them, so it checks the combined repair. Tasks waiting on the gate stay `active` until it passes.
- If a failure an earlier fix Task was meant to fix still stands, stop for the Managing Intelligence's decision. If suites cannot run, stop for the environment to be fixed or a waiver. Record the failure and unfinished gate so a later Run resumes there.

Integration results apply to the changes tested. Further source or integration-test changes need a new result. Integration fixes that affect documentation go through the Task's documentation pass and review before completion.
