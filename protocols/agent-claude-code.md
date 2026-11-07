# Claude Code Agent Protocol File

## Prerequisites

Check skills in `~/.claude/skills/<skill>/SKILL.md` for a user installation or `<repo>/.claude/skills/<skill>/SKILL.md` for a repository installation, and shared materials under `~/.sdlc/`, so Claude Code can load the same SDLC instructions as the other Agents.

## Context use

**TBD:** agent-director will report each agent's context use. Until it does, no reading exists: a Main Agent skips its own check, and a Child Agent's reading counts as unknown, so it's always started fresh instead of reused.

## Launch template

Launch each Main Agent and Child Agent with the `template` its resolved `setting:levels` entry names, or `WORKER` when it names none, because the template sets the agent's sandbox and permissions.

## Blocking waits

As a Main Agent, run your watch on Child Agents, such as the command `setting:child_watch_command` names, with the Bash tool's `run_in_background`, because a foreground run hits the Bash timeout; you're re-invoked when it exits. Keep each wait one plain command, because Claude Code asks permission for shell constructs such as `declare -A` or braces with quotes. Between fallback checks, run a separate `sleep`, such as `sleep 30`, the same way, so the checks don't busy-poll. As any Agent, run every other blocking wait, such as the one `guide:build-commands.md` names for a scheduler job, in the foreground with a Bash `timeout` longer than the wait's own, not the 2-minute default, because ending your turn shows you as `waiting` and whoever watches you returns early; rerun it only when it prints `timeout`.
