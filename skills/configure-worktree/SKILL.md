---
name: configure-worktree
description: "Create or reuse an Idea's or Epic's git worktrees and optionally launch a Worker for its next skill."
---

# configure-worktree

## Purpose

Prepares isolated worktrees for an Idea or Epic before implementation. By default, it also asks the Launcher to start a Worker there.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

An Idea or Epic ID.

## Required Reading

- **Workflow:** `~/.apiary/system/workflow.md`. Why: to follow the shared Run rules.
- **Settings files:** `<Project Folder>/.apiary/project_settings.md` if present, then `~/.apiary/default_project_settings.md`. Why: to select `ticket_system` and, when launching, `launcher`, the Worker's skill line in `thinking_levels`, and its Agent's `levels_claude_code` or `levels_codex` mapping.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` in Claude Code, or `~/.apiary/system/protocols/agent-codex.md` in Codex CLI. Why: to ask and report through the Agent.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: to read the Idea or Epic and record decisions on it.
- **The Idea or Epic:** through the Ticket System Protocol File, using the input ID. Why: to read its setup choices and earlier preparation or launch results so a resumed Run continues existing work.
- **Repo state:** each main checkout at `<Project Folder>/<repo path>` and its registered worktrees. Why: to check branches, base commits, uncommitted changes and worktrees available for reuse.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when all of these are true:

- The Idea or Epic is `defined` or `active`, so preparation serves work ready to proceed. Otherwise, stop and report its status.
- The Run starts outside `<Project Folder>/.worktrees/`, so setup uses the main checkouts as its starting point. Otherwise, stop and ask the Managing Intelligence to run it from the Project Folder or a main checkout.
- For a Worker launch, the Project Folder has `.apiary/project_settings.md`, so the Worker finds the same Project Folder from its worktree. If it is absent, stop and suggest project-setup or worktree-only preparation.

## Steps

1. **Settle the setup from the ticket.** Use its repos, chosen base refs and Worker assignment. The Managing Intelligence settles missing choices. Default each base to the main checkout's `HEAD`, and the Worker Agent to the running Agent. Launch by default; a worktree-only choice on the ticket ends the Run after preparation. Record the choices before preparing worktrees so another Run can continue them.
   - When launching, read `~/.apiary/system/protocols/launcher-<launcher>.md` and the assigned skill's `SKILL.md` for the chosen Agent before making changes, to check launch requirements and the skill's required ticket IDs. The assignment names the skill and those tickets so the Worker reads its instructions from the record.

2. **Prepare the worktrees.** Follow the Worktree guidance below. Record each repo's result as preparation proceeds, so a failure in one repo leaves a usable handoff for the others.

3. **Hand off the work.**
   - For worktree-only mode, finish after all repos are prepared.
   - Otherwise, follow the Launcher Protocol File to start or reuse the assignment's Worker at `<Project Folder>/.worktrees/<ticket id>/`, using the chosen Agent and its skill's Thinking Level. Confirm delivery of the skill and ticket IDs, and record the Worker identity and launch result so teardown-worktree can find it. On a resumed Run, reconcile the recorded Worker through the Launcher before launching, to avoid duplicate Workers.

## Dispatches

None: configure-worktree prepares the worktrees itself; the Launcher starts the Worker.

## Writes

- **The input Idea or Epic:** record setup choices, each repo's worktree path and branch, whether it was created or reused, its base ref and commit when created, and Worker identity and launch result or worktree-only completion. Record any failure, what remains and what needs resolving so another Run can resume. Ticket statuses stay unchanged because this skill prepares the workspace.
- **Repos:** create branches and worktrees; commit main-checkout changes only when the Managing Intelligence chooses them.

## Done

Report the ticket ID and the worktree paths.

If a Worker was launched, it runs the assigned skill. Otherwise, the work can start in the worktrees.

## Worktree guidance

Name the branch after the ticket ID with dots replaced by underscores, preserving the existing naming convention so later Runs can find it. Use the worktree path `workflow.md` defines.

- Reuse an existing worktree only when it belongs to the intended repo and is on the ticket's branch. Preserve its changes and original base, because a resumed Run continues that work. Record a newly requested base as unapplied when reusing, so the ticket describes the actual setup.
- If the expected path holds different work, or the ticket's branch exists without its expected worktree, stop for the Managing Intelligence's decision to protect that work.
- Resolve each new worktree's base to a commit before creation. If it cannot be resolved, stop and record the failed ref so the Managing Intelligence can correct it.
- When creating from the main checkout's `HEAD` or its branch, the Managing Intelligence decides whether to commit uncommitted changes first or stop, because the new worktree would otherwise omit them. After an approved commit, resolve the base again so it includes that commit.
- Preserve worktrees and Workers already created if preparation or launch fails, so another Run can continue from the recorded state.
