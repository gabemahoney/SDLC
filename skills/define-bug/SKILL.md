---
name: define-bug
description: "Reproduce a draft Bug to confirm it's real, record how to reproduce it, and mark it defined or invalid. Takes a Bug ID."
---

# define-bug

## Purpose

You reproduce a reported Bug to confirm it's real, and record how you reproduced it so fix-bug can rerun it. You also re-check Bugs whose fixes the Managing Intelligence returned.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

A Bug ID.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md` and the Ticket System Protocol File selected by `setting:ticket_system`, for operations.
- **Bug and its Dependencies:** for readiness, the report, validation, reproduction and decisions.
- **Guidance:** `guide:bug-writing-guide.md` and `guide:build-commands.md`, for the report, validation standards and reproduction commands.

Also read the Project's code, tests and linked Research as needed, and any Source References through their Resolvers.

## Gate

Run only when all of these are true:

- The Bug is `draft`. If it isn't, stop and report its status.
- Every ticket the Bug depends on is `done`, so validation uses the completed prerequisites. If any isn't, stop and report the blocking ticket IDs.

## Steps

1. **Complete the report.** Follow `guide:bug-writing-guide.md` using the supplied evidence, Source References and earlier decisions, so fix-bug has one current account of the defect. The Managing Intelligence settles unclear expected behaviour.

2. **Validate the behaviour.** Reproduce it in the main checkouts under the Bug-writing guidance. Keep scratch scripts and inputs outside repos so validation leaves repository files unchanged. For a returned fix, use the retained scenario and new evidence against current software, because the earlier validation predates the repair. If reproduction is inconclusive or requires repository edits, use source evidence to settle the report.

3. **Record the outcome** using the Bug sections below.
   - Confirmed by reproduction, source evidence or the Managing Intelligence's decision: set `defined` for fix-bug.
   - Evidence or a Managing Intelligence decision establishes that the behaviour cannot happen or is intended: set `invalid`, with the reason.
   - Inconclusive: leave `draft`, record the limitation and ask the Managing Intelligence whether the Bug is real. Record their decision and apply the corresponding outcome.

## Child Agents

None: you validate the Bug yourself.

## Writes

Update the Bug in the Bugs store, setting its status in step 3:

- `## Report`: the current write-up under `guide:bug-writing-guide.md`.
- `## Validation`: evidence, conclusion and any limitations.
- `## Reproduction`: commands or scripts, inputs, setup and observed result, so fix-bug can rerun the reported scenario. Retain it across returned fixes and incorporate new evidence; explain when it cannot run.
- `## Decisions`: the Managing Intelligence's decisions.

Set or replace `thinking_level:<label>` when confirming the Bug, matching the fix's current complexity and risk, because fix-bug uses it for its executors.

## Done

Report the Bug's ID, status and unresolved work with reasons.

- If it's `defined`, suggest fix-bug.
- If it's still `draft`, report what is needed to settle it.
