---
name: write-srd
description: "Write or revise an Idea's Software Requirements Document (SRD) from its PRD and codebase, and model the parts that need TLA+."
---

# write-srd

## Purpose

Writes the SRD: what must be true about the software for the PRD to be satisfied. It follows write-prd and supplies grounded software requirements and any TLA+ models for req-review and planning.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

An Idea ID or its PRD Doc ID, with optional review findings, model findings or change notes for a revision.

## Reads

- **Workflow:** `~/.apiary/system/workflow.md`. Why: to follow the shared Run rules and Questions and stops.
- **Settings files:** `<Project Folder>/.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`. Why: to select the Ticket System Protocol File through `ticket_system` and, when dispatching, the TLA+ Writer's Thinking Level through `thinking_levels` and its model and effort through `levels_claude_code` or `levels_codex` for the running Agent.
- **Your Agent's Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` in Claude Code, or `~/.apiary/system/protocols/agent-codex.md` in Codex CLI. Why: to locate the installed TLA+ Writer definition, dispatch it, and ask and report through this Agent.
- **The Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: to read the Idea and its Docs, and create or update its SRD.
- **Source Reference instructions:** `~/.apiary/system/resolvers/<resolver>.md`, selected by each Source Reference's kind. Why: to read the Idea's source material as context.
- **The Idea and its Docs:** through the Ticket System Protocol File, using the input ID and its parent when given a PRD. Why: to understand the PRD, find the SRD and TLA+ specs to revise, and ground changes in current requirements and supplied findings.
- **Engineering guidance:** `.apiary/engineering-best-practices.md` copies found for each explored repo through the Guidance Documents rule in `workflow.md`, or `~/.apiary/engineering-best-practices-default-fallback.md`. Why: to ground constraints in the Project's engineering conventions.
- **Test guidance:** `.apiary/test-guide.md` copies found for each explored repo through the same rule, or `~/.apiary/test-guide-default-fallback.md`. Why: to ground the Test Fixtures section in the Project's test conventions. For a Project without repos, load both Guidance Documents from the working folder through that rule.
- **Codebase and tests:** the affected code folders under `<Project Folder>`, identified from the PRD and Idea. Why: to establish the architecture, modules, patterns, data models, configuration and test infrastructure the requirements must fit.
- **TLA+ Writer definition:** the installed definition for the TLA+ Writer Subagent Role, located through your Agent's Protocol File. Why: when a part needs modelling, to dispatch its model-writing and model-checking work with the inputs and Guidance Documents its definition requires.

## Gate

None: the SRD can be written or revised at any Idea status.

## Steps

1. **Gather the current requirements.** Read the Idea, its Source References and Docs, including the PRD's Glossary, Goals, requirements and acceptance criteria. Gather supplied findings and change notes with the Managing Intelligence's decisions on them.
   - If revising, then establish the current requirements from that material and apply actionable findings. Honour declined findings and withdrawn requirements throughout the Run.

2. **Explore the affected code yourself.** Load the engineering and test Guidance Documents, then explore the affected code folders using the Codebase exploration guidance below. Gather concrete references for the requirements and Test Fixtures section, in proportion to the change.

3. **Settle the design decisions the SRD needs.** Resolve facts from the PRD, code and guidance.
   - If a necessary design decision remains that those sources cannot settle, then stop and ask the Managing Intelligence: which behaviour or constraint should the SRD require? Follow `workflow.md`'s Questions and stops, explaining the decision and its consequences.
   - If the Managing Intelligence explicitly leaves a necessary decision open, then mark it **RESEARCH NEEDED** beside the affected requirement, save the unfinished SRD as `draft` following Writes, and stop with the affected work reported as incomplete.
   - If the needed decisions are settled, then continue with the draft.

4. **Write and save the SRD.** Write it yourself using the section template and craft guidance below. Assess its concurrency, state machines, protocols and invariants, and select the parts whose correctness needs a model, including existing modelled parts affected by a revision. Complete `workflow.md`'s prerequisite checks for the selected dispatches before saving through the Ticket System Protocol File.
   - If the Idea has an SRD, then update that Doc; a revised `defined` SRD returns to `draft`, and a `draft` SRD stays `draft`.
   - If the Idea has no SRD, then create a Doc child of the Idea titled `SRD`, with status `draft`.

5. **Model the selected parts.** Use the saved SRD as the source for modelling.
   - If parts need modelling, then dispatch one TLA+ Writer per part in parallel as described in Dispatches. Read each report and spec, fix SRD bugs the models find, and save the corrected SRD. Re-dispatch for affected parts until the models agree with the corrected SRD and their checks pass. Route any necessary design decision back through step 3.
   - If no part needs modelling, then continue to self-review and report why modelling was unnecessary.

6. **Review and finish the SRD yourself.** Read the whole draft once for each of the four checks below, one after another. If any check changed something, do all four again. Stop when a full round changes nothing. Do this for a first draft and a revision alike.
   - **Succinctness:** cut repetition and padding with no loss of signal.
     - Fold each review finding, model finding or change into the requirement it affects. Never append amendments, errata or a review-fixes section.
     - Cut text a change superseded, repeated text and padding.
     - Keep every current software requirement, invariant, acceptance criterion, supplied edge case and Managing Intelligence answer. One the Managing Intelligence withdrew or replaced is no longer current, so cut it.
     - Within the SRD, an acceptance criterion may restate the behaviour it checks, and a summary may restate what the body details. Nothing else repeats; refer to an existing SR when another group needs it.
   - **Requirements:** make every SR a verifiable software obligation grounded in the PRD and explored code, with implementation choices left to planning and execution.
   - **Current requirements:** remove every trace of dropped ideas and fold settled questions into the body. Keep an explicit boundary only when the Managing Intelligence wants it stated.
   - **Quality checklist:** check every item below and fix what fails.

   - If self-review changes requirements covered by a model or reveals another part needing one, then repeat steps 4–6, checking dispatch prerequisites before saving the revised SRD.
   - If self-review leaves no modelling work to do, then save the final SRD in the same Doc with status `draft`.

## Dispatches

Dispatch the **TLA+ Writer** once per selected SRD part, in parallel, through the Agent Protocol File. Read its installed definition at the location that Protocol File supplies. Use the `TLA+ Writer` line in `thinking_levels`, mapped through the running Agent's `levels_claude_code` or `levels_codex`, following `workflow.md`'s dispatch rules.

Pass the Idea, PRD and SRD IDs; the assigned SR group IDs and modelling question; the relevant repos and checkout paths; any existing spec Doc ID for that part; and findings that prompted the dispatch. Include the resolved settings and Protocol Files as `workflow.md` requires. Each Writer models its assigned part, runs the Model check command from the `build-commands.md` Guidance Document its definition loads, and returns the spec Doc ID, checker results and SRD findings. Revisiting a part updates its existing spec.

## Writes

The Idea's Doc titled `SRD` in the Ideas store is created `draft` or updated in place, with a revised `defined` SRD set back to `draft`.

The dispatched TLA+ Writer creates a TLA+ spec Doc `defined` for each modelled SRD part, or updates that part's existing spec and leaves it `defined`.

## Done

Report the SRD's ID, each SR group's one-line description, any **RESEARCH NEEDED** flags and incomplete work, and what the Succinctness pass cut. Report which parts were modelled, their spec Doc IDs and checker results, and the SRD bugs corrected from model findings, or why modelling was unnecessary.

- If work is incomplete, then report what must be resolved before write-srd can finish.
- If the SRD and all selected modelling are complete, then suggest “req-review, or, on a `draft` Idea, mark the Idea defined”.

## Codebase exploration

Before drafting, understand what is being built, which components it affects, the supplied error scenarios and the acceptance criteria. Explore the relevant code yourself:

- **Architecture:** identify the directory structure and module organization.
- **Affected modules:** identify the real files and modules the PRD touches across the Project's repos.
- **Existing patterns:** inspect how comparable features handle configuration, validation, errors and serialization where relevant to the requirements.
- **Data models:** inspect the definitions and constraints the feature extends.
- **Test fixtures:** identify test organization, helpers, factories and centralized constants.
- **Configuration:** trace how relevant configuration is loaded, validated and accessed.

Ground references in what exists. Describe required new capabilities as new, and size exploration to the change.

## SRD section template

Organize requirements by domain or concern, rather than by PRD section. Use numbered SR groups and subsections, with one clear requirement per statement.

```markdown
# [Feature or Project Name] Software Requirements

## Glossary
Use the PRD's Glossary terms consistently. Define additional software terms only
when this SRD gives them a particular meaning, and write them in Title Case.

## SR-1: [Domain Name]

### SR-1.1: [Specific Concern]
State what must be true about the software, including the applicable constraints.

### SR-1.2: [Another Concern]
State the next distinct, verifiable obligation.

## SR-N: Test Fixtures
Describe the test infrastructure and the additions this feature requires,
following the Test Fixtures guidance below.
```

Derive the groups from the PRD. Common concerns include the following; include those the change needs:

- **Data Model:** state the required fields, types, constraints, serialization and affected entities.
- **Configuration:** state required schema changes, validation and resolution behaviour.
- **API / Commands:** state required interfaces, parameters, results and availability.
- **Execution / Processing:** state runtime behaviour, lifecycle and process-management constraints.
- **Validation / Linting:** state required checks and their integration with existing validation.
- **Existing Behaviour:** state the behaviour the input requires preserving.
- **Documentation:** state which documentation the feature requires after implementation.

## Test Fixtures

Every SRD includes this section, sized to the feature and grounded in the code and test guidance. An implementor should know which helpers and fixtures to use and where tests belong.

1. Identify where relevant fixtures, helpers, constants and test documentation live.
2. Name the existing factories and fixtures tests must reuse, following established conventions instead of hardcoding shared setup and values.
3. Specify the capabilities and parameters existing helpers need to support the feature.
4. Identify required new fixtures and where they belong.
5. Identify existing test files to extend and any new test files needed.

Describe the needed infrastructure where it does not yet exist, distinguishing required additions from existing helpers. State when a category needs no additions.

## Style rules

- **Software requirements:** define what must be true, leaving the implementation plan open. Name actual modules and established patterns where they constrain the work.
- **Definitive wording:** write one clear, testable obligation per statement, in full sentences. Mark genuinely unresolved decisions **RESEARCH NEEDED** instead of presenting competing requirements.
- **Grounded requirements:** derive obligations from current input and applicable guidance. Keep the SRD in proportion to the change.
- **No false precision:** use numeric limits only when the input states them, the Managing Intelligence confirms them, or an existing constraint that must be preserved establishes them. Keep model-checking bounds in the spec as modelling assumptions, rather than turning them into product limits.
- **Consistent terms:** use the PRD's Glossary terms in Title Case wherever they appear, with the same meanings. Explain additional terms at first use and use their defined names consistently.
- **Stable references:** name files and modules without line numbers. Test helper and fixture names belong in Test Fixtures; other requirements describe obligations rather than function calls.
- **Current requirements:** state requirements as they now stand and fold answered questions into the relevant statements.

## Quality checklist

Before finishing, check the following. Report checks affected by explicitly unresolved decisions or unfinished modelling as incomplete.

- [ ] Every PRD acceptance criterion maps to at least one SR.
- [ ] Every SR states a specific, testable obligation grounded in current input or applicable guidance.
- [ ] The SRD agrees with the PRD and uses its Glossary consistently.
- [ ] Codebase references name real modules, patterns, fixtures and helpers, with additions clearly identified.
- [ ] Test Fixtures identifies the relevant helpers, factories, constants, needed extensions and test locations.
- [ ] Requirements define what must be true and leave implementation steps open.
- [ ] Numeric constraints have a stated basis, and modelling bounds remain modelling assumptions.
- [ ] Each selected part has a checked TLA+ spec matching the final SRD, and model findings have been resolved.
- [ ] The document contains only current requirements and boundaries the Managing Intelligence wants stated.
- [ ] The document is free of source code, pseudocode and line numbers.

## What not to include

- Keep source code, function signatures and pseudocode out of the SRD; TLA+ models belong in their spec Docs.
- Leave function-call instructions, library choices, architectural proposals, design alternatives and step-by-step implementation plans to implementation planning, except for constraints the input already requires and the Test Fixtures guidance above.
- Include defaults, fallbacks, validation, schemas, error rules and guards only when grounded in the input or applicable guidance.
- Omit invented numbers, time estimates and scheduling.
- Omit rejected alternatives, withdrawn requirements, history, decision logs and deferred work.
