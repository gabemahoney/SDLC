# Apiary workflow

Read this shared rulebook at the start of each skill run.

## Stores and ticket terms

Stores are flat; none is nested in another.

| Store | Top-level ticket | Child tiers |
|---|---|---|
| Ideas | Idea | Doc |
| Plans | Plan | Epic → Task → Subtask |
| Bugs | Bug | None |
| Research | Research ticket | Report |

An Idea is a piece of work; a Bug is a defect to validate and fix. A Plan divides an Idea into Epics, an Epic into Tasks (each committed in one go), and a Task into Subtasks (each one executor's part). A Doc describes an Idea: its PRD (what and why), SRD (what the software must do), TLA+ spec (a model-checked design), or another document. A Research ticket holds a research question; its one Report holds the answer. A Report is not a Doc.

## Statuses and tags

Set and read only these statuses, in every store:

| Status | Meaning |
|---|---|
| `draft` | Not fully written up. |
| `defined` | Fully written up. |
| `active` | Work in progress. |
| `done` | Complete. |

All status transitions are idempotent.

- `level:<label>`: one Thinking Level tag per ticket.
- `invalid`: define-bug sets it on a Bug that is not real, with a note explaining why.

## Status Ownership

Each automatic transition has exactly one owner. Change only the tickets and statuses assigned to your skill by its Doc and this table.

| Ticket | Transitions and owners |
|---|---|
| Idea | **I1:** write-idea creates `draft`. **I2:** req-review sets `draft` → `defined` on the Managing Intelligence's yes, once every Doc child is `defined`. **I3:** develop-epic sets `active` when starting an Epic. **I4:** the Managing Intelligence sets `done` after testing the Idea. |
| PRD / SRD | **D1:** write-prd / write-srd creates `draft`; revising a `defined` PRD or SRD sets it back to `draft`. **D2:** req-review asks the Managing Intelligence and, on yes, sets `defined`. |
| Other Doc (not PRD, SRD or TLA+ spec) | **D3:** the Managing Intelligence creates `draft` and owns changes other than D4. **D4:** req-review asks the Managing Intelligence and, on yes, sets `defined`. |
| TLA+ spec Doc | **D5:** tla-plus creates `defined`; a re-run updates it and leaves it `defined`. No other transition. |
| Plan | **P1–P2:** write-plan creates `draft`, then sets `defined`. **P3:** develop-epic sets `active` when starting an Epic. **P4:** develop-epic sets `done` when finishing an Epic leaves every Epic in the Plan `done`. |
| Epic | **E1:** write-plan creates `draft`. **E2:** write-epic sets `defined`. **E3–E4:** develop-epic sets `active`, then `done`. |
| Task | **T1–T2:** write-epic creates `draft`, then sets `defined`. **T3–T4:** develop-epic sets `active`, then `done`; `done` requires every Subtask to be `done`. |
| Subtask | **S1–S2:** write-epic creates `draft`, then sets `defined`. **S3–S4:** the executor working it sets `active`, then `done`. |
| Bug | **B1:** write-bug or the Managing Intelligence creates `draft`, not yet validated. **B2:** define-bug sets `defined` after reproducing and validating it, and sets its `level:` tag. **B3:** define-bug leaves a Bug that is not real `draft`, tags it `invalid`, and notes why, awaiting the Managing Intelligence. **B4:** fix-bug sets `active`. **B5:** the Managing Intelligence sets `done` after checking the merged fix or agreeing with the invalidity note. **B6:** the Managing Intelligence sets it back to `draft`, or removes `invalid`, to send it back to define-bug. |
| Research ticket and Report | **R1–R4:** research creates the Research ticket `defined`, sets it `active` during review rounds, sets it `done` when the reviewer accepts, and reopens it as `active` when a reviewer asks for more work. **R5:** research makes its Report mirror its status. |

## Flows

**Idea:** write-idea → write-prd and write-srd → req-review → write-plan → write-epic for each Epic → develop-epic for each Epic → idea-review → the Managing Intelligence's testing. idea-review checks the whole Idea without changing statuses.

An Idea has at most one each of the Docs titled `PRD`, `SRD` and `TLA+ spec`; the writing skill updates an existing one. Docs and req-review are optional: the Managing Intelligence may mark an Idea `defined` and proceed to write-plan.

**Bug:** write-bug → define-bug → fix-bug → the Managing Intelligence checks the merged fix. A Bug tagged `invalid` awaits the Managing Intelligence's agreement to close it or removal of the tag to return it to define-bug. Sending a fix back also returns the Bug to define-bug, as `draft`.

**Research:** research files the Research ticket, runs review rounds through acceptance, and reopens it for further reviewer requests; the Report follows it throughout.

## State gates

Enforce your skill's gate before changing anything. If it fails, change nothing and say why.

| Skill | Gate |
|---|---|
| write-plan | Idea `defined`. Finish an existing Plan in `draft` or `defined`; never duplicate it. |
| write-epic | Epic `draft`; its Plan `defined` or `active`. |
| develop-epic | Epic `defined` or `active`; every Epic it depends on `done`. |
| idea-review | Plan `done`; no worktree of its Epics still unmerged. |
| define-bug | Bug `draft` and not tagged `invalid`. |
| fix-bug | Bug `defined`, or `active` when resuming; every ticket it depends on `done`. |
| configure-worktree | Idea or Epic `defined` or `active`. |
| teardown-worktree | Merge an Idea's worktrees only once the Idea is `done`, and an Epic's only once the Epic is `done`. |

## Source references

A source reference is a link stored on a ticket to something outside the ticket system that the ticket came from. The ticket system stores only the link; Apiary resolves and reads it. Resolve GitHub links through the GitHub CLI, file paths by reading the file, and ticket IDs through the ticket system. Use your ticket's source references as context when present; work without them when absent.

## Questions, stops and next steps

When a skill or Subagent needs an answer or cannot continue, stop and explain why in its output. Give all questions you can ask at once, numbered in plain text, each with its options, or state what must be fixed. Whoever started the run—the Managing Intelligence, or the skill or Subagent above it—reads the output and decides. Never continue with missing or ambiguous information.

The Managing Intelligence answers in the session (through the Launcher for a Worker), or by re-running the skill with answers. A re-run with answers continues the work.

End every skill with its Doc's listed next-step suggestion.
