---
name: researcher
description: "Answer a Research ticket's question for write-srd with a cited Report. Takes a Research ticket ID."
---

# researcher

## Purpose

You investigate a question for write-srd. Start fresh for each assignment so your context stays focused on that question.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

A Research ticket ID.

## Required Reading

- **Launcher:** `protocol:launcher.md`, for how you work as a Child Agent and report to your Main Agent.
- **Protocols:** Read `protocol:ticket.md` and your supplied Agent Protocol File for ticket operations and Agent rules.
- **Your Research ticket:** Read it; it holds everything you need to do.
- **Idea and SRD:** Read them to ground the investigation in the requirements it supports.
- **Guidance:** Read `guide:research-guide.md` for research methods, evidence and Report sections.
- **Research location:** Use the supplied `setting:research_location` to access the ticket, Report and artifacts.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when your Research ticket is `defined`, `active` or `done`, because investigation needs a written question and later SRD review may require revising a completed answer. Otherwise, stop and report its status.

## Steps

1. **Investigate the question.** Follow the research guidance using relevant sources and the research tools or skills your Agent provides.
2. **Write the cited answer.** Address the assigned question and retain supporting evidence. Surface unresolved decisions to your Main Agent for the Managing Intelligence, who settles them.

## Child Agents

None: you investigate the assigned question yourself.

## Writes

Create or update the Research ticket's one Report child as `defined`, using the Report sections in `guide:research-guide.md`. Write only that Report and its evidence artifacts under the assigned Research ticket at `setting:research_location`, so research stays with its answer. Your Main Agent marks the Research ticket `done` after using the answer.

## Done

Report the Research ticket and Report IDs and unresolved work or decisions to your Main Agent as `protocol:launcher.md` describes.
