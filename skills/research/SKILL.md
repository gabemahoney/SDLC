---
name: research
description: "Research a question and write the answer, with sources, in a Report, through review rounds with whoever asked. Takes a question, or an existing Research ticket ID."
---

# research

## Purpose

You research a question and write the answer, with sources, in a Report. The question lives on a Research ticket, and the Report is a child ticket of that Research ticket. Your reviewer is whoever asked: the Managing Intelligence, or the Main Agent that launched you as a Child Agent.

You work in rounds. A round is one pass of researching and updating the Report, then presenting it to your reviewer, who either accepts it or asks for more. You repeat rounds until it's accepted.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

One of these:

- **A new question.** You file a Research ticket for it.
- **A Research ticket ID**, with anything more your reviewer wants researched.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Launcher:** `protocol:launcher.md` if you were launched as a Child Agent, for how to report to your Main Agent.
- **Protocols:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md` and the Ticket System Protocol File selected by `setting:ticket_system`, for operations.
- **The Research ticket and its Report, if they exist:** the ticket for the question and scope; the Report for the current answer.
- **Guidance:** `guide:research-guide.md`, for research methods, evidence and Report requirements.
- **Existing research:** relevant earlier Research tickets and Reports at `setting:research_location`, and anything relevant that `guide:research-guide.md` names, so you build on what's already known instead of repeating it.

## Gate

Run only when all of these are true:

- The question, whether given to you or on the Research ticket, is clear enough to research. Otherwise, ask your reviewer to sharpen it, because the question determines what to investigate.
- Given a Research ticket ID: the ticket is `defined`, `active` or `done`. Otherwise, stop for your reviewer to finish defining it, so research starts from a written question.

## Steps

1. **Set up.** For a new question, file a Research ticket at `setting:research_location`, in the format under "Research ticket record" below. Create its Report if it has none. Set both `active`.

2. **Research.** Research the question, or your reviewer's latest request, following `guide:research-guide.md`. Update the Report with the answer, so there is always one current answer.

3. **Review.** Present the Report to your reviewer.
   - If they ask for more, go back to step 2.
   - If they accept it, set both tickets `done`, then do whatever `guide:research-guide.md` requires after acceptance.

## Child Agents

None: you investigate the question yourself.

## Writes

- **The Research ticket:** its `## Question` and `## Scope`, including changes from your reviewer.
- **Its Report:** maintain one child titled `Report: <Research ticket title>`, using the sections in `guide:research-guide.md`.

## Done

Report the Research ticket ID, the Report's ID, and any after-acceptance work left unfinished with the reason.

If the round is waiting on your reviewer, say so; their answer continues it.

## Research ticket record

- `## Question`: state the question in the requester's words where possible.
- `## Scope`: record who asked, why, and the supplied constraints and boundaries. State when none were given.
