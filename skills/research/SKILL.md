---
name: research
description: "Investigate a Research ticket's question and complete its cited Report through review rounds with the Managing Intelligence."
---

# research

## Purpose

Keeps a research question, its evidence and review rounds together until the Managing Intelligence accepts the Report.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

A Research ticket ID.

## Required Reading

- **Workflow:** `~/.apiary/system/workflow.md`. Why: to follow the shared Run rules.
- **Settings files:** `<Project Folder>/.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`. Why: to select the Ticket System Protocol File through `ticket_system`.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` in Claude Code, or `~/.apiary/system/protocols/agent-codex.md` in Codex CLI. Why: to present rounds, receive decisions and use research skills provided by the Agent.
- **The Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: to read and write the Research ticket, its Report and review log, and store and link research artifacts.
- **Research ticket and its existing Report:** through the Ticket System Protocol File, using the input ID. Why: to understand the question, constraints, findings and latest review decision, and resume the right round.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when all of these are true:

- The Research ticket states its question. If it doesn't, stop for the Managing Intelligence to supply it, because the question determines what to investigate.
- The Research ticket is `defined`, `active` or `done`. Otherwise, stop for the Managing Intelligence to finish defining it, so research starts from a written question.

## Steps

1. **Start or resume the research.**
   - For a `defined` or `active` ticket, go to step 3 if the latest round awaits review or has an acceptance to apply. Otherwise, set the ticket and Report `active`, creating the Report if needed, and continue research in step 2. This lets an interrupted Run continue with the same Report.
   - For a `done` ticket, finish unless the Managing Intelligence has requested further work since acceptance. Record that request and set both the ticket and Report `active` for a new round, because the revised answer needs review too.

2. **Research the round.** Investigate the question on the first round and the Managing Intelligence's latest request on later rounds. Save the evidence and update the same Report to reflect all findings so far, so later readers have one current answer. Check it against the Report guidance below, then append a dated round with a short Presented summary to the Research ticket.

3. **Review with the Managing Intelligence.** Refer them to the Research ticket and Report IDs for any round awaiting a verdict. They decide whether to accept the Report or request more work. Record who reviewed the round and their verdict, keeping requests for more work verbatim so later rounds follow the actual request. Apply a verdict already recorded for this round when resuming.
   - If they request more work, return to step 2 with that request.
   - If they accept the Report, set the Report and Research ticket `done`.

## Dispatches

None: research does the investigation and brings each round to the Managing Intelligence.

## Writes

- **The Research ticket:** update its question and scope when the Managing Intelligence revises them, and its review log after each round and verdict. Its status follows steps 1 and 3.
- **Its Report:** create the Report child, titled `Report: <Research ticket title>`, when research starts, and update it after each round. Its status follows steps 1 and 3, including revisions to an accepted Report.
- **Artifacts:** store and link them with the Research ticket through the Ticket System Protocol File, so the evidence stays with the answer.

Retain accepted Research tickets, Reports and artifacts in the Research store, with automatic archival disabled, so their citations remain usable.

## Done

Report the Research ticket ID and any findings or feedback left unaddressed, with the reason.

## Research ticket record

- **Question:** state the question in the requester's words where possible.
- **Scope:** record who asked, why, and the supplied constraints and boundaries. State when none were given.
- **Review rounds:** give each round a number and date. Its Presented summary briefly describes the findings or changes. Record the reviewer's identity and verdict when received; a round without a verdict awaits review.

## Research methods and artifacts

Choose methods that suit the question and review request. Use any research skill your Agent provides, as its Agent Protocol File describes. A small runnable prototype can answer a design question; keep it with the research artifacts and record what it demonstrated.

Keep bulky data, scripts, logs, screenshots, notes and excerpts in artifacts, with secrets and tokens removed, because the research record may be shared. Link evidence from the findings it supports.

## Report guidance

Write a standalone document that a reader can use without the ticket or conversation:

1. **Summary:** answer the question first, in a few lines.
2. **Findings:** organize findings by theme or sub-question and give their evidence.
3. **Limitations:** state what was not checked, uncertainty and open questions.
4. **Conclusions and recommendations:** include these when the question calls for them.
5. **References:** give a numbered list, with an inline `[n]` citation for every claim beyond common knowledge. Identify sources precisely: a URL and access date, a file path and line or commit SHA, a ticket ID, a message permalink, or a document title and section.
6. **Artifacts:** link each artifact through the Ticket System Protocol File and explain in one line what it holds.
