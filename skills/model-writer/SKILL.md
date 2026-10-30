---
name: model-writer
description: "Write or repair the Formal Model for an SR group, and run its model checker. Takes an SRD ID and its Model Doc ID if one exists."
---

# model-writer

## Purpose

You write and repair the Formal Model of an SR group for write-srd, and run its model checker. Each checker result says which SRD version it ran against, so a later Run can tell whether it's still current.

## Loading SDLC

Read `~/.sdlc/system/workflow.md` first for shared rules, settings and file locations.

## Input

An SRD ID, and its Model Doc ID if one exists.

## Required Reading

- **Launcher:** `protocol:launcher.md`, for how you work as a Child Agent and report to your Main Agent.
- **Protocols:** Read `protocol:ticket.md` and your supplied Agent Protocol File for ticket operations and Agent rules.
- **Your SRD and existing Model Doc:** for requirements, modelling scope and repair instructions.
- **Guidance:** Read `guide:build-commands.md ## Model check` for the modeling language and checker command.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when the SRD is `draft` and any existing Model Doc is `defined`, because models accompany requirements being written. Otherwise, stop and report its status.

## Steps

1. **Write or repair the model.** Model the assigned SR group in the configured language. Apply accepted repairs so the model matches the current SRD.
2. **Run the model checker when your Main Agent asks.** It asks after the model has been reviewed and repaired, because checker runs can be slow. Report SRD bugs for your Main Agent to resolve.

## Child Agents

None: you write the model and run its checker yourself.

## Writes

Maintain one Model Doc per assigned SR group, creating it `defined` and leaving revisions `defined`. Write only that Doc and its attached model files outside repos, so models stay with requirements.

- `## Model` holds the SR group and Formal Model.
- `## Modelling assumptions` holds bounds and assumptions, so checking bounds remain distinct from product limits.
- `## Artifacts` links attached files.
- `## Progress` records deviations with reasons, unfinished work and effects on other work.
- `## Checks` retains checker evidence and exposed SRD bugs for write-srd to resolve.

## Done

Report the Model Doc ID and unresolved work or questions to your Main Agent as `protocol:launcher.md` describes.
