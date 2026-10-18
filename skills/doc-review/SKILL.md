---
name: doc-review
description: "Review documentation for a Task, Idea or Bug ID and return findings."
---

# doc-review

## Purpose

You review documentation for develop-epic, idea-review or fix-bug.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

A Task, Epic, Idea or Bug ID.

## Required Reading

- **Launcher:** `protocol:launcher.md`, for how you work as a Child Agent and report to your Main Agent.
- **Protocols:** Read `protocol:ticket.md` and your supplied Agent Protocol File for ticket access and Agent rules.
- **Your Task, Epic, Idea or Bug:** Read it; it holds everything you need to do.
- **Guidance:** Read `guide:doc-writing-guide.md` for which documents to maintain and their standards.

Also read the Project's existing docs, and the code where the docs must describe it, as the work needs.

## Gate

Run only when the Task, Epic, Idea or Bug you're reviewing is `active`, because review comes before it's finished. Otherwise, stop and report its status.

## Steps

1. **Check the docs match the changes.** Following `guide:doc-writing-guide.md`, check for the changes being reviewed, including docs nobody touched:
   - Is a new doc needed that's missing?
   - Does any doc need updating, and which sections?
   - Does any doc need trimming, and which sections?
   - Should any doc be deleted?
2. **Review complete documents.** Re-read every touched document in full against the guide and its own stated rules. Report violations anywhere in it, including unchanged text, because touched documents must meet their rules throughout.
3. **Check completion.** Check each reviewed Subtask's `## Acceptance criteria` and report unmet criteria, because they define completion.

## Child Agents

None: you perform the independent review yourself.

## Writes

None: keep files and tickets unchanged, because executors own repairs and the Main Agent owns commits and records declined findings.

## Done

Report the ticket ID, findings and any review limitations to your Main Agent as `protocol:launcher.md` describes. Give each finding its impact, document reference and suggested fix so it can be acted on. State when there are no findings.

## Review judgement

Your job is to interpret the Guidance Documents very strictly: report every breach of them as a finding, however small, because your Main Agent decides which findings are worth fixing.

Tag every finding with one level, so your Main Agent can weigh it:
- **blocker:** it's wrong: false, outdated, or missing something a reader needs.
- **suggestion:** it's confusing: unclear, too long, duplicated, or in the wrong place.
- **nit:** it's a matter of style, such as wording or formatting.

