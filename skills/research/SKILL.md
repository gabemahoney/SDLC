---
name: research
description: "Research a question and write the answer, with sources, in a Report, through review rounds with the Managing Intelligence. Takes a question, or an existing Research ticket ID."
---

# research

## Purpose

You research a question and write the answer, with sources, in a Report. The question lives on a Research ticket, and the Report is a child ticket of that Research ticket. You revise the Report in review rounds until the Managing Intelligence accepts it, recording the evidence and each round on the Research ticket.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

A research question, or an existing Research ticket ID.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md` and the Ticket System Protocol File selected by `setting:ticket_system`, for operations.
- **The Research ticket, and its Report if one exists:** for the question, constraints, findings and latest review decision.
- **Guidance:** `guide:research-guide.md`, for research methods, evidence and Report requirements.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when all of these are true:

- For a question: it's clear enough to research. Otherwise, ask the Managing Intelligence to sharpen it, because the question determines what to investigate.
- For a Research ticket: it states its question and is `defined`, `active` or `done`. Otherwise, stop for the Managing Intelligence to finish defining it, so research starts from a written question.

## Steps

1. **Start or resume.** Given a question, file it first as a `defined` Research ticket at `setting:research_location`, with `## Question` and `## Scope`, so the question and its answer stay together. Set the Research ticket and its Report `active` when research starts, creating the Report if needed. Continue an existing round from its recorded progress or verdict so work isn't repeated.
   - A round awaiting review goes to step 3.
   - A `done` ticket goes to step 4 unless the Managing Intelligence requests more research. Record that request and set both tickets `active`, because the revised answer needs acceptance too.

2. **Research the round.** Investigate the question or latest review request under `guide:research-guide.md`. Update the same Report so readers have one current answer with cited evidence. Check it against the guide and record the round before presenting it.

3. **Review with the Managing Intelligence.** Present the Research ticket and Report IDs. Record the reviewer's identity and verdict under `## Review rounds`, keeping requests verbatim so later work follows the actual request.
   - More work: repeat step 2 with that request.
   - Acceptance: set the Report and Research ticket `done`.

4. **Complete extra outputs.** For each accepted round, record the outputs `guide:research-guide.md` requires under `## Extra outputs` before producing them, so an interrupted Run can continue. Keep their locations, completion and unfinished work there. Leave both tickets `done`, because Report acceptance stands.

## Child Agents

None: you investigate the question and bring each round to the Managing Intelligence.

## Writes

- **The Research ticket:** create it when given a question, then update its record below, including question or scope changes from the Managing Intelligence. Its status follows steps 1 and 3.
- **Its Report:** maintain one child titled `Report: <Research ticket title>`, using the sections in `guide:research-guide.md`. Its status follows steps 1 and 3.
- **Artifacts:** store them with the Research ticket and link them under `## Artifacts` through the Ticket System Protocol File, so the evidence stays with the answer. Remove secrets and tokens because the research record may be shared.
- **Extra outputs:** create or update them after acceptance as step 4 describes.

Keep Research tickets, Reports and artifacts at `setting:research_location`. Retain accepted research with automatic archival disabled, so its citations remain usable.

## Done

Report the Research ticket ID, the Report's ID once it exists, and any required extra outputs left unfinished with the reason.

If the round awaits review, say so; the Managing Intelligence's verdict continues it.

## Research ticket record

- `## Question`: state the question in the requester's words where possible.
- `## Scope`: record who asked, why, and the supplied constraints and boundaries. State when none were given.
- `## Review rounds`: give each round a number and date. Its Presented summary briefly describes the findings or changes. Record the reviewer's identity and verdict when received; a round without a verdict awaits review.
- `## Extra outputs`: track each accepted round's required outputs, locations, completion and any unfinished work with reasons.
