# Apiary workflow

Every Apiary skill reads this rulebook when run; every Subagent reads it when spawned.

## Stores and ticket terms

Stores are flat; none is nested in another.

| Store | Top-level ticket | Child tiers |
|---|---|---|
| Ideas | Idea | Doc |
| Plans | Plan | Epic → Task → Subtask |
| Bugs | Bug | None |
| Research | Research ticket | Report |

An Idea is a piece of software to build: a feature, a change or a product; a Bug is a defect to validate and fix. A Plan divides an Idea into Epics, an Epic into Tasks (each committed in one go), and a Task into Subtasks (each one executor's part). A Doc describes an Idea: its PRD (what and why), SRD (what the software must do), TLA+ spec (a model-checked design), or another document. A Research ticket holds a research question; its one Report holds the answer. A Report is not a Doc.

## Tags

| Tag | Meaning |
|---|---|
| `level:<label>` | The ticket's Thinking Level: one on each Idea, Epic, Task and Bug. |

## Statuses

Ideas, Plans and Research use `draft`, `defined`, `active` and `done`. Bugs use those plus `invalid`. Set and read only the statuses for each store. All status transitions are idempotent.

| Status | Meaning |
|---|---|
| `draft` | Not fully written up. |
| `defined` | Fully written up. |
| `active` | Work in progress. |
| `done` | Complete. |
| `invalid` | Not a real Bug; define-bug sets it with a note saying why. |

## Status Ownership

Each transition has exactly one owner. Change only the tickets and statuses your `SKILL.md` and this table give you.

| Ticket                                | Transitions and owners                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| ------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Idea                                  | write-idea creates `draft`; req-review sets `draft` → `defined` on the Managing Intelligence's yes, once its PRD and SRD are `defined`; develop-epic sets `active` when starting an Epic; the Managing Intelligence sets `done` after testing the Idea.                                                                                                                                                                                                            |
| PRD / SRD                             | write-prd / write-srd creates `draft`; revising a `defined` PRD or SRD sets it back to `draft`; req-review asks the Managing Intelligence and, on yes, sets `defined`.                                                                                                                                                                                                                                                                                             |
| Other Doc (not PRD, SRD or TLA+ spec) | The Managing Intelligence creates `draft`; req-review asks the Managing Intelligence and, on yes, sets `defined`; the Managing Intelligence owns other changes.                                                                                                                                                                                                                                                                                                    |
| TLA+ spec Doc                         | tla-plus creates `defined`; a re-run updates it and leaves it `defined`. No other transition.                                                                                                                                                                                                                                                                                                                                                                      |
| Plan                                  | write-plan creates `draft`, and sets `defined` once the Plan is written, checked and revised; develop-epic sets `active` when starting an Epic; develop-epic sets `done` when finishing an Epic leaves every Epic in the Plan `done`.                                                                                                                                                                                                                              |
| Epic                                  | write-plan creates `draft`; write-epic sets `defined`; develop-epic sets `active`, then `done`.                                                                                                                                                                                                                                                                                                                                                                    |
| Task                                  | write-epic creates `draft`, then sets `defined`; develop-epic sets `active`, then `done`; `done` requires every Subtask to be `done`.                                                                                                                                                                                                                                                                                                                              |
| Subtask                               | write-epic creates `draft`, then sets `defined`; the executor working it sets `active`, then `done`.                                                                                                                                                                                                                                                                                                                                                               |
| Bug                                   | write-bug or the Managing Intelligence creates `draft`, not yet validated; define-bug sets `defined` after reproducing and validating it, and sets its `level:` tag; define-bug sets `invalid` when the Bug is not real, with a note saying why; fix-bug sets `active`; the Managing Intelligence sets `done` after checking the merged fix or agreeing with the invalidity note; the Managing Intelligence sets it back to `draft` to send it back to define-bug. |
| Research ticket and Report            | research creates the Research ticket `defined`, sets it `active` during review rounds, sets it `done` when the reviewer accepts, and reopens it as `active` when a reviewer asks for more work; the Report, created with the first round, carries the Research ticket's status.                                                                                                                                                                                    |

## Flows

**Idea:** write-idea → write-prd and write-srd → req-review → write-plan → write-epic for each Epic → develop-epic for each Epic → idea-review → the Managing Intelligence's testing. idea-review checks the whole Idea without changing statuses.

Every Idea has exactly one PRD and one SRD; the writing skill updates an existing one. req-review is optional: the Managing Intelligence may skip it and mark the Idea `defined` by hand. When the PRD or SRD is not `defined`, write-plan stops and asks the Managing Intelligence to confirm planning without review, and goes on only on an explicit yes.

**Bug:** write-bug → define-bug → fix-bug → the Managing Intelligence checks the merged fix. If the Bug is not real, define-bug sets `invalid` with a note saying why. The Managing Intelligence either sets an `invalid` Bug `done` or sends it back to `draft` for define-bug. Returned fixes also go back to `draft` for define-bug.

**Research:** research files the Research ticket, runs review rounds through acceptance, and reopens it for further reviewer requests.

## State gates

Enforce your skill's gate before changing anything. If it fails, change nothing and say why.

| Skill | Gate |
|---|---|
| write-plan | Idea `defined`, with a PRD and an SRD. Finish an existing Plan in `draft` or `defined`; never duplicate it. |
| write-epic | Epic `draft`; its Plan `defined` or `active`. |
| develop-epic | Epic `defined` or `active`; every Epic it depends on `done`. |
| idea-review | Plan `done`; no worktree of its Epics still unmerged. |
| define-bug | Bug `draft`. |
| fix-bug | Bug `defined`, or `active` when resuming; every ticket it depends on `done`. |
| configure-worktree | Idea or Epic `defined` or `active`. |
| teardown-worktree | Merge an Idea's worktrees only once the Idea is `done`, and an Epic's only once the Epic is `done`. |

## Source references

A source reference links a ticket to something outside the ticket system that it came from. The ticket system stores only the link; Apiary resolves and reads it. Resolve GitHub links through the GitHub CLI, file paths by reading them, and ticket IDs through the ticket system. Use source references as context when present; work without them when absent.

## Shared rules

### Starting, reporting and resuming

Before changing anything, identify your Agent, read the installed `workflow.md`, find the Project Folder (see Project Folder, paths and worktrees) and load settings (see Settings). Load the Agent Protocol File, the Ticket System Protocol File for ticket work, and the Launcher Protocol File where required. Check the ticket ID or creation input, load needed Guidance Documents (see Guidance Documents), templates and ticket-dependent skills' `SKILL.md` files, complete the fail-closed checks, then check the state gate. On failure, stop without changes and say why.

Stop before any change, naming the file, if a needed Guidance Document has neither a user copy nor a Default Fallback File, or a needed installed `workflow.md`, `SKILL.md`, Subagent definition or Protocol File is missing, empty or unreadable. A missing store stops the run likewise; point to project-setup.

Read and follow a skill's installed `SKILL.md` whenever running it. An inner skill uses its caller's settings and Protocol Files and reports into its caller's report. Subagents follow their installed definitions. Report pass, fail or not applicable for every required check and gate in loaded `SKILL.md` files and Guidance Documents; name the Guidance Document copies or Default Fallback Files used.

After compaction, re-read `workflow.md`, the resolved Protocol Files, inner skills' `SKILL.md` files and Guidance Documents before continuing. A compacted Subagent re-reads `workflow.md`, its dispatch prompt's Protocol Files and its Guidance Documents.

### Project Folder, paths and worktrees

The Project Folder is the nearest folder, from the working directory up, containing `.apiary/project_settings.md`. Without one, use the folder the Agent started in and only `~/.apiary/default_project_settings.md`. The Project's repos are its main checkouts under the Project Folder.

Project-level skills—project-setup, write-idea, write-bug, write-prd, write-srd, req-review, tla-plus, write-plan, write-epic and research—must not assume git. Execution skills—develop-epic, idea-review, define-bug, fix-bug and the worktree skills—change files and commit only inside repo checkouts.

Use absolute paths (`/…` or `~/…`) as given. A target inside a Project repo, however written, opens its copy in the checkout being worked in. Resolve Guidance Documents' relative paths, including pointers and `maintained-docs.md` entries, from that checkout's root, wherever the Guidance Document sits.

For develop-epic, idea-review, review skills and the repos write-plan and write-epic plan in, starting in `.worktrees/<ticket id>/` confines work to that ticket's worktrees; otherwise use main checkouts. Put worktrees only at `<Project Folder>/.worktrees/<ticket id>/<repo path>`, where `<repo path>` is relative to the Project Folder. Commit per repo, naming the ticket; a Task spanning repos gets one commit per repo. Only release pushes.

### Settings

Read settings only from the Project Folder's `.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`. The first file naming a setting supplies its whole value.

The six names are `ticket_system`, `launcher`, `new_idea_intake`, `new_bug_intake`, `levels_claude_code` and `levels_codex`. Each value is the text below its `## <setting name>` heading up to the next `##` heading; text before the first heading is a comment. A malformed settings file stops the run, naming it. An unset required setting stops the run before changes, naming it and pointing to project-setup. Ticket systems, Launchers and intake approaches must be ones Apiary ships.

Resolve settings and Protocol Files once per run started by the Managing Intelligence; retain them throughout. Pass values and Ticket System and Agent Protocol Files in every dispatch. Subagents and inner skills use them; settings edits apply to the next run the Managing Intelligence starts.

### Guidance Documents

Read every user copy of each needed Guidance Document from the working folder's `.apiary` through each parent, including `~/.apiary`. In a repo checkout, start at that checkout's `.apiary`, then its parent; a worktree uses its branch's committed copy. Outside `~`, walk to `/`, then read `~/.apiary` once.

Files sit directly in each `.apiary` Folder. User copies are `<name>.md`. Only if no user copy exists, read `~/.apiary/<name>-default-fallback.md` alone. Every user copy adds up, including all its checks and gates; any user copy disables the Default Fallback File. If guidance conflicts, stop and ask the Managing Intelligence which to follow, naming both files and the conflicting lines.

A Guidance Document may consist entirely of a pointer; `maintained-docs.md` entries are pointers too. Open targets as plain references under the path rule: no walk, combining or Default Fallback File. Report a missing target; stop if the work requires it.

### Thinking Levels

The labels `low` < `medium` < `high` < `xhigh` < `max` each map to an Agent's model and effort. Take each session's or Subagent's Thinking Level from one source:

| Session or work | Source |
|---|---|
| Worker | Its skill's session Thinking Level in `SKILL.md`; this is a recommendation for other sessions. |
| Inner skill | The caller's session or dispatch model and effort. |
| PRD Writer, SRD Writer, Requirements Reviewer, Plan Writer; idea-review's reviewers, fix-up executors and integration Test Writer | Idea. |
| write-epic's planners; develop-epic's final integration Test Writer and end-of-Epic check | Epic. |
| develop-epic's executors, Code, Test and Doc Reviewers, Product Manager, and integration Test Writer for a flagged Task | Task. |
| Every Subagent fix-bug dispatches | Bug. |

When an Idea, Epic, Task or Bug starts work with a missing, unknown or repeated `level:` tag, ask the Managing Intelligence for its Thinking Level, set the tag and continue.

Read each `levels_<agent>` mapping as one plain-language line per label; model names come only from these mappings. At dispatch, pass the mapped model and effort through the Agent Protocol File; pass neither for an unset mapping. Worker launches use the Worker's Agent's mapping and Launcher Protocol File. If a Thinking Level cannot be applied, report it and use the session's model and effort; never stop for this. Retry a dispatch or Worker launch rejected for its model or effort without them, and report it.

### Subagent dispatch and reuse

Name each Subagent's repos and checkouts in its dispatch; it loads their Guidance Documents and may read any repo for context. develop-epic, idea-review and fix-bug do no executor or reviewer work themselves. Executors never commit. Read-only Subagent Roles change no files or tickets and never commit.

A reuse scope is one Task, a Bug in fix-bug, idea-review's close-out fix-ups, or an Epic's integration gate after its last Task. Dispatch each executor once per scope: one per executor Subagent Role, one per Test Writer lane, and an integration Test Writer separate from the lanes. Start with a self-contained prompt. Later passes resume only affected executors, with self-contained messages giving the findings and chosen fix in full, other changes since their last pass, and what to report; do not repeat context they hold. Resumes retain the first dispatch's Thinking Level and Guidance Documents; a newly assigned repo adds its Guidance Documents.

Writers and read-only Subagent Roles are fresh every dispatch. Never reuse across scopes. Subagents never talk to each other; the diff is the handoff. Replace an executor with a fresh dispatch only after an approach change, failed resume, or transcript exceeding the Agent Protocol File's model limit. Carry findings, chosen fix and work so far into the replacement prompt. A same-approach refinement resumes. An error or no report means resume failed; unknown transcript size never triggers the limit.

Keep a progress record on the skill's ticket: each warm Subagent's Subagent Role, scope, ID the Agent gave it, name where available, dispatch Thinking Level and last transcript size, updated after each report. Resume from it after compaction or a re-run, using the name if available, otherwise ID; a stale name or ID fails the resume and goes fresh.

Before each Task after its first, develop-epic checks its own context use; fix-bug does so before each pass after its first. Follow the Agent Protocol File. At 75% or more, or a reading older than its freshness window, stop at that boundary and name the re-run for a new session. With no reading, continue and report it.

Where the Agent requires closing Subagents, close a cold one after its report and a warm one when replaced or its scope ends. At the open-Subagent limit, close finished Subagents and dispatch again. With no resume tool, make every pass fresh; with no transcript size, skip that limit check. Report each unavailable capability.

### Versions and fresh reads

Before changing anything, stop if a `SKILL.md`, Subagent definition or `workflow.md` is from another Apiary version; say to resume the session. Read `workflow.md`, inner skills' `SKILL.md` files and `.apiary` files from disk each run; Subagents read `workflow.md` and Guidance Documents when spawned. After an Apiary update, a resumed session's next run uses the new skills and Subagent definitions.

## Questions and stops

A skill or Subagent needing an answer or unable to continue stops and explains why in its output. Give all questions available at once, numbered in plain text, each with options, or state what must be fixed. Whoever started the run—the Managing Intelligence or the skill or Subagent above it—reads the output and decides. Never continue with missing or ambiguous information.

The Managing Intelligence answers in the session (through the Launcher for a Worker), or re-runs the skill with answers to continue the work.

## Ending a run

End every skill run with the next-step suggestions its `SKILL.md` lists. The Managing Intelligence may decline them.
