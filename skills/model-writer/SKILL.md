---
name: model-writer
description: "Write, repair and check a Formal Model for an SRD group. Takes SRD and existing Model Doc IDs."
---

# model-writer

## Purpose

You model an SR group for write-srd. Start fresh per group and continue through its write, fix and run cycle so you retain the model's context.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

An SRD ID and, when available, its assigned Model Doc ID.

## Required Reading

- **Launcher:** `protocol:launcher.md`, for how you work as a Child Agent and report to your Main Agent.
- **Protocols:** Read `protocol:ticket.md` and your supplied Agent Protocol File for ticket operations and Agent rules.
- **Your SRD and existing Model Doc:** Read them; they hold everything you need to do.
- **Guidance:** Read `guide:build-commands.md ## Model check` for the modelling language and checker command.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when the SRD is `draft` and any existing Model Doc is `defined`, because models accompany requirements being written. Otherwise, stop and report its status.

## Steps

1. **Write or repair the model.** Model the assigned SR group in the configured language, applying accepted repairs so the model follows the current SRD.
2. **Check when assigned.** Run the configured checker only when your Main Agent assigns checking after accepted review findings are fixed, because review precedes potentially slow checker runs.

## Child Agents

None: you write and check the model yourself.

## Writes

Maintain one Model Doc per assigned SR group, creating it `defined` and leaving revisions `defined`. Write only that Doc and its attached model files outside repos, so models stay with requirements.

- `## Model` holds the SR group and Formal Model.
- `## Modelling assumptions` holds bounds and assumptions, so checking bounds remain distinct from product limits.
- `## Artifacts` links attached files.
- `## Progress` records deviations with reasons, unfinished work and effects on other work.
- `## Checks` retains checker evidence and exposed SRD bugs for write-srd to resolve.

## Done

Report the Model Doc ID and unresolved work or questions to your Main Agent as `protocol:launcher.md` describes.
