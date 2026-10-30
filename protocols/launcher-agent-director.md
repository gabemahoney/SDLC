# agent-director Launcher Protocol File

## Prerequisites

Use agent-director, with the template the Agent Protocol File names under `## Launch template`. This launcher requires that section, so every Agent Protocol File used with it must have one. Run `agent-director --help` for anything this file doesn't cover, because it documents every command, state and error.

## Main Agents and Child Agents

Both run in their own agent-director sessions. The Managing Intelligence launches Main Agents; a Main Agent launches its Child Agents. A Main Agent sends work at launch and follow-ups with `send-keys`. A Child Agent ends its turn with its report or question, and its Main Agent reads it from the pane. Decisions needing the Managing Intelligence go through the Main Agent.

## Launching a Main Agent

Use the Managing Intelligence's recorded skill and ticket, with the settings resolved through `~/.sdlc/install/workflow.md`'s Thinking Levels, so the session uses the configured Agent, model and effort or mode. Read the selected `protocol:agent-<agent>.md`, use its launch template and the matching command below, and invoke the skill installed for that Agent, so the session receives that tool's instructions and configuration:

```sh
# Claude Code (agent: claude-code)
agent-director spawn --template '<template>' --agent claude --cwd '<checkout>' -- --model '<model>' --effort '<effort>' '/<skill> <arguments>'
# Codex
agent-director spawn --template '<template>' --agent codex --cwd '<checkout>' -- --model '<model>' -c 'model_reasoning_effort="<effort>"' '$<skill> <arguments>'
# Cursor
agent-director spawn --template '<template>' --agent cursor --cwd '<checkout>' -- --model '<model>' '/<skill> <arguments>'
```

For Cursor, pass the resolved model and, when configured, `--mode '<mode>'` before the prompt, because agent-director accepts model, mode and an initial prompt for interactive Cursor sessions, with no effort flag.

Arguments after `--` replace the template's `agent_args`, so include those too, or the agent loses its sandbox and prompt. Record the returned `instance_id`.

## Launching a Child Agent

Resolve the Child Agent's Thinking Level and use the selected Agent's protocol, template and command above from the Main Agent's own session, so agent-director keeps the parent–child relationship even when the Agents differ. Check `agent-director get --instance-id '<id>'` shows the right `parent_id`.

## Reporting to your Main Agent

End your turn with your report or question as the final message, so your Main Agent can read it.

## Knowing when a Child Agent's state changes

While work is outstanding, wait by running the command `setting:child_watch_command` names, followed by your Child Agents' ids, as one plain command, because agent-director doesn't notify you. Never write your own watch loop, because an Agent may ask permission for its shell constructs, stalling you until a human answers, while a host can allowlist one fixed command.

The command returns as soon as any Child Agent's state is other than `pending` or `working`, printing `<id> <state>`, because a wait that ends only on some states, such as `check_permission`, stalls on the others. If `setting:child_watch_command` is unset, re-check each Child Agent with this plain command instead, one at a time, spacing the checks as your Agent Protocol File's `## Blocking waits` says because it returns at once, until it shows another state:

```sh
agent-director status --instance-id '<id>'
```

On any other state, read that Child Agent's pane:

```sh
agent-director read-pane --instance-id '<id>' --n-lines 80
```

`waiting` means its turn ended: read the pane for its report or question. `check_permission` means it needs a permission decision. `ended` or `missing` means it stopped. After you act on it, wait again while work is outstanding. A Codex Child Agent can stay `working` after a model error, so also read the pane if its state hasn't changed for a long time.

## Resuming a Child Agent

Apply `~/.sdlc/install/workflow.md`'s context gate first, because reuse depends on a verified reading. For an eligible `waiting` child, send its next assignment with `agent-director send-keys --instance-id '<id>' --text '<next assignment>'`. For one that has exited, run `agent-director resume --instance-id '<id>'` from your own session first.

## Reading a Child Agent's context

Run `agent-director get --instance-id '<id>'` for its context and session details, then follow `## Context use` in its Agent Protocol File. An unverified reading is unknown, never zero.

## Stopping a Child Agent

Run `agent-director pause --instance-id '<id>'` for a `waiting` child, or `agent-director kill --instance-id '<id>'` otherwise. Don't treat it as stopped until `status` shows `ended` or `missing`; follow `agent-director --help` if it doesn't stop. To stop a Main Agent, stop its children too: `agent-director list --parent '<id>'` lists them.
