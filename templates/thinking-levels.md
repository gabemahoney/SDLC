# Recommended Thinking Levels

Each line maps a skill name to its default Thinking Level. Task and Bug tags override the executor skills as `~/.apiary/system/workflow.md` describes.

```text
project-setup: medium
write-idea: medium
write-bug: medium
define-bug: high
fix-bug: medium
write-prd: xhigh
write-srd: max
write-plan: max
write-epic: xhigh
develop-epic: medium
idea-review: high
research: high
release: medium
configure-worktree: medium
teardown-worktree: medium
engineer: high
test-writer: high
doc-writer: high
model-writer: xhigh
model-review: xhigh
engineer-planner: high
test-writer-planner: high
doc-writer-planner: high
req-review: xhigh
code-review: xhigh
test-review: xhigh
doc-review: high
product-manager: xhigh
```

## Agents, models and effort

Use this shape for `setting:levels`, with an Agent, model and its own effort or optional Cursor mode at each level, so one mapping can mix Agents and choose how each model runs:

```text
## levels
max: {agent: claude-code, model: claude-opus-5-5, effort: max}
xhigh: {agent: claude-code, model: claude-opus-5-5, effort: high}
high: {agent: cursor, model: claude-opus-5-5-high}
medium: {agent: codex, model: gpt-6-astra, effort: xhigh}
low: {agent: codex, model: gpt-6-astra, effort: low}
```

Have the Managing Intelligence supply models and effort values available to their accounts, checking Cursor models with `cursor-agent --list-models`, because these example model names are illustrative. A level's label chooses an entry; its `effort` is the selected model's setting, so the two can differ.

## Per-Agent mappings

Keep existing `setting:levels_claude_code`, `setting:levels_codex` and `setting:levels_cursor` mappings valid, because they apply on the caller's own Agent when `setting:levels` is unset. Claude Code and Codex mappings supply model and effort.

### Cursor models

Use this shape for `setting:levels_cursor`, replacing each placeholder with a model from the user's `cursor-agent --list-models`, so every level names a model their account can use:

```text
## levels_cursor
low: model=<model>
medium: model=<model>
high: model=<model>
xhigh: model=<model>
max: model=<model>
```

For either mapping, choose a Cursor mode that permits the assigned skill's work, because agent-director supports `agent`, `plan` and `ask`, and `plan` and `ask` are read-only. Use `mode: <mode>` in a `setting:levels` entry or `mode=<mode>` on a `setting:levels_cursor` line, so the mode follows its mapping's format. A model alone uses the normal agent mode. Keep Cursor mappings to model and optional mode, because Cursor launches have no effort setting.
