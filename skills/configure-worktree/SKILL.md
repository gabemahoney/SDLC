---
name: configure-worktree
description: "Create or reuse an Idea's or Epic's git worktrees and optionally launch a Main Agent for its next skill."
---

# configure-worktree

## Purpose

Prepares isolated worktrees for an Idea or Epic before implementation. By default, it uses the Launcher to start the next Main Agent there on the Managing Intelligence's recorded assignment.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

An Idea or Epic ID.

## Required Reading

- **Settings:** Project and default settings, resolved as `~/.apiary/system/workflow.md` describes, for this Run's configuration.
- **Agent Protocol File:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md` under `~/.apiary/system/protocols/`, for the Main Agent's own context readings and skill invocation.
- **Ticket System Protocol File:** selected by `setting:ticket_system` as `~/.apiary/system/workflow.md` describes, to read the Idea or Epic and record decisions on it.
- **The Idea or Epic:** to read its setup choices and earlier preparation or launch results so a resumed Run continues existing work.
- **Repo state:** each main checkout at `<Project Folder>/<repo path>` and its registered worktrees. Why: to check branches, base commits, uncommitted changes and worktrees available for reuse.

When launching, read `protocol:launcher.md` and the assigned skill before making changes, for launch requirements and input IDs. If committing main-checkout changes, read `guide:release-guide.md`, found as `~/.apiary/system/workflow.md` describes, for applicable permissions.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when all of these are true:

- The Idea or Epic is `defined` or `active`, so preparation serves work ready to proceed. Otherwise, stop and report its status.
- The Run starts outside `<Project Folder>/.worktrees/`, so setup uses the main checkouts as its starting point. Otherwise, stop and ask the Managing Intelligence to run it from the Project Folder or a main checkout.
- For a Main Agent launch, the Project Folder has `<Project Folder>/.apiary/project_settings.md`, so the Main Agent finds the same Project Folder from its worktree. If it is absent, stop and suggest project-setup or worktree-only preparation.

## Steps

1. **Settle the setup from the ticket.** Read the repos, base refs and next Main Agent assignment recorded by the Managing Intelligence. They settle missing choices. Use each main checkout's `HEAD` as its default base and the current Agent tool for the new session unless the assignment says otherwise. Launch by default; a worktree-only choice ends the Run after preparation. Record the choices before preparing worktrees so another Run can continue them.

2. **Prepare the worktrees.** Follow the Worktree guidance below. Record each repo's result as preparation proceeds, so a failure in one repo leaves a usable handoff for the others.

3. **Hand off the work.**
   - For worktree-only mode, finish after all repos are prepared.
   - Otherwise, follow the Launcher Protocol File to start or reuse the assignment's Main Agent at `<Project Folder>/.worktrees/<ticket id>/`, using the chosen Agent and its skill's Thinking Level. Confirm delivery of the skill and ticket IDs, and record the Main Agent identity and launch result so teardown-worktree can find it. On a resumed Run, reconcile the recorded Main Agent through the Launcher before launching, to avoid duplicate Main Agents.

## Child Agents

None: configure-worktree prepares the worktrees itself; the Launcher starts the Main Agent.

## Writes

- **The input Idea or Epic:** record setup choices, each repo's worktree path and branch, whether it was created or reused, its base ref and commit when created, and Main Agent identity and launch result or worktree-only completion. Record any failure, what remains and what needs resolving so another Run can resume. Ticket statuses stay unchanged because this skill prepares the workspace.
- **Repos:** create branches and worktrees; commit main-checkout changes only when the Managing Intelligence chooses them.

## Done

Report the ticket ID and the worktree paths.

If a Main Agent was launched, it runs the assigned skill. Otherwise, the work can start in the worktrees.

## Worktree guidance

Name the branch after the ticket ID with dots replaced by underscores, preserving the existing naming convention so later Runs can find it. Use the worktree path `~/.apiary/system/workflow.md` defines.

- Reuse an existing worktree only when it belongs to the intended repo and is on the ticket's branch. Preserve its changes and original base, because a resumed Run continues that work. Record a newly requested base as unapplied when reusing, so the ticket describes the actual setup.
- If the expected path holds different work, or the ticket's branch exists without its expected worktree, stop for the Managing Intelligence's decision to protect that work.
- Resolve each new worktree's base to a commit before creation. If it cannot be resolved, stop and record the failed ref so the Managing Intelligence can correct it.
- When creating from the main checkout's `HEAD` or its branch, the Managing Intelligence decides whether to commit uncommitted changes first or stop, because the new worktree would otherwise omit them. After an approved commit, resolve the base again so it includes that commit.
- Preserve worktrees and Main Agents already created if preparation or launch fails, so another Run can continue from the recorded state.
