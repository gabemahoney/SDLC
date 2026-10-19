---
name: configure-worktree
description: "Create or reuse the git worktrees an Idea or Epic needs, and record them on its ticket. Takes an Idea or Epic ID."
---

# configure-worktree

## Purpose

You create or reuse the git worktrees an Idea or Epic needs, one per repo it changes, and record them on its ticket. The Managing Intelligence then launches the next Main Agent in them, and teardown-worktree uses your record to merge the work back and clean up.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

An Idea or Epic ID.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md` and the Ticket System Protocol File selected by `setting:ticket_system`, for operations.
- **Idea or Epic:** for setup choices and earlier preparation or launch results.

For a launch, read the assigned skill and `protocol:launcher.md`. Before committing main-checkout changes, read `guide:release-guide.md` for permissions.

## Gate

Run only when all of these are true:

- The Idea or Epic is `defined` or `active`, so preparation serves work ready to proceed. Otherwise, stop and report its status.
- For a Main Agent launch, the Project Folder has `<Project Folder>/.apiary/project_settings.md`, so the Main Agent finds the same Project Folder from its worktree. If it is absent, stop and suggest project-setup or worktree-only preparation.

## Steps

1. **Settle the setup.** Use the ticket's repos, base refs and next Main Agent assignment. Default to each main checkout's `HEAD` and the current Agent tool. The Managing Intelligence settles missing choices. A recorded worktree-only choice skips the launch.

2. **Prepare the worktrees.** Create or reuse one per assigned repo under the Worktree rules below. Preserve completed preparation if another repo or launch fails, so a later Run can continue.

3. **Hand off.** Unless worktree-only, use `protocol:launcher.md` to start the assigned Main Agent in `<Project Folder>/.worktrees/<ticket id>/`. Use the chosen Agent and the assigned skill's Thinking Level. Check any recorded launch through the Launcher first, because retrying an uncertain launch can start a duplicate Main Agent.

## Child Agents

None: you prepare the worktrees yourself; the Launcher starts the Main Agent.

## Writes

- **The input Idea or Epic:** under `## Worktrees`, record setup choices, each repo's path, branch and original base ref and commit, Main Agent identity and launch result or worktree-only completion, and unfinished work. This record lets teardown-worktree find the work and later Runs continue it. Ticket statuses stay unchanged because you prepare the workspace.
- **Repos:** create branches and worktrees; commit main-checkout changes only when the Managing Intelligence chooses them.

## Done

Report the ticket ID, worktree paths and any unfinished preparation or launch.

## Worktree rules

Name the branch after the ticket ID with dots replaced by underscores, so later Runs can find it. Use the worktree paths defined in `~/.apiary/system/workflow.md`.

- Reuse only a worktree in the intended repo on the ticket's branch. Preserve its changes and original base, because a resumed Run continues that work. Record a newly requested base as unapplied so the ticket describes the actual setup.
- If the expected path holds different work, or the ticket's branch exists without its expected worktree, stop for the Managing Intelligence's decision to protect that work.
- If the base is the main checkout's `HEAD` or branch and that checkout has uncommitted changes, the Managing Intelligence decides whether to commit them first or stop, because a worktree would otherwise omit them.
