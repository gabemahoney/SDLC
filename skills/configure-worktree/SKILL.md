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

An Idea or Epic ID. The ticket holds the repos to prepare, any chosen base refs and, when launching, the Worker prompt naming its skill and Agent. An omitted Agent defaults to the running Agent. Worktree-only mode creates or reuses the worktrees and finishes there.

## Required Reading

- **Settings files:** `<Project Folder>/.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`. Why: to select `ticket_system` and, when launching, `launcher`, the Worker's skill line in `thinking_levels`, and its Agent's `levels_claude_code` or `levels_codex` mapping.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` in Claude Code, or `~/.apiary/system/protocols/agent-codex.md` in Codex CLI. Why: to ask and report through the Agent.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: to read the Idea or Epic and record decisions on it.
- **The Idea or Epic:** through the Ticket System Protocol File, using the input ID. Why: to check its status and read its repos, base refs and Worker instructions.
- **Repo state:** each main checkout at `<Project Folder>/<repo path>` and its registered worktrees. Why: to check branches, base commits, uncommitted changes and worktrees available for reuse.
- **Launcher Protocol File, when launching:** `~/.apiary/system/protocols/launcher-<launcher>.md`, selected by `launcher`. Why: to find an existing Worker or start one associated with this ticket and its worktrees.
- **Worker's skill, when launching:** `~/.claude/skills/<skill>/SKILL.md` for a Claude Code Worker, or `~/.agents/skills/<skill>/SKILL.md` for a Codex CLI Worker, using the skill named in the ticket's Worker prompt. Why: to check that the prompt supplies the skill's required input.

## Gate

Run only when both of these are true:

- The Idea or Epic is `defined` or `active`. Otherwise, stop and report its status.
- The Run starts outside `<Project Folder>/.worktrees/`, because it creates worktrees there and a worktree can't hold another. Otherwise, stop and ask the Managing Intelligence to run it from the Project Folder or a main checkout.

## Steps

1. **Settle the worktrees.** For each repo, default the base to its main checkout's branch. Name the worktree branch after the ticket ID with dots replaced by underscores, because some git tools treat dots in branch names specially. Record any Managing Intelligence decisions about repos, bases or Worker instructions on the ticket.
   - If the expected path is already a worktree on the ticket's branch, reuse it; a newly requested base applies only when creating a worktree, so resuming does not rebase existing work.
   - If the expected path holds different work or the ticket's branch remains without its worktree, stop for the Managing Intelligence's decision.
   - If creating from the main checkout's branch and it has uncommitted changes, the Managing Intelligence decides whether to commit them first or stop, because the worktree would otherwise omit them.

2. **Prepare the worktrees.** Create each missing worktree at the path `workflow.md` defines, from its resolved base commit. Keep reused worktrees' changes intact.

3. **Hand off the work.**
   - If worktree-only mode was requested, finish with the prepared worktrees.
   - Otherwise, follow the Launcher Protocol File to start or reuse a Worker for this assignment at `<Project Folder>/.worktrees/<ticket id>/`, with the ticket's prompt, chosen Agent, model and effort from its skill's Thinking Level, and all prepared repo paths. Confirm that it received the current prompt and paths.

## Dispatches

None: configure-worktree prepares the worktrees itself; the Launcher starts the Worker.

## Writes

Creates git branches and worktrees at `<Project Folder>/.worktrees/<ticket id>/<repo path>`. Commits main-checkout changes only when the Managing Intelligence chooses them. Records decisions about repos, bases and Worker instructions on the input Idea or Epic.

## Done

Report the ticket ID and each worktree's path, branch, whether it was created or reused, and its base ref and commit when created. Report the Worker and its assigned skill, or worktree-only completion. If preparation or launch stopped, report what remains in place and what needs resolving before another Run.

Next step: follow the Worker's progress, or have the Managing Intelligence start the intended work in the prepared worktrees.
