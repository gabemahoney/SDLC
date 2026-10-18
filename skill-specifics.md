# Skill specifics

Skills still to write for b.v38: engineer, test-writer, doc-writer, engineer-planner, test-writer-planner, doc-writer-planner, code-review, test-review, doc-review, product-manager, researcher, model-writer and model-review. req-review is already a Child Agent skill used by write-prd and write-srd. The other existing review skills are legacy versions; these notes describe their replacements. Remove an entry once its finished skill absorbs it.

Draft from `docs/goals.md`, `~/.apiary/system/workflow.md` and the existing instructions for that work. The b.v38 PRD Docs are background only; the Acceptance baseline (t1.v38.2d) holds the checks.

## Required Reading for remaining drafts

Each entry names its specific inputs. Shared startup, settings, Protocol File locations, Guidance Document lookup and Child Agent rules are in `~/.apiary/system/workflow.md`. The `guide:<file>` references below use that lookup. Each Child Agent uses the configuration its Main Agent supplies and reads findings and decisions from the assigned tickets.

The Main Agent resolves Thinking Levels under `~/.apiary/system/workflow.md`. These Child Agent skills launch no Agents.

The workflow skills that launch Child Agents are write-prd, write-srd, write-plan, write-epic, develop-epic, idea-review and fix-bug. Each drafted skill needs a Gate requiring a Main Agent parent, because that parent owns its assignment and judges the result. Include that Gate when moving these notes into the skill. All file changes remain uncommitted for the Main Agent to check and commit.

## engineer

**Required Reading:** Assigned Subtasks or Bug, source context and handed-off findings; `guide:engineering-best-practices.md`, `guide:build-commands.md`.

**Owned transitions:** **Subtask:** the executor working it sets `active`, then `done`.

**Specific rules:** Change source files only. Record changes affecting design or docs on the assigned ticket for doc-writer.

## test-writer

**Required Reading:** Assigned Task or Bug, testing Subtasks or Bug assignments, affected repo checkouts and recorded results; tests, fixtures and source changes; `guide:test-guide.md`, `guide:build-commands.md`.

**Owned transitions:** **Subtask:** the executor working it sets `active`, then `done`.

**Specific rules:** Write tests for assigned Subtasks or Bug testing assignments under `guide:test-guide.md`, so coverage matches the Project's guidance. Each Lane owns whole files and exclusively used setup; the final writer handles shared files after the Lanes finish to avoid conflicting edits. The last `test-writer` makes shared changes and runs `guide:build-commands.md ## Unit tests` for each affected code folder, skipping sections marked `none`, to check the combined work. For a Bug, records failing-before and passing-after regression evidence so the test proves it catches the defect.

Repair test failures from the calling skill's Integration gate; return source failures to that Main Agent. The Main Agent runs and reruns the integration suites itself.

## doc-writer

**Required Reading:** Assigned Subtasks or Bug, source/test diff and source findings on the ticket; `guide:doc-writing-guide.md`.

**Owned transitions:** **Subtask:** the executor working it sets `active`, then `done`.

**Specific rules:** Update documentation from the diff and recorded source findings under `guide:doc-writing-guide.md`, which determines the documents to change.

## engineer-planner

**Required Reading:** Proposed Task, Epic, Idea requirements, repo context and Managing Intelligence decisions on the tickets; `guide:engineering-best-practices.md`.

**Owned transitions:** None.

**Specific rules:** Proposes code Subtasks to write-epic. Return findings or proposals to the Main Agent, which owns their ticket record; keep the reviewed files unchanged.

## test-writer-planner

**Required Reading:** Proposed Task and requirements on the tickets, tests and fixtures; `guide:test-guide.md`.

**Owned transitions:** None.

**Specific rules:** Proposes unit and integration testing Subtasks and `test-writer` Lanes following `guide:test-guide.md`, so write-epic plans the coverage the work needs. Returns proposals to write-epic, which owns the tickets.

## doc-writer-planner

**Required Reading:** Proposed Task and requirements on the tickets, product context; `guide:doc-writing-guide.md`.

**Owned transitions:** None.

**Specific rules:** Proposes doc Subtasks to write-epic. Return findings or proposals to the Main Agent, which owns their ticket record; keep the reviewed files unchanged.

## code-review

**Required Reading:** Task, Idea or Bug review scope, source changes and context; `guide:engineering-best-practices.md`, `guide:build-commands.md`.

**Owned transitions:** None.

**Specific rules:** Reviews source changes with lint findings. Return findings or proposals to the Main Agent, which owns their ticket record; keep the reviewed files unchanged.

## test-review

**Required Reading:** Task, Idea or Bug review scope, test changes and whole suite; `guide:test-guide.md`.

**Owned transitions:** None.

**Specific rules:** Reviews tests against the whole suite without running it. Return findings or proposals to the Main Agent, which owns their ticket record; keep the reviewed files unchanged.

## doc-review

**Required Reading:** Task, Idea or Bug review scope, product changes and complete touched docs; `guide:doc-writing-guide.md`.

**Owned transitions:** None.

**Specific rules:** Re-reads touched docs in full, flagging breaches anywhere and docs made wrong or left missing. Return findings or proposals to the Main Agent, which owns their ticket record; keep the reviewed files unchanged.

## product-manager

**Required Reading:** Idea requirements, planned work, product changes and recorded commits; no Guidance Documents.

**Owned transitions:** None.

**Specific rules:** Checks the product, scope and proportion for every Plan, Epic's planned Tasks/Subtasks, completed Task, end-of-Epic and finished Idea. Return findings or proposals to the Main Agent, which owns their ticket record; keep the reviewed files unchanged.

## researcher

**Required Reading:** The question, why the SRD needs it, the Idea, SRD and Research ticket supplied by write-srd, and relevant sources, to ground the answer. Read `guide:research-guide.md`, found as `~/.apiary/system/workflow.md` describes, so the investigation follows the Project's guidance. Use the supplied `setting:research_location` to read the Research ticket and write its Report through the Ticket System Protocol File.

**Owned transitions:** Creates the Research ticket's Report child `defined` with a cited answer.

**Specific rules:** Answer write-srd's research question in the cited Report, using research tools or skills available to the Agent. Write only that Report and its evidence artifacts at `setting:research_location`, so research stays with the answer. Return unresolved decisions to write-srd for the Managing Intelligence.

## model-writer

**Required Reading:** Assigned SRD part, any existing Model Doc, model files and checker output; `guide:build-commands.md` for the language and checker command in `guide:build-commands.md ## Model check`.

**Owned transitions:** **Model Doc:** the `model-writer`, launched by write-srd, creates it `defined`, one Doc per modelled SRD part. A revision updates its Formal Model and leaves it `defined`.

**Specific rules:** Writes the assigned SRD part's Formal Model in the language named by `guide:build-commands.md ## Model check`. Attaches the model files to its Model Doc as the Ticket System Protocol File describes, so they stay with the requirements. Model files stay out of repos. Resumed to fix accepted review findings or update the Formal Model after an SRD change, then to run the checker command once accepted findings are fixed, because review catches mistakes before a potentially slow checker run. Records checker results and SRD findings on the Model Doc and returns its ID to write-srd so later work uses that evidence.

## model-review

**Required Reading:** Assigned Model Doc, its attached Formal Model and the SRD; no Guidance Documents.

**Owned transitions:** None.

**Specific rules:** Review independently after writing or fixes, before checking. Check that the model matches the SRD and has meaningful invariants. Return findings with references and suggested fixes to write-srd, which owns their ticket record; keep model files unchanged.

## Managing Intelligence

**Owned transitions:** **PRD and SRD:** the Managing Intelligence sets each `defined` on approval.

**Idea:** the Managing Intelligence sets a `draft` Idea `defined` once its PRD and SRD are both approved, and `done` after testing the Idea.

**Other Doc (not PRD, SRD or Model Doc):** the Managing Intelligence creates it `draft` and owns its later status changes.

**Bug:** write-bug or the Managing Intelligence creates `draft`, not yet validated

**Bug:** the Managing Intelligence sets `done` after checking the merged fix or agreeing with the invalidity note.

**Bug:** the Managing Intelligence sets it back to `draft` to send it back to define-bug.
