---
name: write-idea
description: File an Idea from a description of the work or intake input such as an issue URL, using the Project's new_idea_intake setting.
---

# write-idea

Files an Idea. Input: a description of the work, or intake input such as an issue URL.

## Loading Apiary

You are running inside Apiary. Identify your Agent:
- Claude Code: your rules are in `~/.claude/skills/apiary/`.
- Codex CLI: your rules are in `~/.agents/skills/apiary/`.

In that folder, read `workflow.md` and follow it. Then load the Protocol Files it names from `protocols/`: your Agent's (`agent-claude-code.md` or `agent-codex.md`), and the Ticket System and Launcher ones your settings choose.

As a Subagent, use the settings and Protocol Files your dispatch prompt names; look nothing up yourself.

After a compaction, before going on, re-read `workflow.md`, the Protocol Files you loaded and your Guidance Documents.

## Filing the Idea

Follow the `new_idea_intake` setting:
- When it names a source reference resolver, store the input as the Idea's source reference.
- When it says to interview the Managing Intelligence, do so and write the description in the Idea's body.

File the Idea and print its ID. Next step: "write-prd".
