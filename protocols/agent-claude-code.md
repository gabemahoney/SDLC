# Claude Code Agent Protocol File

## Skills

Invoke an installed skill as `/<skill> <ticket-id>`. User skills live at `~/.claude/skills/<skill>/SKILL.md`; a repository install uses `<repo>/.claude/skills/<skill>/SKILL.md`. Main Agents and Child Agents use the same skill format, so each skill has one set of instructions.

## Context use

Read the latest `statusLine` payload matching the session's `session_id`. Its context fraction is `context_window.used_percentage / 100`. This measures input, including cached input. A status-line collector must already be configured to retain that payload.

For a session-file estimate, use the transcript path recorded for this session, normally `~/.claude/projects/{project}/{sessionId}.jsonl` (under `CLAUDE_CONFIG_DIR` when configured). Match its session ID. On the active history after the latest compaction, take the latest valid assistant usage:

```text
used = input_tokens + cache_creation_input_tokens + cache_read_input_tokens + output_tokens
context_fraction = used / capacity
```

Count each category once because cached input still occupies context. For multi-iteration usage, use the last ordinary `message` or `fallback_message` iteration, excluding advisor and compaction iterations. Use the current session's effective context window from its model, provider and session data, including any tighter cap. A transcript usage count alone does not establish capacity.

Keep the reading's source, history position and configuration so later turns, compaction or configuration changes can be detected. Match the token count and capacity's accounting basis; the transcript estimate includes output, while the status-line percentage measures input. Missing usage or capacity, an unchecked default, incompatible accounting or unresolved history means unknown, never zero.

## Launch template

Launch every Main Agent and Child Agent with the `WORKER` template, because it sets the agent's sandbox and permissions.
