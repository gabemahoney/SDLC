---
name: write-epic
description: "Break one draft Epic into Tasks and Subtasks, or reconcile its existing work after the Plan changes."
---

# write-epic

## Purpose

Follows write-plan or a round of idea-review. Writes one Epic's Tasks and Subtasks for develop-epic.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

An Epic ID.

## Required Reading

- **Workflow:** `~/.apiary/system/workflow.md`. Why: to follow the shared Run rules.
- **Settings files:** `<Project Folder>/.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`. Why: to select the Ticket System Protocol File through `ticket_system`, and the dispatched planners' and Product Manager's Thinking Levels through `thinking_levels` and `levels_claude_code` or `levels_codex`.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` in Claude Code, or `~/.apiary/system/protocols/agent-codex.md` in Codex CLI. Why: to dispatch Subagents and ask and report through the Agent.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: to read requirements and existing work, and write Tasks, Subtasks, dependencies, tags and statuses.
- **Resolver:** `~/.apiary/system/resolvers/<resolver>.md`, selected by each Source Reference's kind. Why: to read the source material behind the Epic and its requirements.
- **Epic, Plan, all sibling Epics and existing Tasks and Subtasks:** through the Ticket System Protocol File, using the input Epic ID. Why: to establish the Epic's outcome, account for its dependencies, avoid overlapping work and reconcile earlier planning and progress.
- **Idea and its Docs:** through the Idea reference on the Plan and the Ticket System Protocol File. Why: to follow the PRD, SRD and settled decisions, including findings and Managing Intelligence answers recorded on the tickets they concern.
- **Codebase, tests and interfaces:** the affected code folders under `<Project Folder>`, if any, identified from the Epic and requirements. Why: to ground proposed Key Files and distinguish existing capabilities from work planned in prerequisite Epics.
- **Guidance Documents:** `engineering-best-practices.md`, `test-guide.md`, `doc-writing-guide.md` and `maintained-docs.md` for each affected code folder, found as `workflow.md` describes, including the documents `maintained-docs.md` lists. Why: to judge proposals against engineering conventions, plan tests and fixture reuse, and limit documentation work to what its guide allows.

## Gate

Run only when both of these are true:

- The Epic is `draft`. If it isn't, stop and report its status.
- Its Plan is `defined` or `active`. If it isn't, stop and suggest write-plan.

## Steps

1. **Outline the Tasks.** Follow the Epic's acceptance criteria, the PRD and the SRD's choices. Account for all sibling Epics and assume prerequisite Epics deliver their stated outcomes before execution. Use the Task template below.
   - If Tasks already exist, reconcile them with current requirements and recorded progress. Preserve `done` Tasks and Subtasks. Revise, add or drop unfinished work; put further changes to completed capabilities into unfinished Tasks.

2. **Plan each Task's Subtasks.** Work through Tasks in dependency order. Use executor planners for detailed research, because this skill needs its context for the remaining Tasks. Combine their proposals using the guidance below. Assign each unfinished Task a `thinking_level:<label>` tag suited to its complexity and risk.
   - Before each Task, re-check the Plan. If it has returned to `draft`, stop at that boundary so planning can resume from the revised Plan.
   - If proposals require a product decision or conflict with the SRD's choices, stop for the Managing Intelligence's decision. Record it on the affected ticket.

3. **Check the whole Epic with the Product Manager.** Save the proposed Tasks and Subtasks, then dispatch the Product Manager. Revise from its findings and check the Quality checklist below. Record findings and their resolution on the tickets they concern.

4. **Finalize the Epic.** Re-check the Plan's Gate condition. After the Product Manager's check and revision, set unfinished Subtasks and Tasks `defined`, then the Epic `defined`.

## Dispatches

- **Engineer planner:** launch for each Task needing source changes. Expect implementation Subtasks grounded in the code and engineering guidance.
- **Test Writer planner:** launch for each Task needing source or unit-test changes, after engineering proposals it needs are available. Expect unit-test Subtasks, fixture planning, suggested Test Writer lanes and the final full-unit-suite Subtask.
- **Doc Writer planner:** launch for each Task affecting source, user-facing behaviour, installation, setup or documentation. Expect documentation Subtasks allowed by the doc-writing guide, or a reason none are needed.
- **Product Manager:** launch after saving the Epic's proposed Tasks and Subtasks. Expect an independent check that the work meets the requirements and is in proportion to them, including duplicated tests and unsafe lane groupings, with references and suggested fixes.

## Writes

Tasks are children of the Epic in the Plans store, with dependencies and `thinking_level:<label>` tags. Subtasks are children of their Tasks, with executors and dependencies. Create or revise unfinished Tasks and Subtasks as `draft`, then set them and the Epic `defined` in step 4. Remove dropped unfinished work through the Ticket System Protocol File.

Record findings and Managing Intelligence decisions on the tickets they concern. The Epic holds the planning result and any incomplete work for a later Run.

## Done

Report the Epic's ID and status, Tasks in dependency order with their Thinking Levels, test lanes and integration flags, and the Product Manager's findings and resulting revisions. Include incomplete work and decisions still needed. For a revision, identify work preserved, revised, added or dropped.

Suggest develop-epic when its prerequisites are met; otherwise report what remains.

## Task template

- **Context:** explain why the Task exists, the requirements it serves and what prerequisite work it assumes.
- **What needs to change:** state the work and affected code folders, following the SRD's decisions.
- **Acceptance criteria:** state observable results that demonstrate the Task's outcome.
- **Dependencies:** name Tasks that must finish first and explain why.

Size each Task for one commit per affected repo. Describe outcomes and constraints, leaving implementation detail to the executor. Name files and modules rather than code snippets or line numbers.

## Subtask template

Every Subtask names its executor: Engineer, Test Writer or Doc Writer. Include all four sections, with detail in proportion to the work:

- **Context:** explain why the Subtask exists and what preconditions it assumes. For testing, name fixtures, factories, helpers and constants it reuses, creates or changes.
- **What Needs to Change:** describe the work and requirements for that executor's part of the Task.
- **Key Files:** give concrete paths relative to a named repo's root, or a named code folder under `<Project Folder>` when there is no repo. Identify files to create as new.
- **Acceptance Criteria:** state observable, testable conditions for completion. For example, a CSV export's fields are correctly quoted and its existing JSON export still works.

## Planning guidance

Keep each Task's implementation, tests and documentation together. Assign prerequisite work to the Epic that owns it and reference that dependency.

Carry recorded Managing Intelligence decisions word for word into affected Subtasks, so execution preserves them.

Put testing after its implementation and documentation after its implementation and tests. Every Task changing source or unit tests includes a final unit-test Subtask to run the full unit suite and fix failures. Its acceptance criterion is a passing full unit suite in each affected code folder with unit tests.

Plan documentation as `doc-writing-guide.md` allows. Consider user-facing documentation when behaviour, installation or setup changes, and architecture documentation when source changes affect the design. Use the maintained documents to identify which files need revision.

Integration Tester writes and runs integration tests during develop-epic. Flag each Task changing a contract, API, schema or other cross-component interface with a `## Run Integration After This Task` section. In it, state `Interface changed:` followed by the interface and the change. This tells develop-epic to run its integration check after that Task.

## Fixture planning and Test Writer lanes

Plan which existing fixtures, factories, helpers and constants tests reuse, what changes they need, which new fixtures are needed and where they belong, and which test files to extend or add. This lets tests share established setup.

Organize unit-test Subtasks by test file or logical group of files. Give each behaviour one coverage owner. Account for tests to update, obsolete tests to remove and missing coverage to add.

A Test Writer lane is a group of test files one Test Writer can change independently. Keep files together when they share a fixture or helper the Task creates or changes, or when their tested behaviours overlap. Give each resulting independent group a lane. The final full-unit-suite Subtask follows all lanes and belongs to the final Test Writer.

For each Task with unit-test Subtasks, end its description with a `## Test Writer Lanes` section. State the suggested lane count, list each lane's test files with their repo or code folder, and name shared fixtures or helpers, or state that there are none. These are suggestions for develop-epic to reconcile with the code at execution time.

## Quality checklist

- [ ] The Tasks cover the Epic's acceptance criteria and follow the PRD, SRD and recorded Managing Intelligence decisions.
- [ ] Every proposed change serves the requirements or applicable Guidance Documents, and its size fits the outcome.
- [ ] Prerequisite and sibling Epic work is accounted for, and each Task has a coherent outcome and the dependencies it needs.
- [ ] Each Subtask has an executor, the four template sections and concrete Key Files in a named repo or code folder.
- [ ] Test proposals identify fixture reuse and changes, give behaviours a single coverage owner and group dependent test files in the same lane.
- [ ] Every Task changing source or unit tests has a final full-unit-suite Subtask following its other unit-test work.
- [ ] Each Task changing an interface carries the integration flag, and the flag identifies that change.
- [ ] Documentation work follows its implementation and tests and is allowed by the doc-writing guide.
- [ ] Every unfinished Task has a Thinking Level suited to its complexity and risk.
- [ ] Revisions preserve completed work and reconcile unfinished work with current requirements.
- [ ] The Product Manager has checked the whole Epic's planned work, and its findings have been addressed.
