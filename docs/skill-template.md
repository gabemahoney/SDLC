# Skill template

Every `SKILL.md` uses these sections, in this order. Every section is required; when one does not apply, write "None: <why>".

```
---
name: <skill>
description: "<one line: what it does and its input>"
---

# <skill>

## Purpose
One or two lines: what this skill does and where it sits in the flow.

## Loading Apiary
You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input
What it is given.

## Required Reading
Every file and setting it uses, with its full path or the setting that picks it, including any templates. Each one says why the skill needs it. List only what every Run reads. Code, tests and Research tickets read as the work needs go in one closing line: "Also read the Project's code, tests and any linked Research tickets as the work needs."

## Gate
What must be true before it changes anything, or "None: <why>". A skill for a Child Agent requires that it runs for a Main Agent, because that parent owns the assignment.

## Steps
The work, in a few numbered steps: what to do, not how a capable Agent would do it. Name a stop for the Managing Intelligence's decision only where the design needs one.

## Child Agents
For each Child Agent skill, say when to launch it and what result to expect. State whether it starts fresh every time or is reused, with the scope of reuse and a short reason, so its lifecycle is clear. If none are needed, write "None: <why>".

## Writes
Each ticket or file it creates or changes: which store or path, and which status (the transitions it owns).

## Done
What it reports, and the next-step suggestion.

## <Craft guidance, if any>
Sections carried over from today's skill that make its output good, e.g. a document template, style rules, a quality checklist, or what not to include. Keep them.
```

Rules for writing a skill (see also docs/goals.md):
- Start from today's Apiary skill and keep its proven guidance; change only what docs/goals.md requires.
- No logic specific to one template, intake, resolver, ticket system, Launcher or Agent: say 'follow the …' and put the specifics in that file.
- State what a skill does and takes; don't list what it doesn't.
- Write a step that branches as if/then bullets, one per path. Write straight-line steps as plain sentences.
- Quote the `description` value: an unquoted colon breaks the frontmatter.
- Everything specific to this skill is in the skill. Rules more than one skill needs are in `~/.apiary/system/workflow.md`; do not repeat them.
- Say exactly where everything is: full paths, and how a setting value maps to a file.
- Use `setting:<name>`, `guide:<file>`, `guide:<file> ## <Section>`, `protocol:<file>` and `protocol:<file> ## <Section>`, each in one pair of backticks; use full paths for files with one fixed place, so an Agent knows how to find each reference.
- Capable Agents: no edge cases, no fault handling a capable Agent does anyway.
- No random subsets: list every case or state a general rule.
- Glossary terms in Title Case. Skill names use their installed names.
- A skill that launches Child Agents lists `protocol:launcher.md` in Required Reading, for operations and Child Agent context readings. The Agent Protocol File covers the Main Agent's own context. Shared Context rules belong in `~/.apiary/system/workflow.md`; retain only skill-specific check timing here.
