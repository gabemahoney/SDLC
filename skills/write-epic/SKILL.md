---
name: write-epic
description: Break one draft Epic into Tasks and Subtasks
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
   - If Tasks already exist, revise every affected Task from recorded progress and current requirements. Have planners revise its affected Subtasks, whatever their status. Include removing delivered functionality that the requirements withdraw, so the software will match them. Add new work, remove obsolete unimplemented work, and leave unaffected work as it is.

2. **Plan each draft Task's Subtasks.** Work in Dependency order. Save each Task, then launch the `engineer-planner`, `test-writer-planner` and `doc-writer-planner` Child Agents described below. Each reads its part's code, tests or docs and writes its Subtasks as `draft`, so your context lasts through the Epic. Review all of the Task's Subtasks together for overlaps, gaps, order and file conflicts between testing Subtasks. Send edits back to the planner that wrote them. Set the Subtasks `defined` when they are right. When a planner reports a rule this Task sets up that later Tasks must follow, put it in each affected Task's `## Context`, so its executors and reviewers see it. Assign each draft Task a `thinking_level:<label>` tag using the Thinking Level guidance below, because develop-epic uses it for the Task's executors.
   - Before each Task, re-check the Plan. If it has returned to `draft`, stop at that boundary so planning can resume from the revised Plan.
   - If planning raises a product question or conflicts with the SRD, ask the Managing Intelligence, because planning follows the defined requirements.

3. **Check the whole Epic with the `product-manager`.** Launch `product-manager` to review the saved Tasks and Subtasks. Judge every finding under the shared rule and review again after significant revisions. Check the Quality checklist below.

4. **Finalize the Epic.** Re-check the Plan's Gate condition, because an SRD revision may have paused planning. Only once the `product-manager`'s accepted findings are fixed and the Quality checklist passes, set draft Subtasks and Tasks `defined`, then the Epic `defined`.

## Child Agents

- **`engineer-planner`:** Start fresh for each Task and reuse it for edits to its Subtasks, so it keeps its knowledge of the Task. Launch for each Task needing source code changes. Expect implementation Subtasks grounded in the code and engineering guidance.
- **`test-writer-planner`:** Start fresh for each Task and reuse it for edits to its Subtasks, so it keeps its knowledge of the Task. Launch for each Task once any implementation Subtasks it needs are available. Expect `test-writer` Subtasks for the unit and integration coverage `guide:test-guide.md` requires and fixture planning. develop-epic's `test-review` checks test quality independently.
- **`doc-writer-planner`:** Start fresh for each Task and reuse it for edits to its Subtasks, so it keeps its knowledge of the Task. Launch for each Task affecting source, user-facing behaviour, installation, setup or documentation. Expect documentation Subtasks allowed by the doc-writing guide, or a reason none are needed.
- **`product-manager`:** Start fresh every time so each assessment is independent. Launch after saving the Epic's Tasks and Subtasks. Expect an independent check that the work meets (and does not exceed) the requirements and is in proportion to them, including duplicated tests, with references and suggested fixes.

## Writes

- **Tasks:** children of the Epic in the Plans store. New and revised Tasks start `draft`. Each gets a `thinking_level:<label>` tag. Record Dependencies so execution follows the required order.
- **Subtasks:** planners write them as `draft` children of their Tasks. You review them and set them `defined` in step 2. Have planners record Dependencies so execution follows the required order.
- **Revised work:** reset affected Tasks and Subtasks to `draft`, even if previously `active` or `done`, so develop-epic executes the revised work. Have planners revise the Subtasks. Delete obsolete unimplemented work.
- **The Epic and its draft children:** set to `defined` in step 4. Record unfinished writing under `## Progress` on the Epic, so a later Run can resume it. Record declined or unaddressed review findings with reasons under `## Declined findings` on the Task or Epic they concern.

## Done

Report the Epic's ID, and any `product-manager` findings left unaddressed with the reason.

Suggest develop-epic on this Epic once every Epic it depends on is `done`.

## Task template

- `## Context`: explain why the Task exists, the requirements it serves and what prerequisite work it assumes.
- `## Work`: state the work and affected code folders, following the SRD's decisions.
- `## Dependencies`: name Tasks that must finish first and explain why.

Describe outcomes and constraints, leaving implementation detail to the executor. Name files and modules rather than code snippets or line numbers, because prerequisite work can change the code before execution.

The planners write Subtasks using their own Subtask templates.

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

Tests are easier to split up than code, so during develop-epic several `test-writer` Child Agents can work on one Task at once, one per testing Subtask.

Check that no two testing Subtasks in a Task edit the same file. Tests that share a helper the Task changes go in one Subtask.

## Quality checklist

- [ ] The Tasks cover the Epic's acceptance criteria and follow the PRD, SRD and recorded Managing Intelligence decisions.
- [ ] Every planned change serves the requirements or applicable Guidance Documents, and its size fits the outcome.
- [ ] Prerequisite and sibling Epic work is accounted for, and each Task has a coherent outcome and the Dependencies it needs.
- [ ] Each Subtask has `## Executor`, `## Context`, `## Work`, `## Key files` and `## Acceptance criteria`, with concrete paths in a named repo or code folder.
- [ ] Testing Subtasks identify fixture reuse and changes and avoid duplicate checks at the same level.
- [ ] Documentation work follows its implementation and tests and is allowed by the doc-writing guide.
- [ ] Every Task to execute has a Thinking Level suited to its complexity and risk.
- [ ] A revision covers every affected Task and Subtask, whatever its earlier status, and leaves it ready for develop-epic.
- [ ] The `product-manager` has checked the whole Epic's Tasks and Subtasks, and every finding has been judged and accepted fixes applied.
