---
name: project-setup
description: "Set up or repair a Project's settings, ticket stores and Guidance Documents, from a Project Template or an interview, or save a Project as a Project Template."
---

# project-setup

## Purpose

Set up an existing or empty Project Folder before other SDLC skills run. Re-running repairs or completes the setup. You also save a Project's setup as a Project Template, so other Projects can reuse it.

A **Project Template** is a named bundle of setting values and Template Guides in its own folder, `~/.sdlc/templates/<name>/`. A **Template Guide** names a Guidance Document, the file that supplies it, and whether it is linked or copied. `install.sh` never writes there, so templates survive SDLC upgrades. Project Templates below describes the format.

## Loading SDLC

Read `~/.sdlc/system/workflow.md` first for shared rules, settings and file locations.

## Input

The Project Folder resolved by `~/.sdlc/system/workflow.md`, and the Managing Intelligence's request. The request may name a Project Template in plain words, such as "set up ~/projects/foo using the github-intake template"; treat that name as the template's, never the Project's. It may instead ask you to save the Project as a named template; then follow Saving a Project Template instead of the Steps. Interview the Managing Intelligence for everything a template leaves out.

## Required Reading

- **Settings:** Project and defaults, when present, for existing choices.
- **Protocols:** the Agent Protocol Files for each selected Agent (`protocol:agent-claude-code.md`, `protocol:agent-codex.md` or `protocol:agent-cursor.md`) and the Ticket System Protocol File selected by `setting:ticket_system`, for installation and ticket operations.
- **Thinking Levels:** `~/.sdlc/system/templates/thinking-levels.md`, for recommended skill levels and the `setting:levels` format.
- **Project Template:** `~/.sdlc/templates/<name>/template.md`, when the request names one, for its settings and Template Guides.
- **Code folders and Guidance:** confirmed folders and their inherited Guidance Documents, for commands and existing guidance.

## Gate

When the request names a Project Template, run only if `~/.sdlc/templates/<name>/template.md` exists and is readable, because a silent fallback to a full interview would set the Project up by hand without the Managing Intelligence knowing. Otherwise, stop and name the template you couldn't find.

Missing settings, stores and Guidance Documents are repaired here rather than triggering the shared missing-file stop. Ask the Managing Intelligence to settle missing or invalid settings.

## Steps

1. **Settle the Project Folder and code folders.** If another Project exists above or below, the Managing Intelligence chooses that Project or another folder, because Project Folders cannot nest. Create `<Project Folder>/.sdlc/project_settings.md` if absent. Propose existing repos as code folders; move or clone any selected outside folder into the Project. If none exist, offer a new repo in a subfolder they name, or continue without code.

2. **Set the configuration.** Apply the named template's settings as Project Templates below describes. Follow the Settings guidance below for every setting it leaves out, interviewing the Managing Intelligence, including both intakes.

3. **Create or check stores.** Follow the Ticket System Protocol File for the four stores, child tiers and statuses in `~/.sdlc/system/workflow.md`. Keep stores at the top level so each can be listed independently. Check Research tickets, Reports and artifacts can be read and written at `setting:research_location`. Disable automatic Research archival so accepted evidence remains available. If the protocol lacks a link type, agree its representation with the Managing Intelligence and record it in the Project's `setting:ticket_links`.

4. **Set up guidance.** Apply the named template's Template Guides as Project Templates below describes. Follow Guidance below for every confirmed code folder and every guide the template leaves out. Project-wide release and research guidance also applies when there is no code folder.

5. **Check the installation.** Check `~/.sdlc/system/workflow.md` and every Main Agent and Child Agent skill for each selected Agent in your install scope, so each tool can run the workflow. Report missing files and direct the Managing Intelligence to `install.sh`. Check the selected Ticket System Protocol File's prerequisites and every named section in `~/.sdlc/system/workflow.md`'s Ticket system operations for usable instructions. Check the selected Launcher's prerequisites and every named section in `~/.sdlc/system/workflow.md`'s Launcher operations, including usable instructions for how a Main Agent and its Child Agents communicate (sending work and follow-ups, reporting results, asking questions), reading Child Agent context, watching both classes and stopping Main Agents. Naming the sections isn't enough; each must say how. Check each used Agent Protocol File explains the Main Agent's own context reading or why it skips that check, and says under `## Blocking waits` how it runs a wait, because the Launcher's waits rely on it. Follow each one's installation prerequisites, so setup accounts for the Agent's capabilities. Stop and name missing files, sections or instructions, because later skills rely on them.

## Child Agents

None.

## Writes

- Project settings and agreed default settings, including `setting:ticket_links` when needed.
- Ideas, Plans and Bugs stores, and Research at `setting:research_location`.
- User Guidance Documents at the agreed locations, including Template Guides in the Project Folder's `.sdlc`.
- A Project Template in `~/.sdlc/templates/<name>/`, only when the request asks you to save one.

## Done

Report the Project Folder, the Project Template applied or saved, and any incomplete setup or failed installation checks. Guidance written in repos needs a commit by the Managing Intelligence, because you make no commits. Next: write-idea or write-bug, or project-setup with the saved template for another Project.

## Settings guidance

A Project Template's value answers that setting's question, so don't ask it. Check the value as you would the Managing Intelligence's answer and report a failing one the same way, so a template can't bypass setup's checks. Write template values to Project settings only, because home defaults affect other Projects.

For each setting, the Managing Intelligence chooses a default or Project value. Preserve an existing chosen value. When a template value differs from the Project's existing value, show both and have the Managing Intelligence choose, so a template never silently overwrites an earlier choice. Using a default removes the Project override. Adding or changing a home default needs their approval because it affects other Projects using it.

- **`setting:ticket_system`, `setting:launcher` and `setting:prd_template`:** offer existing defaults together, then individual choices. When missing, suggest `bees`, `agent-director` and `~/.sdlc/system/doc-templates/prd.md`. A custom `setting:prd_template` is a file path because the PRD covers the whole Project.
- **Intakes:** settle `setting:new_idea_intake` and `setting:new_bug_intake` with the Managing Intelligence. Suggest the interview intake when unset.
- **Agent mappings:** offer `setting:levels` in the format in `~/.sdlc/system/templates/thinking-levels.md`, so the Managing Intelligence can choose an Agent, model and its own effort for each of `low`, `medium`, `high`, `xhigh` and `max`. Have them supply missing or corrected entries, checking Cursor models as `protocol:agent-cursor.md ## Models` says, so each Cursor level names a usable model. Check every named Agent is installed with its skills and the launch template its Agent Protocol File names, so each configured level can launch.
- **`setting:thinking_levels`:** write a complete `setting:thinking_levels` value using the recommended list. Keep valid existing lines, add missing recommendations and have the Managing Intelligence correct invalid lines or change any recommendation. Include every Child Agent skill so launches can resolve their settings.
- **`setting:research_location`:** offer the existing `setting:research_location`; otherwise recommend a shared location such as `~/research/tickets`, because answers can serve other Projects. A shared choice goes in default settings with the Project override removed; a Project-local choice goes in Project settings. Store folder locations as absolute paths so all working directories resolve them alike.
- **`setting:child_watch_command`:** offer it when the host ships a command that waits on Child Agents, as a home default in `~/.sdlc/default_project_settings.md`, because it belongs to the host rather than the Project. Check it meets `protocol:launcher.md ## Knowing when a Child Agent's state changes`: it takes Child Agent ids, returns when any leaves `pending` or `working`, and prints `<id> <state>`. Otherwise leave it unset, so the Launcher Protocol File's fallback applies.

## Guidance

Use existing copies as the starting point. Locate each guide as `~/.sdlc/system/workflow.md` describes. When a guide points to another file, resolve its path relative to the pointer file's folder.

For `guide:engineering-best-practices.md`, `guide:test-guide.md` and `guide:doc-writing-guide.md`, use the template's Template Guide or have the Managing Intelligence choose their own guide or the default. Offer defaults together before individual choices. If inherited user copies prevent a chosen default from applying, they decide whether to keep or remove them. With no user copies, check that the Default Fallback File exists and is readable; use it without writing a user copy. If unavailable, the Managing Intelligence supplies a guide so setup leaves usable guidance. Store a shared user guide in the Project's `.sdlc/`, or a code-folder-specific guide in that folder's `.sdlc/`, as rules or a pointer. Change existing guides only as agreed.

For `guide:build-commands.md`, propose commands from each code folder and have the Managing Intelligence settle them. Use the four required sections in `~/.sdlc/system/workflow.md`'s Build Commands, each with a command or `none` and a reason for every code folder, so every required check is accounted for. Agree a shared or per-folder copy; shared sections identify each folder's commands. Offer optional `guide:build-commands.md ## Model check` with the modelling language and checker command, and arrange installation of its checker on the host. Preserve other Project sections with instructions for their use.

For `guide:bug-writing-guide.md`, agree the report format with the Managing Intelligence, using an existing guide, a user copy or an available Default Fallback File so write-bug and define-bug have their required guidance.

For `guide:release-guide.md`, write or point to the guide in the Project's `.sdlc/`. Agree permissions without a human (including pushing and releasing), human approvals and the release process.

For `guide:research-guide.md`, offer existing guidance, a guide written with the Managing Intelligence, a pointer to their guide or the default. Cover sources, depth, evidence, Report shape, work required after acceptance and human involvement. Agree its location; Project-wide guidance belongs in the Project's `.sdlc/`. Settle inherited copies as for other defaults. Research uses the requesting Project's guidance even when its store is shared.

## Project Templates

A template's manifest, `~/.sdlc/templates/<name>/template.md`, writes settings in the `<setting>: <value>` lines and `## <setting>` blocks of `<Project Folder>/.sdlc/project_settings.md`, so you can copy each value into the Project's settings as written. Its `## guides` section lists Template Guides, one `<guide file>: link <path>` or `<guide file>: copy <path>` line each. A relative path is relative to the template folder, so a template can carry its own guide files. A template holds as much or as little as its author wants, and you settle everything it leaves out as you would without one. Leave `setting:child_watch_command` and `guide:build-commands.md` out of templates, both when applying and when saving, because the first belongs to the host and the second's commands are per code folder.

Apply each Template Guide in the Project Folder's `.sdlc`, because a template can't know a Project's code folders:

- **Linked Guide (`link`):** write a pointer guide that names the source's absolute path, so the Guidance Document walk reads the shared file and its later edits reach every Project that links it.
- **Copied Guide (`copy`):** copy the source into the Project once, so the Project owns its copy and the two change independently.

When the Project already has that guide, show both and have the Managing Intelligence choose, as for settings. If a Template Guide's source can't be read, name it, write neither a pointer nor a copy, and settle that guide as without a template, so the Project isn't left with a broken guide.

## Saving a Project Template

1. **Collect the setup.** Read the settings in `<Project Folder>/.sdlc/project_settings.md` and the Guidance Documents in `<Project Folder>/.sdlc/`, because those are the Project's own choices and inherited defaults keep applying through `~/.sdlc`.
2. **Choose link or copy.** The Managing Intelligence chooses for each guide. A Linked Guide names the absolute path of the file to share. A Copied Guide is copied into the template folder and named by its relative path, so the template keeps working after the Project changes.
3. **Show, then write.** Show the Managing Intelligence the manifest and the files you'll copy, then write `~/.sdlc/templates/<name>/`. Replace an existing template of that name only with their OK, because other Projects may use it.
