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

SDLC assigns each skill a fixed label in [`templates/thinking-levels.md`](../../templates/thinking-levels.md), installed at `~/.sdlc/install/templates/thinking-levels.md`. Settings can't change these labels, and project-setup removes any leftover `thinking_levels` block. Your `levels` setting assigns each label an `agent`, a `model` and that model's `effort` for Claude Code or Codex. Valid Agent names are `claude-code`, `codex` and `cursor`. An entry may also name a launch `template`, such as `CURSOR_WORKER_HIGH`, so each level can carry its own host configuration; without one, the level uses its Agent's default template from the [README](../../README.md#agent-setup).

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

## Separate levels for Main Agents

An optional `main_agent_levels` block in the same format applies only to Main Agents, the skills you launch yourself, such as fix-bug, develop-epic or research. Child Agents always use `levels`. A level `main_agent_levels` omits, or every level when it is unset, uses `levels`. For example, to keep Main Agents on Claude Code while Child Agents use your `levels` mapping:

```text
## main_agent_levels
high: {agent: claude-code, model: claude-opus-5-5, effort: high}
medium: {agent: claude-code, model: claude-opus-5-5, effort: medium}
```

A Project's `main_agent_levels` replaces the home block, as `levels` does. The two settings resolve separately, so a Project that overrides only `levels` still uses your home `main_agent_levels`.

## Task, Bug and Tweak overrides

A Task, Bug or Tweak's `thinking_level:<label>` tag overrides the fixed levels for `code-writer`, `test-writer` and `doc-writer`. A Subtask uses its Task's tag. Other skills keep their fixed levels, except that idea-review launches its reviewers at `xhigh` in a round that reviews the whole Idea.

write-epic assigns Task tags, and develop-epic assigns them to fix Tasks. define-bug assigns Bug tags at `medium` or `high`, never below `medium` because fixes require reproduction and review. fix-bug launches an `xhigh` or `max` Bug tag at `high`. The Managing Intelligence may ask you, with a reason, to run one Bug at `xhigh`; on your yes, it tags the Bug `xhigh` and records your yes under the Bug's `## Decisions`, and only then does fix-bug launch it at `xhigh`. write-idea assigns Tweak tags at `medium`, `high` or `xhigh`, and build-tweak launches its code-writer at the tag. For example, `thinking_level:high` makes all three executors use your `high` mapping.

The caller resolves the mapping before launch. A missing entry for a shipped skill stops the Run, identifies the shipped mapping file and points to reinstalling SDLC with `install.sh`; a level with no usable entry, such as a Child Agent level missing from `levels`, goes to project-setup. A missing Task tag goes back to planning and a missing Bug tag goes to the Managing Intelligence. A Tweak with no tag uses the fixed level. When no entry resolves setup's own level, the Managing Intelligence chooses setup's Agent and model settings.
