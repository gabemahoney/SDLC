---
name: write-prd
description: "Write or revise an Idea's Product Requirements Document (PRD) from its context, an interview, and findings and change requests recorded on its tickets."
---

# write-prd

## Purpose

Follows write-idea and writes the product requirements for write-srd, req-review and planning.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

An Idea ID.

## Required Reading

- **Workflow:** `~/.apiary/system/workflow.md`. Why: to follow the shared Run rules.
- **Settings files:** `<Project Folder>/.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`. Why: to select the Ticket System Protocol File through `ticket_system` and the PRD template through `prd_template`.
- **PRD template:** the file at the path named by `prd_template`. Why: to structure the PRD.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` in Claude Code, or `~/.apiary/system/protocols/agent-codex.md` in Codex CLI. Why: to interview the Managing Intelligence and report through the Agent.
- **The Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: to read the Idea and its Docs, and create or update its PRD.
- **Resolver:** `~/.apiary/system/resolvers/<resolver>.md`, selected by each Source Reference's kind. Why: to read the Idea's source material as context.
- **The Idea and its existing Docs:** through the Ticket System Protocol File, using the input Idea ID. Why: to gather requirements, find the PRD to revise and determine whether an SRD exists.

## Gate

None: the PRD can be written or revised at any Idea status.

## Steps

1. **Gather the existing requirements.** Read the Idea, its Source References and existing Docs, including accepted findings on the PRD and the Managing Intelligence's change requests on the Idea or PRD, so revisions follow the recorded decisions.

2. **Interview the Managing Intelligence until you share an understanding.** Cover the problem, acceptance criteria, boundaries, edge cases and errors, UI/UX, performance and security constraints, and dependencies on or effects on other work. Ask where the product runs, who operates it and what it runs on, as far as that shapes what its users get.
   - Treat the decisions this Idea needs as a tree: each one branches into the decisions that depend on it. Follow only branches that change what the product must do; don't invent new edge cases to explore.
   - Ask in rounds. Each round asks every question whose prerequisites are already settled. Number each question, give your recommended answer, and word it so "yes" accepts that answer. Hold a question that depends on one still open in this round for a later round.
   - Look up facts yourself instead of asking: the code, the Idea, its Docs and Source References. Ask only for decisions. Keep asking the other questions while a lookup runs.
   - Stop when every branch is either answered or one the Managing Intelligence chooses to leave open, nothing is silently assumed, and they confirm you share an understanding. Questions they leave open become Open Questions.

3. **Write the PRD.** Read the file named by `prd_template` and draft the PRD from it, following the craft guidance below.

4. **Review it yourself.** Read the whole draft once for each of the four checks below, one after another. If any check changed something, do all four again. Stop when a full round changes nothing. Do this for a first draft and a revision alike.
   - **Succinctness:** cut repetition and padding with no loss of signal.
     - Fold each accepted finding or change into the body where it belongs. Never append amendments, errata or a review-fixes section, so later skills find one current account of the requirements.
     - Cut text a change superseded, repeated text and padding.
     - Keep every current requirement, acceptance criterion, edge case and Managing Intelligence answer. One the Managing Intelligence withdrew or replaced is no longer current, so cut it.
     - An acceptance criterion may restate the behaviour it checks, and a summary section may restate what the body details. Nothing else repeats.
   - **Product, not software:** rewrite any requirement that describes how the software works (code, components, data structures, APIs) as what the product must do for the people who use it. Software requirements belong in the SRD.
   - **Dropped ideas:** remove every trace of ideas discussed and dropped. If the interview considered something and decided against it, the PRD doesn't mention it at all. No "must not do X" or "X is out of scope" just because X came up. Keep a Non-Goal only when the Managing Intelligence wants that boundary stated.
   - **Quality checklist:** check every item in the Quality checklist below, and fix what fails.

5. **Save the PRD.**
   - If the Idea has a PRD, update that Doc.
   - Otherwise, create it.
   Mark each finding folded into the saved PRD resolved on that Doc, so req-review can check what changed.

## Dispatches

None: write-prd interviews and writes the PRD itself.

## Writes

The PRD, a Doc child of the Idea titled `PRD`, including resolution of its accepted findings. A new PRD starts as `draft`, and a revised `defined` PRD goes back to `draft`.

## Done

Report the PRD's ID and anything left unaddressed with the reason.

Suggest “req-review”.

## Style rules

- **Plain English.** Use short sentences, bullet lists and short paragraphs.
- **Only what the input states.** Include only requirements and guards against real harm grounded in the context and interview answers.
- **No false precision.** Give a number only when the Managing Intelligence states one or confirms it is a real limit, because the SRD must meet it exactly. Otherwise state the need and how it will be judged. If the Managing Intelligence can't say how a need will be judged, make it an Open Question.
- **Requirements, not solutions.** State the user's problem and needed outcome; leave the design open.
  Bad: “Add a red Retry button that calls the retry endpoint.” Good: “Customers can retry a failed payment. An order is charged at most once.”
- **Conversational wording.** Use direct statements without requirement numbers. Use user stories when actor, goal and benefit add clarity.
- **Consistent terms.** Write each defined term in Title Case wherever it appears, and briefly explain it at its first use. Never use a synonym for a defined term.

## Quality checklist

If an Open Question stops a check below from passing, say so in your report and mark that check incomplete.

- [ ] The problem statement names who has the problem and why it matters to them.
- [ ] Every requirement is user-facing product behaviour; nothing describes code, components or data structures.
- [ ] Nothing mentions an idea that was discussed and dropped, except a Non-Goal the Managing Intelligence asked to keep.
- [ ] Supplied edge cases and error scenarios have expected behaviours.
- [ ] Each requirement states one testable obligation, serves a stated need and has an acceptance check.
- [ ] Supplied priorities and trade-offs are explicit.
- [ ] Acceptance criteria specify observable outcomes, and the conditions and measures that matter.
- [ ] Sections agree with each other.
- [ ] An Agent can implement the resolved requirements without inventing product decisions.

## What not to include

- Leave out time estimates and scheduling.
- Leave history and decision logs out of the requirements body; review records belong on the Doc ticket so later Runs can use them.
- Leave out deferred features and follow-up work.
