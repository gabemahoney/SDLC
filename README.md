# Apiary 🐝

Apiary is an opinionated agentic workflow for taking an idea from inception to working software.
It uses the [bees](https://github.com/gabemahoney/bees) ticket management system. Install that first.

Apiary comes in two flavours from the same skills and agents: **Claude Code** and **Codex CLI**.
This README writes skills as `/do-bee`; in Codex CLI, invoke them as `$do-bee`.

## Requirements

- [bees](https://github.com/gabemahoney/bees).
- agent-director 0.12.0 or later, for the worker mode of `/configure-worktree` and `/teardown-worktree`, and for `/run-lanes`. Earlier versions refuse the flags these skills pass (`--instance-id`, `--agent`). Check with `agent-director version`.
- Claude Code 2.1.296 or later for workers under agent-director 0.12.0.
- Bots run by claude-slack-channel-bots need its 0.16.0 release, which needs agent-director 0.12.0.
- Codex CLI: run Apiary sessions with full access (`--sandbox danger-full-access`), or with writable roots that let them commit in git worktrees (whose metadata lives in the main checkout) and reach `~/.config/agent-director` (with `network_access = true`). The Codex install needs `python3`.

## Install

### 1. Clone the repo

```bash
git clone https://github.com/gabemahoney/apiary ~/projects/apiary
```

### 2. Install the skills and agents

Run the installer from the clone, for the agent you use:

```bash
cd ~/projects/apiary
./install.sh                  # Claude Code (the default)
./install.sh --agent codex    # Codex CLI
./install.sh --agent both
```

Add `--repo <path>` to install skills and agents into one repository instead of your user-level folders (to try Apiary on one project), and `--dry-run` to print what it would do. It copies each skill folder and each agent, overwriting earlier Apiary copies in place. Shared files always go under `~/.apiary`, including with `--repo`: document templates in `system/doc-templates/`, protocols in `system/protocols/`, and the `dot-apiary/*-default-fallback.md` guides directly in `~/.apiary/`.

The `prd_template` setting names the PRD template file. project-setup offers `~/.apiary/system/doc-templates/prd.md` as the shipped default or records your own file's path. Settings resolve from `<Project Folder>/.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`. The installer does not create or update these settings files; project-setup writes them.

| Flavour | Skills | Agents | With `--repo <path>` |
|---|---|---|---|
| Claude Code | `~/.claude/skills/<name>/` | `~/.claude/agents/apiary-*.md` | `<path>/.claude/skills`, `<path>/.claude/agents` |
| Codex CLI | `~/.agents/skills/<name>/` | `~/.codex/agents/apiary-*.toml`, rendered from `agents/*.md` | `<path>/.agents/skills`, `<path>/.codex/agents` |

Skills and agents are a paired copy: always install both to the same scope. Codex loads a repo's `.codex/agents/` only when it trusts that project.

To install by hand instead:

- Copy `doc-templates/` to `~/.apiary/system/doc-templates/` for either Agent.
- Copy `dot-apiary/*-default-fallback.md` to `~/.apiary/` for either Agent, including `research-guide-default-fallback.md`.
- Claude Code: copy each `skills/<name>/` to `~/.claude/skills/<name>/` and `agents/*.md` to `~/.claude/agents/`.
- Codex CLI: copy each `skills/<name>/` to `~/.agents/skills/<name>/`, then run `python3 scripts/codex_agents.py render --out ~/.codex/agents`.

`python3 scripts/codex_agents.py lint ~/.codex/agents` checks a Codex install's agent files (it needs Python 3.11+ or `tomli`; the installer runs the same checks when one is available).

### Execution model

Apiary's execution skills spawn role players (Engineer, Test Writer, Doc Writer, Product Manager, and reviewers) as **named subagents**. The document and planning skills (`write-prd`, `write-srd`, `req-review`, `make-plan`) likewise delegate their heavy work to named subagents (PRD Writer, SRD Writer, Requirements Reviewer, Plan Writer) — the calling agent handles user interaction and reports the results.

- **Claude Code**: subagents are spawned with the Agent tool from the install's `.claude/agents/` (user-global or per-repo, mirroring the skill install). They run in-process and inherit the calling agent's permission surface — no experimental feature flags required. Each agent's model is set in its frontmatter.
- **Codex CLI**: each agent is a Codex custom agent in `.codex/agents/apiary-<role>.toml`, which the installer renders from the same `agents/*.md`: the instructions unchanged, plus a few generated Codex notes. Skills spawn them with `spawn_agent` (`agent_type: "apiary-<role>"`, cold start) and collect results with `wait_agent`. Models map from the frontmatter: Opus → `gpt-6-astra`, Sonnet → `gpt-6.1-sol`, Haiku → `gpt-6-luna`, with the same reasoning effort; set `APIARY_CODEX_MODEL_OPUS`, `_SONNET` or `_HAIKU` before installing to change one (empty: Codex's default). Subagents inherit the parent's sandbox and approvals, so the read-only roles are read-only by instruction only. Codex runs a few agents at once (`agents.max_concurrent_threads_per_session`, 4 by default including the parent), so parallel dispatches run in batches.

### 3. Configure
Run `/project-setup` to configure the Project's settings, ticket stores and Guidance Documents. It recommends a shared Research location, such as `~/research/tickets`, and also offers a Project-local folder. Shared Research uses `research_location` in `~/.apiary/default_project_settings.md`; a Project-local value goes in the Project's `.apiary/project_settings.md`. Setup checks that the location exists and the ticket system can use it.

Setup also offers `research-guide.md` for the Project's source preferences, research depth, evidence, Report shape and human involvement. The guide is found as `workflow.md` describes, with `research-guide-default-fallback.md` used when there is no user copy. A shared Research store still uses the requesting Project's guidance.

Hives set up with older states still have the old status values. Run `/apiary-setup` to migrate them, Bugs, Ideas, Plans and Research alike, with every child ticket (Docs, Epics, Tasks, Subtasks, Reports):
- From the interim set, on any hive: `larva` → `draft`, `pupa` → `defined`, `worker` → `active`, `finished` → `done`.
- From the original sets: Bugs `open` → `defined`, `finished` → `done`; Research `new` → `defined`, `active` stays `active`, `completed` → `done`.

It adds the new values, renames the tickets, then removes the old values, so no ticket is lost or left in an invalid state.


## Workflow

### Ticket states
Every hive uses the same four states:
- `draft` — filed, not yet fully written up (for a bug: not yet validated)
- `defined` — fully written up, not approved (for a bug: confirmed real)
- `active` — being worked on
- `done` — complete (for a bug: fixed and merged, or closed as invalid)

A state never means approval or priority. Those come from tags:
- `approved:yes` — the User approved this ticket, and work on it may begin. `defined` only means written up, not approved.
- `priority:N` — one tag per ticket. A lower number means higher priority: `priority:0` is the highest, then `priority:1`, and so on, with no upper limit.
- `parked` — set aside for now.

`/write-prd` refuses an Idea bee without `approved:yes`. `/write-srd`, `/make-plan`, `/hatch-epic`, `/do-bee` and `/run-lanes` refuse unless the Idea's PRD has it; for a Plan bee or Epic they trace back to the Idea's PRD. Apiary's own `/apiary-work` checks an Idea bee (and its PRD, if there is one), and traces a Plan bee or Epic like `/do-bee`. Bugs (`/fix-bug`) and research are not gated.
Only the User approves. No skill adds `approved:yes`; a bot adds it only when relaying the User's explicit approval. In-progress Plans are not exempt.

### Idea
Run `/idea` to jot down a new idea.
It will be stored as a bee in the Ideas Hive.

### Product Requirements Document
Run `/write-prd` with the Idea bee to flesh out a PRD.
The PRD will be stored as a child of the Idea bee.
> Tip: Run `/req-review` on the Idea bee after the PRD is written multiple times until the feedback becomes trivial

### Software Requirements Document
Run `/write-srd` with the Idea bee to flesh out an SRD.
The SRD will be stored as a child of the Idea bee.
> Tip: Run `/req-review` on the Idea bee after the SRD is written multiple times until the feedback becomes trivial

### Make Plan
Run `/make-plan` with the Idea bee to develop a plan for building the feature.
The plan will be stored as a bee in the Plans Hive.

### Do Bee
Run `/do-bee` with the Feature bee to build the feature.
It builds one Epic per session: after each Epic it records progress in the Bee's `## do-bee progress` section and stops with a next-step line. Re-run `/do-bee <bee-id>` in a fresh session to continue; the final reviews also run in a fresh session.
It will spawn a full set of role subagents to do the work.
Within each Task the roles run in order: the Engineer, then one or more Test Writer lanes in parallel, with no upper limit (starting from the lanes suggested for the Task at planning time, which `/do-bee` may adjust to the actual change), then the Doc Writer once code and tests have settled. Doc rework from reviews is batched into one pass per review round.
Test Writers write unit and integration tests as Task Subtasks following `test-guide.md`. The final (or only) Test Writer of each pass runs the full unit suite. After the Epic's last Task, a fresh Test Writer runs every affected repo's integration suites because the Epic is a complete vertical slice. It fixes failures caused by tests and reports source failures for repair Tasks through the full Task pipeline. One integration run checks the combined repairs. `/develop-epic` keeps the Epic active until the gate passes or the Managing Intelligence waives it, and stops if suites cannot run or a failure a repair was meant to fix persists.
> Tip:
> - Run `/configure-worktree` first to do the work in an isolated worktree
> - Run your own tests
> - Run `/teardown-worktree` to merge back to main
>
> With `--no-questions`, or when run as an agent-director worker, `/do-bee` never uses AskUserQuestion, even when launched outside a worktree. Wherever it would ask, it stops with a `do-bee: needs input:` line for its driver to answer.
>
> Orchestrator bots can run both worktree skills without questions (`--no-questions`), create or merge the worktree only and launch their own worker (`--worktree-only`), and pick the branch to start from (`--base`) and merge into (`--target`), e.g. one branch per Epic merged into a feature branch. Without `--worktree-only`, `/configure-worktree` launches the worker through agent-director: Claude Code or Codex CLI, picked with `--agent` (by default the agent you run in, or the `--template`'s). Each skill's Arguments table has the details.

### Run Lanes
Run `/run-lanes` with the Feature bee to build its independent Epics in parallel instead of one at a time.
It creates a feature branch for the Bee in its own worktree. Each Epic that is ready and touches different files from the running ones (going by its Subtasks' Key Files) gets an Epic lane: its own worktree and branch from the feature branch, with a `/do-bee <epic-id> --lane` worker launched through agent-director.
Finished lanes are merged into the feature branch one at a time. After each merge, a post-merge Test Writer reruns the full unit suite and the integration suites on the feature branch, and an Engineer fixes failures where the merged work does not fit together.
It never asks questions: a merge conflict, a failing retest or a stuck Bee stops it with a report. Each run is one pass. Run it again whenever a lane worker finishes, until every Epic is merged; then run `/do-bee` in the feature worktree for the final review and `/teardown-worktree` to merge the feature branch.

### Fix Bug
You can tell your LLM to file a bug in the Bugs Hive as `draft`, no skill needed.
Run `/fix-bug` with the bug in the Bugs Hive to fix.
It first confirms the bug is real: it reproduces it, or if it can't, reviews the code. A real bug goes to `defined`, then `active` while it is fixed, then `done` once the fix is merged, all in one run. An invalid bug goes straight to `done` with the tag `invalid` and an `## Invalid` note saying why; nothing else changes.
With `--no-questions`, or when run as an agent-director worker, `/fix-bug` never uses AskUserQuestion. Wherever it would ask, it stops with a `fix-bug: needs input:` line; the driver answers after the ID (e.g. `/fix-bug <bug-id> fix`).
It will spawn a smaller set of role subagents to do the work, in the same Engineer, Test Writer, Doc Writer order.
The same suite ownership applies at bug scope: the Test Writer of each pass runs the full unit suite once, and an integration Test Writer runs the integration suites once at the end of the fix. The bug is not done while they fail unless the User waives it; `/fix-bug` stops and asks on the same terms as `/do-bee`.
Unlike `/do-bee`, `/fix-bug` manages its own isolated worktree: it creates a fresh worktree for the Bug ID, does all the work and commits there, then merges back and cleans up automatically (unless it stops at the integration gate, leaving the uncommitted fix in the worktree) — no separate `/configure-worktree` or `/teardown-worktree` needed.

### Research
Run `/research <ticket-id>` to investigate a Research ticket's written question or continue its review. Research tickets, Reports and artifacts live at `research_location`, resolved from the Project settings and then the home defaults. Skills use that setting through the Ticket System Protocol File when filing Research or following a linked Research ticket.

The skill manages `defined` → `active` → `done` and follows `research-guide.md` for the investigation and Report. Findings and citations go in the ticket's Report child, with artifacts stored and linked through the Ticket System Protocol File. Each round and verdict stay on the Research ticket. The Managing Intelligence accepts the Report or requests more work; acceptance sets both ticket and Report `done`. The skill then completes any extra outputs the guide requires and records their locations on the ticket so interrupted work can resume.

Accepted Research tickets, Reports and artifacts stay at `research_location` with automatic archival disabled, so Projects and bots can keep using their evidence.


## Releases
Apiary versions are annotated git tags `vX.Y.Z` on GitHub, starting at `v1.0.0`.
- Patch: fixes and wording.
- Minor: new skills or behaviour.
- Major: anything that needs a migration or breaks other bots' hives or prompts.

When an install needs it, the tag message includes the line `Needs: run /apiary-setup fix mode`.
To update, pull the latest tag and re-run `./install.sh` for each flavour you use (see Install, step 2).

### Upgrading to v3 (agent-director 0.12.0)
1. Upgrade agent-director to 0.12.0 with its own installer and upgrade steps. If you run claude-slack-channel-bots, follow its 0.16.0 migration guide instead, which orders the two upgrades.
2. Pull the v3 tag and re-run `./install.sh` for each flavour you use. Workers need Claude Code 2.1.296 or later.
3. Change orchestrator prompts and scripts that pass `--claude-instance-id` or read `claude_instance_id` to `--instance-id` and `instance_id`.

No hive migration is needed: skip `/apiary-setup` fix mode.


## Advanced Configuration
Apiary provides default `/code-review`, `/test-review` and `doc-review` skills. Feel free to replace this in part 
or wholesale with your own guidelines.

**Note:** These guidelines are enforced across all repos.
Repo-specific guidelines are listed in the repo's CLAUDE.md under `## Documentation Locations`, which `/apiary-setup` can write for you (see Configure).
`/apiary-setup` does not modify the above-listed skills.
