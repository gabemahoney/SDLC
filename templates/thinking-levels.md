# Thinking Levels

SDLC fixes each skill's Thinking Level below, so callers resolve the same level in every Project. Task, Bug and Tweak tags override the executor skills as `~/.sdlc/install/workflow.md` describes.

```text
project-setup: medium
write-idea: medium
write-bug: medium
define-bug: high
fix-bug: medium
build-tweak: medium
write-prd: high
write-srd: xhigh
write-plan: xhigh
write-epic: high
develop-epic: medium
idea-review: high
research: high
release: medium
configure-worktree: medium
teardown-worktree: medium
engineer: medium
test-writer: medium
doc-writer: high
model-writer: high
model-review: high
engineer-planner: high
test-writer-planner: high
doc-writer-planner: high
req-review: high
code-review: high
test-review: high
doc-review: high
product-manager: high
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

Have the Managing Intelligence supply models and effort values available to their accounts, checking Cursor models as `protocol:agent-cursor.md ## Models` says, because these example model names are illustrative. A level's label chooses an entry; its `effort` is the selected model's setting, so the two can differ. Give Cursor entries a model and no effort, leaving mode unset as `protocol:agent-cursor.md ## Modes` says, because Cursor launches have no effort setting. Add `template: <name>`, such as `CURSOR_WORKER_HIGH`, to launch a level with its own Launcher template, so a host can configure each level separately; an entry without one uses its Agent Protocol File's `## Launch template` default.
