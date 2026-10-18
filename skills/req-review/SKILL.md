---
name: req-review
description: "Review one PRD or SRD as a Child Agent and return findings to write-prd or write-srd."
---

# req-review

## Purpose

You independently review one draft PRD or SRD for your Main Agent.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

A PRD or SRD Doc ID.

## Required Reading

- **Settings:** supplied by the Main Agent, for configuration.
- **Protocols:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md` and the Ticket System Protocol File selected by `setting:ticket_system`, supplied by the Main Agent, for operations.
- **Doc, Idea and supporting Docs:** for requirements, context and decisions; the approved PRD and Model Docs for SRD coverage and modelling evidence.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when all of these are true:

- You have a parent Main Agent running write-prd or write-srd, because it owns the assignment and judges your findings. If not, stop and say so.
- The assigned Doc is `draft`, because you review requirements before approval. If not, stop and say so.
- The Idea isn't `done`, because a completed Idea has already been accepted. If it is, stop and say so.

## Steps

1. **Review the Doc** using the Review criteria below and its recorded findings and decisions.
2. **Return your findings to your Main Agent** to judge and record on the Doc.

## Child Agents

None: you review the Doc yourself.

## Writes

None: your Main Agent owns the Doc's record.

## Done

Report the Doc ID and your findings to your Main Agent, or say there are none.

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
