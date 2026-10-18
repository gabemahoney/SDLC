---
name: fix-bug
description: "Fix a defined Bug, prove the regression is covered, review and merge the repair, and hand it back for acceptance. Takes a Bug ID."
---

# fix-bug

## Purpose

You follow define-bug and take a confirmed Bug through implementation, review, testing and merge. The Managing Intelligence checks the merged fix and accepts or returns it.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

A Bug ID.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md`, `protocol:launcher.md` and the Ticket System Protocol File selected by `setting:ticket_system`, for operations.
- **Bug and its Dependencies:** for confirmed behaviour, reproduction, Thinking Level, progress and decisions.
- **Guidance:** `guide:engineering-best-practices.md`, `guide:test-guide.md`, `guide:doc-writing-guide.md`, `guide:build-commands.md` and `guide:release-guide.md` for reviews, verification and commit, merge and push permissions in each affected repo.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when all of these are true:

- The Bug is `defined`, or `active` when resuming. If it is `draft`, stop and suggest define-bug. For any other status, stop and report it.
- Every ticket the Bug depends on is `done`, so the repair uses completed prerequisites. If any isn't, stop and report the blocking ticket IDs.
- You start outside `<Project Folder>/.worktrees/`, because you merge and remove your own worktrees. If you start inside, stop and say to run from the Project Folder.

## Steps

1. **Prepare or resume.** Set the Bug `active`. Create an isolated Bug worktree for each affected repo from its main checkout's current branch, using the workflow's worktree path. Record paths, bases and merge targets under `## Worktrees`. Reconcile progress with git, including unfinished merges and cleanup. A returned fix follows the revised Bug against current code.

2. **Implement and review.** Record testing assignments under `## Progress` on the Bug for the coverage `guide:test-guide.md` requires. Follow the Repair pipeline and Regression evidence guidance. Judge findings under the shared rule. The Managing Intelligence settles expected behaviour because the defined Bug is the repair's requirements.

3. **Prove the repair.** Pass the Integration gate after implementation and review. Rerun the retained reproduction with its original inputs and setup. Route a remaining symptom through the Repair pipeline. If reproduction cannot run or validation used source inspection, the Managing Intelligence decides sufficient verification; record the decision under `## Decisions` and evidence under `## Regression evidence`.

4. **Commit and merge.** Require fixed accepted findings, complete regression evidence, successful reproduction or agreed verification, and a passed integration gate.

   **Run the commit checks yourself.** Run `guide:build-commands.md ## Compile`, `## Lint` and `## Unit tests` for every code folder the repair changed. Skip only sections marked `none` with a reason. Send each failure to the executor that owns the files through the Repair pipeline, then rerun all three. Commit only when all three pass, so every commit leaves working code.

   Merge from the main checkouts into the recorded targets. If a target or conflict resolution changes the repair, review and check the combined result before cleanup because earlier evidence no longer covers it. Record successful merges under `## Worktrees`, then remove merged worktrees and branches. Leave the Bug `active` for acceptance. If a merge conflicts, preserve its worktree, record conflicts and completed merges under `## Worktrees`, and stop for resolution; a later Run resumes there.

## Child Agents

- **`engineer`:** Start fresh for each Bug repair and reuse it for fix rounds to preserve its knowledge. Launch for source changes. Expect the implementation, targeted checks, deviations and changes affecting design or documentation.
- **`test-writer`:** Start fresh for each Bug repair and reuse each writer for fix rounds to preserve its knowledge. Launch one per testing assignment, in parallel. Use them after every source-changing pass and for integration failures caused by tests. Expect unit and integration tests, before-and-after regression evidence, fixture changes, test repairs, gaps and only targeted checks on its own work, because you run the full suites.
- **`doc-writer`:** Start fresh for each Bug repair and reuse it for fix rounds to preserve its knowledge. Launch after source and testing assignments finish to assess and update documentation following `guide:doc-writing-guide.md`. Include review findings or repairs that affect documentation. Expect changes or a reason none are needed.
- **`code-review`:** Start fresh every time so each assessment is independent. Launch after source changes, while `test-writer` Child Agents work. Expect correctness, engineering and lint findings with references and suggested fixes, or no findings.
- **`test-review`:** Start fresh every time so each assessment is independent. Launch after testing assignments finish, while the `doc-writer` works, and after test repairs from the Integration gate. Expect findings on test quality, regression coverage and duplication across the suite, or no findings.
- **`doc-review`:** Start fresh every time so each assessment is independent. Launch after the `doc-writer` finishes. Expect findings on complete touched documents and documentation missing or made outdated by the fix, or no findings.

Record the current phase, next work, integration repair-round count and executor IDs, skills, testing assignments and Thinking Levels under `## Progress` on the Bug so later Runs can resume.

## Writes

The Bug is the only ticket changed. Set it `active` at start and leave it `active` after merge for the Managing Intelligence's acceptance. Write these sections on the Bug:

- `## Progress`: testing assignments, phase, next work, repair-round count, executor IDs, skills, Thinking Levels and commits.
- `## Decisions`: Managing Intelligence decisions.
- `## Reproduction`: the retained scenario and its rerun.
- `## Regression evidence`: before-and-after verification.
- `## Checks`: check results and accepted failures.
- `## Worktrees`: preparation, merges and cleanup.
- `## Declined findings`: declined or unaddressed review findings with reasons.

## Done

Report the Bug's ID, and any review findings left unaddressed with the reason.

Suggest the Managing Intelligence check the fix: they set the Bug `done` on acceptance, or return it to `draft` for define-bug.

## Repair pipeline

You coordinate executors and independent reviewers and own commits. Run engineer first; code-review and test-writer in parallel; then test-review and doc-writer in parallel; then doc-review. Use the skills the repair needs, including doc-writer assessment for every Bug so restored behaviour does not hide documentation gaps.

Keep testing assignments from editing the same file so their writers can work in parallel. Tests that share a helper the repair changes go in one assignment.

Group accepted findings into repair rounds. Resume affected executors in source → tests → documentation order. Give doc-writer one pass after source and tests finish; reviewers check repairs. Repeat until accepted findings are fixed.

## Regression evidence

The `test-writer` preserves an automated regression test at the boundary where the defect occurs, using unit coverage or integration coverage for interacting components as `guide:test-guide.md` describes. It records failing-before and passing-after results, commands, revisions and coverage limits under `## Regression evidence` on the Bug, because a passing test alone does not prove it catches the regression. If automated coverage is impractical, the Managing Intelligence decides what repeatable verification is sufficient. Record that decision under `## Decisions` and evidence under `## Regression evidence` on the Bug so acceptance uses the agreed check.

## Integration gate

After implementation and review, you run `guide:build-commands.md ## Integration tests` for every affected code folder, following `guide:test-guide.md`. Skip sections marked `none` with a reason. Save output to a file and read only failures so suite output stays out of context. Record commands, exit statuses and output paths under `## Checks` on the Bug.

The gate passes when the suites pass, or when the Managing Intelligence accepts the remaining failures; record what it accepted under `## Checks`. If the suites can't run, stop and ask the Managing Intelligence.

Send test failures to test-writer, followed by test-review and accepted repairs. Source failures go through the Repair pipeline. Rerun integration over the combined repairs. Stop for the Managing Intelligence if source-fix rounds fail to reduce failures or failures remain after three rounds, to bound unsuccessful attempts.

If repairs stop making progress, stop and ask the Managing Intelligence, so a repair loop doesn't burn the budget. Record unfinished work under `## Progress` so a later Run can resume the gate.
