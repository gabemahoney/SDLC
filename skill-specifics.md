# Skill specifics

Rules moved from `workflow/workflow.md` at `1d606655eb4da0934fb3d666e02e210c509b8a65`, for future skill and Subagent definition drafts. Wording is carried over; table cells are split at their semicolons and labelled with their ticket. A statement that the source specifies nothing is an inventory note, not a new gate or permission. The Managing Intelligence section preserves its transitions.

## project-setup

### State gate

None specified in the source workflow.

### Owned transitions

None specified in the source workflow.

### Specific rules

None specified in the source workflow.

## write-idea

### State gate

None specified in the source workflow.

### Owned transitions

**Idea:** write-idea creates `draft`

### Specific rules

None specified in the source workflow.

## write-bug

### State gate

None specified in the source workflow.

### Owned transitions

**Bug:** write-bug or the Managing Intelligence creates `draft`, not yet validated

### Specific rules

None specified in the source workflow.

## define-bug

### State gate

Bug `draft`.

### Owned transitions

**Bug:** define-bug sets `defined` after reproducing and validating it, and sets its `thinking_level:` tag

**Bug:** define-bug sets `invalid` when the Bug is not real, with a note saying why

### Specific rules

**Tag (`thinking_level:<label>`):** define-bug sets a Bug's.

Not a real Bug; define-bug sets it with a note saying why.

## write-prd

### State gate

None specified in the source workflow.

### Owned transitions

**PRD / SRD:** write-prd / write-srd creates `draft`

**PRD / SRD:** revising a `defined` PRD or SRD sets it back to `draft`

### Specific rules

None specified in the source workflow.

## write-srd

### State gate

None specified in the source workflow.

### Owned transitions

**PRD / SRD:** write-prd / write-srd creates `draft`

**PRD / SRD:** revising a `defined` PRD or SRD sets it back to `draft`

### Specific rules

write-srd selects the parts to model, dispatches one TLA+ Writer per part in parallel, and fixes SRD bugs their models find.

## req-review

### State gate

None specified in the source workflow.

### Owned transitions

**Idea:** req-review sets `draft` → `defined` on the Managing Intelligence's yes, once its PRD and SRD are `defined`

**PRD / SRD:** req-review asks the Managing Intelligence and, on yes, sets `defined`.

**Other Doc (not PRD, SRD or TLA+ spec):** req-review asks the Managing Intelligence and, on yes, sets `defined`

### Specific rules

req-review dispatches one read-only TLA+ Reviewer per TLA+ spec Doc alongside the Requirements Reviewer, checking that the model matches the SRD and its invariants are meaningful.

## write-plan

### State gate

Idea `defined`, with a PRD and an SRD. Finish an existing Plan in `draft` or `defined`; never duplicate it.

### Owned transitions

**Plan:** write-plan creates `draft`, and sets `defined` once the Plan is written, checked and revised

**Epic:** write-plan creates `draft`, and idea-review creates a Round Feedback Epic `draft`

### Specific rules

When the PRD or SRD is not `defined`, write-plan stops and asks the Managing Intelligence to confirm planning without review, and goes on only on an explicit yes.

## write-epic

### State gate

Epic `draft`; its Plan `defined` or `active`.

### Owned transitions

**Epic:** write-epic sets `defined`

**Task:** write-epic creates `draft`, then sets `defined`

**Subtask:** write-epic creates `draft`, then sets `defined` for its Tasks

### Specific rules

**Tag (`thinking_level:<label>`):** write-epic and develop-epic set their Tasks' tags

## develop-epic

### State gate

Epic `defined` or `active`; every Epic it depends on `done`. A re-run on a `done` Epic may only finish the Plan's completion check.

### Owned transitions

**Idea:** develop-epic sets `active` when starting an Epic

**Plan:** develop-epic sets `active` when starting an Epic

**Plan:** develop-epic sets `done` when finishing an Epic leaves every Epic in the Plan `done`

**Epic:** develop-epic sets `active`, then `done`.

**Task:** develop-epic also creates integration fix Tasks `draft`, sets their `thinking_level:` tags and sets them `defined`

**Task:** develop-epic sets Tasks `active`, then `done`

**Task:** `done` requires every Subtask to be `done`.

**Subtask (context):** write-epic creates `draft`, then sets `defined` for its Tasks; develop-epic does the same for its integration fix Tasks

### Specific rules

Before each Task after the first, develop-epic checks its own context use per the Agent Protocol File. At 75% or more, or a reading older than its freshness window, stop at that Task boundary and name the re-run for a new session. The Managing Intelligence restarts it, through the Launcher for a Worker, per its Launcher Protocol File. With no reading, continue and report it.

**Tag (`thinking_level:<label>`):** write-epic and develop-epic set their Tasks' tags

## idea-review

### State gate

Plan `done`; no worktree of its Epics still unmerged.

### Owned transitions

**Plan:** idea-review sets `done` → `active` when it files a Round Feedback Epic.

**Epic:** write-plan creates `draft`, and idea-review creates a Round Feedback Epic `draft`

### Specific rules

None specified in the source workflow.

## fix-bug

### State gate

Bug `defined`, or `active` when resuming; every ticket it depends on `done`.

### Owned transitions

**Bug:** fix-bug sets `active`

### Specific rules

None specified in the source workflow.

## research

### State gate

None specified in the source workflow.

### Owned transitions

**Research ticket and Report:** research creates the Research ticket `defined`, sets it `active` during review rounds, sets it `done` when the reviewer accepts, and reopens it as `active` when a reviewer asks for more work

**Research ticket and Report:** the Report, created with the first round, carries the Research ticket's status.

### Specific rules

None specified in the source workflow.

## configure-worktree

### State gate

Idea or Epic `defined` or `active`.

### Owned transitions

None specified in the source workflow.

### Specific rules

At startup, a Run checks the `levels_<agent>` mapping for its Agent and the `thinking_levels` lines for its skill, each non-executor Subagent Role it dispatches and, for configure-worktree, its Worker's skill.

## teardown-worktree

### State gate

Merge an Idea's worktrees only once the Idea is `done`, and an Epic's only once the Epic is `done`.

### Owned transitions

None specified in the source workflow.

### Specific rules

None specified in the source workflow.

## release

### State gate

None specified in the source workflow.

### Owned transitions

None specified in the source workflow.

### Specific rules

None specified in the source workflow.

## Engineer

### State gate

None specified in the source workflow.

### Owned transitions

**Subtask:** the executor working it sets `active`, then `done`.

### Specific rules

None specified in the source workflow.

## Test Writer

### State gate

None specified in the source workflow.

### Owned transitions

**Subtask:** the executor working it sets `active`, then `done`.

### Specific rules

None specified in the source workflow.

## Doc Writer

### State gate

None specified in the source workflow.

### Owned transitions

**Subtask:** the executor working it sets `active`, then `done`.

### Specific rules

None specified in the source workflow.

## Engineer planner

### State gate

None specified in the source workflow.

### Owned transitions

None specified in the source workflow.

### Specific rules

None specified in the source workflow.

## Test Writer planner

### State gate

None specified in the source workflow.

### Owned transitions

None specified in the source workflow.

### Specific rules

None specified in the source workflow.

## Doc Writer planner

### State gate

None specified in the source workflow.

### Owned transitions

None specified in the source workflow.

### Specific rules

None specified in the source workflow.

## Code Reviewer

### State gate

None specified in the source workflow.

### Owned transitions

None specified in the source workflow.

### Specific rules

None specified in the source workflow.

## Test Reviewer

### State gate

None specified in the source workflow.

### Owned transitions

None specified in the source workflow.

### Specific rules

None specified in the source workflow.

## Doc Reviewer

### State gate

None specified in the source workflow.

### Owned transitions

None specified in the source workflow.

### Specific rules

None specified in the source workflow.

## Product Manager

### State gate

None specified in the source workflow.

### Owned transitions

None specified in the source workflow.

### Specific rules

None specified in the source workflow.

## Requirements Reviewer

### State gate

None specified in the source workflow.

### Owned transitions

None specified in the source workflow.

### Specific rules

None specified in the source workflow.

## TLA+ Writer

### State gate

None specified in the source workflow.

### Owned transitions

**TLA+ spec Doc:** the TLA+ Writer, dispatched by write-srd, creates `defined`, one Doc per modelled SRD part

**TLA+ spec Doc:** revisiting that part updates its spec and leaves it `defined`. No other transition.

### Specific rules

None specified in the source workflow.

## TLA+ Reviewer

### State gate

None specified in the source workflow.

### Owned transitions

None specified in the source workflow.

### Specific rules

None specified in the source workflow.

## Integration Tester

### State gate

None specified in the source workflow.

### Owned transitions

None specified in the source workflow.

### Specific rules

None specified in the source workflow.

## Managing Intelligence

### State gate

None specified in the source workflow.

### Owned transitions

**Idea:** the Managing Intelligence sets `done` after testing the Idea.

**Other Doc (not PRD, SRD or TLA+ spec):** The Managing Intelligence creates `draft`

**Other Doc (not PRD, SRD or TLA+ spec):** the Managing Intelligence owns other changes.

**Bug:** write-bug or the Managing Intelligence creates `draft`, not yet validated

**Bug:** the Managing Intelligence sets `done` after checking the merged fix or agreeing with the invalidity note

**Bug:** the Managing Intelligence sets it back to `draft` to send it back to define-bug.

### Specific rules

None specified in the source workflow.
