---
name: write-idea
description: "File a new Idea from a description of the work, following the Project's `setting:new_idea_intake`."
---

# write-idea

## Purpose

You file a new Idea in `draft` as the first step of the Idea flow; write-prd comes next.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

A description of the work: either freeform, or in the form `setting:new_idea_intake` asks for.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md` and the Ticket System Protocol File selected by `setting:ticket_system`, for operations.
- **Intake:** interview instructions or the Source Reference Resolver named by `setting:new_idea_intake`, for input requirements and Idea preparation.

## Gate

None: you create a new ticket.

## Steps

1. **Check the input.** Use `setting:new_idea_intake` when the input is in its form; otherwise take the freeform description as given.
   - If it doesn't say what the work is, stop and ask the Managing Intelligence.
2. **Prepare the Idea.**
   - If the intake names a Source Reference resolver, store the input under `## Source References` as the Idea's Source Reference, so write-prd can read the original context.

   Follow the intake's instructions for `## Description` in the Idea's body.
3. **File the Idea.** Create it in the Ideas store with status `draft`.

## Child Agents

None: you file the Idea yourself.

## Writes

- A new Idea in the Ideas store, status `draft`, with `## Description` holding the intake's account of the work and `## Source References` holding any original input links or paths.

## Done

Print the Idea's ID. Next step: "write-prd".
