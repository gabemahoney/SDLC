---
name: write-srd
description: "Write or revise an Idea's Software Requirements Document (SRD) from its PRD, codebase and recorded findings and change requests, with Formal Models for concurrency or state machines."
---

# write-srd

## Purpose

Follows write-prd and defines what the software must do to meet the PRD. The SRD settles technology choices and architecture, contains no code, and feeds req-review and planning.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

An Idea ID.

## Required Reading

- **Settings:** Project and default settings, resolved as `workflow.md` describes, for this Run's configuration.
- **Agent Protocol File:** `agent-claude-code.md` or `agent-codex.md` under `~/.apiary/system/protocols/`, for context readings and skill invocation.
- **Launcher Protocol File:** `launcher.md`, selected as `workflow.md` describes, for Child Agent operations.
- **Ticket System Protocol File:** selected by `ticket_system` as `workflow.md` describes, to read and write the SRD, Plan and Research tickets and read their supporting Docs and Reports.
- **The Idea, its Docs and Plan:** to understand the PRD, read accepted findings on the SRD and the Managing Intelligence's change requests on the Idea or SRD, find Model Docs to revise, and identify the Plan and active Epics affected by a revision.
- **Engineering guidance:** `engineering-best-practices.md` for each explored repo, found as `workflow.md` describes, to ground constraints in the Project's engineering conventions.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

The Idea's PRD is `defined`, because the SRD builds on the approved product requirements. If it isn't, stop and suggest req-review.

## Steps

1. **Pause a Plan built from the SRD before revising it.** Set that Plan `draft`, including a completed Plan, because changed requirements need replanning. Record changed SRs and previously active Epics on it as the revision proceeds. Tell the Managing Intelligence to pause running write-epic and develop-epic work; their Runs stop at the next Task boundary.

2. **Write the SRD** from the approved PRD and any existing code. Settle technology and architecture choices. Look up small questions yourself. For deeper research, read `research-guide.md`, found as `workflow.md` describes, file a question at `research_location` and associate it with the SRD. Save the SRD before launching `researcher` so it reads the current requirements.

3. **Model SR groups** where concurrency or a state machine hides ordering bugs that reading and tests can miss, including changed groups with existing models. Read `build-commands.md`, found as `workflow.md` describes, for the language and checker in `## Model check`. If missing, ask the Managing Intelligence to supply it. For each group, independently and in parallel where possible:
   - Have `model-writer` write or update its Formal Model and attach the files to its Model Doc.
   - Have a fresh `model-review` check it against the SRD before running the checker, because checker runs can be slow. Judge findings under the shared rule and record repairs on the Model Doc. Resume the writer for repairs, then review again.
   - Once accepted findings are fixed, resume the writer to run the checker and retain its results on the Model Doc. Correct model errors through the same review cycle. If checking exposes an SRD bug, correct the requirements and repeat modelling, review and checking. The Managing Intelligence settles product questions because the PRD is approved.

4. **Review the whole draft** for succinctness, software obligations, dropped ideas and the Quality checklist, in that order. Repeat after changes until a full round changes nothing, so revisions receive the same scrutiny as a first draft.
   - Fold changes into the affected requirements. Cut superseded text and padding while preserving current SRs, invariants, acceptance criteria, supplied edge cases and Managing Intelligence decisions. Only acceptance criteria and summaries may repeat behaviour; otherwise reference the existing SR.
   - Make each SR a verifiable obligation grounded in the PRD and existing code.
   - Include a boundary from a dropped idea only if the Managing Intelligence wants it stated.

   Return changed or newly modelled groups to step 3 so models cover the final requirements, then save the SRD.

## Dispatches

- **`model-writer`:** Launch for each modelled SR group. Retain it for the group's write, fix and run cycle under the shared Context rule. Expect a Model Doc, checker results and any SRD bugs they show.
- **`model-review`:** Launch fresh for each review in step 3. Expect findings with references and suggested fixes, or none.
- **`researcher`:** Launch one per question needing real digging, in parallel. Expect a cited answer in that Research ticket's Report.

## Writes

- **SRD:** create or update the Idea's Doc titled `SRD`, set `draft` because new or revised requirements need approval.
- **Plan:** reset to `draft` when revising the SRD it was built from, with changed SRs and previously active Epics recorded.
- **Model Docs:** one per modelled SR group, maintained by `model-writer`. Keep model files attached to the Doc, outside repos, so they stay with requirements. Record repair instructions, checker evidence and outstanding findings there.
- **Research:** file questions `defined` at `research_location` and associate them with the SRD. The researcher writes each Report `defined`; set the ticket `done` after using the answer. These questions skip research's review rounds because req-review checks the SRD decisions they inform.

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
