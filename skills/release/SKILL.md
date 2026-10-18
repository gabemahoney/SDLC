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

- **Settings:** Project and defaults when the release guide uses tickets, for ticket configuration.
- **Protocols:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md`, for Agent instructions; the Ticket System Protocol File selected by `setting:ticket_system` when the guide uses tickets, for ticket operations.
- **Guidance:** `guide:release-guide.md` and the files it points to, for the release process, permissions and approvals.

## Gate

Run only when both of these are true:

- The Project has a release process in its guide. If it doesn't, stop and suggest project-setup, because that skill helps write the process.
- The guide's release conditions are met. If any fail, stop and report what remains, because the Project sets its own release readiness.

## Steps

1. **Follow the guide's release process.** Carry out its steps under its permissions. A step requiring a human's approval waits for that human's yes, because a bot acting as Managing Intelligence cannot supply human approval.

2. **Check the result** as the guide requires, so the report reflects what was released.

## Child Agents

None: you follow the guide yourself.

## Writes

The files, release artifacts and ticket changes specified by `guide:release-guide.md`. Ticket status transitions come from the guide because release processes differ between Projects.

## Done

Report the ID or version released, anything left incomplete, and the next step from the guide.
