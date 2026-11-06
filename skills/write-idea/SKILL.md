---
name: write-idea
description: "File or revise an Idea or Tweak from what the Managing Intelligence gives you: plain text describing the work, or input for the Project's `setting:new_idea_intake`."
---

# write-idea

## Purpose

You file an Idea or a Tweak as the first step of its flow, and revise it.

## Loading SDLC

Read `~/.sdlc/install/workflow.md` first for shared rules, settings and file locations.

## Input

Plain text describing the work, or input of the kind `setting:new_idea_intake` takes, such as a link. To revise, also the Idea's or Tweak's ID.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** your Agent Protocol File (`protocol:agent-claude-code.md`, `protocol:agent-codex.md` or `protocol:agent-cursor.md`) and the Ticket System Protocol File selected by `setting:ticket_system`, for operations.
- **Intake:** the instructions `setting:new_idea_intake` names, for what input it takes and how to prepare the Idea or Tweak.
- **Research guide:** `guide:research-guide.md`, for where the Project's research lives.

## Gate

None: you create or revise an Idea or Tweak.

## Steps

1. **Take in the work.** Follow the intake's instructions for input it takes; otherwise, work out the Idea or change with the Managing Intelligence.
2. **Classify the request** by `~/.sdlc/install/workflow.md`'s Flows rule, because a Tweak skips requirements and planning. File a Tweak or an Idea; for a Bug, change nothing and suggest write-bug.
3. **File or revise the ticket** as Writes describes.
4. **Check it** against Idea body or Tweak body, so drift is fixed before approval.

## Child Agents

None: you file the ticket yourself.

## Writes

A new `draft` Idea in the Ideas store, with `## Description` saying what the work is, or a new `draft` Tweak in the Ideas store, marked as a Tweak through `protocol:ticket.md`, as Tweak body describes. Keep the link or path the input came from as a Source Reference, through `protocol:ticket.md`, so write-prd or build-tweak can read the original.

Revise in place, so the body shows only the current direction, and link its history under `## Artifacts`, so it survives. A revision keeps sections other skills own, such as `## Review rounds`, `## Worktrees`, `## Declined findings` and `## Retrospective notes`.

When the Managing Intelligence has you refile a Tweak as an Idea, remove its Tweak mark through `protocol:ticket.md`, and rewrite its body as Idea body describes, keeping its other sections, so the same ticket carries its record into the Idea flow. Once the Managing Intelligence has settled its worktrees, remove its `## Worktrees` record, because the Idea's Plan will hold the new one.

## Retrospective notes

While you work, note under `## Retrospective notes` on your ticket, with evidence, your answers to these questions, because the Managing Intelligence builds the ticket's retrospective from them:

- Where did we introduce a quality issue? How could it have been avoided?
- Where did we spend too much time and not gain value? How could it have been avoided?
- Where did we spend too many tokens and not gain value? How could it have been avoided?

## Done

Report the ticket's ID and whether it's an Idea or a Tweak. Suggest the Managing Intelligence get it approved, then run write-prd for an Idea, or set up a Tweak's worktrees and run build-tweak.

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

A Tweak's `## Description` is short enough for the User to approve in one read, because that approval is its only gate. In a few sentences, it says what the user will see change and how we'll know it's done, as observable checks, because build-tweak builds and the Managing Intelligence accepts against it. Leave out design and implementation detail, because the engineer settles it under the Guidance Documents.
