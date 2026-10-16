# Apiary workflow

Every Apiary skill reads this rulebook when run; every Subagent reads it when spawned.

It holds the bird's-eye view of the workflow and common information required by more than one skill. Information specific to a skill lives in its `SKILL.md`; information specific to a Subagent Role lives in its Subagent definition.

## Terms

- **Managing Intelligence:** the person, or a bot acting for one, who drives Apiary: runs the skills, answers their questions, decides what work happens next and tests the results.
- **Agent:** the AI coding tool Apiary runs in: Claude Code or Codex CLI.
- **Subagent:** a helper an Agent starts inside its own session, with fresh context, to do one Subagent Role's work for a skill and report back.
- **Subagent Role:** the job a Subagent does, defined by its Subagent definition. Executors change files, writers write tickets, read-only Subagent Roles change nothing.
- **Worker:** a separate Agent session the Launcher starts to run one skill.
- **Launcher:** the program that starts, watches and stops Workers.
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
| `thinking_level:<label>` | The Thinking Level the executors working the ticket run at: one on each Task and Bug. Subtasks carry no tag and use their Task's. write-epic and develop-epic set their Tasks' tags. |

## Statuses

Ideas, Plans and Research use `draft`, `defined`, `active` and `done`. Bugs use those plus `invalid`. All status transitions are idempotent.

| Status | Meaning |
|---|---|
| `draft` | Not fully written up. |
| `defined` | Fully written up. |
| `active` | Work in progress. |
| `done` | Complete. |
| `invalid` | Not a real Bug. |

## Status Ownership

Each transition has exactly one owner. Change only the tickets and statuses your `SKILL.md` or Subagent definition gives you.

| Who | What they do |
|---|---|
| Filing and writing skills | Create Ideas, Bugs, Docs, Plans, Epics, Tasks and Subtasks. |
| TLA+ Writer | Writes TLA+ spec Docs. |
| req-review and define-bug | Review Docs and validate Bugs. |
| develop-epic and its executors | Track work on Ideas, Plans, Epics, Tasks and Subtasks. |
| idea-review | Reopens a Plan for a Round Feedback Epic. |
| fix-bug | Tracks work on a Bug. |
| research | Tracks the Research ticket and its Report. |
| Managing Intelligence | Accepts Ideas and Bugs, returns Bugs and manages other Docs. |

## Flows

**Idea:** write-idea → write-prd and write-srd → req-review → write-plan → write-epic for each Epic → develop-epic for each Epic → idea-review → the Managing Intelligence's testing. Each round of idea-review that has non-trivial findings files them as a Round Feedback Epic, which goes through write-epic and develop-epic before idea-review runs again.

Every Idea has exactly one PRD and one SRD; the writing skill updates an existing one. An Idea may have several TLA+ spec Docs, one per modelled SRD part; revisiting a part updates its spec. req-review is optional: the Managing Intelligence may skip it and mark the Idea `defined` by hand.

**Bug:** write-bug → define-bug → fix-bug → the Managing Intelligence checks the merged fix. Returned fixes go back to `draft` for define-bug.

**Research:** research files the Research ticket, runs review rounds through acceptance, and reopens it for further reviewer requests.

## State gates

Enforce your skill's gate before changing anything. If it fails, change nothing and say why.

## Source references

A source reference links a ticket to something outside the ticket system that it came from. The ticket system stores only the link; Apiary resolves and reads it. A source reference names its resolver by its kind (a GitHub URL uses `github`, a file path uses `file`). Follow that resolver's instructions at `~/.apiary/system/resolvers/<resolver>.md`. Read source references as context.

## Shared rules

### Starting, reporting and resuming

Before changing anything, identify your Agent, read the installed `workflow.md`, find the Project Folder (see Project Folder, paths and worktrees) and load settings (see Settings). Load these Protocol Files from `~/.apiary/system/protocols/`:
- your Agent's: `agent-claude-code.md` in Claude Code, `agent-codex.md` in Codex CLI;
- `ticket-<ticket_system>.md`, named by the `ticket_system` setting (e.g. `ticket-bees.md`), for ticket work;
- `launcher-<launcher>.md`, named by the `launcher` setting (e.g. `launcher-agent-director.md`), for configure-worktree and teardown-worktree outside worktree-only mode, and for project-setup to check the Launcher's prerequisites.

A Subagent uses the settings and Protocol Files its dispatch prompt names and looks nothing up itself. After a compaction, also re-read the Protocol Files you loaded and your Guidance Documents. Check the ticket ID or creation input, load the Guidance Documents your `SKILL.md` names (see Guidance Documents) and any templates it names, complete the fail-closed checks, then check the state gate.

Stop before any change, naming the file, if a Guidance Document your `SKILL.md` or Subagent definition names has neither a user copy nor a Default Fallback File, or a needed installed `workflow.md`, `SKILL.md`, Subagent definition or Protocol File is missing, empty or unreadable. A missing store stops the Run likewise; point to project-setup.

Read and follow a skill's installed `SKILL.md` whenever running it. No skill or Subagent runs another skill. Subagents follow their installed definitions. Report pass, fail or not applicable for every required check and gate in loaded `SKILL.md` files and Guidance Documents; name the Guidance Document copies or Default Fallback Files used.

### Project Folder, paths and worktrees

The Project Folder is the nearest folder, from the working directory up, containing `.apiary/project_settings.md`. Without one, use the folder the Agent started in and only `~/.apiary/default_project_settings.md`. Project Folders don't nest. The Project's repos are its main checkouts under the Project Folder, outside any other Project Folder.

Project-level skills—project-setup, write-idea, write-bug, write-prd, write-srd, req-review, write-plan, write-epic and research—must not assume git. Execution skills—develop-epic, idea-review, define-bug, fix-bug and the worktree skills—change files and commit only inside repo checkouts. release follows the process and conditions in `release-guide.md`.

Use absolute paths (`/…` or `~/…`) as given. A target inside a Project repo, however written, opens its copy in the checkout being worked in. Resolve a Guidance Document's relative pointers from the folder holding that Guidance Document. Resolve its other relative paths from the checkout's root.

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

Files sit directly in each `.apiary` Folder. User copies are `<name>.md`. Only if no user copy exists, read `~/.apiary/<name>-default-fallback.md` alone. Every user copy adds up, including all its checks and gates. If guidance conflicts, stop and ask the Managing Intelligence which to follow, naming both files and the conflicting lines.

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

Before a Run dispatches a Subagent or launches a Worker, it checks the `thinking_levels` line for that Subagent Role or the Worker's skill, and the `levels_<agent>` mapping for the Agent it runs in. A missing line or mapping stops the Run before changes, naming it and pointing to project-setup.

For a Task or Bug starting work with a missing, unknown or repeated `thinking_level:` tag, ask the Managing Intelligence for its Thinking Level, set the tag and continue.

Dispatch through the Agent Protocol File with the mapped model and effort. Worker launches use the Worker's Agent's mapping and Launcher Protocol File.

If a Thinking Level cannot be applied, report it and use the session's model and effort; never stop. Retry dispatches or launches rejected for model or effort without them, and report it.

### Subagent dispatch and reuse

A Subagent loads the Guidance Documents of each repo it works in and may read any repo for context.

**Fresh start:** a new dispatch with no earlier context.

**Reuse:** resume the same Subagent for its Task or Bug. Keep its Guidance Documents; newly assigned repos add theirs.

- **Executors (Engineer, Test Writer, Doc Writer):** dispatch one Engineer, one Doc Writer and one Test Writer per lane for each Task (or for the Bug in fix-bug). Fix rounds reuse only the executors whose work the findings touch. The next Task or Bug starts fresh executors.
- **Everything else:** fresh start every dispatch—the planners; Code, Test and Doc Reviewers; Product Manager; Requirements Reviewer; TLA+ Writer; TLA+ Reviewer; Integration Tester.

#### Replacing an executor

Resume it for each fix round; if it can't continue, start a fresh one with the findings and the work so far.

#### Handoff

Subagents never talk to each other. The skill coordinates them: it reads each Subagent's report and passes what the next one needs in that one's dispatch or resume message. The work itself passes through the files: each Subagent sees the changes earlier ones made in its checkouts.

#### Progress record

On the skill's ticket, record each warm Subagent's Subagent Role, Task or Bug, ID from the Agent, name if available and dispatch Thinking Level; update after each report. Resume from it after compaction or a re-run, by name if available, otherwise ID.

## Questions and stops

When you need an answer or can't continue, stop and say why. Never guess past missing or ambiguous information. Ask all your questions at once, numbered, each with options. A skill that interviews in rounds follows its own round rules instead.

## Ending a Run

End every skill Run with the next-step suggestions its `SKILL.md` lists.
