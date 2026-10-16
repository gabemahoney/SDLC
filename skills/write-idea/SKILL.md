---
name: write-idea
description: File an Idea from a description of the work or intake input such as an issue URL, using the Project's new_idea_intake setting.
---

# write-idea

Files an Idea. Input: a description of the work, or intake input such as an issue URL.

## Loading Apiary

You are running inside Apiary. Read `~/.apiary/system/workflow.md` and follow it. Then load, from `~/.apiary/system/protocols/`, your Agent's Protocol File (`agent-claude-code.md` in Claude Code, `agent-codex.md` in Codex CLI) and the Ticket System and Launcher Protocol Files this Run requires, as your settings choose.

As a Subagent, use the settings and Protocol Files your dispatch prompt names; look nothing up yourself.

After a compaction, before going on, re-read `workflow.md`, the Protocol Files you loaded and your Guidance Documents.

## Gate

Check the creation input.

## Owned transition

write-idea creates `draft`.

## Filing the Idea

Read the `new_idea_intake` setting from the Project Folder's `.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. It names how this Project files Ideas: interview the Managing Intelligence, or a source reference resolver such as `github`. Follow it:
- When it names a source reference resolver, store the input as the Idea's source reference.
- When it says to interview the Managing Intelligence, do so and write the description in the Idea's body.

File the Idea and print its ID. Next step: "write-prd".
