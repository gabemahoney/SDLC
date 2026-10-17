---
name: develop-epic
description: "Build, review and commit one Epic's Tasks and pass its integration gate, resuming from recorded progress when needed."
---

# develop-epic

## Purpose

Builds one Epic's planned work through executors and independent reviewers. Commits the completed Tasks and checks their integration before handing the Epic back to the Managing Intelligence.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

An Epic ID.

## Required Reading

- **Settings:** Project and default settings, resolved as `workflow.md` describes, for this Run's configuration.
- **Agent Protocol File:** `agent-claude-code.md` or `agent-codex.md` under `~/.apiary/system/protocols/`, for the Main Agent's own context readings and skill invocation.
- **Launcher Protocol File:** `launcher.md`, selected as `workflow.md` describes, for Child Agent operations and context readings.
- **Ticket System Protocol File:** selected by `ticket_system` as `workflow.md` describes, to read requirements and progress, and record results, fix Tasks, Dependencies and statuses.
- **Epic, its Tasks and Subtasks, Plan and sibling Epics:** to follow Dependencies, resume unfinished work and check Plan completion.
- **Idea and its Docs:** through the Plan's Association to its Idea. Why: to follow the PRD, SRD and decisions recorded on the tickets they concern.
- **Guidance Documents:** `engineering-best-practices.md`, `test-guide.md`, `doc-writing-guide.md`, `build-commands.md` and `release-guide.md` for each affected repo, found as `workflow.md` describes, to judge findings, plan repairs, check builds and tests, and handle documentation, commits and pushing.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when all of these are true:

- The Epic is `defined` or `active`, or is `done` and needs only the Plan completion check in step 4. Otherwise, stop and suggest write-epic.
- Every Epic it depends on is `done`. Otherwise, stop and report the unfinished Dependency.
- Its Plan is `defined` or `active`, or is `done` for a completed Epic's handoff. Otherwise, stop and suggest write-plan.
- The Idea's PRD and SRD are `defined`, because execution follows approved requirements. Otherwise, stop and return the requirements to the Managing Intelligence.
- The Epic has planned Tasks with Subtasks. Every unfinished Task and Subtask is `defined` or `active`, except `draft` fix Tasks and their Subtasks, whose planning this skill resumes so interrupted repairs can continue. Otherwise, stop and suggest write-epic to finish planning.

## Steps

1. **Start or resume.** For a completed Epic, go to step 4. Otherwise set the Idea, Plan and Epic `active`. Reconcile recorded progress with tickets and git so completed work is not repeated. Reopened Tasks remain unfinished even if an earlier version was committed.

2. **Complete Tasks in Dependency order, one at a time.**
   - Before each Task, including fix Tasks, check the Plan and apply the shared Main Agent Context rule. Stop if the Plan returned to `draft`, because an SRD revision paused execution.
   - Update instructions made stale by earlier Tasks' code, then set the Task `active` and follow the Task pipeline.
   - Once Subtasks are `done` and accepted findings are fixed, require passing Compile, Lint and the full Unit Tests for every affected code folder. Use `build-commands.md`, skipping only sections marked `none` with a reason. The final `test-writer` owns the unit run. Route failures through the Task pipeline and repeat affected checks after repairs, so the evidence covers the completed work.
   - Commit only after all three checks pass, then set the Task `done`.

3. **Finish the Epic.** After all Tasks, run the Integration gate once for their combined work. Then launch `product-manager`. Turn accepted findings into fix Tasks and complete them through step 2. Rerun integration after all repairs, rather than between Tasks, so it checks the completed Epic.

   Reuse an earlier gate result or waiver only if its files are unchanged. Re-check the Plan before completion; if it is `draft`, record progress and stop for write-plan. Otherwise set the Epic `done` once all Tasks, accepted findings and the Integration gate are complete.

4. **Check Plan completion.** Set the Plan `done` when every Epic is `done`. Record remaining Epics or the handoff to teardown-worktree, then idea-review after merging.

## Child Agents

- **`engineer`:** Start fresh for each Task and reuse it for fix rounds to preserve its knowledge. Launch for source changes, including integration fixes. Expect implementation, targeted checks and any deviations or effects on design and documentation.
- **`test-writer`:** Start fresh for each Task and reuse it for fix rounds to preserve its knowledge. Launch for testing Subtasks after their source changes, one per Lane and a final writer after multiple Lanes, and for integration failures caused by tests. Expect unit and integration coverage following `test-guide.md`, fixture changes, test repairs, remaining gaps and assigned test results.
- **`doc-writer`:** Start fresh for each Task and reuse it for fix rounds to preserve its knowledge. Launch when source and testing Subtasks finish and documentation is affected. Expect updates following `doc-writing-guide.md`, including gaps found in the implementation.
- **`code-review`:** Start fresh every time so each assessment is independent. Launch after source changes, alongside `test-writer` Child Agents. Expect correctness, engineering and lint findings with references and suggested fixes, or none.
- **`test-review`:** Start fresh every time so each assessment is independent. Launch after unit-test or integration-test changes finish. Expect findings on test quality, coverage and duplication across the suite, or none.
- **`doc-review`:** Start fresh every time so each assessment is independent. Launch after documentation changes finish. Expect findings on complete touched documents and missing or outdated documentation, or none.
- **`product-manager`:** Start fresh every time so each assessment is independent. Launch after each Task's executors and reviewers finish, again after fixes affecting product behaviour, and after the Epic's integration gate. Expect findings on requirements, scope and proportion, including incomplete work and decisions needing the Managing Intelligence.

Record executor IDs, skills, testing assignments and Thinking Levels on the Task after reports so another Run can continue.

## Writes

- **Idea and Plan:** set `active` at execution start; set the Plan `done` in step 4.
- **Epic:** set `active` at start and `done` in step 3. Keep the current Task and phase, checkout paths, integration evidence, waivers and next work here.
- **Tasks and Subtasks:** update stale instructions. Record decisions, Lane assignments, checks and commits on the Task. Set it `active` at start and `done` after commit. Executors set assigned Subtasks `active`, then `done`.
- **Fix Tasks:** create Epic children for source integration failures and accepted final product findings, with repair Subtasks. Start them `draft`, then set them `defined` when planning is complete. Include outcomes, acceptance criteria, Dependencies, a complexity-appropriate `thinking_level:<label>` tag and Subtasks with Context, What Needs to Change, Key Files and Acceptance Criteria. Plan required coverage, a final full-unit-suite Subtask, affected docs and Testing Lanes so repairs receive the original work's checks.

Keep only declined or unaddressed findings with reasons, under the shared rule.

## Done

Report the Epic's ID, and any review findings left unaddressed with the reason.

- If it stopped at a Task boundary, suggest re-running develop-epic on this Epic.
- If more Epics remain, suggest the next one: write-epic if it's `draft`, otherwise develop-epic.
- If the Plan is `done`, suggest teardown-worktree for any Epic worktrees, then idea-review.

## Task pipeline

Executors change files; reviewers check them independently. develop-epic judges findings and commits.

Run engineer first; code-review and test-writer in parallel; then test-review and doc-writer in parallel; then doc-review. Use the work's applicable executors and reviewers, followed by product-manager for every Task so it sees the combined result. Repeat product review after fixes affecting behaviour.

Group accepted findings into repair rounds. Resume affected executors in source → tests → documentation order; give doc-writer one pass after the round's code and tests. Reviewers check repairs. Repeat until accepted findings are fixed. Product questions and conflicts with the SRD go to the Managing Intelligence because execution follows approved requirements.

Assign the final full-unit-suite Subtask to the sole test-writer or a final writer after multiple Lanes. It runs `## Unit tests` after the combined changes and any later source or unit-test repairs. Route source failures through engineer, testing and review; the writer fixes test failures. Other executors run targeted checks so each does not repeat the full suite. Ensure a final writer owns the unit check even for a Task with no test edits, because every Task commit has the same gate.

## Testing Lanes

A **Lane** is a group of test files one test-writer can change independently. Adjust proposed Lanes to the implementation and record their files, behaviours, fixtures and helpers on the Task, with reasons for changes. Keep overlapping behaviour and changed shared setup together to avoid conflicts and duplicate coverage.

Each Lane owns whole files and exclusively used setup. Writers record shared changes or gaps for a final test-writer after all Lanes finish. That writer changes shared files, closes gaps and runs the full unit suite. A sole writer owns all tests and helpers. Keep the same ownership during repairs.

## Integration gate

develop-epic runs `## Integration tests` for every affected code folder after the Epic's Tasks, following `test-guide.md`. Skip sections marked `none` with a reason. Save output to a file and read only failures so suite output stays out of context. Record commands, exit statuses and output paths on the Epic.

The gate passes when required suites pass or the Managing Intelligence explicitly waives remaining failures. Keep the Epic `active` until then. If suites cannot run, stop for environment repair or a waiver.

Route test failures to test-writer, then test-review. Apply the Task's Compile, Lint and full-unit checks before committing repairs. Route source failures into fix Tasks through the full Task pipeline. Finish draft repair planning before execution so interrupted work resumes safely. After all repairs are committed, rerun integration over their combined result.

If a failure persists after its fix Task, stop for the Managing Intelligence's decision so failed repairs cannot become an automatic loop. Record the unfinished gate. Results and waivers cover only the files checked; later changes require a new result or waiver.
