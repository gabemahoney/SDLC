---
name: doc-review
description: "Review documentation for a Task, Idea or Bug ID and return findings."
---

# doc-review

## Purpose

You review documentation for develop-epic, idea-review or fix-bug.

## Loading SDLC

You are running an SDLC software development workflow. Before anything else, read `~/.sdlc/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.sdlc/system/workflow.md` before going on.

## Input

A Task, Epic, Idea or Bug ID.

## Required Reading

- **Launcher:** `protocol:launcher.md`, for how you work as a Child Agent and report to your Main Agent.
- **Protocols:** Read `protocol:ticket.md` and your supplied Agent Protocol File for ticket access and Agent rules.
- **Your Task, Epic, Idea or Bug:** Read it; it holds everything you need to do.
- **Guidance:** Read `guide:doc-writing-guide.md` for which documents to maintain and their standards.
- **All the Project's docs:** read every doc the doc-writing guide covers, so you can spot gaps, leftovers and duplicates anywhere.

Also read any other code where the docs must describe it, as the work needs.

## Gate

Run only when the Task, Epic, Idea or Bug you're reviewing is `active`, because review comes before it's finished. Otherwise, stop and report its status.

## Steps

1. **Read the code changes.** Read every code change made in this Task carefully, so you know exactly what changed.
2. **Read every document.** Read all of the Project's docs, in full, so nothing the change affects is missed.
3. **Check the docs against the changes.** Judge every passage against the document's intended audience, including unchanged material. Report unnecessary or misplaced content not covered by a `## Guide exceptions` entry even when a Subtask asks to retain it, and recommend cuts or consolidation to preserve required reader information. Following `guide:doc-writing-guide.md`, check:
   - Is a new doc needed that's missing?
   - Does any doc need updating, and which sections?
   - Does any doc need trimming, and which sections?
   - Should any doc be deleted?
4. **Check completion.** Check each reviewed Subtask's `## Acceptance criteria` and report unmet criteria, because they define completion.

## Child Agents

None: you perform the independent review yourself.

## Writes

None: keep files and tickets unchanged, because executors own repairs and the Main Agent owns commits and records declined findings.

## Done

Report the ticket ID, findings and any review limitations to your Main Agent as `protocol:launcher.md` describes. Give each finding its impact, document reference and suggested fix so it can be acted on. State when there are no findings.

## Review judgement

Report every Guidance Document breach, however small, except those an entry in `## Guide exceptions` covers on the ticket you're reviewing or its parents, so review respects the Managing Intelligence's approved exceptions.

Tag every finding with one level, so your Main Agent can weigh it:
- **blocker:** it's wrong: false, outdated, or missing something a reader needs.
- **suggestion:** it's confusing: unclear, too long, duplicated, or in the wrong place.
- **nit:** it's a matter of style, such as wording or formatting.

