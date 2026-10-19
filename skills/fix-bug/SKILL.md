---
name: fix-bug
description: "Fix a defined Bug in its recorded worktrees, prove the regression is covered, review the fix, and hand it back for acceptance. Takes a Bug ID."
---

# fix-bug

## Purpose

You follow define-bug and configure-worktree, and take a confirmed Bug through implementation, review and testing. The Managing Intelligence tests the fix and accepts or returns it before teardown-worktree merges it.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

A Bug ID.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md`, `protocol:launcher.md` and the Ticket System Protocol File selected by `setting:ticket_system`, for operations.
- **Bug and its Dependencies:** for confirmed behaviour, reproduction, progress and decisions, and the Thinking Level to launch your Child Agents at.
- **Guidance:** `guide:engineering-best-practices.md`, `guide:test-guide.md`, `guide:doc-writing-guide.md`, `guide:build-commands.md` and `guide:release-guide.md` for reviews, verification and commit and push permissions in each affected repo.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when all of these are true:

- The Bug is `defined` or `active`. If it's `draft`, stop and suggest define-bug. Otherwise, stop and report its status.
- The Bug's `## Worktrees` record exists, so the fix is made in its prepared worktrees. Otherwise, stop and suggest configure-worktree.
- Every ticket the Bug depends on is `done`, so the fix builds on completed prerequisites. If any isn't, stop and report the blocking ticket IDs.

## Steps

1. **Prepare or resume.** Set the Bug `active`. Work only in the worktrees recorded under the Bug's `## Worktrees`. If the Managing Intelligence sent the Bug back because the fix failed their testing, keep working in the same worktrees and branches, so earlier work on the fix is kept.

2. **Implement and review.** Assign Child Agents to the Bug's worktrees. Record testing assignments under `## Progress` for the coverage `guide:test-guide.md` requires. Follow the Fix pipeline, Regression evidence and Handling Reviewer Feedback sections until accepted findings are fixed.

   **Run the commit checks yourself.** Run `guide:build-commands.md ## Compile`, `## Lint` and `## Unit tests` for every code folder the fix changed. Skip only sections marked `none` with a reason. Send failures through the Fix pipeline, then rerun all three. Require all three to pass before committing, so every commit leaves working code.

3. **Prove the fix.** Pass the Integration gate. Rerun every scenario under `## Reproduction` with its recorded inputs and setup. A remaining symptom returns to step 2, then repeat verification so the evidence covers the final fix. If reproduction cannot run or validation used source inspection, the Managing Intelligence decides sufficient verification; record the decision under `## Decisions` and evidence under `## Regression evidence`.

4. **Commit.** Commit after steps 2 and 3 pass, so the Managing Intelligence tests the verified fix.

## Child Agents

Use the Fix pipeline and Integration gate for sequencing.

- **`engineer`:** Start fresh for each Bug and reuse it for fix rounds to preserve its knowledge. Launch for source changes, including integration fixes. Expect implementation, targeted checks, deviations and effects on design or documentation.
- **`test-writer`:** Start fresh for each Bug and reuse each writer for fix rounds to preserve its knowledge. Launch one per testing assignment, in parallel, after source changes and for failures caused by tests. Expect unit and integration tests, fixtures, repairs, gaps, regression evidence and only targeted checks, because you run the full suites.
- **`doc-writer`:** Start fresh for each Bug and reuse it for fix rounds to preserve its knowledge. Launch after source and tests for every Bug so restored behaviour does not hide documentation gaps. Expect updates following `guide:doc-writing-guide.md` or a reason none are needed.
- **`code-review`:** Start fresh every time so each assessment is independent. Launch after source changes. Expect correctness, engineering and lint findings with references and suggested fixes.
- **`test-review`:** Start fresh every time so each assessment is independent. Launch after test changes. Expect quality, regression coverage and duplication findings across the suite.
- **`doc-review`:** Start fresh every time so each assessment is independent. Launch after doc-writer. Expect findings on complete touched documents and missing or outdated documentation.

## Writes

Change source, tests and docs in the Bug's recorded worktrees. The Bug is the only ticket changed; set it `active` in step 1 and leave it `active` for the Managing Intelligence's acceptance. Write these sections on it:

- `## Progress`: testing assignments, phase, unfinished work, executor IDs, skills, Thinking Levels and commits, so another Run can continue.
- `## Decisions`: Managing Intelligence decisions.
- `## Reproduction`: the retained scenario and its rerun.
- `## Regression evidence`: before-and-after verification.
- `## Checks`: check results and accepted failures.
- `## Declined findings`: declined or unaddressed review findings with reasons.

## Done

Report the Bug's ID and unaddressed work or review findings with reasons.

Suggest the Managing Intelligence test the fix: they set the Bug `done` on acceptance, then run teardown-worktree, or return it to `draft` and run define-bug with what's still wrong.

## Handling Reviewer Feedback

You coordinate the work; your Child Agents do it. For each finding from code-review, test-review or doc-review:

- **Fix it:** return it to the executor that owns the files.
- **Decline it:** use your judgement to decline minor or trivial findings. Record each with its reason under `## Declined findings` on the Bug and in the Done report, so the Managing Intelligence sees what was left.
- **Ask the Managing Intelligence:** for expected behaviour or conflicts with the defined Bug, because it holds the fix's approved requirements.

## Fix pipeline

Run engineer; code-review and test-writer in parallel; test-review and doc-writer in parallel; then doc-review. Use applicable executors and reviewers. You own commits.

Keep testing assignments from editing the same file so their writers can work in parallel. Tests that share a helper the fix changes go in one assignment.

Group accepted findings into fix rounds. Resume affected executors in source → tests → documentation order, with one doc-writer pass per round. Have reviewers check repairs until accepted findings are fixed.

## Regression evidence

Require an automated regression test following `guide:test-guide.md`. The test-writer records failing-before and passing-after results, commands, revisions and coverage limits under `## Regression evidence`, because a passing test alone does not prove it catches the defect. If automated coverage is impractical, the Managing Intelligence decides sufficient repeatable verification. Record that decision under `## Decisions` and evidence under `## Regression evidence` so acceptance uses the agreed check.

## Integration gate

After implementation and review, you run `guide:build-commands.md ## Integration tests` for every affected code folder, following `guide:test-guide.md`. Skip sections marked `none` with a reason. Save output outside the Bug's worktrees so teardown-worktree preserves the evidence; read only failures to preserve context. Record commands, exit statuses and output paths under `## Checks` on the Bug.

The gate passes when the suites pass, or when the Managing Intelligence accepts the remaining failures; record what it accepted under `## Checks`. If the suites can't run, stop and ask the Managing Intelligence.

Send test failures to test-writer, followed by test-review. Source failures go through the Fix pipeline. Run step 2's commit checks yourself after fixes, then rerun integration to check their combined result.

If fixes stop making progress, stop and ask the Managing Intelligence, so a fix loop doesn't burn the budget. Record unfinished work under `## Progress` so a later Run can resume the gate.
