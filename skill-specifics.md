# Skill specifics

Skills still to write for b.v38: engineer, test-writer, doc-writer, engineer-planner, test-writer-planner, doc-writer-planner, code-review, test-review, doc-review, product-manager, researcher, model-writer and model-review. The existing review skills are legacy versions; these notes describe their replacements. Remove an entry once its finished skill absorbs it.

Draft from `docs/goals.md`, `workflow/workflow.md` and the existing instructions for that work. The b.v38 PRD Docs are background only; the Acceptance baseline (t1.v38.2d) holds the checks.

## Required Reading for remaining drafts

Each entry names its specific inputs. Shared startup, settings, Protocol File locations, Guidance Document lookup and Child Agent rules are in `workflow/workflow.md`. Guidance names below mean their `.md` files found by that lookup. Each Child Agent uses the configuration its Main Agent supplies and reads findings and decisions from the assigned tickets.

**Thinking Levels:** the caller sets the level for each skill it launches, using `thinking_levels` and the chosen Agent's model mapping. Task or Bug tags override the defaults for engineer, test-writer and doc-writer as `workflow.md` describes. None of the skills below launches another Agent, so none resolves its own Thinking Level.

The workflow skills that launch Child Agents are write-srd, write-plan, write-epic, develop-epic, idea-review and fix-bug. Every skill below has its own Gate requiring that it runs for a Main Agent, so it receives an assignment and reports to that parent.

## engineer

**Required Reading:** Assigned Subtasks or Bug, source context and handed-off findings; `engineering-best-practices`, `build-commands`.

**Gate:** Runs as a Child Agent for a Main Agent. Otherwise, stop, because the Main Agent owns the assignment and judges the result.

**Owned transitions:** **Subtask:** the executor working it sets `active`, then `done`.

**Specific rules:** Writes code; report flags changes affecting design or docs for `doc-writer`. Never commit.

## test-writer

**Required Reading:** Assigned Task, Epic or Bug, testing Subtasks, affected repo checkouts and recorded results; tests, fixtures and source changes; `test-guide`, `build-commands`.

**Gate:** Runs as a Child Agent for a Main Agent. Otherwise, stop, because the Main Agent owns the assignment and judges the result.

**Owned transitions:** **Subtask:** the executor working it sets `active`, then `done`.

**Specific rules:** Writes unit and integration tests as Subtask work following `test-guide.md`, so coverage matches the Project's guidance. Each Lane owns its files and exclusively used fixtures and helpers so parallel writers avoid conflicting edits. The last `test-writer` makes shared changes and runs `## Unit tests` from `build-commands.md` for each affected code folder, skipping sections marked `none`, to check the combined work. For a Bug, records failing-before and passing-after regression evidence so the test proves it catches the defect. The calling skill owns commits.

The calling skill runs `## Integration tests` itself and saves output to a file, reading only failures so suite output stays out of its context. A `test-writer` repairs failures caused by tests; source failures go through the calling skill's repair pipeline. The calling skill reruns Integration Tests after repairs so its gate covers the completed work.

## doc-writer

**Required Reading:** Assigned Subtasks or Bug, source/test diff and `engineer` report; `doc-writing-guide`.

**Gate:** Runs as a Child Agent for a Main Agent. Otherwise, stop, because the Main Agent owns the assignment and judges the result.

**Owned transitions:** **Subtask:** the executor working it sets `active`, then `done`.

**Specific rules:** Updates documentation from the diff and `engineer` report following `doc-writing-guide.md`, so the Project's guide determines which documents need work. Never commit.

## engineer-planner

**Required Reading:** Proposed Task, Epic, Idea requirements, repo context and Managing Intelligence decisions on the tickets; `engineering-best-practices`.

**Gate:** Runs as a Child Agent for a Main Agent. Otherwise, stop, because the Main Agent owns the assignment and judges the result.

**Owned transitions:** None.

**Specific rules:** Proposes code Subtasks to write-epic. Edit no files, change no tickets, never commit.

## test-writer-planner

**Required Reading:** Proposed Task and requirements on the tickets, tests and fixtures; `test-guide`.

**Gate:** Runs as a Child Agent for a Main Agent. Otherwise, stop, because the Main Agent owns the assignment and judges the result.

**Owned transitions:** None.

**Specific rules:** Proposes unit and integration testing Subtasks and `test-writer` Lanes following `test-guide.md`, so write-epic plans the coverage the work needs. Returns proposals to write-epic, which owns the tickets.

## doc-writer-planner

**Required Reading:** Proposed Task and requirements on the tickets, product context; `doc-writing-guide`.

**Gate:** Runs as a Child Agent for a Main Agent. Otherwise, stop, because the Main Agent owns the assignment and judges the result.

**Owned transitions:** None.

**Specific rules:** Proposes doc Subtasks to write-epic. Edit no files, change no tickets, never commit.

## code-review

**Required Reading:** Task, Idea or Bug review scope, source changes and context; `engineering-best-practices`, `build-commands`.

**Gate:** Runs as a Child Agent for a Main Agent. Otherwise, stop, because the Main Agent owns the assignment and judges the result.

**Owned transitions:** None.

**Specific rules:** Reviews source changes with lint findings. Edit no files, change no tickets, never commit.

## test-review

**Required Reading:** Task, Idea or Bug review scope, test changes and whole suite; `test-guide`.

**Gate:** Runs as a Child Agent for a Main Agent. Otherwise, stop, because the Main Agent owns the assignment and judges the result.

**Owned transitions:** None.

**Specific rules:** Reviews tests against the whole suite without running it. Edit no files, change no tickets, never commit.

## doc-review

**Required Reading:** Task, Idea or Bug review scope, product changes and complete touched docs; `doc-writing-guide`.

**Gate:** Runs as a Child Agent for a Main Agent. Otherwise, stop, because the Main Agent owns the assignment and judges the result.

**Owned transitions:** None.

**Specific rules:** Re-reads touched docs in full, flagging breaches anywhere and docs made wrong or left missing. Edit no files, change no tickets, never commit.

## product-manager

**Required Reading:** Idea requirements, planned work, product changes and recorded commits; no Guidance Documents.

**Gate:** Runs as a Child Agent for a Main Agent. Otherwise, stop, because the Main Agent owns the assignment and judges the result.

**Owned transitions:** None.

**Specific rules:** Checks the product, scope and proportion for every Plan, Epic's planned Tasks/Subtasks, completed Task, end-of-Epic and finished Idea. Edit no files, change no tickets, never commit.

## researcher

**Required Reading:** The question, why the SRD needs it, the Idea, SRD and Research ticket supplied by write-srd, and relevant sources, to ground the answer. Read `research-guide.md`, found as `workflow.md` describes, so the investigation follows the Project's guidance. Use the supplied `research_location` to read the Research ticket and write its Report through the Ticket System Protocol File.

**Gate:** Runs as a Child Agent for a Main Agent. Otherwise, stop, because the Main Agent owns the assignment and judges the result.

**Owned transitions:** Creates the Research ticket's Report child `defined` with a cited answer.

**Specific rules:** Launched by write-srd to answer one research question and report back with its cited Report. It may use any research skill its Agent provides, as its Agent Protocol File describes. Its investigation is read-only: it changes no code and no ticket other than its Report. Never commit.

## model-writer

**Required Reading:** Assigned SRD part, any existing Model Doc, model files and checker output; `build-commands` for the language and checker command in `## Model check`.

**Gate:** Runs as a Child Agent for a Main Agent. Otherwise, stop, because the Main Agent owns the assignment and judges the result.

**Owned transitions:** **Model Doc:** the `model-writer`, launched by write-srd, creates it `defined`, one Doc per modelled SRD part. A revision updates its Formal Model and leaves it `defined`.

**Specific rules:** Writes the assigned SRD part's Formal Model in the language named by `## Model check` in `build-commands.md`. Attaches the model files to its Model Doc as the Ticket System Protocol File describes, so they stay with the requirements. Model files stay out of repos. Resumed to fix accepted review findings or update the Formal Model after an SRD change, then to run the checker command once accepted findings are fixed, because review catches mistakes before a potentially slow checker run. Records checker results and SRD findings on the Model Doc and returns its ID to write-srd so later work uses that evidence. Never commit.

## model-review

**Required Reading:** Assigned Model Doc, its attached Formal Model and the SRD; no Guidance Documents.

**Gate:** Runs as a Child Agent for a Main Agent. Otherwise, stop, because the Main Agent owns the assignment and judges the result.

**Owned transitions:** None.

**Specific rules:** Launched fresh by write-srd for each model after writing or fixes, before each checker run. Checks that the model matches the SRD and its invariants are meaningful; returns findings with references and suggested fixes, or no findings. Edit no files, change no tickets, never commit.

## Managing Intelligence

**Gate:** None specified.

**Owned transitions:** **Idea:** the Managing Intelligence sets `done` after testing the Idea.

**Other Doc (not PRD, SRD or Model Doc):** the Managing Intelligence creates it `draft` and owns its later status changes.

**Bug:** write-bug or the Managing Intelligence creates `draft`, not yet validated

**Bug:** the Managing Intelligence sets `done` after checking the merged fix or agreeing with the invalidity note

**Bug:** the Managing Intelligence sets it back to `draft` to send it back to define-bug.
