# Skill specifics

Skills still to write for b.v38: researcher and model-review. req-review, code-review, test-review and doc-review are Child Agent skills. Remove an entry once its finished skill absorbs it.

Draft from `docs/goals.md`, `~/.apiary/system/workflow.md` and the existing instructions for that work. The b.v38 PRD Docs are background only; the Acceptance baseline (t1.v38.2d) holds the checks.

## Required Reading for remaining drafts

Each entry names its specific inputs. Shared startup, settings, Protocol File locations, Guidance Document lookup and Child Agent rules are in `~/.apiary/system/workflow.md`. The `guide:<file>` references below use that lookup. Each Child Agent uses the configuration its Main Agent supplies and reads findings and decisions from the assigned tickets.

The Main Agent resolves Thinking Levels under `~/.apiary/system/workflow.md`. These Child Agent skills launch no Agents.

The workflow skills that launch Child Agents are write-prd, write-srd, write-plan, write-epic, develop-epic, idea-review and fix-bug. Each drafted skill's Gate checks its assigned ticket's state, so work starts at the right stage. All file changes remain uncommitted for the Main Agent to check and commit.

## researcher

**Required Reading:** The question, why the SRD needs it, the Idea, SRD and Research ticket supplied by write-srd, and relevant sources, to ground the answer. Read `guide:research-guide.md`, found as `~/.apiary/system/workflow.md` describes, so the investigation follows the Project's guidance. Use the supplied `setting:research_location` to read the Research ticket and write its Report through the Ticket System Protocol File.

**Owned transitions:** Creates the Research ticket's Report child `defined` with a cited answer.

**Specific rules:** Answer write-srd's research question in the cited Report, using research tools or skills available to the Agent. Write only that Report and its evidence artifacts at `setting:research_location`, so research stays with the answer. Return unresolved decisions to write-srd for the Managing Intelligence.

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
