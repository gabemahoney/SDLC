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
- **Run:** one execution of a skill, from its first steps to its report.
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
| `thinking_level:<label>` | The Thinking Level the executors working the ticket run at: one on each Task and Bug. Subtasks carry no tag and use their Task's. write-epic and develop-epic set their Tasks' tags; define-bug sets a Bug's. |

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
| Task                                  | write-epic creates `draft`, then sets `defined`; develop-epic also creates integration fix Tasks `draft`, sets their `thinking_level:` tags and sets them `defined`; develop-epic sets Tasks `active`, then `done`; `done` requires every Subtask to be `done`.                                                                                                                                                                                                                                                                                                                              |
| Subtask                               | write-epic creates `draft`, then sets `defined` for its Tasks; develop-epic does the same for its integration fix Tasks; the executor working it sets `active`, then `done`.                                                                                                                                                                                                                                                                                                                                                               |
| Bug                                   | write-bug or the Managing Intelligence creates `draft`, not yet validated; define-bug sets `defined` after reproducing and validating it, and sets its `thinking_level:` tag; define-bug sets `invalid` when the Bug is not real, with a note saying why; fix-bug sets `active`; the Managing Intelligence sets `done` after checking the merged fix or agreeing with the invalidity note; the Managing Intelligence sets it back to `draft` to send it back to define-bug. |
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

Stop before any change, naming the file, if a Guidance Document your `SKILL.md` or Subagent definition names has neither a user copy nor a Default Fallback File, or a needed installed `workflow.md`, `SKILL.md`, Subagent definition or Protocol File is missing, empty or unreadable. A missing store stops the Run likewise; point to project-setup.

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

The seven names are `ticket_system`, `launcher`, `new_idea_intake`, `new_bug_intake`, `levels_claude_code`, `levels_codex` and `thinking_levels`. Each value is the text below its `## <setting name>` heading up to the next `##` heading; text before the first heading is a comment. A malformed settings file stops the Run, naming it. If neither file names a required setting, the Run stops before changes, naming it and pointing to project-setup. Ticket systems, Launchers and intake approaches must be ones Apiary ships.

Pass the settings and the Ticket System and Agent Protocol Files in every dispatch; Subagents use those, not their own lookup.

### Guidance Documents

Load only the Guidance Documents your `SKILL.md` or Subagent definition names; read no others. Read every user copy of each of them from the working folder's `.apiary` through each parent, including `~/.apiary`. In a repo checkout, start at that checkout's `.apiary`, then its parent; a worktree uses its branch's committed copy. Outside `~`, walk to `/`, then read `~/.apiary` once.

Files sit directly in each `.apiary` Folder. User copies are `<name>.md`. Only if no user copy exists, read `~/.apiary/<name>-default-fallback.md` alone. Every user copy adds up, including all its checks and gates; any user copy disables the Default Fallback File. If guidance conflicts, stop and ask the Managing Intelligence which to follow, naming both files and the conflicting lines.

A Guidance Document may consist entirely of a pointer to other files. Open targets as plain references under the path rule: no walk, combining or Default Fallback File. Report a missing target; stop if the work requires it.

### Thinking Levels

`levels_<agent>` maps `low` < `medium` < `high` < `xhigh` < `max` to an Agent's model and effort, one plain-language line per label. Model names come only from these mappings.

The `thinking_levels` setting (see Settings) holds one `<name>: <label>` line per skill and non-executor Subagent Role, for example:

```
## thinking_levels
write-plan: max
develop-epic: medium
Code Reviewer: xhigh
```

- A Worker runs at its skill's line; a non-executor Subagent at its Subagent Role's.
- Engineer, Test Writer and Doc Writer have no lines: they always use their Task's or Bug's `thinking_level:` tag. Subtasks carry no tag and use their Task's.
- A resumed Subagent keeps its first dispatch's Thinking Level.
- A session the Managing Intelligence starts itself runs at whatever it was started with.

At startup, a Run checks the `levels_<agent>` mapping for its Agent and the `thinking_levels` lines for its skill, each non-executor Subagent Role it dispatches and, for configure-worktree, its Worker's skill. A missing mapping or line stops the Run before changes, naming it and pointing to project-setup.

For a Task or Bug starting work with a missing, unknown or repeated `thinking_level:` tag, ask the Managing Intelligence for its Thinking Level, set the tag and continue.

Dispatch through the Agent Protocol File with the mapped model and effort. Worker launches use the Worker's Agent's mapping and Launcher Protocol File.

If a Thinking Level cannot be applied, report it and use the session's model and effort; never stop. Retry dispatches or launches rejected for model or effort without them, and report it.

### Subagent dispatch and reuse

Name each Subagent's repos and checkouts in its dispatch; it loads their Guidance Documents and may read any repo for context.

**Fresh start:** a new dispatch with a self-contained prompt and no earlier context.

**Reuse:** resume the same Subagent for its Task or Bug. Give a self-contained message: findings and chosen fix in full, other changes since its last pass, and what to report; omit context it holds. Keep its first dispatch's Thinking Level and Guidance Documents; newly assigned repos add theirs.

- **Executors (Engineer, Test Writer, Doc Writer):** dispatch one Engineer, one Doc Writer and one Test Writer per lane for each Task (or for the Bug in fix-bug). Fix rounds reuse only the executors whose work the findings touch. The next Task or Bug starts fresh executors.
- **Everything else:** fresh start every dispatch—the planners; Code, Test and Doc Reviewers; Product Manager; Requirements Reviewer; TLA+ Writer; TLA+ Reviewer; Integration Tester.

#### Replacing an executor

Resume it for each fix round. If it can't continue, because its context is full or the resume fails, start a fresh one with the findings and the work so far.

#### Handoff

Subagents never talk to each other. The skill coordinates them: it reads each Subagent's report and passes what the next one needs in that one's dispatch or resume message. The work itself passes through the files: each Subagent sees the changes earlier ones made in its checkouts.

#### Progress record

On the skill's ticket, record each warm Subagent's Subagent Role, Task or Bug, ID from the Agent, name if available and dispatch Thinking Level; update after each report. Resume from it after compaction or a re-run, by name if available, otherwise ID. A stale name or ID fails the resume and goes fresh.

#### Context guard

Before each Task after the first, develop-epic checks its own context use per the Agent Protocol File. At 75% or more, or a reading older than its freshness window, stop at that Task boundary and name the re-run for a new session. The Managing Intelligence restarts it, through the Launcher for a Worker, per its Launcher Protocol File. With no reading, continue and report it.

#### Agent limits

Where the Agent requires closing, close cold Subagents after reporting, warm ones when replaced or their Task or Bug ends. At the open-Subagent limit, close finished Subagents and dispatch again. Without a resume tool, every pass gets a fresh start. Report each unavailable capability.

### Versions and fresh reads

Before changing anything, stop if a `SKILL.md`, Subagent definition or `workflow.md` is from another Apiary version; say to resume the session. Read `workflow.md` and `.apiary` files from disk each Run; Subagents read `workflow.md` and Guidance Documents when spawned. After an Apiary update, a resumed session's next Run uses the new skills and Subagent definitions.

## Questions and stops

A skill or Subagent needing an answer or unable to continue stops and explains why in its output. Give all questions available at once, numbered in plain text, each with options, or state what must be fixed. Whoever started the Run—the Managing Intelligence or the skill or Subagent above it—reads the output and decides. Never continue with missing or ambiguous information.

The Managing Intelligence answers in the session (through the Launcher for a Worker), or re-runs the skill with answers to continue the work.

## Ending a Run

End every skill Run with the next-step suggestions its `SKILL.md` lists. The Managing Intelligence may decline them.
