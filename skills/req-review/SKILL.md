---
name: req-review
description: "Review one PRD or SRD as a Child Agent and return findings to write-prd or write-srd."
---

# req-review

## Purpose

You independently review one draft PRD or SRD for your Main Agent.

## Loading SDLC

Read `~/.sdlc/system/workflow.md` first for shared rules, settings and file locations.

## Input

A PRD or SRD Doc ID.

## Required Reading

- **Launcher:** `protocol:launcher.md`, for how you work as a Child Agent and report to your Main Agent.
- **Settings:** supplied by the Main Agent, for configuration.
- **Protocols:** your Agent Protocol File (`protocol:agent-claude-code.md`, `protocol:agent-codex.md` or `protocol:agent-cursor.md`) and the Ticket System Protocol File selected by `setting:ticket_system`, supplied by the Main Agent, for operations.
- **Doc, Idea and supporting Docs:** for requirements, context and decisions; the approved PRD and Model Docs for SRD coverage and modelling evidence.
- **Guidance:** `guide:engineering-best-practices.md`, `guide:doc-writing-guide.md` and `guide:test-guide.md` for Project constraints in both PRD and SRD reviews.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when the assigned Doc is `draft`, because you review requirements before approval. Otherwise, stop and report its status.

## Steps

1. **Review the Doc** using the Review criteria below and its recorded findings and decisions.
2. **Return your findings to your Main Agent** to judge and record declined or unaddressed findings under `## Declined findings` on the Doc.

## Child Agents

None: you review the Doc yourself.

## Writes

None: your Main Agent owns the Doc's record.

## Done

Report the Doc ID and your findings to your Main Agent as `protocol:launcher.md` describes. State when there are no findings.

## Review criteria

Value content over form. Prefer concise, direct requirements and clear organization; user stories are only useful when they clarify the requirement.

Check the relevant code and docs as well as the requirements. Review for:

- **Guide conflicts:** Check both PRDs and SRDs against these three guides and report every conflict not covered by the Doc's `## Guide exceptions` as **major**, so the Managing Intelligence settles it before approval.
- **Consistency:** statements agree, terms keep their meanings, and control flows have complete outcomes without unintended gaps or cycles. When an SRD is reviewed, it agrees with the PRD and covers every PRD acceptance criterion.
- **Completeness:** requirements state the dependencies, assumptions, boundaries and expected behaviour for relevant edge cases and errors. Cover the decisions this change needs in proportion to the Idea.
- **Testability:** each requirement has clear acceptance criteria and observable outcomes. Performance, security, scalability and other non-functional requirements have measures grounded in a stated need or existing constraint.
- **Implementation readiness:** Agents can implement the resolved requirements without inventing product decisions. Flag implied assumptions and unresolved questions that prevent implementation.
- **PRD quality:** the problem and the outcome users need are clear, acceptance criteria are defined, and any user-facing behaviour the Idea needs is described. Report a capability or outcome the PRD adds that the Idea doesn't describe, because new scope needs the Idea changed first. Report anything about what the code does or how as a finding to move to the SRD, because the PRD covers only what a user sees or interacts with. Also report numbers the Managing Intelligence didn't state or confirm, and deferred or follow-up work. Report a gap whose fix needs design as a lead for write-srd, not a PRD edit, because each pulls the PRD into design.
- **SRD quality:** deployment, performance, interfaces, data models, authentication and authorization, security and testing are specified where the Idea needs them. Software requirements fit the existing code and make new capabilities explicit. A risky SRD part lacking a model may be raised as a finding for write-srd.

Make each finding specific: cite the affected Doc and section or requirement, explain its criticality and suggest a fix. Every proposed new rule cites the stated requirement it serves.

In a separate cut-only pass, propose removing repetition, superseded text, padding, unsupported requirements, and sections that duplicate or belong in another Doc or a Guidance Document. Preserve current requirements, acceptance criteria and Managing Intelligence decisions. Keep cuts separate from proposed additions so simplification gets its own consideration.
