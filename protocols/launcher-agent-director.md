# agent-director Launcher Protocol File

Select this file with `setting:launcher` set to `agent-director`. It installs as `~/.apiary/system/protocols/launcher-agent-director.md` and is the `protocol:launcher.md` that skills refer to.

## Prerequisites

Use agent-director with working hooks for each chosen Agent, tmux, the Agent's installed skills and access to the assigned checkouts and ticket system. Run `agent-director version` and `agent-director --help` to check the installed commands. Run lifecycle commands as the same user and on the same tmux server as the agents, because another server cannot establish their liveness.

Choose an agent-director template for the selected Agent and assignment from `~/.config/agent-director/templates/<name>.toml`. The template supplies the approved permissions and environment. Record its name on the ticket so a resumed Run uses the same launch configuration. Resolve Thinking Levels as described below.

## Launch a Main Agent

The Managing Intelligence assigns one skill and its ticket IDs to a new Main Agent. configure-worktree may carry out that recorded assignment on its behalf. Start a fresh session with `agent-director spawn`, selecting `--template`, `--agent` and `--cwd`. Pass the skill invocation as one prompt argument after `--`, along with the model and effort arguments described below. Fresh launches use no continuation arguments so they start with fresh context.

Record the returned `instance_id` on the ticket. Use `get` and `status` to confirm the launch and read its `session_id` and `jsonl_path` when available. A pending row has not yet reported in; inspect it before trying another launch, because a timeout can leave an agent running.

## Launch a Child Agent

Run `spawn` from the Main Agent's environment. agent-director records the caller's `AGENT_DIRECTOR_INSTANCE_ID` as the new row's `parent_id`, and gives the Child Agent its own instance ID. Verify that `get` returns the intended Main Agent ID as `parent_id`, so the Child Agent remains attached to its parent.

Use the same spawn arguments as for a Main Agent, with the Child Agent's assignment and launch context from `~/.apiary/system/workflow.md`. Record its instance ID, skill, assignment and Thinking Level on the ticket for continuation.

## Model and Thinking Level at launch

Resolve the model and effort from `setting:thinking_levels` and the chosen Agent's `setting:levels_claude_code` or `setting:levels_codex` mapping. Apply Task or Bug overrides before resolving that mapping. Model and effort are launch arguments, so the same skill can run in either Agent.

Claude Code example, with placeholders filled from the assignment and settings:

```sh
agent-director spawn --template '<chosen-template>' --agent claude --cwd '<checkout>' -- --model '<model>' --effort '<effort>' '/engineer <ticket-id>'
```

Codex example:

```sh
agent-director spawn --template '<chosen-template>' --agent codex --cwd '<checkout>' -- --model '<model>' -c 'model_reasoning_effort="<effort>"' '$engineer <ticket-id>'
```

Replace `engineer` with the assigned skill and include its launch context in the same prompt. Quote the Codex prompt so the shell preserves `$`. Arguments after `--` replace the template's `agent_args`, so carry forward any required Agent arguments from that template when adding model, effort and prompt.

## Resume a Child Agent

Read its recorded identity and current state with `get`, then apply `~/.apiary/system/workflow.md`'s reused Child Agent Context rule using the reading below. Continue an idle `waiting` Child Agent with:

```sh
agent-director send-keys --instance-id '<child-id>' --text 'Continue from <ticket-id>.'
```

This starts the next turn in the existing session. The ticket holds the repair instructions. If the session has ended and its process is confirmed gone, `agent-director resume --instance-id '<child-id>'` reopens its recorded session; inspect its state and pane before sending the continuation. A resumed Codex session may stay `pending` until its first prompt; after reading its pane and confirming it is ready for input, send that continuation with `send-keys --allow-pending`. Run `resume` from the Main Agent's environment, because it records the current caller as the parent.

When a fresh replacement is needed, resolve any uncertain delivery and stop the old assignment first, because a timed-out send may have arrived. Launch a fresh Child Agent with the same skill and ticket IDs and record its new identity.

## Read a Child Agent's context

Get its `session_id`, `jsonl_path` and Agent with `agent-director get --instance-id '<child-id>'`. Confirm `parent_id` and match the session file's identity, because a parent's context says nothing about its child.

### Claude Code

Read the latest retained `statusLine` payload matching the child's `session_id`. Its context fraction is `context_window.used_percentage / 100`, which measures input including cached input. A status-line collector must already be configured to retain that payload.

For a transcript estimate, use the child's recorded `jsonl_path`, normally `~/.claude/projects/{project}/{sessionId}.jsonl` (under `CLAUDE_CONFIG_DIR` when configured). On the active history after the latest compaction, take the latest valid assistant usage:

```text
used = input_tokens + cache_creation_input_tokens + cache_read_input_tokens + output_tokens
context_fraction = used / capacity
```

Count each category once because cached input occupies context. For multi-iteration usage, use the last ordinary `message` or `fallback_message` iteration, excluding advisor and compaction iterations. Establish capacity from the child's model, provider and session data, including any tighter cap; a transcript usage count alone does not establish capacity.

### Codex

Use the child's recorded `jsonl_path`, or find its rollout under `$CODEX_HOME/sessions` (normally `~/.codex/sessions`) by matching `session_meta.payload.id` to its `session_id`. Read the latest complete `event_msg` with `payload.type` of `token_count` and non-null `info` on the active history after the latest compaction:

```text
used = payload.info.last_token_usage.total_tokens
capacity = payload.info.model_context_window
context_fraction = used / capacity
```

Use `last_token_usage` because `total_token_usage` accumulates across requests. Cached input and reasoning output are already included. A captured app-server `thread/tokenUsage/updated` reading for the same thread is another source. Validate capacity against the child's model, provider and configuration, including any tighter cap and reported reduction to the usable window.

### Validate the reading

Retain the child's session identity, source, history position, model, provider and capacity basis so later turns, compaction or configuration changes can be accounted for. Match usage and capacity accounting: Claude Code's status-line percentage measures input, while its transcript estimate includes output. Missing identity or usage, nonpositive capacity, an unchecked capacity default, incompatible accounting, incomplete writes or unresolved history means unknown, never zero. `~/.apiary/system/workflow.md` decides whether to resume or replace.

## Know when a Child Agent's state changes

agent-director provides no automatic notification. After launch or resume, poll `agent-director status --instance-id '<child-id>'` every few seconds while work is outstanding, including when the Main Agent has no other work. Inspect `get` and `read-pane` when the state changes so a completed or blocked Child Agent does not wait unnoticed.

- `pending`: launch has not reported in. Follow the pending grace and inspection instructions in `agent-director --help` before sending input or retrying a launch.
- `working`: the turn is running.
- `waiting`: read the result; the turn may have completed, asked a question or stopped unfinished.
- `ask_user` or `check_permission`: inspect the request. Relay decisions needing the Managing Intelligence; use `decide` for an open relayed permission request as `--help` describes.
- `ended` or `missing`: inspect the result and verify process exit before replacement or cleanup, because a row state alone does not prove exit.

Continue watching after any resumption.

## Watch and collect results

Use `status --instance-id '<id>'` for state, `get --instance-id '<id>'` for the full record and `read-pane --instance-id '<id>' --lines 80` for output. `list --parent '<main-id>'` finds a Main Agent's Child Agents.

Use the state handling above for both classes. Read results from the recorded tickets and pane.

A fresh Main Agent may continue a retained Child Agent only after the old Main Agent has stopped using it. Stop the idle Child Agent with `pause`, verify exit, then `resume` it from the new Main Agent's environment to update `parent_id`. Verify that relationship with `get` before sending work, so continuation belongs to the current Main Agent.

## Stop a Child Agent

For an idle Child Agent, use `agent-director pause --instance-id '<id>'`. Verify exit before replacing it or removing its worktree. To stop a live Child Agent, use `agent-director kill --instance-id '<id>'` and check the result; `kill` does not itself change the row's state.

Follow the live-row sequence in `agent-director --help`: allow a pending launch its grace period, then run `find-missing` and check `status`, about five seconds apart, at most three times. If still live, try `kill` once more, wait and reconcile once more, then report the unresolved stop. An error or a `missing` row alone is not proof of exit, so retain the worktree while liveness is unresolved. A session conflict needs the Managing Intelligence's decision because the session may belong to someone else.

## Stop a Main Agent

Use the same pause, exit verification and live-row stop procedure for a Main Agent. Before ending its assignment or deleting its worktrees, inspect its Child Agents with `list --parent` and stop any still using those worktrees. Stopping the Main Agent alone does not stop its children.
