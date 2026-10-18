---
name: write-plan
description: "Turn an Idea's PRD and SRD into a Plan and draft Epics, or revise its existing Plan after requirements change."
---

# write-plan

## Purpose

You turn the `defined` PRD and SRD into a Plan and its Epics. write-epic then breaks each Epic into Tasks.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

An Idea ID.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md`, `protocol:launcher.md` and the Ticket System Protocol File selected by `setting:ticket_system`, for operations.
- **Idea, its Docs and existing Plan and Epics:** for requirements and earlier planning.
- **Guidance:** `guide:engineering-best-practices.md`, `guide:test-guide.md` and `guide:doc-writing-guide.md` for engineering, testing and documentation planning in each affected code folder.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

The Idea is `defined`, or `active` when revising a Plan, and has a PRD and an SRD. Both Docs are `defined`, unless the Managing Intelligence explicitly confirms planning without review in step 1.

Revise the existing Plan; create one only if absent, so the Idea keeps one Plan.

## Steps

1. **Settle readiness for planning.**
   - If either Doc is not `defined`, continue only with the Managing Intelligence's explicit approval to plan without review.
   - If both are `defined`, continue with planning.

2. **Write the Plan and Epics.** First state in a sentence what changes for the user or system when the Idea is done, from the PRD's goals, acceptance criteria and constraints. If you can't, stop and raise it with the Managing Intelligence, because Epics cut without a clear outcome won't add up to one. Follow the SRD's software requirements, technology choices and architecture. Write each ticket as "What to write in each ticket" below says, and follow the Planning guidance.
   - If the Idea has no Plan, create one and its Epics as `draft`.
   - If the Idea already has a Plan, bring it up to date with the SRD; `## SRD changes` on the Plan says which SRs changed. Update every Epic the SRD change affects, whatever its status, and set it to `draft` so write-epic replans it. Add new Epics as `draft`, remove any no longer needed, and leave the rest as they are.

3. **Check the Plan with the `product-manager`.** Save the Plan and Epics, then launch `product-manager`. Judge every finding under the shared rule and review again after significant changes. Then check the whole Plan against the Quality checklist below.

4. **Set the Plan's status.** Only once the `product-manager`'s accepted findings are fixed and the Quality checklist passes:
   - If any Epic is `done` or `active`, or was before this revision, set the Plan `active`, because work is already underway.
   - Otherwise, set the Plan `defined`.

## Child Agents

- **`product-manager`:** Start fresh every time so each assessment is independent. Launch after writing or revising the Plan, with the Idea, PRD, SRD, Plan and Epic IDs. Expect findings on product coverage, scope and proportion, with references and suggested fixes.

## Writes

- **The Plan:** one per Idea, in the Plans store, with an Association to its Idea so later skills can find the requirements. A new Plan starts `draft`, and becomes `defined` or `active` in step 4.
- **Its Epics:** children of the Plan. When one Epic can't start until another is `done`, record a Dependency from the waiting Epic on the one it waits for. New and changed Epics are `draft`. When revising a Plan, remove any Epic the changed SRD no longer calls for.

## Done

Report the Plan's ID, and any `product-manager` findings left unaddressed with the reason.

Suggest write-epic on each `draft` Epic in dependency order.

## What to write in each ticket

**The Plan ticket's body:**

- `## Goal and scope`: the goal and scope in two or three sentences.
- `## Epic count`: why this number of Epics fits the Idea.
- `## Declined findings`: declined or unaddressed review findings, with reasons.

**Each Epic ticket's body:**

- `## Outcome`: the one user- or system-visible capability it delivers, and how success is measured.
- `## Work`: what it takes to deliver that outcome, the requirements it serves and the code folders it touches, including the engineering, testing and documentation work the Guidance Documents require.
- `## Acceptance criteria`: how the Managing Intelligence can check the outcome on the result. Where they can't interact with it directly, how the Agent will show it with observable evidence.
- `## Dependencies`: why each Epic it depends on must be `done` first.
- `## Declined findings`: declined or unaddressed review findings about this Epic, with reasons.

## Planning guidance

Keep the Plan and its Epics in proportion to the Idea. As a rough guide, a small Idea has 1–3 Epics, a medium one 3–6, a large one 6–9 and a new product 10 or more. These are guidance, not limits: choose the count by judgement, and when it falls outside the range, give a good reason for it under `## Epic count` on the Plan.

Slice by capability, following the workflow's Epic rule. “User places an order and sees confirmation” is a coherent demo. Grouping by layer, such as database or UI, hides whether the product works. A refactor's demo shows existing behaviour still working. Leave every Epic working with existing tests passing.

Acceptance criteria describe that demo. For example, “Start the server and request its health endpoint; it returns the SRD's expected response” gives a checkable result. “The server is available” leaves success undefined.

Plan documentation as `guide:doc-writing-guide.md` guides, including which doc files to write and what belongs in them. Plan the test types and engineering steps the Guidance Documents call for inside the Epics they support.

## Quality checklist

- [ ] The Plan covers the PRD's goals and acceptance criteria and the SRD's requirements and choices.
- [ ] Each Epic meets the workflow's Epic rule and has one coherent outcome with a concrete demonstration of success.
- [ ] Each Epic leaves the software working, and its prerequisites are recorded as Dependencies.
- [ ] The Epic count fits the size of the Idea, with a reason for any departure from the guidance range.
- [ ] Engineering and testing work required by the Guidance Documents belongs to the Epics it supports.
- [ ] Every planned documentation change is allowed by the doc-writing guide.
- [ ] Every planned requirement is grounded in the Idea's Docs, supplied decisions or applicable Guidance Documents.
- [ ] A revision covers every changed SR, and every Epic it affects is back in `draft`.
- [ ] The `product-manager` has checked the Plan, and every finding has been judged and accepted fixes applied.

## What not to include

- Work the PRD, SRD or Guidance Documents don't ask for, such as extra validation or fallbacks, because the SRD has already defined the full set of requirements.
- Task-level detail. Leave it to write-epic, which plans each Epic with a fresh context.
