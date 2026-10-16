# Skill specifics

Remaining b.v38 draft notes: gates, owned transitions, specific reads and rules. Draft from `docs/goals.md`, `workflow/workflow.md` and today's Apiary skill and any Role it folds in. The b.v38 PRD Docs are background only; the Acceptance baseline (t1.v38.2d) holds the checks. Remove an entry once its finished skill or Role absorbs it.

## Reads for remaining drafts

Per-entry Reads name specific inputs only. Shared startup, settings, Protocol File paths, Guidance Document walks and dispatch rules are in `workflow/workflow.md`. Guidance names below mean their `.md` files loaded by that walk; `maintained-docs` also means the documents it lists. Roles use the settings and Protocol Files their dispatch prompt supplies.

**Thinking Levels (2026-10-16):** only skills that dispatch a Subagent or launch a Worker read `thinking_levels` and the relevant `levels_<agent>` mapping, before that dispatch or launch. They check the target Role or Worker's skill, not their own skill line. Whoever launches a skill sets its own level. Executors use their Task's or Bug's tag; the dispatcher maps it. No Role below dispatches or launches, so none reads thinking levels itself.

The dispatching skills are write-srd, req-review, write-plan, write-epic, develop-epic, idea-review and fix-bug. configure-worktree reads its Worker's skill line and Worker's Agent mapping only when launching, outside worktree-only mode.

## write-bug

**Reads:** `new_bug_intake`, supplied input and `bug-writing-guide`, to file the report.

**Gate:** None specified.

**Owned transitions:** Creates Bug `draft`, not yet validated.

**Specific rules:** Follows the selected intake and writes what the input gives; define-bug fills the write-up from a source reference.

## define-bug

**Reads:** Bug and source references; `bug-writing-guide`, `build-commands`, reproduction source, tests and configuration in the main checkouts, to validate the report.

**Gate:** Bug `draft`.

**Owned transitions:** **Bug:** define-bug sets `defined` after reproducing and validating it, and sets its `thinking_level:` tag

**Bug:** define-bug sets `invalid` when the Bug is not real, with a note saying why

**Specific rules:** Changes no tracked file. When it cannot reproduce or settle the report from source, leaves Bug `draft`, records what it tried and asks the Managing Intelligence whether it is real.

## req-review

**Reads:** Idea and every Doc child; Requirements Reviewer and TLA+ Reviewer reports, to report findings and ready Docs.

**Gate:** None specified.

**Owned transitions:** **Idea:** req-review sets `draft` → `defined` on the Managing Intelligence's yes, once its PRD and SRD are `defined`

**PRD / SRD:** req-review asks the Managing Intelligence and, on yes, sets `defined`.

**Other Doc (not PRD, SRD or TLA+ spec):** req-review asks the Managing Intelligence and, on yes, sets `defined`

**Two modes:** with no SRD yet, it reviews the PRD alone and loops with write-prd until the Managing Intelligence approves, then sets the PRD `defined`. Once the SRD exists, it reviews the PRD and SRD together (they agree, and the SRD covers every PRD acceptance criterion) and loops with write-srd, or write-prd if the PRD must change, until approval; then it sets the SRD and the Idea `defined`.

**Specific rules:** req-review dispatches one read-only TLA+ Reviewer per TLA+ spec Doc alongside the Requirements Reviewer, checking that the model matches the SRD and its invariants are meaningful.

## write-plan

**Reads:** Idea, requirements Docs, source references, existing Plan and Epics; `engineering-best-practices`, `test-guide`, `doc-writing-guide`, `maintained-docs`, planning context and Product Manager report, to plan and revise the work.

**Gate:** Idea `defined`, with a PRD and an SRD. Finish an existing Plan in `draft` or `defined`; never duplicate it. A Plan write-srd reset to `draft` is revised against the changed SRD: `done` Epics stay done; the rest are revised, added or dropped; then the Plan is set `defined` again, or `active` if any Epic is `done` or `active`.

**Owned transitions:** Creates Plan and Epics `draft`; sets Plan `defined` once written, checked by the Product Manager and revised.

**Specific rules:** When the PRD or SRD is not `defined`, stops and asks the Managing Intelligence to confirm planning without review, and goes on only on an explicit yes. Stops after the Plan and Epics; suggests write-epic on each `draft` Epic in dependency order.

## write-epic

**Reads:** Epic, Plan, sibling Epics, Idea requirements and source references; proposed Key Files and interfaces, planner reports and Managing Intelligence answers. Without a planner, its guidance: `engineering-best-practices` for Engineer; `test-guide` for Test Writer; `doc-writing-guide` and `maintained-docs` for Doc Writer.

**Gate:** Epic `draft`; its Plan `defined` or `active`.

**Owned transitions:** Creates Tasks and Subtasks `draft`; after the Product Manager's check and revision, sets them, then Epic, `defined`.

**Specific rules:** Plans the test fixtures (moved from the SRD, 2026-10-16): which existing fixtures, factories, helpers and constants tests reuse, what they need for this change, which new fixtures are needed and where, and which test files to extend or add, so tests don't hand-roll shared setup. Sets its Tasks' `thinking_level:` tags. Dispatches executor planners where useful. Records suggested Test Writer lanes and flags Tasks changing interfaces for integration checks. Each Subtask names its executor, scope, acceptance criteria and concrete Key Files from a named repo's root; Managing Intelligence decisions are carried word for word.

## develop-epic

**Reads:** Epic work, dependencies, Idea requirements, progress and findings; `build-commands`, checkout state, changes, Subagent reports and its own context reading, to execute and resume Tasks.

**Gate:** Epic `defined` or `active`; every Epic it depends on `done`; its Plan `defined` or `active`. Re-check the Plan before each Task and stop cleanly if it went back to `draft`. A re-run on a `done` Epic may only finish the Plan's completion check.

**Owned transitions:** **Idea:** develop-epic sets `active` when starting an Epic

**Plan:** develop-epic sets `active` when starting an Epic

**Plan:** develop-epic sets `done` when finishing an Epic leaves every Epic in the Plan `done`

**Epic:** develop-epic sets `active`, then `done`.

**Task:** develop-epic also creates integration fix Tasks `draft`, sets their `thinking_level:` tags and sets them `defined`

**Task:** develop-epic sets Tasks `active`, then `done`

**Task:** `done` requires every Subtask to be `done`.

**Subtask:** creates `draft`, then sets `defined` for its integration fix Tasks

**Specific rules:** Before each Task after the first, develop-epic checks its own context use per the Agent Protocol File. At 75% or more, or a reading older than its freshness window, stop at that Task boundary and name the re-run for a new session. The Managing Intelligence restarts it, through the Launcher for a Worker, per its Launcher Protocol File. With no reading, continue and report it.

The Code Reviewer starts after the Engineer, while Test Writers work; Test Reviewer after Test Writers when tests changed, while Doc Writer works; Doc Reviewer after Doc Writer; Product Manager last. Collects all findings before one fix round, resuming each affected executor once; re-reviews changed work with the same pipeline.

Dispatches Integration Tester after flagged Tasks and the last Task. Flagged Task and Epic wait for a pass or Managing Intelligence waiver. Source failures become fix Tasks in the same Epic, grouped and tagged by develop-epic, with the full Task review pipeline and no Product Manager plan check. Re-runs Integration Tester; a failure an earlier fix Task was meant to fix that still stands stops for the Managing Intelligence.

Gets the Product Manager's end-of-Epic check after integration; records its report without making it a blocker. Records commits, integration results and unacted-on review feedback on the Epic.

## idea-review

**Reads:** Idea requirements, Plan and Epics, round progress and earlier feedback; `build-commands`, finished product, recorded commits and review reports, to check the whole Idea.

**Gate:** Plan `done`; no worktree of its Epics still unmerged.

**Owned transitions:** Creates a Round Feedback Epic `draft`; sets Plan `done` → `active` when filing it.

**Specific rules:** Each round dispatches Code, Test and Doc Reviewers and Product Manager, and demonstrates acceptance criteria. Has no executors. Files all unmet requirements/acceptance criteria and real defects as one `Round <N> Feedback` Epic without asking. A trivial-only round files nothing and lists findings in its final report. A finding an earlier feedback Epic was meant to fix that still stands stops for the Managing Intelligence. Problems outside the Idea are report suggestions for write-bug or write-idea.

## fix-bug

**Reads:** Bug, dependencies, tag, progress and source references; `build-commands`, fix and merge context and Subagent reports, to fix and resume the Bug.

**Gate:** Bug `defined`, or `active` when resuming; every ticket it depends on `done`. Started inside `.worktrees/`, stops and says to run from the Project Folder.

**Owned transitions:** **Bug:** fix-bug sets `active`

**Specific rules:** Creates, commits in, merges and cleans up its own worktrees. Uses develop-epic's executor/reviewer pipeline without a Product Manager or context guard. Integration Tester handles its integration gate; source failures go through its fix round and full unit suite before a fresh integration check. Failed suites need a pass or waiver; asks when suites cannot run, a fix round does not reduce failures, or after three rounds. Leaves the Bug `active` for the Managing Intelligence's check.

## research

**Reads:** Question, evidence, Research ticket, Report and review log, to continue the research and its review rounds.

**Gate:** None specified.

**Owned transitions:** **Research ticket and Report:** research creates the Research ticket `defined`, sets it `active` during review rounds, sets it `done` when the reviewer accepts, and reopens it as `active` when a reviewer asks for more work

**Research ticket and Report:** the Report, created with the first round, carries the Research ticket's status.

**Specific rules:** Sets the ticket flow, not how research is done; the reviewer is the Managing Intelligence.

Research tickets filed by write-srd are researched by its Researcher and closed by write-srd, without review rounds.

## configure-worktree

**Reads:** Idea or Epic, repo, branch and worktree state; outside worktree-only mode, `launcher`, Launcher Protocol File, Worker prompt and its named skill, to create worktrees and launch the Worker.

**Gate:** Idea or Epic `defined` or `active`. Starts outside `.worktrees/`.

**Owned transitions:** None.

**Specific rules:** May create worktrees in several repos; defaults each base branch to the main checkout's branch. Worker starts in `.worktrees/<ticket id>/`. Worktree-only mode launches none.

## teardown-worktree

**Reads:** Idea or Epic, worktree, branch and merge state; outside worktree-only mode, `launcher` and Launcher Protocol File, to merge and stop the Worker.

**Gate:** Merge an Idea's worktrees only once the Idea is `done`, and an Epic's only once the Epic is `done`. Starts outside the folder it removes; before merging, stops if the Launcher reports another live Worker under that ticket's worktrees.

**Owned transitions:** None.

**Specific rules:** Merge target defaults per repo to its main checkout's branch. Commits or discards uncommitted changes only as the Managing Intelligence chooses. Stops its Worker only after every merge succeeds, then removes worktrees; worktree-only mode stops none.

## release

**Reads:** `release-guide` and its plain reference targets; Ticket System Protocol File only if the guide uses tickets.

**Gate:** Follows the conditions in `release-guide.md`; stops without a release process.

**Owned transitions:** Ticket changes come from `release-guide.md`.

**Specific rules:** A human step requires a human's yes.

## Engineer

**Reads:** Assigned Subtasks or Bug, source context and handed-off findings; `engineering-best-practices`, `build-commands`.

**Gate:** None specified.

**Owned transitions:** **Subtask:** the executor working it sets `active`, then `done`.

**Specific rules:** Writes code; report flags changes affecting design or docs for Doc Writer. Never commit.

## Test Writer

**Reads:** Assigned Subtasks or Bug, tests, fixtures and source changes; `test-guide`, `build-commands`.

**Gate:** None specified.

**Owned transitions:** **Subtask:** the executor working it sets `active`, then `done`.

**Specific rules:** Unit tests only. Each lane changes its own files and exclusively used fixtures/helpers; last Test Writer makes needed shared changes and runs the full unit suite in each changed repo. Every source-changing pass has one. For a Bug, adds a unit test failing before and passing after the fix. Never commit.

## Doc Writer

**Reads:** Assigned Subtasks or Bug, source/test diff and Engineer report; `doc-writing-guide`, `maintained-docs`.

**Gate:** None specified.

**Owned transitions:** **Subtask:** the executor working it sets `active`, then `done`.

**Specific rules:** Writes user-facing, contributor and design docs from the diff and Engineer report. Never commit.

## Engineer planner

**Reads:** Proposed Task, Epic, Idea requirements, repo context and Managing Intelligence decisions from dispatch; `engineering-best-practices`.

**Gate:** None specified.

**Owned transitions:** None.

**Specific rules:** Proposes code Subtasks to write-epic. Edit no files, change no tickets, never commit.

## Test Writer planner

**Reads:** Proposed Task and requirements from dispatch, tests and fixtures; `test-guide`.

**Gate:** None specified.

**Owned transitions:** None.

**Specific rules:** Proposes unit-test Subtasks and Test Writer lanes to write-epic. Edit no files, change no tickets, never commit.

## Doc Writer planner

**Reads:** Proposed Task and requirements from dispatch, product context; `doc-writing-guide`, `maintained-docs`.

**Gate:** None specified.

**Owned transitions:** None.

**Specific rules:** Proposes doc Subtasks to write-epic. Edit no files, change no tickets, never commit.

## Code Reviewer

**Reads:** Task, Idea or Bug review scope, source changes and context; `engineering-best-practices`, `build-commands`.

**Gate:** None specified.

**Owned transitions:** None.

**Specific rules:** Reviews source changes with lint findings. Edit no files, change no tickets, never commit.

## Test Reviewer

**Reads:** Task, Idea or Bug review scope, test changes and whole suite; `test-guide`.

**Gate:** None specified.

**Owned transitions:** None.

**Specific rules:** Reviews tests against the whole suite without running it. Edit no files, change no tickets, never commit.

## Doc Reviewer

**Reads:** Task, Idea or Bug review scope, product changes and complete touched docs; `doc-writing-guide`, `maintained-docs`.

**Gate:** None specified.

**Owned transitions:** None.

**Specific rules:** Re-reads touched docs in full, flagging breaches anywhere and docs made wrong or left missing. Edit no files, change no tickets, never commit.

## Product Manager

**Reads:** Idea requirements, planned work, product changes and recorded commits; no Guidance Documents.

**Gate:** None specified.

**Owned transitions:** None.

**Specific rules:** Checks the product, scope and proportion for every Plan, Epic's planned Tasks/Subtasks, completed Task, end-of-Epic and finished Idea. Edit no files, change no tickets, never commit.

## Requirements Reviewer

**Reads:** Idea requirements Docs and codebase context; no Guidance Documents.

**Gate:** None specified.

**Owned transitions:** None.

**Specific rules:** Cuts in a separate cut-only pass; every proposed new rule cites its stated requirement. May flag a risky SRD part without a model as a normal finding for write-srd. Edit no files, change no tickets, never commit.

## Researcher

**Reads:** The question, why the SRD needs it, the Idea, SRD and Research ticket supplied by write-srd, and relevant sources, to ground the answer; no Guidance Documents.

**Gate:** None specified.

**Owned transitions:** Creates the Research ticket's Report child `defined` with a cited answer.

**Specific rules:** Dispatched by write-srd to answer one research question and report back with its cited Report. It may use any research skill its Agent provides, as its Agent Protocol File describes. Its investigation is read-only: it changes no code and no ticket other than its Report. Never commit.

## TLA+ Writer

**Reads:** Assigned SRD part, existing spec, model files and checker output; `build-commands` for Model check.

**Gate:** None specified.

**Owned transitions:** **TLA+ spec Doc:** the TLA+ Writer, dispatched by write-srd, creates `defined`, one Doc per modelled SRD part

**TLA+ spec Doc:** revisiting that part updates its spec and leaves it `defined`. No other transition.

**Specific rules:** Model-checks the assigned part and returns findings to write-srd. Never commit.

## TLA+ Reviewer

**Reads:** Assigned TLA+ spec and SRD; no Guidance Documents.

**Gate:** None specified.

**Owned transitions:** None.

**Specific rules:** Checks model correspondence with the SRD and meaningful invariants; reports to req-review. Edit no files, change no tickets, never commit.

## Integration Tester

**Reads:** Gated changes, changed repo checkouts and earlier results from dispatch; integration tests and interfaces, `test-guide`, `build-commands`.

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

## Executor rules (moved from workflow.md, for develop-epic and fix-bug)

Fold these into develop-epic and fix-bug when they are written, and define "lane" there.


A Subagent loads the Guidance Documents of each repo it works in and may read any repo for context.

**Fresh start:** a new dispatch with no earlier context.

**Reuse:** resume the same Subagent for its Task or Bug. Keep its Guidance Documents. Add the Guidance Documents of any newly assigned repos.

- **Executors (Engineer, Test Writer, Doc Writer):** dispatch one Engineer, one Doc Writer and one Test Writer per lane for each Task (or for the Bug in fix-bug). Fix rounds reuse only the executors whose work the findings touch. The next Task or Bug starts fresh executors.
- **Every other Subagent Role:** starts fresh on every dispatch. These are the planners, the Code, Test and Doc Reviewers, the Product Manager, the Requirements Reviewer, the Researcher, the TLA+ Writer, the TLA+ Reviewer and the Integration Tester.

#### Replacing an executor

Resume the executor for each fix round. If the executor can't continue, start a fresh executor with the findings and the work so far.

#### Handoff

Subagents never talk to each other. The skill coordinates them: it reads each Subagent's report and passes what the next one needs in that one's dispatch or resume message. The work itself passes through the files: each Subagent sees the changes earlier ones made in its checkouts.

#### Progress record

On the skill's ticket, record each Subagent kept for reuse: its Subagent Role, its Task or Bug, its ID from the Agent, its name if available, and its dispatch Thinking Level.

Update the record after each report. After compaction or a re-run, use the record to resume each Subagent by name if available, otherwise by ID.

