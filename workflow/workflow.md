# SDLC workflow

## Terms

- **Managing Intelligence:** the person or bot acting for one who chooses skills, starts Main Agents, answers questions and tests results.
- **User:** the person the Managing Intelligence acts for, or the Managing Intelligence itself when it is a person.
- **Agent:** the AI coding tool SDLC runs in: Claude Code, Codex CLI or Cursor.
- **Main Agent:** an Agent started by the Managing Intelligence to run one skill and report back.
- **Child Agent:** an Agent started by a Main Agent to run one skill for it and report back. The Launcher keeps the parent–child relationship.
- **Skills Child Agents run:**
  - **engineer:** changes source code for a Task or Bug.
  - **test-writer:** writes unit and integration tests and runs assigned suites.
  - **doc-writer:** updates documentation for a Task or Bug.
  - **engineer-planner:** reads a Task's source context and writes draft implementation Subtasks.
  - **test-writer-planner:** writes draft testing Subtasks that can be implemented in parallel and plans their fixtures.
  - **doc-writer-planner:** writes a Task's draft documentation Subtasks.
  - **req-review:** reviews one PRD or SRD independently for write-prd or write-srd.
  - **code-review:** checks source changes independently.
  - **test-review:** checks test quality, coverage and duplication independently.
  - **doc-review:** checks documentation changes and gaps independently.
  - **product-manager:** checks planned or finished work against requirements, for scope and proportion.
  - **research:** answers one research question with a cited Report. It also runs as a Main Agent.
  - **model-writer (Model Writer):** writes a Formal Model and runs its checker.
  - **model-review (Model Reviewer):** checks a Formal Model against the SRD before its checker runs.
- **Launcher:** the program that launches, resumes, watches and stops Main Agents and Child Agents, keeping their parent–child relationships.
- **Launcher Protocol File (`protocol:launcher.md`):** instructions for Launcher operations and Child Agent context readings. `setting:launcher` selects `~/.sdlc/install/protocols/launcher-<launcher>.md`; `setting:ticket_system` selects `protocol:ticket-<ticket_system>.md` there.
- **Project:** the software the Managing Intelligence builds with SDLC, with its repos, settings and tickets.
- **Project Folder:** the folder a Project lives in, holding its repos and their worktrees (see Project Folder, paths and worktrees).
- **`.sdlc` Folder:** a folder named `.sdlc` holding a user's own Guidance Documents. The Project Folder's also holds the Project's settings, and `~/.sdlc` the default settings.
- **Guidance Document:** one of seven instruction files: `guide:engineering-best-practices.md`, `guide:test-guide.md`, `guide:doc-writing-guide.md`, `guide:build-commands.md`, `guide:release-guide.md`, `guide:bug-writing-guide.md` and `guide:research-guide.md`. They set the Project's engineering, testing, documentation, build, release, Bug and research rules.
- **Build Commands:** named sections in `guide:build-commands.md` for sequencing checks. Each code folder needs the first four, containing a command or `none` with a reason so required work is explicit.
  - **Compile** (`guide:build-commands.md ## Compile`): compilation or type-checking.
  - **Lint** (`guide:build-commands.md ## Lint`): lint and format checks.
  - **Unit Tests** (`guide:build-commands.md ## Unit tests`): the full unit suite.
  - **Integration Tests** (`guide:build-commands.md ## Integration tests`): the integration suites.
  - **Model Check** (`guide:build-commands.md ## Model check`): an optional section naming the formal-modelling language and the command that runs its checker. If a Formal Model needs checking and this section is missing, write-srd stops and asks the Managing Intelligence.

  Any other `##` section belongs to the Project; skills use it as the file describes.
- **Formal Model:** a formal specification checked by a model checker. **Model checking** means running that checker. A **Model Doc** is a Doc under the Idea, next to the PRD and SRD, that holds a Formal Model, its attached files, review notes and checker results.
- **Default Fallback File:** the default copy of a Guidance Document shipped with SDLC, in `~/.sdlc`, used only where no user copy of that Guidance Document is found.
- **Protocol Files:** the SDLC Ticket System, Launcher and Agent Protocol Files, each holding everything specific to one ticket system, Launcher or Agent. `protocol:ticket.md` means the Ticket System Protocol File selected by `setting:ticket_system`.
- **Dependency:** a link meaning one ticket can't start until another is `done`, such as between Epics or between Tasks.
- **Association:** a link between related tickets where neither waits on the other, such as a Plan and its Idea, or an SRD and a Research ticket it cites.
- **Source Reference:** a link to a ticket's origin outside the ticket system, such as a GitHub issue or file. write-prd and define-bug use it to establish requirements. Downstream skills use the requirements on the tickets so external changes cannot silently change their scope.
- **Resolver:** the instructions for reading one kind of Source Reference, selected by its kind, with optional overrides in `setting:resolvers` (a GitHub URL uses `github`, a file path uses `file`).
- **Intake:** the file of instructions for taking in new Ideas or Bugs, whose path `setting:new_idea_intake` or `setting:new_bug_intake` holds. write-idea and write-bug also always accept plain text describing the work or defect.
- **Run:** one execution of a skill, from its first steps to its report.
- **Thinking Level:** the Agent, model and any effort or mode a session runs with (see Thinking Levels).

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
- A Doc describes an Idea: its Product Requirements Document (PRD: the product's features, what a user sees or interacts with; for an API, CLI or library, what a caller can do and rely on), Software Requirements Document (SRD: what the code does and how it does it, including exact interfaces and data shapes), Formal Model in a Model Doc, or another document.
- A Research ticket holds a research question. Its one Report holds the answer. A Report is not a Doc.

Every Epic is a vertical slice: a feature or working part of one, through code, tests and docs, that can be demonstrated independently. A **Round Feedback Epic**, titled `Round <N> Feedback`, is the exception. idea-review files it under the Idea's Plan to group one round's non-trivial corrections.

## Statuses

Ideas, Plans and Research use `draft`, `defined`, `active` and `done`. Bugs use those plus `invalid`. All status transitions are idempotent.

- `draft`: not fully written up.
- `defined`: fully written up.
- `active`: work in progress.
- `done`: complete.
- `invalid`: not a real Bug.

## Status Ownership

Each transition has exactly one owner. Change only the tickets and statuses your `SKILL.md` gives you.

The Managing Intelligence approves an Idea before write-prd and records the approval on the Idea, because the approved Idea bounds the PRD. It sets PRDs and SRDs `defined` on approval, and a `draft` Idea `defined` once both are approved. It sets Ideas and Bugs `done` on acceptance, sets them back to `active` when teardown-worktree hits a merge conflict (fix-bug resolves it for a Bug; for an Idea, idea-review files it as a Round Feedback Epic), and manages Docs other than the PRD, SRD and Model Docs.

### Temporary end-of-bee report (through 2026-11-12)

When you act as Managing Intelligence and accept an Idea or Bug as `done`, write or refresh its short report at `/home/horde/research/tickets/b.rvm/artifacts/end-of-bee/<project>-<ticket id>.md`, including work that changes no repo, because Research b.rvm needs one report per finished Idea or Bug. Use the Project Folder's name for `<project>` and create the directory if needed, so bots share a predictable destination. Remove this temporary subsection after 2026-11-12 unless the User extends it, because it is a bounded data collection exercise.

Use existing ticket history, job records and logs through acceptance to cover the following, citing ticket IDs and evidence locations so the report is factual and cheap to produce:

- Quality problems and the phase where each surfaced.
- The longest phases or steps, with wall times and their timestamp boundaries.
- Minor findings that triggered another round, owner or rerun, with the resulting elapsed time as possible nitpick cost.

Label missing timings unknown, distinguish waiting from work where evidence allows, and avoid summing overlapping intervals, because elapsed time alone does not prove wasted effort.

## Flows

**Idea:** write-idea → write-prd → write-srd → write-plan → configure-worktree → write-epic for each Epic → develop-epic for each Epic → idea-review → the Managing Intelligence's testing and acceptance → teardown-worktree → release. Each round of idea-review that has non-trivial findings files them as a Round Feedback Epic, which goes through write-epic and develop-epic before idea-review runs again. A round that finds an unmet PRD requirement no SRD requirement covers sends it back through write-srd and write-plan first.

An Idea has at most one PRD and one SRD, and needs both before planning. An Idea may have several Model Docs, one per modelled SRD part.

**Bug:** write-bug → define-bug → configure-worktree → fix-bug → the Managing Intelligence's testing and acceptance (`done`) → teardown-worktree → release. If the fix fails the Managing Intelligence's testing, they note what's still wrong under `## Decisions` on the Bug and run fix-bug again, in the same worktrees. define-bug doesn't run again, because it only weeds out reports that aren't real Bugs.

**Research:** research → whoever asked (the Managing Intelligence, or the Main Agent that launched it) accepts the Report.

## Shared rules

### Every Run

- Stop before any change, naming the file, if a file the Run needs is missing, empty or unreadable. That covers the `SKILL.md`, a Protocol File, and a Guidance Document with neither a user copy nor a Default Fallback File. A missing store stops the Run the same way; point to project-setup.
- If your skill's Gate fails, change nothing and say why.
- The Managing Intelligence runs no skills itself. It assigns each workflow skill to a Main Agent, which launches the Child Agents its skill names.
- After a compaction, re-read this workflow and the Protocol Files and Guidance Documents you loaded, because summaries can omit their rules.
- Report pass, fail or not applicable for every required check and gate in the `SKILL.md` and its Guidance Documents, and name the Guidance Document copies or Default Fallback Files used.

### Project Folder, paths and worktrees

- **Project Folder:** the nearest folder, from the working directory up, that holds `<Project Folder>/.sdlc/project_settings.md`. If there is none, the Project Folder is the folder the Agent started in, and settings come only from `~/.sdlc/default_project_settings.md`. Project Folders don't nest, so each folder resolves one Project's settings. Projects may share Research through `setting:research_location`.
- **Repos:** the Project's repos are its main checkouts under the Project Folder.
- **Git:** project-setup may clone or create repos but commits nothing. write-idea, write-bug, write-prd, write-srd, req-review, write-plan, write-epic and research work without git. develop-epic, idea-review, fix-bug, configure-worktree, teardown-worktree and release make repository changes only inside repo checkouts. define-bug reproduces defects in main checkouts without editing repository files.
- **Worktrees:** a worktree of a repo lives at `<Project Folder>/.worktrees/<ticket id>/<repo path>`, where `<repo path>` is the repo's path under the Project Folder.
- **Guidance Documents come from the main checkout,** because worktree guides may still be in development. Load only the guides your skill names. For each, read copies in the main checkout's `.sdlc` (or the current code folder's, outside a repo), then parent `.sdlc` folders and `~/.sdlc`. Combine copies cumulatively; the Managing Intelligence settles conflicts. With no user copy, use `~/.sdlc/<name>-default-fallback.md`.
- **Commits:** commit per repo, naming the ticket. A Task that spans repos gets one commit per repo.
- **Pushing:** push only as the Project's `guide:release-guide.md` allows.

### Settings

Read settings only from `<Project Folder>/.sdlc/project_settings.md`, then `~/.sdlc/default_project_settings.md`. The first file naming a setting supplies its whole value, so a Project's setting replaces the default cleanly rather than mixing with it.

`setting:research_location` locates Research tickets, Reports and artifacts through the Ticket System Protocol File, including linked Research. A home default shares Research across Projects and bots because answers may serve more than one Project; a Project setting overrides it. Research always uses the requesting Project's guidance.

`setting:child_watch_command` is optional: it names a host's command that waits on Child Agents, as `protocol:launcher.md ## Knowing when a Child Agent's state changes` describes. When it is unset, that section's fallback applies, so its absence never stops a Run.

If a setting the Run needs is missing from both files, stop before any change and point to project-setup.

Record Dependencies, Associations and Source References as the Ticket System Protocol File says, or as `setting:ticket_links` says where that file doesn't cover one.

### Intakes and Resolvers

Your intakes live in `~/.sdlc/intakes/` and your Resolvers in `~/.sdlc/resolvers/`. `install.sh` never writes there, so they survive SDLC upgrades. Shipped files live in `~/.sdlc/install/intakes/` and `~/.sdlc/install/resolvers/` and are replaced on installation.

Set `setting:new_idea_intake` and `setting:new_bug_intake` to the chosen file's absolute path, so each intake can use a shipped or user file. `setting:resolvers` is optional: add one `<kind>: <absolute path>` line for each custom or overridden Source Reference kind, so Projects can use their own instructions while keeping shipped Resolvers. For example:

```text
## resolvers
support: /home/you/.sdlc/resolvers/support.md
```

Use the mapped file when the kind has an entry; otherwise use `~/.sdlc/install/resolvers/<kind>.md`, including when `setting:resolvers` is unset, so existing Projects can read shipped source kinds without new settings. Stop if neither a mapping nor a shipped Resolver exists, because the source has no reading instructions. Check the selected file and its prerequisites before using it, because access depends on the source.

### References

Use these references, each in one pair of backticks, so an Agent knows whether to read a setting, walk up for a Guidance Document or open a Protocol File:

- A setting: `setting:<name>`, for example `setting:research_location`, in the settings files above.
- A Guidance Document: `guide:<file>`, for example `guide:research-guide.md`, found by the Guidance Document walk.
- A named guide section: `guide:<file> ## <Section>`, for example `guide:build-commands.md ## Integration tests`.
- A Protocol File: `protocol:<file>`, for example `protocol:agent-codex.md`, under `~/.sdlc/install/protocols/`; `protocol:launcher.md` means the file selected by `setting:launcher`.
- A named protocol section: `protocol:<file> ## <Section>`, for example `protocol:launcher.md ## Launching a Child Agent`.
- A file with one fixed place: its full path, for example `~/.sdlc/install/workflow.md` or `<Project Folder>/.sdlc/project_settings.md`.

### Ticket system operations

`protocol:ticket.md` defines these named sections, so project-setup can check the ticket system covers what the skills rely on:

- `protocol:ticket.md ## Prerequisites`: the ticket system and how to reach the stores.
- `protocol:ticket.md ## Create or check stores`: the four stores, their child tiers and statuses, including shared Research.
- `protocol:ticket.md ## SDLC records in bees`: how to keep the records that have no direct equivalent in the ticket system: updating one body section, Dependencies, Associations, Source References, attached files, Thinking Level tags, deleting a ticket and its links, and keeping Research from automatic archival.

Plain operations (create, read, find and update tickets, set status) use the ticket system directly.

### Launcher operations

`protocol:launcher.md` defines these named sections so project-setup can check every operation the skills rely on:

- `protocol:launcher.md ## Main Agents and Child Agents`: what each class is and how a Main Agent and its Child Agents communicate: how the Main Agent sends work and follow-ups, and how a Child Agent reports its result and asks a question, so both sides know how to reach the other.
- `protocol:launcher.md ## Reporting to your Main Agent`: how a Child Agent hands back its result.
- `protocol:launcher.md ## Launching a Main Agent`: start the skill assigned by the Managing Intelligence.
- `protocol:launcher.md ## Launching a Child Agent`: start its assigned skill and keep it a child of its Main Agent.
- `protocol:launcher.md ## Resuming a Child Agent`: continue that Child Agent's recorded session.
- `protocol:launcher.md ## Knowing when a Child Agent's state changes`: how the Main Agent learns that a Child Agent has finished, asked a question or stopped, so it never waits on a Child Agent that is already done.
- `protocol:launcher.md ## Stopping a Child Agent`: stop it and verify that it has exited.
- `protocol:launcher.md ## Reading a Child Agent's context`: read or estimate that Child Agent's context fraction.

Each section must give usable instructions, because a heading alone cannot support the agent lifecycle. The file also describes watching both classes and stopping a Main Agent.

### Thinking Levels

A Thinking Level picks an Agent, model and any effort or mode. The caller resolves it before launch, as `protocol:launcher.md` describes, so every session starts on the intended Agent with the intended settings.

- `setting:thinking_levels` maps skill names to levels, one `<skill>: <label>` line each:
  ```
  ## thinking_levels
  write-plan: max
  code-review: xhigh
  engineer: high
  ```
- `setting:levels` maps each level (`low` < `medium` < `high` < `xhigh` < `max`) to an `agent` (`claude-code`, `codex` or `cursor`), a `model` and that Agent's own `effort` for Claude Code and Codex, or optional `mode` for Cursor. Use the format in `~/.sdlc/install/templates/thinking-levels.md`, so setup and callers read the same mapping.

For `engineer`, `test-writer` and `doc-writer`, the assigned Task's or Bug's `thinking_level:<label>` tag overrides the skill's default, so the Agent, model and any effort or mode follow the work's complexity and risk. A Subtask uses its Task's tag. write-epic and develop-epic set Task tags; define-bug sets Bug tags.

If a skill line or `setting:levels` entry is missing, stop and point to project-setup. Before `setting:levels` resolves, the Managing Intelligence chooses project-setup's Agent, model and any effort or mode, because no level resolves until setup has run. A missing Task tag returns to its planning skill, because that skill judges the work's complexity. A missing Bug tag goes to the Managing Intelligence to set, because define-bug only runs on `draft` Bugs.

### Child Agents

Launch Child Agents on the Agent their Thinking Level resolves to through `protocol:launcher.md`, with the skill, ticket IDs and checkout paths, so each runs on the configured tool. Supply resolved settings and Protocol File locations, including the selected Agent's protocol, so each uses the same Project configuration. It reads work from tickets and reports their IDs and unresolved work to the Main Agent.

Start Child Agents fresh unless the skill retains them, so unrelated work does not fill context. Each loads its named guides for every assigned repo and may read other repos for context. The Main Agent coordinates their work through files and tickets.

### Context

Before each new unit of work, every Main Agent checks its own context fraction as its Agent Protocol File describes, and skips its own check where that file says no reading exists yet. At 75% or more, or when a reading should exist but can't be made, record progress on the ticket and stop for the Managing Intelligence to start a fresh session with the same skill and ticket IDs, because a nearly full context causes mistakes.

Before resuming any reused Child Agent, read its context fraction as `protocol:launcher.md` describes. Resume only below 75%; otherwise, including an unknown reading, replace it with a fresh Child Agent that reads the ticket, because reuse saves work only while enough context remains.

### Tickets carry the information

Skills judge every finding returned by a review skill or product-manager and fix the ones they accept. Record only declined or unaddressed findings on the ticket they concern, each with its reason, so the next skill sees what remains. Product questions go to the Managing Intelligence, who decides the expected behaviour. idea-review files non-trivial findings for correction and hands the result to the Managing Intelligence for acceptance.

Main Agents and Child Agents keep decisions, repair instructions, progress and handoffs on the ticket they concern so later work can continue from the record. A launch, continuation or report names those tickets rather than repeating their contents, because copied instructions can drift from the record.

### Work outside the ticket

If you find work outside the current Idea or Bug, such as a refactor, a new defect or a missing feature, record it on the ticket and suggest it to the Managing Intelligence as a new Idea or Bug. Don't take it on, because whether to do it is their call.

### Questions and stops

When you need an answer or can't continue, stop and say why. Never guess past missing or ambiguous information.
