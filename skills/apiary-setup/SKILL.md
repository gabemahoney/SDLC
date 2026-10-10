---
name: apiary-setup
description: Configure hives for Apiary workflow
---

## Overview

This skill should be run once to configure a repo for the Apiary workflow. It can also be run to fix hives that
have gotten misconfigured, or to migrate hives still on old status values.

## Valid configuration

The repo must have the following hives available and configured with these child tiers and valid status values.

Every hive uses the same four status values, and no others: `draft`, `defined`, `active`, `done`. A board can then show every hive the same way. What each value means in each hive is listed below. `defined` means fully written up, not approved. Approval and priority come from tags, never from the status: one `priority:N` tag, where a lower number means higher priority (`priority:0` is the highest, then `priority:1`, and so on, with no upper limit), and `parked`.

### Bugs Hive
Child tiers:
none

Status values:
- draft — filed, not yet validated
- defined — confirmed real, not yet being fixed
- active — being fixed
- done — fixed and merged, or closed as invalid (tagged `invalid`)

### Ideas Hive
Child tiers:
- t1 - Doc / Docs

Status values:
- draft — not fully documented, not ready to work
- defined — fully documented, ready to work
- active — in progress
- done — complete

#### Plans Hive (nested inside Ideas)
Located at `{ideas_hive_path}/Plans`.

Child tiers:
- t1 — Epic / Epics
- t2 — Task / Tasks
- t3 — Subtask / Subtasks

Status values:
- draft — not fully documented, not ready to work
- defined — fully documented, ready to work
- active — in progress
- done — complete

### Research Hive
Used by the `research` skill.

Child tiers:
- t1 — Report / Reports

Status values:
- draft — not used by `research`: a question is ready as soon as it is written
- defined — filed with its question, ready to work
- active — in review rounds
- done — accepted; kept, never archived

The Research hive must never be swept by the undertaker: it must not have an `undertaker_schedule`. Accepted research sits in `done` like closed tickets in every other hive, so an undertaker pointed at the Research hive by mistake would archive it.

## Instructions

### Prerequisites

Before configuring hives, verify the following are installed and configured.

#### 1. bees

Verify bees is available either as a CLI on PATH (`which bees`) or as a configured MCP server. If neither is present, direct the user to the bees repo for installation instructions: https://github.com/gabemahoney/bees

#### 2. Apiary Agent Definitions

The Apiary workflow spawns role players as subagents defined in `agents/*.md` files. This is a **verify-only** step — no install, no repair.

Detect the skill install location and check that all 18 agent definition files are present at the parallel path:
- `<repo>/.claude/agents/` when the Apiary skills live in `<repo>/.claude/skills/`
- `~/.claude/agents/` when they live in `~/.claude/skills/`

The 18 files: `apiary-engineer.md`, `apiary-test-writer.md`, `apiary-doc-writer.md`, `apiary-product-manager.md`, `apiary-engineer-bugfix.md`, `apiary-test-writer-bugfix.md`, `apiary-doc-writer-bugfix.md`, `apiary-engineer-planner.md`, `apiary-test-writer-planner.md`, `apiary-doc-writer-planner.md`, `apiary-product-manager-planner.md`, `apiary-code-reviewer.md`, `apiary-test-reviewer.md`, `apiary-doc-reviewer.md`, `apiary-prd-writer.md`, `apiary-srd-writer.md`, `apiary-req-reviewer.md`, `apiary-plan-writer.md`.

If all 18 are present, report success and move on. If any are missing, report the missing filenames and instruct the user to re-run README Install step 2 (the paired copy of `skills/` and `agents/`). Perform no file copies, no backups, and no clone-path prompts.

#### 3. tmux (required for worktree skills)

The `configure_worktree` and `teardown_worktree` skills launch and stop Claude Code workers through agent-director, which runs them in tmux. Check if tmux is installed (`which tmux`). If not, direct the user to install it via their system package manager (e.g. `apt install tmux`, `brew install tmux`). Their worktree-only mode needs neither tmux nor agent-director.

#### 4. Repository Directory Structure

Apiary expects the repo's main checkout to live one level below a parent directory, so that git worktrees can be created alongside it during development:

```
project-root/
├── repo/          # the main checkout (already exists — do NOT create this)
└── ...            # worktrees appear here later, created by Apiary agents as needed
```

**Do not create the main repo or any worktree directories during setup.** The only check here is that the main checkout is not itself the top-level directory (i.e., it has a parent directory with room for sibling worktrees). If it is, offer to reorganize it before proceeding.

---

### Hive Configuration

#### Working directory requirement

Bees validates that hive paths are within the git repo root of the current working directory.

**Rule:** Before running `colonize-hive`, your CWD must be a directory that is at or above the hive path. This is typically:
- The **repo** — if the hive lives inside the repo (e.g. `<repo>/tickets/bugs`)
- The **project parent** — if the hive lives alongside the repo (e.g. `<project-parent>/Bugs`)

After colonization, `cd` into the target repo for all other bees write operations (`set_status_values`, `create_ticket`, etc.) — these need CWD inside the repo for write-permission checks.

**Do not** run bees write operations from the Apiary checkout — it is a queen repo without write permission.

If the MCP write tool rejects the call, fall back to the `bees` CLI invoked from the correct directory.

#### Scope requirement

When calling `colonize_hive`, **always pass an explicit `scope` parameter** that is specific to the target project, for example `scope="/home/user/projects/myproject/**"`. The default scope (`/home/user/**` or wider) overlaps with other projects' hives and the bees server will reject the creation with `cross_scope_hive_conflict` if any other project has already registered a hive with the same normalized name (e.g. `bugs`, `plans`).

Pick the narrowest scope glob that still covers the entire project directory tree — typically the project's parent directory with a trailing `/**`.

#### Create or validate

Check for the existence of the above hives and validate their configs.
If any hives are missing:
- **You must use `AskUserQuestion` to ask the user where each missing hive should live.** Do not assume a default path, do not reuse paths from a previous run, and do not proceed without an explicit answer. Suggest sensible options (e.g. `<repo>/tickets/bugs` in-repo, or `<project-parent>/bugs` sibling-to-repo) but always let the user pick.
- Once the user chooses a path, colonize the hive, passing:
  - `name` — the hive name (e.g. `Bugs`, `Ideas`)
  - `path` — absolute path where the hive will live (as answered by the user)
  - `child_tiers` — as defined in the Valid Configuration section above
  - `scope` — explicit project-scoped glob (see above)
- After colonization, set the hive's status values using `set_status_values` (remember the CWD requirement above).

If a hive exists:
- Validate its child tiers and status values.
- If they differ from above, ask user if you may change them to the values listed above.
- If the hive still has old status values (any of `larva`, `pupa`, `worker`, `finished`, `open`, `new`, `completed`), make the change with the migration below, never with a single `set_status_values` call. `active` alone is not old: it is one of the four values.

#### Migrating hives on old status values

Older setups used one of two earlier sets of status values:
- **Interim set**, on any hive: `larva`, `pupa`, `worker`, `finished`.
- **Original sets**: Bugs `open` and `finished`; Research `new`, `active` and `completed`.

Every hive that still has any of those values is migrated: Bugs, Ideas, Plans and Research alike. Plans is a hive of its own, migrated on its own, even though it lives inside the Ideas folder. Check each hive's configured values with `bees get-status-values`, and query each hive for tickets on old values too, since a ticket can hold a value the config no longer lists. Rename by this table:

| Old value | New value | Old set |
|-----------|-----------|---------|
| `larva` | `draft` | interim, any hive |
| `pupa` | `defined` | interim, any hive |
| `worker` | `active` | interim, any hive |
| `finished` | `done` | interim (any hive), and original Bugs |
| `open` | `defined` | original Bugs (already filed and treated as real) |
| `new` | `defined` | original Research |
| `active` | `active` (unchanged) | original Research |
| `completed` | `done` | original Research |

Move each such hive to the four values in this order, with the CWD requirement above:

1. **Add the new values alongside the old ones.** Set the hive's status values to draft, defined, active and done plus every old value it has, e.g. for Bugs on the original set:
   ```bash
   bees set-status-values --scope hive --hive bugs --status-values '["draft","defined","active","done","open","finished"]'
   ```
2. **Rename the tickets.** For each old value except `active`, find its tickets and move them in batches. The query matches every tier, not just Bees: Docs in Ideas, Epics, Tasks and Subtasks in Plans, Reports in Research all move with their Bees.
   ```bash
   bees execute-freeform-query --query-yaml 'stages:
     - [hive=plans, status=pupa]'
   bees update-ticket --ids <id1> <id2> ... --status defined --hive plans
   ```
   A Plans hive can hold thousands of Epics, Tasks and Subtasks, so never update one ticket per call: pass the IDs from the query to `update-ticket --ids` in batches of up to 200. Each call reports `updated`, `not_found` and `failed` IDs; collect the failures for the report. Repeat the query until it returns no tickets on that value, or only ones that keep failing.

   Use the hive's normalized name from `bees list-hives` (e.g. `bugs`) in queries: a display name like `Bugs` matches nothing.
3. **Remove the old values.** Query each old value again. If any ticket still holds one, stop: leave the old values in place and report those tickets. Otherwise set the status values to exactly `["draft","defined","active","done"]`. `active` stays, since it is one of the four. Then run `bees sanitize-hive` on this hive only, after checking for nested hives with one command: `find <hive-path> -mindepth 2 -type d -name .hive`. Any result is another hive inside this hive's path, registered or not (e.g. Plans at `.../Ideas/Plans`, or a copy of a hive kept as evidence inside a ticket). If there is any result, do not sanitize this hive, because sanitize treats the nested hive's tickets as its own and moves their files; report the paths found instead. Never sanitize any other hive as part of this migration. An Ideas hive with Plans inside it is migrated, but never sanitized.
4. **Report** for each hive the number of tickets renamed per old → new value, any that failed or are left over (by ID), and whether the hive was sanitized or skipped for a nested `.hive`.

Never delete a ticket during the migration.

The order matters. Bees checks a ticket's status against the hive's configured values when the ticket is written, so a rename to a value the hive does not have yet fails. It does not recheck existing tickets when the values change, but `sanitize-hive` flags any ticket whose status is not in the list. Adding first and removing last means no ticket ever holds an invalid status.

#### Research hive: no undertaker schedule

Bees has no command that shows undertaker schedules, so read `~/.bees/config.json` (read only) and find the Research hive's entry under this project's scope. If it has an `undertaker_schedule`, warn the user that accepted research would be archived to the cemetery, and tell them to remove that block and restart the bees MCP server. Do not edit the file yourself. This matters more now that Research uses `done` like every other hive: a sweep meant for another hive is easy to point at it by mistake.

### Documentation Locations

With hive configuration complete, the next setup step is to record where your project's documentation lives so that Apiary agents can find and update it automatically.

After hives are configured, ask the user to define their project documentation locations in their CLAUDE.md.
Note that these are repo-specific documents.

Use AskUserQuestion to ask: "Would you like to define repo-specific documentation locations in a repo-specific CLAUDE.md now?"
- Tell the user: "The Apiary workflow will enforce your project standards. To do so, you must define the locations of those documents in your CLAUDE.md. You may skip this step if you have not defined such standards."
- Options: "Yes" / "Skip for now"

If yes, ask for the following (can use a single multi-part question or sequential questions):
- Engineering best practices guide path
- Internal architecture docs directory path
- Customer-facing docs path (e.g. README)
- Test writing guide path
- Test review guide path
- Doc writing guide path

Do NOT volunteer the following context unless the user asks what a location is for:
- **Engineering best practices**: Used by the Engineer agent in fix-bug, hatch-epic, and do-bee to follow project coding standards when writing or modifying source code.
- **Internal architecture docs**: Used by the Engineer to understand existing system design, and by the Doc Writer to update architecture documentation after code changes.
- **Customer-facing docs**: Used by the Doc Writer to update user-facing documentation when user-visible behavior changes.
- **Test writing guide**: Used by the Test Writer to follow project testing conventions when writing or modifying tests.
- **Test review guide**: Used by the Test Writer to self-review test quality before completing work.
- **Doc writing guide**: Used by the Doc Writer to follow project documentation style and format conventions.

Then write or update a `## Documentation Locations` section in the project's CLAUDE.md with the provided paths, using this format:

```markdown
## Documentation Locations

- **Engineering best practices**: <path>
- **Internal architecture docs**: <path>
- **Customer-facing docs**: <path>
- **Test writing guide**: <path>
- **Test review guide**: <path>
- **Doc writing guide**: <path>
```

### Integration Test Command

Finally, use AskUserQuestion to ask: "Does this repo have an integration test suite? If so, what command runs it?"
- Tell the user: "The integration Test Writer uses this command. If you skip this, it finds the command in the repo's docs or CI config, or reports that no integration suite was found."
- Options: "Enter the command" / "Skip for now"

If the user gives a command, write or update a `## Test Commands` section in the project's CLAUDE.md:

```markdown
## Test Commands

- **Integration test command**: <command>
```
