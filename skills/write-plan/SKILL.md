---
name: write-plan
description: "Turn an Idea's PRD and SRD into a Plan and draft Epics, or revise its existing Plan after requirements change."
---

# write-plan

## Purpose

Turns the `defined` PRD and SRD into a Plan and its Epics. write-epic then breaks each Epic into Tasks.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

An Idea ID.

## Required Reading

- **Workflow:** `~/.apiary/system/workflow.md`. Why: to follow the shared Run rules.
- **Settings files:** `<Project Folder>/.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`. Why: to select the Ticket System Protocol File through `ticket_system`, and the Product Manager's Thinking Level through `thinking_levels` and `levels_claude_code` or `levels_codex`.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` in Claude Code, or `~/.apiary/system/protocols/agent-codex.md` in Codex CLI. Why: to dispatch the Product Manager and ask and report through the Agent.
- **The Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: to read the Idea and its Docs, and write the Plan, Epics and their relationships.
- **The Idea, its Docs and existing Plan and Epics:** through the Ticket System Protocol File, using the input Idea ID. Why: to ground the Plan in requirements, reuse existing planning and preserve completed work.
- **Engineering, testing and documentation guidance:** `engineering-best-practices.md`, `test-guide.md`, `doc-writing-guide.md` and `maintained-docs.md` for each affected code folder, found as `workflow.md` describes, including the documents listed by `maintained-docs.md`. Why: to understand the existing design, plan required engineering and testing work, and limit documentation work to what its guide allows.
- **Codebase and tests:** the affected code folders under `<Project Folder>`, if any, identified from the Idea and requirements. Why: to fit the Epics to the software that exists.
- **Research tickets and Reports:** every Research ticket linked from the SRD or the Idea, through the Ticket System Protocol File. Why: to plan with the evidence behind the SRD's technology and architecture choices.
- **Product Manager's report:** returned during this Run. Why: to revise the Plan from its findings.

## Gate

The Idea is `defined`, or `active` when revising a Plan that write-srd reset, and has a PRD and an SRD. Both Docs are `defined`, unless the Managing Intelligence explicitly confirms planning without review in step 1.

Finish the Idea's existing Plan when it is `draft` or `defined`; create a Plan only when the Idea has none, so the work has one Plan to follow.

## Steps

1. **Settle readiness for planning.**
   - If either required Doc is not `defined`, stop and ask the Managing Intelligence: confirm planning without review. Continue only on an explicit yes.
   - If both are `defined`, continue with planning.

2. **Write the Plan and Epics.** Establish the outcome from the PRD's goals, acceptance criteria and constraints, and follow the SRD's software requirements, technology choices and architecture. Use the templates and craft guidance below to write the Plan itself and set its Epic dependencies.
   - If the Idea has no Plan, create one and its Epics as `draft`.
   - If the Idea has a `draft` or `defined` Plan, finish or revise that Plan. For a Plan write-srd reset, use its report to reconsider the changed SRs and the Epics that were `active`. Preserve `done` Epics; revise, add or drop the remaining Epics to fit the changed SRD. Revised Epics return to `draft` for write-epic to reconcile their Tasks before execution resumes. Remove dropped Epics from the Plan through the Ticket System Protocol File, preserving completed work. Put any further work needed on a completed capability into the remaining Epics, so completed work stays recorded.

3. **Check the Plan with the Product Manager.** Save the Plan and Epics, then dispatch the Product Manager for an independent check of product, scope and proportion. Revise from its findings and check the whole Plan against the Quality checklist below before finalizing it.

4. **Set the Plan's status.**
   - If any Epic is `done` or `active`, set the Plan `active` to reflect work already underway.
   - Otherwise, set the Plan `defined`.

## Dispatches

- **Product Manager:** launch fresh after writing or revising the Plan, with the Idea, PRD, SRD, Plan and Epic IDs. Expect findings on product coverage, scope and proportion, with references and suggested fixes. An independent read checks the planner's judgement before the Plan is finalized.

## Writes

The Plan in the Plans store starts as `draft`, with a dependency on the Idea and a reference linking back to it, recorded through the Ticket System Protocol File. An existing `draft` or `defined` Plan is updated in place. After the Product Manager's check and revision, set the Plan `defined`, or `active` if any Epic is `done` or `active`.

Epics are children of the Plan, created as `draft` with their dependencies recorded. Revised Epics return to `draft`; unchanged Epics keep their statuses and `done` Epics are preserved. Dropped Epics are removed from the Plan through the Ticket System Protocol File.

## Done

Report the Plan's ID and status, and each Epic's ID, title, status, dependencies and one-line outcome in dependency order. Include the size class and reason for its Epic count, the Product Manager's findings and resulting revisions, ambiguous decomposition decisions and their rationale, and any incomplete work. For a revised Plan, identify the changed SRs addressed and the Epics preserved, revised, added or dropped.

Suggest write-epic on each `draft` Epic in dependency order.

## Plan template

- **Goal and scope:** summarize the outcome and the work included in two or three sentences, grounded in the PRD's Goals and the SRD.
- **Requirements:** link the Idea, PRD and SRD so the Plan's basis is clear.
- **Epics and order:** list the Epics, each one's outcome and the dependencies that determine their order.
- **Proportion:** state the size class, the Epic count and why that decomposition fits the change.

## Epic template

- **Outcome:** state the single user- or system-visible capability the Epic delivers and its measurable success condition.
- **Work and requirements:** describe the work needed for that outcome, cite the requirements it serves, and identify the affected code folders. Include the engineering, testing and documentation work the Guidance Documents require within the Epic it supports.
- **Acceptance criteria:** describe how the Managing Intelligence can demonstrate the outcome using the resulting artifact. Where direct interaction is unavailable, explain how the Agent will demonstrate completion with observable evidence.
- **Dependencies:** name the Epics that must be complete before this one can be worked on, and explain why.

## Planning guidance

Keep the Plan and its Epics short and in proportion to the change. Use these Epic counts as guidance: small, 1–3; medium, 3–6; large, 6–9; new product, 10+. Choose the count by judgement and state a reason when it falls outside its range. A single Epic can be enough.

Every Epic must leave the software working with existing tests passing. Each outcome should be independently testable and demonstrable when its dependencies are complete. Watch for chains whose intermediate states cannot be tested and for pervasive refactors mixed into feature work without serving its outcome.

Acceptance criteria describe a concrete demonstration. For example, “Start the server and request its health endpoint; it returns the SRD's expected response” gives a checkable result. “The server is available” leaves success undefined.

Plan documentation only as `doc-writing-guide.md` allows: it decides which doc files exist and what changes belong in them. Plan required test types and engineering steps within the Epics they support.

## Quality checklist

- [ ] The Plan covers the PRD's goals and acceptance criteria and the SRD's requirements and choices.
- [ ] Each Epic meets the workflow's Epic rule and has one coherent outcome with a concrete demonstration of success.
- [ ] Each Epic leaves the software working, and its prerequisites are recorded as dependencies.
- [ ] The Epic count fits the size of the change, with a reason for any departure from the guidance range.
- [ ] Engineering and testing work required by the Guidance Documents belongs to the Epics it supports.
- [ ] Every planned documentation change is allowed by the doc-writing guide.
- [ ] Every planned requirement is grounded in the Idea's Docs, supplied decisions or applicable Guidance Documents.
- [ ] A revision accounts for changed SRs and preserves completed Epics.
- [ ] The Product Manager has checked the Plan, and its findings have been addressed.

## What not to include

Include defaults, fallbacks, validation, edge-case rules, schemas and guards only when the Idea's Docs or applicable Guidance Documents require them. Keep Task and Subtask detail for write-epic.
