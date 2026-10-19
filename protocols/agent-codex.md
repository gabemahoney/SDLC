# Codex Agent Protocol File

## Launch template

Launch every Main Agent and Child Agent with the `CODEX_WORKER` template, because it sets the agent's sandbox and permissions.

## Skills

Invoke an installed skill as `$<skill> <ticket-id>`. User skills live at `~/.agents/skills/<skill>/SKILL.md`; a repository install uses `<repo>/.agents/skills/<skill>/SKILL.md`. Main Agents and Child Agents use the same skill format, so each skill has one set of instructions.

## Context use

Find the session's rollout under `$CODEX_HOME/sessions` (normally `~/.codex/sessions`) by matching `session_meta.payload.id` to its session ID. Use the recorded transcript path when available.

Read the latest complete `event_msg` whose `payload.type` is `token_count`, with non-null `info`, on the active history after the latest compaction:

```text
used = payload.info.last_token_usage.total_tokens
capacity = payload.info.model_context_window
context_fraction = used / capacity
```

Use `last_token_usage`, because `info.total_token_usage` accumulates usage across requests. Cached input and reasoning output are already included in the total. A captured app-server `thread/tokenUsage/updated` reading for the same thread is another source.

Validate the window against this session's model, provider and configuration, including any tighter context cap. Match the token count and window's accounting basis, retaining any reported reduction to the usable window. Keep the source, history position and configuration with the reading so later instructions, tool results, compaction or configuration changes can be accounted for. Missing usage, nonpositive capacity, an unchecked window default, incompatible accounting, incomplete writes or unresolved history means unknown, never zero.
