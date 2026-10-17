# Apiary workflow

## Terms

- **Managing Intelligence:** the person, or a bot acting for one, who orchestrates Apiary: chooses the next skill, starts its Main Agent, answers questions and tests the results.
- **Agent:** the AI coding tool Apiary runs in: Claude Code or Codex CLI.
- **Main Agent:** an Agent started by the Managing Intelligence to run one skill and report back.
- **Child Agent:** an Agent started by a Main Agent to run one skill for it and report back. The Launcher keeps the parent–child relationship.
- **Skills Child Agents run:**
  - **engineer:** changes source code for a Task or Bug.
  - **test-writer:** writes unit and integration tests and runs assigned suites.
  - **doc-writer:** updates documentation for a Task or Bug.
  - **engineer-planner:** reads a Task's source context and proposes implementation Subtasks.
  - **test-writer-planner:** proposes testing Subtasks, fixtures and groups of tests that can be written in parallel.
  - **doc-writer-planner:** proposes a Task's documentation Subtasks.
  - **code-review:** checks source changes independently.
  - **test-review:** checks test quality, coverage and duplication independently.
  - **doc-review:** checks documentation changes and gaps independently.
  - **product-manager:** checks planned or finished work against requirements, for scope and proportion.
  - **researcher:** answers one research question with a cited Report.
  - **model-writer:** writes a Formal Model and runs its checker.
  - **model-review:** checks a Formal Model against the SRD before its checker runs.
- **Launcher:** the program that launches, resumes, watches and stops Main Agents and Child Agents, keeping their parent–child relationships.
- **Launcher Protocol File (`launcher.md`):** the instructions for those operations, including reading a Child Agent's context. The `launcher` setting selects `~/.apiary/system/protocols/launcher-<launcher>.md`, just as `ticket_system` selects `ticket-<ticket_system>.md`. Skills call the selected file `launcher.md`.
- **Project:** the software the Managing Intelligence builds with Apiary, with its repos, settings and tickets.
- **Project Folder:** the folder a Project lives in, holding its repos and their worktrees (see Project Folder, paths and worktrees).
- **`.apiary` Folder:** a folder named `.apiary` holding a user's own Guidance Documents. The Project Folder's also holds the Project's settings, and `~/.apiary` the default settings.
- **Guidance Document:** one of seven user-written instruction files with fixed names: `engineering-best-practices.md`, `test-guide.md`, `doc-writing-guide.md`, `build-commands.md`, `release-guide.md`, `bug-writing-guide.md` and `research-guide.md`. The Project's `doc-writing-guide.md` sets its documentation rules. Its `research-guide.md` guides sources, depth, evidence, Report shape, extra outputs after acceptance and when to involve a human.
- **Build Commands:** `build-commands.md` defines named sections for each code folder. Apiary names these sets of work as Terms so skills can sequence them: Lint before a commit, Unit Tests at the end of each Task and Integration Tests at the end of each Epic. Each code folder needs the first four sections below, each containing a command or `none` with a reason, so an empty entry never leaves the required work unclear.
  - **Compile** (`## Compile`): compilation or type-checking.
  - **Lint** (`## Lint`): lint and format checks.
  - **Unit Tests** (`## Unit tests`): the full unit suite.
  - **Integration Tests** (`## Integration tests`): the integration suites.
  - **Model Check** (`## Model check`): an optional section naming the formal-modelling language and the command that runs its checker. If a Formal Model needs checking and this section is missing, write-srd stops and asks the Managing Intelligence.

  Any other `##` section belongs to the Project; skills use it as the file describes.
- **Formal Model:** a formal specification checked by a model checker. **Model checking** means running that checker. A **Model Doc** holds a Formal Model and its attached files.
- **Default Fallback File:** Apiary's shipped default copy of a Guidance Document, in `~/.apiary`, used only where no user copy of that Guidance Document is found.
- **Protocol Files:** Apiary's Ticket System, Launcher and Agent Protocol Files, each holding everything specific to one ticket system, Launcher or Agent.
- **Dependency:** a link meaning one ticket can't start until another is `done`, such as between Epics or between Tasks.
- **Association:** a link between related tickets where neither waits on the other, such as a Plan and its Idea, or an SRD and a Research ticket it cites.
- **Source Reference:** a link on a ticket to where it came from outside the ticket system, such as a GitHub issue or a file. Read it as context.
- **Resolver:** the instructions for reading one kind of Source Reference, picked by its kind (a GitHub URL uses `github`, a file path uses `file`).
- **Run:** one execution of a skill, from its first steps to its report.
- **Thinking Level:** the model and effort an Agent runs at (see Thinking Levels).

## Stores and ticket terms

| Store | Top-level ticket | Child tiers |
|---|---|---|
| Ideas | Idea | Doc |
| Plans | Plan | Epic → Task → Subtask |
| Bugs | Bug | None |
| Research | Research ticket | Report |

- An Idea is a piece of software to build: a feature, a change or a product.
- A Bug is a defect to validate and fix.
- A Plan has an Association with one Idea, and an Idea has at most one Plan.
- A Plan divides an Idea into Epics, an Epic into Tasks (each committed in one go), and a Task into Subtasks (each one executor's part).
- A Doc describes an Idea: its Product Requirements Document (PRD, what and why), Software Requirements Document (SRD, what the software must do), Formal Model in a Model Doc, or another document.
- A Research ticket holds a research question. Its one Report holds the answer. A Report is not a Doc.

Every Epic is a vertical slice of the end product: one new feature or working part of a feature, through the whole stack of code, tests and docs, so each delivers something that can be demonstrated on its own. The one exception is a Round Feedback Epic: the Epic titled `Round <N> Feedback` that idea-review files in the Idea's Plan, holding a round's non-trivial findings. It need not be a vertical slice, because it groups corrections from one review round.

## Statuses

Ideas, Plans and Research use `draft`, `defined`, `active` and `done`. Bugs use those plus `invalid`. All status transitions are idempotent.

- `draft`: not fully written up.
- `defined`: fully written up.
- `active`: work in progress.
- `done`: complete.
- `invalid`: not a real Bug.

## Status Ownership

Each transition has exactly one owner. Change only the tickets and statuses your `SKILL.md` gives you.

The Managing Intelligence accepts Ideas and Bugs, returns Bugs and manages Docs other than the PRD, SRD and Model Docs.

## Flows

**Idea:** write-idea → write-prd → req-review → write-srd → req-review → write-plan → write-epic for each Epic → develop-epic for each Epic → idea-review → the Managing Intelligence's testing. Each round of idea-review that has non-trivial findings files them as a Round Feedback Epic, which goes through write-epic and develop-epic before idea-review runs again.

An Idea has at most one PRD and one SRD, and needs both before planning. An Idea may have several Model Docs, one per modelled SRD part. Run each req-review in a fresh session, not the one that wrote the PRD or SRD, so the review is independent. req-review is optional: the Managing Intelligence may skip it and mark the PRD, the SRD and the Idea `defined` by hand.

**Bug:** write-bug → define-bug → fix-bug → the Managing Intelligence checks the merged fix. Bugs whose fixes are returned go back to `draft` for define-bug.

**Research:** research → the Managing Intelligence accepts the Report.

## Shared rules

### Every Run

- Stop before any change, naming the file, if a file the Run needs is missing, empty or unreadable. That covers the `SKILL.md`, a Protocol File, and a Guidance Document with neither a user copy nor a Default Fallback File. A missing store stops the Run the same way; point to project-setup.
- If your skill's Gate fails, change nothing and say why.
- Every workflow skill runs in a Main Agent, because the Managing Intelligence orchestrates the work. A skill assigned to a Child Agent runs for its Main Agent; its own Gate requires that relationship. The Managing Intelligence chooses the next workflow skill, while a Main Agent launches the Child Agents its skill calls for.
- After a compaction, re-read the Protocol Files and Guidance Documents you loaded, because summaries can omit their rules.
- Report pass, fail or not applicable for every required check and gate in the `SKILL.md` and its Guidance Documents, and name the Guidance Document copies or Default Fallback Files used.

### Project Folder, paths and worktrees

- **Project Folder:** the nearest folder, from the working directory up, that holds `.apiary/project_settings.md`. If there is none, the Project Folder is the folder the Agent started in, and settings come only from `~/.apiary/default_project_settings.md`. Project Folders don't nest, so each folder resolves one Project's settings. Projects may share Research through `research_location`.
- **Repos:** the Project's repos are its main checkouts under the Project Folder.
- **Git:** project-setup, write-idea, write-bug, write-prd, write-srd, req-review, write-plan, write-epic and research work without git. develop-epic, idea-review, define-bug, fix-bug, configure-worktree and teardown-worktree make repository changes and commits only inside repo checkouts.
- **Worktrees:** a worktree of a repo lives at `<Project Folder>/.worktrees/<ticket id>/<repo path>`, where `<repo path>` is the repo's path under the Project Folder.
- **Guidance Documents come from the main checkout,** never a worktree, because a worktree may hold guides still in development. Load only the ones your `SKILL.md` names. Read every copy of each, starting from the `.apiary` Folder in the main checkout of the repo you're working in (or, outside a repo, the code folder you're working in), then each parent folder's `.apiary` up to `~/.apiary`. Use all the copies together (they are meant to be cumalitive), and ask the Managing Intelligence if they conflict. If there's no copy at all, use `~/.apiary/<name>-default-fallback.md`.
- **Commits:** commit per repo, naming the ticket. A Task that spans repos gets one commit per repo.
- **Pushing:** push only as the Project's `release-guide.md` allows.

### Settings

Read settings only from the Project Folder's `.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`. The first file naming a setting supplies its whole value, so a Project's setting replaces the default cleanly rather than mixing with it.

`research_location` names where Research tickets, their Reports and artifacts live. Every skill that reads or files Research uses this setting through the Ticket System Protocol File, including when following a linked Research ticket. Set it in `~/.apiary/default_project_settings.md` to share Research across Projects and bots using that default, because an answer may be useful beyond the Project that requested it. A Project value can select its own location. Research guidance still comes from the requesting Project's Guidance Documents.

If a setting the Run needs is missing from both files, stop before any change and point to project-setup.

Record Dependencies, Associations and Source References as the Ticket System Protocol File says, or as the `ticket_links` setting says where that file doesn't cover one.

Give each Child Agent the Run's resolved settings and Protocol File locations, including the Agent Protocol File for the tool it uses, so it follows the same Project configuration as its Main Agent.

### Launcher operations

`launcher.md` defines these named sections so project-setup can check every operation the skills rely on:

- `## Launch a Main Agent`: start the skill assigned by the Managing Intelligence.
- `## Launch a Child Agent`: start its assigned skill and keep it a child of its Main Agent.
- `## Resume a Child Agent`: continue that Child Agent's recorded session.
- `## Stop a Child Agent`: stop it and verify that it has exited.
- `## Read a Child Agent's context`: read or estimate that Child Agent's context fraction.

Each section must give usable instructions, because a heading alone cannot support the agent lifecycle. The file also describes watching both classes and stopping a Main Agent.

### Thinking Levels

A Thinking Level picks an Agent's model and effort. The caller resolves it before launch, as `launcher.md` describes, so every session starts with the intended settings.

- `thinking_levels` maps skill names to levels, one `<skill>: <label>` line each:
  ```
  ## thinking_levels
  write-plan: max
  code-review: xhigh
  engineer: high
  ```
- `levels_claude_code` and `levels_codex` map each level (`low` < `medium` < `high` < `xhigh` < `max`) to a model and effort for that Agent. Use the model names in those settings.

For `engineer`, `test-writer` and `doc-writer`, the assigned Task's or Bug's `thinking_level:<label>` tag overrides the skill's default, so effort follows the work's complexity and risk. A Subtask uses its Task's tag. write-epic and develop-epic set Task tags; define-bug sets Bug tags.

If a required skill line, tag or model mapping is missing, stop before any change and point to project-setup.

### Child Agents

A Main Agent launches a Child Agent with the assigned skill, as `launcher.md` describes. It gives the Child Agent ticket IDs, checkout paths and the Run's configuration so the Child Agent reads its instructions and progress from the tickets. Each Child Agent reports back to its Main Agent with the relevant ticket IDs and anything left unaddressed.

Start each Child Agent fresh unless the calling skill says to retain it, so unrelated work does not fill its context. Each Child Agent loads the Guidance Documents its skill names for every repo it works in and may read other repos for context. Work passes between Child Agents through files and tickets, coordinated by their Main Agent, so assignments and findings stay in one record.

### Context

Before each new unit of work, every Main Agent checks its own context fraction as its Agent Protocol File describes. At 75% or more, or when the fraction is unknown, record progress on the ticket and stop for the Managing Intelligence to start a fresh session with the same skill and ticket IDs, because a nearly full context causes mistakes.

Before resuming a retained Child Agent, read its context fraction as `launcher.md` describes. Resume only below 75%; otherwise, including an unknown reading, replace it with a fresh Child Agent that reads the ticket, because reuse saves work only while enough context remains.

### Tickets carry the information

Skills judge every finding returned by a review skill or product-manager and fix the ones they accept. Record only declined or unaddressed findings on the ticket they concern, each with its reason, so the next skill sees what remains. Product questions go to the Managing Intelligence, who decides the expected behaviour. idea-review hands its final findings to the Managing Intelligence to act on.

Main Agents and Child Agents keep decisions, repair instructions, progress and handoffs on the ticket they concern so later work can continue from the record. A launch, continuation or report names those tickets rather than repeating their contents, because copied instructions can drift from the record.

### Work outside the ticket

If you find work outside the current Idea or Bug, such as a refactor, a new defect or a missing feature, record it on the ticket and suggest it to the Managing Intelligence as a new Idea or Bug. Don't take it on, because whether to do it is their call.

### Questions and stops

When you need an answer or can't continue, stop and say why. Never guess past missing or ambiguous information.
