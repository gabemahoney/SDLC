# SDLC

SDLC turns Ideas, Tweaks and Bugs into reviewed, tested changes using Claude Code, Codex CLI or Cursor CLI. Agents plan the work, build it and hand it back for your acceptance.

## Requirements

- Claude Code, Codex CLI or Cursor CLI.
- A ticket database. SDLC ships a Protocol File for [bees](https://github.com/gabemahoney/bees); add your own Protocol File to use another.
- Optional: an agent launch manager for autonomous development. SDLC ships a Protocol File for [agent-director](https://github.com/gabemahoney/agent-director).

## Install

```bash
git clone https://github.com/gabemahoney/SDLC ~/projects/sdlc
cd ~/projects/sdlc
./install.sh
```

The default installs all three agents, as does `--agent all`. Select any comma-separated combination of `claude` (Claude Code), `codex` and `cursor`, for example `--agent claude,cursor`, or one name for a single agent. Repeated names install once; empty or unknown names are errors. Add `--repo /path/to/repo` for repository skills; shared files still install under `~/.sdlc/`.

`install.sh` copies shipped skills into the selected tool's skills folder, overwriting matching files. It also copies the workflow, templates, intakes, resolvers, document templates and protocols into `~/.sdlc/install/`, and default fallback guides into `~/.sdlc/`. It never writes your settings, custom guides, or `~/.sdlc/{templates,intakes,resolvers}/`. It leaves unshipped skills, agent definitions and other files in place, but deletes `~/.sdlc/install/templates/public-github-project.md`.

## Agent setup

If you use agent-director, have your host operator configure a default worker template for every tool you use, and any per-level template your `levels` setting names (see [Thinking Levels](docs/user/thinking-levels.md)):

| Tool | Default template |
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

Start each skill in a fresh session, passing the ticket ID after intake; fix-bug and build-tweak can bundle small tickets. Each reports what to run next.

- **Idea:** write-idea → write-prd → write-srd → write-plan → configure-worktree → write-epic and develop-epic for each Epic, running Epics that don't depend on each other at the same time → idea-review.
- **Tweak** (a minor feature): write-idea → build-tweak.
- **Bug:** write-bug → define-bug → fix-bug.
- **Research:** research answers a question with a cited Report, revising it until you accept it.

Approve the Idea before write-prd, and approve the PRD and SRD before planning. Approve a Tweak once and set up its worktrees before build-tweak, or record `none` under its `## Worktrees` when it changes no repo. Once you approve an SRD with Formal Models, run model-writer on each Model Doc alongside the build, for the model checks that didn't need to pass before coding. Send each violation it reports through write-srd, write-plan and write-epic, and accept the Idea only once every check passes. When an Epic ran in its own worktrees, merge them into the Idea's once it's done. After implementation and review, test the Idea, Tweak or Bug, write its retrospective and accept it. Then run teardown-worktree for an Idea, or merge a Tweak's or Bug's branch and remove its worktrees yourself, and run release. Your release guide controls what may ship.

## Customize

- [Settings reference](docs/user/settings.md): files, overrides and every setting.
- [Thinking Levels](docs/user/thinking-levels.md): tools, models and Task/Bug overrides.
- [Guides](docs/user/guides.md): engineering, testing, docs, builds, Bugs, research and releases.
- [Intakes and resolvers](docs/user/intakes-and-resolvers.md): input sources and your own instructions.
