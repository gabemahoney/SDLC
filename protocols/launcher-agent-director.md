# agent-director Launcher Protocol File

Select this file with `launcher: agent-director`. It installs as `~/.apiary/system/protocols/launcher-agent-director.md` and is the `launcher.md` that skills refer to.

## Prerequisites

Use agent-director with working hooks for each chosen Agent, tmux, the Agent's installed skills and access to the assigned checkouts and ticket system. Run `agent-director version` and `agent-director --help` to check the installed commands. Run lifecycle commands as the same user and on the same tmux server as the agents, because another server cannot establish their liveness.

Choose an agent-director template for the selected Agent and assignment from `~/.config/agent-director/templates/<name>.toml`. The template supplies the approved permissions and environment. Record its name on the ticket so a resumed Run uses the same launch configuration. The caller resolves the skill's Thinking Level through the Project settings before launch, including a Task or Bug tag override as `workflow.md` describes.

## Launch a Main Agent

The Managing Intelligence assigns one skill and its ticket IDs to a new Main Agent. configure-worktree may carry out that recorded assignment on its behalf. Start a fresh session with `agent-director spawn`, selecting `--template`, `--agent` and `--cwd`. Pass the skill invocation as one prompt argument after `--`, along with the model and effort arguments described below. Fresh launches use no continuation arguments so they start with fresh context.

Record the returned `instance_id` on the ticket. Use `get` and `status` to confirm the launch and read its `session_id` and `jsonl_path` when available. A pending row has not yet reported in; inspect it before trying another launch, because a timeout can leave an agent running.

## Launch a Child Agent

Run `spawn` from the Main Agent's environment. agent-director records the caller's `AGENT_DIRECTOR_INSTANCE_ID` as the new row's `parent_id`, and gives the Child Agent its own instance ID. Verify that `get` returns the intended Main Agent ID as `parent_id`, so the Child Agent remains attached to its parent.

agent-director 0.12.0 takes the parent from that environment; its `--parent` flag belongs to `list`, not `spawn`. From a supervising shell, `env AGENT_DIRECTOR_INSTANCE_ID='<main-id>' agent-director spawn ...` supplies the same parent identity. Use the recorded Main Agent ID, because a Child Agent must belong to the Main Agent assigning its work.

Start the Child Agent with the assigned skill and ticket IDs. Include the Main Agent ID, assigned checkout paths, resolved settings and Protocol File locations in the prompt. Keep work instructions and progress on the referenced tickets so the launch does not copy their contents. Record the Child Agent's instance ID, skill, assignment and Thinking Level on the ticket for later continuation.

## Model and Thinking Level at launch

Resolve the model and effort from `thinking_levels` and the chosen Agent's `levels_claude_code` or `levels_codex` mapping. Apply Task or Bug overrides before resolving that mapping. Model and effort are launch arguments, so the same skill can run in either Agent.

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

Read its recorded identity and current state with `get`, then apply `workflow.md`'s retained Child Agent Context rule using the reading below. Continue an idle `waiting` Child Agent with:

```sh
agent-director send-keys --instance-id '<child-id>' --text 'Continue from <ticket-id>.'
```

This starts the next turn in the existing session. The ticket holds the repair instructions. If the session has ended and its process is confirmed gone, `agent-director resume --instance-id '<child-id>'` reopens its recorded session; inspect its state and pane before sending the continuation. A resumed Codex session may stay `pending` until its first prompt; after reading its pane and confirming it is ready for input, send that continuation with `send-keys --allow-pending`. Run `resume` from the Main Agent's environment, because it records the current caller as the parent.

When a fresh replacement is needed, resolve any uncertain delivery and stop the old assignment first, because a timed-out send may have arrived. Launch a fresh Child Agent with the same skill and ticket IDs and record its new identity.

## Read a Child Agent's context

Until agent-director ships Idea b.17w, read the Child Agent's own session file, following Research Report t1.b1n.y4. Get the child's `session_id`, `jsonl_path` and Agent with `agent-director get --instance-id '<child-id>'`. Confirm `parent_id` against the recorded Main Agent and match the file's session identity, because the parent's context says nothing about the child's.

Follow the selected Agent Protocol File's **Context use** section for that session: Claude Code's latest assistant usage and effective capacity, or Codex's latest `token_count` usage and window. A captured status-line reading is usable only when it belongs to that Child Agent's session. These Child Agents are separate Agent sessions, so their files are the sessions recorded by agent-director.

Keep the session identity, source, history position, model, provider and capacity basis with the reading. Use the active history after compaction and the latest completed turn, because cumulative usage measures consumption rather than current context. If identity, usage or compatible capacity cannot be established, return unknown so the shared Context rule replaces the Child Agent.

## Watch and collect results

Use `status --instance-id '<id>'` for state, `get --instance-id '<id>'` for the full record and `read-pane --instance-id '<id>' --lines 80` for output. `list --parent '<main-id>'` finds a Main Agent's Child Agents. A `waiting` state means the turn ended; read its result to distinguish completion from a question or an unfinished assignment.

Child Agents report ticket IDs and unresolved work to their Main Agent. The Main Agent reads the tickets, coordinates the next work and passes questions needing a decision to the Managing Intelligence. Record progress on tickets so a replacement Main Agent can find both the work and its retained Child Agents.

A fresh Main Agent may continue a retained Child Agent only after the old Main Agent has stopped using it. Stop the idle Child Agent with `pause`, verify exit, then `resume` it from the new Main Agent's environment to update `parent_id`. Verify that relationship with `get` before sending work, so continuation belongs to the current Main Agent.

## Stop a Child Agent

For an idle Child Agent, use `agent-director pause --instance-id '<id>'`. Verify exit before replacing it or removing its worktree. To stop a live Child Agent, use `agent-director kill --instance-id '<id>'` and check the result; `kill` does not itself change the row's state.

Follow the live-row sequence in `agent-director --help`: allow a pending launch its grace period, then run `find-missing` and check `status`, about five seconds apart, at most three times. If still live, try `kill` once more, wait and reconcile once more, then report the unresolved stop. An error or a `missing` row alone is not proof of exit, so retain the worktree while liveness is unresolved. A session conflict needs the Managing Intelligence's decision because the session may belong to someone else.

## Stop a Main Agent

Use the same pause, exit verification and live-row stop procedure for a Main Agent. Before ending its assignment or deleting its worktrees, inspect its Child Agents with `list --parent` and stop any still using those worktrees. Stopping the Main Agent alone does not stop its children.
