---
name: fix-bug
description: "Fix a defined Bug in its own worktrees with a pipeline sized to the fix, prove the regression is covered, review and commit the fix, and hand it back for testing. Takes one or more Bug IDs."
---

# fix-bug

## Purpose

You set up a Bug's worktrees and coordinate its fix, review and verification, then hand it to the Managing Intelligence to test.

## Loading SDLC

Read `~/.sdlc/install/workflow.md` first for shared rules, settings and file locations.

## Input

A Bug ID, or several as `~/.sdlc/install/workflow.md`'s Bundles rule describes; then each must pass the Gate, every step and record covers each Bug, and you use the Small pipeline, stopping at step 3 if a Bug doesn't fit it.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** your Agent Protocol File (`protocol:agent-claude-code.md`, `protocol:agent-codex.md` or `protocol:agent-cursor.md`), `protocol:launcher.md` and `protocol:ticket.md`, for operations.
- **Bug and its Dependencies:** for the report, reproduction, decisions and progress. The Bug's `## Reproduction` names the repos the fix is likely to change, its `## Worktrees` holds any worktrees and merge conflict recorded earlier, and its `thinking_level` tag, the highest in a bundle, is the level you launch `engineer`, `test-writer` and `doc-writer` at.
- **Guidance:** `guide:engineering-best-practices.md`, `guide:test-guide.md`, `guide:doc-writing-guide.md`, `guide:build-commands.md` and `guide:release-guide.md` for implementation, reviews, checks and commits in each affected repo.

## Gate

Run only when all of these are true:

- The Bug is `defined` or `active`. If it's `draft`, stop and suggest define-bug. Otherwise, stop and report its status.
- Every ticket the Bug depends on is `done`. Otherwise, stop and report the blocking ticket IDs.

## Steps

1. **Start or resume.** Set the Bug `active`. If the Managing Intelligence has noted under `## Decisions` what's still wrong after an earlier fix, fix that on top of the earlier commits. Resolve any merge conflict recorded in the Bug's `## Worktrees` on the Bug's branch, because the Managing Intelligence can't merge until it's gone. Before committing work left by an interrupted Run, have it reviewed.

2. **Set up worktrees** for each repo the fix changes, now or later, as `~/.sdlc/install/workflow.md`'s Worktrees rule says.

3. **Choose the pipeline** from Fix pipelines below and record it with your reason under `## Progress`. When the fix must choose an approach, record it there and check it against the guides before any code, because a rejected design throws the build away; ask the Managing Intelligence first when the guides don't settle it or it changes behaviour others rely on.

4. **Write a test that catches the Bug.** Before the fix, have the engineer in Small, or test-writers in Full, add each failing regression test that Regression evidence below requires and that doesn't exist yet.

5. **Fix and review.** Follow your pipeline until accepted findings are fixed, running checks before each review as `~/.sdlc/install/workflow.md`'s Checks rule says. Once the fix is built, take any proposal before its first review, as `~/.sdlc/install/workflow.md`'s Proposals rule says, so no Agent sees it before the fix exists.

   **Run the commit checks yourself:** `guide:build-commands.md ## Compile`, `## Lint` and `## Unit tests` for every code folder the fix changed. Send failures back through your pipeline until they pass.

6. **Test the fix.** Rerun every scenario under `## Reproduction` and every noted failure to check the Bug is gone, then pass the Integration gate.

7. **Commit** in each worktree the fix changed.

## Child Agents

Start executors, and the small and docs-only pipelines' reviewer, fresh each Run and reuse them for its fix rounds, to preserve their knowledge; start the full pipeline's reviewers fresh every time, so each assessment is independent.

- **`engineer`:** Expect implementation, targeted checks, deviations, effects on documentation and regression evidence for tests it writes.
- **`test-writer`:** Launch one per testing assignment, telling each which is theirs. Expect tests, fixtures, gaps and regression evidence.
- **`doc-writer`:** In the full pipeline, launch it for every Bug, because a fix can leave docs wrong even when it only restores documented behaviour. Expect updates and implementation gaps, or a reason none are needed.
- **`code-review`, `test-review` and `doc-review`:** Expect findings on source, tests and documentation respectively, or on the whole change as a pipeline's only reviewer.

## Writes

Your Bugs are the only tickets you change, and no Child Agent writes them, because several work on them at once. Leave them `active` for the Managing Intelligence to test. Keep their `## Worktrees`, `## Progress` (including the deviations and documentation effects executors report), `## Regression evidence`, `## Checks` and `## Declined findings` current.

## Retrospective notes

While you work, note under `## Retrospective notes` on your ticket, with evidence, your answers to these questions, because the Managing Intelligence builds the Idea's or Bug's retrospective from them:

- Where did we introduce a quality issue? How could it have been avoided?
- Where did we spend too much time and not gain value? How could it have been avoided?
- Where did we spend too many tokens and not gain value? How could it have been avoided?

## Done

Report each Bug's ID, each worktree's path, branch and commit, and unaddressed findings with reasons.

- If you stopped before committing, say what you need, and suggest re-running fix-bug once it's settled.
- Otherwise, suggest the Managing Intelligence test the fix in its worktrees, then accept and merge it, or note what's still wrong under `## Decisions` and run fix-bug again, as `~/.sdlc/install/workflow.md`'s Bug flow describes.

## Handling Reviewer Feedback

For each finding from code-review, test-review or doc-review:

- **Fix it:** return it to the executor that owns the files.
- **Decline it:** use your judgement to decline findings that are minor or trivial, and record each one with its reason under `## Declined findings` and in the Done report.
- **Ask the Managing Intelligence:** for expected behaviour, or conflicts with the Bug's report and decisions, because those are theirs to decide.

## Fix pipelines

- **Small:** for a code fix in a Bug tagged `medium` or below, or `high` when the fix stays in one function or file and raises no design question, because the engineer still runs at the `high` level. One `engineer` writes the regression tests, the fix and any doc changes, and one `code-review` reviews the whole change.
- **Docs only:** for a fix that changes only documentation, whatever its tag. One `doc-writer` makes the change and one `doc-review` reviews it. Skip the Integration gate and run `## Unit tests` only for code folders whose tests read the changed docs, because no code changed.
- **Full:** for every other code fix. After `test-writer`s write step 4's regression tests, run engineer; code-review and test-writer in parallel for any further tests; test-review and doc-writer in parallel; then doc-review. Use applicable executors and reviewers. Split the testing work into assignments that don't edit the same files, so their writers can work in parallel. Group accepted findings into fix rounds and resume affected executors in source → tests → documentation order, with one doc-writer pass per round. Have reviewers check each round.

If fixes stop making progress, stop for the Managing Intelligence, so a fix loop doesn't burn the budget.

## Regression evidence

Except in the docs-only pipeline, each scenario under `## Reproduction` and each failure noted under `## Decisions` needs an automated regression test that fails before the fix and passes after it, because a passing test alone doesn't prove it catches the defect. If you can't get this evidence, ask the Managing Intelligence what verification is enough.

## Integration gate

You run `guide:build-commands.md ## Integration tests` for every code folder the fix affects, following `guide:test-guide.md`. Keep the output somewhere that survives the worktrees' removal.

The gate passes when suites pass, or when the Managing Intelligence accepts the remaining failures. If suites can't run, ask the Managing Intelligence.

Send failures back through step 5, so every change is reviewed and checked before it's committed, then repeat step 6 once for all repairs, as `~/.sdlc/install/workflow.md`'s Checks rule says.
