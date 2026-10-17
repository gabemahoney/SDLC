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
- **`.apiary` Folder:** a folder named `.apiary` holding a user's own Guidance Documents. The Project Folder's also holds the Project's settings, and `~/.apiary` the default settings.
- **Guidance Document:** one of seven user-written instruction files with fixed names: `engineering-best-practices.md`, `test-guide.md`, `doc-writing-guide.md`, `build-commands.md`, `maintained-docs.md`, `release-guide.md`, `bug-writing-guide.md`.
- **Default Fallback File:** Apiary's shipped default copy of a Guidance Document, in `~/.apiary`, used only where no user copy of that Guidance Document is found.
- **Protocol Files:** Apiary's Ticket System, Launcher and Agent Protocol Files, each holding everything specific to one ticket system, Launcher or Agent.
- **Source Reference:** a link on a ticket to where it came from outside the ticket system, such as a GitHub issue or a file. Read it as context.
- **Resolver:** the instructions for reading one kind of Source Reference, picked by its kind (a GitHub URL uses `github`, a file path uses `file`).
- **Run:** one execution of a skill, from its first steps to its report.
- **Thinking Level:** the model and effort a Subagent or Worker runs at (see Thinking Levels).

## Stores and ticket terms

| Store | Top-level ticket | Child tiers |
|---|---|---|
| Ideas | Idea | Doc |
| Plans | Plan | Epic → Task → Subtask |
| Bugs | Bug | None |
| Research | Research ticket | Report |

- An Idea is a piece of software to build: a feature, a change or a product.
- A Bug is a defect to validate and fix.
- A Plan is linked to one Idea, and an Idea has at most one Plan. The Ticket System Protocol File defines how tickets are linked.
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

**Idea:** write-idea → write-prd → req-review → write-srd → req-review → write-plan → write-epic for each Epic → develop-epic for each Epic → idea-review → the Managing Intelligence's testing. Each round of idea-review that has non-trivial findings files them as a Round Feedback Epic, which goes through write-epic and develop-epic before idea-review runs again.

An Idea has at most one PRD and one SRD, and needs both before planning. An Idea may have several TLA+ spec Docs, one per modelled SRD part. Run each req-review in a fresh session, not the one that wrote the PRD or SRD, so the review is independent. req-review is optional: the Managing Intelligence may skip it and mark the PRD, the SRD and the Idea `defined` by hand.

**Bug:** write-bug → define-bug → fix-bug → the Managing Intelligence checks the merged fix. Bugs whose fixes are returned go back to `draft` for define-bug.

**Research:** research → the Managing Intelligence accepts the Report.

## Shared rules

### Every Run

- Stop before any change, naming the file, if a file the Run needs is missing, empty or unreadable. That covers the `SKILL.md`, a Subagent definition, a Protocol File, and a Guidance Document with neither a user copy nor a Default Fallback File. A missing store stops the Run the same way; point to project-setup.
- If your skill's Gate fails, change nothing and say why.
- No skill or Subagent runs another Apiary skill.
- After a compaction, re-read the Protocol Files and Guidance Documents you loaded.
- Report pass, fail or not applicable for every required check and gate in the `SKILL.md` and its Guidance Documents, and name the Guidance Document copies or Default Fallback Files used.

### Project Folder, paths and worktrees

- **Project Folder:** the nearest folder, from the working directory up, that holds `.apiary/project_settings.md`. If there is none, the Project Folder is the folder the Agent started in, and settings come only from `~/.apiary/default_project_settings.md`. Project Folders don't nest.
- **Repos:** the Project's repos are its main checkouts under the Project Folder.
- **Git:** project-setup, write-idea, write-bug, write-prd, write-srd, req-review, write-plan, write-epic and research work without git. develop-epic, idea-review, define-bug, fix-bug, configure-worktree and teardown-worktree make repository changes and commits only inside repo checkouts.
- **Worktrees:** a worktree of a repo lives at `<Project Folder>/.worktrees/<ticket id>/<repo path>`, where `<repo path>` is the repo's path under the Project Folder.
- **Guidance Documents come from the main checkout,** never a worktree, because a worktree may hold guides still in development. Load only the ones your `SKILL.md` or Subagent definition names. Read every copy of each, starting from the `.apiary` Folder in the main checkout of the repo you're working in (or, outside a repo, the code folder you're working in), then each parent folder's `.apiary` up to `~/.apiary`. Use all the copies together (they are meant to be cumalitive), and ask the Managing Intelligence if they conflict. If there's no copy at all, use `~/.apiary/<name>-default-fallback.md`.
- **Commits:** commit per repo, naming the ticket. A Task that spans repos gets one commit per repo.
- **Pushing:** push only as the Project's `release-guide.md` allows.

### Settings

Read settings only from the Project Folder's `.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`. The first file naming a setting supplies its whole value.

If a setting the Run needs is missing from both files, stop before any change and point to project-setup.

Pass the settings and the Ticket System and Agent Protocol Files in every dispatch. Subagents use the supplied settings and Protocol Files, not their own lookup.

### Thinking Levels

A Thinking Level picks the model and effort a Subagent or Worker runs at. Two settings turn a level into a model:

- `thinking_levels` gives each skill and each non-executor Subagent Role a level, one `<name>: <label>` line each:
  ```
  ## thinking_levels
  write-plan: max
  Code Reviewer: xhigh
  ```
- `levels_claude_code` and `levels_codex` say what each level (`low` < `medium` < `high` < `xhigh` < `max`) means for that Agent, one line per level. Use only the model names they give.

Executors (Engineer, Test Writer, Doc Writer) have no line. They use their Task's or Bug's `thinking_level:` tag, and a Subtask uses its Task's. write-epic and develop-epic set Task tags; define-bug sets Bug tags.

If a line or mapping you need is missing, stop before any change and point to project-setup.

### Subagents

- A skill starts every Subagent fresh, with no earlier context, unless the skill says to reuse one.
- A Subagent loads the Guidance Documents of each repo it works in, and may read any repo for context.
- Subagents never talk to each other. The skill reads each report and passes on what the next Subagent needs. Their work passes through the files.

### Questions and stops

When you need an answer or can't continue, stop and say why. Never guess past missing or ambiguous information.
