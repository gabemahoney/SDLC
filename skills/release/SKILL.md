---
name: release
description: "Release accepted, merged Ideas and Bugs by following the Project's `guide:release-guide.md`, including its permissions and human approvals. Takes Idea and Bug IDs."
---

# release

## Purpose

You carry out the Project's release process. The Project's guide defines what releasing means and who may authorize each step.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

The IDs of the Ideas and Bugs to release, chosen by the Managing Intelligence, plus anything else the Project's guide requires, such as a version.

## Required Reading

- **Agent:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md`, for Agent instructions.
- **Settings and protocol:** Project and default settings, and `protocol:ticket.md`, for ticket operations.
- **The Ideas and Bugs:** their status and `## Worktrees` records, for the Gate.
- **Guidance:** `guide:release-guide.md` and the files it points to, for the release process, permissions and approvals.

## Gate

Run only when all of these are true:

- The guide defines a release process. Otherwise, stop and suggest project-setup, which helps the Managing Intelligence write it.
- Each Idea and Bug is `done`, because only accepted work ships. Otherwise, stop and name the ones the Managing Intelligence hasn't accepted.
- Each one's `## Worktrees` record shows every repo merged and its worktrees removed, because unmerged work isn't in the release. Otherwise, stop and tell the Managing Intelligence which ones aren't, suggesting teardown-worktree for an Idea.
- Each main checkout in those records is on the branch the guide releases from, with no uncommitted changes to tracked files, so the release holds only merged work. Otherwise, stop and tell the Managing Intelligence which ones aren't.

## Steps

1. **Follow the release process** in the guide's order, with its readiness checks and permissions. Stop at any unmet condition, because the Project controls release readiness. For a step that needs a named human's approval, stop and ask the Managing Intelligence to get it, and continue only on that human's answer, because a bot acting as Managing Intelligence can't give it.

2. **Check the result** as the guide requires, so the report reflects what was released.

## Child Agents

None: you follow the guide yourself.

## Writes

The files, release artifacts and ticket changes specified by `guide:release-guide.md`. Leave Idea and Bug statuses unchanged, because the Managing Intelligence owns them.

## Done

Report the version released, the Idea and Bug IDs it includes, anything left incomplete, and the next step from the guide.
