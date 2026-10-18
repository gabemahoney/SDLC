# Skill template

Use [the writing guide](skill-writing-guide.md) for the rules and [the checklist](skill-review-checklist.md) to review the result. The core sections below appear in this order; an unused section says “None: <why>”.

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

Run only when <ticket and prerequisite conditions>, because <reason>.
Otherwise, <response>.

## Steps

1. **<Outcome>.** <Work and reason.>

## Child Agents

- **`<skill>`:** <When to launch and expected result. Fresh or reused, scope and reason.>

## Writes

- **<Ticket or file>:** <Store or path, contents, owned status changes, who decides and why.>

## Done

Report <ticket ID and unaddressed work with reasons>.
Suggest <next step>.
```

For a Child Agent, Required Reading opens with:

```markdown
- **Launcher:** `protocol:launcher.md`, for how you work as a Child Agent and report to your Main Agent.
- **Protocols:** `protocol:ticket.md` and your supplied Agent Protocol File, for ticket operations and Agent rules.
- **Your <assigned ticket>:** it holds everything you need to do.
```

Its Gate names the assigned ticket's allowed states. Its Done takes this form:

```markdown
Report the ticket IDs, unresolved work with reasons, any questions and the next step to your Main Agent as `protocol:launcher.md` describes.
```

Add sections for skill-specific workflow contracts when needed: ticket body shapes, review judgement or an integration gate. Craft is referenced through Guidance Documents.
