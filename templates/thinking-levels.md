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

Use this shape for `setting:levels`, with an Agent, model and its own effort at each level, so one mapping can mix Agents and choose how each model runs:

```text
## levels
max: {agent: claude-code, model: claude-opus-5-5, effort: max}
xhigh: {agent: claude-code, model: claude-opus-5-5, effort: high}
high: {agent: cursor, model: claude-opus-5-5-high}
medium: {agent: codex, model: gpt-6-astra, effort: xhigh}
low: {agent: codex, model: gpt-6-astra, effort: low}
```

Have the Managing Intelligence supply models and effort values available to their accounts, checking Cursor models as `protocol:agent-cursor.md ## Models` says, because these example model names are illustrative. A level's label chooses an entry; its `effort` is the selected model's setting, so the two can differ.

## Per-Agent mappings

Keep existing `setting:levels_claude_code`, `setting:levels_codex` and `setting:levels_cursor` mappings valid, because they apply when no `setting:levels` does, as `~/.apiary/system/workflow.md`'s Thinking Levels describes. Claude Code and Codex mappings supply model and effort.

### Cursor models

Use this shape for `setting:levels_cursor`, replacing each placeholder with a model chosen as `protocol:agent-cursor.md ## Models` says, so every level names a model their account can use:

```text
## levels_cursor
low: model=<model>
medium: model=<model>
high: model=<model>
xhigh: model=<model>
max: model=<model>
```

Give Cursor entries a model and no effort, leaving mode unset as `protocol:agent-cursor.md ## Modes` says, because Cursor launches have no effort setting.
