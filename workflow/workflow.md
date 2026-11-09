# SDLC workflow

## Terms

- **Managing Intelligence:** the person or bot acting for one who chooses skills, starts Main Agents, answers questions, tests results and writes retrospectives.
- **User:** the person the Managing Intelligence acts for, or the Managing Intelligence itself when it is a person.
- **Agent:** the AI coding tool SDLC runs in: Claude Code, Codex CLI or Cursor.
- **Main Agent:** an Agent started by the Managing Intelligence to run one skill and report back.
- **Child Agent:** an Agent started by a Main Agent to run one skill for it and report back. The Launcher keeps the parent–child relationship.
- **Skills Child Agents run:**
  - **engineer:** changes source code for a Task, Bug or Tweak, and a small Bug fix's or Tweak's tests and docs.
  - **test-writer:** writes unit and integration tests and runs assigned suites.
  - **doc-writer:** updates documentation for a Task or Bug.
  - **engineer-planner:** reads a Task's source context and writes draft implementation Subtasks.
  - **test-writer-planner:** writes draft testing Subtasks that can be implemented in parallel and plans their fixtures.
  - **doc-writer-planner:** writes a Task's draft documentation Subtasks.
  - **req-review:** reviews one PRD or SRD independently for write-prd or write-srd.
  - **code-review:** checks source changes independently, and a small Bug fix's or Tweak's whole change.
  - **test-review:** checks test quality, coverage and duplication independently.
  - **doc-review:** checks documentation changes and gaps independently.
  - **product-manager:** checks planned or finished work against requirements, for scope and proportion.
  - **research:** answers one research question with a cited Report. It also runs as a Main Agent.
  - **model-writer (Model Writer):** writes a Formal Model and runs its checker. It also runs as a Main Agent for during-build checks.
  - **model-review (Model Reviewer):** checks a Formal Model against the SRD before its checker runs.
- **Launcher:** the program that launches, resumes, watches and stops Main Agents and Child Agents, keeping their parent–child relationships.
- **Launcher Protocol File (`protocol:launcher.md`):** instructions for Launcher operations and Child Agent context readings. `setting:launcher` selects `~/.sdlc/install/protocols/launcher-<launcher>.md`; `setting:ticket_system` selects `protocol:ticket-<ticket_system>.md` there.
- **Project:** the software the Managing Intelligence builds with SDLC, with its repos, settings and tickets.
- **Project Folder:** the folder a Project lives in, holding its repos and their worktrees (see Project Folder, paths and worktrees).
- **`.sdlc` Folder:** a folder named `.sdlc` holding a user's own Guidance Documents. The Project Folder's also holds the Project's settings, and `~/.sdlc` the default settings.
- **Guidance Document:** one of seven instruction files: `guide:engineering-best-practices.md`, `guide:test-guide.md`, `guide:doc-writing-guide.md`, `guide:build-commands.md`, `guide:release-guide.md`, `guide:bug-writing-guide.md` and `guide:research-guide.md`. They set the Project's engineering, testing, documentation, build, release, Bug and research rules.
- **Build Commands:** named sections in `guide:build-commands.md` for sequencing checks. Each code folder needs the first four, containing a command or `none` with a reason so required work is explicit. A check that runs outside the session, such as a scheduler job, also names the command that blocks until it ends, so no Agent polls it.
  - **Compile** (`guide:build-commands.md ## Compile`): compilation or type-checking.
  - **Lint** (`guide:build-commands.md ## Lint`): lint and format checks.
  - **Unit Tests** (`guide:build-commands.md ## Unit tests`): the full unit suite.
  - **Integration Tests** (`guide:build-commands.md ## Integration tests`): the integration suites.
  - **Model Check** (`guide:build-commands.md ## Model check`): an optional section naming the formal-modelling language, the command that runs its checker, the command that only parses model files, and the time cap for gating checker runs: 30 minutes if unset, and never over 1 hour, because a gating run still going then is a model defect. During-build runs use the gating cap unless the section gives a longer one, so every run has a defined cap that can still fit checks too slow to gate. If a Formal Model needs checking and this section is missing, write-srd stops and asks the Managing Intelligence.

  Any other `##` section belongs to the Project; skills use it as the file describes.
- **Formal Model:** a formal specification checked by a model checker. **Model checking** means running that checker. A **Model Doc** is a Doc under the Idea, next to the PRD and SRD, that holds a Formal Model, its attached files, review notes and checker results.
  - **Gating check:** a model check that guards a PRD requirement or acceptance criterion that must always hold, covers a new or changed mechanism, and would change the design's shape (its records, states, protocol or interfaces) if it failed. It must pass before coding starts, because code written first could be thrown away.
  - **During-build check:** every other model check. It runs while the Idea is built, because its failure is fixed without reshaping the design. It also includes gating checks moved here, with the reason recorded, when they can't finish in hours; moving a check changes its phase, not its requirement.
- **Default Fallback File:** the default copy of a Guidance Document shipped with SDLC, in `~/.sdlc`, used only where no user copy of that Guidance Document is found.
- **Protocol Files:** the SDLC Ticket System, Launcher and Agent Protocol Files, each holding everything specific to one ticket system, Launcher or Agent. `protocol:ticket.md` means the Ticket System Protocol File selected by `setting:ticket_system`.
- **Dependency:** a link meaning one ticket can't start until another is `done`, such as between Epics or between Tasks.
- **Association:** a link between related tickets where neither waits on the other, such as a Plan and its Idea, or an SRD and a Research ticket it cites.
- **Source Reference:** a link to a ticket's origin outside the ticket system, such as a GitHub issue or file. write-prd and define-bug use it to establish requirements. Downstream skills use the requirements on the tickets so external changes cannot silently change their scope.
- **Resolver:** the instructions for reading one kind of Source Reference, selected by its kind, with optional overrides in `setting:resolvers` (a GitHub URL uses `github`, a file path uses `file`).
- **Intake:** the file of instructions for taking in new Ideas, Tweaks or Bugs, whose path `setting:new_idea_intake` or `setting:new_bug_intake` holds. write-idea and write-bug also always accept plain text describing the work or defect.
- **Run:** one execution of a skill, from its first steps to its report.
- **Thinking Level:** the Agent, model, any effort or mode and any launch template a session runs with (see Thinking Levels).

## Stores and ticket terms

| Store | Top-level ticket | Child tiers |
|---|---|---|
| Ideas | Idea | Doc |
| Plans | Plan | Epic → Task → Subtask |
| Bugs | Bug | None |
| Research | Research ticket | Report |

- An Idea is a piece of software to build: a feature, a change or a product.
- A Tweak is a minor feature: an Ideas-store ticket, marked as `protocol:ticket.md` says, with no Docs and only the Tweak flow.
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

Executors set their Subtasks `active` and `done`; only develop-epic sets a `done` Subtask back to `active`, to reopen it for a repair.

The Managing Intelligence records the User's approval on an Idea before write-prd, because the approved Idea bounds the PRD, and on a Tweak, setting it `defined`. It sets PRDs and SRDs `defined` on approval, and a `draft` Idea `defined` once both are approved. It sets Ideas, Tweaks and Bugs `done` on acceptance, sets them back to `active` when their merge hits a conflict (fix-bug or build-tweak resolves it for a Bug or Tweak; for an Idea, idea-review files it as a Round Feedback Epic), sets a Tweak `draft` when it becomes an Idea, and manages Docs other than the PRD, SRD and Model Docs.

### Managing Intelligence retrospectives

From an Idea's or Tweak's approval or a Bug's filing to its acceptance, watch its work for answers to these questions and note each one, with evidence, under `## Retrospective notes` on the Idea, Tweak or Bug, because you see the whole job and its Main Agents see only their part:

- Where did we introduce a quality issue? How could it have been avoided?
- Where did we spend too much time and not gain value? How could it have been avoided?
- Where did we spend too many tokens and not gain value? How could it have been avoided?

Write your notes only while no Main Agent is writing that ticket, so no update is lost. Before setting the Idea, Tweak or Bug `done`, gather its Main Agents' notes from it, its Docs, Plan and Epics, and their Research tickets, and summarize them with your findings under `## Retrospective`, because whoever maintains SDLC consolidates these into SDLC improvements.

## Flows

Classify each request before intake, because each kind has its own flow: a Bug is behaviour that differs from what the product should do (write-bug); a Tweak is a small user-visible change in one area with no design decision (write-idea); anything else is an Idea (write-idea).

**Idea:** write-idea → write-prd → write-srd → write-plan → configure-worktree → write-epic for each Epic → develop-epic for each Epic → idea-review → the Managing Intelligence's testing, retrospective and acceptance → teardown-worktree → release. Each round of idea-review that has non-trivial findings files them as a Round Feedback Epic, which goes through write-epic and develop-epic before idea-review runs again. A round that finds an unmet PRD requirement no SRD requirement covers sends it back through write-srd and write-plan first.

Epics without a Dependency between them may run at the same time. A second Epic running at once gets its own worktrees, branched from the Idea's and recorded on the Epic. Before its Integration gate, develop-epic merges the Idea's branches into the Epic's and reruns its checks. Then, between the other Run's Tasks, the Managing Intelligence fast-forwards the Idea's branches to it and removes the Epic's worktrees and branches, recording that on the Epic; if they can't fast-forward, develop-epic merges again. Dependent Epics and idea-review wait for that merge.

An Idea has at most one PRD and one SRD, and needs both before planning. An Idea may have several Model Docs, one per modelled SRD part.

Each time the SRD becomes `defined`, the Managing Intelligence has one model-writer Main Agent per Model Doc run its during-build checks, skipping a Model Doc whose results are still current, outside the Plan because the Plan holds only the coding work. A violation is a design fix, not a Bug: the Managing Intelligence sends it through write-srd's revision (see SRD revisions), then write-plan and write-epic. The Idea isn't accepted until every check passes against the current SRD; a result stays current while its SR group and model are unchanged.

**Tweak:** write-idea → the User's one approval (`defined`) → the Managing Intelligence's worktree setup → build-tweak → the Managing Intelligence's retrospective, acceptance against the description (`done`) and merge → release, handling failures and conflicts as for a Bug, through build-tweak. At any step, a design decision or growth past one area makes it an Idea: write-idea refiles it, and the Managing Intelligence sets it `draft`, removes its approval, settles its worktrees and removes its `## Worktrees` record, because the Idea needs the User's own approval before write-prd and must not pass build-tweak's Gate.

**Bug:** write-bug → define-bug → fix-bug → the Managing Intelligence's testing, retrospective, acceptance (`done`) and merge → release. If the fix fails the Managing Intelligence's testing, they note what's still wrong under `## Decisions` on the Bug and run fix-bug again, in the same worktrees. define-bug doesn't run again, because it only weeds out reports that aren't real Bugs.

The Managing Intelligence merges an accepted Bug or Tweak itself, because a few git commands don't need a Main Agent. It waits until no agent works in its worktrees. Each main checkout its `## Worktrees` names must be on its base branch, and each checkout and worktree free of uncommitted changes; if one isn't, it settles that first without losing anyone's work. It checks every repo merges cleanly before landing any, merges them all, then removes the worktrees and branches, so no base branch holds part of the fix. It records what merged and what was removed under `## Worktrees`, because release checks that record. If any repo conflicts, it lands nothing, records the conflict there and sets it `active`, so fix-bug or build-tweak resolves it on its branch.

**Bundles:** the Managing Intelligence may run independent Bugs that fit fix-bug's Small pipeline, or Tweaks, through one Run of their skill, choosing how many by its own judgement, to share one build and review. They share one worktree and branch per repo, named after the Input's first ID and recorded under each ticket's `## Worktrees`, with one commit per ticket per repo, so each can be reverted. Each ticket keeps its own records, findings, retrospective notes and acceptance. A ticket that leaves the bundle (it doesn't fit, becomes an Idea, is invalid or abandoned, or keeps failing) stops the Run; the Managing Intelligence reverts its commits and removes it from every `## Worktrees`, and it continues alone. A re-run takes only failing tickets, and accepted ones are re-tested after any new commit. The bundle merges once all are accepted, because they share a branch; record the merge, removal or conflict on every ticket, setting all `active` on a conflict.

**Research:** research → whoever asked (the Managing Intelligence, or the Main Agent that launched it) accepts the Report.

## Shared rules

### Every Run

- Stop before any change, naming the file, if a file the Run needs is missing, empty or unreadable. That covers the `SKILL.md`, a Protocol File, and a Guidance Document with neither a user copy nor a Default Fallback File. A missing store stops the Run the same way; point to project-setup.
- If your skill's Gate fails, change nothing and say why.
- Gates guard a skill's own steps, not the preparation for them. The Managing Intelligence may have approved work done early or in parallel, such as drafting release notes during the last review, as long as each ticket has one writer and nothing irreversible (merge, push, release, deletion) happens before its Gate. The gated skill then re-checks that work.
- The Managing Intelligence runs no skills itself. It assigns each workflow skill to a Main Agent, which launches the Child Agents its skill names.
- After a compaction, re-read this workflow and the Protocol Files and Guidance Documents you loaded, because summaries can omit their rules.
- Report pass, fail or not applicable for every required check and gate in the `SKILL.md` and its Guidance Documents, and name the Guidance Document copies or Default Fallback Files used.

### Project Folder, paths and worktrees

- **Project Folder:** the nearest folder, from the working directory up, that holds `<Project Folder>/.sdlc/project_settings.md`. If there is none, the Project Folder is the folder the Agent started in, and settings come only from `~/.sdlc/default_project_settings.md`. Project Folders don't nest, so each folder resolves one Project's settings. Projects may share Research through `setting:research_location`.
- **Repos:** the Project's repos are its main checkouts under the Project Folder.
- **Git:** project-setup may clone or create repos but commits nothing. write-idea, write-bug, write-prd, write-srd, req-review, write-plan, write-epic and research work without git. develop-epic, idea-review, fix-bug, build-tweak, configure-worktree, teardown-worktree, release and the Managing Intelligence's Bug, Tweak and Epic git work make repository changes only inside repo checkouts. define-bug reproduces defects in main checkouts without editing repository files.
- **Worktrees:** an Idea, Tweak or Bug gets one worktree in each repo it changes, at `<Project Folder>/.worktrees/<ticket id>/<repo path>`, where `<repo path>` is the repo's path under the Project Folder. Its branch is named after its ID and made from the main checkout's current branch, so its work stays off the base branch until it's accepted. Reuse any it already has. Record each repo's main checkout, worktree path, branch and base branch under `## Worktrees` on the Idea's Plan or the Bug or Tweak, or `none` when the work changes no repo, because later skills find and merge the work from that record and read `none` as nothing to merge. The first repo recorded replaces `none`, so no skill skips its merge. Stop for the Managing Intelligence if a main checkout that needs a new branch has uncommitted changes, because the branch would leave them out, or if something in the way isn't the ticket's.
- **Guidance Documents come from the main checkout,** because worktree guides may still be in development. Load only the guides your skill names. For each, read copies in the main checkout's `.sdlc` (or the current code folder's, outside a repo), then parent `.sdlc` folders and `~/.sdlc`. Combine copies cumulatively; the Managing Intelligence settles conflicts. With no user copy, use `~/.sdlc/<name>-default-fallback.md`.
- **Commits:** commit per repo, naming the ticket. A Task that spans repos gets one commit per repo.
- **Pushing:** push only as the Project's `guide:release-guide.md` allows.

### Settings

Read settings only from `<Project Folder>/.sdlc/project_settings.md`, then `~/.sdlc/default_project_settings.md`. A setting with one value is a `<name>: <value>` line, and a map setting, such as `setting:levels`, is a `## <name>` section with one line per entry; a setting is unset only when neither form appears. The first file naming a setting supplies its whole value, so a Project's setting replaces the default cleanly rather than mixing with it.

`setting:research_location` locates Research tickets, Reports and artifacts through the Ticket System Protocol File, including linked Research. A home default shares Research across Projects and bots because answers may serve more than one Project; a Project setting overrides it. Research always uses the requesting Project's guidance.

`setting:child_watch_command` is optional: it names a host's command that waits on Child Agents, as `protocol:launcher.md ## Knowing when a Child Agent's state changes` describes. When it is unset or empty, that section's fallback applies, so its absence never stops a Run.

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

### Proposals

A proposal is a reporter's or source's suggested fix, implementation or answer, not direction from the User or Managing Intelligence. Keep it off tickets and launches until a worker records its comparison, because an Agent that reads one first anchors on it. write-idea and write-bug file only the reporter's facts, leaving out the proposal, any mention of it and any Source Reference carrying it. Likewise, a skill reading a Source Reference and whoever asks a research question leave out any proposal. Each reports what it left out to the Managing Intelligence, which keeps one file per ticket ID in `<Project Folder>/.proposals/`, read by no skill, and removes the file when the ticket is `done`. At the step their skill names, once their own approach exists, fix-bug, build-tweak and research always ask the Agent that launched them for any proposal; it answers with any it holds or "none". They record where theirs differs and why under `## Progress`, or in the Report for research, and ask the Managing Intelligence before adopting the proposal.

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
- `protocol:ticket.md ## SDLC records in bees`: how to keep the records that have no direct equivalent in the ticket system: updating one body section, Dependencies, Associations, Source References, attached files, Thinking Level tags, marking a Tweak, deleting a ticket and its links, and keeping Research from automatic archival.

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

A Thinking Level picks an Agent, model, any effort or mode and any launch template. The caller resolves it before launch, as `protocol:launcher.md` describes, so every session starts on the intended Agent with the intended settings.

- Read each skill's fixed level from `~/.sdlc/install/templates/thinking-levels.md`, because SDLC owns this mapping across all Projects.
- `setting:levels` maps each level (`low` < `medium` < `high` < `xhigh` < `max`) to an `agent` (`claude-code`, `codex` or `cursor`), a `model` and that Agent's own `effort` for Claude Code and Codex, or optional `mode` for Cursor, plus an optional Launcher `template`. Use the format in `~/.sdlc/install/templates/thinking-levels.md`, so setup and callers read the same mapping.

For `engineer`, `test-writer` and `doc-writer`, the assigned Task's, Bug's or Tweak's `thinking_level:<label>` tag overrides the skill's fixed level, so the Agent, model and any effort or mode follow the work's complexity and risk. A Subtask uses its Task's tag. write-epic and develop-epic set Task tags; define-bug sets Bug tags; write-idea sets Tweak tags.

If a shipped skill's line is missing, stop, name the shipped mapping file and point to reinstalling SDLC with `install.sh`, because Project settings cannot repair it. If a `setting:levels` entry is missing, stop and point to project-setup, because it configures the user's Agents and models. Before `setting:levels` resolves, the Managing Intelligence chooses project-setup's Agent, model and any effort or mode, because no level resolves until setup has run. A missing Task tag returns to its planning skill, because that skill judges the work's complexity. A missing Bug tag goes to the Managing Intelligence to set, because define-bug only runs on `draft` Bugs. A Tweak with no tag uses the skill's fixed level.

### Child Agents

Launch Child Agents on the Agent their Thinking Level resolves to through `protocol:launcher.md`, with the skill, ticket IDs and checkout paths, so each runs on the configured tool. Supply resolved settings and Protocol File locations, including the selected Agent's protocol, so each uses the same Project configuration. It reads work from tickets and reports their IDs and unresolved work to the Main Agent.

Start Child Agents fresh unless the skill retains them, so unrelated work does not fill context. Stop each one, as `protocol:launcher.md ## Stopping a Child Agent` says, once its output is saved and your skill won't resume it, and stop any still open before you report or hand off, because an open session keeps costing money. Each loads its named guides for every assigned repo and may read other repos for context. The Main Agent coordinates their work through files and tickets.

### Context

The Managing Intelligence starts each skill Run in a fresh session. Long sessions cost more, because every turn re-reads the whole context. "Hand off" means a Main Agent records progress on the ticket and stops, and the Managing Intelligence starts a fresh session on the same ticket. Once a Main Agent has run long, it hands off at the next natural break, such as between Tasks or between fix rounds. The Managing Intelligence may also ask it to hand off. A Main Agent that can read its context use also hands off at 75%, because a nearly full context causes mistakes.

Before resuming any reused Child Agent, read its context fraction as `protocol:launcher.md` describes. Resume only below 75%; otherwise, including an unknown reading, replace it with a fresh Child Agent that reads the ticket, because reuse saves work only while enough context remains. Within one fix-bug or build-tweak Run or develop-epic Task, you may resume executors and the only reviewer of build-tweak or fix-bug's small or docs-only pipeline for fix rounds even when no reading exists, because a single Run's or Task's context stays small.

### Checks

develop-epic, fix-bug and build-tweak run Build Commands themselves for the code folders a change touches, skipping only sections marked `none` with a reason, and send each failure to the executor that owns the files. Before each code-review or test-review they run Compile and Lint, and before test-review Unit Tests too, so reviewers see only code that builds and tests that pass. They confirm each repair with the checks it affects, then rerun the full checks once all repairs are in, because a full run per repair costs much and adds little. A commit check may reuse a passing run if no file it covers has changed since.

### Review findings

Skills judge every finding returned by a review skill or product-manager and fix the ones they accept. When you fix a finding, sweep the change for its kind of problem within the files you own, not just the places cited, because each place missed costs another round; report other places to your Main Agent. After a repair round, review again only if it repaired blocker or suggestion findings; decline nits instead of repairing them, because a review round costs more than nits are worth. Record each repaired finding with the places its repair and sweep changed under `## Progress` on the reviewed ticket (PRD, SRD, Model Doc, Plan, Epic, Task, Subtask, Bug or Tweak), and each declined or unaddressed finding with its reason on the ticket it concerns, so later skills see what changed and what remains. A round is later only when the Main Agent's launch says so, after the same reviewer skill reviewed this work in this loop; otherwise review in full. A later round checks only the recorded repairs, from every reviewer, and the docs or code that refer to them, because the first round read the rest. New work or a new Run starts a fresh review loop, except in idea-review, whose later rounds review only the changes since its last finished round. Any review a skill requires to cover the whole work, such as model-writer's pre-gate review, is always full. Product questions go to the Managing Intelligence, who decides the expected behaviour. So does any finding, even a nit, that one of their decisions breaks existing behaviour, a requirement or a Bug's expected behaviour, with its evidence, because the decision may be wrong.

### Tickets carry the information

Main Agents and Child Agents keep decisions, repair instructions, progress and handoffs on the ticket they concern so later work can continue from the record. A launch, continuation or report names those tickets rather than repeating their contents, because copied instructions can drift from the record.

"Your ticket" in a skill is the one its Input names or it files; model-writer's is its Model Doc. Add to `## Retrospective notes` without replacing others' notes, because several agents write there.

### SRD revisions

When write-srd revises an SRD that has a Plan, it sets the Plan `draft` and writes the Plan's `## Paused Epics` as `all`, because changed requirements need replanning. For a revision driven by a during-build check, the Managing Intelligence may instead name only the Epics the fix touches, or `none`, an empty list, for a model error or any model-only change the writer proposed, because those change no SR and needn't stop the build. write-srd also adds each Epic its changed SRs reach once the Managing Intelligence has stopped their Runs, because they would otherwise build on changing requirements. Pausing an Epic also pauses the Epics that depend on it, because they would build on changing code. The first Epic added replaces `none`, so no reader takes the list as empty. If the Plan already has `## Paused Epics`, a revision is still in progress: write-srd adds this revision's changed SRs and previously active Epics to `## SRD changes`, and its paused Epics to the list, rather than replacing them. The Managing Intelligence starts a revision only when no write-plan, write-srd or idea-review Run for the Idea is in progress, so write-srd Runs never overlap; a later revision merges into an unfinished one. It stops paused Epics' write-epic and develop-epic Runs at the next Task boundary, and stops a Model Doc's during-build model-writer Run before write-srd changes that Model Doc, because its result won't be current. The revision lasts while the list exists, and an Epic it doesn't name is **unpaused**: write-epic and develop-epic may work on it with the Plan and SRD `draft`. Before write-plan sets an unpaused Epic `draft`, the Managing Intelligence stops its Runs and write-plan adds it to the list, as it does each Epic it adds, so two writers never share an Epic. write-plan removes the list once the revised Plan's status is set.

### Work outside the ticket

If you find work outside the current Idea, Tweak or Bug, such as a refactor, a new defect or a missing feature, record it on the ticket and suggest it to the Managing Intelligence as a new Idea, Tweak or Bug. Don't take it on, because whether to do it is their call.

### Questions and stops

When you need an answer or can't continue, stop and say why. Never guess past missing or ambiguous information.
