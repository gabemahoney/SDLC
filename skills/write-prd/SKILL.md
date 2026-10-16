---
name: write-prd
description: "Write or revise an Idea's Product Requirements Document (PRD) from its context, an interview, and optional review findings or change notes."
---

# write-prd

## Purpose

Writes the PRD: the plain-English requirements for a development effort, clear enough for Agents to implement without inventing product decisions. It follows write-idea and supplies the product requirements for write-srd, req-review and planning.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

An Idea ID, with optional review findings or change notes for a revision.

## Reads

- **Workflow:** `~/.apiary/system/workflow.md`. Why: to follow the shared Run rules and the Succinctness pass.
- **Settings files:** `<Project Folder>/.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`. Why: to select the Ticket System Protocol File through `ticket_system`.
- **Your Agent's Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` in Claude Code, or `~/.apiary/system/protocols/agent-codex.md` in Codex CLI. Why: to interview the Managing Intelligence and report through this Agent.
- **The Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: to read the Idea and its Docs, and create or update its PRD.
- **Source reference instructions:** `~/.apiary/system/resolvers/<resolver>.md`, selected by each source reference's kind. Why: to read the Idea's source material as context.
- **The Idea and its existing Docs:** through the Ticket System Protocol File, using the input Idea ID. Why: to gather requirements, find the PRD to revise and determine whether an SRD exists.

## Gate

None: the PRD can be written or revised at any Idea status.

## Steps

1. **Gather the existing requirements.** Read the Idea, its source references and existing Docs. Gather what they and the conversation already say, together with any review findings or change notes.

2. **Interview the Managing Intelligence until you share an understanding.** Cover the problem, acceptance criteria, what is out of scope, edge cases and errors, UI/UX considerations, performance or security constraints, how it will be deployed and run (where it runs, who operates it, what it runs on), and dependencies on or effects on other work.
   - Treat the decisions this Idea needs as a tree: each one branches into the decisions that depend on it. Follow only branches that change what the product must do; don't invent new edge cases to explore.
   - Ask in rounds. Each round asks every question whose prerequisites are already settled. Number each question, give your recommended answer, and word it so "yes" accepts that answer. Hold a question that depends on one still open in this round for a later round.
   - Look up facts yourself instead of asking: the code, the Idea, its Docs and source references. Ask only for decisions. Keep asking the other questions while a lookup runs.
   - Stop when every branch is either answered or one the Managing Intelligence chooses to leave open, nothing is silently assumed, and they confirm you share an understanding. Questions they leave open become Open Questions.

3. **Write the PRD.** Draft it yourself from the gathered context and interview answers, using the section template and craft guidance below. Decisions the Managing Intelligence leaves unresolved may remain as Open Questions; flag them in the report.
   - If revising, first apply the findings or change notes to establish the current requirements.

4. **Review it yourself.** Make four passes over the whole draft (succinctness, product not software, dropped ideas, quality checklist), for a first draft and a revision alike. Repeat them until a pass changes nothing:
   - **Succinctness:** run the Succinctness pass in `workflow.md`: cut repetition and padding with no loss of signal.
   - **Product, not software:** rewrite any requirement that describes how the software works (code, components, data structures, APIs) as what the product must do for the people who use it. Software requirements belong in the SRD.
   - **Dropped ideas:** remove every trace of ideas discussed and dropped. If the interview considered something and decided against it, the PRD doesn't mention it at all. No "must not do X" or "X is out of scope" just because X came up. Keep a Non-Goal only when the Managing Intelligence wants that boundary stated.
   - **Quality checklist:** check every item in the Quality checklist below, and fix what fails.

5. **Save the PRD.** Follow the Ticket System Protocol File.
   - If the Idea has a PRD, update that Doc; a revised `defined` PRD returns to `draft`, and a `draft` PRD stays `draft`.
   - Otherwise, create a Doc child of the Idea titled `PRD`, with status `draft`.

## Dispatches

None: write-prd interviews and writes the PRD itself.

## Writes

The Idea's Doc titled `PRD` in the Ideas store: created `draft`, or updated in place, with a revised `defined` PRD set back to `draft`.

## Done

Report the PRD's ID, one line describing each section, its assumptions, its Open Questions and any incomplete work. Report what the Succinctness pass cut.

- If the Idea has no SRD, suggest “write-srd”.
- Otherwise, suggest “req-review, or, on a `draft` Idea, mark the Idea defined”.

## PRD section template

```markdown
# [Feature/Project Name]

## Glossary
Define only novel terms the product coins or uses in its own sense, grouped
by topic, each in Title Case. Each definition is one to three short sentences:
what it is and what it is for. Use plain words, common developer terms or other
Glossary terms; each definition stands alone without pointing to the body.

## Goals
List one bullet per new feature or goal. Each states a concrete, measurable outcome that must be true when the work is complete, and makes sense without reading the body.

## Problem Statement
What problem exists today? Who has it? Why does it matter?
Keep this to two or three sentences.

## Non-Goals / Out of Scope (if any)
State what this work will not do, when the Managing Intelligence wants a boundary
stated so the scope doesn't creep. Remove this section when there are none.

## Requirements

### Functional Requirements
Each requirement is a statement of what the product must do, not how it must
do it. Each should be specific enough to test and validate.

### Edge Cases and Error Handling
Describe how the product behaves when things don't go as expected. For each edge case or error the input or interview names, state the scenario and the expected behaviour.

### Non-Functional Requirements (if applicable)
State the performance, security, scalability or compatibility constraints that apply. Include this section only when they are relevant.

## Acceptance Criteria
List the observable, testable checks that must pass for the work to be complete.
- [ ] Criterion

## Assumptions
State what is assumed to be true going into this work, including dependencies on
other systems, existing functionality or prior work.

## Open Questions (if any)
List the product decisions still unanswered, for the Managing Intelligence to
resolve. Remove this section when there are none.
```

## Style rules

- **Product requirements, not software requirements.** Write what the product must do for the people who use it: user-facing behaviour and outcomes. Software requirements belong in the SRD, written next. If you are writing about code, components or data structures, you are probably doing it wrong.
- **Plain English.** Use short sentences and clear bullet lists, with short paragraphs where detail is needed. Every sentence adds information.
- **Only what the input states.** Keep the PRD short. Include only requirements and guards against real harm grounded in the context and interview answers.
- **No false precision.** Every number in a PRD becomes a hard limit the SRD must meet exactly. Give a number only when the Managing Intelligence states one or confirms it is a real limit. Otherwise state the need in words and how it will be judged, such as "a typical report exports without the user noticing a wait". Never invent a target to make a requirement look testable; if the Managing Intelligence can't say how a need will be judged, make it an Open Question.
- **Requirements, not solutions.** State the user's problem and needed outcome; leave the design open. Make every requirement specific and verifiable.
  Bad: “Add a red Retry button that calls the retry endpoint.” Good: “Customers can retry a failed payment. An order is charged at most once.”
- **Conversational wording.** Use direct statements without requirement numbers. Use user stories when actor, goal and benefit add clarity.
- **Consistent terms.** Write each Glossary term in Title Case wherever it appears, and briefly explain it or point to the Glossary at its first use. Never use a synonym for a defined term.
- **Current requirements.** State the requirements as they now stand. Fold answered Open Questions into the body.

## Quality checklist

Before saving, check the resolved requirements below. Record gaps the Managing Intelligence explicitly leaves unresolved as Open Questions and report the affected checks as incomplete.

- [ ] The Glossary and Goals stand alone, and terms are explained at first use.
- [ ] The problem statement names who has the problem and why it matters to them.
- [ ] Goals are concrete and measurable.
- [ ] Any Non-Goals are boundaries the Managing Intelligence asked for.
- [ ] Each requirement states one testable obligation, serves a stated need and has an acceptance check.
- [ ] Supplied priorities and trade-offs are explicit.
- [ ] Supplied edge cases and error scenarios have expected behaviours.
- [ ] Acceptance criteria specify observable outcomes, and the conditions and measures that matter.
- [ ] Assumptions and dependencies are explicit.
- [ ] Every requirement is user-facing product behaviour; nothing describes code, components or data structures.
- [ ] Nothing mentions an idea that was discussed and dropped, except a Non-Goal the Managing Intelligence asked to keep.
- [ ] Sections agree with each other.
- [ ] An Agent can implement the resolved requirements without inventing product decisions; unresolved decisions are Open Questions.

## What not to include

- Source code, pseudocode or technical implementation details.
- Architecture decisions, design proposals or instructions for how to build it.
- Defaults, fallbacks, validation, schemas, edge-case rules or guards the input did not request.
- Invented numbers or targets the Managing Intelligence did not give.
- Time estimates or scheduling.
- Specific file paths, function names or line numbers.
- Rejected alternatives, reversed decisions, history or a decision log.
- Optional mentions, deferred features, later revisions or follow-up work.
