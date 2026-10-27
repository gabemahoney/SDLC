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

- **Settings:** Project and defaults, for configuration.
- **Protocols:** your Agent Protocol File (`protocol:agent-claude-code.md`, `protocol:agent-codex.md` or `protocol:agent-cursor.md`), `protocol:launcher.md` and the Ticket System Protocol File selected by `setting:ticket_system`, for operations.
- **Epic, Tasks, Subtasks, Plan, sibling Epics, Idea and its Docs:** for requirements, decisions, Dependencies, unfinished work and Plan completion. The Plan's `## Worktrees` says where you and your Child Agents work.
- **Guidance:** `guide:engineering-best-practices.md`, `guide:test-guide.md`, `guide:doc-writing-guide.md`, `guide:build-commands.md` and `guide:release-guide.md` for implementation, reviews, checks and commits in each affected repo.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when all of these are true:

- The Epic is `defined` or `active`, or is `done` and needs only step 4. Otherwise, stop and suggest write-epic.
- Every Epic it depends on is `done`. Otherwise, stop and report the unfinished Dependency.
- Its Plan is `defined` or `active`, or is `done` for a completed Epic's handoff. Otherwise, stop and suggest write-plan.
- The PRD and SRD are `defined`, because execution follows approved requirements. Otherwise, stop and return them to the Managing Intelligence.
- The Plan's `## Worktrees` covers every repo this Epic changes, so nothing is committed on a base branch. Otherwise, stop and suggest configure-worktree.
- The Epic has planned Tasks with Subtasks. Unfinished ones are `defined` or `active`, except `draft` fix Tasks and Subtasks whose planning you resume before execution so interrupted repairs can continue. Otherwise, stop and suggest write-epic.
- Every Task names what it serves, as write-epic's Task template says, because work outside the approved requirements and guidance bypassed their review. Otherwise, add the names to the Task's `## Context` from its Epic's `## Work` or `## Findings`, because you own Task records and write-epic runs only on `draft` Epics; if the Epic names none, stop and ask the Managing Intelligence.

## Steps

1. **Start or resume.** For a completed Epic, go to step 4. Otherwise, set the Idea, Plan and Epic `active`.

2. **Complete Tasks in Dependency order, one at a time.** Update stale instructions, set the Task `active` and follow the Task pipeline until Subtasks are `done` and accepted findings are fixed.

   **Run the commit checks yourself.** Run `guide:build-commands.md ## Compile`, `## Lint` and `## Unit tests` for every code folder the Task changed. Send each failure to the executor that owns the files, then rerun all three. Commit and set the Task `done` only when all three pass, so every commit leaves working code.

3. **Finish the Epic.** Pass the Integration gate, then launch `product-manager`. Handle findings as Handling Reviewer Feedback describes. Complete accepted findings as fix Tasks through step 2 and pass the Integration gate again. Set the Epic `done` once its Tasks, accepted findings and gate are complete.

4. **Check Plan completion.** Set the Plan `done` when every Epic is `done`.

## Child Agents

Use the Task pipeline and Integration gate for sequencing.

- **`engineer`:** Start fresh for each Task and reuse it for fix rounds to preserve its knowledge. Launch for source changes, including integration fixes. Expect implementation, targeted checks, deviations and effects on design or documentation.
- **`test-writer`:** Start fresh for each Task and reuse each writer for fix rounds to preserve its knowledge. Launch one per testing Subtask, in parallel. Use them for integration failures in tests. Expect unit and integration tests, fixtures, repairs, gaps and only targeted checks on its own work following `guide:test-guide.md`, because you run the full suites.
- **`doc-writer`:** Start fresh for each Task and reuse it for fix rounds to preserve its knowledge. Launch when documentation is affected. Expect updates following `guide:doc-writing-guide.md` and implementation gaps.
- **`code-review`:** Start fresh every time so each assessment is independent. Launch after source changes. Expect correctness, engineering and lint findings with references and suggested fixes.
- **`test-review`:** Start fresh every time so each assessment is independent. Launch after unit or integration test changes. Expect quality, coverage and duplication findings across the suite.
- **`doc-review`:** Start fresh every time so each assessment is independent. Launch after documentation changes. Expect findings on complete touched documents and missing or outdated documentation.
- **`product-manager`:** Start fresh every time so each assessment is independent. Launch after each Task's executors and reviewers, after fixes affecting behaviour and after the Epic's Integration gate. Expect requirements, scope and proportion findings, including incomplete work and Managing Intelligence decisions needed.

## Writes

- **Idea, Plan and Epic:** set statuses in steps 1, 3 and 4. Keep the current Task, phase and checkout paths under `## Progress` and integration evidence under `## Checks` on the Epic.
- **Tasks and Subtasks:** add the names of what a Task serves to its `## Context` when the Gate finds them missing. Update stale instructions and set Task statuses in step 2. Executors set assigned Subtasks `active`, then `done`. Record executor IDs, skills, testing assignments, Thinking Levels, checks and commits under `## Progress` on the Task so another Run can continue.
- **Fix Tasks:** create Epic children for source integration failures and accepted final product findings. Start Tasks and repair Subtasks `draft`, then set them `defined` when planned. Use `## Context`, `## Work` and `## Dependencies` for each Task's purpose, changes and prerequisites, naming in `## Context` what the Task or Epic it repairs serves, so a re-run passes the Gate. Set a complexity-appropriate `thinking_level:<label>` tag. Use `## Executor`, `## Context`, `## Work`, `## Key files` and `## Acceptance criteria` for each Subtask's owner, preconditions, work, paths and completion checks. Include required coverage and affected docs so repairs receive the original work's checks.

## Done

Report the Epic's ID and unaddressed findings with reasons.

- If you stopped at a Task boundary, suggest re-running develop-epic on this Epic.
- For remaining Epics, suggest write-epic if `draft`, otherwise develop-epic.
- For a completed Plan, suggest idea-review.

## Handling Reviewer Feedback

You coordinate the work; your Child Agents do it. For each finding from code-review, test-review, doc-review or product-manager:

- **Fix it:** return it to the executor that owns the files.
- **Decline it:** use your judgement to decline findings that are minor or trivial, and record each one with its reason under `## Declined findings` on the Task or Epic and in the Done report, so the Managing Intelligence sees what was left.
- **Ask the Managing Intelligence:** for product questions or conflicts with the PRD or SRD, because those are their approved decisions.

## Task pipeline

Run engineer; code-review and test-writer in parallel; test-review and doc-writer in parallel; then doc-review. Use applicable executors and reviewers, followed by product-manager for every Task so it sees the combined result.

Keep testing Subtasks from editing the same file so their writers can work in parallel. Tests that share a helper the Task changes go in one Subtask.

Group accepted findings into repair rounds, as Handling Reviewer Feedback describes. Resume affected executors in source → tests → documentation order, with one doc-writer pass per round. Have reviewers check repairs until accepted findings are fixed.

For the commit checks in step 2, skip only sections marked `none` with a reason.

## Integration gate

You run `guide:build-commands.md ## Integration tests` for every affected code folder after the Epic's Tasks, following `guide:test-guide.md`. Skip sections marked `none` with a reason. Save output to a file and read only failures to preserve context. Record commands, exit statuses and output paths under `## Checks` on the Epic.

Keep the Epic `active` until suites pass or the Managing Intelligence accepts the remaining failures; record accepted failures under `## Checks` on the Epic. If suites cannot run, ask the Managing Intelligence.

Route test failures to test-writer, then test-review, and run step 2's commit checks yourself before committing repairs. Route source failures into fix Tasks through the full Task pipeline. Rerun integration after all repairs are committed to check their combined result.

If repairs stop making progress, stop for the Managing Intelligence so a repair loop doesn't burn the budget.
