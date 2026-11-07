# Cursor Agent Protocol File

## Prerequisites

Use Cursor CLI 2026.10.08 or later on Linux with an operator-configured login and launch templates, because agent-director's Cursor support and `## Blocking waits` require that host setup.

Check skills in `~/.cursor/skills/<skill>/SKILL.md` for a user installation or `<repo>/.cursor/skills/<skill>/SKILL.md` for a repository installation, and shared materials under `~/.sdlc/`, so Cursor can load the same SDLC instructions as the other Agents.

## Models

Choose Cursor models from `cursor-agent --list-models`, because model availability depends on the account.

## Modes

Leave mode unset in `setting:levels`, so a model alone uses agent-director's normal `agent` mode, because Task and Bug tags can reach any level and its other modes, `plan` and `ask`, are read-only. Where a mode is set, write `mode: <mode>` in that level's entry.

## Subagents

Don't use Cursor's built-in subagents (its Task tool), because agent-director's Cursor gateway rejects them and cancels your turn; launch only the Child Agents your skill names, through `protocol:launcher.md`.

## Context use

agent-director reports `context.fraction` as `null` for Cursor. As a Main Agent, skip your own context check; as a caller, start every Cursor Child Agent fresh, because no context reading is available to judge reuse.

## Launch template

Launch each Main Agent and Child Agent with the `template` its resolved `setting:levels` entry names, or `CURSOR_WORKER` when it names none, because the template supplies the host's Cursor configuration.

## Blocking waits

While Child Agents are outstanding, keep your turn open: run the watch that `protocol:launcher.md ## Knowing when a Child Agent's state changes` describes as a watched background shell that prints a unique marker when it returns, and watch for that marker, because Cursor resumes an open turn on a watched marker but never wakes an ended one. Then inspect the child and watch again. Between fallback checks, run a separate `sleep`, such as `sleep 30`, the same way, so the checks don't busy-poll. Run every other blocking wait, such as the one `guide:build-commands.md` names for a scheduler job, the same way with your turn open, because ending your turn shows you as `waiting` and whoever watches you returns early; rerun it only when it prints `timeout`, not because Cursor backgrounded it.
