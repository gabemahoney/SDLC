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

## Reads
Every file and setting it uses, with its full path or the setting that picks it, including any templates. Each one says why the skill needs it.

## Gate
What must be true before it changes anything, or "None: <why>".

## Steps
The work, in numbered order: what to do, not how a capable Agent would do it. Put each deliberate stop at its step as "stop and ask the Managing Intelligence: …". List only stops the design chose; never generic "ask when unsure".

## Dispatches
Each Subagent Role it starts, when, and what it passes, or "None".

## Writes
Each ticket or file it creates or changes: which store or path, and which status (the transitions it owns).

## Done
What it reports, and the next-step suggestion.
```

Rules for writing a skill:
- No logic specific to one template, intake, resolver, ticket system, Launcher or Agent: say 'follow the …' and put the specifics in that file.
- State what a skill does and takes; don't list what it doesn't.
- Write a step that branches as if/then bullets, one per path. Write straight-line steps as plain sentences.
- Quote the `description` value: an unquoted colon breaks the frontmatter.
- Everything specific to this skill is in the skill. Rules more than one skill needs are in `workflow.md`; do not repeat them.
- Say exactly where everything is: full paths, and how a setting value maps to a file.
- Capable Agents: no edge cases, no fault handling a capable Agent does anyway.
- No random subsets: list every case or state a general rule.
- Glossary terms in Title Case.
