---
name: write-srd
description: "Write or revise an Idea's Software Requirements Document (SRD) from its PRD, codebase and recorded findings and change requests, with Formal Models for concurrency or state machines."
---

# write-srd

## Purpose

Follows write-prd and defines what the software must do to meet the PRD. The SRD settles technology choices and architecture, contains no code, and feeds req-review and planning.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

An Idea ID.

## Required Reading

- **Workflow:** `~/.apiary/system/workflow.md`. Why: to follow the shared Run rules.
- **Settings files:** `<Project Folder>/.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`. Why: `ticket_system` and `launcher` select the Protocol Files; `thinking_levels` and `levels_claude_code` or `levels_codex` set the launched skills' model and effort. `research_location` locates Research when needed.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` in Claude Code, or `~/.apiary/system/protocols/agent-codex.md` in Codex CLI. Why: to check this Main Agent's context and ask and report through the Agent.
- **Launcher Protocol File:** `launcher.md`, selected by `launcher` as `workflow.md` describes. Why: to launch, resume and watch Child Agents, keep their parent relationship and read their context before reuse.
- **The Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: to read and write the SRD, Plan and Research tickets and read their supporting Docs and Reports.
- **Resolver:** `~/.apiary/system/resolvers/<resolver>.md`, selected by each Source Reference's kind. Why: to read the Idea's source material as context.
- **The Idea, its Docs and Plan:** through the Ticket System Protocol File, using the input Idea ID. Why: to understand the PRD, read accepted findings on the SRD and the Managing Intelligence's change requests on the Idea or SRD, find Model Docs to revise, and identify the Plan and active Epics affected by a revision.
- **Engineering guidance:** `engineering-best-practices.md` for each explored repo, found as `workflow.md` describes. Why: to ground constraints in the Project's engineering conventions.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

The Idea's PRD is `defined`, because the SRD builds on the approved product requirements. If it isn't, stop and suggest req-review.

## Steps

1. **If you're revising an SRD that a Plan was built from, pause that Plan.** If the Idea has a `defined` or `active` Plan, set it back to `draft`, because the Plan must be reconsidered once the SRD changes, and note on the Plan which SRs changed and which Epics were `active`, so write-plan knows what to revise. Tell the Managing Intelligence to pause any develop-epic or write-epic work now running: those Runs stop at their next Task, and anything built until then follows the SRD as it was.

2. **Write the SRD from the PRD and any existing code.** Make the software, technology and architecture decisions yourself. For a question that needs real digging, read `research-guide.md`, found as `workflow.md` describes, so the investigation follows the Project's guidance. File a Research ticket at `research_location`, launch a Child Agent with the researcher skill as `launcher.md` describes and link the ticket from the SRD. Look up small things yourself. Save the SRD before launching any Child Agent, so it can read the SRD.

3. **Write Formal Models where they help.** Model an SR group when concurrency (things happening at the same time, retries, partial failure) or a state machine hides ordering bugs that reading and tests can miss. Include already-modelled groups a revision changed. Skip modelling when no group needs it. For groups that do, read `build-commands.md`, found as `workflow.md` describes, and use the language and checker command in `## Model check`. If that section is missing, stop and ask the Managing Intelligence, because the Project must supply the modelling language and a way to check the model. Review each Formal Model before model checking, because checker runs can be slow. For each chosen SR group, in parallel:
   1. **Write.** Launch a Child Agent with the model-writer skill, as `launcher.md` describes, using the SRD ID and assigned SR group. It writes a Formal Model in the language named by `## Model check` and attaches its files to a Model Doc under the Idea so the model stays with its requirements.
   2. **Review.** Launch a fresh Child Agent with the model-review skill, as `launcher.md` describes, using the Model Doc and SRD IDs so the check is independent of the writer's reasoning. Judge each finding and turn accepted ones into repair instructions on the Model Doc so the writer can act on them. Record only declined or unaddressed findings, each with its reason, so later review sees what remains.
   3. **Fix.** If repairs are needed, resume the same writer to carry them out, then return to step 2 so a fresh reviewer checks the changed model.
   4. **Run.** Once accepted review findings are fixed, resume the writer to run the `## Model check` command. Keep its results on the Model Doc as evidence. Have the writer fix model errors and repeat the review and model checking so the Formal Model passes before this work finishes.
   5. **Fix the SRD.** If the checker exposes an SRD bug, correct and save the requirements, then have the writer update the model and repeat its review and run so both agree. Product questions go to the Managing Intelligence, because the SRD follows the approved PRD.

4. **Review it yourself.** Read the whole draft once for each of the four checks below, one after another. If any check changed something, do all four again. Stop when a full round changes nothing. Do this for a first draft and a revision alike.
   - **Succinctness:** cut repetition and padding with no loss of signal.
     - Fold each accepted finding or change into the requirement it affects. Never append amendments, errata or a review-fixes section, so later skills find one current account of the requirements.
     - Cut text a change superseded, repeated text and padding.
     - Keep every current software requirement, invariant, acceptance criterion, supplied edge case and Managing Intelligence answer. One the Managing Intelligence withdrew or replaced is no longer current, so cut it.
     - Within the SRD, an acceptance criterion may restate the behaviour it checks, and a summary may restate what the body details. Nothing else repeats; refer to an existing SR when another group needs it.
   - **Requirements:** make every SR a verifiable software obligation grounded in the PRD and any existing code.
   - **Dropped ideas:** remove every trace of ideas discussed and dropped. Keep an explicit boundary only when the Managing Intelligence wants it stated.
   - **Quality checklist:** check every item in the Quality checklist below, and fix what fails.

   If self-review changes a modelled SR group or finds another that needs a model, return to step 3 so the models cover the final requirements. Otherwise, save the SRD. Keep only declined or unaddressed findings on its Doc ticket, each with its reason, so req-review sees what remains.

## Child Agents

- **`model-writer`:** Launch a Child Agent with the model-writer skill, as `launcher.md` describes, for each modelled SR group. Retain it for the group's write, fix and run cycle under the shared Context rule. Expect a Model Doc, checker results and any SRD bugs they show.
- **`model-review`:** Launch a Child Agent with the model-review skill, as `launcher.md` describes, fresh for each review in step 3. Expect findings with references and suggested fixes, or none.
- **`researcher`:** Launch a Child Agent with the researcher skill, as `launcher.md` describes, one per question needing real digging, in parallel. Expect a cited answer in that Research ticket's Report. Use it to settle the decision, then set the ticket `done`.

## Writes

The SRD is a Doc child of the Idea titled `SRD`. Apply accepted fixes to its requirements and keep only declined or unaddressed findings on the Doc ticket, each with its reason, so req-review sees the current requirements and what remains. A new or revised SRD is `draft` because it needs approval.

The Idea's Plan, set back to `draft` when a revision changes an SRD it was built from.

Each modelled SR group has a Model Doc under the Idea, with the Formal Model's files written and attached by its `model-writer`. The Doc holds repair instructions and checker results so work can resume from the evidence. Its finding record contains only declined or unaddressed findings, each with its reason, so later review sees what remains.

Research tickets at `research_location`, filed `defined` with the question; the `researcher` writes each one's Report, and write-srd sets the ticket `done` once it uses the answer. They skip the research skill's review rounds, because req-review checks the SRD decisions they inform.

## Done

Report the SRD's ID, its Model Doc and Research ticket IDs, and anything left unaddressed with the reason. If the Plan was reset, report its ID.

- If the SRD and all its modelling are complete, suggest “req-review”.
- Otherwise, say what must be settled before write-srd can finish.

## Style rules

- **Group by concern:** group requirements by domain or concern, not by PRD section. Data model, configuration, interfaces, runtime behaviour, validation, behaviour to preserve and documentation are common groups; use those the Idea needs.
- **Numbered requirements:** number each requirement group and requirement (SR-1, SR-1.1), because `model-writer` Child Agents, req-review and write-plan cite them by number.
- **Software requirements:** define what must be true. Name actual modules and established patterns where they constrain the work.
- **Linked models:** link each modelled SR group to its Model Doc so reviewers can find the Formal Model and checker results.
- **Code in poor shape:** where the code this Idea changes is in poor shape, decide whether delivering the Idea needs it refactored. If it does, state the refactor as a requirement with its reason. If it doesn't, it's work outside the Idea, as `workflow.md` describes.
- **Technology and architecture:** state each choice the SRD makes, with its reason in a sentence, and link the Research ticket if one informed it.
- **Definitive wording:** write one clear, testable obligation per statement, in full sentences.
- **Grounded requirements:** derive obligations from current input and applicable guidance. Keep the SRD in proportion to the Idea. If a capability the SRD needs doesn't exist yet, say it's new rather than implying it exists.
- **No false precision:** use numeric limits only when the input states them, the Managing Intelligence confirms them, or an existing constraint that must be preserved establishes them. Keep bounds used for model checking in the Model Doc as modelling assumptions, so they do not become product limits.
- **Consistent terms:** use the PRD's defined terms in Title Case wherever they appear, with the same meanings. Explain additional terms at first use and use their defined names consistently.
- **Stable references:** you may name code files and modules, but never line numbers or code, because those change far more often than the requirements. Pseudocode is fine where it makes a requirement clearer.

## Quality checklist

If an unresolved decision or unfinished model stops a check below from passing, say so in your report and mark that check incomplete.

- [ ] The SRD covers every PRD acceptance criterion.
- [ ] Every SR states a specific, testable obligation grounded in current input or applicable guidance.
- [ ] The SRD agrees with the PRD and uses its defined terms consistently.
- [ ] References to existing code name real modules and patterns, and anything new is marked as new.
- [ ] Numeric constraints have a stated basis, and modelling bounds remain modelling assumptions.
- [ ] Each modelled SR group has a Formal Model that matches the final SRD and passes the checker named in `## Model check`.

## What not to include

- Leave out function signatures and step-by-step implementation plans.
- Keep each Formal Model in its Model Doc so the SRD stays focused on software requirements.
- Include defaults, fallbacks, validation, schemas, error rules and guards only when grounded in the input or applicable guidance.
- Omit time estimates and scheduling.
- Keep the requirements body about the software to build. Put reasons for declined or unaddressed findings on the Doc ticket so later Runs can assess what remains.
