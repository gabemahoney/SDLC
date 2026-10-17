---
name: req-review
description: "Review an Idea's PRD, or its PRD and SRD together, and mark them defined with the Managing Intelligence's approval."
---

# req-review

## Purpose

Reviews the PRD before write-srd, then the PRD and SRD together before write-plan. A fresh Requirements Reviewer checks them for consistency, completeness and clarity, to ensure their quality.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

An Idea ID or one of its PRD or SRD Doc IDs, with any earlier findings and Managing Intelligence decisions for a re-review.

## Reads

- **Workflow:** `~/.apiary/system/workflow.md`. Why: to follow the shared Run rules.
- **Settings files:** `<Project Folder>/.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`. Why: to select the Ticket System Protocol File through `ticket_system`, and the Requirements Reviewer's Thinking Level through `thinking_levels` and `levels_claude_code` or `levels_codex`.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` in Claude Code, or `~/.apiary/system/protocols/agent-codex.md` in Codex CLI. Why: to dispatch Subagents and ask and report through the Agent.
- **The Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: to read the Idea and its Docs and set their approved statuses.
- **Resolver:** `~/.apiary/system/resolvers/<resolver>.md`, selected by each Source Reference's kind. Why: to read the Idea's source material as context.
- **The Idea and every Doc child:** through the Ticket System Protocol File, using the input ID. Why: to see which Docs are `draft`, supply the requirements to the reviewer, and identify other `draft` Docs.
- **Codebase and docs:** the affected code folders under `<Project Folder>`, if any, identified from the Idea and requirements. Why: to give the Requirements Reviewer the context needed to judge whether the requirements fit the existing software.
- **Review reports:** returned by the Requirements Reviewer dispatched during this Run. Why: to present findings and readiness for the Managing Intelligence's decision.

## Gate

Run only when both are true:
- The Idea's PRD or SRD is `draft`. If neither is, there's nothing to review; say so and stop. If the Idea has no PRD, suggest write-prd.
- The Idea isn't `done`, because done work is already shipped. If it is, stop and say so.

## Steps

1. **Review whatever is `draft`.** Dispatch the Requirements Reviewer to review the `draft` PRD, the `draft` SRD, or both. It always reads the PRD, because the SRD is checked against it, but it reviews a `defined` PRD only for the SRD's agreement with it, not on its own.

2. **Get the Managing Intelligence's decision.** Present the findings and readiness verdicts. The Managing Intelligence decides which findings to accept and which Docs to approve. Set each approved PRD or SRD `defined`. The PRD can be approved while the SRD still needs revision, so write-srd can build on settled product requirements.
   - If revisions are needed, hand off the accepted findings and declined findings separately. Suggest that the Managing Intelligence run write-prd for product changes or write-srd for software changes, then req-review again. A PRD change goes through approval before write-srd revises the SRD to match.
   - Once both the PRD and SRD are `defined`, set a `draft` Idea `defined`.

3. **Settle other Docs separately.** For each `draft` Doc other than the PRD, SRD or a TLA+ spec, ask the Managing Intelligence whether to mark it `defined`, and do so on yes. These approvals are independent of the Idea's approval.

## Dispatches

- **Requirements Reviewer:** launch for each review, with the Idea and requirements Doc IDs, relevant code folders, earlier decisions and the review criteria below. Expect findings ordered by criticality, suggested fixes, a separate cut-only pass and a readiness verdict for each reviewed Doc.

## Writes

The PRD and SRD, Doc children of the Idea, each set `defined` when the Managing Intelligence approves it.

The Idea, set from `draft` to `defined` once its PRD and SRD are both `defined`.

Other Docs, excluding TLA+ specs, move from `draft` to `defined` on their own approval.

## Done

Report the reviewed Doc IDs and titles, findings ordered by criticality, suggested fixes and each Doc's readiness verdict. Include the cut-only findings, accepted and declined findings, status changes, and any incomplete review work or decisions still needed.

- If revisions are needed, suggest the writing skill for the accepted findings, followed by req-review.
- If the PRD is `defined` and there's no SRD, suggest write-srd.
- If the PRD and SRD are both `defined`, suggest write-plan.

## Review criteria

Value content over form. Prefer concise, direct requirements and clear organization; user stories are useful when they clarify the requirement.

The Requirements Reviewer checks the relevant code and docs as well as the requirements. Review for:

- **Consistency:** statements agree, terms keep their meanings, and control flows have complete outcomes without unintended gaps or cycles. When an SRD is reviewed, it agrees with the PRD and covers every PRD acceptance criterion.
- **Completeness:** requirements state the dependencies, assumptions, boundaries and expected behaviour for relevant edge cases and errors. Cover the decisions this change needs in proportion to the change.
- **Testability:** each requirement has clear acceptance criteria and observable outcomes. Performance, security, scalability and other non-functional requirements have measures grounded in a stated need or existing constraint.
- **Implementation readiness:** Agents can implement the resolved requirements without inventing product decisions. Flag implied assumptions and unresolved questions that prevent implementation.
- **PRD quality:** the problem and the outcome users need are clear, acceptance criteria are defined, and any user-facing behaviour the change needs is described. Product requirements describe what users need.
- **SRD quality:** deployment, performance, interfaces, data models, authentication and authorization, security and testing are specified where the change needs them. Software requirements fit the existing code and make new capabilities explicit. A risky SRD part lacking a model may be raised as a finding for write-srd.

Make each finding specific: cite the affected Doc and section or requirement, explain its criticality and suggest a fix. Every proposed new rule cites the stated requirement it serves.

In a separate cut-only pass, propose removing repetition, superseded text, padding and unsupported requirements. Preserve current requirements, acceptance criteria and Managing Intelligence decisions. Keep cuts separate from proposed additions so simplification gets its own consideration.
