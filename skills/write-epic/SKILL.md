---
name: write-epic
description: "Break one draft Epic into Tasks and Subtasks, or reconcile its existing work after the Plan changes."
---

# write-epic

## Purpose

Breaks one Epic into Tasks and Subtasks for develop-epic, after write-plan or a round of idea-review. Revises existing work when the Epic's requirements change.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

An Epic ID.

## Required Reading

- **Settings:** Project and default settings, resolved as `~/.apiary/system/workflow.md` describes, for this Run's configuration.
- **Agent Protocol File:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md` under `~/.apiary/system/protocols/`, for the Main Agent's own context readings and skill invocation.
- **Launcher Protocol File:** `protocol:launcher.md`, selected as `~/.apiary/system/workflow.md` describes, for Child Agent operations and context readings.
- **Ticket System Protocol File:** selected by `setting:ticket_system` as `~/.apiary/system/workflow.md` describes, to read requirements and existing work, and write Tasks, Subtasks, Dependencies, tags and statuses.
- **Epic, Plan, all sibling Epics and existing Tasks and Subtasks:** to establish the Epic's outcome, account for its Dependencies, avoid overlapping work and reconcile earlier planning and progress.
- **Idea and its Docs:** the Plan's Idea, through the Ticket System Protocol File. Why: to follow the PRD, SRD and recorded decisions, including findings and Managing Intelligence answers recorded on the tickets they concern.
- **Guidance Documents:** `guide:engineering-best-practices.md`, `guide:test-guide.md` and `guide:doc-writing-guide.md` for each affected code folder, found as `~/.apiary/system/workflow.md` describes, so the Tasks and Subtasks it writes follow the Project's engineering, testing and documentation guidance.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when all of these are true:

- The Epic is `draft`. If it isn't, stop and report its status.
- Its Plan is `defined` or `active`. If it isn't, stop and suggest write-plan.

## Steps

1. **Write or revise the Tasks.** Follow the Epic's acceptance criteria, the PRD and the SRD's choices, using the Task template below. Leave out work that a sibling or prerequisite Epic already covers, and assume prerequisite Epics are `done` before this one runs, so no work is written twice.
   - If Tasks already exist, revise every affected Task and Subtask, whatever its status, from recorded progress and current requirements. Include removing delivered functionality that the requirements withdraw, so the software will match them. Add new work, remove obsolete unimplemented work, and leave unaffected work as it is.

2. **Plan each draft Task's Subtasks.** Work in Dependency order. For each Task, save it, then launch the `engineer-planner`, `test-writer-planner` and `doc-writer-planner` Child Agents described below. Each reads the code, tests or docs its part needs and proposes that part's Subtasks, because reading every Task's code yourself would fill your context before the Epic is planned. Combine their proposals using the guidance below. Assign each draft Task a `thinking_level:<label>` tag, as the Thinking Level guidance below describes, because develop-epic uses it for the Task's executors.
   - Before each Task, re-check the Plan. If it has returned to `draft`, stop at that boundary so planning can resume from the revised Plan.
   - If planning raises a product question, or a planner's proposal conflicts with the SRD, ask the Managing Intelligence, because planning follows the defined requirements.

3. **Check the whole Epic with the `product-manager`.** Save the Tasks and Subtasks, then launch `product-manager`. Judge every finding under the shared rule and review again after significant revisions. Check the Quality checklist below.

4. **Finalize the Epic.** Re-check the Plan's Gate condition, because an SRD revision may have paused planning. Only once the `product-manager`'s accepted findings are fixed and the Quality checklist passes, set draft Subtasks and Tasks `defined`, then the Epic `defined`.

## Child Agents

- **`engineer-planner`:** Start fresh every time so planning stays focused on the assigned Task. Launch for each Task needing source code changes. Expect implementation Subtasks grounded in the code and engineering guidance.
- **`test-writer-planner`:** Start fresh every time so planning stays focused on the assigned Task. Launch for each Task once any engineering proposals it needs are available. Expect `test-writer` Subtasks for the unit and integration coverage `guide:test-guide.md` requires, fixture planning, suggested Lanes and the final full-unit-suite Subtask. develop-epic's `test-review` checks test quality independently.
- **`doc-writer-planner`:** Start fresh every time so planning stays focused on the assigned Task. Launch for each Task affecting source, user-facing behaviour, installation, setup or documentation. Expect documentation Subtasks allowed by the doc-writing guide, or a reason none are needed.
- **`product-manager`:** Start fresh every time so each assessment is independent. Launch after saving the Epic's proposed Tasks and Subtasks. Expect an independent check that the work meets (and does not exceed) the requirements and is in proportion to them, including duplicated tests and unsafe Lane groupings, with references and suggested fixes.

## Writes

- **Tasks and Subtasks:** children of the Epic and its Tasks respectively, in the Plans store. New and revised tickets start `draft` in steps 1–2. Reset affected tickets and their parent Tasks even if previously `active` or `done`, so develop-epic executes the revised work. Delete obsolete unimplemented work. Each Task gets a `thinking_level:<label>` tag; each Subtask names its executor. Record a Dependency from each waiting Task or Subtask to its prerequisite so execution follows the required order.
- **The Epic and its draft children:** set to `defined` in step 4. The Epic records any unfinished writing, so a later Run can resume it.

## Done

Report the Epic's ID, and any `product-manager` findings left unaddressed with the reason.

Suggest develop-epic on this Epic once every Epic it depends on is `done`.

## Task template

- **Context:** explain why the Task exists, the requirements it serves and what prerequisite work it assumes.
- **What needs to change:** state the work and affected code folders, following the SRD's decisions.
- **Acceptance criteria:** state observable results that demonstrate the Task's outcome.
- **Dependencies:** name Tasks that must finish first and explain why.

Describe outcomes and constraints, leaving implementation detail to the executor. Name files and modules rather than code snippets or line numbers, because prerequisite work can change the code before execution.

## Subtask template

Every Subtask names its executor: `engineer`, `test-writer` or `doc-writer`. Include all four sections, with detail in proportion to the work:

- **Context:** explain why the Subtask exists and what preconditions it assumes. For testing, name fixtures, factories, helpers and constants it reuses, creates or changes.
- **What Needs to Change:** describe the work and requirements for that executor's part of the Task.
- **Key Files:** give concrete paths relative to a named repo's root, or a named code folder under `<Project Folder>` when there is no repo. Identify files to create as new.
- **Acceptance Criteria:** state observable, testable conditions for completion. For example, a CSV export's fields are correctly quoted and its existing JSON export still works.

## Writing guidance

Keep each Task's implementation, tests and documentation together so its outcome can be checked and committed as a whole. Reference the tickets holding applicable Managing Intelligence decisions so executors follow the current decisions.

Put testing after its implementation and documentation after its implementation and tests, so each checks the work it describes. Every Task includes a final unit-test Subtask to run the full unit suite and fix failures, to check the combined changes. Its acceptance criterion is a passing full unit suite in each affected code folder with unit tests.

Include each guide's required work in the Task it supports.

## Thinking Level guidance

A Task's tag sets how hard its `engineer`, `test-writer` and `doc-writer` think, so match it to what a mistake in that Task would cost and how much judgement it needs:
- `low`: trivial, mechanical changes such as wording or config values, where a mistake is obvious and cheap.
- `medium`: routine work that follows an established pattern, such as adding a field or a small, well-understood change.
- `high`: work that needs real design judgement, touches several modules, or changes behaviour other code relies on.
- `xhigh`: work where a mistake is costly or hard to spot, such as concurrency, security, data migrations or an interface between components.
- `max`: the hardest, highest-risk Tasks only, because it is the slowest and most expensive.

When unsure between two levels, choose the higher one.

## Writing the testing Subtasks

Assign each Task's unit and integration testing Subtasks to `test-writer` Child Agents, following `guide:test-guide.md` so coverage matches the work. Write them with two goals in mind:

1. **Reuse the Project's test setup.** Say which existing fixtures, factories, helpers and constants the tests reuse, any changes they need, any new setup and where it goes, and which test files to extend or add, so tests don't each build their own setup.
2. **Let `test-writer` Child Agents work in parallel.** develop-epic can run several `test-writer` Child Agents on one Task, one per Lane. A **Lane** is a group of test files one writer can change without touching another's. Suggest the Lanes in the Task: keep files together when they share a fixture or helper the Task changes, or test overlapping behaviour, so writers don't edit the same helper or test the same thing twice. Give every independent group its own Lane, so as many writers as possible work at once. develop-epic adjusts them to the actual code.

Check each behaviour once at each test level, so effort isn't spent on duplicates: one unit test of a quoting rule is enough, though an end-to-end test of the export may check it again from the outside. Include tests to update, obsolete tests to remove and missing coverage to add. The last `test-writer` runs the full unit suite after the Task's changes and again after repairs, so it checks the combined work before commit.

## Quality checklist

- [ ] The Tasks cover the Epic's acceptance criteria and follow the PRD, SRD and recorded Managing Intelligence decisions.
- [ ] Every proposed change serves the requirements or applicable Guidance Documents, and its size fits the outcome.
- [ ] Prerequisite and sibling Epic work is accounted for, and each Task has a coherent outcome and the Dependencies it needs.
- [ ] Each Subtask has an executor, the four template sections and concrete Key Files in a named repo or code folder.
- [ ] Test proposals identify fixture reuse and changes, avoid duplicate checks at the same level, and keep test files that share changed setup in the same Lane.
- [ ] Every Task has a final full-unit-suite Subtask following its other unit-test work.
- [ ] Documentation work follows its implementation and tests and is allowed by the doc-writing guide.
- [ ] Every Task to execute has a Thinking Level suited to its complexity and risk.
- [ ] A revision covers every affected Task and Subtask, whatever its earlier status, and leaves it ready for develop-epic.
- [ ] The `product-manager` has checked the whole Epic's Tasks and Subtasks, and every finding has been judged and accepted fixes applied.
