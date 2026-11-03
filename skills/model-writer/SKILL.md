---
name: model-writer
description: "Model an SR group for write-srd, or run one Model Doc's during-build checks. Takes an SRD ID and any Model Doc ID."
---

# model-writer

## Purpose

You build models and run gating checks as write-srd's Child Agent; as a Main Agent, run one Doc's during-build checks.

## Loading SDLC

Read `~/.sdlc/install/workflow.md` first for shared rules, settings and file locations.

## Input

An SRD ID and a Model Doc ID (required as a Main Agent).

## Required Reading

- **Launcher:** `protocol:launcher.md` as a Child Agent, for reporting.
- **Protocols:** `protocol:ticket.md` and your Agent Protocol File, for records and execution.
- **Assignment:** the SRD and existing Model Doc, for promises and repairs.
- **Settings:** Project and defaults as a Main Agent, for configuration.
- **Guidance:** `guide:build-commands.md ## Model check` for language, commands and caps; `guide:test-guide.md` for modelling practices, following them where it has them and otherwise recording your own choice and reason in the Model Doc, because a Project's own guide may have none.

## Gate

As a Child Agent, require a `draft` SRD and any existing Model Doc `defined`, because construction develops requirements. As a Main Agent, require both `defined`, because during-build checks test approved requirements. Otherwise stop and report the status.

## Steps

As a Main Agent, do only step 3, because write-srd coordinates repairs.

1. **Size the SR group.** Tabulate every independently falsifiable clause, including qualifications and exceptions, with SRD source, events, outcomes, assertions and controls, because invariant names hide omissions. Classify by the workflow and justify minimal bounds covering actors, faults, races and data relationships, including two racing peers, because runtime cannot set scope. Establish a history mapping and estimate composed states and invocation/suite time ranges from retained dimensions and interactions, counting partitions, fingerprints and concurrency; use only minimal reviewed probes for unknown growth/throughput, because kernels expose costs late. If history coverage or credible estimates are missing, upper forecasts exceed the cap, or gates cannot finish in hours, stop before kernel construction and return a decomposition naming clause allocation, component assumptions/guarantees, cross-component races and costs for the caller to choose, because partial models leave gaps.
2. **Finish one clause before expanding.** At those bounds, close its source event, returned/durable outcomes, independent assertion and inspected controls before adding another interacting mechanism, because skeletons hide missing endpoints. Retain bounds and reductions; measure each change separately from repairs, because bundled changes hide multipliers. If an exhaustive invocation exceeds two minutes of checker process wall time, freeze expansion until same-case reduction or complete partitions restore invocations below two minutes, because expansion compounds cost; only the configured cap stops execution. Measure slow partitions and reconcile whole-suite forecasts before expanding, because short partitions can still multiply work.
3. **Run reviewed work when asked.** As a Child Agent, expect your Main Agent to obtain scoped model-review before diagnostics for changes to behaviour, clauses, assertions, controls, bounds or reductions (rerun mechanical fixes unreviewed), and whole-group review closing gating rows before gates, with repairs fixed, because open clauses need resolution. During-build checks await the Managing Intelligence, except write-srd's revision reruns, so coding can proceed.
   - Parse exact attachments first; stop if the parse-only command is missing, because broken packages fail cheaply.
   - Refresh forecasts from measured growth/throughput before full-size runs; refuse over-cap upper forecasts or gates beyond hours and return proposals as for a capped run, because composition can invalidate estimates.
   - Cap each invocation, including partitions and any fingerprint reruns, as configured; gating defaults to 30 minutes, never over one hour, because overlong gates are model defects. Budget batches for summed upper forecasts plus overhead, because they need their own wall budget.
   - After one capped invocation or batch, stop model work, cancel owned siblings, explain growth and return reduction, partitioning, during-build or cap proposals; resume only after the caller chooses, with longer caps approved by the Managing Intelligence within workflow limits, because retrying repeats the defect.
   - Pass only clauses with closed coverage and all required cases finished against the current SRD/model, because partial exploration leaves obligations open; a capped invocation passes nothing.

## Child Agents

None: you own construction and execution.

## Writes

Maintain one `defined` Model Doc per SR group, writing only it and attachments outside repos, so models stay with requirements. For durable handoffs:

- `## Model`: SR group and model.
- `## Modelling assumptions`: bounds, reductions, history mapping and reasons, distinct from product limits.
- `## Artifacts`: files and logs.
- `## Progress`: repairs, deviations with reasons, unfinished coverage, unresolved findings with reasons and effects on other work; leave `## Declined findings` to write-srd, because it judges review findings.
- `## Checks`: clause/phase table with reasons; SRD/model versions, forecasts, measurements, controls, completion, capped runs, unreached checks and violations.

## Retrospective notes (as a Main Agent)

While you work, note under `## Retrospective notes` on your ticket, with evidence, your answers to these questions, because the Managing Intelligence builds the bee's retrospective from them:

- Where did we introduce a quality issue? How could it have been avoided?
- Where did we spend too much time and not gain value? How could it have been avoided?
- Where did we spend too many tokens and not gain value? How could it have been avoided?

## Done

Report the Model Doc ID, violations, unresolved work, reasons and questions through `protocol:launcher.md` to your Main Agent, or to the Managing Intelligence as a Main Agent, so the caller can continue. Distinguish model from design errors and route violations through write-srd, because during-build failures need revision, not Bugs.
