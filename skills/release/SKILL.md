---
name: release
description: "Release a Project by following its `guide:release-guide.md`, including its permissions and human approvals."
---

# release

## Purpose

You carry out the Project's release process. The Project's guide defines what releasing means and who may authorize each step.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

The release target required by the Project's guide, such as a ticket ID or version.

## Required Reading

- **Agent:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md`, for Agent instructions.
- **Guidance:** `guide:release-guide.md` and the files it points to, for the release process, permissions and approvals.

If the guide uses tickets, also read Project and default settings and `protocol:ticket.md` for ticket operations.

## Gate

Run only when the guide defines a release process. Otherwise, stop and suggest project-setup, which helps the Managing Intelligence write it.

## Steps

1. **Follow the release process.** Follow the guide's order, readiness checks and permissions. Stop at any unmet condition, because the Project controls release readiness. A step requiring human approval waits for that human's approval, because a bot acting as Managing Intelligence cannot supply it.

2. **Check the result** as the guide requires, so the report reflects what was released.

## Child Agents

None: you follow the guide yourself.

## Writes

The files, release artifacts and ticket changes specified by `guide:release-guide.md`. Ticket status transitions come from the guide because release processes differ between Projects.

## Done

Report the ID or version released, anything left incomplete, and the next step from the guide.
