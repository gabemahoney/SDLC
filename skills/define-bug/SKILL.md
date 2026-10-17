---
name: define-bug
description: "Validate a draft Bug from its report, Source References and code, preserve its reproduction, and mark it defined or invalid. Takes a Bug ID."
---

# define-bug

## Purpose

Validates a Bug report and preserves the evidence and reproduction for fix-bug. It also revalidates Bugs whose fixes the Managing Intelligence returned.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

A Bug ID.

## Required Reading

- **Settings:** Project and default settings, resolved as `~/.apiary/system/workflow.md` describes, for this Run's configuration.
- **Agent Protocol File:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md` under `~/.apiary/system/protocols/`, for the Main Agent's own context readings and skill invocation.
- **Ticket System Protocol File:** selected by `setting:ticket_system` as `~/.apiary/system/workflow.md` describes, to read and update the Bug, its status and its tags.
- **The Bug and its Dependencies:** to check readiness and read the report, earlier validation, retained reproduction and Managing Intelligence decisions, including why a fix was returned.
- **Bug writing guidance:** `guide:bug-writing-guide.md`, found as `~/.apiary/system/workflow.md` describes, to complete the Bug's write-up in the Project's format.
- **Build commands:** `guide:build-commands.md`, found as `~/.apiary/system/workflow.md` describes, to run the relevant commands for each repo involved in reproduction.

For Source References, read `~/.apiary/system/resolvers/<resolver>.md`, selected by kind, to access the original report.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when all of these are true:

- The Bug is `draft`. If it isn't, stop and report its status.
- Every ticket the Bug depends on is `done`, so validation uses the completed prerequisites. If any isn't, stop and report the blocking ticket IDs.

## Steps

1. **Complete the report.** Fill out the Bug from its supplied evidence and any Source References, following `guide:bug-writing-guide.md`. Incorporate earlier validation and the Managing Intelligence's decisions into the write-up so fix-bug has one current account of the defect.

2. **Validate the reported behaviour.** Reproduce it in the main checkouts using the guidance below. Keep scratch scripts and inputs outside the repos so validation leaves repository files unchanged. For a returned fix, check the retained reproduction and new evidence against the current software, because the earlier validation predates the repair.
   - If reproduction cannot establish whether the report is real or would require repository edits, review the source for evidence that settles it.

3. **Record the outcome on the Bug.** Save the evidence, reproduction and conclusion.
   - If reproduction, source evidence or the Managing Intelligence's recorded decision establishes that the Bug is real, set it `defined` for fix-bug.
   - If the reported behaviour cannot happen or is intended, set the Bug `invalid` and explain why, citing the evidence or the Managing Intelligence's decision.
   - If the result is inconclusive, leave the Bug `draft`, record what was tried and why it is inconclusive, and ask the Managing Intelligence whether the Bug is real. Record their decision on the Bug and apply the corresponding outcome above.

## Child Agents

None: define-bug validates the Bug itself.

## Writes

The Bug's write-up, validation evidence, retained reproduction and Managing Intelligence decisions, with its status set by step 3. Before setting a confirmed Bug `defined`, save its evidence and set or replace its `thinking_level:<label>` tag to match the fix's current complexity and risk, so fix-bug receives the evidence and Thinking Level its executors need.

## Done

Report the Bug's ID and its status.

- If it's `defined`, suggest fix-bug.
- If it's still `draft`, report what is needed to settle it.

## Reproduction guidance

- **Keep the exact symptom.** Follow the reporter's steps with their inputs, setup and expected and actual behaviour. Exercise the boundary where the real interaction happens, because an isolated component test can miss the reported failure.
- **Keep it runnable.** Store the commands or script contents, required inputs, setup and observed result on the Bug, so fix-bug can rerun the original scenario after the fix. Retain the reproduction across a returned fix and update it with the reporter's new evidence.
- **Separate evidence from inference.** Record what actually ran and what it showed. If source inspection settles the report, cite the relevant code and explain why it proves the conclusion. Keep any attempted reproduction and state what prevented it from demonstrating the symptom.
