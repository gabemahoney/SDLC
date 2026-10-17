# Apiary 🐝

Apiary is an opinionated workflow for taking an idea from inception to working software with Claude Code or Codex CLI. Skills describe the work; tickets hold requirements, decisions and progress.

This branch contains the b.v38 workflow refactor. The skills Child Agents run are listed in [skill-specifics.md](skill-specifics.md) and are still to be written. Legacy skills and `agents/` remain available during the transition.

## Execution

The Managing Intelligence chooses the next workflow skill and starts a Main Agent to run it. A Main Agent may launch Child Agents with the skills its instructions name, such as `engineer`, `test-writer` or `code-review`. Each Child Agent belongs to its Main Agent and reports back to it. Both classes run skills from the same installation.

The `launcher` setting selects `~/.apiary/system/protocols/launcher-<launcher>.md`, called `launcher.md` in the skills. It defines launching Main Agents and Child Agents, preserving their relationship, continuing a Child Agent, reading its context, watching agents and stopping them. Apiary's [agent-director protocol](protocols/launcher-agent-director.md) uses separate tracked sessions for both classes. Model and effort are set at launch from the Project's Thinking Levels.

Before each new unit of work, a Main Agent follows the shared Context rule in [workflow.md](workflow/workflow.md). It records progress and stops at 75% context or an unknown reading; the Managing Intelligence starts a fresh session with the same skill and ticket IDs. Retained Child Agents are resumed only below 75%, otherwise replaced from the ticket record.

## Requirements

- A supported ticket system and its Ticket System Protocol File. Apiary's existing integration uses [bees](https://github.com/gabemahoney/bees).
- Claude Code or Codex CLI, with the skills installed for that Agent.
- The selected Launcher's prerequisites. The shipped protocol uses agent-director and tmux, with hooks configured for each Agent. See [launcher-agent-director.md](protocols/launcher-agent-director.md).
- For git worktrees, access to their main checkout's git metadata. Agent sessions also need access to their ticket store and the Launcher's configuration.
- Python 3 for the installer's legacy Codex agent conversion.

## Install

```bash
git clone https://github.com/gabemahoney/apiary ~/projects/apiary
cd ~/projects/apiary
./install.sh                  # Claude Code (the default)
./install.sh --agent codex    # Codex CLI
./install.sh --agent both
```

Add `--repo <path>` to install into one repository, or `--dry-run` to print the actions without writing. The installer updates Apiary files in place.

| Agent | User skills | Repository skills |
|---|---|---|
| Claude Code | `~/.claude/skills/<skill>/SKILL.md` | `<repo>/.claude/skills/<skill>/SKILL.md` |
| Codex CLI | `~/.agents/skills/<skill>/SKILL.md` | `<repo>/.agents/skills/<skill>/SKILL.md` |

Invoke a skill as `/write-idea <ticket-id>` in Claude Code or `$write-idea <ticket-id>` in Codex. Their Agent Protocol Files describe invocation and reading a session's context.

Shared files always install under `~/.apiary`, including with `--repo`: `workflow.md`, protocols, templates, document templates, intakes and resolvers go under `system/`; `dot-apiary/*-default-fallback.md` goes directly under `~/.apiary/`. The launcher protocol installs alongside the Agent Protocol Files.

For the legacy skills, the installer still copies `agents/*.md` to the selected Claude Code scope and renders them as TOML in the selected Codex scope. `python3 scripts/codex_agents.py lint ~/.codex/agents` checks that legacy Codex install. New Child Agent skills use the skill files above and their launch settings.

## Configure

Have the Managing Intelligence start a Main Agent with `project-setup`. It configures settings, ticket stores and Guidance Documents. Settings resolve from `<Project Folder>/.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`. The installer leaves those settings to project-setup.

- `ticket_system` selects the Ticket System Protocol File.
- `launcher` selects the Launcher Protocol File; setup suggests `agent-director`.
- `thinking_levels` maps skill names to levels. `levels_claude_code` and `levels_codex` map levels to models and effort. Task and Bug tags override executor skill defaults as the workflow describes.
- `prd_template` selects the PRD template; setup offers `~/.apiary/system/doc-templates/prd.md` or a user-supplied file.
- `research_location` selects where Research tickets, Reports and artifacts live. Setup recommends a shared location such as `~/research/tickets`, and also offers a Project-local location.

project-setup requires the named launcher sections listed in [workflow.md](workflow/workflow.md): launch a Main Agent, launch a Child Agent as its child, resume a Child Agent, stop it and read its context. It stops and names missing sections or instructions so later skills can rely on those operations.

Guidance Documents come from the main checkout and its parent folders, as the workflow describes. They cover engineering, tests, documentation, build commands, release permissions, Bug writing and research. A shared Research store still uses the requesting Project's `research-guide.md`. Default Fallback Files apply where no user copy exists.

For hives created by earlier Apiary releases, use the legacy `apiary-setup` migration instructions before adopting the new ticket flow.

## Workflow

Each workflow skill below runs in its own Main Agent. The Managing Intelligence chooses the next Run from the tickets and the previous Run's handoff.

**Ideas:** write-idea → write-prd → req-review → write-srd → req-review → write-plan → write-epic for each Epic → develop-epic for each Epic → idea-review → the Managing Intelligence's testing.

write-srd settles technology and architecture. write-plan divides the Idea into Epics; write-epic plans Tasks and Subtasks. develop-epic coordinates implementation, tests, documentation and independent review, then commits each completed Task. Its Main Agent runs the Epic's Integration Tests and records their evidence. idea-review checks the combined work and files non-trivial findings in a feedback Epic for planning and implementation.

configure-worktree prepares isolated worktrees and can launch the Managing Intelligence's assigned next Main Agent. teardown-worktree merges completed work, stops the assigned agents and removes their worktrees. Decisions and agent identities stay on the ticket so interrupted preparation or cleanup can resume.

**Bugs:** write-bug → define-bug → fix-bug → the Managing Intelligence's acceptance. fix-bug uses isolated worktrees, coordinates the repair and review, runs Integration Tests and merges the verified fix. It leaves the Bug `active` for acceptance.

**Research:** research investigates a Research ticket, writes its Report and continues review until the Managing Intelligence accepts it. Accepted tickets and artifacts remain at `research_location` with automatic archival disabled so other Projects can use the evidence.

Ideas, Plans and Research use `draft`, `defined`, `active` and `done`. Bugs also use `invalid`. Each skill owns the status changes its instructions name; [workflow.md](workflow/workflow.md) defines the shared terms and rules.

## Releases

The release skill follows the Project's `release-guide.md`, including its permissions for pushing and publishing. Apiary versions use annotated `vX.Y.Z` git tags: patch for fixes and wording, minor for new skills or behaviour, and major for changes requiring migration. To update an installation, pull the chosen tag and rerun `install.sh` for each Agent in use.
