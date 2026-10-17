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
- **Guidance Documents:** `engineering-best-practices.md`, `test-guide.md`, `doc-writing-guide.md` and `maintained-docs.md` for each affected code folder, found as `workflow.md` describes, including the documents `maintained-docs.md` lists. Why: so the Tasks and Subtasks it writes follow the Project's engineering, testing and documentation guidance.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when all of these are true:

- The Epic is `draft`. If it isn't, stop and report its status.
- Its Plan is `defined` or `active`. If it isn't, stop and suggest write-plan.

## Steps

1. **Write or revise the Tasks.** Follow the Epic's acceptance criteria, the PRD and the SRD's choices, using the Task template below. Account for sibling Epics and plan on prerequisite Epics delivering their outcomes before execution, so their work is planned once.
   - If Tasks already exist, revise every affected Task and Subtask, whatever its status, from recorded progress and current requirements. Include removing delivered functionality that the requirements withdraw, so the software will match them. Add new work, remove obsolete unimplemented work, and leave unaffected work as it is.

2. **Plan each draft Task's Subtasks.** Work in Dependency order. Save the Task before dispatching its planners, so they can read it. Use planners for detailed research to keep this skill's context available for the whole Epic. Combine their proposals using the guidance below. Assign each draft Task a `thinking_level:<label>` tag suited to its complexity and risk, because develop-epic uses it for the Task's executors.
   - Before each Task, re-check the Plan. If it has returned to `draft`, stop at that boundary so planning can resume from the revised Plan.
   - The Managing Intelligence decides product questions and conflicts with the SRD's choices, because planning follows the defined requirements.

3. **Check the whole Epic with the Product Manager.** Save the Tasks and Subtasks, then dispatch the Product Manager. Resolve its findings and dispatch a fresh one after significant revisions, so the revised work has an independent check. Check the Quality checklist below.

4. **Finalize the Epic.** Re-check the Plan's Gate condition, because an SRD revision may have paused planning. Only once the Product Manager's findings are resolved and the Quality checklist passes, set draft Subtasks and Tasks `defined`, then the Epic `defined`.

## Dispatches

- **Engineer planner:** launch for each Task needing source changes. Expect implementation Subtasks grounded in the code and engineering guidance.
- **Test Writer planner:** launch for each Task needing source or unit-test changes, after engineering proposals it needs are available. Expect unit-test Subtasks, fixture planning, suggested Test Writer Lanes and the final full-unit-suite Subtask.
- **Doc Writer planner:** launch for each Task affecting source, user-facing behaviour, installation, setup or documentation. Expect documentation Subtasks allowed by the doc-writing guide, or a reason none are needed.
- **Product Manager:** launch after saving the Epic's proposed Tasks and Subtasks. Expect an independent check that the work meets the requirements and is in proportion to them, including duplicated tests and unsafe Lane groupings, with references and suggested fixes.

## Writes

- **Tasks and Subtasks:** children of the Epic and its Tasks respectively, in the Plans store. New and revised tickets start `draft` in steps 1–2. Reset affected tickets and their parent Tasks even if previously `active` or `done`, so develop-epic executes the revised work. Delete obsolete unimplemented work. Each Task gets a `thinking_level:<label>` tag; each Subtask names its executor. Record a Dependency from each waiting Task or Subtask to its prerequisite so execution follows the required order.
- **The Epic and its draft children:** set to `defined` in step 4. The Epic holds incomplete planning work so a later Run can resume it.

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

## Planning guidance

Keep each Task's implementation, tests and documentation together so its outcome can be checked and committed as a whole. Reference the tickets holding applicable Managing Intelligence decisions so executors follow the current decisions.

Put testing after its implementation and documentation after its implementation and tests, so each checks the work it describes. Every Task changing source or unit tests includes a final unit-test Subtask to run the full unit suite and fix failures, to check the combined changes. Its acceptance criterion is a passing full unit suite in each affected code folder with unit tests.

Plan documentation as `doc-writing-guide.md` allows. Consider user-facing documentation when behaviour, installation or setup changes, and architecture documentation when source changes affect the design. Use the maintained documents to identify which files need revision.

Integration Tester writes and runs integration tests during develop-epic. Flag each Task changing a contract, API, schema or other cross-component interface with a `## Run Integration After This Task` section. In it, state `Interface changed:` followed by the interface and the change. This tells develop-epic to run its integration check after that Task.

## Fixture planning and Test Writer Lanes

Plan which existing fixtures, factories, helpers and constants tests reuse, what changes they need, which new fixtures are needed and where they belong, and which test files to extend or add. This lets tests share established setup.

Organize unit-test Subtasks by test file or logical group of files. Give each behaviour one coverage owner, so parallel Writers do not duplicate tests. Account for tests to update, obsolete tests to remove and missing coverage to add.

A **Lane** is a group of unit-test files one Test Writer can change independently. Keep files together when they share a fixture or helper the Task creates or changes, or when their tested behaviours overlap, so parallel Writers do not conflict or duplicate coverage. Give each resulting independent group a Lane. The final full-unit-suite Subtask follows all Lanes and belongs to the final Test Writer, so one Writer checks their combined changes.

For each Task with unit-test Subtasks, end its description with a `## Test Writer Lanes` section. State the suggested number of Lanes, list each Lane's test files with their repo or code folder, and name shared fixtures or helpers, or state that there are none. These are suggestions for develop-epic to reconcile with the code at execution time.

## Quality checklist

- [ ] The Tasks cover the Epic's acceptance criteria and follow the PRD, SRD and recorded Managing Intelligence decisions.
- [ ] Every proposed change serves the requirements or applicable Guidance Documents, and its size fits the outcome.
- [ ] Prerequisite and sibling Epic work is accounted for, and each Task has a coherent outcome and the Dependencies it needs.
- [ ] Each Subtask has an executor, the four template sections and concrete Key Files in a named repo or code folder.
- [ ] Test proposals identify fixture reuse and changes, give behaviours a single coverage owner and group dependent test files in the same Lane.
- [ ] Every Task changing source or unit tests has a final full-unit-suite Subtask following its other unit-test work.
- [ ] Each Task changing an interface carries the integration flag, and the flag identifies that change.
- [ ] Documentation work follows its implementation and tests and is allowed by the doc-writing guide.
- [ ] Every Task to execute has a Thinking Level suited to its complexity and risk.
- [ ] A revision covers every affected Task and Subtask, whatever its earlier status, and leaves it ready for develop-epic.
- [ ] The Product Manager has checked the whole Epic's planned work, and its findings have been addressed.
