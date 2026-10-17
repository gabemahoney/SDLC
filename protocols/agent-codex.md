# Codex Agent Protocol File

This is an example Agent Protocol File. Its other sections are still to be written.

## Context use

For the main session, find its rollout under `$CODEX_HOME/sessions` (normally `~/.codex/sessions`) by matching `session_meta.payload.id` to its session ID.

Before resuming a retained Subagent, find its rollout in the same directory. Match `session_meta.payload.id` and `source.subagent.thread_spawn.parent_thread_id`; use `agent_path` to resolve a canonical target when needed. Keep the actual thread ID and canonical target with the ticket's executor record so the reading belongs to the right Subagent.

For either session, read the latest complete `event_msg` whose `payload.type` is `token_count`, with non-null `info`, on the active history after the latest compaction:

```text
used = payload.info.last_token_usage.total_tokens
capacity = payload.info.model_context_window
context_fraction = used / capacity
```

Use `last_token_usage`, because `info.total_token_usage` accumulates usage across requests. Cached input and reasoning output are already included in the total. A captured app-server `thread/tokenUsage/updated` reading for the same thread is another source.

Validate the window against that Agent's own model, provider and session data, including any tighter context cap. Match the token count and window's accounting basis, retaining any reported reduction to the usable window. Keep the source and configuration with the reading so later instructions, tool results, compaction or configuration changes can be accounted for. Missing usage, nonpositive capacity, an unchecked window default, incompatible accounting, incomplete writes or unresolved history means unknown, never zero.

Resume an idle retained Subagent with `followup_task(target=<retained-child>, message=<ticket to read>)`; `send_message` alone does not start an idle turn. With the alternate tool family, use `send_input`, reopening a closed child with `resume_agent` if exposed. Follow the tools available in the session.

Start a fresh Subagent with `spawn_agent` and `fork_turns="none"`, because the default inherits the parent's history. Supply the ticket, Role, checkout, settings, Protocol Files and Thinking Level so it can start from recorded progress. Resolve an uncertain send before replacing the Subagent so two executors do not work on the same assignment.
