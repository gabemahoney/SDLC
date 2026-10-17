---
name: define-bug
description: "Validate a draft Bug from its report, Source References and code, preserve its reproduction, and mark it defined or invalid. Takes a Bug ID."
---

# define-bug

## Purpose

Follows write-bug and validates the report before fix-bug. Re-runs validate Bugs returned to `draft` by the Managing Intelligence.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

A Bug ID.

## Required Reading

- **Settings files:** `<Project Folder>/.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`. Why: to select the Ticket System Protocol File through `ticket_system`.
- **Your Agent's Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` in Claude Code, or `~/.apiary/system/protocols/agent-codex.md` in Codex CLI. Why: to ask the Managing Intelligence questions and report through this Agent.
- **The Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: to read and update the Bug, its status and its tags.
- **The Bug:** through the Ticket System Protocol File, using the input ID. Why: to read the report, earlier validation, retained reproduction and Managing Intelligence decisions, including why a fix was returned.
- **Resolvers:** `~/.apiary/system/resolvers/<resolver>.md`, selected by each Source Reference's kind. Why: to read the Bug's source material and fill out its report.
- **Bug writing guidance:** `bug-writing-guide.md`, found as `workflow.md` describes. Why: to complete the Bug's write-up in the Project's format.
- **Build commands:** `build-commands.md`, found as `workflow.md` describes. Why: to run the relevant commands for each repo involved in reproduction.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

The Bug is `draft`. If it isn't, stop and report its status.

## Steps

1. **Complete the report.** Fill out the Bug from its Source References and supplied evidence, following `bug-writing-guide.md`. Incorporate any earlier validation and the Managing Intelligence's decisions recorded on the Bug.

2. **Validate the reported behaviour.** Reproduce it in the main checkouts using the guidance below. Keep scratch scripts and inputs outside the repos so validation leaves tracked files unchanged.
   - If reproduction cannot establish whether the report is real, review the source for evidence that settles it.

3. **Record the outcome on the Bug.** Save the evidence, reproduction and conclusion.
   - If reproduction, source evidence or the Managing Intelligence's recorded decision establishes that the Bug is real, set it `defined` and assign a `thinking_level:<label>` tag suited to the fix's complexity and risk, because fix-bug uses it for the Bug's executors.
   - If the reported behaviour cannot happen or is intended, set the Bug `invalid` and explain why, citing the evidence or the Managing Intelligence's decision.
   - If the result is inconclusive, leave the Bug `draft`, record what was tried and why it is inconclusive, and ask the Managing Intelligence whether the Bug is real. Record their decision on the Bug and apply the corresponding outcome above.

## Dispatches

None: define-bug validates the Bug itself.

## Writes

The Bug's write-up, validation evidence, runnable reproduction and Managing Intelligence decisions. A confirmed Bug becomes `defined` with a `thinking_level:<label>` tag; an invalid report becomes `invalid` with its reason. An inconclusive Bug stays `draft`.

## Done

Report the Bug's ID, status, validation evidence, reproduction result and any unresolved decision.

- If the Bug is `defined`, report its Thinking Level and suggest "fix-bug".
- If the Bug is `invalid`, report why.
- If the Bug is still `draft`, report what is needed to settle it.

## Reproduction guidance

- **Keep the exact symptom.** Follow the reporter's steps with their inputs, setup and expected and actual behaviour. Exercise the boundary where the real interaction happens, because an isolated component test can miss the reported failure.
- **Keep it runnable.** Store the commands or script contents, required inputs, setup and observed result on the Bug, so fix-bug can rerun the original scenario after the fix. Retain the reproduction across a returned fix and update it with the reporter's new evidence.
- **Separate evidence from inference.** Record what actually ran and what it showed. If source inspection settles the report, cite the relevant code and explain why it proves the conclusion. Keep any attempted reproduction and state what prevented it from demonstrating the symptom.
