---
name: fix-bug
description: "Fix a defined Bug in its recorded worktrees, prove the regression is covered, review and commit the fix, and hand it back for testing. Takes a Bug ID."
---

# fix-bug

## Purpose

You coordinate a Bug's fix, review and verification in the worktrees configure-worktree prepared, then hand it to the Managing Intelligence to test. You commit the fix; teardown-worktree merges it once they accept it. If the fix fails their testing, they note what's still wrong on the Bug and run you again.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

A Bug ID.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md`, `protocol:launcher.md` and the Ticket System Protocol File selected by `setting:ticket_system`, for operations.
- **Bug and its Dependencies:** for the report, reproduction, decisions and progress. The Bug's `## Worktrees` says where you and your Child Agents work, and its `thinking_level` tag is the level you launch `engineer`, `test-writer` and `doc-writer` at.
- **Guidance:** `guide:engineering-best-practices.md`, `guide:test-guide.md`, `guide:doc-writing-guide.md`, `guide:build-commands.md` and `guide:release-guide.md` for implementation, reviews, checks and commits in each affected repo.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when all of these are true:

- The Bug is `defined` or `active`. If it's `draft`, stop and suggest define-bug. Otherwise, stop and report its status.
- The Bug has a `## Worktrees` record. Otherwise, stop and suggest configure-worktree.
- Every ticket the Bug depends on is `done`. Otherwise, stop and report the blocking ticket IDs.

## Steps

1. **Start or resume.** Set the Bug `active`. If the Managing Intelligence has noted under `## Decisions` that an earlier fix failed their testing, start a new round under `## Progress` to fix what's still wrong, building on the earlier commits. When resuming an interrupted Run, have reviewers check all uncommitted changes, so nothing unreviewed is committed.

2. **Fix and review.** Follow the Fix pipeline until accepted findings are fixed.

   **Run the commit checks yourself.** Run `guide:build-commands.md ## Compile`, `## Lint` and `## Unit tests` for every code folder the fix changed, skipping only sections marked `none` with a reason. Send each failure to the executor that owns the files as a fix round. Go on when all three pass.

3. **Prove the fix.** Pass the Integration gate. Then rerun every scenario under `## Reproduction`, and anything still wrong under `## Decisions`, in the Bug's worktrees. A remaining symptom goes back to step 2, then repeat this step. Check each scenario has regression evidence, or a Managing Intelligence decision agreeing other verification.

4. **Commit** in each worktree the fix changed, so the Managing Intelligence tests a verified fix.

## Child Agents

Use the Fix pipeline and Integration gate for sequencing. Start executors fresh for each Run and reuse them for that Run's fix rounds, to preserve their knowledge. Start reviewers fresh every time, so each assessment is independent.

- **`engineer`:** Launch for source changes, including integration fixes. Expect implementation, targeted checks and effects on design or documentation.
- **`test-writer`:** Launch one per testing assignment, in parallel, naming its assignment and the baseline checkout. Use them for integration failures in tests. Expect tests, fixtures, gaps and regression evidence following `guide:test-guide.md`. It runs only targeted checks, because you run the full suites.
- **`doc-writer`:** Launch for every Bug, because a fix can leave docs wrong even when it only restores documented behaviour. Expect updates following `guide:doc-writing-guide.md` and implementation gaps, or a reason none are needed.
- **`code-review`:** Launch after source changes. Expect correctness, engineering and lint findings with references and suggested fixes.
- **`test-review`:** Launch after test changes. Expect quality, regression coverage and duplication findings across the suite.
- **`doc-review`:** Launch after documentation changes. Expect findings on complete touched documents and missing or outdated documentation.

## Writes

The Bug is the only ticket you change, and only you write it: Child Agents report to you and you record their results, because several work on it at once. Set it `active` in step 1 and leave it `active` for the Managing Intelligence to test. Write these sections on it:

- `## Progress`: rounds, testing assignments, phase, executor IDs, skills, Thinking Levels, unfinished work and commits, so another Run can continue.
- `## Decisions`: the Managing Intelligence's decisions.
- `## Regression evidence`: failing-before and passing-after results for each scenario, and each reproduction rerun.
- `## Checks`: check results and accepted failures.
- `## Declined findings`: declined findings with reasons.

Create and remove any baseline checkouts you make, as the Regression evidence section describes.

## Done

Report the Bug's ID, each worktree's path, branch and commit, and unaddressed findings with reasons.

- If you stopped before committing, report why and suggest re-running fix-bug on this Bug.
- Otherwise, suggest the Managing Intelligence test the fix in its worktrees. If it passes, they set the Bug `done` and launch teardown-worktree. If not, they note what's still wrong under `## Decisions` and launch fix-bug again.

## Handling Reviewer Feedback

You coordinate the work; your Child Agents change the files. For each finding from code-review, test-review or doc-review:

- **Fix it:** return it to the executor that owns the files.
- **Decline it:** use your judgement to decline findings that are minor or trivial, and record each one with its reason under `## Declined findings` and in the Done report, so the Managing Intelligence sees what was left.
- **Ask the Managing Intelligence:** for expected behaviour, or conflicts with the Bug's `## Report`, because they decide how the software should behave.

## Fix pipeline

Run engineer; code-review and test-writer in parallel; test-review and doc-writer in parallel; then doc-review. Use applicable executors and reviewers.

Split the testing work into assignments yourself, because a Bug has no Subtasks, and record them under `## Progress`. Keep assignments from editing the same file so their writers can work in parallel. Tests that share a helper the fix changes go in one assignment.

Group the findings you accept into fix rounds. Resume affected executors with their findings, in source → tests → documentation order, with one doc-writer pass per round. Have reviewers check each round until accepted findings are fixed.

If fix rounds stop making progress, stop for the Managing Intelligence, so a fix loop doesn't burn the budget.

## Regression evidence

Require an automated regression test, following `guide:test-guide.md`, for each scenario under `## Reproduction` and each failure the Managing Intelligence noted, that has no regression evidence yet. Each test must fail before the fix and pass after it, because a passing test alone doesn't prove it catches the defect.

For failing-before results, make one baseline checkout per repo under `<Project Folder>/.scratch/<Bug ID>/baseline/`, at the Bug's base commit, or at the last fix commit for a failure the Managing Intelligence noted after testing. Never undo the fix in the Bug's worktrees, because other Child Agents work there at the same time. Remove the baseline checkouts before Done.

If a scenario can't run, or define-bug confirmed the Bug from source evidence, or automated coverage is impractical, ask the Managing Intelligence what verification is enough, and record their decision under `## Decisions`.

## Integration gate

You run `guide:build-commands.md ## Integration tests` for every code folder the fix affects, following `guide:test-guide.md`. Skip sections marked `none` with a reason. Save output under `<Project Folder>/.scratch/<Bug ID>/checks/`, so it survives teardown, and read only failures to preserve context. Record commands, exit statuses and output paths under `## Checks`.

The gate passes when suites pass, or when the Managing Intelligence accepts the remaining failures; record what they accepted under `## Checks`. If suites can't run, ask the Managing Intelligence.

Send test failures to test-writer, then test-review. Send source failures to engineer as a fix round. Run step 2's commit checks yourself after fixes, then rerun integration to check their combined result.
