---
name: write-srd
description: "Write or revise an Idea's Software Requirements Document (SRD) from its PRD and codebase, and model in TLA+ any requirements with concurrency or a state machine."
---

# write-srd

## Purpose

Follows write-prd and defines what the software must do to meet the PRD. The SRD settles technology choices and architecture, contains no code, and feeds req-review and planning.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

An Idea ID, with optional review findings or change notes for a revision.

## Required Reading

- **Workflow:** `~/.apiary/system/workflow.md`. Why: to follow the shared Run rules.
- **Settings files:** `<Project Folder>/.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`. Why: to select the Ticket System Protocol File through `ticket_system`, and the TLA+ Writer's, TLA+ Reviewer's and Researcher's Thinking Levels through `thinking_levels` and `levels_claude_code` or `levels_codex`.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` in Claude Code, or `~/.apiary/system/protocols/agent-codex.md` in Codex CLI. Why: to dispatch Subagents and ask and report through the Agent.
- **The Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: to read and write the SRD, Plan and Research tickets and read their supporting Docs and Reports.
- **Resolver:** `~/.apiary/system/resolvers/<resolver>.md`, selected by each Source Reference's kind. Why: to read the Idea's source material as context.
- **The Idea, its Docs and Plan:** through the Ticket System Protocol File, using the input Idea ID. Why: to understand the PRD, find the SRD and TLA+ specs to revise, ground changes in current requirements and supplied findings, and identify the Plan and active Epics affected by a revision.
- **Engineering guidance:** `engineering-best-practices.md` for each explored repo, found as `workflow.md` describes. Why: to ground constraints in the Project's engineering conventions.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

The Idea's PRD is `defined`, because the SRD builds on the approved product requirements. If it isn't, stop and suggest req-review.

## Steps

1. **If you're revising an SRD that a Plan was built from, pause that Plan.** If the Idea has a `defined` or `active` Plan, set it back to `draft`, because the Plan must be reconsidered once the SRD changes, and note on the Plan which SRs changed and which Epics were `active`, so write-plan knows what to revise. Tell the Managing Intelligence to pause any develop-epic or write-epic work now running: those Runs stop at their next Task, and anything built until then follows the SRD as it was.

2. **Write the SRD from the PRD and any existing code.** Make the software, technology and architecture decisions yourself. For a question that needs real digging, file a Research ticket, dispatch a Researcher and link the ticket from the SRD. Look up small things yourself. Save the SRD before dispatching any Subagent, so it can read the SRD.

3. **Model in TLA+ only what needs it.** Model an SR group when it has concurrency (things happening at the same time, retries, partial failure) or a state machine, because those hide ordering bugs that reading and tests miss. Include already-modelled groups a revision changed. Most SRDs need neither, so skip this step. The checker is slow, so each model is reviewed before it runs. For each picked SR group, in parallel:
   1. **Write.** Dispatch a TLA+ Writer with the SR group and what to model. It writes the model as a TLA+ spec Doc on the Idea, with the model files attached to that Doc, and doesn't run it yet.
   2. **Review.** Dispatch a fresh TLA+ Reviewer with the spec and the SRD. It reports whether the model matches the SRD and its invariants are meaningful.
   3. **Fix.** If there are findings, resume the same Writer with them, then go back to 2 with a fresh Reviewer.
   4. **Run.** Once a review has no findings, resume the Writer to run the TLA+ model checker. It returns the checker results and any SRD bugs they show.
   5. **Fix the SRD.** If the run shows an SRD bug, fix the SRD, save it, and repeat from 3 for that SR group, giving the Writer the SRD change.

4. **Review it yourself.** Read the whole draft once for each of the four checks below, one after another. If any check changed something, do all four again. Stop when a full round changes nothing. Do this for a first draft and a revision alike.
   - **Succinctness:** cut repetition and padding with no loss of signal.
     - Fold each accepted finding or change into the requirement it affects. Never append amendments, errata or a review-fixes section.
     - Cut text a change superseded, repeated text and padding.
     - Keep every current software requirement, invariant, acceptance criterion, supplied edge case and Managing Intelligence answer. One the Managing Intelligence withdrew or replaced is no longer current, so cut it.
     - Within the SRD, an acceptance criterion may restate the behaviour it checks, and a summary may restate what the body details. Nothing else repeats; refer to an existing SR when another group needs it.
   - **Requirements:** make every SR a verifiable software obligation grounded in the PRD and any existing code.
   - **Dropped ideas:** remove every trace of ideas discussed and dropped. Keep an explicit boundary only when the Managing Intelligence wants it stated.
   - **Quality checklist:** check every item in the Quality checklist below, and fix what fails.

   If self-review changed a modelled SR group or found another that needs a model, go back to step 3. Otherwise, save the final SRD.

## Dispatches

- **TLA+ Writer:** one per modelled SR group, kept for that group's whole cycle (write, fix, run), as step 3 says. Expect a TLA+ spec Doc; after a run, the checker results and any SRD bugs they show.
- **TLA+ Reviewer:** a fresh one for each review in step 3. Expect findings with references and suggested fixes, or none.
- **Researcher:** launch one per question needing real digging, in parallel. Expect a cited answer in that Research ticket's Report. Use it to settle the decision, then set the ticket `done`.

## Writes

The SRD, a Doc child of the Idea titled `SRD`. A new SRD starts as `draft`, and a revised `defined` SRD goes back to `draft`.

The Idea's Plan, set back to `draft` when a revision changes an SRD it was built from.

Each modelled SR group's TLA+ spec Doc, a Doc child of the Idea with the model files attached, written by its TLA+ Writer.

Research tickets in the Research store, filed `defined` with the question; the Researcher writes each one's Report, and write-srd sets the ticket `done` once it uses the answer. They skip the research skill's review rounds.

## Done

Report the SRD's ID, each SR group with a one-line description, any incomplete work, and what the Succinctness pass cut. Report which SR groups were modelled, their spec Doc IDs, TLA+ review findings and checker results, and the SRD bugs corrected from model findings, or why modelling was unnecessary. If you reset the Plan, list the Epics that were `active` and the SRs that changed, so write-plan knows what to reconsider.

Report the Research tickets filed and what each settled.

- If the SRD and all its modelling are complete, suggest “req-review”.
- Otherwise, say what must be settled before write-srd can finish.

## Style rules

- **Group by concern:** group requirements by domain or concern, not by PRD section. Data model, configuration, interfaces, runtime behaviour, validation, behaviour to preserve and documentation are common groups; use those the change needs.
- **Numbered requirements:** number each requirement group and requirement (SR-1, SR-1.1), because TLA+ Writers, req-review and write-plan cite them by number.
- **Software requirements:** define what must be true. Name actual modules and established patterns where they constrain the work.
- **Linked models:** link each modelled SR group to its TLA+ spec Doc.
- **Technology and architecture:** state each choice the SRD makes, with its reason in a sentence, and link the Research ticket if one informed it.
- **Definitive wording:** write one clear, testable obligation per statement, in full sentences.
- **Grounded requirements:** derive obligations from current input and applicable guidance. Keep the SRD in proportion to the change. If a capability the SRD needs doesn't exist yet, say it's new rather than implying it exists.
- **No false precision:** use numeric limits only when the input states them, the Managing Intelligence confirms them, or an existing constraint that must be preserved establishes them. Keep model-checking bounds in the spec as modelling assumptions, rather than turning them into product limits.
- **Consistent terms:** use the PRD's defined terms in Title Case wherever they appear, with the same meanings. Explain additional terms at first use and use their defined names consistently.
- **Stable references:** you may name code files and modules, but never line numbers or code, because those change far more often than the requirements. Pseudocode is fine where it makes a requirement clearer.

## Quality checklist

If an unresolved decision or unfinished model stops a check below from passing, say so in your report and mark that check incomplete.

- [ ] The SRD covers every PRD acceptance criterion.
- [ ] Every SR states a specific, testable obligation grounded in current input or applicable guidance.
- [ ] The SRD agrees with the PRD and uses its defined terms consistently.
- [ ] References to existing code name real modules and patterns, and anything new is marked as new.
- [ ] Numeric constraints have a stated basis, and modelling bounds remain modelling assumptions.
- [ ] Each modelled SR group has a TLA+ spec that matches the final SRD and passes the model checker.

## What not to include

- Leave out function signatures and step-by-step implementation plans.
- Put TLA+ models in their spec Docs, not in the SRD.
- Include defaults, fallbacks, validation, schemas, error rules and guards only when grounded in the input or applicable guidance.
- Omit time estimates and scheduling.
- Omit history, decision logs and deferred work.
