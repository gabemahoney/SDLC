# Claude Code Agent Protocol File

This is an example Agent Protocol File. Its other sections are still to be written.

## Context use

For the main session, read the latest `statusLine` payload matching its `session_id`. Its context fraction is `context_window.used_percentage / 100`. This measures input, including cached input. If no matching reading is available, the fraction is unknown.

Before resuming a retained Subagent, read its latest completed round:

- Keep its actual Agent ID, parent session ID and transcript path with the ticket's executor record so the reading belongs to the right Subagent. Transcripts live at `~/.claude/projects/{project}/{sessionId}/subagents/agent-{agentId}.jsonl`. `SubagentStop` supplies `agent_id` and `agent_transcript_path`; its `transcript_path` is the parent's file.
- From the active history after the latest compaction, take the latest valid assistant usage: `input_tokens + cache_creation_input_tokens + cache_read_input_tokens + output_tokens`. Count each category once because cached input still occupies context. For multi-iteration usage, use the last ordinary `message` or `fallback_message` iteration, excluding advisor and compaction iterations.
- A matching completed round's `subagent_tokens` is an alternative estimate. Use that round's count alone, because adding rounds measures accumulated usage rather than context.
- Obtain the Subagent's context window from its own model, provider and session data. A configured `subagentStatusLine` collector can retain `tasks[]` entries' `id`, `model`, `tokenCount` and `contextWindowSize`, keyed by parent session and child ID. Collect the window while the entry is visible so it remains available after completion. These collectors must be configured before their readings are available.
- Divide the latest context tokens by that Subagent's applicable context window to get its context fraction.

For either reading, use the window that applies to that Agent's current model, provider and session, including any tighter context cap. Match the token count and window's accounting basis. Keep the source and configuration with the reading so a later turn, compaction or configuration change can be detected. Missing usage or capacity, an unchecked default, incompatible accounting or unresolved history means unknown, never zero.

Resume an idle retained Subagent with `SendMessage(to=<actual-agent-id>, message=<ticket to read>)`, following the exposed tool schema. Start a fresh Subagent with a new `Agent` call and no retained ID or history. Supply the ticket, Role, checkout, settings, Protocol Files and Thinking Level so it can start from recorded progress. Resolve an uncertain send before replacing the Subagent so two executors do not work on the same assignment.
