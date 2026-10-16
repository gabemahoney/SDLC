# Apiary workflow

## Terms

- **Managing Intelligence:** the person, or a bot acting for one, who drives Apiary: runs the skills, answers their questions, decides what work happens next and tests the results.
- **Agent:** the AI coding tool Apiary runs in: Claude Code or Codex CLI.
- **Subagent:** a helper an Agent starts inside its own session, with fresh context, to do one Subagent Role's work for a skill and report back.
- **Subagent Role:** the job a Subagent does, defined by its Subagent definition. Executors change files. Writers write tickets. Read-only Subagent Roles change nothing.
- **Worker:** a separate Agent session the Launcher starts to run one skill.
- **Launcher:** the program that starts, watches and stops Workers.
- **Project:** the software the Managing Intelligence builds with Apiary, with its repos, settings and tickets.
- **Project Folder:** the folder a Project lives in, holding its repos and their worktrees (see Project Folder, paths and worktrees).
- **`.apiary` Folder:** a folder named `.apiary` holding a user's own Guidance Documents for the folder it sits in, and settings in the Project Folder and `~`.
- **Guidance Document:** one of seven user-written instruction files with fixed names: `engineering-best-practices.md`, `test-guide.md`, `doc-writing-guide.md`, `build-commands.md`, `maintained-docs.md`, `release-guide.md`, `bug-writing-guide.md`.
- **Default Fallback File:** Apiary's shipped default copy of a Guidance Document, in `~/.apiary`, used only where no user copy of that Guidance Document is found.
- **Protocol Files:** Apiary's Ticket System, Launcher and Agent Protocol Files, each holding everything specific to one ticket system, Launcher or Agent.
- **Source Reference:** a link on a ticket to where it came from outside the ticket system, such as a GitHub issue or a file. Read it as context.
- **Resolver:** the instructions for reading one kind of Source Reference, picked by its kind (a GitHub URL uses `github`, a file path uses `file`).
- **Run:** one execution of a skill, from its first steps to its report.
- **Thinking Level:** one of `low`, `medium`, `high`, `xhigh` or `max`, picking the model and effort a session or Subagent runs at.

## Stores and ticket terms

| Store | Top-level ticket | Child tiers |
|---|---|---|
| Ideas | Idea | Doc |
| Plans | Plan | Epic → Task → Subtask |
| Bugs | Bug | None |
| Research | Research ticket | Report |

- An Idea is a piece of software to build: a feature, a change or a product.
- A Bug is a defect to validate and fix.
- A Plan divides an Idea into Epics, an Epic into Tasks (each committed in one go), and a Task into Subtasks (each one executor's part).
- A Doc describes an Idea: its Product Requirements Document (PRD, what and why), Software Requirements Document (SRD, what the software must do), TLA+ spec (a model-checked design), or another document.
- A Research ticket holds a research question. Its one Report holds the answer. A Report is not a Doc.

Every Epic is a vertical slice through the product, never an Epic of only testing, docs or plumbing. The one exception is a Round Feedback Epic: the Epic titled `Round <N> Feedback` that idea-review files in the Idea's Plan, holding a round's non-trivial findings. It need not be a vertical slice.

## Statuses

Ideas, Plans and Research use `draft`, `defined`, `active` and `done`. Bugs use those plus `invalid`. All status transitions are idempotent.

- `draft`: not fully written up.
- `defined`: fully written up.
- `active`: work in progress.
- `done`: complete.
- `invalid`: not a real Bug.

## Status Ownership

Each transition has exactly one owner. Change only the tickets and statuses your `SKILL.md` or Subagent definition gives you.

The Managing Intelligence accepts Ideas and Bugs, returns Bugs and manages Docs other than the PRD, SRD and TLA+ specs.

## Flows

**Idea:** write-idea → write-prd and write-srd → req-review → write-plan → write-epic for each Epic → develop-epic for each Epic → idea-review → the Managing Intelligence's testing. Each round of idea-review that has non-trivial findings files them as a Round Feedback Epic, which goes through write-epic and develop-epic before idea-review runs again.

Every Idea has exactly one PRD and one SRD. An Idea may have several TLA+ spec Docs, one per modelled SRD part. req-review is optional: the Managing Intelligence may skip req-review and mark the Idea `defined` by hand.

**Bug:** write-bug → define-bug → fix-bug → the Managing Intelligence checks the merged fix. Bugs whose fixes are returned go back to `draft` for define-bug.

**Research:** research → the Managing Intelligence accepts the Report.

## Shared rules

### Starting, reporting and resuming

- Stop before any change, naming the file, if a file the Run needs is missing, empty or unreadable. That covers `workflow.md`, the `SKILL.md`, a Subagent definition, a Protocol File, and a Guidance Document with neither a user copy nor a Default Fallback File. A missing store stops the Run the same way; point to project-setup.
- If your skill's Gate fails, change nothing and say why.
- No skill or Subagent runs another skill.
- After a compaction, re-read the Protocol Files and Guidance Documents you loaded.
- Report pass, fail or not applicable for every required check and gate in the `SKILL.md` and its Guidance Documents, and name the Guidance Document copies or Default Fallback Files used.

### Project Folder, paths and worktrees

The Project Folder is the nearest folder, from the working directory up, containing `.apiary/project_settings.md`. If no such settings file is found, use the folder the Agent started in as the Project Folder and read settings only from `~/.apiary/default_project_settings.md`. Project Folders don't nest. The Project's repos are its main checkouts under the Project Folder, outside any other Project Folder.

Project-level skills—project-setup, write-idea, write-bug, write-prd, write-srd, req-review, write-plan, write-epic and research—must not assume git. Execution skills—develop-epic, idea-review, define-bug, fix-bug, configure-worktree and teardown-worktree—change files and commit only inside repo checkouts.

Use absolute paths (`/…` or `~/…`) as given. A target inside a Project repo, however written, opens its copy in the checkout being worked in. Resolve a Guidance Document's relative pointers from the folder holding that Guidance Document. Resolve its other relative paths from the checkout's root.

- **Where worktrees live:** only at `<Project Folder>/.worktrees/<ticket id>/<repo path>`, where `<repo path>` is relative to the Project Folder.
- **Where to work:** this rule applies to develop-epic and idea-review, and to write-plan and write-epic for the repos they plan in. When started in `<Project Folder>/.worktrees/<ticket id>/`, these skills work only in that ticket's worktrees. Otherwise, they work in the main checkouts.
- **How to commit:** commit per repo, naming the ticket. A Task spanning repos gets one commit per repo.
- **Who pushes:** push only as the Project's `release-guide.md` allows.

### Settings

Read settings only from the Project Folder's `.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`. The first file naming a setting supplies its whole value.

If a setting your skill needs is missing from both files, stop before any change and point to project-setup.

Pass the settings and the Ticket System and Agent Protocol Files in every dispatch. Subagents use the supplied settings and Protocol Files, not their own lookup.

### Guidance Documents

Load only the Guidance Documents your `SKILL.md` or Subagent definition names. To find one, `<name>.md`:

1. Start in the main checkout of the repo you're working in, or in your current directory if you're not working in a repo.
2. Walk up to `~`, reading `<name>.md` from each folder's `.apiary` Folder, including `~/.apiary`.
3. Use every copy you find, together. If two copies conflict, stop and ask the Managing Intelligence which to follow, naming both files and the conflicting lines.
4. If you find none, use `~/.apiary/<name>-default-fallback.md`.

If a copy is only a pointer to other files, follow it.

### Thinking Levels

`levels_<agent>` means `levels_claude_code` for Claude Code or `levels_codex` for Codex CLI. Each setting maps the ordered labels `low` < `medium` < `high` < `xhigh` < `max` to that Agent's model and effort, one plain-language line per label. Model names come only from these mappings.

The `thinking_levels` setting (see Settings) holds one `<name>: <label>` line per skill and non-executor Subagent Role, for example:

```
## thinking_levels
write-plan: max
develop-epic: medium
Code Reviewer: xhigh
```

- A Worker runs at the Thinking Level on its skill's line in `thinking_levels`. A non-executor Subagent runs at the Thinking Level on its Subagent Role's line.
- Engineer, Test Writer and Doc Writer have no lines in `thinking_levels`: they always use their Task's or Bug's `thinking_level:` tag. Subtasks carry no tag and use their Task's Thinking Level. write-epic and develop-epic set their Tasks' tags.
- A resumed Subagent keeps its first dispatch's Thinking Level.
- A session the Managing Intelligence starts itself runs at the model and effort the session was started with.

Before a Run dispatches a Subagent or launches a Worker, check the `thinking_levels` line for that Subagent Role or the Worker's skill. Also check the `levels_<agent>` mapping for the Agent the Subagent or Worker runs in. A missing line or mapping stops the Run before changes, naming the missing line or mapping and pointing to project-setup.

For a Task or Bug starting work with a missing, unknown or repeated `thinking_level:` tag, ask the Managing Intelligence for its Thinking Level, set the tag and continue.

Dispatch through the Agent Protocol File with the mapped model and effort. Worker launches use the Worker's Agent's mapping and Launcher Protocol File.

If a Thinking Level cannot be applied, report the failure and use the session's model and effort. Never stop because a Thinking Level cannot be applied. Retry dispatches or launches rejected for model or effort without specifying the model or effort, and report the retry.

### Subagent dispatch and reuse

A Subagent loads the Guidance Documents of each repo it works in and may read any repo for context.

**Fresh start:** a new dispatch with no earlier context.

**Reuse:** resume the same Subagent for its Task or Bug. Keep its Guidance Documents. Add the Guidance Documents of any newly assigned repos.

- **Executors (Engineer, Test Writer, Doc Writer):** dispatch one Engineer, one Doc Writer and one Test Writer per lane for each Task (or for the Bug in fix-bug). Fix rounds reuse only the executors whose work the findings touch. The next Task or Bug starts fresh executors.
- **Every other Subagent Role:** starts fresh on every dispatch. These are the planners, the Code, Test and Doc Reviewers, the Product Manager, the Requirements Reviewer, the TLA+ Writer, the TLA+ Reviewer and the Integration Tester.

#### Replacing an executor

Resume the executor for each fix round. If the executor can't continue, start a fresh executor with the findings and the work so far.

#### Handoff

Subagents never talk to each other. The skill coordinates them: it reads each Subagent's report and passes what the next one needs in that one's dispatch or resume message. The work itself passes through the files: each Subagent sees the changes earlier ones made in its checkouts.

#### Progress record

On the skill's ticket, record each Subagent kept for reuse: its Subagent Role, its Task or Bug, its ID from the Agent, its name if available, and its dispatch Thinking Level.

Update the record after each report. After compaction or a re-run, use the record to resume each Subagent by name if available, otherwise by ID.

## Questions and stops

When you need an answer or can't continue, stop and say why. Never guess past missing or ambiguous information. Ask all your questions at once, numbered, each with options. A skill that interviews in rounds follows its own round rules instead.

## Ending a Run

End every skill Run with the next-step suggestions its `SKILL.md` lists.
