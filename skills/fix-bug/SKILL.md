---
name: fix-bug
description: "Fix a defined Bug in its recorded worktrees, prove the regression is covered, review and commit the fix, and hand it back for testing. Takes a Bug ID."
---

# fix-bug

## Purpose

You coordinate a Bug's fix, review and verification, then hand it to the Managing Intelligence to test.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

A Bug ID.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md`, `protocol:launcher.md` and the Ticket System Protocol File selected by `setting:ticket_system`, for operations.
- **Bug and its Dependencies:** for the report, reproduction, decisions and progress. The Bug's `## Worktrees` says where you and your Child Agents work, and its `thinking_level` tag is the level you launch `engineer`, `test-writer` and `doc-writer` at.
- **Guidance:** `guide:engineering-best-practices.md`, `guide:test-guide.md`, `guide:doc-writing-guide.md`, `guide:build-commands.md` and `guide:release-guide.md` for implementation, reviews, checks and commits in each affected repo.

## Gate

Run only when all of these are true:

- The Bug is `defined` or `active`. If it's `draft`, stop and suggest define-bug. Otherwise, stop and report its status.
- The Bug has a `## Worktrees` record. Otherwise, stop and suggest configure-worktree.
- Every ticket the Bug depends on is `done`. Otherwise, stop and report the blocking ticket IDs.

## Steps

1. **Start or resume.** Set the Bug `active`. An attempt is one fix of the original report, or of one note the Managing Intelligence left under `## Decisions` saying what's still wrong after testing; record under `## Progress` which one each attempt answers. Start a new attempt for any such note no attempt answers yet, on top of the earlier commits. When resuming an interrupted attempt, have reviewers check all uncommitted changes, so nothing unreviewed is committed, then continue from `## Progress`.

2. **Fix and review.** Make the baseline worktrees Regression evidence describes, then follow the Fix pipeline until accepted findings are fixed.

   **Run the commit checks yourself.** Run `guide:build-commands.md ## Compile`, `## Lint` and `## Unit tests` for every code folder the fix changed, skipping only sections marked `none` with a reason. Send each failure to the executor that owns the files as a fix round, then rerun all three. Go on only when all three pass.

3. **Prove the fix.** Rerun every scenario under `## Reproduction`, using the files attached to the Bug, and every failure noted under `## Decisions`, in the Bug's worktrees rather than the main checkouts the scenarios name. A remaining symptom goes back to step 2, with a new regression test if the old one passes. Then pass the Integration gate, and check Regression evidence below is met.

4. **Commit** in each worktree the fix changed.

## Child Agents

Executors are `engineer`, `test-writer` and `doc-writer`. Start them fresh for each Run and reuse them for that Run's fix rounds, to preserve their knowledge. Start reviewers fresh every time, so each assessment is independent.

- **`engineer`:** Launch for source changes. Expect implementation, targeted checks, deviations and effects on documentation.
- **`test-writer`:** Launch one per testing assignment, in parallel, naming its assignment and the baseline checkout. Expect tests, fixtures, gaps and regression evidence. It runs only targeted checks, because you run the full suites.
- **`doc-writer`:** Launch for every Bug, with the engineer's deviations and effects on documentation, because a fix can leave docs wrong even when it only restores documented behaviour. Expect updates and implementation gaps, or a reason none are needed.
- **`code-review`, `test-review` and `doc-review`:** Launch after source, test and documentation changes respectively. test-review also checks regression coverage.

## Writes

The Bug is the only ticket you change, and no Child Agent writes it, because several work on it at once. Leave it `active` for the Managing Intelligence to test. Write these sections on it:

- `## Progress`: attempts, fix rounds, testing assignments, executor IDs, Thinking Levels, executors' deviations, unfinished work and commits, so another Run can continue.
- `## Decisions`: the Managing Intelligence's answers to your questions.
- `## Regression evidence`: failing-before and passing-after results, and reproduction reruns.
- `## Checks`: check results and accepted failures.
- `## Declined findings`: declined findings with reasons.

## Done

Report the Bug's ID, each worktree's path, branch and commit, and unaddressed findings with reasons.

- If you stopped before committing, say what you need, and suggest re-running fix-bug once it's settled.
- Otherwise, suggest the Managing Intelligence test the fix in its worktrees and, if it fails, note what's still wrong under `## Decisions` before running fix-bug again.

## Handling Reviewer Feedback

You coordinate the work; your Child Agents change the files, so everything you commit has been reviewed. For each finding from code-review, test-review or doc-review:

- **Fix it:** return it to the executor that owns the files.
- **Decline it:** use your judgement to decline findings that are minor or trivial, and record each one with its reason under `## Declined findings` and in the Done report.
- **Ask the Managing Intelligence:** for expected behaviour, or conflicts with the Bug's `## Report` and `## Decisions` not already settled there, because those are theirs to decide. Stop and end the Run with the question; they record their answer under `## Decisions`.

## Fix pipeline

Run engineer; code-review and test-writer in parallel; test-review and doc-writer in parallel; then doc-review. Use applicable executors and reviewers.

Split the testing work into assignments, and keep them from editing the same file so their writers can work in parallel. Tests that share a helper the fix changes go in one assignment.

Group accepted findings into fix rounds and resume affected executors in source → tests → documentation order, with one doc-writer pass per round. Have reviewers check each round.

If fix rounds or attempts stop making progress, stop for the Managing Intelligence, so a fix loop doesn't burn the budget.

## Regression evidence

Require an automated regression test for each scenario under `## Reproduction` and each failure noted under `## Decisions` that doesn't have one. Each test must fail before the fix and pass after it, because a passing test alone doesn't prove it catches the defect.

For failing-before results, make one detached worktree per repo under `<Project Folder>/.scratch/<Bug ID>/baseline/`, at the base commit recorded under `## Worktrees` for the original report, or at the last fix commit for a noted failure. Never undo the fix in the Bug's worktrees, because other Child Agents work there at the same time. Remove these baseline worktrees, never the Bug's, before Done.

If you can't meet this, for example because a scenario can't run or automated coverage is impractical, ask the Managing Intelligence what verification is enough.

## Integration gate

You run `guide:build-commands.md ## Integration tests` for every code folder the fix changed, and every code folder that depends on one of them, skipping only sections marked `none` with a reason. Save output under `<Project Folder>/.scratch/<Bug ID>/checks/`, so it survives teardown, and read only failures to preserve context. Record commands, exit statuses and output paths under `## Checks`.

The gate passes when suites pass, or when the Managing Intelligence accepts the remaining failures. If suites can't run, ask the Managing Intelligence.

Send test failures to test-writer, then test-review. Send source failures through the Fix pipeline as a new fix round, so the change gets tests and reviews. Run step 2's commit checks yourself after fixes, then rerun step 3.
