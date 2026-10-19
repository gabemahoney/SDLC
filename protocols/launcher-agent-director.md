# agent-director Launcher Protocol File

Select with `setting:launcher` set to `agent-director`. This file installs as `~/.apiary/system/protocols/launcher-agent-director.md`, referenced by skills as `protocol:launcher.md`.

## Prerequisites

Use agent-director, tmux, the chosen Agent's hooks and installed skills. Check `agent-director version` and `agent-director --help` for the installed behavior. Run lifecycle commands as the agents' user on their tmux server, because another server cannot establish their liveness.

Choose an approved template from `~/.config/agent-director/templates/<name>.toml` for its permissions and environment. Record the template on the assignment's ticket for continuation.

## Main Agents and Child Agents

Both run in separate agent-director sessions. The Managing Intelligence assigns Main Agents; a Main Agent assigns its Child Agents.

Send the initial assignment at launch. For a follow-up, use `send-keys` as Resume a Child Agent describes. A Child Agent ends its turn with a report or question; its Main Agent polls its state and reads the pane. Decisions needing the Managing Intelligence go through the Main Agent.

## Launch a Main Agent

Launch the Managing Intelligence's recorded skill and ticket assignment. Resolve model and effort from the workflow's Thinking Levels, including Task or Bug overrides.

Claude Code:

```sh
agent-director spawn --template '<template>' --agent claude --cwd '<checkout>' -- --model '<model>' --effort '<effort>' '/engineer <ticket-id>'
```

Codex:

```sh
agent-director spawn --template '<template>' --agent codex --cwd '<checkout>' -- --model '<model>' -c 'model_reasoning_effort="<effort>"' '$engineer <ticket-id>'
```

Replace placeholders and `engineer` with the assignment. Include the workflow's launch context in the prompt. Keep the Codex prompt quoted so the shell preserves `$`. Arguments after `--` replace the template's `agent_args`; carry forward required template arguments, excluding continuation arguments for a fresh session.

Record the returned `instance_id` and inspect it with `get` and `status` below. A timed-out launch may still be running: follow `--help` before retrying, to avoid duplicate agents.

## Launch a Child Agent

Use the same launch commands from the Main Agent's environment. agent-director takes `parent_id` from `AGENT_DIRECTOR_INSTANCE_ID` and gives the child its own ID. Check `get` returns the intended parent so the assignment stays attached to its Main Agent. Record the child's identity and assignment on its ticket as the workflow requires.

## Report to your Main Agent

End your turn with your report or question as the final message. Your Main Agent reads it with `read-pane`; it answers questions through `send-keys`.

## Know when a Child Agent's state changes

There are no automatic notifications. Poll while work is outstanding, including after resumption:

```sh
agent-director status --instance-id '<id>'
agent-director get --instance-id '<id>'
agent-director read-pane --instance-id '<id>' --n-lines 80
```

Poll `status` every few seconds; use `get` and `read-pane` when it changes or needs inspection. The same commands inspect Main Agents.

| State | Action |
|---|---|
| `pending` | Launch has not reported in. Follow `--help` for its grace period and pane inspection before sending input or retrying. |
| `working` | Wait for the turn. |
| `waiting` | Read the result; it may be complete, unfinished or asking a question. |
| `ask_user`, `check_permission` | Inspect the request and obtain the required decision. |
| `ended`, `missing` | Read the result. Establish process exit before replacement or cleanup; the state alone is not proof. |

For an authorized verdict on an open relayed permission request:

```sh
agent-director decide --instance-id '<id>' --request-token '<token>' --decision '<allow-or-deny>'
agent-director get-permission --request-token '<token>'
```

Check delivery and follow `--help` for fallback or closed requests, because a recorded verdict may not have reached the Agent.

## Resume a Child Agent

Read its state with `get` and its context as below. Apply the workflow's reuse rule before continuing.

For a `waiting` child, send the ticket holding its next assignment:

```sh
agent-director send-keys --instance-id '<child-id>' --text 'Continue from <ticket-id>.'
```

For a finished child whose process has exited, reopen its recorded conversation first:

```sh
agent-director resume --instance-id '<child-id>'
```

Inspect state and pane before sending the continuation. A resumed Codex session can remain `pending` until its first prompt; after inspecting the pane and confirming readiness, send with `--allow-pending`.

Run `resume` from the current Main Agent's environment, because it updates `parent_id`. To transfer a retained child to a new Main Agent, first end the old Main Agent's use of it, pause the idle child and verify exit, then resume it from the new parent and check `parent_id`.

Before replacing a child, settle uncertain message delivery and stop the old assignment, because a timed-out send may have arrived.

## Read a Child Agent's context

Use `agent-director get --instance-id '<child-id>'` for its `agent`, `parent_id`, `session_id` and `jsonl_path`. Match the parent and transcript session identities so you measure the child rather than yourself.

Apply the matching Agent protocol's context procedure to that child's session:

- `protocol:agent-claude-code.md ## Context use` for Claude Code's retained status-line payload or transcript estimate.
- `protocol:agent-codex.md ## Context use` for Codex's rollout token usage and effective window.

Those procedures cover locating a missing transcript path, token accounting, compaction and capacity validation. An unverified reading is unknown, never zero; the workflow decides whether to resume or replace.

## Stop a Child Agent

For a `waiting` child:

```sh
agent-director pause --instance-id '<id>'
```

For a live child that must be stopped:

```sh
agent-director kill --instance-id '<id>'
```

Check the result. `kill` does not change the row's state. Follow its live-row sequence in `agent-director --help`: allow pending launches their grace period, run `agent-director find-missing` and check `status` about five seconds apart, at most three times. If still live, retry `kill` once, wait and reconcile once more, then report the unresolved stop.

Errors and finished-row no-op successes do not prove exit. Retain worktrees while liveness is unresolved. A session conflict or a reported non-agent survivor needs the Managing Intelligence; retrying must not hide that survivor. Leave `expire` to operator-scheduled cleanup, because it deletes records.

## Stop a Main Agent

Find its children with:

```sh
agent-director list --parent '<main-id>'
```

Use the same stop procedure for the Main Agent and its children before removing their worktrees. Stopping a Main Agent alone does not stop its children.
