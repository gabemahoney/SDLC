---
name: fix-bug
description: "Fix a defined Bug in its recorded worktrees, prove the regression is covered, review and commit the fix, and hand it back for testing. Takes a Bug ID."
---

# fix-bug

## Purpose

You coordinate a Bug's fix, review and verification, then hand it to the Managing Intelligence to test.

## Loading SDLC

Read `~/.sdlc/system/workflow.md` first for shared rules, settings and file locations.

## Input

A Bug ID.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** your Agent Protocol File (`protocol:agent-claude-code.md`, `protocol:agent-codex.md` or `protocol:agent-cursor.md`), `protocol:launcher.md` and `protocol:ticket.md`, for operations.
- **Bug and its Dependencies:** for the report, reproduction, decisions and progress. The Bug's `## Worktrees` says where you and your Child Agents work and holds any merge conflict teardown-worktree reported, and its `thinking_level` tag is the level you launch `engineer`, `test-writer` and `doc-writer` at.
- **Guidance:** `guide:engineering-best-practices.md`, `guide:test-guide.md`, `guide:doc-writing-guide.md`, `guide:build-commands.md` and `guide:release-guide.md` for implementation, reviews, checks and commits in each affected repo.

## Gate

Run only when all of these are true:

- The Bug is `defined` or `active`. If it's `draft`, stop and suggest define-bug. Otherwise, stop and report its status.
- The Bug has a `## Worktrees` record. Otherwise, stop and suggest configure-worktree.
- Every ticket the Bug depends on is `done`. Otherwise, stop and report the blocking ticket IDs.

## Steps

1. **Start or resume.** Set the Bug `active`. If the Managing Intelligence has noted under `## Decisions` what's still wrong after an earlier fix, fix that on top of the earlier commits. Resolve any merge conflict recorded in the Bug's `## Worktrees` on the Bug's branch, because teardown-worktree can't merge until it's gone. Before committing work left by an interrupted Run, have it reviewed.

2. **Write a test that catches the Bug.** Before the fix, have test-writers add a failing regression test for each scenario under `## Reproduction` and each failure the Managing Intelligence noted, that isn't covered yet, as Regression evidence below describes.

3. **Fix and review.** Follow the Fix pipeline until accepted findings are fixed. If the fix needs a repo with no worktree, stop and suggest configure-worktree.

   **Run the commit checks yourself.** Run `guide:build-commands.md ## Compile`, `## Lint` and `## Unit tests` for every code folder the fix changed, sending failures back through the Fix pipeline, until they pass.

4. **Test the fix.** Rerun every scenario under `## Reproduction` and every noted failure to check the Bug is gone, then pass the Integration gate.

5. **Commit** in each worktree the fix changed.

## Child Agents

Use the Fix pipeline and Integration gate for sequencing. Start executors fresh for each Run and reuse them for its fix rounds, to preserve their knowledge. Start reviewers fresh every time, so each assessment is independent.

- **`engineer`:** Launch for source changes. Expect implementation, targeted checks, deviations and effects on documentation.
- **`test-writer`:** Launch one per testing assignment, in parallel, telling each which assignment is theirs. Expect tests, fixtures, gaps and regression evidence.
- **`doc-writer`:** Launch for every Bug, because a fix can leave docs wrong even when it only restores documented behaviour. Expect updates and implementation gaps, or a reason none are needed.
- **`code-review`, `test-review` and `doc-review`:** Launch after source, test and documentation changes respectively.

## Writes

The Bug is the only ticket you change, and no Child Agent writes it, because several work on it at once. Leave it `active` for the Managing Intelligence to test. Keep its `## Progress` (including the deviations and documentation effects executors report), `## Regression evidence`, `## Checks` and `## Declined findings` current.

## Done

Report the Bug's ID, each worktree's path, branch and commit, and unaddressed findings with reasons.

- If you stopped before committing, say what you need, and suggest re-running fix-bug once it's settled.
- Otherwise, suggest the Managing Intelligence test the fix in its worktrees. If it passes, they set the Bug `done` and run teardown-worktree. If not, they note what's still wrong under `## Decisions` and run fix-bug again.

## Handling Reviewer Feedback

You coordinate the work; your Child Agents do it. For each finding from code-review, test-review or doc-review:

- **Fix it:** return it to the executor that owns the files.
- **Decline it:** use your judgement to decline findings that are minor or trivial, and record each one with its reason under `## Declined findings` and in the Done report.
- **Ask the Managing Intelligence:** for expected behaviour, or conflicts with the Bug's report and decisions, because those are theirs to decide.

## Fix pipeline

After step 2's regression tests, run engineer; code-review and test-writer in parallel for any further tests; test-review and doc-writer in parallel; then doc-review. Use applicable executors and reviewers.

Split the testing work into assignments that don't edit the same files, so their writers can work in parallel.

Group accepted findings into fix rounds and resume affected executors in source → tests → documentation order, with one doc-writer pass per round. Have reviewers check each round.

If fixes stop making progress, stop for the Managing Intelligence, so a fix loop doesn't burn the budget.

## Regression evidence

Each scenario and noted failure needs an automated regression test that fails before the fix and passes after it, because a passing test alone doesn't prove it catches the defect. If you can't get this evidence, ask the Managing Intelligence what verification is enough.

## Integration gate

You run `guide:build-commands.md ## Integration tests` for every code folder the fix affects, following `guide:test-guide.md`. Keep the output somewhere that survives teardown.

The gate passes when suites pass, or when the Managing Intelligence accepts the remaining failures. If suites can't run, ask the Managing Intelligence.

Send failures back through step 3, so every change is reviewed and checked before it's committed, then repeat step 4.
