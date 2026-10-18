---
name: model-review
description: "Review a Formal Model against its SRD and return findings. Takes Model Doc and SRD IDs."
---

# model-review

## Purpose

You review a Formal Model against its SRD for write-srd before its checker runs.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

A Model Doc ID and its SRD ID.

## Required Reading

- **Launcher:** `protocol:launcher.md`, for how you work as a Child Agent and report to your Main Agent.
- **Protocols:** Read `protocol:ticket.md` and your supplied Agent Protocol File for ticket access and Agent rules.
- **Your Model Doc and SRD:** for the model, requirements, assumptions and repair instructions.
- **Guidance:** Read `guide:build-commands.md ## Model check` for the configured modelling language and checker.

Also read the Project's code, tests and any linked Research tickets as the work needs.

## Gate

Run only when your Model Doc is `defined`, because review needs a written model. Otherwise, stop and report its status.

## Steps

1. **Review the Formal Model in your Model Doc.** Check that it matches the SR group it models, can expose the ordering bugs it's meant to catch, and keeps modelling assumptions separate from real product limits. Review by reading it; don't run the checker, because model-writer runs it once your accepted findings are fixed.

## Child Agents

None: you perform the independent review yourself.

## Writes

None: keep files and tickets unchanged, because model-writer owns repairs and your Main Agent records declined findings.

## Done

Report the Model Doc ID, findings with references and suggested fixes, or no findings, and review limitations to your Main Agent as `protocol:launcher.md` describes.

## Review judgement

Your job is to hold the model strictly to the SRD: report every place it doesn't match, however small, because your Main Agent decides which findings are worth fixing.

Tag every finding with one level, so your Main Agent can weigh it:

- **blocker:** the model doesn't match the SRD or can't expose an error it is meant to find.
- **suggestion:** it's hard to understand or maintain: duplicated or needlessly complex.
- **nit:** it's a matter of style, such as naming or formatting.
