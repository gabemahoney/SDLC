# Skill specifics

Remaining b.v38 draft notes: gates, owned transitions, specific reads and rules. Draft from `docs/goals.md`, `workflow/workflow.md` and today's Apiary skill and any Role it folds in. The b.v38 PRD Docs are background only; the Acceptance baseline (t1.v38.2d) holds the checks. Remove an entry once its finished skill or Role absorbs it.

## Required Reading for remaining drafts

Per-entry Required Reading names specific inputs only. Shared startup, settings, Protocol File paths, Guidance Document walks and dispatch rules are in `workflow/workflow.md`. Guidance names below mean their `.md` files loaded by that walk; `maintained-docs` also means the documents it lists. Roles use the settings and Protocol Files their dispatch prompt supplies.

**Thinking Levels (2026-10-16):** only skills that dispatch a Subagent or launch a Worker read `thinking_levels` and the relevant `levels_<agent>` mapping, before that dispatch or launch. They check the target Role or Worker's skill, not their own skill line. Whoever launches a skill sets its own level. Executors use their Task's or Bug's tag; the dispatcher maps it. No Role below dispatches or launches, so none reads thinking levels itself.

The dispatching skills are write-srd, req-review, write-plan, write-epic, develop-epic, idea-review and fix-bug. configure-worktree reads its Worker's skill line and Worker's Agent mapping only when launching, outside worktree-only mode.

## define-bug

**Required Reading:** Bug and source references; `bug-writing-guide`, `build-commands`, reproduction source, tests and configuration in the main checkouts, to validate the report.

**Gate:** Bug `draft`.

**Owned transitions:** **Bug:** define-bug sets `defined` after reproducing and validating it, and sets its `thinking_level:` tag

**Bug:** define-bug sets `invalid` when the Bug is not real, with a note saying why

**Specific rules:** Changes no tracked file. When it cannot reproduce or settle the report from source, leaves Bug `draft`, records what it tried and asks the Managing Intelligence whether it is real.

## fix-bug

**Required Reading:** Bug, dependencies, tag, progress and source references; `build-commands`, fix and merge context and Subagent reports, to fix and resume the Bug.

**Gate:** Bug `defined`, or `active` when resuming; every ticket it depends on `done`. Started inside `.worktrees/`, stops and says to run from the Project Folder.

**Owned transitions:** **Bug:** fix-bug sets `active`

**Specific rules:** Creates, commits in, merges and cleans up its own worktrees. Uses develop-epic's executor/reviewer pipeline without a Product Manager or context guard. Integration Tester handles its integration gate; source failures go through its fix round and full unit suite before a fresh integration check. Failed suites need a pass or waiver; asks when suites cannot run, a fix round does not reduce failures, or after three rounds. Leaves the Bug `active` for the Managing Intelligence's check.

## research

**Required Reading:** Question, evidence, Research ticket, Report and review log, to continue the research and its review rounds.

**Gate:** None specified.

**Owned transitions:** **Research ticket and Report:** research creates the Research ticket `defined`, sets it `active` during review rounds, sets it `done` when the reviewer accepts, and reopens it as `active` when a reviewer asks for more work

**Research ticket and Report:** the Report, created with the first round, carries the Research ticket's status.

**Specific rules:** Sets the ticket flow, not how research is done; the reviewer is the Managing Intelligence.

Research tickets filed by write-srd are researched by its Researcher and closed by write-srd, without review rounds.

## configure-worktree

**Required Reading:** Idea or Epic, repo, branch and worktree state; outside worktree-only mode, `launcher`, Launcher Protocol File, Worker prompt and its named skill, to create worktrees and launch the Worker.

**Gate:** Idea or Epic `defined` or `active`. Starts outside `.worktrees/`.

**Owned transitions:** None.

**Specific rules:** May create worktrees in several repos; defaults each base branch to the main checkout's branch. Worker starts in `.worktrees/<ticket id>/`. Worktree-only mode launches none.

## teardown-worktree

**Required Reading:** Idea or Epic, worktree, branch and merge state; outside worktree-only mode, `launcher` and Launcher Protocol File, to merge and stop the Worker.

**Gate:** Merge an Idea's worktrees only once the Idea is `done`, and an Epic's only once the Epic is `done`. Starts outside the folder it removes; before merging, stops if the Launcher reports another live Worker under that ticket's worktrees.

**Owned transitions:** None.

**Specific rules:** Merge target defaults per repo to its main checkout's branch. Commits or discards uncommitted changes only as the Managing Intelligence chooses. Stops its Worker only after every merge succeeds, then removes worktrees; worktree-only mode stops none.

## release

**Required Reading:** `release-guide` and its plain reference targets; Ticket System Protocol File only if the guide uses tickets.

**Gate:** Follows the conditions in `release-guide.md`; stops without a release process.

**Owned transitions:** Ticket changes come from `release-guide.md`.

**Specific rules:** A human step requires a human's yes.

## Engineer

**Required Reading:** Assigned Subtasks or Bug, source context and handed-off findings; `engineering-best-practices`, `build-commands`.

**Gate:** None specified.

**Owned transitions:** **Subtask:** the executor working it sets `active`, then `done`.

**Specific rules:** Writes code; report flags changes affecting design or docs for Doc Writer. Never commit.

## Test Writer

**Required Reading:** Assigned Subtasks or Bug, tests, fixtures and source changes; `test-guide`, `build-commands`.

**Gate:** None specified.

**Owned transitions:** **Subtask:** the executor working it sets `active`, then `done`.

**Specific rules:** Unit tests only. Each lane changes its own files and exclusively used fixtures/helpers; last Test Writer makes needed shared changes and runs the full unit suite in each changed repo. For a Bug, adds a unit test failing before and passing after the fix. Never commit.

## Doc Writer

**Required Reading:** Assigned Subtasks or Bug, source/test diff and Engineer report; `doc-writing-guide`, `maintained-docs`.

**Gate:** None specified.

**Owned transitions:** **Subtask:** the executor working it sets `active`, then `done`.

**Specific rules:** Writes user-facing, contributor and design docs from the diff and Engineer report. Never commit.

## Engineer planner

**Required Reading:** Proposed Task, Epic, Idea requirements, repo context and Managing Intelligence decisions from dispatch; `engineering-best-practices`.

**Gate:** None specified.

**Owned transitions:** None.

**Specific rules:** Proposes code Subtasks to write-epic. Edit no files, change no tickets, never commit.

## Test Writer planner

**Required Reading:** Proposed Task and requirements from dispatch, tests and fixtures; `test-guide`.

**Gate:** None specified.

**Owned transitions:** None.

**Specific rules:** Proposes unit-test Subtasks and Test Writer lanes to write-epic. Edit no files, change no tickets, never commit.

## Doc Writer planner

**Required Reading:** Proposed Task and requirements from dispatch, product context; `doc-writing-guide`, `maintained-docs`.

**Gate:** None specified.

**Owned transitions:** None.

**Specific rules:** Proposes doc Subtasks to write-epic. Edit no files, change no tickets, never commit.

## Code Reviewer

**Required Reading:** Task, Idea or Bug review scope, source changes and context; `engineering-best-practices`, `build-commands`.

**Gate:** None specified.

**Owned transitions:** None.

**Specific rules:** Reviews source changes with lint findings. Edit no files, change no tickets, never commit.

## Test Reviewer

**Required Reading:** Task, Idea or Bug review scope, test changes and whole suite; `test-guide`.

**Gate:** None specified.

**Owned transitions:** None.

**Specific rules:** Reviews tests against the whole suite without running it. Edit no files, change no tickets, never commit.

## Doc Reviewer

**Required Reading:** Task, Idea or Bug review scope, product changes and complete touched docs; `doc-writing-guide`, `maintained-docs`.

**Gate:** None specified.

**Owned transitions:** None.

**Specific rules:** Re-reads touched docs in full, flagging breaches anywhere and docs made wrong or left missing. Edit no files, change no tickets, never commit.

## Product Manager

**Required Reading:** Idea requirements, planned work, product changes and recorded commits; no Guidance Documents.

**Gate:** None specified.

**Owned transitions:** None.

**Specific rules:** Checks the product, scope and proportion for every Plan, Epic's planned Tasks/Subtasks, completed Task, end-of-Epic and finished Idea. Edit no files, change no tickets, never commit.

## Researcher

**Required Reading:** The question, why the SRD needs it, the Idea, SRD and Research ticket supplied by write-srd, and relevant sources, to ground the answer; no Guidance Documents.

**Gate:** None specified.

**Owned transitions:** Creates the Research ticket's Report child `defined` with a cited answer.

**Specific rules:** Dispatched by write-srd to answer one research question and report back with its cited Report. It may use any research skill its Agent provides, as its Agent Protocol File describes. Its investigation is read-only: it changes no code and no ticket other than its Report. Never commit.

## TLA+ Writer

**Required Reading:** Assigned SRD part, existing spec, model files and checker output; `build-commands` for Model check.

**Gate:** None specified.

**Owned transitions:** **TLA+ spec Doc:** the TLA+ Writer, dispatched by write-srd, creates `defined`, one Doc per modelled SRD part

**TLA+ spec Doc:** revisiting that part updates its spec and leaves it `defined`. No other transition.

**Specific rules:** Attaches the model files (`.tla`, `.cfg`) to its TLA+ spec Doc as the Ticket System Protocol File describes, and runs the checker on them there; they never go in a repo. Dispatched by write-srd to write the assigned part's model without running it. Resumed to fix review findings or update the model after an SRD change, then to run the Project's Model check command from `build-commands.md` once review has no findings. Returns the spec, checker results and SRD findings to write-srd. Never commit.

## TLA+ Reviewer

**Required Reading:** Assigned TLA+ spec and SRD; no Guidance Documents.

**Gate:** None specified.

**Owned transitions:** None.

**Specific rules:** Dispatched fresh by write-srd for each model after writing or fixes, before each checker run. Checks that the model matches the SRD and its invariants are meaningful; returns findings with references and suggested fixes, or no findings. Edit no files, change no tickets, never commit.

## Integration Tester

**Required Reading:** Gated changes, changed repo checkouts and earlier results from dispatch; integration tests and interfaces, `test-guide`, `build-commands`.

**Gate:** None specified.

**Owned transitions:** None.

**Specific rules:** Writes and runs integration tests, fixes test-caused failures without editing source, and reports pass, source failure, cannot run or no suites found. Works no Subtasks. Never commit.

## Managing Intelligence

**Gate:** None specified.

**Owned transitions:** **Idea:** the Managing Intelligence sets `done` after testing the Idea.

**Other Doc (not PRD, SRD or TLA+ spec):** The Managing Intelligence creates `draft`

**Other Doc (not PRD, SRD or TLA+ spec):** the Managing Intelligence owns other changes.

**Bug:** write-bug or the Managing Intelligence creates `draft`, not yet validated

**Bug:** the Managing Intelligence sets `done` after checking the merged fix or agreeing with the invalidity note

**Bug:** the Managing Intelligence sets it back to `draft` to send it back to define-bug.

## Executor rules for fix-bug

Fold these into fix-bug when it is written, and define "lane" there. develop-epic now holds its executor rules.


A Subagent loads the Guidance Documents of each repo it works in and may read any repo for context.

**Fresh start:** a new dispatch with no earlier context.

**Reuse:** resume the same Subagent for its Bug. Keep its Guidance Documents. Add the Guidance Documents of any newly assigned repos.

- **Executors (Engineer, Test Writer, Doc Writer):** dispatch one Engineer, one Doc Writer and one Test Writer per lane for the Bug. Every source-changing pass has a Test Writer. Fix rounds reuse only the executors whose work the findings touch. The next Bug starts fresh executors.
- **Code, Test and Doc Reviewers and Integration Tester:** start fresh on every dispatch.

#### Replacing an executor

Resume the executor for each fix round. If the executor can't continue, start a fresh executor with the findings and the work so far.

#### Handoff

Subagents never talk to each other. The skill coordinates them: it reads each Subagent's report and passes what the next one needs in that one's dispatch or resume message. The work itself passes through the files: each Subagent sees the changes earlier ones made in its checkouts.

#### Progress record

On the skill's ticket, record each Subagent kept for reuse: its Subagent Role, its Bug, its ID from the Agent, its name if available, and its dispatch Thinking Level.

Update the record after each report. After compaction or a re-run, use the record to resume each Subagent by name if available, otherwise by ID.

