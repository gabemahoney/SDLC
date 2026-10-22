# Cursor Agent Protocol File

## Prerequisites

Use Cursor CLI on Linux with an operator-configured login and launch template, because agent-director's Cursor support requires that host setup.

Check skills in `~/.cursor/skills/<skill>/SKILL.md` for a user installation or `<repo>/.cursor/skills/<skill>/SKILL.md` for a repository installation, and shared materials under `~/.apiary/`, so Cursor can load the same Apiary instructions as the other Agents.

## Context use

agent-director reports `context.fraction` as `null` for Cursor. As a Main Agent, skip your own context check; as a caller, start every Cursor Child Agent fresh, because no context reading is available to judge reuse.

## Launch template

Launch every Main Agent and Child Agent with the `CURSOR_WORKER` template, because it supplies the host's Cursor configuration.
