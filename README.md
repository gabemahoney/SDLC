# Apiary 🐝

Apiary is an opinionated agentic workflow for taking an idea from inception to working software.
It uses the [bees](https://github.com/gabemahoney/bees) ticket management system. Install that first.

## Install

### 1. Clone the repo

```bash
git clone https://github.com/gabemahoney/apiary ~/projects/apiary
```

### 2. Install the skills and agents

Ask Claude Code to install the Apiary skills and agent definitions. The two directories are a paired copy — always install both to the same scope. You have two options — pick one.

**Option A — Global install (recommended for single-user machines).** Installs into your user-level `.claude` directories so every repo you work in can use them.

> "Install the Apiary skills from `~/projects/apiary/skills` globally into `~/.claude/skills`, and the Apiary agents from `~/projects/apiary/agents` into `~/.claude/agents`."

**Option B — Single-repo install.** Installs into a specific project's `.claude` directories so only that repo sees them. Useful if you want to try Apiary on one project without affecting anything else.

> "Install the Apiary skills from `~/projects/apiary/skills` into `<absolute path to target repo>/.claude/skills`, and the Apiary agents from `~/projects/apiary/agents` into `<absolute path to target repo>/.claude/agents`."

In either case, Claude will copy each skill directory (`apiary-setup`, `idea`, `write-prd`, `write-srd`, `make-plan`, `hatch-epic`, `do-bee`, `fix-bug`, `research`, etc.) and each agent definition file (`apiary-engineer.md`, `apiary-code-reviewer.md`, etc.) into the chosen directories without disturbing any other skills or agents already installed there.

### Execution model

Apiary's execution skills spawn role players (Engineer, Test Writer, Doc Writer, Product Manager, and reviewers) as **named subagents** via the Agent tool. The document and planning skills (`write-prd`, `write-srd`, `req-review`, `make-plan`) likewise delegate their heavy work to named subagents (PRD Writer, SRD Writer, Requirements Reviewer, Plan Writer) — the calling agent handles user interaction and reports the results. All definitions live in the install's `.claude/agents/` directory (user-global or per-repo, mirroring the skill install). Subagents run in-process and inherit the calling agent's permission surface — no experimental feature flags required. Each agent's model is set in its frontmatter; the harness resolves the model from the agent definition.

### 3. Configure
Run `/apiary-setup` to configure hives for the Apiary workflow: Bugs, Ideas, Plans and Research.
It can also record your project's documentation locations and integration test command in the repo's CLAUDE.md; you may skip either step.
Without a configured command, the integration Test Writer looks in the repo's docs or CI config, and reports "no integration suite found" if there is none.

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
- `priority:N` — one tag per ticket. A lower number means higher priority: `priority:0` is the highest, then `priority:1`, and so on, with no upper limit.
- `parked` — set aside for now.

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
It will spawn a full set of role subagents via the Agent tool to do the work.
Within each Task the roles run in order: the Engineer, then one or more Test Writer lanes in parallel, with no upper limit (starting from the lanes suggested for the Task at planning time, which `/do-bee` may adjust to the actual change), then the Doc Writer once code and tests have settled. Doc rework from reviews is batched into one pass per review round.
The final (or only) Test Writer of each pass runs the full unit suite once. An integration Test Writer runs the integration suites at the end of each Epic, after any Task flagged at planning time as an interface change, and after final-review fix-ups that touch source code or integration tests. An Epic is not finished while they fail unless the User waives it; `/do-bee` stops and asks if they cannot run, or if a source-fix round does not reduce the failures or 3 rounds pass. No other role runs a full suite.
> Tip:
> - Run `/configure-worktree` first to do the work in an isolated worktree
> - Run your own tests
> - Run `/teardown-worktree` to merge back to main
>
> With `--no-questions`, or when run as an agent-director worker, `/do-bee` never uses AskUserQuestion, even when launched outside a worktree. Wherever it would ask, it stops with a `do-bee: needs input:` line for its driver to answer.
>
> Orchestrator bots can run both worktree skills without questions (`--no-questions`), create or merge the worktree only and launch their own worker (`--worktree-only`), and pick the branch to start from (`--base`) and merge into (`--target`), e.g. one branch per Epic merged into a feature branch. Without `--worktree-only`, `/configure-worktree` launches the worker through agent-director. Each skill's Arguments table has the details.

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
It will spawn a smaller set of role subagents via the Agent tool to do the work, in the same Engineer, Test Writer, Doc Writer order.
The same suite ownership applies at bug scope: the Test Writer of each pass runs the full unit suite once, and an integration Test Writer runs the integration suites once at the end of the fix. The bug is not done while they fail unless the User waives it; `/fix-bug` stops and asks on the same terms as `/do-bee`.
Unlike `/do-bee`, `/fix-bug` manages its own isolated worktree: it creates a fresh worktree for the Bug ID, does all the work and commits there, then merges back and cleans up automatically (unless it stops at the integration gate, leaving the uncommitted fix in the worktree) — no separate `/configure-worktree` or `/teardown-worktree` needed.

### Research
Run `/research "<question>"` to file a research task as a bee in the Research Hive, or `/research <bee-id>` to continue one.
The skill defines only the ticket flow, not how the research is done: `defined` → `active` → `done`. A research bee is `defined` as soon as it is filed, since a question is ready once it is written.
`active` is a review loop. Each round, the researcher presents its findings and a reviewer (the User, or an orchestrator Claude, which decides each round whether to review it itself or send it to the User) accepts them or asks for more work. Each round and its verdict are recorded in the bee's `## Review rounds` section.
The findings go in a Report child of the bee: a standalone document with inline citations and a numbered References list. Research artifacts (data, scripts, logs) go in the bee's `artifacts/` folder, and the Report links to them by relative path.
Accepted research is kept: never run the undertaker on the Research Hive or give it an undertaker schedule. The undertaker only touches the hive it is pointed at, so sweeping other hives is safe, but Research uses `done` like every other hive, so check which hive a sweep is pointed at.


## Advanced Configuration
Apiary provides default `/code-review`, `/test-review` and `doc-review` skills. Feel free to replace this in part 
or wholesale with your own guidelines.

**Note:** These guidelines are enforced across all repos.
Repo-specific guidelines are listed in the repo's CLAUDE.md under `## Documentation Locations`, which `/apiary-setup` can write for you (see Configure).
`/apiary-setup` does not modify the above-listed skills.

