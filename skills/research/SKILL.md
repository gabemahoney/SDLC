---
name: research
description: "Research a question and write the answer, with sources, in a Report, through review rounds with the Managing Intelligence. Takes a question, or an existing Research ticket ID."
---

# research

## Purpose

You research a question and write the answer, with sources, in a Report. The question lives on a Research ticket, and the Report is a child ticket of that Research ticket. You revise the Report in review rounds until the Managing Intelligence accepts it, recording each round on the Research ticket.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

A research question, or an existing Research ticket ID.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md` and the Ticket System Protocol File selected by `setting:ticket_system`, for operations.
- **The Research ticket, and its Report if one exists:** the ticket for the question, scope and latest review decision; the Report for the current findings.
- **Guidance:** `guide:research-guide.md`, for research methods, evidence and Report requirements.
- **Existing research:** relevant earlier Research tickets and Reports at `setting:research_location`, and anything relevant that `guide:research-guide.md` names, so you build on what's already known instead of repeating it.

Also read the Project's code and tests as the work needs.

## Gate

Run only when all of these are true:

- The question, whether given to you or on the Research ticket, is clear enough to research. Otherwise, ask the Managing Intelligence to sharpen it, because the question determines what to investigate.
- Given a Research ticket ID: the ticket is `defined`, `active` or `done`. Otherwise, stop for the Managing Intelligence to finish defining it, so research starts from a written question.

## Steps

1. **Start or resume.** Given a question, file it as a `defined` Research ticket at `setting:research_location`, in the format under "Research ticket record" below. Then pick up where the ticket stands, so work isn't repeated:
   - A round awaiting review goes to step 3.
   - A `done` ticket goes to step 4, unless the Managing Intelligence asks for more research. Then record that request as a new round and continue below, because the revised answer needs acceptance too.
   - Otherwise, set the Research ticket and its Report `active`, creating the Report if needed, and go to step 2.

2. **Research the round.** Investigate the question or latest review request under `guide:research-guide.md`. Update the same Report so readers have one current answer with cited evidence. Check it against the guide and record the round before presenting it.

3. **Review with the Managing Intelligence.** Present the Research ticket and Report IDs. Record the reviewer's identity and verdict under `## Review rounds`, keeping requests verbatim so later work follows the actual request.
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

If the round awaits review, say so; the Managing Intelligence's verdict continues it.

## Research ticket record

- `## Question`: state the question in the requester's words where possible.
- `## Scope`: record who asked, why, and the supplied constraints and boundaries. State when none were given.
- `## Review rounds`: for each round, its number and date, a short summary of what was presented, and, once received, the reviewer, their verdict and their requests verbatim. A round without a verdict awaits review.
