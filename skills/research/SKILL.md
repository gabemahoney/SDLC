---
name: research
description: "File or continue a Research ticket, investigate its question, and complete its cited Report through review rounds with the Managing Intelligence."
---

# research

## Purpose

Keeps a research question, its evidence and review rounds together until the Managing Intelligence accepts the Report.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

A Research ticket ID to continue, or a question to file as a new Research ticket.

## Required Reading

- **Workflow:** `~/.apiary/system/workflow.md`. Why: to follow the shared Run rules.
- **Settings files:** `<Project Folder>/.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`. Why: to select the Ticket System Protocol File through `ticket_system`.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` in Claude Code, or `~/.apiary/system/protocols/agent-codex.md` in Codex CLI. Why: to present rounds, receive decisions and use research skills provided by the Agent.
- **The Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: to read and write the Research ticket, its Report and review log, and store and link research artifacts.
- **Research ticket, Report and evidence:** through the Ticket System Protocol File, using the input ID when continuing. Why: to understand the question, constraints, findings and latest review decision, and resume the right round.
- **Resolver:** `~/.apiary/system/resolvers/<resolver>.md`, selected by each Source Reference's kind. Why: to read source material supplied with the question.

## Gate

None: research files a new Research ticket or continues one at any status.

## Steps

1. **File or continue the question.**
   - If given a new question, create a Research ticket as `defined`, using the Research ticket template below. If asked only to file it, report its ID and finish.
   - If the ticket is `defined`, set it `active` and create its Report as `active` when starting the first round.
   - If the ticket is `active`, use its review log to continue unfinished research or requested further work in step 2. For a round awaiting review or already accepted, go to step 3.
   - If the ticket is `done`, report its completion and Report ID and finish unless the Managing Intelligence requests more work. For that request, record it and set the ticket and Report `active` for a new round.

2. **Research the round.** Investigate the question on the first round and the Managing Intelligence's latest request on later rounds. Save the evidence and update the same Report to reflect all findings so far. Check it against the Report guidance below, then append a dated round with a short Presented summary to the Research ticket.

3. **Review with the Managing Intelligence.** If a verdict is still needed, present the ticket ID, round summary, Report ID and links to the Report and artifacts, then wait for the Managing Intelligence's decision. Record and apply the verdict, including one already supplied. Record who reviewed the round, keeping any request for more work verbatim.
   - If they request more work, return to step 2 with that request.
   - If they accept the Report, set the Report and Research ticket `done`.

## Dispatches

None: research does the investigation and brings each round to the Managing Intelligence.

## Writes

- Create the Research ticket in the Research store as `defined` with its question and constraints, then set it `active` when research starts. Its review log records each round and the Managing Intelligence's decisions.
- Create its one Report child, titled `Report: <Research ticket title>`, as `active` in the first round and update it throughout the investigation.
- Both tickets become `done` only when the Managing Intelligence accepts the Report. Both return to `active` when the Managing Intelligence requests more work after acceptance.
- Store research artifacts with the Research ticket through the Ticket System Protocol File. Keep accepted tickets, Reports and artifacts available as the research record.

## Done

Report the Research ticket ID and status, the Report ID when it exists, and the one-line answer or work still awaiting review. For an unfinished round, name the remaining work or decision needed from the Managing Intelligence.

## Research ticket template

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
