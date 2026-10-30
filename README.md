# SDLC

SDLC turns Ideas and Bugs into reviewed, tested changes using Claude Code, Codex CLI or Cursor CLI. Agents plan the work, build it and hand it back for your acceptance.

## Requirements

- Claude Code, Codex CLI or Cursor CLI
- [bees](https://github.com/gabemahoney/bees) for tickets
- [agent-director](https://github.com/gabemahoney/agent-director) and tmux to launch agents

## Install

```bash
git clone https://github.com/gabemahoney/SDLC ~/projects/sdlc
cd ~/projects/sdlc
./install.sh --agent both
```

`both` installs Claude Code and Codex CLI. Use `--agent cursor` for Cursor alone or `--agent all` for all three. Add `--repo /path/to/repo` for repository skills; shared files still install under `~/.sdlc/`.

`install.sh` copies shipped skills into the selected tool's skills folder, overwriting matching files. It also copies the workflow, templates, intakes, resolvers, document templates and protocols into `~/.sdlc/install/`, and default fallback guides into `~/.sdlc/`. It never writes your settings, custom guides, or `~/.sdlc/{templates,intakes,resolvers}/`. It leaves obsolete skills, agent definitions and other unshipped files in place, except for one deletion: `~/.sdlc/install/templates/public-github-project.md`.

## Agent setup

Have your host operator configure the agent-director worker template for every tool you use:

| Tool | Template |
| --- | --- |
| Claude Code | `WORKER` |
| Codex CLI | `CODEX_WORKER` |
| Cursor CLI | `CURSOR_WORKER` |

These templates supply worker permissions and host configuration. Cursor needs Linux, CLI 2026.10.08 or later and an operator-configured login. Choose an account model with `cursor-agent --list-models`.

## Migrate an existing install

Move `~/.apiary` to `~/.sdlc` and each Project's `.apiary` folder to `.sdlc`. Update paths in settings, saved templates and pointer guides. SDLC versions restarted at `1.0.0`.

For SDLC `2.0.0`, move `~/.sdlc/system` to `~/.sdlc/install` or delete the old folder. Update stored paths in settings and templates, then reinstall so skills and shared files use the new location.

### Upgrading from Apiary 1.0

Apiary 1.0 (`v2.3.1`) installed eight skill folders that SDLC no longer ships. Remove them manually from each tool where they remain, then reinstall. These Bash commands name only those folders:

```bash
# Claude Code
rm -rf ~/.claude/skills/{apiary-setup,configure_worktree,do-bee,hatch-epic,idea,make-plan,run-lanes,teardown_worktree}
# Codex CLI
rm -rf ~/.agents/skills/{apiary-setup,configure_worktree,do-bee,hatch-epic,idea,make-plan,run-lanes,teardown_worktree}
# Cursor CLI
rm -rf ~/.cursor/skills/{apiary-setup,configure_worktree,do-bee,hatch-epic,idea,make-plan,run-lanes,teardown_worktree}
```

Also remove the 18 Claude Code agent files shipped by that release:

```bash
rm -f \
  ~/.claude/agents/apiary-code-reviewer.md \
  ~/.claude/agents/apiary-doc-reviewer.md \
  ~/.claude/agents/apiary-doc-writer-bugfix.md \
  ~/.claude/agents/apiary-doc-writer-planner.md \
  ~/.claude/agents/apiary-doc-writer.md \
  ~/.claude/agents/apiary-engineer-bugfix.md \
  ~/.claude/agents/apiary-engineer-planner.md \
  ~/.claude/agents/apiary-engineer.md \
  ~/.claude/agents/apiary-plan-writer.md \
  ~/.claude/agents/apiary-prd-writer.md \
  ~/.claude/agents/apiary-product-manager-planner.md \
  ~/.claude/agents/apiary-product-manager.md \
  ~/.claude/agents/apiary-req-reviewer.md \
  ~/.claude/agents/apiary-srd-writer.md \
  ~/.claude/agents/apiary-test-reviewer.md \
  ~/.claude/agents/apiary-test-writer-bugfix.md \
  ~/.claude/agents/apiary-test-writer-planner.md \
  ~/.claude/agents/apiary-test-writer.md
```

For a repository install, replace `~` with that repository's path in the commands above.

## Set up a Project

```bash
cd ~/projects/my-project
claude "/project-setup"
```

Setup chooses settings, ticket stores and guides with you. For Cursor, launch project-setup through agent-director with `CURSOR_WORKER` and your chosen model. Use a [Project Template](docs/project-templates.md) to reuse a setup.

## Use

Start each skill in a fresh session, passing the ticket ID after intake. Each reports what to run next.

- **Idea:** write-idea → write-prd → write-srd → write-plan → configure-worktree → write-epic and develop-epic for each Epic → idea-review.
- **Bug:** write-bug → define-bug → configure-worktree → fix-bug.
- **Research:** research answers a question with a cited Report, revising it until you accept it.

Approve the Idea before write-prd, and approve the PRD and SRD before planning. After implementation and review, test and accept the Idea or Bug, then run teardown-worktree and release. Your release guide controls what may ship.

## Customize

- [Settings reference](docs/user/settings.md): files, overrides and every setting.
- [Thinking Levels](docs/user/thinking-levels.md): tools, models and Task/Bug overrides.
- [Guides](docs/user/guides.md): engineering, testing, docs, builds, Bugs, research and releases.
- [Intakes and resolvers](docs/user/intakes-and-resolvers.md): input sources and your own instructions.
