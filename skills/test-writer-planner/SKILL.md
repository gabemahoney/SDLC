---
name: test-writer-planner
description: "Write unit and integration testing Subtasks for a Task ID during write-epic."
---

# test-writer-planner

## Purpose

You write testing Subtasks and plan fixture work for write-epic.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

A Task ID.

## Required Reading

- **Launcher:** `protocol:launcher.md`, for how you work as a Child Agent and report to your Main Agent.
- **Protocols:** Read `protocol:ticket.md` and your supplied Agent Protocol File for ticket access and Agent rules.
- **Your Task:** Read it; it holds everything you need to do.
- **Guidance:** Read `guide:test-guide.md` for required coverage and testing standards.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when your Task is `draft`, because write-epic is planning its work. Otherwise, stop and report its status.

## Steps

1. **Plan coverage.** Plan unit and integration tests from the Task, implementation Subtasks and existing tests under `guide:test-guide.md`. Match coverage to the changes without duplicating checks. Identify fixtures and helpers to reuse, create or change.
2. **Ask before choosing.** When the SRD leaves open a design choice the Subtasks must commit to, ask your Main Agent, because design choices belong to the Managing Intelligence.
3. **Write Subtasks.** Create or revise your Subtasks as `draft` children of the Task using the template below. No two testing Subtasks may edit the same file, because during develop-epic each one gets its own `test-writer` and they run at the same time. Tests that share a helper the Task changes go in one Subtask. Include implementation prerequisites so testing follows its source work.
4. **Make edits.** When your Main Agent sends edits, apply them to your Subtasks.

## Child Agents

None: you plan and write the testing Subtasks yourself.

## Writes

Your Subtask tickets, `draft` only.

## Done

Report the Subtask IDs, incomplete planning and questions to your Main Agent as `protocol:launcher.md` describes. Explain when no testing Subtasks are needed.

## Subtask template

Every Subtask has these sections, with detail in proportion to the work:

- `## Executor`: `test-writer`, so develop-epic knows which Child Agent works it.
- `## Context`: explain why the Subtask exists and what preconditions it assumes. For code, name what depends on the code it changes and what that code depends on, so the executor sees what a change could break.
- `## Work`: describe the work and requirements for that executor's part of the Task.
- `## Key files`: give concrete paths relative to a named repo's root, or a named code folder under `<Project Folder>` when there is no repo. Identify files to create as new.
- `## Acceptance criteria`: state observable, testable conditions for completion. For example, a CSV export's fields are correctly quoted and its existing JSON export still works.
