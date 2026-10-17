---
name: write-idea
description: "File a new Idea from a description of the work or intake input such as an issue URL, following the Project's `setting:new_idea_intake`."
---

# write-idea

## Purpose

Files a new Idea in `draft`. It is the first step of the Idea flow; write-prd comes next.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

A description of the work, or intake input such as an issue URL.

## Required Reading

- **Settings:** Project and default settings, resolved as `~/.apiary/system/workflow.md` describes, for this Run's configuration.
- **Intake instructions:** `~/.apiary/system/intakes/interview.md` for the interview intake, or `~/.apiary/system/resolvers/<resolver>.md` for the Source Reference resolver named by `setting:new_idea_intake`. Why: to check the input and prepare the Idea according to that intake.
- **Agent Protocol File:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md` under `~/.apiary/system/protocols/`, for the Main Agent's own context readings and skill invocation.
- **Ticket System Protocol File:** selected by `setting:ticket_system` as `~/.apiary/system/workflow.md` describes, to create the Idea and store its body and any Source Reference.

## Gate

None: write-idea creates a new ticket.

## Steps

1. **Check the input.** Follow the intake named by `setting:new_idea_intake`.
   - If the input doesn't fit, stop and ask the Managing Intelligence for what's needed.
2. **Prepare the Idea.**
   - If the intake names a Source Reference resolver, store the input as the Idea's Source Reference, so write-prd can read the original context.

   Follow the intake's instructions for the Idea's body.
3. **File the Idea.** Create it in the Ideas store with status `draft`.

## Child Agents

None: write-idea files the Idea itself.

## Writes

- A new Idea in the Ideas store, status `draft`.

## Done

Print the Idea's ID. Next step: "write-prd".
