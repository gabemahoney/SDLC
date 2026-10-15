# Apiary workflow

Every Apiary skill reads this rulebook when run; every Subagent reads it when spawned.

## Terms

- **Managing Intelligence:** the person, or a bot acting for one, who drives Apiary: runs the skills, answers their questions, decides what work happens next and tests the results.
- **Agent:** the AI coding tool Apiary runs in: Claude Code or Codex CLI.
- **Subagent:** a helper an Agent starts inside its own session, with fresh context, to do one Subagent Role's work for a skill and report back.
- **Subagent Role:** the job a Subagent does, such as Engineer or Code Reviewer, defined by its Subagent definition. Executors change files, writers write tickets, read-only Subagent Roles change nothing.
- **Worker:** a separate Agent session the Launcher starts to run one skill.
- **Launcher:** the program that starts, watches and stops Workers, such as agent-director.
- **Project Folder:** the folder a Project lives in, holding its repos and their worktrees (see Project Folder, paths and worktrees).
- **`.apiary` Folder:** a folder named `.apiary` holding a user's own Guidance Documents for the folder it sits in, and settings in the Project Folder and `~`.
- **Guidance Document:** one of seven user-written instruction files with fixed names: `engineering-best-practices.md`, `test-guide.md`, `doc-writing-guide.md`, `build-commands.md`, `maintained-docs.md`, `release-guide.md`, `bug-writing-guide.md`.
- **Default Fallback File:** Apiary's shipped default copy of a Guidance Document, in `~/.apiary`, used only where no copy of it is found.
- **Protocol Files:** Apiary's Ticket System, Launcher and Agent Protocol Files, each holding everything specific to one ticket system, Launcher or Agent.
- **Thinking Level:** one of `low` to `max`, picking the model and effort a session or Subagent runs at.

## Stores and ticket terms

Stores are flat; none is nested in another.

| Store | Top-level ticket | Child tiers |
|---|---|---|
| Ideas | Idea | Doc |
| Plans | Plan | Epic → Task → Subtask |
| Bugs | Bug | None |
| Research | Research ticket | Report |

An Idea is a piece of software to build: a feature, a change or a product; a Bug is a defect to validate and fix. A Plan divides an Idea into Epics, an Epic into Tasks (each committed in one go), and a Task into Subtasks (each one executor's part). A Doc describes an Idea: its PRD (what and why), SRD (what the software must do), TLA+ spec (a model-checked design), or another document. A Research ticket holds a research question; its one Report holds the answer. A Report is not a Doc.

Every Epic is a vertical slice through the product, never component work (only testing, docs or plumbing). The one exception is a Round Feedback Epic: the Epic titled `Round <N> Feedback` that idea-review files in the Idea's Plan, holding a round's non-trivial findings. It need not be a vertical slice.

## Tags

| Tag | Meaning |
|---|---|
| `level:<label>` | The Thinking Level the executors working the ticket run at, and a fix-bug Worker on the Bug: one on each Task and Bug. write-epic sets a Task's, define-bug a Bug's. |

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
| TLA+ spec Doc                         | the TLA+ Writer, dispatched by write-srd, creates `defined`, one Doc per modelled SRD part; revisiting that part updates its spec and leaves it `defined`. No other transition.                                                                                                                                                                                                                                                                                                                                                                      |
| Plan                                  | write-plan creates `draft`, and sets `defined` once the Plan is written, checked and revised; develop-epic sets `active` when starting an Epic; develop-epic sets `done` when finishing an Epic leaves every Epic in the Plan `done`; idea-review sets `done` → `active` when it files a Round Feedback Epic.                                                                                                                                                                                                                              |
| Epic                                  | write-plan creates `draft`, and idea-review creates a Round Feedback Epic `draft`; write-epic sets `defined`; develop-epic sets `active`, then `done`.                                                                                                                                                                                                                                                                                                                                                                    |
| Task                                  | write-epic creates `draft`, then sets `defined`; develop-epic sets `active`, then `done`; `done` requires every Subtask to be `done`.                                                                                                                                                                                                                                                                                                                              |
| Subtask                               | write-epic creates `draft`, then sets `defined`; the executor working it sets `active`, then `done`.                                                                                                                                                                                                                                                                                                                                                               |
| Bug                                   | write-bug or the Managing Intelligence creates `draft`, not yet validated; define-bug sets `defined` after reproducing and validating it, and sets its `level:` tag; define-bug sets `invalid` when the Bug is not real, with a note saying why; fix-bug sets `active`; the Managing Intelligence sets `done` after checking the merged fix or agreeing with the invalidity note; the Managing Intelligence sets it back to `draft` to send it back to define-bug. |
| Research ticket and Report            | research creates the Research ticket `defined`, sets it `active` during review rounds, sets it `done` when the reviewer accepts, and reopens it as `active` when a reviewer asks for more work; the Report, created with the first round, carries the Research ticket's status.                                                                                                                                                                                    |

## Flows

**Idea:** write-idea → write-prd and write-srd → req-review → write-plan → write-epic for each Epic → develop-epic for each Epic → idea-review → the Managing Intelligence's testing. Each round of idea-review that has non-trivial findings files them as a Round Feedback Epic, which goes through write-epic and develop-epic before idea-review runs again.

Every Idea has exactly one PRD and one SRD; the writing skill updates an existing one. An Idea may have several TLA+ spec Docs, one per modelled SRD part; revisiting a part updates its spec. write-srd selects the parts to model, dispatches one TLA+ Writer per part in parallel, and fixes SRD bugs their models find. req-review dispatches one read-only TLA+ Reviewer per TLA+ spec Doc alongside the Requirements Reviewer, checking that the model matches the SRD and its invariants are meaningful. req-review is optional: the Managing Intelligence may skip it and mark the Idea `defined` by hand. When the PRD or SRD is not `defined`, write-plan stops and asks the Managing Intelligence to confirm planning without review, and goes on only on an explicit yes.

**Bug:** write-bug → define-bug → fix-bug → the Managing Intelligence checks the merged fix. If the Bug is not real, define-bug sets `invalid` with a note saying why. The Managing Intelligence either sets an `invalid` Bug `done` or sends it back to `draft` for define-bug. Returned fixes also go back to `draft` for define-bug.

**Research:** research files the Research ticket, runs review rounds through acceptance, and reopens it for further reviewer requests.

## State gates

Enforce your skill's gate before changing anything. If it fails, change nothing and say why.

| Skill | Gate |
|---|---|
| write-plan | Idea `defined`, with a PRD and an SRD. Finish an existing Plan in `draft` or `defined`; never duplicate it. |
| write-epic | Epic `draft`; its Plan `defined` or `active`. |
| develop-epic | Epic `defined` or `active`; every Epic it depends on `done`. A re-run on a `done` Epic may only finish the Plan's completion check. |
| idea-review | Plan `done`; no worktree of its Epics still unmerged. |
| define-bug | Bug `draft`. |
| fix-bug | Bug `defined`, or `active` when resuming; every ticket it depends on `done`. |
| configure-worktree | Idea or Epic `defined` or `active`. |
| teardown-worktree | Merge an Idea's worktrees only once the Idea is `done`, and an Epic's only once the Epic is `done`. |

## Source references

A source reference links a ticket to something outside the ticket system that it came from. The ticket system stores only the link; Apiary resolves and reads it. Resolve GitHub links through the GitHub CLI, file paths by reading them, and ticket IDs through the ticket system. Use source references as context when present; work without them when absent.

## Shared rules

### Starting, reporting and resuming

Before changing anything, identify your Agent, read the installed `workflow.md`, find the Project Folder (see Project Folder, paths and worktrees) and load settings (see Settings). Load the Agent Protocol File, the Ticket System Protocol File for ticket work, and the Launcher Protocol File where required. Check the ticket ID or creation input, load the Guidance Documents your `SKILL.md` names (see Guidance Documents) and templates, complete the fail-closed checks, then check the state gate. On failure, stop without changes and say why.

Stop before any change, naming the file, if a Guidance Document your `SKILL.md` or Subagent definition names has neither a user copy nor a Default Fallback File, or a needed installed `workflow.md`, `SKILL.md`, Subagent definition or Protocol File is missing, empty or unreadable. A missing store stops the run likewise; point to project-setup.

Read and follow a skill's installed `SKILL.md` whenever running it. No skill or Subagent runs another skill. Subagents follow their installed definitions. Report pass, fail or not applicable for every required check and gate in loaded `SKILL.md` files and Guidance Documents; name the Guidance Document copies or Default Fallback Files used.

### Project Folder, paths and worktrees

The Project Folder is the nearest folder, from the working directory up, containing `.apiary/project_settings.md`. Without one, use the folder the Agent started in and only `~/.apiary/default_project_settings.md`. The Project's repos are its main checkouts under the Project Folder.

Project-level skills—project-setup, write-idea, write-bug, write-prd, write-srd, req-review, write-plan, write-epic and research—must not assume git. Execution skills—develop-epic, idea-review, define-bug, fix-bug and the worktree skills—change files and commit only inside repo checkouts.

Use absolute paths (`/…` or `~/…`) as given. A target inside a Project repo, however written, opens its copy in the checkout being worked in. Resolve Guidance Documents' relative paths, pointers included, from that checkout's root, wherever the Guidance Document sits.

- **Where worktrees live:** only at `<Project Folder>/.worktrees/<ticket id>/<repo path>`, where `<repo path>` is relative to the Project Folder.
- **Where to work:** develop-epic, idea-review, and write-plan and write-epic for the repos they plan in, work only in a ticket's worktrees when started in `.worktrees/<ticket id>/`; otherwise in the main checkouts.
- **How to commit:** per repo, naming the ticket; a Task spanning repos gets one commit per repo.
- **Who pushes:** push only as the Project's `release-guide.md` allows.

### Settings

Read settings only from the Project Folder's `.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`. The first file naming a setting supplies its whole value.

The seven names are `ticket_system`, `launcher`, `new_idea_intake`, `new_bug_intake`, `levels_claude_code`, `levels_codex` and `thinking_levels`. Each value is the text below its `## <setting name>` heading up to the next `##` heading; text before the first heading is a comment. A malformed settings file stops the run, naming it. If neither file names a required setting, the run stops before changes, naming it and pointing to project-setup. Ticket systems, Launchers and intake approaches must be ones Apiary ships.

Pass the settings and the Ticket System and Agent Protocol Files in every dispatch; Subagents use those, not their own lookup.

### Guidance Documents

Load only the Guidance Documents your `SKILL.md` or Subagent definition names; read no others. Read every user copy of each of them from the working folder's `.apiary` through each parent, including `~/.apiary`. In a repo checkout, start at that checkout's `.apiary`, then its parent; a worktree uses its branch's committed copy. Outside `~`, walk to `/`, then read `~/.apiary` once.

Files sit directly in each `.apiary` Folder. User copies are `<name>.md`. Only if no user copy exists, read `~/.apiary/<name>-default-fallback.md` alone. Every user copy adds up, including all its checks and gates; any user copy disables the Default Fallback File. If guidance conflicts, stop and ask the Managing Intelligence which to follow, naming both files and the conflicting lines.

A Guidance Document may consist entirely of a pointer to other files. Open targets as plain references under the path rule: no walk, combining or Default Fallback File. Report a missing target; stop if the work requires it.

### Thinking Levels

The recommended `thinking_levels` entry for the TLA+ Reviewer is `TLA+ Reviewer: xhigh`.

The labels `low` < `medium` < `high` < `xhigh` < `max` each map to an Agent's model and effort. Take each session's or Subagent's Thinking Level from one source:

- **A Worker** runs at its skill's line in the `thinking_levels` setting; a fix-bug Worker runs at its Bug's `level:` tag. A session the Managing Intelligence starts itself runs at whatever it was started with.
- **A Subagent** runs at its Subagent Role's line in `thinking_levels`. An executor (the Engineer, Test Writer or Doc Writer) working on a Task or Bug runs at that ticket's `level:` tag instead. A resumed Subagent keeps its first dispatch's level.

`thinking_levels` holds one `<name>: <label>` line for every skill and every Subagent Role except fix-bug and the Doc Writer, which always run at a Task's or Bug's tag. At its start, a run checks that it has every line the run will use:
- its skill's, unless it is fix-bug;
- each Subagent Role's it dispatches outside a Task or Bug;
- for configure-worktree, the line of the skill its Worker will run.

A missing line stops the run before changes, naming the line and pointing to project-setup.

When a Task or Bug starts work with a missing, unknown or repeated `level:` tag, ask the Managing Intelligence for its Thinking Level, set the tag and continue.

Read each `levels_<agent>` mapping as one plain-language line per label; model names come only from these mappings. At dispatch, pass the mapped model and effort through the Agent Protocol File; pass neither for an unset mapping. Worker launches use the Worker's Agent's mapping and Launcher Protocol File. If a Thinking Level cannot be applied, report it and use the session's model and effort; never stop for this. Retry a dispatch or Worker launch rejected for its model or effort without them, and report it.

### Subagent dispatch and reuse

Name each Subagent's repos and checkouts in its dispatch; it loads their Guidance Documents and may read any repo for context. develop-epic and fix-bug do no executor or reviewer work themselves; idea-review does no reviewer work and dispatches no executor. Executors never commit. Read-only Subagent Roles change no files or tickets and never commit.

A reuse scope is one Task, a Bug in fix-bug, or an Epic's integration gate after its last Task. Dispatch each executor once per scope: one per executor Subagent Role, one per Test Writer lane, and an integration Test Writer separate from the lanes. Start with a self-contained prompt. Later passes resume only affected executors, with self-contained messages giving the findings and chosen fix in full, other changes since their last pass, and what to report; do not repeat context they hold. Resumes retain the first dispatch's Thinking Level and Guidance Documents; a newly assigned repo adds its Guidance Documents.

Writers and read-only Subagent Roles are fresh every dispatch. Never reuse across scopes. Subagents never talk to each other; the diff is the handoff. Replace an executor with a fresh dispatch only after an approach change, failed resume, or transcript exceeding the Agent Protocol File's model limit. Carry findings, chosen fix and work so far into the replacement prompt. A same-approach refinement resumes. An error or no report means resume failed; unknown transcript size never triggers the limit.

Keep a progress record on the skill's ticket: each warm Subagent's Subagent Role, scope, ID the Agent gave it, name where available, dispatch Thinking Level and last transcript size, updated after each report. Resume from it after compaction or a re-run, using the name if available, otherwise ID; a stale name or ID fails the resume and goes fresh.

Before each Task after its first, develop-epic checks its own context use, as the Agent Protocol File says. At 75% or more, or with a reading older than its freshness window, it stops at that Task boundary and names the re-run for a new session; the Managing Intelligence restarts it, through the Launcher for a Worker, as its Launcher Protocol File says. With no reading, it continues and reports it.

Where the Agent requires closing Subagents, close a cold one after its report and a warm one when replaced or its scope ends. At the open-Subagent limit, close finished Subagents and dispatch again. With no resume tool, make every pass fresh; with no transcript size, skip that limit check. Report each unavailable capability.

### Versions and fresh reads

Before changing anything, stop if a `SKILL.md`, Subagent definition or `workflow.md` is from another Apiary version; say to resume the session. Read `workflow.md` and `.apiary` files from disk each run; Subagents read `workflow.md` and Guidance Documents when spawned. After an Apiary update, a resumed session's next run uses the new skills and Subagent definitions.

## Questions and stops

A skill or Subagent needing an answer or unable to continue stops and explains why in its output. Give all questions available at once, numbered in plain text, each with options, or state what must be fixed. Whoever started the run—the Managing Intelligence or the skill or Subagent above it—reads the output and decides. Never continue with missing or ambiguous information.

The Managing Intelligence answers in the session (through the Launcher for a Worker), or re-runs the skill with answers to continue the work.

## Ending a run

End every skill run with the next-step suggestions its `SKILL.md` lists. The Managing Intelligence may decline them.
