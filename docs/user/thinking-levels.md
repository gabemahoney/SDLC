# Thinking Levels

A Thinking Level selects the Agent, model, effort or mode and any launch template for a skill. SDLC fixes skill levels; you choose the tools and models each level uses through project-setup or either [settings file](settings.md).

## The five levels

The labels run from `low` through `medium`, `high`, `xhigh` and `max`. Task planning uses these meanings:

| Level | Work it suits |
| --- | --- |
| `low` | Trivial, mechanical changes with obvious, cheap mistakes. |
| `medium` | Routine work following an established pattern. |
| `high` | Design judgement, several modules or behaviour other code relies on. |
| `xhigh` | Costly or hard-to-spot mistakes, such as concurrency or security. |
| `max` | The hardest, highest-risk work. |

## Configure each level

SDLC assigns each skill a fixed label in [`templates/thinking-levels.md`](../../templates/thinking-levels.md), installed at `~/.sdlc/install/templates/thinking-levels.md`. Your `levels` setting assigns each label an `agent`, a `model` and that model's `effort` for Claude Code or Codex. Valid Agent names are `claude-code`, `codex` and `cursor`. An entry may also name a launch `template`, such as `CURSOR_WORKER_HIGH`, so each level can carry its own host configuration; without one, the level uses its Agent's default template from the [README](../../README.md#agent-setup).

The label and effort need not match: a `medium` level can use a model's `high` effort. Choose models and efforts your accounts support. For Cursor, choose from `cursor-agent --list-models`, omit `effort` and leave `mode` unset. That uses the launcher's normal `agent` mode; `plan` and `ask` are read-only and unsuitable for levels that may execute Tasks, Bugs or Tweaks.

For example, the illustrative `levels` block SDLC ships mixes Agents:

```text
## levels
max: {agent: claude-code, model: claude-opus-5-5, effort: max}
xhigh: {agent: claude-code, model: claude-opus-5-5, effort: high}
high: {agent: cursor, model: claude-opus-5-5-high}
medium: {agent: codex, model: gpt-6-astra, effort: xhigh}
low: {agent: codex, model: gpt-6-astra, effort: low}
```

A Project's `levels` block replaces the entire home block, so include all five levels when overriding it.

## Task, Bug and Tweak overrides

A Task, Bug or Tweak's `thinking_level:<label>` tag overrides the fixed levels for `engineer`, `test-writer` and `doc-writer`. A Subtask uses its Task's tag. Other skills keep their fixed levels.

write-epic assigns Task tags, and develop-epic assigns them to fix Tasks. define-bug assigns Bug tags at `medium` or above because fixes require reproduction and review. write-idea assigns Tweak tags at any level, and build-tweak launches its engineer at the tag. For example, `thinking_level:high` makes all three executors use your `high` mapping.

The caller resolves the mapping before launch. A missing entry for a shipped skill stops the Run, identifies the shipped mapping file and points to reinstalling SDLC with `install.sh`; a missing `levels` entry goes to project-setup. A missing Task tag goes back to planning and a missing Bug tag goes to the Managing Intelligence. A Tweak with no tag uses the fixed level. Before setup has established `levels`, the Managing Intelligence chooses setup's Agent and model settings.
