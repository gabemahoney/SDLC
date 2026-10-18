---
name: research
description: "Research a question and write the answer, with sources, in a Report, through review rounds with the Managing Intelligence. Takes a question, or an existing Research ticket ID."
---

# research

## Purpose

You research a question and write the answer, with sources, in a Report. The question lives on a Research ticket, and the Report is a child ticket of that Research ticket. You work in rounds. A round is one pass of researching and updating the Report, then presenting it to the Managing Intelligence, who either accepts it or asks for more. You repeat rounds until it's accepted, recording each one on the Research ticket.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

One of these three:

- **A new question.** You file a Research ticket for it and start round 1.
- **A Research ticket with no research yet.** You start round 1.
- **A Research ticket with earlier rounds.** You continue from where the last round left off.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md` and the Ticket System Protocol File selected by `setting:ticket_system`, for operations.
- **The Research ticket and its Report, if they exist:** the ticket for the question, scope and latest review decision; the Report for the current findings.
- **Guidance:** `guide:research-guide.md`, for research methods, evidence and Report requirements.
- **Existing research:** relevant earlier Research tickets and Reports at `setting:research_location`, and anything relevant that `guide:research-guide.md` names, so you build on what's already known instead of repeating it.

## Gate

Run only when all of these are true:

- The question, whether given to you or on the Research ticket, is clear enough to research. Otherwise, ask the Managing Intelligence to sharpen it, because the question determines what to investigate.
- Given a Research ticket ID: the ticket is `defined`, `active` or `done`. Otherwise, stop for the Managing Intelligence to finish defining it, so research starts from a written question.

## Steps

1. **Start.** Depending on your input:
   - A new question: file it as a `defined` Research ticket at `setting:research_location`, in the format under "Research ticket record" below. Then treat it as a ticket with no research yet.
   - A round presented to the Managing Intelligence but not yet answered: go to step 3.
   - An accepted (`done`) ticket: go to step 4, unless the Managing Intelligence asks for more research. Then record that request on the last round and continue with the next bullet, because the revised answer needs acceptance too.
   - Otherwise: set the Research ticket and its Report `active`, creating the Report if needed, and go to step 2.

2. **Research.** Research the question, or the Managing Intelligence's latest request, following `guide:research-guide.md`. Write the answer into the Research ticket's one Report, revising it each round rather than starting a new one, so there is always one current answer. Check it against the guide, then record the round under `## Review rounds`.

3. **Review with the Managing Intelligence.** Present the Research ticket and Report IDs. Record who reviewed it and their answer (accept, or what more to do) under `## Review rounds`, keeping requests verbatim so later work follows the actual request.
   - More work: repeat step 2 with that request.
   - Acceptance: set the Report and Research ticket `done`.

4. **After acceptance.** Do whatever `guide:research-guide.md` requires after a Report is accepted.

## Child Agents

None: you investigate the question and bring each round to the Managing Intelligence.

## Writes

- **The Research ticket:** create it when given a question, then update its record below, including question or scope changes from the Managing Intelligence.
- **Its Report:** maintain one child titled `Report: <Research ticket title>`, using the sections in `guide:research-guide.md`.

## Done

Report the Research ticket ID, the Report's ID once it exists, and any after-acceptance work left unfinished with the reason.

If the round is waiting on the Managing Intelligence, say so; their answer continues it.

## Research ticket record

- `## Question`: state the question in the requester's words where possible.
- `## Scope`: record who asked, why, and the supplied constraints and boundaries. State when none were given.
- `## Review rounds`: for each round, its number and date, a short summary of what was presented, and, once received, the reviewer and their answer, with any requests verbatim. A round with no answer is waiting for review.
