---
name: fix-bug
description: "Fix a defined Bug, prove the regression is covered, review and merge the repair, and hand it back for acceptance. Takes a Bug ID."
---

# fix-bug

## Purpose

Follows define-bug and takes a confirmed Bug through implementation, review, testing and merge. The Managing Intelligence checks the merged fix and accepts or returns it.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

A Bug ID.

## Required Reading

- **Settings:** Project and default settings, resolved as `workflow.md` describes, for this Run's configuration.
- **Agent Protocol File:** `agent-claude-code.md` or `agent-codex.md` under `~/.apiary/system/protocols/`, for the Main Agent's own context readings and skill invocation.
- **Launcher Protocol File:** `launcher.md`, selected as `workflow.md` describes, for Child Agent operations and context readings.
- **Ticket System Protocol File:** selected by `ticket_system` as `workflow.md` describes, to read the Bug and its dependencies and record execution evidence, decisions and status.
- **The Bug and its Dependencies:** to read the confirmed behaviour, retained reproduction, `thinking_level:<label>` tag, progress and Managing Intelligence decisions, including why an earlier fix was returned.
- **Guidance Documents:** `engineering-best-practices.md`, `test-guide.md`, `doc-writing-guide.md`, `build-commands.md` and `release-guide.md` for each affected repo, found as `workflow.md` describes, to judge findings, check the fix and affected documentation, and commit, merge and push as permitted.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when all of these are true:

- The Bug is `defined`, or `active` when resuming. If it is `draft`, stop and suggest define-bug. For any other status, stop and report it.
- Every ticket the Bug depends on is `done`, so the repair uses completed prerequisites. If any isn't, stop and report the blocking ticket IDs.
- The Run starts outside `<Project Folder>/.worktrees/`, because it merges and removes its own worktrees. If it starts inside, stop and say to run from the Project Folder.

## Steps

1. **Prepare or resume.** Set the Bug `active`. Create an isolated Bug worktree for each affected repo from its main checkout's current branch, using the workflow's worktree path. Record paths, bases and merge targets. Reconcile progress with git, including unfinished merges and cleanup. A returned fix follows the revised Bug against current code.

2. **Implement and review.** Record testing assignments in the Bug body for the coverage `test-guide.md` requires. Follow the Repair pipeline and Regression evidence guidance. Judge findings under the shared rule. The Managing Intelligence settles expected behaviour because the defined Bug is the repair's requirements.

3. **Prove the repair.** Pass the Integration gate after implementation and review. Rerun the retained reproduction with its original inputs and setup. Route a remaining symptom through the Repair pipeline. If reproduction cannot run or validation used source inspection, the Managing Intelligence decides sufficient verification; record the decision and evidence.

4. **Commit and merge.** Require fixed accepted findings, complete regression evidence, successful reproduction or agreed verification, and a passed integration gate. Run Compile and Lint from `build-commands.md` for every affected code folder; the final test-writer's full Unit Tests must also pass for the completed repair. Skip only sections marked `none` with a reason. Route failures through the Repair pipeline and repeat affected checks before committing, so evidence covers the final files.

   Merge from the main checkouts into the recorded targets. If a target or conflict resolution changes the repair, review and check the combined result before cleanup because earlier evidence no longer covers it. Record successful merges, then remove merged worktrees and branches. Leave the Bug `active` for acceptance. If a merge conflicts, preserve its worktree, record conflicts and completed merges, and stop for resolution; a later Run resumes there.

## Child Agents

- **`engineer`:** Start fresh for each Bug repair and reuse it for fix rounds to preserve its knowledge. Launch for source changes. Expect the implementation, targeted checks, deviations and changes affecting design or documentation.
- **`test-writer`:** Start fresh for each Bug repair and reuse it for fix rounds to preserve its knowledge. Launch for testing assignments and after every source-changing pass, one per Lane and a final writer after multiple Lanes, and for integration failures caused by tests. Expect unit and integration tests, before-and-after regression evidence, fixture changes, test repairs, gaps and assigned test results.
- **`doc-writer`:** Start fresh for each Bug repair and reuse it for fix rounds to preserve its knowledge. Launch after source and testing assignments finish to assess and update documentation following `doc-writing-guide.md`. Include review findings or repairs that affect documentation. Expect changes or a reason none are needed.
- **`code-review`:** Start fresh every time so each assessment is independent. Launch after source changes, while `test-writer` Child Agents work. Expect correctness, engineering and lint findings with references and suggested fixes, or no findings.
- **`test-review`:** Start fresh every time so each assessment is independent. Launch after testing assignments finish, while the `doc-writer` works, and after test repairs from the Integration gate. Expect findings on test quality, regression coverage and duplication across the suite, or no findings.
- **`doc-review`:** Start fresh every time so each assessment is independent. Launch after the `doc-writer` finishes. Expect findings on complete touched documents and documentation missing or made outdated by the fix, or no findings.

Record the current phase, next work, integration repair-round count and executor IDs, skills, testing assignments and Thinking Levels on the Bug so later Runs can resume.

## Writes

The Bug is the only ticket changed. Set it `active` at start and leave it `active` after merge for the Managing Intelligence's acceptance. Keep testing assignments, progress, decisions, reproduction and regression evidence, check results, waivers, commits and merges on it. Apply the shared finding-record rule.

## Done

Report the Bug's ID, and any review findings left unaddressed with the reason.

Suggest the Managing Intelligence check the fix: they set the Bug `done` on acceptance, or return it to `draft` for define-bug.

## Repair pipeline

fix-bug coordinates executors and independent reviewers and owns commits. Run engineer first; code-review and test-writer in parallel; then test-review and doc-writer in parallel; then doc-review. Use the skills the repair needs, including doc-writer assessment for every Bug so restored behaviour does not hide documentation gaps.

Group accepted findings into repair rounds. Resume affected executors in source → tests → documentation order. Give doc-writer one pass after source and tests finish; reviewers check repairs. Repeat until accepted findings are fixed.

The sole test-writer or final writer after multiple Lanes owns the full `## Unit tests` run for every affected code folder. Run after the combined changes and later source or unit-test repairs, skipping sections marked `none`. The writer fixes test failures; source failures return through engineer, testing and review. Other executors run targeted checks so they do not each repeat the full suite.

## Regression evidence

The `test-writer` preserves an automated regression test at the boundary where the defect occurs, using unit coverage or integration coverage for interacting components as `test-guide.md` describes. It records failing-before and passing-after results, commands, revisions and coverage limits on the Bug, because a passing test alone does not prove it catches the regression. If automated coverage is impractical, the Managing Intelligence decides what repeatable verification is sufficient. Record that decision and evidence on the Bug so acceptance uses the agreed check.

## Testing Lanes

A **Lane** is a group of test files one test-writer can change independently. Record each Lane's files, behaviours, fixtures and helpers on the Bug. Group overlapping behaviour and changed shared setup together to avoid conflicting edits and duplicate coverage.

Each Lane owns whole files and exclusively used setup. Writers record shared changes and gaps for a final test-writer after all Lanes finish. That writer changes shared files, closes gaps and runs the full unit suite. A sole writer owns all tests and helpers. Keep this ownership during repairs.

## Integration gate

After implementation and review, fix-bug runs `## Integration tests` for every affected code folder, following `test-guide.md`. Skip sections marked `none` with a reason. Save output to a file and read only failures so suite output stays out of context. Record commands, exit statuses and output paths on the Bug.

Required suites pass or the Managing Intelligence explicitly waives remaining failures. Record waivers; if suites cannot run, stop for environment repair or a waiver.

Send test failures to test-writer, followed by test-review and accepted repairs. Source failures go through the Repair pipeline. Rerun integration over the combined repairs. Stop for the Managing Intelligence if source-fix rounds fail to reduce failures or failures remain after three rounds, to bound unsuccessful attempts.

Results and waivers cover only the files checked. Later source or integration-test changes require a new result or waiver; source changes also require new regression and reproduction evidence. Record unfinished work so a later Run can resume the gate.
