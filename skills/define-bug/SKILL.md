---
name: define-bug
description: "Check a draft Bug against the docs and reproduce it to confirm it's a real defect, record how to reproduce it, and mark it defined or invalid. Takes a Bug ID."
---

# define-bug

## Purpose

You check a reported Bug is a real defect rather than intended behaviour, reproduce it, and record how you reproduced it so fix-bug can rerun it.

## Loading SDLC

Read `~/.sdlc/system/workflow.md` first for shared rules, settings and file locations.

## Input

A Bug ID.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** your Agent Protocol File (`protocol:agent-claude-code.md`, `protocol:agent-codex.md` or `protocol:agent-cursor.md`) and the Ticket System Protocol File selected by `setting:ticket_system`, for operations.
- **Bug and its Dependencies:** for readiness, the report, validation, reproduction and decisions.
- **Guidance:** `guide:bug-writing-guide.md`, for the report, and `guide:build-commands.md` when reproducing needs a build or tests.

- **Documentation:** the Project's user and internal docs, such as its README, `docs/`, architecture docs and the PRDs and SRDs behind the feature, for its intended behaviour.

Also read the Project's code, tests and linked Research as needed, and any Source References through their Resolvers.

## Gate

Run only when all of these are true:

- The Bug is `draft`. If it isn't, stop and report its status.
- Every ticket the Bug depends on is `done`, so validation uses the completed prerequisites. If any isn't, stop and report the blocking ticket IDs.

## Steps

1. **Check the expected behaviour.** Compare the report's expected result with what the Project's user and internal docs say the software should do, because behaviour the docs describe as a design choice isn't a Bug. If they show the reported behaviour is intended, mark it `invalid` as step 4 describes, citing the docs. The Managing Intelligence settles expected behaviour the docs leave unclear.

2. **Reproduce the Bug** in the main checkouts, at the boundary where the real interaction happens, because an isolated component test can miss the reported failure. Put scratch scripts and inputs in `<Project Folder>/.scratch/<Bug ID>/`, so tracked repository files stay unchanged; build output in the checkouts is fine. If reproducing it would need tracked repository files edited, use source evidence instead, citing the code and why it proves the conclusion. Record what ran and what it showed, keeping what you saw separate from what you infer.

3. **Write up the report** using `guide:bug-writing-guide.md`, from the original report and what you found, so fix-bug has one current account of the defect.

4. **Record the outcome** using the Bug sections below.
   - Confirmed by reproduction, source evidence or the Managing Intelligence's decision: set its Thinking Level tag (below), then set it `defined` for configure-worktree.
   - The docs, evidence or a Managing Intelligence decision establish that the behaviour is intended or cannot happen: set `invalid`, with the reason.
   - Inconclusive: leave it `draft`, record what you couldn't establish, and ask the Managing Intelligence for guidance.

## Child Agents

None: you validate the Bug yourself.

## Writes

Update the Bug in the Bugs store, setting its status in step 4:

- `## Report`: the current write-up, holding whatever `guide:bug-writing-guide.md` says a report contains.
- `## Validation`: evidence, conclusion and anything you couldn't establish.
- `## Reproduction`: commands or scripts, inputs, setup, the code revision, and the expected and observed results, so fix-bug can rerun the reported scenario. Include each repo's main checkout path for the repos the reproduction touched and the repos the fix is likely to change, so configure-worktree can find them. If it cannot run, say why.
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
