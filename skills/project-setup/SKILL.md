---
name: project-setup
description: "Set up or repair a Project's settings, ticket stores and Guidance Documents, from a template or an interview."
---

# project-setup

## Purpose

Set up an existing or empty Project Folder before other Apiary skills run. Re-running repairs or completes the setup.

## Loading Apiary

Read `~/.apiary/system/workflow.md` first for shared rules, settings and file locations.

## Input

The Project Folder resolved by `~/.apiary/system/workflow.md`, and optionally an Apiary template name. Without a template, interview the Managing Intelligence.

## Required Reading

- **Settings:** Project and defaults, when present, for existing choices.
- **Protocols:** `protocol:agent-claude-code.md` or `protocol:agent-codex.md` and the Ticket System Protocol File selected by `setting:ticket_system`, for installation and ticket operations.
- **Templates:** `thinking-levels.md` and any selected Apiary template, for recommended skill levels and setup choices.
- **Code folders and Guidance:** confirmed folders and their inherited Guidance Documents, for commands and existing guidance.

## Gate

None. Missing settings, stores and Guidance Documents are repaired here rather than triggering the shared missing-file stop. Ask the Managing Intelligence to settle missing or invalid settings.

## Steps

1. **Settle the Project Folder and code folders.** If another Project exists above or below, the Managing Intelligence chooses that Project or another folder, because Project Folders cannot nest. Create `<Project Folder>/.apiary/project_settings.md` if absent. Propose existing repos as code folders; move or clone any selected outside folder into the Project. If none exist, offer a new repo in a subfolder they name, or continue without code.

2. **Set the configuration.** Follow the Settings guidance below. Use a named template's answers; otherwise interview the Managing Intelligence, including both intakes.

3. **Create or check stores.** Follow the Ticket System Protocol File for the four stores, child tiers and statuses in `~/.apiary/system/workflow.md`. Keep stores at the top level so each can be listed independently. Check Research tickets, Reports and artifacts can be read and written at `setting:research_location`. Disable automatic Research archival so accepted evidence remains available. If the protocol lacks a link type, agree its representation with the Managing Intelligence and record it in the Project's `setting:ticket_links`.

4. **Set up guidance.** Follow Guidance below for every confirmed code folder. Project-wide release and research guidance also applies when there is no code folder.

5. **Check the installation.** Check the workflow and every Main Agent and Child Agent skill in your install scope. Report missing files and direct the Managing Intelligence to `install.sh`. Check the selected Ticket System Protocol File's prerequisites and every named section in `~/.apiary/system/workflow.md`'s Ticket system operations for usable instructions. Check the selected Launcher's prerequisites and every named section in `~/.apiary/system/workflow.md`'s Launcher operations, including usable instructions for how a Main Agent and its Child Agents communicate (sending work and follow-ups, reporting results, asking questions), reading Child Agent context, watching both classes and stopping Main Agents. Naming the sections isn't enough; each must say how. Check each used Agent Protocol File explains the Main Agent's own context reading. Stop and name missing files, sections or instructions, because later skills rely on them.

## Child Agents

None.

## Writes

- Project settings and agreed default settings, including `setting:ticket_links` when needed.
- Ideas, Plans and Bugs stores, and Research at `setting:research_location`.
- User Guidance Documents at the agreed locations.

## Done

Report the Project Folder and any incomplete setup or failed installation checks. Guidance written in repos needs a commit by the Managing Intelligence, because you work without git. Next: write-idea or write-bug.

## Settings guidance

A template supplies Name, New Idea intake and New Bug intake. Its optional engineering, test and documentation sections may supply guide paths, request an interview or leave defaults in place.

For each setting, the Managing Intelligence chooses a default or Project value. Preserve an existing chosen value. Using a default removes the Project override. Adding or changing a home default needs their approval because it affects other Projects using it.

- **`setting:ticket_system`, `setting:launcher` and `setting:prd_template`:** offer existing defaults together, then individual choices. When missing, suggest `bees`, `agent-director` and `~/.apiary/system/doc-templates/prd.md`. A custom `setting:prd_template` is a file path because the PRD covers the whole Project.
- **Intakes:** use the template's instructions, or settle `setting:new_idea_intake` and `setting:new_bug_intake` with the Managing Intelligence. Suggest the interview intake when unset.
- **Agent mappings:** the Managing Intelligence chooses Claude Code, Codex CLI or both. Keep valid `setting:levels_claude_code` and `setting:levels_codex` mappings. They supply missing or corrected model and effort values for `low`, `medium`, `high`, `xhigh` and `max`, because available models depend on the account and change over time.
- **`setting:thinking_levels`:** write a complete `setting:thinking_levels` value using the recommended list. Keep valid existing lines, add missing recommendations and have the Managing Intelligence correct invalid lines or change any recommendation. Include every Child Agent skill so launches can resolve their settings.
- **`setting:research_location`:** offer the existing `setting:research_location`; otherwise recommend a shared location such as `~/research/tickets`, because answers can serve other Projects. A shared choice goes in default settings with the Project override removed; a Project-local choice goes in Project settings. Store folder locations as absolute paths so all working directories resolve them alike.

## Guidance

Use existing copies as the starting point. Locate each guide as `~/.apiary/system/workflow.md` describes. When a guide points to another file, resolve its path relative to the pointer file's folder.

For `guide:engineering-best-practices.md`, `guide:test-guide.md` and `guide:doc-writing-guide.md`, use the template's answer or have the Managing Intelligence choose their own guide or the default. Offer defaults together before individual choices. If inherited user copies prevent a chosen default from applying, they decide whether to keep or remove them. With no user copies, check that the Default Fallback File exists and is readable; use it without writing a user copy. If unavailable, the Managing Intelligence supplies a guide so setup leaves usable guidance. Store a shared user guide in the Project's `.apiary/`, or a code-folder-specific guide in that folder's `.apiary/`, as rules or a pointer. Change existing guides only as agreed.

For `guide:build-commands.md`, propose commands from each code folder and have the Managing Intelligence settle them. Use the four required sections in `~/.apiary/system/workflow.md`'s Build Commands, each with a command or `none` and a reason for every code folder, so every required check is accounted for. Agree a shared or per-folder copy; shared sections identify each folder's commands. Offer optional `guide:build-commands.md ## Model check` with the modelling language and checker command, and arrange installation of its checker on the host. Preserve other Project sections with instructions for their use.

For `guide:bug-writing-guide.md`, agree the report format with the Managing Intelligence, using an existing guide, a user copy or an available Default Fallback File so write-bug and define-bug have their required guidance.

For `guide:release-guide.md`, write or point to the guide in the Project's `.apiary/`. Agree permissions without a human (including pushing and releasing), human approvals and the release process.

For `guide:research-guide.md`, offer existing guidance, a guide written with the Managing Intelligence, a pointer to their guide or the default. Cover sources, depth, evidence, Report shape, extra outputs after acceptance and human involvement. Agree its location; Project-wide guidance belongs in the Project's `.apiary/`. Settle inherited copies as for other defaults. Research uses the requesting Project's guidance even when its store is shared.
