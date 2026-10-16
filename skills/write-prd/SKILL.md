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

2. **Interview the Managing Intelligence.** Ask focused questions to fill the gaps in that context, and wait for the answers. Cover the problem, acceptance criteria, what is out of scope, edge cases and errors, UI/UX considerations, performance or security constraints, how it will be deployed and run (where it runs, who operates it, what it runs on), and dependencies on or effects on other work. Offer options rather than open-ended questions where you can.

3. **Write and check the PRD.** Draft it yourself from the gathered context and interview answers, using the section template and craft guidance below. Decisions the Managing Intelligence leaves unresolved may remain as Open Questions in the draft; flag them in the report.
   - If revising, first apply the findings or change notes to establish the current requirements, then run the Succinctness pass in `workflow.md` on that revised document.

   Apply the Quality Checklist before saving.

4. **Save the PRD.** Follow the Ticket System Protocol File.
   - If the Idea has a PRD, update that Doc; a revised `defined` PRD returns to `draft`, and a `draft` PRD stays `draft`.
   - Otherwise, create a Doc child of the Idea titled `PRD`, with status `draft`.

## Dispatches

None: write-prd interviews and writes the PRD itself.

## Writes

The Idea's Doc titled `PRD` in the Ideas store: created `draft`, or updated in place, with a revised `defined` PRD set back to `draft`.

## Done

Report the PRD's ID, one line describing each section, its assumptions, its Open Questions and any incomplete work. On a revision, report what the Succinctness pass cut.

- If the Idea has no SRD, suggest “write-srd”.
- Otherwise, suggest “req-review, or, on a `draft` Idea, mark the Idea defined”.

## PRD section template

```markdown
# [Feature/Project Name]

## Glossary
Define only novel terms the product coins or uses in its own sense, grouped
by topic. Each definition is one to three short sentences: what it is and,
where applicable, where it lives, who writes or edits it and what it is for.
Use plain words, common developer terms or other Glossary terms; each
definition stands alone without pointing to the body.

## Goals
One bullet per new feature or goal: a concrete, measurable outcome that must be true when the work is complete, understandable without reading the body.

## Problem Statement
What problem exists today? Who has it? Why does it matter?
Keep this to two or three sentences.

## Non-Goals / Out of Scope
Explicit boundaries that prevent scope creep during implementation.

## Requirements

### Functional Requirements
What the system must do. Each requirement is specific enough to test and
independent where possible.

### Edge Cases and Error Handling
The scenarios and expected behaviour supplied by the input and interview.

### Non-Functional Requirements (if applicable)
Relevant performance, security, scalability and compatibility constraints.

### UI/UX Requirements (if applicable)
Layout, interaction and presentation requirements for user-facing features.

## Acceptance Criteria
Observable, testable checks that must pass for the work to be complete.
- [ ] Criterion

## Assumptions
Explicit assumptions and dependencies on other systems, existing
functionality or prior work.

## Open Questions (if any)
Unanswered product decisions for the Managing Intelligence to resolve.
Remove this section when there are none.
```

## Style rules

- **Plain English.** Use short sentences and clear bullet lists, with short paragraphs where detail is needed. Every sentence adds information.
- **Only what the input states.** Keep the PRD short. Include only requirements and guards against real harm grounded in the context and interview answers.
- **Requirements, not solutions.** State the user's problem and needed outcome; leave the design open. Make every requirement specific and verifiable.
  Bad: “Add a red Retry button that calls the retry endpoint.” Good: “Customers can retry a failed payment. An order is charged at most once.”
- **Conversational wording.** Use direct statements without requirement numbers. Use user stories when actor, goal and benefit add clarity.
- **Consistent terms.** Explain each novel term briefly or point to the Glossary at first use in the body. Use its exact Glossary wording in Title Case, including plurals, except names in backticks. Lowercase words and synonyms never stand for defined terms; definitions avoid the lowercase form of their own term. Quote or backtick feature names sharing a term's word.
- **Current requirements.** State the requirements as they now stand. Fold answered Open Questions into the body.

## Quality checklist

Before saving, check the resolved requirements below. Record gaps the Managing Intelligence explicitly leaves unresolved as Open Questions and report the affected checks as incomplete.

- [ ] The Glossary and Goals stand alone, and terms are explained at first use.
- [ ] The problem statement identifies the affected users and the evidence for their need; assumptions are labelled.
- [ ] Goals are concrete and measurable.
- [ ] Non-goals give explicit boundaries.
- [ ] Each requirement states one testable obligation, serves a stated need and has an acceptance check.
- [ ] Supplied priorities and trade-offs are explicit.
- [ ] Supplied edge cases and error scenarios have expected behaviours.
- [ ] Acceptance criteria specify observable outcomes and relevant conditions and measures. Use Given/When/Then for behaviour that depends on context.
- [ ] Assumptions and dependencies are explicit.
- [ ] The document contains requirements rather than implementation details or code.
- [ ] Sections agree with each other.
- [ ] An Agent can implement the resolved requirements without inventing product decisions; unresolved decisions are Open Questions.

## What not to include

- Source code, pseudocode or technical implementation details.
- Architecture decisions, design proposals or instructions for how to build it.
- Defaults, fallbacks, validation, schemas, edge-case rules or guards the input did not request.
- Vague claims such as “fast” or “user-friendly” without agreed measures, or invented targets presented as requirements.
- Time estimates or scheduling.
- Specific file paths, function names or line numbers.
- Rejected alternatives, reversed decisions, history or a decision log.
- Optional mentions, deferred features, later revisions or follow-up work.
