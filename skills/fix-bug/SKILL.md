---
name: fix-bug
description: "Fix a defined Bug in its recorded worktrees, prove the regression is covered, review and commit the fix, and hand it back for testing. Takes a Bug ID."
---

# fix-bug

## Purpose

You coordinate a Bug's fix, review and verification in the worktrees configure-worktree prepared, then hand it to the Managing Intelligence to test. You commit the fix; teardown-worktree merges it once they accept it.

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

1. **Start or resume.** Set the Bug `active`. If the Managing Intelligence sent the Bug back because the fix failed their testing, `## Decisions` says what's still wrong and `## Reproduction` has a new scenario for it; build on the existing branch and fix that. When resuming, have reviewers check any uncommitted changes `## Progress` doesn't show as reviewed, so nothing unreviewed is committed.

2. **Fix and review.** Follow the Fix pipeline until accepted findings are fixed.

   **Run the commit checks yourself.** Run `guide:build-commands.md ## Compile`, `## Lint` and `## Unit tests` for every code folder the fix changed. Send each failure to the executor that owns the files, then rerun all three. Go on only when all three pass.

3. **Prove the fix.** Rerun every scenario under `## Reproduction` in the Bug's worktrees, with its recorded inputs. A remaining symptom goes back to step 2. Then pass the Integration gate, and check the Regression evidence is complete.

4. **Commit** in each worktree, so the Managing Intelligence tests a verified fix.

## Child Agents

Use the Fix pipeline and Integration gate for sequencing.

- **`engineer`:** Start fresh for each Bug and reuse it for fix rounds to preserve its knowledge. Launch for source changes, including integration fixes. Expect implementation, targeted checks, deviations and effects on design or documentation.
- **`test-writer`:** Start fresh for each Bug and reuse each writer for fix rounds to preserve its knowledge. Launch one per testing assignment, in parallel. Use them for integration failures in tests. Expect unit and integration tests, fixtures, regression evidence and only targeted checks on its own work following `guide:test-guide.md`, because you run the full suites.
- **`doc-writer`:** Start fresh for each Bug and reuse it for fix rounds to preserve its knowledge. Launch for every Bug, because a fix can leave docs wrong even when it only restores documented behaviour. Expect updates following `guide:doc-writing-guide.md`, or a reason none are needed.
- **`code-review`:** Start fresh every time so each assessment is independent. Launch after source changes. Expect correctness, engineering and lint findings with references and suggested fixes.
- **`test-review`:** Start fresh every time so each assessment is independent. Launch after test changes. Expect quality, regression coverage and duplication findings across the suite.
- **`doc-review`:** Start fresh every time so each assessment is independent. Launch after doc-writer. Expect findings on complete touched documents and missing or outdated documentation.

## Writes

The Bug is the only ticket you change. Set it `active` in step 1 and leave it `active` for the Managing Intelligence to test. Write these sections on it:

- `## Progress`: testing assignments, phase, executor IDs, skills, Thinking Levels, unfinished work and commits, so another Run can continue.
- `## Decisions`: the Managing Intelligence's decisions.
- `## Regression evidence`: failing-before and passing-after results, and each `## Reproduction` rerun.
- `## Checks`: check results and accepted failures.
- `## Declined findings`: declined findings with reasons.

## Done

Report the Bug's ID, each worktree's path, branch and commit, and unaddressed findings with reasons.

- If you stopped before committing, report why and suggest re-running fix-bug on this Bug.
- Otherwise, suggest the Managing Intelligence test the fix in its worktrees. On acceptance they set the Bug `done` and launch teardown-worktree. If it fails, they set it `draft` and launch define-bug with what's still wrong.

## Handling Reviewer Feedback

You coordinate the work; your Child Agents do it. For each finding from code-review, test-review or doc-review:

- **Fix it:** return it to the executor that owns the files.
- **Decline it:** use your judgement to decline findings that are minor or trivial, and record each one with its reason under `## Declined findings` and in the Done report, so the Managing Intelligence sees what was left.
- **Ask the Managing Intelligence:** for expected behaviour, or conflicts with the Bug's `## Report`, because they decide how the software should behave.

## Fix pipeline

Run engineer; code-review and test-writer in parallel; test-review and doc-writer in parallel; then doc-review.

Split the testing work into assignments yourself, because a Bug has no Subtasks, and record them under `## Progress`. Keep assignments from editing the same file so their writers can work in parallel. Tests that share a helper the fix changes go in one assignment.

Group accepted findings into fix rounds, as Handling Reviewer Feedback describes. Resume affected executors in source → tests → documentation order, with one doc-writer pass per round. Have reviewers check the fixes until accepted findings are fixed.

## Regression evidence

Require an automated regression test, following `guide:test-guide.md`, for each scenario under `## Reproduction` that isn't covered yet. Have test-writers report failing-before and passing-after results, commands and revisions, and record them under `## Regression evidence` yourself, because a passing test alone doesn't prove it catches the defect. Failing-before results come from a separate checkout at the Bug's base commit, never from reverting the fix in the Bug's worktrees, because other Child Agents work there at the same time.

If the reproduction can't run, or define-bug confirmed the Bug from source evidence, or automated coverage is impractical, ask the Managing Intelligence what verification is enough. Record their decision under `## Decisions`, so acceptance uses the agreed check.

## Integration gate

You run `guide:build-commands.md ## Integration tests` for every code folder the fix changed, following `guide:test-guide.md`. Skip sections marked `none` with a reason. Save output to a file outside the worktrees, such as `<Project Folder>/.scratch/<Bug ID>/`, so it survives teardown, and read only failures to preserve context. Record commands, exit statuses and output paths under `## Checks`.

The gate passes when suites pass, or when the Managing Intelligence accepts the remaining failures; record what they accepted under `## Checks`. If suites can't run, ask the Managing Intelligence.

Send test failures to test-writer, then test-review. Send source failures through the Fix pipeline. Run step 2's commit checks yourself after fixes, then rerun integration to check their combined result.

If fixes stop making progress, stop for the Managing Intelligence, so a fix loop doesn't burn the budget.
