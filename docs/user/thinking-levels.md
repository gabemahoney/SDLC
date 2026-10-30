# Thinking Levels

A Thinking Level selects the Agent, model and effort for a skill. You can use different tools for planning, implementation and review. Configure the mappings through project-setup or in either [settings file](settings.md).

## The five levels

The labels run from `low` through `medium`, `high`, `xhigh` and `max`. Task planning uses these meanings:

| Level | Work it suits |
| --- | --- |
| `low` | Trivial, mechanical changes with obvious, cheap mistakes. |
| `medium` | Routine work following an established pattern. |
| `high` | Design judgement, several modules or behaviour other code relies on. |
| `xhigh` | Costly or hard-to-spot mistakes, such as concurrency or security. |
| `max` | The hardest, highest-risk work. |

## Set the mappings

`thinking_levels` assigns one label to each skill. `levels` assigns each label an `agent`, a `model` and that model's `effort` for Claude Code or Codex. Valid Agent names are `claude-code`, `codex` and `cursor`.

The label and effort need not match: a `medium` level can use a model's `high` effort. Choose models and efforts your accounts support. For Cursor, choose from `cursor-agent --list-models`, omit `effort` and leave `mode` unset. That uses the launcher's normal `agent` mode; `plan` and `ask` are read-only and unsuitable for levels that may execute Tasks or Bugs.

For example, this illustrative `levels` block uses Codex at every level:

```text
## levels
low: {agent: codex, model: gpt-6-astra, effort: low}
medium: {agent: codex, model: gpt-6-astra, effort: medium}
high: {agent: codex, model: gpt-6-astra, effort: high}
xhigh: {agent: codex, model: gpt-6-astra, effort: xhigh}
max: {agent: codex, model: gpt-6-astra, effort: xhigh}
```

Copy the complete recommended list from `~/.sdlc/install/templates/thinking-levels.md` into a `## thinking_levels` block in a settings file. Change that block's `write-plan: max` entry to choose write-plan's default. A Project block replaces the entire home block, so retain every needed entry.

## Task and Bug overrides

A Task or Bug's `thinking_level:<label>` tag overrides the defaults for `engineer`, `test-writer` and `doc-writer`. A Subtask uses its Task's tag. Other skills keep their own defaults.

write-epic assigns Task tags, and develop-epic assigns them to fix Tasks. define-bug assigns Bug tags at `medium` or above because fixes require reproduction, regression coverage and review. For example, `thinking_level:high` makes all three executors use your `high` mapping.

The caller resolves the mapping before launch. Missing skill or level entries go to project-setup; a missing Task tag goes back to planning, and a missing Bug tag goes to the Managing Intelligence. Before setup has established mappings, the Managing Intelligence chooses setup's Agent and model settings.
