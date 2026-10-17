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
- **Product Manager's report:** returned during this Run. Why: to revise the Plan from its findings.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

The Idea is `defined`, or `active` when revising a Plan, and has a PRD and an SRD. Both Docs are `defined`, unless the Managing Intelligence explicitly confirms planning without review in step 1.

Finish the Idea's existing Plan when it is `draft` or `defined`; create a Plan only when the Idea has none, so the work has one Plan to follow.

## Steps

1. **Settle readiness for planning.**
   - If either required Doc is not `defined`, stop and ask the Managing Intelligence: confirm planning without review. Continue only on an explicit yes.
   - If both are `defined`, continue with planning.

2. **Write the Plan and Epics.** First state in a sentence what changes for the user or system when the Idea is done, from the PRD's goals, acceptance criteria and constraints. If you can't, stop and raise it with the Managing Intelligence, because Epics cut without a clear outcome won't add up to one. Follow the SRD's software requirements, technology choices and architecture. Write each ticket as "What to write in each ticket" below says, and follow the Planning guidance.
   - If the Idea has no Plan, create one and its Epics as `draft`.
   - If the Idea already has a Plan, bring it up to date with the SRD; write-srd's note on the Plan says which SRs changed. Update every Epic the SRD change affects, whatever its status, and set it to `draft` so write-epic replans it. Add new Epics as `draft`, remove any no longer needed, and leave the rest as they are.

3. **Check the Plan with the Product Manager.** Save the Plan and Epics, then dispatch the Product Manager. Fix what its findings show, and dispatch a fresh one after any significant change, until its findings are resolved. Then check the whole Plan against the Quality checklist below.

4. **Set the Plan's status.** Only once the Product Manager's findings are resolved and the Quality checklist passes:
   - If any Epic is `done` or `active`, set the Plan `active`, because work is already underway.
   - Otherwise, set the Plan `defined`.

## Dispatches

- **Product Manager:** launch fresh after writing or revising the Plan, with the Idea, PRD, SRD, Plan and Epic IDs. Expect findings on product coverage, scope and proportion, with references and suggested fixes. An independent read checks the planner's judgement before the Plan is finalized.

## Writes

- **The Plan:** one per Idea, in the Plans store, with an Association to its Idea so later skills can find the requirements. A new Plan starts `draft`, and becomes `defined` or `active` in step 4.
- **Its Epics:** children of the Plan. When one Epic can't start until another is `done`, record a Dependency from the waiting Epic on the one it waits for. New and changed Epics are `draft`. When revising a Plan, remove any Epic the changed SRD no longer calls for.

## Done

Report the Plan's ID, and any Product Manager findings left unaddressed with the reason.

Suggest write-epic on each `draft` Epic in dependency order.

## What to write in each ticket

**The Plan ticket's body:** the goal and scope in two or three sentences, and why this number of Epics fits the Idea.

**Each Epic ticket's body:**
- **Outcome:** the one user- or system-visible capability it delivers, and how success is measured.
- **Work:** what it takes to deliver that outcome, the requirements it serves and the code folders it touches, including the engineering, testing and documentation work the Guidance Documents require.
- **Acceptance criteria:** how the Managing Intelligence can check the outcome on the result. Where they can't interact with it directly, how the Agent will show it with observable evidence.
- **Dependencies:** why each Epic it depends on must be `done` first.

## Planning guidance

Keep the Plan and its Epics in proportion to the Idea. As a rough guide, a small Idea has 1–3 Epics, a medium one 3–6, a large one 6–9 and a new product 10 or more. These are guidance, not limits: choose the count by judgement, and when it falls outside the range, give a good reason for it in the Plan's body.

**An Epic is a vertical slice of the end product.** It delivers one new feature, or one working part of a feature, through the whole stack: the code, its tests and its docs. The test is a sprint demo: when the Epic is `done`, you could show the product doing at least a little something new. Code alone or a set of tests isn't a demo. Every Epic leaves the software working with existing tests passing.

Slice by capability, not by layer. "User places an order and sees confirmation", "System retries a failed payment" and "Metrics are emitted for each order" are good Epics. "Database", "API", "UI", "Testing" and "Documentation" are not, because none of them delivers something a user can check on its own.

Common Dependencies: a capability depends on the infrastructure it uses; a screen depends on the data and services it shows; processing depends on the import that supplies its data; protected features depend on authentication. For each Epic, ask what must be `done` before it can start. Watch for chains whose intermediate states cannot be tested and for pervasive refactors mixed into feature work without serving its outcome.

Acceptance criteria describe that demo. For example, “Start the server and request its health endpoint; it returns the SRD's expected response” gives a checkable result. “The server is available” leaves success undefined.

Plan documentation only as `doc-writing-guide.md` allows: it decides which doc files exist and what changes belong in them. Plan required test types and engineering steps within the Epics they support.

## Quality checklist

- [ ] The Plan covers the PRD's goals and acceptance criteria and the SRD's requirements and choices.
- [ ] Each Epic meets the workflow's Epic rule and has one coherent outcome with a concrete demonstration of success.
- [ ] Each Epic leaves the software working, and its prerequisites are recorded as Dependencies.
- [ ] The Epic count fits the size of the Idea, with a reason for any departure from the guidance range.
- [ ] Engineering and testing work required by the Guidance Documents belongs to the Epics it supports.
- [ ] Every planned documentation change is allowed by the doc-writing guide.
- [ ] Every planned requirement is grounded in the Idea's Docs, supplied decisions or applicable Guidance Documents.
- [ ] A revision accounts for changed SRs and preserves completed Epics.
- [ ] The Product Manager has checked the Plan, and its findings have been addressed.

## What not to include

Include defaults, fallbacks, validation, edge-case rules, schemas and guards only when the Idea's Docs or applicable Guidance Documents require them. Keep Task and Subtask detail for write-epic, so detailed planning has a fresh context for each Epic.
