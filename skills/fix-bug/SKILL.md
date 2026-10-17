---
name: fix-bug
description: "Fix a defined Bug, prove the regression is covered, review and merge the repair, and hand it back for acceptance. Takes a Bug ID."
---

# fix-bug

## Purpose

Follows define-bug and takes a confirmed Bug through implementation, review, testing and merge. The Managing Intelligence checks the merged fix and accepts or returns it.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

A Bug ID.

## Required Reading

- **Workflow:** `~/.apiary/system/workflow.md`. Why: to follow the shared Run rules.
- **Settings files:** `<Project Folder>/.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`. Why: to select the Ticket System Protocol File through `ticket_system` and map the Bug's executor tag and the reviewers' `thinking_levels` through `levels_claude_code` or `levels_codex`.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` in Claude Code, or `~/.apiary/system/protocols/agent-codex.md` in Codex CLI. Why: to dispatch and resume Subagents and ask and report through the Agent.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: to read the Bug and its dependencies and record execution evidence, decisions and status.
- **The Bug and its Dependencies:** through the Ticket System Protocol File, using the input ID. Why: to read the confirmed behaviour, retained reproduction, `thinking_level:<label>` tag, progress and Managing Intelligence decisions, including why an earlier fix was returned.
- **Guidance Documents:** `engineering-best-practices.md`, `test-guide.md`, `doc-writing-guide.md`, `build-commands.md` and `release-guide.md` for each affected repo, found as `workflow.md` describes. Why: to judge findings, check the fix and affected documentation, and commit, merge and push as permitted.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when all of these are true:

- The Bug is `defined`, or `active` when resuming. If it is `draft`, stop and suggest define-bug. For any other status, stop and report it.
- Every ticket the Bug depends on is `done`, so the repair uses completed prerequisites. If any isn't, stop and report the blocking ticket IDs.
- The Run starts outside `<Project Folder>/.worktrees/`, because it merges and removes its own worktrees. If it starts inside, stop and say to run from the Project Folder.

## Steps

1. **Prepare or resume the repair.** Set the Bug `active` when work starts. Use an isolated Bug worktree for each affected repo to keep concurrent work separate, based on its main checkout's current branch. Record worktree paths, base revisions and merge targets on the Bug. Resume from its progress and actual git state, including unfinished merges and cleanup. For a returned fix, address the revised write-up against current code, because the earlier merge predates the new evidence.

2. **Implement and review the fix.** Record Test Writer Subtasks on the Bug for the unit and integration coverage `test-guide.md` requires, so regression tests are written and reviewed with the repair. Follow the Repair pipeline and Regression evidence guidance below. Judge review findings and record each disposition and reason on the Bug. The Managing Intelligence decides expected behaviour because the defined Bug is the repair's requirements.

3. **Prove the repair.** After implementation and review finish, pass the Integration gate below. Rerun the Bug's retained reproduction against the repaired worktrees with the same inputs and setup, to check the reporter's exact symptom.
   - If the symptom remains, route it through the repair pipeline.
   - If the reproduction can't run or validation relied on source inspection, the Managing Intelligence decides how to verify the fix. Record that decision and its evidence on the Bug.

4. **Commit and merge.** Once accepted findings are resolved, regression evidence is complete, the reproduction or agreed verification shows the expected behaviour, required checks pass and the integration gate is met, commit the Bug's changes. Merge each worktree into its recorded target from the main checkout. If the target changed or conflict resolution changed the repair, review and check the resulting source before cleanup, because the worktree evidence predates those changes. Record successful merges, then remove the merged worktrees and branches. Leave the Bug `active` for the Managing Intelligence's acceptance.
   - If a merge conflicts, preserve that worktree and record the conflicting files and completed merges. Stop for resolution; a later Run resumes the unfinished merge, verification and cleanup.

## Dispatches

- **Engineer:** launch for source changes. Expect the implementation, targeted checks, deviations and changes affecting design or documentation.
- **Test Writer:** launch for testing Subtasks and after every source-changing pass, one per Lane and a final Writer after multiple Lanes. Expect unit and integration tests, before-and-after regression evidence, fixture changes, gaps and assigned test results. Dispatch a fresh Test Writer for the Integration gate to keep suite output out of this skill's context. Expect a result per affected repo with commands and evidence.
- **Doc Writer:** launch after source and testing Subtasks finish to assess and update documentation following `doc-writing-guide.md`. Resume when review findings or repairs affect documentation. Expect changes or a reason none are needed.
- **Code Reviewer:** launch after source changes, while Test Writers work. Expect correctness, engineering and lint findings with references and suggested fixes, or no findings.
- **Test Reviewer:** launch after testing Subtasks finish, while the Doc Writer works, and after test repairs from the Integration gate. Expect findings on test quality, regression coverage and duplication across the suite, or no findings.
- **Doc Reviewer:** launch after the Doc Writer finishes. Expect findings on complete touched documents and documentation missing or made outdated by the fix, or no findings.

## Writes

The Bug is the only ticket changed. Set it `active` when work starts and leave it `active` after merge, because the Managing Intelligence accepts the fix. Record Test Writer Subtasks and their progress, reproduction and regression evidence, review findings and decisions, checks, integration results and waivers, commits and merges on the Bug so a later Run can continue the repair.

## Done

Report the Bug's ID, and any review findings left unaddressed with the reason.

Suggest the Managing Intelligence check the fix: they set the Bug `done` on acceptance, or return it to `draft` for define-bug.

## Repair pipeline

Executors change files; reviewers check them independently. fix-bug coordinates their work, judges findings and commits the result.

Run the Engineer first, then the Code Reviewer and Test Writers in parallel. After the Test Writers finish, run the Test Reviewer and Doc Writer in parallel, then the Doc Reviewer. Use the roles the work needs, with a Doc Writer assessment for every Bug so documentation gaps are checked even when source behaviour is restored.

Collect findings before a fix round so executors address them together. Resume affected executors in source → tests → documentation order, so coverage and documentation follow the repair. Give the Doc Writer one pass after the round's source and tests finish. Re-review changed work with fresh reviewers and repeat for findings worth fixing.

The sole Test Writer, or final Writer after multiple Lanes, runs the full unit suite in each affected repo with unit tests. It fixes failures caused by tests and rechecks them. Include this run after every source- or unit-test-changing pass so later repairs are tested too. Route source failures through the Engineer, unit testing and review. Other roles use targeted checks so every role does not repeat the full suite.

## Regression evidence

The Test Writer preserves an automated regression test at the boundary where the defect occurs, using unit coverage or integration coverage for interacting components as `test-guide.md` describes. It records failing-before and passing-after results, commands, revisions and coverage limits on the Bug, because a passing test alone does not prove it catches the regression. If automated coverage is impractical, the Managing Intelligence decides what repeatable verification is sufficient. Record that decision and evidence on the Bug so acceptance uses the agreed check.

## Test Writer Lanes

A **Lane** is a group of test files one Test Writer can change independently. Group the Bug's affected files by the behaviours they cover and the fixtures or helpers they change, so parallel Writers avoid conflicting edits and duplicate coverage.

Record Lane assignments, covered behaviours and shared fixtures or helpers on the Bug so Writers can follow their boundaries. Each Lane owns its files and exclusively used setup, including entries in common helper files. Writers record shared changes and coverage gaps on the Bug for a final Test Writer, which makes those changes and runs the full unit suite after all Lanes finish. A sole Writer owns all the Bug's tests and helpers. Keep this ownership in fix rounds so parallel repairs stay independent.

## Executor reuse and progress

Retain the repair's executors for fix rounds, including any final Test Writer, so repairs reuse their knowledge. Replace unavailable executors with fresh ones reading the Bug's progress. Start reviewers fresh each time for an independent assessment.

Keep the current phase, next work and integration repair-round count on the Bug. Record retained executors' Roles, Lane or final-Writer assignments, Agent IDs, names if available and Thinking Levels so a later Run can resume them.

## Integration gate

After the repair's implementation and review finish, dispatch a fresh Test Writer for one integration run across every affected repo, following `test-guide.md` and `build-commands.md`. It fixes only failures caused by the tests themselves, leaving source repairs to the Repair pipeline. It reports `passed`, `source failures`, `could not run` or `no suites found` for each repo, with commands and evidence.

The gate passes when every affected repo reports `passed` or `no suites found`, or the Managing Intelligence explicitly waives its remaining failures. Record results and waivers on the Bug so acceptance and later Runs have the evidence.

- If the run changes tests, get a fresh Test Reviewer check because those repairs follow the earlier review. Have the Test Writer resolve accepted findings and rerun the affected suites so the result covers the reviewed tests.
- If source fixes are needed, pass the failures through the Repair pipeline, then dispatch a fresh Test Writer for one run over the combined repairs. Stop for the Managing Intelligence's decision if a round does not reduce failures or failures remain after three source-fix rounds, to bound unsuccessful repair attempts.
- If suites cannot run, stop for the environment to be fixed or an explicit waiver. Keep the unfinished gate and evidence on the Bug so a later Run resumes there.

Results and waivers apply to the files they covered. Further source or integration-test changes need a new result or explicit waiver; source changes also need the regression and reproduction or agreed verification checked again, so the evidence covers the final repair.
