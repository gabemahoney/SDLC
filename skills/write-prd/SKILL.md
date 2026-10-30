---
name: write-prd
description: "Write or revise an Idea's Product Requirements Document (PRD) from its context, an interview, and findings and change requests recorded on its tickets."
---

# write-prd

## Purpose

You follow write-idea and write the product requirements for write-srd and planning.

## Loading SDLC

Read `~/.sdlc/install/workflow.md` first for shared rules, settings and file locations.

## Input

An Idea ID.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** your Agent Protocol File (`protocol:agent-claude-code.md`, `protocol:agent-codex.md` or `protocol:agent-cursor.md`), `protocol:launcher.md` and the Ticket System Protocol File selected by `setting:ticket_system`, for operations.
- **Idea and its existing Docs:** for requirements and existing PRD and SRD context.
- **Template:** `setting:prd_template`, for PRD structure.
- **Resolvers:** the files selected by Intakes and Resolvers in `~/.sdlc/install/workflow.md`, for source instructions and prerequisites, so optional custom mappings and shipped Resolvers work alike.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

A revision that adds scope the Idea doesn't describe stops and returns to the Managing Intelligence, who has write-idea revise it and approves the revision first, because the approved Idea bounds the PRD.

## Steps

1. **Gather requirements** from the Idea, Source References, existing Docs and recorded change requests.

2. **Interview the Managing Intelligence.** Settle the problem, outcomes, acceptance criteria, boundaries, edge cases, errors, UI/UX, performance, security and dependencies as the Idea needs. Establish users, operators and deployment constraints that affect the product. Follow dependent decisions only where they change product behaviour. Look up facts; ask the Managing Intelligence for decisions. Finish when they confirm the shared understanding; decisions they leave unresolved become Open Questions.

3. **Write or revise the PRD** using the body sections in `setting:prd_template` and the craft guidance below.

4. **Review the whole draft** for succinctness, product requirements, dropped ideas and the Quality checklist, in that order. Repeat all four checks after changes until a full round changes nothing, so revisions receive the same scrutiny as a first draft.
   - Fold changes into the affected requirements so readers find one current account. Cut superseded text and padding while preserving current requirements, acceptance criteria, supplied edge cases and Managing Intelligence decisions. Only acceptance criteria and summaries may repeat behaviour.
   - State what people need from the product; software design belongs in the SRD.
   - Include a boundary from a dropped idea only if the Managing Intelligence wants it stated.

5. **Save the PRD** as described under Writes.

6. **Review the PRD with `req-review`.** Launch a fresh Child Agent each round so each review is independent. Take every conflict with `guide:engineering-best-practices.md`, `guide:doc-writing-guide.md` or `guide:test-guide.md` to the Managing Intelligence as a major finding, because only they may settle it. Judge other findings: fix them, decline minor findings with reasons, or take product questions to the Managing Intelligence. Record each design lead you accept as one line on what's open in `srd-leads.md`, attached to the Idea through `protocol:ticket.md` and linked under its `## Artifacts`, so write-srd settles it and the PRD and Idea body stay free of design. Expect many PRD findings to need product decisions. Save revisions and repeat until a review returns nothing left to fix. Then hand the PRD to the Managing Intelligence for approval, reporting declined findings with their reasons.

## Child Agents

- **`req-review`:** Launch after writing or revising the PRD, fresh every round so each review is independent. Expect findings with references and suggested fixes, or none.

## Writes

Record each approved guide exception once under `## Guide exceptions` on the PRD or SRD it concerns, stating the guide rule, what the spec does instead, why and the Managing Intelligence's approval, so later work preserves the decision.

Create or update the Idea's Doc titled `PRD`. Set it `draft` because a new or revised PRD needs approval. Record declined or unaddressed review findings with their reasons under `## Declined findings` on the PRD.

## Done

Report the PRD's ID and anything left unaddressed with the reason.

The PRD remains `draft` and awaits the Managing Intelligence's approval. The Managing Intelligence sets it `defined` on approval.

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
- Leave out deferred features and follow-up work.
