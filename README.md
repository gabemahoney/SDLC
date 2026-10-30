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

## Agent setup

Have your host operator configure the agent-director worker template for every tool you use:

| Tool | Template |
| --- | --- |
| Claude Code | `WORKER` |
| Codex CLI | `CODEX_WORKER` |
| Cursor CLI | `CURSOR_WORKER` |

These templates supply worker permissions and host configuration. Cursor needs Linux, CLI 2026.10.08 or later and an operator-configured login. Choose an account model with `cursor-agent --list-models`.

## Migrate an existing install

Move `~/.apiary` to `~/.sdlc` and each Project's `.apiary` folder to `.sdlc`. Update paths in settings, saved templates and pointer guides, then reinstall from the SDLC repository. SDLC versions restart at `1.0.0`.

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
