---
name: req-review
description: "Review an Idea's PRD or SRD, record findings and the Managing Intelligence's decisions on each Doc, and mark approved Docs defined."
---

# req-review

## Purpose

Reviews draft requirements independently: the PRD before write-srd, then the SRD against the approved PRD before write-plan.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

An Idea ID or one of its PRD or SRD Doc IDs.

## Required Reading

- **Settings:** Project and default settings, resolved as `workflow.md` describes, for this Run's configuration.
- **Agent Protocol File:** `agent-claude-code.md` or `agent-codex.md` under `~/.apiary/system/protocols/`, for context readings and skill invocation.
- **Ticket System Protocol File:** selected by `ticket_system` as `workflow.md` describes, to read the Idea and its Docs, record findings and decisions, and set their approved statuses.
- **The Idea and every Doc child:** to see which Docs are `draft`, read unresolved findings and decisions, and review the current requirements.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when both of these are true:

- The Idea's PRD or SRD is `draft`. If neither is, there's nothing to review; say so and stop. If the Idea has no PRD, suggest write-prd.
- The Idea isn't `done`, because the Idea has already been accepted. If it is, stop and say so.

If this session wrote the PRD or SRD you'd review, stop and suggest a fresh session, so the review is independent.

## Steps

1. **Review whatever is `draft`:** the PRD, the SRD or both, using the Review criteria below. Check earlier findings against the current requirements. Record unresolved findings on the affected Doc for its writing skill; remove findings already fixed so the record shows only what remains.

2. **Get the Managing Intelligence's decision.** The Managing Intelligence decides which findings to accept or decline and which Docs to approve. Record the readiness verdict and reasons for declined or unaddressed findings on the Doc so revision follows the decision. Only when the Managing Intelligence approves a PRD or SRD, set it `defined`. The PRD can be approved while the SRD still needs revision, so write-srd can build on settled product requirements.
   - If revisions are needed, suggest write-prd for product changes or write-srd for software changes, then req-review again. A PRD change goes through approval before write-srd revises the SRD to match.
   - Once both the PRD and SRD are `defined`, set a `draft` Idea `defined`.

## Dispatches

None: req-review reviews the Docs itself.

## Writes

req-review records readiness verdicts and declined or unaddressed findings with reasons on the Doc tickets. Requirements changes belong to the writing skills, so the review remains independent of the writers' work.

- The PRD or SRD: set to `defined` when the Managing Intelligence approves it.
- The Idea: set from `draft` to `defined` once its PRD and SRD are both `defined`.

## Done

Report the reviewed Doc IDs and any findings left unaddressed with the reason.

- If revisions are needed, suggest the writing skill for the accepted findings, followed by req-review.
- If the PRD is `defined` and there's no SRD, suggest write-srd.
- If the PRD and SRD are both `defined`, suggest write-plan.

## Review criteria

Value content over form. Prefer concise, direct requirements and clear organization; user stories are only useful when they clarify the requirement.

Check the relevant code and docs as well as the requirements. Review for:

- **Consistency:** statements agree, terms keep their meanings, and control flows have complete outcomes without unintended gaps or cycles. When an SRD is reviewed, it agrees with the PRD and covers every PRD acceptance criterion.
- **Completeness:** requirements state the dependencies, assumptions, boundaries and expected behaviour for relevant edge cases and errors. Cover the decisions this change needs in proportion to the Idea.
- **Testability:** each requirement has clear acceptance criteria and observable outcomes. Performance, security, scalability and other non-functional requirements have measures grounded in a stated need or existing constraint.
- **Implementation readiness:** Agents can implement the resolved requirements without inventing product decisions. Flag implied assumptions and unresolved questions that prevent implementation.
- **PRD quality:** the problem and the outcome users need are clear, acceptance criteria are defined, and any user-facing behaviour the Idea needs is described. Product requirements describe what users need.
- **SRD quality:** deployment, performance, interfaces, data models, authentication and authorization, security and testing are specified where the Idea needs them. Software requirements fit the existing code and make new capabilities explicit. A risky SRD part lacking a model may be raised as a finding for write-srd.

Make each finding specific: cite the affected Doc and section or requirement, explain its criticality and suggest a fix. Every proposed new rule cites the stated requirement it serves.

In a separate cut-only pass, propose removing repetition, superseded text, padding and unsupported requirements. Preserve current requirements, acceptance criteria and Managing Intelligence decisions. Keep cuts separate from proposed additions so simplification gets its own consideration.
