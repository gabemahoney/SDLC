# Codex Agent Protocol File

## Context use

Your context fraction is the latest `token_count` event's `last_token_usage.total_tokens` in your session's rollout file, divided by its `model_context_window`. If you can't tell, treat it as unknown, never zero.

## Launch template

Launch every Main Agent and Child Agent with the `CODEX_WORKER` template, because it sets the agent's sandbox and permissions.
