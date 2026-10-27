# Claude Code Agent Protocol File

## Context use

**TBD:** agent-director will report each agent's context use (AD Idea b.17w). Until it does, no reading exists: a Main Agent skips its own check, and a Child Agent's reading counts as unknown, so it's always started fresh instead of reused.

## Launch template

Launch every Main Agent and Child Agent with the `WORKER` template, because it sets the agent's sandbox and permissions.

## Blocking waits

Run blocking waits, such as the command `setting:child_watch_command` names, with the Bash tool's `run_in_background`, because a foreground run hits the Bash timeout; you're re-invoked when it exits. Keep each wait one plain command, because Claude Code asks permission for shell constructs such as `declare -A` or braces with quotes. Between fallback checks, run a separate `sleep`, such as `sleep 30`, the same way, so the checks don't busy-poll.
