---
name: write-epic
description: "Break one draft Epic into Tasks and Subtasks, or reconcile its existing work after the Plan changes."
---

# write-epic

## Purpose

You break one Epic into Tasks and Subtasks for develop-epic, after write-plan or a round of idea-review. You revise existing work when the Epic's requirements change.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

An Epic ID.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md`, `protocol:launcher.md` and the Ticket System Protocol File selected by `setting:ticket_system`, for operations.
- **Epic, Plan, all sibling Epics, existing Tasks and Subtasks, Idea and its Docs:** for requirements, decisions, Dependencies, scope and progress.
- **Guidance:** `guide:engineering-best-practices.md`, `guide:test-guide.md` and `guide:doc-writing-guide.md` for Task and Subtask planning in each affected code folder.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when all of these are true:

- The Epic is `draft`. If it isn't, stop and report its status.
- Its Plan is `defined` or `active`. If it isn't, stop and suggest write-plan.

## Steps

1. **Write or revise the Tasks,** using the Task template below. Leave out work another Epic already covers, so no work is planned twice.
   - If Tasks already exist, revise every affected Task and Subtask, whatever its status, from recorded progress and current requirements. Include removing delivered functionality that the requirements withdraw, so the software will match them. Add new work, remove obsolete unimplemented work, and leave unaffected work as it is.

2. **Plan each draft Task's Subtasks.** Work in Dependency order. For each Task, save it, then launch the `engineer-planner`, `test-writer-planner` and `doc-writer-planner` Child Agents described below. Each reads the code, tests or docs its part needs and proposes that part's Subtasks, because reading every Task's code yourself would fill your context before the Epic is planned. Combine their proposals using the guidance below. Assign each draft Task a `thinking_level:<label>` tag, as the Thinking Level guidance below describes, because develop-epic uses it for the Task's executors.
   - Before each Task, re-check the Plan. If it has returned to `draft`, stop at that boundary so planning can resume from the revised Plan.
   - If planning raises a product question, or a planner's proposal conflicts with the SRD, ask the Managing Intelligence, because planning follows the defined requirements.

3. **Check the whole Epic with the `product-manager`.** Save the Tasks and Subtasks, then launch `product-manager`. Judge every finding under the shared rule and review again after significant revisions. Check the Quality checklist below.

4. **Finalize the Epic.** Re-check the Plan's Gate condition, because an SRD revision may have paused planning. Only once the `product-manager`'s accepted findings are fixed and the Quality checklist passes, set draft Subtasks and Tasks `defined`, then the Epic `defined`.

## Child Agents

- **`engineer-planner`:** Start fresh every time so planning stays focused on the assigned Task. Launch for each Task needing source code changes. Expect implementation Subtasks grounded in the code and engineering guidance.
- **`test-writer-planner`:** Start fresh every time so planning stays focused on the assigned Task. Launch for each Task once any engineering proposals it needs are available. Expect `test-writer` Subtasks for the unit and integration coverage `guide:test-guide.md` requires, fixture planning and suggested Lanes. develop-epic's `test-review` checks test quality independently.
- **`doc-writer-planner`:** Start fresh every time so planning stays focused on the assigned Task. Launch for each Task affecting source, user-facing behaviour, installation, setup or documentation. Expect documentation Subtasks allowed by the doc-writing guide, or a reason none are needed.
- **`product-manager`:** Start fresh every time so each assessment is independent. Launch after saving the Epic's proposed Tasks and Subtasks. Expect an independent check that the work meets (and does not exceed) the requirements and is in proportion to them, including duplicated tests and unsafe Lane groupings, with references and suggested fixes.

## Writes

- **Tasks and Subtasks:** children of the Epic and its Tasks respectively, in the Plans store. New and revised tickets start `draft` in steps 1–2. Reset affected tickets and their parent Tasks even if previously `active` or `done`, so develop-epic executes the revised work. Delete obsolete unimplemented work. Each Task gets a `thinking_level:<label>` tag; each Subtask names its executor under `## Executor`. Record a Dependency from each waiting Task or Subtask to its prerequisite so execution follows the required order.
- **The Epic and its draft children:** set to `defined` in step 4. Record unfinished writing under `## Progress` on the Epic, so a later Run can resume it. Record declined or unaddressed review findings with reasons under `## Declined findings` on the Task or Epic they concern.

## Done

Report the Epic's ID, and any `product-manager` findings left unaddressed with the reason.

Suggest develop-epic on this Epic once every Epic it depends on is `done`.

## Task template

- `## Context`: explain why the Task exists, the requirements it serves and what prerequisite work it assumes.
- `## Work`: state the work and affected code folders, following the SRD's decisions.
- `## Dependencies`: name Tasks that must finish first and explain why.

Describe outcomes and constraints, leaving implementation detail to the executor. Name files and modules rather than code snippets or line numbers, because prerequisite work can change the code before execution.

## Subtask template

Every Subtask has these sections, with detail in proportion to the work:

- `## Executor`: `engineer`, `test-writer` or `doc-writer`, so develop-epic knows which Child Agent works it.
- `## Context`: explain why the Subtask exists and what preconditions it assumes. For code, name what depends on the code it changes and what that code depends on, so the executor sees what a change could break.
- `## Work`: describe the work and requirements for that executor's part of the Task.
- `## Key files`: give concrete paths relative to a named repo's root, or a named code folder under `<Project Folder>` when there is no repo. Identify files to create as new.
- `## Acceptance criteria`: state observable, testable conditions for completion. For example, a CSV export's fields are correctly quoted and its existing JSON export still works.

## Writing guidance

Put testing after its implementation and documentation after its implementation and tests, so each checks the work it describes.

Follow the Guidance Documents when writing each Task and Subtask.

## Thinking Level guidance

A Task's tag sets how hard its `engineer`, `test-writer` and `doc-writer` think, so match it to how hard the engineering problem in that Task is and what a mistake in it would cost:
- `low`: trivial, mechanical changes such as wording or config values, where a mistake is obvious and cheap.
- `medium`: routine work that follows an established pattern, such as adding a field or a small, well-understood change.
- `high`: work that needs real design judgement, touches several modules, or changes behaviour other code relies on.
- `xhigh`: work where a mistake is costly or hard to spot, such as concurrency, security, data migrations or an interface between components.
- `max`: the hardest, highest-risk Tasks only, because it is the slowest and most expensive.

When unsure between two levels, choose the higher one.

## Writing the testing Subtasks

Tests are easier to split up than code, so several `test-writer` Child Agents can work on one Task at once.

Split each Task's test files into **Lanes**. Each Lane gets its own `test-writer`. Two Lanes must never edit the same file, so put tests that share a changed helper in the same Lane.

List the Lanes under `## Testing Lanes` in the Task.

## Quality checklist

- [ ] The Tasks cover the Epic's acceptance criteria and follow the PRD, SRD and recorded Managing Intelligence decisions.
- [ ] Every proposed change serves the requirements or applicable Guidance Documents, and its size fits the outcome.
- [ ] Prerequisite and sibling Epic work is accounted for, and each Task has a coherent outcome and the Dependencies it needs.
- [ ] Each Subtask has an executor, the template sections and concrete key files in a named repo or code folder.
- [ ] Test proposals identify fixture reuse and changes, avoid duplicate checks at the same level, and keep test files that share changed setup in the same Lane.
- [ ] Documentation work follows its implementation and tests and is allowed by the doc-writing guide.
- [ ] Every Task to execute has a Thinking Level suited to its complexity and risk.
- [ ] A revision covers every affected Task and Subtask, whatever its earlier status, and leaves it ready for develop-epic.
- [ ] The `product-manager` has checked the whole Epic's Tasks and Subtasks, and every finding has been judged and accepted fixes applied.
