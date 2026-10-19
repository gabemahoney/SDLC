# agent-director Launcher Protocol File

## Prerequisites

Use agent-director, with the template the Agent Protocol File names under `## Launch template`. This launcher requires that section, so every Agent Protocol File used with it must have one. Run `agent-director --help` for anything this file doesn't cover, because it documents every command, state and error.

## Main Agents and Child Agents

Both run in their own agent-director sessions. The Managing Intelligence launches Main Agents; a Main Agent launches its Child Agents. A Main Agent sends work at launch and follow-ups with `send-keys`. A Child Agent ends its turn with its report or question, and its Main Agent reads it from the pane. Decisions needing the Managing Intelligence go through the Main Agent.

## Launch a Main Agent

Use the Managing Intelligence's recorded skill and ticket, with the model and effort from the workflow's Thinking Levels:

```sh
# Claude Code
agent-director spawn --template '<template>' --agent claude --cwd '<checkout>' -- --model '<model>' --effort '<effort>' '/<skill> <ticket-id>'
# Codex
agent-director spawn --template '<template>' --agent codex --cwd '<checkout>' -- --model '<model>' -c 'model_reasoning_effort="<effort>"' '$<skill> <ticket-id>'
```

Record the returned `instance_id`. Don't retry a launch that timed out until `agent-director get` shows it ended, because it may still be starting.

## Launch a Child Agent

Use the same commands from the Main Agent's own session, so agent-director makes it a child of that Main Agent. Check `agent-director get --instance-id '<id>'` shows the right `parent_id`.

## Report to your Main Agent

End your turn with your report or question as the final message, so your Main Agent can read it.

## Know when a Child Agent's state changes

agent-director doesn't notify you, so poll while work is outstanding:

```sh
agent-director status --instance-id '<id>'
agent-director read-pane --instance-id '<id>' --n-lines 80
```

`waiting` means it finished its turn: read the pane for its report or question. `check_permission` means it needs a permission decision. `ended` or `missing` means it stopped. A Codex Child Agent can stay `working` after a model error, so also read the pane if it hasn't changed for a long time.

## Resume a Child Agent

For a `waiting` child, send its next assignment with `agent-director send-keys --instance-id '<id>' --text 'Continue from <ticket-id>.'`. For one that has exited, run `agent-director resume --instance-id '<id>'` from your own session first.

## Read a Child Agent's context

Run `agent-director get --instance-id '<id>'` for its `session_id` and `jsonl_path`, then follow `## Context use` in its Agent Protocol File. An unverified reading is unknown, never zero.

## Stop a Child Agent

Run `agent-director pause --instance-id '<id>'` for a `waiting` child, or `agent-director kill --instance-id '<id>'` otherwise. Don't treat it as stopped until `status` shows `ended` or `missing`; follow `agent-director --help` if it doesn't stop. To stop a Main Agent, stop its children too: `agent-director list --parent '<id>'` lists them.
