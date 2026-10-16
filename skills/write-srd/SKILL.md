---
name: write-srd
description: "Write or revise an Idea's Software Requirements Document (SRD) from its PRD and codebase, and model the parts that need TLA+."
---

# write-srd

## Purpose

Follows write-prd and writes the software requirements and any TLA+ models for req-review and planning.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

An Idea ID, with optional review findings or change notes for a revision.

## Reads

- **Workflow:** `~/.apiary/system/workflow.md`. Why: to follow the shared Run rules.
- **Settings files:** `<Project Folder>/.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`. Why: to select the Ticket System Protocol File through `ticket_system`, and the TLA+ Writer's Thinking Level through `thinking_levels` and `levels_claude_code` or `levels_codex`.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` in Claude Code, or `~/.apiary/system/protocols/agent-codex.md` in Codex CLI. Why: to locate the installed TLA+ Writer definition, dispatch it, and ask and report through the Agent.
- **The Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: to read the Idea and its Docs, and create or update its SRD.
- **Resolver:** `~/.apiary/system/resolvers/<resolver>.md`, selected by each Source Reference's kind. Why: to read the Idea's source material as context.
- **The Idea and its Docs:** through the Ticket System Protocol File, using the input Idea ID. Why: to understand the PRD, find the SRD and TLA+ specs to revise, and ground changes in current requirements and supplied findings.
- **Engineering guidance:** `engineering-best-practices.md` for each explored repo, found as `workflow.md` describes. Why: to ground constraints in the Project's engineering conventions.
- **Test guidance:** `test-guide.md` for each explored repo, found as `workflow.md` describes. Why: to ground test requirements in the Project's test conventions.
- **Codebase and tests:** the affected code folders under `<Project Folder>`, identified from the PRD and Idea. Why: to establish the architecture, modules, patterns, data models, configuration and test infrastructure the requirements must fit.
- **TLA+ Writer definition:** the installed definition for the TLA+ Writer Subagent Role, located through the Agent Protocol File. Why: when a part needs modelling, to dispatch its model-writing and model-checking work.

## Gate

The Idea's PRD is `defined`, because the SRD builds on settled product requirements. If it isn't, stop and suggest req-review.

## Steps

1. **Gather the existing requirements.** Combine the Idea, its Source References, existing Docs and conversation with any review findings or change notes. Honour the Managing Intelligence's decisions on findings.

2. **Explore the affected code yourself.** Use the Codebase exploration guidance below, in proportion to the change.

3. **Settle the design decisions the SRD needs.** Resolve facts from the PRD, code and guidance.
   - If a design decision the SRD needs is still open, ask the Managing Intelligence.
   - If the Managing Intelligence leaves a necessary decision open, mark it **RESEARCH NEEDED** beside the affected requirement, save the unfinished SRD as `draft`, and stop.

4. **Write the SRD.** Organize it as the change needs, following the craft guidance below. Assess its concurrency, state machines, protocols and invariants. Select the parts whose correctness needs a model, including existing modelled parts affected by a revision.

5. **Save the SRD.** Save before modelling so each Writer can read the SRD Doc.
   - If the Idea has an SRD, update that Doc.
   - Otherwise, create it.
   - If the Idea has a `defined` or `active` Plan, set it back to `draft`, because the Plan must be reconsidered against the changed SRD. Tell the Managing Intelligence to pause any develop-epic or write-epic work now running: those Runs stop at their next Task, and anything built until then follows the old SRD.

6. **Model the selected parts.**
   - If parts need modelling, dispatch the TLA+ Writers as described in Dispatches. Fix SRD bugs the models find and save the corrected SRD. Re-dispatch for affected parts until the models agree with the corrected SRD and their checks pass. Take necessary design decisions back to step 3.
   - If no part needs modelling, continue to self-review.

7. **Review it yourself.** Read the whole draft once for each of the four checks below, one after another. If any check changed something, do all four again. Stop when a full round changes nothing. Do this for a first draft and a revision alike.
   - **Succinctness:** cut repetition and padding with no loss of signal.
     - Fold each review finding, model finding or change into the requirement it affects. Never append amendments, errata or a review-fixes section.
     - Cut text a change superseded, repeated text and padding.
     - Keep every current software requirement, invariant, acceptance criterion, supplied edge case and Managing Intelligence answer. One the Managing Intelligence withdrew or replaced is no longer current, so cut it.
     - Within the SRD, an acceptance criterion may restate the behaviour it checks, and a summary may restate what the body details. Nothing else repeats; refer to an existing SR when another group needs it.
   - **Requirements:** make every SR a verifiable software obligation grounded in the PRD and explored code, with implementation choices left to planning and execution.
   - **Dropped ideas:** remove every trace of ideas discussed and dropped. Keep an explicit boundary only when the Managing Intelligence wants it stated.
   - **Quality checklist:** check every item in the Quality checklist below, and fix what fails.

8. **Finish.**
   - If self-review changed a modelled part or found another part that needs a model, go back to step 5.
   - Otherwise, save the final SRD.

## Dispatches

Dispatch the **TLA+ Writer** once per selected SRD part, in parallel, through the Agent Protocol File.

Pass the Idea, PRD and SRD IDs; the assigned SR group IDs and modelling question; the relevant repos and checkout paths; any existing spec Doc ID for that part; and findings that prompted the dispatch.

## Writes

The SRD, a Doc child of the Idea titled `SRD`. A new SRD starts as `draft`, and a revised `defined` SRD goes back to `draft`.

The Idea's Plan, set back to `draft` when a revision changes an SRD it was built from.

The TLA+ Writers it dispatches write each modelled part's TLA+ spec Doc.

## Done

Report the SRD's ID, any **RESEARCH NEEDED** flags and incomplete work, and what the Succinctness pass cut. Report which parts were modelled, their spec Doc IDs and checker results, and the SRD bugs corrected from model findings, or why modelling was unnecessary. If you reset the Plan, list the Epics that were `active` and the SRs that changed, so write-plan knows what to reconsider.

- If the SRD and all selected modelling are complete, suggest “req-review, or, on a `draft` Idea, mark the Idea defined”.
- Otherwise, say what must be settled before write-srd can finish.

## Codebase exploration

- **Architecture:** identify the directory structure and module organization.
- **Affected modules:** identify the real files and modules the PRD touches across the Project's repos.
- **Existing patterns:** inspect how comparable features handle configuration, validation, errors and serialization where relevant to the requirements.
- **Data models:** inspect the definitions and constraints the feature extends.
- **Test fixtures:** identify test organization, helpers, factories and centralized constants.
- **Configuration:** trace how relevant configuration is loaded, validated and accessed.

If a capability the SRD needs doesn't exist yet, say it's new rather than implying it exists.

## Style rules

- **Group by concern:** group requirements by domain or concern, not by PRD section. Data model, configuration, interfaces, runtime behaviour, validation, behaviour to preserve and documentation are common groups; use those the change needs.
- **Numbered requirements:** number each requirement group and requirement (SR-1, SR-1.1), because TLA+ Writers, req-review and write-plan cite them by number.
- **Software requirements:** define what must be true, leaving the implementation plan open. Name actual modules and established patterns where they constrain the work.
- **Definitive wording:** write one clear, testable obligation per statement, in full sentences.
- **Grounded requirements:** derive obligations from current input and applicable guidance. Keep the SRD in proportion to the change.
- **No false precision:** use numeric limits only when the input states them, the Managing Intelligence confirms them, or an existing constraint that must be preserved establishes them. Keep model-checking bounds in the spec as modelling assumptions, rather than turning them into product limits.
- **Consistent terms:** use the PRD's defined terms in Title Case wherever they appear, with the same meanings. Explain additional terms at first use and use their defined names consistently.
- **Stable references:** name files and modules without line numbers. Other than test helpers and fixtures, requirements describe obligations rather than function calls.
- **Test fixtures:** say which existing fixtures, factories, helpers and constants tests must reuse, what they need to support this change, what new fixtures are needed and where, and which test files to extend or add. Ground it in the code and test guidance, say when nothing new is needed, and keep it in proportion to the change. This stops tests hand-rolling shared setup.

## Quality checklist

If an unresolved decision or unfinished model stops a check below from passing, say so in your report and mark that check incomplete.

- [ ] Every PRD acceptance criterion maps to at least one SR.
- [ ] Every SR states a specific, testable obligation grounded in current input or applicable guidance.
- [ ] The SRD agrees with the PRD and uses its defined terms consistently.
- [ ] Codebase references name real modules, patterns, fixtures and helpers, with additions clearly identified.
- [ ] The test requirements identify the relevant helpers, factories, constants, needed extensions and test locations.
- [ ] Requirements define what must be true and leave implementation steps open.
- [ ] Numeric constraints have a stated basis, and modelling bounds remain modelling assumptions.
- [ ] Each selected part has a checked TLA+ spec matching the final SRD, and model findings have been resolved.
- [ ] The document contains only current requirements and boundaries the Managing Intelligence wants stated.
- [ ] The document is free of source code, pseudocode and line numbers.

## What not to include

- Keep source code, function signatures and pseudocode out of the SRD; TLA+ models belong in their spec Docs.
- Leave function-call instructions, library choices, architectural proposals, design alternatives and step-by-step implementation plans to planning.
- The exceptions are constraints the input already requires, and the names of test helpers and fixtures.
- Include defaults, fallbacks, validation, schemas, error rules and guards only when grounded in the input or applicable guidance.
- Omit time estimates and scheduling.
- Omit history, decision logs and deferred work.
