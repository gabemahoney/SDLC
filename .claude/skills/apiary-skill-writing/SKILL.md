---
name: apiary-skill-writing
description: "Use when writing, revising or reviewing an Apiary skill, workflow.md, Protocol File, Default Fallback File or other Apiary doc."
---

# apiary-skill-writing

You use these rules for work on Apiary itself. This project skill is not installed for Projects.

## Keep what matters

- Start from today's skill, absorbed agent instructions, approved decisions and [product goals](../../../docs/goals.md), because older drafts may describe a superseded design.
- Keep proven workflow, ownership, outcomes and guards against likely harm, because capable agents need consequential rules rather than craft tutorials, rare edge cases or routine recovery instructions.
- State current requirements and confirmed limits; allow judgement for qualitative needs, because rejected options, future work and invented precision become unintended scope.

## Write plainly

- Use short, complete sentences, clear subjects and concrete verbs; rewrite unclear paragraphs around their purpose, because brevity must preserve meaning.
- Give each rule its reason in the same sentence, so you can apply it with judgement.
- Address the reader as “you”; use Main Agent, Child Agent and Glossary terms consistently and define novel terms before use, so responsibilities and concepts stay clear.

## Give each rule one home

- Put skill-specific gates and transitions in the skill, shared workflow in workflow.md, craft in Guidance Documents and configuration logic in templates or Protocol Files, because repeated rules drift.
- Reference those homes and follow the selected template's structure, so the skill works with the Project's configuration.

## Name the reading

- Use `setting:<name>`, `guide:<file>` and `protocol:<file>`, with ` ## <Section>` inside the same backticks when needed, or full paths for fixed files, so references resolve consistently.
- Identify selected files by their setting or resolved protocol reference; read Guidance Documents from the main checkout, so you use the intended configuration and guidance.
- Give mandatory sources a skill-specific purpose and separate conditional reading, so each Run loads what it needs.

## Make handoffs explicit

- Use ticket IDs as inputs and keep findings, decisions, progress and handoffs on affected tickets, so later agents have one durable record.
- Make writers and readers agree and derive checks from stated requirements, so handoffs add no hidden obligations.
- Use the Gate, Writes and Done contracts in the Template below, so prerequisites, output ownership and next steps are explicit.

## Delegate with ownership

- Delegate for independence, scale or parallel work using the Child Agents contract below, so each launch has a purpose and lifecycle.
- Give parallel writers distinct files and return revisions to the original planner, so work avoids conflicts and retains planning context.
- Make Main Agents own combined checks and executors own targeted checks, so validation has an owner at each level.

## Review with judgement

- Review against the main brief, approved intent, Guidance Documents and actual files, because a child document or finding alone can misrepresent the work.
- Classify findings as blocker (wrong), suggestion (fragile or confusing) or nit (style), so the Main Agent can weigh consequences.
- Have the Main Agent fix accepted findings, record reasons for declining minor findings and refer product decisions or requirements conflicts to the Managing Intelligence with a recommendation, so decision authority stays clear.
- Read the revision cold, compare it with the previous version, run the Checklist and trim after each round, so useful meaning survives without repetition.
- Stop at trivial findings or cuts that would lose information, because reviews can always produce another wording change.

## Checklist

Check each applicable section above and the Template below before reporting, so review covers the rules without maintaining a second copy.

- [ ] Keep what matters: preservation, scope and current requirements.
- [ ] Write plainly: meaning, reasons and terminology.
- [ ] Give each rule one home: ownership, references and selected structure.
- [ ] Name the reading: notation, selection, checkout and purpose.
- [ ] Make handoffs explicit: ticket record, writer/reader agreement and contracts.
- [ ] Delegate with ownership: purpose, lifecycle, files, revisions and checks.
- [ ] Review with judgement: evidence, severity, authority, revision and stopping.
- [ ] Template: section order, unused sections and applicable Child Agent contract.

## Template

Use this shape for workflow skills, keeping core sections in order and writing “None: <why>” for unused sections, so readers can find each contract. Add sections for ticket bodies, review judgement or integration gates where needed, so skill-specific contracts have a home.

```markdown
---
name: <skill>
description: "<What you do and the input you take.>"
---

# <skill>

## Purpose

You <deliver this outcome at this point in the workflow>.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

<Ticket IDs, or creation input for a setup or intake skill.>

## Required Reading

- **<Name>:** <reference>, for <purpose>.

<One closing line for reading needed as the work requires.>

## Gate

Run only when <input ticket and necessary prerequisite states>, because <reason>.
Otherwise, <response to failure>.

## Steps

1. **<Outcome>.** <Work and reason.>

## Child Agents

- **`<skill>`:** <Launch timing and expected result. Fresh or reused, scope and reason.>

## Writes

- **<Ticket or file>:** <Store or path, contents, owned status changes, decision owner and reason. Define ticket bodies in their writing skills.>

## Done

Report <ticket IDs and unresolved work with reasons>.
Suggest <next step>.
```

For a Child Agent, open Required Reading with these sources, so it knows its assignment and reporting relationship:

```markdown
- **Launcher:** `protocol:launcher.md`, for how you work as a Child Agent and report to your Main Agent.
- **Protocols:** `protocol:ticket.md` and your supplied Agent Protocol File, for ticket operations and Agent rules.
- **Your <assigned ticket>:** it holds everything you need to do.
```

Use its assigned ticket's allowed states in Gate and this Done form, so the Main Agent receives the handoff:

```markdown
Report the ticket IDs, unresolved work with reasons, any questions and the next step to your Main Agent as `protocol:launcher.md` describes.
```
