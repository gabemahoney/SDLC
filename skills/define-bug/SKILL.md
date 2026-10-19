---
name: define-bug
description: "Reproduce a draft Bug to confirm it's real, record how to reproduce it, and mark it defined or invalid. Takes a Bug ID."
---

# define-bug

## Purpose

You reproduce a reported Bug to confirm it's real, and record how you reproduced it so fix-bug can rerun it.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

A Bug ID.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md` and the Ticket System Protocol File selected by `setting:ticket_system`, for operations.
- **Bug and its Dependencies:** for readiness, the report, validation, reproduction and decisions.
- **Guidance:** `guide:bug-writing-guide.md`, for the report and validation standards, and `guide:build-commands.md` when reproducing needs a build or tests.

Also read the Project's code, tests and linked Research as needed, and any Source References through their Resolvers.

## Gate

Run only when all of these are true:

- The Bug is `draft`. If it isn't, stop and report its status.
- Every ticket the Bug depends on is `done`, so validation uses the completed prerequisites. If any isn't, stop and report the blocking ticket IDs.

## Steps

1. **Reproduce the Bug** in the main checkouts, following `guide:bug-writing-guide.md`. Put scratch scripts and inputs in `<Project Folder>/.scratch/<Bug ID>/`, so tracked repository files stay unchanged; build output in the checkouts is fine. If reproducing it would need tracked repository files edited, use source evidence instead. The Managing Intelligence settles unclear expected behaviour.

2. **Write up the report** using `guide:bug-writing-guide.md`, from the original report and what you found, so fix-bug has one current account of the defect.

3. **Record the outcome** using the Bug sections below.
   - Confirmed by reproduction, source evidence or the Managing Intelligence's decision: set its Thinking Level tag (below), then set it `defined` for configure-worktree.
   - Evidence or a Managing Intelligence decision establishes that the behaviour cannot happen or is intended: set `invalid`, with the reason.
   - Inconclusive: leave it `draft`, record what you couldn't establish, and ask the Managing Intelligence for guidance.

## Child Agents

None: you validate the Bug yourself.

## Writes

Update the Bug in the Bugs store, setting its status in step 3:

- `## Report`: the current write-up, holding whatever `guide:bug-writing-guide.md` says a report contains.
- `## Validation`: evidence, conclusion and anything you couldn't establish.
- `## Reproduction`: commands or scripts, inputs, setup, the code revision, and the expected and observed results, so fix-bug can rerun the reported scenario. Include each repo's main checkout path for the repos the reproduction touched, so configure-worktree can find them. If it cannot run, say why.
- `## Decisions`: the Managing Intelligence's decisions.

Before you finish, attach any script or input fix-bug needs to rerun the reproduction to the Bug, through `protocol:ticket.md`, and point `## Reproduction` at the attached copies, then delete the scratch files you made there.

Set or replace `thinking_level:<label>` when confirming the Bug, because it sets how hard fix-bug's `engineer`, `test-writer` and `doc-writer` think. Use `medium` or above, because even a small fix goes through reproduction, regression tests and review. Match it to how hard the fix is and what a mistake in it would cost:
- `medium`: routine fixes in one place that follow an established pattern, including trivial ones such as wording or a config value.
- `high`: fixes that need real design judgement, touch several modules, or change behavior other code relies on.
- `xhigh`: fixes where a mistake is costly or hard to spot, such as concurrency, security, data corruption or an interface between components.
- `max`: the hardest, highest-risk fixes only, because it is the slowest and most expensive.

When unsure between two levels, choose the higher one.

## Done

Report the Bug's ID, status and unresolved work with reasons.

- If it's `defined`, suggest configure-worktree.
- If it's still `draft`, report what is needed to settle it.
