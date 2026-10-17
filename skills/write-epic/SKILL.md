---
name: write-epic
description: "Break one draft Epic into Tasks and Subtasks, or reconcile its existing work after the Plan changes."
---

# write-epic

## Purpose

Breaks one Epic into Tasks and Subtasks for develop-epic, after write-plan or a round of idea-review. Revises existing work when the Epic's requirements change.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

An Epic ID.

## Required Reading

- **Workflow:** `~/.apiary/system/workflow.md`. Why: to follow the shared Run rules.
- **Settings files:** `<Project Folder>/.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`. Why: to select the Ticket System Protocol File through `ticket_system`, and the dispatched planners' and Product Manager's Thinking Levels through `thinking_levels` and `levels_claude_code` or `levels_codex`.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` in Claude Code, or `~/.apiary/system/protocols/agent-codex.md` in Codex CLI. Why: to dispatch Subagents and ask and report through the Agent.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: to read requirements and existing work, and write Tasks, Subtasks, Dependencies, tags and statuses.
- **Epic, Plan, all sibling Epics and existing Tasks and Subtasks:** through the Ticket System Protocol File, using the input Epic ID. Why: to establish the Epic's outcome, account for its Dependencies, avoid overlapping work and reconcile earlier planning and progress.
- **Idea and its Docs:** the Plan's Idea, through the Ticket System Protocol File. Why: to follow the PRD, SRD and recorded decisions, including findings and Managing Intelligence answers recorded on the tickets they concern.
- **Guidance Documents:** `engineering-best-practices.md`, `test-guide.md` and `doc-writing-guide.md` for each affected code folder, found as `workflow.md` describes. Why: so the Tasks and Subtasks it writes follow the Project's engineering, testing and documentation guidance.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when all of these are true:

- The Epic is `draft`. If it isn't, stop and report its status.
- Its Plan is `defined` or `active`. If it isn't, stop and suggest write-plan.

## Steps

1. **Write or revise the Tasks.** Follow the Epic's acceptance criteria, the PRD and the SRD's choices, using the Task template below. Leave out work that a sibling or prerequisite Epic already covers, and assume prerequisite Epics are `done` before this one runs, so no work is written twice.
   - If Tasks already exist, revise every affected Task and Subtask, whatever its status, from recorded progress and current requirements. Include removing delivered functionality that the requirements withdraw, so the software will match them. Add new work, remove obsolete unimplemented work, and leave unaffected work as it is.

2. **Plan each draft Task's Subtasks.** Work in Dependency order. For each Task, save it, then dispatch the Engineer, Test Writer and Doc Writer planners described in Dispatches. Each reads the code, tests or docs its part needs and proposes that part's Subtasks, because reading every Task's code yourself would fill your context before the Epic is planned. Combine their proposals using the guidance below. Assign each draft Task a `thinking_level:<label>` tag, as the Thinking Level guidance below describes, because develop-epic uses it for the Task's executors.
   - Before each Task, re-check the Plan. If it has returned to `draft`, stop at that boundary so planning can resume from the revised Plan.
   - If planning raises a product question, or a planner's proposal conflicts with the SRD, ask the Managing Intelligence, because planning follows the defined requirements.

3. **Check the whole Epic with the Product Manager.** Save the Tasks and Subtasks, then dispatch the Product Manager. Resolve its findings and dispatch a fresh one after significant revisions, so the revised work has an independent check. Check the Quality checklist below.

4. **Finalize the Epic.** Re-check the Plan's Gate condition, because an SRD revision may have paused planning. Only once the Product Manager's findings are resolved and the Quality checklist passes, set draft Subtasks and Tasks `defined`, then the Epic `defined`.

## Dispatches

- **Engineer planner:** launch for each Task needing source code changes. Expect implementation Subtasks grounded in the code and engineering guidance.
- **Test Writer planner:** launch for each Task needing source or unit-test changes, after engineering proposals it needs are available. Expect unit-test Subtasks, fixture planning, suggested Test Writer Lanes, and the final full-unit-suite Subtask. develop-epic's Test Reviewer checks the tests' quality independently.
- **Doc Writer planner:** launch for each Task affecting source, user-facing behaviour, installation, setup or documentation. Expect documentation Subtasks allowed by the doc-writing guide, or a reason none are needed.
- **Product Manager:** launch after saving the Epic's proposed Tasks and Subtasks. Expect an independent check that the work meets (and does not exceed) the requirements and is in proportion to them, including duplicated tests and unsafe Lane groupings, with references and suggested fixes.

## Writes

- **Tasks and Subtasks:** children of the Epic and its Tasks respectively, in the Plans store. New and revised tickets start `draft` in steps 1–2. Reset affected tickets and their parent Tasks even if previously `active` or `done`, so develop-epic executes the revised work. Delete obsolete unimplemented work. Each Task gets a `thinking_level:<label>` tag; each Subtask names its executor. Record a Dependency from each waiting Task or Subtask to its prerequisite so execution follows the required order.
- **The Epic and its draft children:** set to `defined` in step 4. The Epic records any unfinished writing, so a later Run can resume it.

## Done

Report the Epic's ID, and any Product Manager findings left unaddressed with the reason.

Suggest develop-epic on this Epic once every Epic it depends on is `done`.

## Task template

- **Context:** explain why the Task exists, the requirements it serves and what prerequisite work it assumes.
- **What needs to change:** state the work and affected code folders, following the SRD's decisions.
- **Acceptance criteria:** state observable results that demonstrate the Task's outcome.
- **Dependencies:** name Tasks that must finish first and explain why.

Describe outcomes and constraints, leaving implementation detail to the executor. Name files and modules rather than code snippets or line numbers, because prerequisite work can change the code before execution.

## Subtask template

Every Subtask names its executor: Engineer, Test Writer or Doc Writer. Include all four sections, with detail in proportion to the work:

- **Context:** explain why the Subtask exists and what preconditions it assumes. For testing, name fixtures, factories, helpers and constants it reuses, creates or changes.
- **What Needs to Change:** describe the work and requirements for that executor's part of the Task.
- **Key Files:** give concrete paths relative to a named repo's root, or a named code folder under `<Project Folder>` when there is no repo. Identify files to create as new.
- **Acceptance Criteria:** state observable, testable conditions for completion. For example, a CSV export's fields are correctly quoted and its existing JSON export still works.

## Writing guidance

Keep each Task's implementation, tests and documentation together so its outcome can be checked and committed as a whole. Reference the tickets holding applicable Managing Intelligence decisions so executors follow the current decisions.

Put testing after its implementation and documentation after its implementation and tests, so each checks the work it describes. Every Task changing source or unit tests includes a final unit-test Subtask to run the full unit suite and fix failures, to check the combined changes. Its acceptance criterion is a passing full unit suite in each affected code folder with unit tests.

Every Subtask follows the Project's Guidance Documents, because they hold the Project's own rules, which the executors also follow:
- `engineering-best-practices.md` for how the code is structured and written;
- `test-guide.md` for what kinds of tests are needed and how they're written and organized;
- `doc-writing-guide.md` for which documents need work and what belongs in them.

Write the work each guide requires, such as a test type or an engineering step, into the Task it belongs to.

## Thinking Level guidance

A Task's tag sets how hard its Engineer, Test Writer and Doc Writer think, so match it to what a mistake in that Task would cost and how much judgement it needs:
- `low`: trivial, mechanical changes such as wording or config values, where a mistake is obvious and cheap.
- `medium`: routine work that follows an established pattern, such as adding a field or a small, well-understood change.
- `high`: work that needs real design judgement, touches several modules, or changes behaviour other code relies on.
- `xhigh`: work where a mistake is costly or hard to spot, such as concurrency, security, data migrations or an interface between components.
- `max`: the hardest, highest-risk Tasks only, because it is the slowest and most expensive.

When unsure between two levels, choose the higher one.

## Writing the testing Subtasks

Write each Task's testing Subtasks with two goals in mind:

1. **Reuse the Project's test setup.** Say which existing fixtures, factories, helpers and constants the tests reuse, any changes they need, any new setup and where it goes, and which test files to extend or add, so tests don't each build their own setup.
2. **Let Test Writers work in parallel.** develop-epic can run several Test Writers on one Task, one per Lane. A **Lane** is a group of test files one Writer can change without touching another's. Suggest the Lanes in the Task: keep files together when they share a fixture or helper the Task changes, or test overlapping behaviour, so Writers don't edit the same helper or test the same thing twice. develop-epic adjusts them to the actual code.

Don't write two tests that check the same thing at the same level, such as two unit tests of the same quoting rule; tests at different levels, such as a unit test and an end-to-end test, can cover the same behaviour. Include tests to update, obsolete tests to remove and missing coverage to add. The full unit suite runs once, at the end, by the last Test Writer, so one Writer checks everyone's changes together.

## Quality checklist

- [ ] The Tasks cover the Epic's acceptance criteria and follow the PRD, SRD and recorded Managing Intelligence decisions.
- [ ] Every proposed change serves the requirements or applicable Guidance Documents, and its size fits the outcome.
- [ ] Prerequisite and sibling Epic work is accounted for, and each Task has a coherent outcome and the Dependencies it needs.
- [ ] Each Subtask has an executor, the four template sections and concrete Key Files in a named repo or code folder.
- [ ] Test proposals identify fixture reuse and changes, avoid duplicate checks at the same level, and keep test files that share changed setup in the same Lane.
- [ ] Every Task changing source or unit tests has a final full-unit-suite Subtask following its other unit-test work.
- [ ] Documentation work follows its implementation and tests and is allowed by the doc-writing guide.
- [ ] Every Task to execute has a Thinking Level suited to its complexity and risk.
- [ ] A revision covers every affected Task and Subtask, whatever its earlier status, and leaves it ready for develop-epic.
- [ ] The Product Manager has checked the whole Epic's Tasks and Subtasks, and its findings have been addressed.
