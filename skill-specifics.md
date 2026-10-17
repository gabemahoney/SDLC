# Skill specifics

Remaining b.v38 draft notes: gates, owned transitions, specific reads and rules. Draft from `docs/goals.md`, `workflow/workflow.md` and today's Apiary skill and any Role it folds in. The b.v38 PRD Docs are background only; the Acceptance baseline (t1.v38.2d) holds the checks. Remove an entry once its finished skill or Role absorbs it.

## Required Reading for remaining drafts

Per-entry Required Reading names specific inputs only. Shared startup, settings, Protocol File paths, Guidance Document walks and dispatch rules are in `workflow/workflow.md`. Guidance names below mean their `.md` files loaded by that walk. Roles use the settings and Protocol Files their dispatch prompt supplies.

**Thinking Levels (2026-10-16):** only skills that dispatch a Subagent or launch a Worker read `thinking_levels` and the relevant `levels_<agent>` mapping, before that dispatch or launch. They check the target Role or Worker's skill, not their own skill line. Whoever launches a skill sets its own level. Executors use their Task's or Bug's tag; the dispatcher maps it. No Role below dispatches or launches, so none reads thinking levels itself.

The dispatching skills are write-srd, req-review, write-plan, write-epic, develop-epic, idea-review and fix-bug.

## Engineer

**Required Reading:** Assigned Subtasks or Bug, source context and handed-off findings; `engineering-best-practices`, `build-commands`.

**Gate:** None specified.

**Owned transitions:** **Subtask:** the executor working it sets `active`, then `done`.

**Specific rules:** Writes code; report flags changes affecting design or docs for Doc Writer. Never commit.

## Test Writer

**Required Reading:** Assigned Task, Epic or Bug, testing Subtasks, affected repo checkouts and recorded results; tests, fixtures and source changes; `test-guide`, `build-commands`.

**Gate:** None specified.

**Owned transitions:** **Subtask:** the executor working it sets `active`, then `done`.

**Specific rules:** Writes unit and integration tests as Subtask work following `test-guide.md`, so coverage matches the Project's guidance. Each Lane owns its files and exclusively used fixtures and helpers so parallel Writers avoid conflicting edits. The last Test Writer makes shared changes and runs `## Unit tests` from `build-commands.md` for each affected code folder, skipping sections marked `none`, to check the combined work. For a Bug, records failing-before and passing-after regression evidence so the test proves it catches the defect. The calling skill owns commits.

The calling skill runs `## Integration tests` itself and saves output to a file, reading only failures so suite output stays out of its context. A Test Writer repairs failures caused by tests; source failures go through the calling skill's repair pipeline. The calling skill reruns Integration Tests after repairs so its gate covers the completed work.

## Doc Writer

**Required Reading:** Assigned Subtasks or Bug, source/test diff and Engineer report; `doc-writing-guide`.

**Gate:** None specified.

**Owned transitions:** **Subtask:** the executor working it sets `active`, then `done`.

**Specific rules:** Updates documentation from the diff and Engineer report following `doc-writing-guide.md`, so the Project's guide determines which documents need work. Never commit.

## Engineer planner

**Required Reading:** Proposed Task, Epic, Idea requirements, repo context and Managing Intelligence decisions from dispatch; `engineering-best-practices`.

**Gate:** None specified.

**Owned transitions:** None.

**Specific rules:** Proposes code Subtasks to write-epic. Edit no files, change no tickets, never commit.

## Test Writer planner

**Required Reading:** Proposed Task and requirements from dispatch, tests and fixtures; `test-guide`.

**Gate:** None specified.

**Owned transitions:** None.

**Specific rules:** Proposes unit and integration testing Subtasks and Test Writer Lanes following `test-guide.md`, so write-epic plans the coverage the work needs. Returns proposals to write-epic, which owns the tickets.

## Doc Writer planner

**Required Reading:** Proposed Task and requirements from dispatch, product context; `doc-writing-guide`.

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

**Required Reading:** Task, Idea or Bug review scope, product changes and complete touched docs; `doc-writing-guide`.

**Gate:** None specified.

**Owned transitions:** None.

**Specific rules:** Re-reads touched docs in full, flagging breaches anywhere and docs made wrong or left missing. Edit no files, change no tickets, never commit.

## Product Manager

**Required Reading:** Idea requirements, planned work, product changes and recorded commits; no Guidance Documents.

**Gate:** None specified.

**Owned transitions:** None.

**Specific rules:** Checks the product, scope and proportion for every Plan, Epic's planned Tasks/Subtasks, completed Task, end-of-Epic and finished Idea. Edit no files, change no tickets, never commit.

## Researcher

**Required Reading:** The question, why the SRD needs it, the Idea, SRD and Research ticket supplied by write-srd, and relevant sources, to ground the answer. Read `research-guide.md`, found as `workflow.md` describes, so the investigation follows the Project's guidance. Use the supplied `research_location` to read the Research ticket and write its Report through the Ticket System Protocol File.

**Gate:** None specified.

**Owned transitions:** Creates the Research ticket's Report child `defined` with a cited answer.

**Specific rules:** Dispatched by write-srd to answer one research question and report back with its cited Report. It may use any research skill its Agent provides, as its Agent Protocol File describes. Its investigation is read-only: it changes no code and no ticket other than its Report. Never commit.

## Model Writer

**Required Reading:** Assigned SRD part, any existing Model Doc, model files and checker output; `build-commands` for the language and checker command in `## Model check`.

**Gate:** None specified.

**Owned transitions:** **Model Doc:** the Model Writer, dispatched by write-srd, creates it `defined`, one Doc per modelled SRD part. A revision updates its Formal Model and leaves it `defined`.

**Specific rules:** Writes the assigned SRD part's Formal Model in the language named by `## Model check` in `build-commands.md`. Attaches the model files to its Model Doc as the Ticket System Protocol File describes, so they stay with the requirements. Model files stay out of repos. Resumed to fix accepted review findings or update the Formal Model after an SRD change, then to run the checker command once accepted findings are fixed, because review catches mistakes before a potentially slow checker run. Records checker results and SRD findings on the Model Doc and returns its ID to write-srd so later work uses that evidence. Never commit.

## Model Reviewer

**Required Reading:** Assigned Model Doc, its attached Formal Model and the SRD; no Guidance Documents.

**Gate:** None specified.

**Owned transitions:** None.

**Specific rules:** Dispatched fresh by write-srd for each model after writing or fixes, before each checker run. Checks that the model matches the SRD and its invariants are meaningful; returns findings with references and suggested fixes, or no findings. Edit no files, change no tickets, never commit.

## Managing Intelligence

**Gate:** None specified.

**Owned transitions:** **Idea:** the Managing Intelligence sets `done` after testing the Idea.

**Other Doc (not PRD, SRD or Model Doc):** the Managing Intelligence creates it `draft` and owns its later status changes.

**Bug:** write-bug or the Managing Intelligence creates `draft`, not yet validated

**Bug:** the Managing Intelligence sets `done` after checking the merged fix or agreeing with the invalidity note

**Bug:** the Managing Intelligence sets it back to `draft` to send it back to define-bug.
