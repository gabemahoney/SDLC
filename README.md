# SDLC

SDLC turns Ideas and Bugs into reviewed, tested changes using Claude Code, Codex CLI or Cursor CLI. Agents plan the work, build it and hand it back for your acceptance.

## Requirements

- Claude Code, Codex CLI or Cursor CLI.
- A ticket database. SDLC ships a Protocol File for [bees](https://github.com/gabemahoney/bees); add your own Protocol File to use another.
- Optional: an agent launch manager for autonomous development. SDLC ships a Protocol File for [agent-director](https://github.com/gabemahoney/agent-director).

## Install

```bash
git clone https://github.com/gabemahoney/SDLC ~/projects/sdlc
cd ~/projects/sdlc
./install.sh --agent both
```

`both` installs Claude Code and Codex CLI. Use `--agent cursor` for Cursor alone or `--agent all` for all three. Add `--repo /path/to/repo` for repository skills; shared files still install under `~/.sdlc/`.

`install.sh` copies shipped skills into the selected tool's skills folder, overwriting matching files. It also copies the workflow, templates, intakes, resolvers, document templates and protocols into `~/.sdlc/install/`, and default fallback guides into `~/.sdlc/`. It never writes your settings, custom guides, or `~/.sdlc/{templates,intakes,resolvers}/`. It leaves unshipped skills, agent definitions and other files in place, but deletes `~/.sdlc/install/templates/public-github-project.md`.

## Agent setup

If you use agent-director, have your host operator configure its worker template for every tool you use:

| Tool | Template |
| --- | --- |
| Claude Code | `WORKER` |
| Codex CLI | `CODEX_WORKER` |
| Cursor CLI | `CURSOR_WORKER` |

These templates supply worker permissions and host configuration. Cursor needs Linux, CLI 2026.10.08 or later and an operator-configured login. Choose an account model with `cursor-agent --list-models`.

## Set up a Project

```bash
cd ~/projects/my-project
claude "/project-setup"
```

Setup chooses settings, ticket stores and guides with you. If you use Cursor with agent-director, launch project-setup with `CURSOR_WORKER` and your chosen model. Use a [Project Template](docs/project-templates.md) to reuse a setup.

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
