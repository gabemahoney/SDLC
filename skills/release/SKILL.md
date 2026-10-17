---
name: release
description: "Release a Project by following its `guide:release-guide.md`, including its permissions and human approvals."
---

# release

## Purpose

Carries out the Project's release process. The Project's guide defines what releasing means and who may authorize each step.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

The release target required by the Project's guide, such as a ticket ID or version.

## Required Reading

- **Release guidance:** `guide:release-guide.md`, found as `~/.apiary/system/workflow.md` describes, and the files it points to. Why: to follow the Project's release process, permissions and approvals.
- **Agent Protocol File:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md` under `~/.apiary/system/protocols/`, for the Main Agent's own context readings and skill invocation.

If the guide uses tickets, read `<Project Folder>/.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`, and the Ticket System Protocol File `protocol:ticket-<ticket_system>.md` selected by `setting:ticket_system`, so ticket changes use the Project's ticket system.

## Gate

Run only when both of these are true:

- The Project has a release process in its guide. If it doesn't, stop and suggest project-setup, because that skill helps write the process.
- The guide's release conditions are met. If any fail, stop and report what remains, because the Project sets its own release readiness.

## Steps

1. **Follow the guide's release process.** Carry out its steps under its permissions. A step requiring a human's approval waits for that human's yes, because a bot acting as Managing Intelligence cannot supply human approval.

2. **Check the result** as the guide requires, so the report reflects what was released.

## Child Agents

None: release follows the guide itself.

## Writes

The files, release artifacts and ticket changes specified by `guide:release-guide.md`. Ticket status transitions come from the guide because release processes differ between Projects.

## Done

Report the ID or version released, anything left incomplete, and the next step from the guide.
