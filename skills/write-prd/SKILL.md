---
name: write-prd
description: "Write or revise an Idea's PRD from its ID, an interview, and optional review findings or change notes."
---

# write-prd

## Purpose

Writes an Idea's Product Requirements Document (PRD): what to build and why, stated as testable requirements. It follows write-idea and leads to write-srd or req-review.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

An Idea ID, then optional review findings or change notes.

## Reads

- **Workflow:** `~/.apiary/system/workflow.md`. Why: follow the shared rules for this Run.
- **Settings:** `<Project Folder>/.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`: `ticket_system`, the running Agent's `levels_claude_code` or `levels_codex`, and `thinking_levels`. Why: select the Ticket System Protocol File and check the Agent's Thinking Level mapping and the `write-prd` line.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` in Claude Code or `~/.apiary/system/protocols/agent-codex.md` in Codex CLI. Why: follow the Agent's instructions for questions and reporting.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, where `<ticket_system>` is the setting's value. Why: read the Idea and its Docs and save its PRD.
- **Idea and Docs:** the input Idea and its Doc children in the Ideas store, through the Ticket System Protocol File. Why: gather the Idea's stated requirements, find its existing PRD and determine whether it has an SRD.
- **Source references:** the paths or URLs stored on the Idea, resolved through `~/.apiary/system/resolvers/<resolver>.md`, selected by the source reference's kind as described in workflow.md. Why: follow the resolver and gather the original context for the requested work.
- **Conversation and revision input:** the conversation, interview answers and supplied review findings or change notes. Why: gather stated requirements and identify unanswered questions.

## Gate

None: write-prd writes or revises an Idea's PRD.

## Steps

1. **Gather what is already stated.** Read the conversation, the Idea's body, its Docs and its source references.

2. **Complete the interview.**
   - If any interview topics remain unanswered, then stop and ask the Managing Intelligence: supply the missing answers about the problem, acceptance criteria, what is out of scope, edge cases and errors, user-facing behaviour, performance or security constraints, and dependencies on other work.
   - If the available input covers these topics, then proceed to writing.

   Record anything the answers leave open as an Open Question.

3. **Write the PRD from those answers.** Treat the gathered input and interview answers as the authority for requirements. Include defaults, fallbacks, validation, edge-case rules and guards only where the input requests them. State what the product must do and why as testable behaviour and constraints.

   a. **Define novel terms first.** After the title, put Glossary first, grouped by topic. Define only terms the product coins or uses in its own sense. Each entry is a complete definition in one to three short sentences: what it is and, where applicable, where it lives, who writes or edits it and what it is for. Make definitions self-contained, using plain words, common developer terms or other Glossary terms.

   b. **Present the requirements in order.** Follow Glossary with At a glance: one bullet per new feature or goal, readable on its own. Then write Problem Statement, Goals, Non-Goals, Requirements, Acceptance Criteria, Assumptions and any Open Questions. Requirements covers functional requirements, edge cases, and non-functional requirements where applicable. Use clear bullet lists of short plain sentences, with short paragraphs where detail is needed.

   c. **Use one word per concept.** Briefly explain each term, or point to the Glossary, at its first use in the body. Use each Glossary term verbatim everywhere, in Title Case, including plurals, except names in backticks. Reserve its lowercase form for ordinary meanings, and define it using words other than its own lowercase form. Quote or backtick product feature names that share a term's word.

   d. **Keep only the current requirements.** Include only requirements and guards against real harm for what this Idea builds. Fold answered Open Questions into the body; keep Open Questions for unanswered questions. Keep the document short.

4. **Tighten each revision.**

   - If revising an existing PRD, then act on the supplied findings or change notes and run the Succinctness pass in workflow.md.

5. **Save the Idea's PRD.** Follow the Ticket System Protocol File.

   - If the Idea has a PRD, then update that Doc; revising a `defined` PRD sets it back to `draft`.
   - If the Idea has no PRD, then create a child Doc titled `PRD`, status `draft`.

## Dispatches

None: write-prd conducts the interview and writes the PRD itself.

## Writes

The Idea's PRD Doc in the Ideas store, titled `PRD`: creates it in `draft`, or updates the existing Doc. Revising a `defined` PRD sets it back to `draft`.

## Done

Report the PRD's ID, one line per section, its assumptions and its Open Questions. For a revision, report what the Succinctness pass cut.

- If the Idea has no SRD, then suggest “write-srd”.
- If the Idea has an SRD, then suggest “req-review, or, on a `draft` Idea, mark the Idea defined”.
