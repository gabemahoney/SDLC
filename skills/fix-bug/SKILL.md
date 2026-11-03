---
name: fix-bug
description: "Fix a defined Bug in its own worktrees with a pipeline sized to the fix, prove the regression is covered, review and commit the fix, and hand it back for testing. Takes a Bug ID."
---

# fix-bug

## Purpose

You set up a Bug's worktrees and coordinate its fix, review and verification, then hand it to the Managing Intelligence to test.

## Loading SDLC

Read `~/.sdlc/install/workflow.md` first for shared rules, settings and file locations.

## Input

A Bug ID.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** your Agent Protocol File (`protocol:agent-claude-code.md`, `protocol:agent-codex.md` or `protocol:agent-cursor.md`), `protocol:launcher.md` and `protocol:ticket.md`, for operations.
- **Bug and its Dependencies:** for the report, reproduction, decisions and progress. The Bug's `## Reproduction` names the repos the fix is likely to change, its `## Worktrees` holds any worktrees and merge conflict recorded earlier, and its `thinking_level` tag is the level you launch `engineer`, `test-writer` and `doc-writer` at.
- **Guidance:** `guide:engineering-best-practices.md`, `guide:test-guide.md`, `guide:doc-writing-guide.md`, `guide:build-commands.md` and `guide:release-guide.md` for implementation, reviews, checks and commits in each affected repo.

## Gate

Run only when all of these are true:

- The Bug is `defined` or `active`. If it's `draft`, stop and suggest define-bug. Otherwise, stop and report its status.
- Every ticket the Bug depends on is `done`. Otherwise, stop and report the blocking ticket IDs.

## Steps

1. **Start or resume.** Set the Bug `active`. If the Managing Intelligence has noted under `## Decisions` what's still wrong after an earlier fix, fix that on top of the earlier commits. Resolve any merge conflict recorded in the Bug's `## Worktrees` on the Bug's branch, because the Managing Intelligence can't merge until it's gone. Before committing work left by an interrupted Run, have it reviewed.

2. **Set up worktrees.** For each repo the fix changes, create or reuse one worktree, with the branch and worktree named after the Bug's ID at the paths `~/.sdlc/install/workflow.md` defines and branched from the main checkout's current branch, so the fix stays off the base branch until it's accepted. Record each repo's main checkout, worktree path, branch and base branch under `## Worktrees`, because the Managing Intelligence merges from that record. Add a worktree the same way if the fix later needs another repo. If a main checkout that needs a new branch has uncommitted changes, which the branch would leave out, or something in the way isn't the Bug's, stop for the Managing Intelligence.

3. **Choose the pipeline** from Fix pipelines below and record it with your reason under `## Progress`, so the effort fits the fix. When the fix must choose an approach, record it there and check it against the guides before any code, because a rejected design throws the build away; ask the Managing Intelligence first only when the approach is questionable.

4. **Write a test that catches the Bug.** Before the fix, have your pipeline's test writer add a failing regression test for each scenario under `## Reproduction` and each failure the Managing Intelligence noted, that isn't covered yet, as Regression evidence below describes.

5. **Fix and review.** Follow your pipeline until accepted findings are fixed.

   **Run the commit checks yourself.** Run `guide:build-commands.md ## Compile`, `## Lint` and `## Unit tests` for every code folder the fix changed. Send failures back through your pipeline and confirm each repair with the checks it affects, then rerun all three, until they pass.

6. **Test the fix.** Rerun every scenario under `## Reproduction` and every noted failure to check the Bug is gone, then pass the Integration gate.

7. **Commit** in each worktree the fix changed.

## Child Agents

Your pipeline and the Integration gate say which Child Agents to launch and when. Start executors fresh for each Run and reuse them for its fix rounds, to preserve their knowledge. Start the full pipeline's reviewers fresh every time, so each assessment is independent.

- **`engineer`:** Expect implementation, targeted checks, deviations, effects on documentation and regression evidence for tests it writes.
- **`test-writer`:** Launch one per testing assignment, telling each which is theirs. Expect tests, fixtures, gaps and regression evidence.
- **`doc-writer`:** In the full pipeline, launch it for every Bug, because a fix can leave docs wrong even when it only restores documented behaviour. Expect updates and implementation gaps, or a reason none are needed.
- **`code-review`, `test-review` and `doc-review`:** Expect findings on source, tests and documentation respectively, or on the whole change as a pipeline's only reviewer.

## Writes

The Bug is the only ticket you change, and no Child Agent writes it, because several work on it at once. Leave it `active` for the Managing Intelligence to test. Keep its `## Worktrees`, `## Progress` (including your pipeline and reason, any approach you chose, and the deviations and documentation effects executors report), `## Regression evidence`, `## Checks` and `## Declined findings` current.

## Retrospective notes

While you work, note under `## Retrospective notes` on your ticket, with evidence, your answers to these questions, because the Managing Intelligence builds the Idea's or Bug's retrospective from them:

- Where did we introduce a quality issue? How could it have been avoided?
- Where did we spend too much time and not gain value? How could it have been avoided?
- Where did we spend too many tokens and not gain value? How could it have been avoided?

## Done

Report the Bug's ID, each worktree's path, branch and commit, and unaddressed findings with reasons.

- If you stopped before committing, say what you need, and suggest re-running fix-bug once it's settled.
- Otherwise, suggest the Managing Intelligence test the fix in its worktrees. If it passes, they set the Bug `done` and merge it, as `~/.sdlc/install/workflow.md`'s Bug flow describes. If not, they note what's still wrong under `## Decisions` and run fix-bug again.

## Handling Reviewer Feedback

You coordinate the work; your Child Agents do it. For each finding from code-review, test-review or doc-review:

- **Fix it:** return it to the executor that owns the files.
- **Decline it:** use your judgement to decline findings that are minor or trivial, and record each one with its reason under `## Declined findings` and in the Done report.
- **Ask the Managing Intelligence:** for expected behaviour, or conflicts with the Bug's report and decisions, because those are theirs to decide.

## Fix pipelines

Before each `code-review` or `test-review`, run `guide:build-commands.md ## Compile` and `## Lint` yourself for the code folders changed, and send failures to the executor that owns the files, so reviewers see only code that builds. Once the test-writers finish, run `## Unit tests` for those folders the same way before test-review, so it sees passing tests.

- **Small:** for a fix in one place with a low cost of mistakes. One `engineer` writes the regression tests, the fix and any doc changes, and one `code-review` reviews the whole change. Resume both for each fix round, because they already know the change.
- **Docs only:** for a fix that changes only documentation. One `doc-writer` makes the change and one `doc-review` reviews it, both resumed for each fix round. Skip step 4, `## Unit tests` and the Integration gate, because there is no code to test.
- **Full:** for a fix that needs design judgement, spans modules or risks costly mistakes. After `test-writer`s write step 4's regression tests, run engineer; code-review and test-writer in parallel for any further tests; test-review and doc-writer in parallel; then doc-review. Use applicable executors and reviewers. Split the testing work into assignments that don't edit the same files, so their writers can work in parallel. Group accepted findings into fix rounds and resume affected executors in source → tests → documentation order, with one doc-writer pass per round. Have reviewers check each round.

If fixes stop making progress, stop for the Managing Intelligence, so a fix loop doesn't burn the budget.

## Regression evidence

Each scenario and noted failure needs an automated regression test that fails before the fix and passes after it, because a passing test alone doesn't prove it catches the defect. If you can't get this evidence, ask the Managing Intelligence what verification is enough.

## Integration gate

You run `guide:build-commands.md ## Integration tests` for every code folder the fix affects, following `guide:test-guide.md`. Keep the output somewhere that survives the worktrees' removal.

The gate passes when suites pass, or when the Managing Intelligence accepts the remaining failures. If suites can't run, ask the Managing Intelligence.

Send failures back through step 5, so every change is reviewed and checked before it's committed. Confirm each repair with the integration tests it affects, then repeat step 6 once for all repairs, because a full run per repair costs much and adds little.
