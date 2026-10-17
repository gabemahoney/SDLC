---
name: research
description: "Investigate a Research ticket's question and complete its cited Report through review rounds with the Managing Intelligence."
---

# research

## Purpose

You keep a research question, its evidence and review rounds together until the Managing Intelligence accepts the Report.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

A Research ticket ID.

## Required Reading

- **Settings:** Project and default settings, resolved as `~/.apiary/system/workflow.md` describes, for this Run's configuration.
- **Agent Protocol File:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md` under `~/.apiary/system/protocols/`, for your own context readings and skill invocation.
- **Ticket System Protocol File:** selected by `setting:ticket_system` as `~/.apiary/system/workflow.md` describes, to read and write the Research ticket, its Report and review log, and store and link research artifacts.
- **Research guidance:** `guide:research-guide.md`, found as `~/.apiary/system/workflow.md` describes, to follow the Project's research methods, evidence requirements and Report guidance.
- **Research ticket and its existing Report:** at `setting:research_location` to understand the question, constraints, findings and latest review decision, and resume the right round.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when all of these are true:

- The Research ticket states its question. If it doesn't, stop for the Managing Intelligence to supply it, because the question determines what to investigate.
- The Research ticket is `defined`, `active` or `done`. Otherwise, stop for the Managing Intelligence to finish defining it, so research starts from a written question.

## Steps

1. **Start or resume the research.**
   - For a `defined` or `active` ticket, go to step 3 if the latest round awaits review or has an acceptance to apply. Otherwise, set the ticket and Report `active`, creating the Report if needed, and continue research in step 2. This lets an interrupted Run continue with the same Report.
   - For a `done` ticket, go to step 4 unless the Managing Intelligence has requested further work since acceptance. If they have, record that request and set both the ticket and Report `active` for a new round, because the revised answer needs review too.

2. **Research the round.** Follow `guide:research-guide.md` to investigate the question on the first round and the Managing Intelligence's latest request on later rounds. Update the same Report with the findings and their citations, so later readers have one current answer with traceable evidence. Check the Report against the guide, then append a dated round with a short Presented summary to the Research ticket.

3. **Review with the Managing Intelligence.** Refer them to the Research ticket and Report IDs for any round awaiting a verdict. They decide whether to accept the Report or request more work. Record who reviewed the round and their verdict, keeping requests for more work verbatim so later rounds follow the actual request. Apply a verdict already recorded for this round when resuming.
   - If they request more work, return to step 2 with that request.
   - If they accept the Report, set the Report and Research ticket `done`.

4. **Complete any extra outputs.** After the Report is accepted, produce any extra outputs `guide:research-guide.md` requires from it. Record their locations and completion on the Research ticket, so an interrupted Run can finish what remains without repeating completed work. Apply this step to each newly accepted revision too, so the extra outputs stay current.

## Child Agents

None: you investigate the question and bring each round to the Managing Intelligence.

## Writes

- **The Research ticket:** update its question and scope when the Managing Intelligence revises them, its review log after each round and verdict, and the completion record for any extra outputs. Its status follows steps 1 and 3.
- **Its Report:** create the Report child, titled `Report: <Research ticket title>`, when research starts, and update it after each round. Its status follows steps 1 and 3, including revisions to an accepted Report.
- **Artifacts:** store and link them with the Research ticket through the Ticket System Protocol File, so the evidence stays with the answer. Remove secrets and tokens because the research record may be shared.
- **Extra outputs:** create or update them where `guide:research-guide.md` requires, after Report acceptance in step 4.

Keep Research tickets, Reports and artifacts at `setting:research_location`. Retain accepted research with automatic archival disabled, so its citations remain usable.

## Done

Report the Research ticket ID, the Report's ID once it exists, and any required extra outputs left unfinished with the reason.

If the round awaits review, say so; the Managing Intelligence's verdict continues it.

## Research ticket record

- **Question:** state the question in the requester's words where possible.
- **Scope:** record who asked, why, and the supplied constraints and boundaries. State when none were given.
- **Review rounds:** give each round a number and date. Its Presented summary briefly describes the findings or changes. Record the reviewer's identity and verdict when received; a round without a verdict awaits review.
