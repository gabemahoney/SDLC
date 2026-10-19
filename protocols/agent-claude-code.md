# Claude Code Agent Protocol File

## Context use

**TBD:** agent-director will report each agent's context use (AD Idea b.17w). Until it does, no reading exists: a Main Agent skips its own check, and a Child Agent's reading counts as unknown, so it's always started fresh instead of reused.

## Launch template

Launch every Main Agent and Child Agent with the `WORKER` template, because it sets the agent's sandbox and permissions.
