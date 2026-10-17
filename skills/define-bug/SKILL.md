---
name: define-bug
description: "Validate a draft Bug from its report, Source References and code, preserve its reproduction, and mark it defined or invalid. Takes a Bug ID."
---

# define-bug

## Purpose

Validates a Bug report and preserves the evidence and reproduction for fix-bug. It also revalidates Bugs whose fixes the Managing Intelligence returned.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

A Bug ID.

## Required Reading

- **Workflow:** `~/.apiary/system/workflow.md`. Why: to follow the shared Run rules.
- **Settings files:** `<Project Folder>/.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`. Why: to select the Ticket System Protocol File through `ticket_system`.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` in Claude Code, or `~/.apiary/system/protocols/agent-codex.md` in Codex CLI. Why: to ask and report through the Agent.
- **The Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: to read and update the Bug, its status and its tags.
- **The Bug and its Dependencies:** through the Ticket System Protocol File, using the input ID. Why: to check readiness and read the report, earlier validation, retained reproduction and Managing Intelligence decisions, including why a fix was returned.
- **Bug writing guidance:** `bug-writing-guide.md`, found as `workflow.md` describes. Why: to complete the Bug's write-up in the Project's format.
- **Build commands:** `build-commands.md`, found as `workflow.md` describes. Why: to run the relevant commands for each repo involved in reproduction.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when all of these are true:

- The Bug is `draft`. If it isn't, stop and report its status.
- Every ticket the Bug depends on is `done`, so validation uses the completed prerequisites. If any isn't, stop and report the blocking ticket IDs.

## Steps

1. **Complete the report.** Fill out the Bug from its supplied evidence and any Source References, following `bug-writing-guide.md`. For each Source Reference, read `~/.apiary/system/resolvers/<resolver>.md`, selected by its kind, to access the source material. Incorporate earlier validation and the Managing Intelligence's decisions into the write-up so fix-bug has one current account of the defect.

2. **Validate the reported behaviour.** Reproduce it in the main checkouts using the guidance below. Keep scratch scripts and inputs outside the repos so validation leaves repository files unchanged. For a returned fix, check the retained reproduction and new evidence against the current software, because the earlier validation predates the repair.
   - If reproduction cannot establish whether the report is real or would require repository edits, review the source for evidence that settles it.

3. **Record the outcome on the Bug.** Save the evidence, reproduction and conclusion.
   - If reproduction, source evidence or the Managing Intelligence's recorded decision establishes that the Bug is real, set it `defined` for fix-bug.
   - If the reported behaviour cannot happen or is intended, set the Bug `invalid` and explain why, citing the evidence or the Managing Intelligence's decision.
   - If the result is inconclusive, leave the Bug `draft`, record what was tried and why it is inconclusive, and ask the Managing Intelligence whether the Bug is real. Record their decision on the Bug and apply the corresponding outcome above.

## Dispatches

None: define-bug validates the Bug itself.

## Writes

The Bug's write-up, validation evidence, retained reproduction and Managing Intelligence decisions, with its status set by step 3. Before setting a confirmed Bug `defined`, save its evidence and set or replace its `thinking_level:<label>` tag to match the fix's current complexity and risk, so fix-bug receives the evidence and Thinking Level its executors need.

## Done

Report the Bug's ID and any findings or feedback left unaddressed with the reason.

## Reproduction guidance

- **Keep the exact symptom.** Follow the reporter's steps with their inputs, setup and expected and actual behaviour. Exercise the boundary where the real interaction happens, because an isolated component test can miss the reported failure.
- **Keep it runnable.** Store the commands or script contents, required inputs, setup and observed result on the Bug, so fix-bug can rerun the original scenario after the fix. Retain the reproduction across a returned fix and update it with the reporter's new evidence.
- **Separate evidence from inference.** Record what actually ran and what it showed. If source inspection settles the report, cite the relevant code and explain why it proves the conclusion. Keep any attempted reproduction and state what prevented it from demonstrating the symptom.
