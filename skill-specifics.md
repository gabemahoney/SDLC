# Skill specifics

All b.v38 Child Agent skills are drafted. Their requirements now live in their skills.

Draft from `docs/goals.md`, `~/.sdlc/install/workflow.md` and the existing instructions for that work. The b.v38 PRD Docs are background only; the Acceptance baseline (t1.v38.2d) holds the checks.

## Required Reading for remaining drafts

Each entry names its specific inputs. Shared startup, settings, Protocol File locations, Guidance Document lookup and Child Agent rules are in `~/.sdlc/install/workflow.md`. The `guide:<file>` references below use that lookup. Each Child Agent uses the configuration its Main Agent supplies and reads findings and decisions from the assigned tickets.

The Main Agent resolves Thinking Levels under `~/.sdlc/install/workflow.md`. These Child Agent skills launch no Agents.

The workflow skills that launch Child Agents are write-prd, write-srd, write-plan, write-epic, develop-epic, idea-review and fix-bug. Each drafted skill's Gate checks its assigned ticket's state, so work starts at the right stage. All file changes remain uncommitted for the Main Agent to check and commit.

## Managing Intelligence

**Owned transitions:** **PRD and SRD:** the Managing Intelligence sets each `defined` on approval.

**Idea:** the Managing Intelligence sets a `draft` Idea `defined` once its PRD and SRD are both approved, and `done` after testing the Idea.

**Other Doc (not PRD, SRD or Model Doc):** the Managing Intelligence creates it `draft` and owns its later status changes.

**Bug:** write-bug or the Managing Intelligence creates `draft`, not yet validated

**Bug:** the Managing Intelligence sets `done` after testing and accepting the fix in its worktrees, before teardown-worktree merges it.

**Idea or Bug:** the Managing Intelligence sets it back to `active` when teardown-worktree hits a merge conflict, so the conflict can be resolved and tested on its branch.

