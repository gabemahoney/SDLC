# Codex Agent Protocol File

## Prerequisites

Check skills in `~/.agents/skills/<skill>/SKILL.md` for a user installation or `<repo>/.agents/skills/<skill>/SKILL.md` for a repository installation, and shared materials under `~/.sdlc/`, so Codex can load the same SDLC instructions as the other Agents.

## Context use

**TBD:** agent-director will report each agent's context use (AD Idea b.17w). Until it does, no reading exists: a Main Agent skips its own check, and a Child Agent's reading counts as unknown, so it's always started fresh instead of reused.

## Launch template

Launch each Main Agent and Child Agent with the `template` its resolved `setting:levels` entry names, or `CODEX_WORKER` when it names none, because the template sets the agent's sandbox and permissions.

## Blocking waits

Run blocking waits, such as the command `setting:child_watch_command` names, with `exec_command`. While it returns a `session_id`, the command is still running, so poll that session with `write_stdin` and empty `chars` until it returns an exit code, because Codex hands a long command back mid-run and never wakes a turn that has ended. Between fallback checks, run a separate `sleep`, such as `sleep 30`, the same way, so the checks don't busy-poll. Run every other blocking wait, such as the one `guide:build-commands.md` names for a scheduler job, polling its session with `write_stdin` without ending your turn, because ending it shows you as `waiting` and whoever watches you returns early; rerun it only when it prints `timeout`.
