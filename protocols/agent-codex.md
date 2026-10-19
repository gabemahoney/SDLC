# Codex Agent Protocol File

## Context use

**TBD:** agent-director will report each agent's context use (AD Idea b.17w). Until it does, there's no reading, so skip the context checks rather than treating the fraction as unknown, which would stop every Run.

## Launch template

Launch every Main Agent and Child Agent with the `CODEX_WORKER` template, because it sets the agent's sandbox and permissions.
