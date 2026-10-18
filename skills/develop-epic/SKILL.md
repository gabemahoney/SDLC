---
name: develop-epic
description: "Build, review and commit one Epic's Tasks and pass its integration gate."
---

# develop-epic

## Purpose

You coordinate an Epic's implementation, review and integration, then hand it back to the Managing Intelligence.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

An Epic ID.

## Required Reading

- **Settings:** Project and default settings, for this Run's configuration.
- **Agent Protocol File:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md`, for your context readings and skill invocation.
- **Launcher Protocol File:** `protocol:launcher.md`, for Child Agent operations and context readings.
- **Ticket System Protocol File:** selected by `setting:ticket_system`, for requirements, progress and ticket changes.
- **Epic, Tasks, Subtasks, Plan and sibling Epics:** for Dependencies, unfinished work and Plan completion.
- **Idea and its Docs:** through the Plan's Association, for requirements and recorded decisions.
- **Guidance Documents:** `guide:engineering-best-practices.md`, `guide:test-guide.md`, `guide:doc-writing-guide.md`, `guide:build-commands.md` and `guide:release-guide.md` for each affected repo, for implementation, reviews, checks and commits.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when all of these are true:

- The Epic is `defined` or `active`, or is `done` and needs only step 4. Otherwise, stop and suggest write-epic.
- Every Epic it depends on is `done`. Otherwise, stop and report the unfinished Dependency.
- Its Plan is `defined` or `active`, or is `done` for a completed Epic's handoff. Otherwise, stop and suggest write-plan.
- The PRD and SRD are `defined`, because execution follows approved requirements. Otherwise, stop and return them to the Managing Intelligence.
- The Epic has planned Tasks with Subtasks. Unfinished ones are `defined` or `active`, except `draft` fix Tasks and Subtasks whose planning you resume before execution so interrupted repairs can continue. Otherwise, stop and suggest write-epic.

## Steps

1. **Start or resume.** For a completed Epic, go to step 4. Otherwise, set the Idea, Plan and Epic `active`.

2. **Complete Tasks in Dependency order, one at a time.** Before each Task, stop if the Plan returned to `draft`, because an SRD revision paused execution. Update stale instructions, set the Task `active` and follow the Task pipeline. Commit and set it `done` only after Subtasks are `done`, accepted findings are fixed and the commit checks pass.

3. **Finish the Epic.** Pass the Integration gate, then launch `product-manager`. Handle findings as Handling Reviewer Feedback describes. Complete accepted findings as fix Tasks through step 2 and pass the Integration gate again. Set the Epic `done` once its Tasks, accepted findings and gate are complete.

4. **Check Plan completion.** Set the Plan `done` when every Epic is `done`.

## Child Agents

Use the Task pipeline and Integration gate for sequencing.

- **`engineer`:** Start fresh for each Task and reuse it for fix rounds to preserve its knowledge. Launch for source changes, including integration fixes. Expect implementation, targeted checks, deviations and effects on design or documentation.
- **`test-writer`:** Start fresh for each Task and reuse it for fix rounds to preserve its knowledge. Launch for testing Subtasks, one per Lane with a final writer after multiple Lanes, and integration failures in tests. Expect unit and integration coverage, fixtures, repairs, gaps and assigned results following `guide:test-guide.md`.
- **`doc-writer`:** Start fresh for each Task and reuse it for fix rounds to preserve its knowledge. Launch when documentation is affected. Expect updates following `guide:doc-writing-guide.md` and implementation gaps.
- **`code-review`:** Start fresh every time so each assessment is independent. Launch after source changes. Expect correctness, engineering and lint findings with references and suggested fixes.
- **`test-review`:** Start fresh every time so each assessment is independent. Launch after unit or integration test changes. Expect quality, coverage and duplication findings across the suite.
- **`doc-review`:** Start fresh every time so each assessment is independent. Launch after documentation changes. Expect findings on complete touched documents and missing or outdated documentation.
- **`product-manager`:** Start fresh every time so each assessment is independent. Launch after each Task's executors and reviewers, after fixes affecting behaviour and after the Epic's Integration gate. Expect requirements, scope and proportion findings, including incomplete work and Managing Intelligence decisions needed.

## Writes

- **Idea, Plan and Epic:** set statuses in steps 1, 3 and 4. Keep the current Task, phase, checkout paths and integration evidence on the Epic.
- **Tasks and Subtasks:** update stale instructions and set Task statuses in step 2. Executors set assigned Subtasks `active`, then `done`. Record executor IDs, skills, testing assignments, Thinking Levels, Lane assignments, checks and commits on the Task so another Run can continue.
- **Fix Tasks:** create Epic children for source integration failures and accepted final product findings. Start Tasks and repair Subtasks `draft`, then set them `defined` when planned. Include outcomes, acceptance criteria, Dependencies, a complexity-appropriate `thinking_level:<label>` tag and Subtasks with Context, What Needs to Change, Key Files and Acceptance Criteria. Include required coverage, a final full-unit-suite Subtask, affected docs and Testing Lanes so repairs receive the original work's checks.

## Done

Report the Epic's ID and unaddressed findings with reasons.

- If you stopped at a Task boundary, suggest re-running develop-epic on this Epic.
- For remaining Epics, suggest write-epic if `draft`, otherwise develop-epic.
- For a completed Plan, suggest teardown-worktree for Epic worktrees, then idea-review.

## Handling Reviewer Feedback

You coordinate the work; your Child Agents do it. For each finding from code-review, test-review, doc-review or product-manager:

- **Fix it:** return it to the executor that owns the files.
- **Decline it:** when minor, record it with its reason on the Task or Epic and in the Done report, so the Managing Intelligence sees what was left.
- **Ask the Managing Intelligence:** for product questions or conflicts with the PRD or SRD, because those are their approved decisions.

## Task pipeline

Run engineer; code-review and test-writer in parallel; test-review and doc-writer in parallel; then doc-review. Use applicable executors and reviewers, followed by product-manager for every Task so it sees the combined result.

Group accepted findings into repair rounds, as Handling Reviewer Feedback describes. Resume affected executors in source → tests → documentation order, with one doc-writer pass per round. Have reviewers check repairs until accepted findings are fixed.

Before every commit, require passing `guide:build-commands.md ## Compile`, `guide:build-commands.md ## Lint` and `guide:build-commands.md ## Unit tests` for every affected code folder. Skip only sections marked `none` with a reason. Repeat affected checks after repairs so evidence covers the final changes.

The sole test-writer or final writer after multiple Lanes owns a full-unit-suite Subtask, even without test edits, because every Task has the same gate. It runs the full suite after combined changes and later source or unit-test repairs; other executors run targeted checks to avoid duplicate runs. Route source failures through engineer, testing and review; the writer fixes test failures.

## Testing Lanes

A **Lane** is a group of test files one test-writer can change independently. Adjust proposed Lanes to the implementation and record their files, behaviours, fixtures, helpers and reasons for changes on the Task. Keep overlapping behaviour and changed shared setup together to avoid conflicts and duplicate coverage.

Each Lane owns whole files and exclusively used setup, including during repairs. After all Lanes finish, a final test-writer handles reported shared changes and gaps and runs the full unit suite. A sole writer owns all tests and helpers.

## Integration gate

You run `guide:build-commands.md ## Integration tests` for every affected code folder after the Epic's Tasks, following `guide:test-guide.md`. Skip sections marked `none` with a reason. Save output to a file and read only failures to preserve context. Record commands, exit statuses and output paths on the Epic.

Keep the Epic `active` until suites pass or the Managing Intelligence accepts the remaining failures; record accepted failures on the Epic. If suites cannot run, ask the Managing Intelligence.

Route test failures to test-writer, then test-review, and pass the Task pipeline's commit checks before committing repairs. Route source failures into fix Tasks through the full Task pipeline. Rerun integration after all repairs are committed to check their combined result.

If repairs stop making progress, stop for the Managing Intelligence so a repair loop doesn't burn the budget.
