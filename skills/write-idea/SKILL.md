---
name: write-idea
description: "File or revise an Idea or Tweak from what the Managing Intelligence gives you: plain text describing the work, or input for the Project's `setting:new_idea_intake`."
---

# write-idea

## Purpose

You file an Idea as the first step of the Idea flow, and revise it. When `~/.sdlc/install/workflow.md`'s Flows rule makes the request a Tweak, file it the same way, marked as `protocol:ticket.md` says, with Tweak body in place of Idea body; for a Bug, suggest write-bug.

## Loading SDLC

Read `~/.sdlc/install/workflow.md` first for shared rules, settings and file locations.

## Input

Plain text describing the work, or input of the kind `setting:new_idea_intake` takes, such as a link. To revise, also the Idea's or Tweak's ID.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** your Agent Protocol File (`protocol:agent-claude-code.md`, `protocol:agent-codex.md` or `protocol:agent-cursor.md`) and the Ticket System Protocol File selected by `setting:ticket_system`, for operations.
- **Intake:** the instructions `setting:new_idea_intake` names, for what input it takes and how to prepare the Idea.
- **Research guide:** `guide:research-guide.md`, for where the Project's research lives.

## Gate

None: you create or revise an Idea or Tweak.

## Steps

1. **Take in and classify the work.** Follow the intake's instructions for input it takes; otherwise, work out the Idea or change with the Managing Intelligence.
2. **File or revise the Idea or Tweak** as Writes describes.
3. **Check it** against Idea body or Tweak body, so drift is fixed before approval.

## Child Agents

None: you file the Idea yourself.

## Writes

A new `draft` Idea in the Ideas store, with `## Description` saying what the work is. Keep the link or path the input came from as a Source Reference, through `protocol:ticket.md`, so write-prd can read the original, unless it carries a proposal.

Set or replace a Tweak's `thinking_level:<label>` tag, through `protocol:ticket.md`, because it sets how hard build-tweak's `engineer` thinks. Use `medium`, `high` or `xhigh`, because one engineer writes the change, its tests and docs, and a change that needs `max` is an Idea, not a Tweak. Match it to how hard the change is and what a mistake in it would cost:
- `medium`: routine changes in one place that follow an established pattern, including trivial ones such as wording or a config value.
- `high`: changes that need care or change behavior other code relies on.
- `xhigh`: changes where a mistake is costly or hard to spot, such as security or stored data.

When unsure between two levels, choose the higher one.

Revise in place, so the body shows only the current direction, and link its history under `## Artifacts`, so it survives. A revision keeps sections other skills own, such as `## Review rounds`, `## Declined findings` and `## Retrospective notes`. To refile a Tweak as an Idea, remove its mark and Thinking Level tag and rewrite its body.

## Retrospective notes

While you work, note under `## Retrospective notes` on your ticket, with evidence, your answers to these questions, because the Managing Intelligence builds the Idea's or Bug's retrospective from them:

- Where did we introduce a quality issue? How could it have been avoided?
- Where did we spend too much time and not gain value? How could it have been avoided?
- Where did we spend too many tokens and not gain value? How could it have been avoided?

## Done

Report the Idea's or Tweak's ID and any proposal, with its source. Suggest the Managing Intelligence approve it, then write-prd, or for a Tweak, worktree setup and build-tweak.

## Idea body

An Idea holds the direction the User and the Managing Intelligence agreed, at product level, without the decisions or rejected options behind it, so it can be approved and built on:

- What the work is and why, and what the User requires, specific enough that write-prd isn't guessing what was meant.
- Associations, each saying why it is linked, so the link can be defended.
- Under `## Artifacts`, completed Research Reports, research the Project keeps elsewhere (`guide:research-guide.md`), reviews and other input, each linked with a line on what it covers, so later skills start from that evidence.

Leave out:

- Anything write-prd or write-srd settles, because they own it.
- Restated engineering principles, because the Guidance Documents carry them.
- Status notes, chat links and timestamps, because they go stale.

Merge sections covering one concept, so it has one account.

## Tweak body

`## Description`: a few sentences on what the user will see change and how we'll know it's done, so the User can approve it in one read.
