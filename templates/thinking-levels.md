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
req-review: medium
code-review: xhigh
test-review: xhigh
doc-review: high
product-manager: xhigh
```

## Cursor models

Use this shape for `setting:levels_cursor`, replacing each placeholder with a model from the user's `cursor-agent --list-models`, so every level names a model their account can use:

```text
## levels_cursor
low: model=<model>
medium: model=<model>
high: model=<model>
xhigh: model=<model>
max: model=<model>
```

Add `mode=agent`, `mode=plan` or `mode=ask` to a line when needed, choosing a mode that permits the assigned skill's work, because agent-director supports these Cursor modes and `plan` and `ask` are read-only. A model alone uses the normal agent mode. Keep Cursor mappings to model and optional mode, because Cursor launches have no effort setting.
