---
name: write-srd
description: "Write or revise an Idea's Software Requirements Document (SRD) from its PRD, codebase and recorded findings and change requests, with Formal Models for concurrency or state machines."
---

# write-srd

## Purpose

You follow write-prd and define what the software must do to meet the PRD. The SRD settles technology choices and architecture, contains no code, and feeds planning.

## Loading SDLC

Read `~/.sdlc/system/workflow.md` first for shared rules, settings and file locations.

## Input

An Idea ID.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** your Agent Protocol File (`protocol:agent-claude-code.md`, `protocol:agent-codex.md` or `protocol:agent-cursor.md`), `protocol:launcher.md` and the Ticket System Protocol File selected by `setting:ticket_system`, for operations.
- **Idea, its Docs and Plan:** for requirements, findings, change requests, existing models and affected Epics.
- **SRD leads:** the Idea's attached `srd-leads.md`, if any, for design leads from PRD review; settle each in the SRD, because the PRD leaves them open.
- **Guidance:** `guide:engineering-best-practices.md` for engineering constraints in each explored repo.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

The Idea's PRD is `defined`, because the SRD builds on the approved product requirements. If it isn't, stop and return it to the Managing Intelligence for approval.

## Steps

1. **Pause a Plan built from the SRD before revising it.** Set that Plan `draft`, including a completed Plan, because changed requirements need replanning. Record changed SRs and previously active Epics under `## SRD changes` on it as the revision proceeds. Tell the Managing Intelligence to pause running write-epic and develop-epic work; their Runs stop at the next Task boundary.

2. **Write the SRD** from the approved PRD and any existing code. Settle technology and architecture choices. Look up small questions yourself. For deeper research, save the SRD, then launch `research` with the question, the SRD's ID and any constraints, and associate the Research ticket it files with the SRD. You are its reviewer, judging each Report against `guide:research-guide.md`: answer its questions, tell it you accept the Report or send back what more to research, and take product questions to the Managing Intelligence. Launch independent questions in parallel.

3. **Model SR groups** where concurrency or a state machine hides ordering bugs that reading and tests can miss, including changed groups with existing models. Read `guide:build-commands.md`, found as `~/.sdlc/system/workflow.md` describes, for the language and checker in `guide:build-commands.md ## Model check`. If missing, ask the Managing Intelligence to supply it. Save the SRD first, so your Child Agents read the current requirements. For each group, independently and in parallel where possible:
   - Have `model-writer` write or update the Formal Model for that group and attach the files to its Model Doc.
   - Have `model-review` review it against the SRD before the checker runs, because checker runs can be slow. Judge findings under the shared rule and record repair instructions under `## Progress` on the Model Doc. Resume the writer for repairs, then review again.
   - Once accepted findings are fixed, resume the writer to run the checker and retain its results under `## Checks` on the Model Doc. Correct model errors through the same review cycle. If checking exposes an SRD bug, correct the requirements and repeat modelling, review and checking. The Managing Intelligence settles product questions because the PRD is approved.

4. **Review the whole draft** for succinctness, software obligations, dropped ideas and the Quality checklist, in that order. Repeat after changes until a full round changes nothing, so revisions receive the same scrutiny as a first draft.
   - Fold changes into the affected requirements. Cut superseded text and padding while preserving current SRs, invariants, acceptance criteria, supplied edge cases and Managing Intelligence decisions. Only acceptance criteria and summaries may repeat behaviour; otherwise reference the existing SR.
   - Make each SR a verifiable obligation grounded in the PRD and existing code.
   - Include a boundary from a dropped idea only if the Managing Intelligence wants it stated.

   Save the SRD, then return changed or newly modelled groups to step 3 so models cover the final requirements.

5. **Review the SRD with `req-review` once every model has been reviewed and its checker run has passed, and every Report you asked for is accepted.** Launch a fresh Child Agent each round so each review is independent. Take every conflict with `guide:engineering-best-practices.md`, `guide:doc-writing-guide.md` or `guide:test-guide.md` to the Managing Intelligence as a major finding, because only they may settle it. Judge other findings: fix them, decline minor findings with reasons, or take product questions to the Managing Intelligence. Return revisions through steps 3 and 4 so models cover the final requirements. Save revisions and repeat until a review returns nothing left to fix. Then hand the SRD to the Managing Intelligence for approval, reporting declined findings with their reasons.

## Child Agents

- **`req-review`:** Launch after writing or revising the SRD and passing its models, fresh every round so each review is independent. Expect findings with references and suggested fixes, or none.
- **`model-writer`:** Start fresh for each modelled SR group and reuse it for the write, fix and run cycle to preserve its knowledge of the model. Expect a Model Doc, checker results and any SRD bugs they show.
- **`model-review`:** Start fresh for each review in step 3 so each assessment is independent. Expect findings with references and suggested fixes, or none.
- **`research`:** Start fresh for each question needing real digging so its context stays focused on that question, and reuse it for that question's review rounds. Expect a cited answer in that Research ticket's Report.

## Writes

Record each approved guide exception once under `## Guide exceptions` on the PRD or SRD it concerns, stating the guide rule, what the spec does instead, why and the Managing Intelligence's approval, so later work preserves the decision.

- **SRD:** create or update the Idea's Doc titled `SRD`, set `draft` because new or revised requirements need approval. Use `## Requirements` for numbered SR groups and their Model Doc links, `## Technology and architecture` for choices, reasons and supporting Research links, and `## Declined findings` for declined or unaddressed review findings with reasons.
- **Plan:** reset to `draft` when revising the SRD it was built from, with changed SRs and previously active Epics recorded under `## SRD changes`.
- **Model Docs:** one per modelled SR group, maintained by `model-writer`. Keep model files attached to the Doc, outside repos, so they stay with requirements. Use `## Model` for the modelled SR group and Formal Model, `## Modelling assumptions` for bounds and assumptions, `## Artifacts` for file links, `## Progress` for repair instructions, `## Checks` for checker evidence and exposed SRD bugs, and `## Declined findings` for declined or unaddressed findings with reasons.
- **Research:** associate each Research ticket `research` files with the SRD.

## Done

Report the SRD's ID, its Model Doc and Research ticket IDs, and anything left unaddressed with the reason. If the Plan was reset, report its ID.

- If the SRD, modelling and review are complete, say the SRD remains `draft` and awaits the Managing Intelligence's approval. The Managing Intelligence sets it `defined` on approval.
- Otherwise, say what must be settled before you can finish.

## Style rules

- **Group by concern:** group requirements by domain or concern, not by PRD section. Data model, configuration, interfaces, runtime behaviour, validation, behaviour to preserve and documentation are common groups; use those the Idea needs.
- **Numbered requirements:** number each requirement group and requirement (SR-1, SR-1.1), because `model-writer` Child Agents, req-review and write-plan cite them by number.
- **Software requirements:** define what must be true. Name actual modules and established patterns where they constrain the work.
- **Linked models:** link each modelled SR group to its Model Doc so reviewers can find the Formal Model and checker results.
- **Code in poor shape:** where the code this Idea changes is in poor shape, decide whether delivering the Idea needs it refactored. If it does, state the refactor as a requirement with its reason. If it doesn't, it's work outside the Idea, as `~/.sdlc/system/workflow.md` describes.
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
- [ ] Each modelled SR group has a Formal Model that matches the final SRD and passes the checker named in `guide:build-commands.md ## Model check`.

## What not to include

- Leave out function signatures and step-by-step implementation plans.
- Keep each Formal Model in its Model Doc so the SRD stays focused on software requirements.
- Include defaults, fallbacks, validation, schemas, error rules and guards only when grounded in the input or applicable guidance.
- Omit time estimates and scheduling.
