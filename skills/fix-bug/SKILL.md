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
- You start outside this Bug's worktrees, because you remove them after merging. Otherwise, stop and say to run from the Project Folder.

## Steps

1. **Prepare or resume.** Set the Bug `active`. Create or resume an isolated Bug worktree for each affected repo from its main checkout's current branch, using the workflow's worktree path. Record paths, branches, bases and merge targets under `## Worktrees`. A returned fix follows the revised Bug against current code.

2. **Implement and review.** Assign Child Agents to the Bug's worktrees. Record testing assignments under `## Progress` for the coverage `guide:test-guide.md` requires. Follow the Repair pipeline, Regression evidence and Handling Reviewer Feedback sections until accepted findings are fixed.

   **Run the commit checks yourself.** Run `guide:build-commands.md ## Compile`, `## Lint` and `## Unit tests` for every code folder the repair changed. Skip only sections marked `none` with a reason. Send failures through the Repair pipeline, then rerun all three. Require all three to pass before committing, so every commit leaves working code.

3. **Prove the repair.** Pass the Integration gate. Rerun the retained reproduction with its original inputs and setup. A remaining symptom returns to step 2, then repeat verification so the evidence covers the final repair. If reproduction cannot run or validation used source inspection, the Managing Intelligence decides sufficient verification; record the decision under `## Decisions` and evidence under `## Regression evidence`.

4. **Commit and merge.** Commit after steps 2 and 3 pass. Merge from the main checkouts into the recorded targets. If the target or conflict resolution changes the combined result, repeat steps 2 and 3 before cleanup because earlier evidence no longer covers it. If a merge conflicts, preserve its worktree, record conflicts and completed merges under `## Worktrees`, and stop for resolution.

   Record successful merges under `## Worktrees`. Stop Child Agents through `protocol:launcher.md` before removing their worktrees so no live agent loses its checkout. Remove only clean, merged worktrees and their merged branches to preserve unfinished work.

## Child Agents

Use the Repair pipeline and Integration gate for sequencing.

- **`engineer`:** Start fresh for each Bug and reuse it for fix rounds to preserve its knowledge. Launch for source changes, including integration fixes. Expect implementation, targeted checks, deviations and effects on design or documentation.
- **`test-writer`:** Start fresh for each Bug and reuse each writer for fix rounds to preserve its knowledge. Launch one per testing assignment, in parallel, after source changes and for failures caused by tests. Expect unit and integration tests, fixtures, repairs, gaps, regression evidence and only targeted checks, because you run the full suites.
- **`doc-writer`:** Start fresh for each Bug and reuse it for fix rounds to preserve its knowledge. Launch after source and tests for every Bug so restored behaviour does not hide documentation gaps. Expect updates following `guide:doc-writing-guide.md` or a reason none are needed.
- **`code-review`:** Start fresh every time so each assessment is independent. Launch after source changes. Expect correctness, engineering and lint findings with references and suggested fixes.
- **`test-review`:** Start fresh every time so each assessment is independent. Launch after test changes. Expect quality, regression coverage and duplication findings across the suite.
- **`doc-review`:** Start fresh every time so each assessment is independent. Launch after doc-writer. Expect findings on complete touched documents and missing or outdated documentation.

## Writes

Change source, tests and docs in the Bug's worktrees. The Bug is the only ticket changed; set it `active` in step 1 and leave it `active` after merge for the Managing Intelligence's acceptance. Write these sections on it:

- `## Progress`: testing assignments, phase, unfinished work, executor IDs, skills, Thinking Levels and commits, so another Run can continue.
- `## Decisions`: Managing Intelligence decisions.
- `## Reproduction`: the retained scenario and its rerun.
- `## Regression evidence`: before-and-after verification.
- `## Checks`: check results and accepted failures.
- `## Worktrees`: preparation, merges and cleanup.
- `## Declined findings`: declined or unaddressed review findings with reasons.

## Done

Report the Bug's ID and unaddressed work or review findings with reasons.

Suggest the Managing Intelligence check the fix: they set the Bug `done` on acceptance, or return it to `draft` for define-bug.

## Handling Reviewer Feedback

You coordinate the work; your Child Agents do it. For each finding from code-review, test-review or doc-review:

- **Fix it:** return it to the executor that owns the files.
- **Decline it:** use your judgement to decline minor or trivial findings. Record each with its reason under `## Declined findings` on the Bug and in the Done report, so the Managing Intelligence sees what was left.
- **Ask the Managing Intelligence:** for expected behaviour or conflicts with the defined Bug, because it holds the repair's approved requirements.

## Repair pipeline

Run engineer; code-review and test-writer in parallel; test-review and doc-writer in parallel; then doc-review. Use applicable executors and reviewers. You own commits.

Keep testing assignments from editing the same file so their writers can work in parallel. Tests that share a helper the repair changes go in one assignment.

Group accepted findings into repair rounds. Resume affected executors in source → tests → documentation order, with one doc-writer pass per round. Have reviewers check repairs until accepted findings are fixed.

## Regression evidence

Require an automated regression test following `guide:test-guide.md`. The test-writer records failing-before and passing-after results, commands, revisions and coverage limits under `## Regression evidence`, because a passing test alone does not prove it catches the defect. If automated coverage is impractical, the Managing Intelligence decides sufficient repeatable verification. Record that decision under `## Decisions` and evidence under `## Regression evidence` so acceptance uses the agreed check.

## Integration gate

After implementation and review, you run `guide:build-commands.md ## Integration tests` for every affected code folder, following `guide:test-guide.md`. Skip sections marked `none` with a reason. Save output outside the Bug's worktrees so cleanup preserves the evidence; read only failures to preserve context. Record commands, exit statuses and output paths under `## Checks` on the Bug.

The gate passes when the suites pass, or when the Managing Intelligence accepts the remaining failures; record what it accepted under `## Checks`. If the suites can't run, stop and ask the Managing Intelligence.

Send test failures to test-writer, followed by test-review. Source failures go through the Repair pipeline. Run step 2's commit checks yourself after repairs, then rerun integration to check their combined result.

If repairs stop making progress, stop and ask the Managing Intelligence, so a repair loop doesn't burn the budget. Record unfinished work under `## Progress` so a later Run can resume the gate.
