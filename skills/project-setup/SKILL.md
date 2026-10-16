---
name: project-setup
description: "One-time setup of an Apiary Project: its settings, ticket stores and Guidance Documents, from a template or an interview. Re-run it to fix or complete a setup."
---

# project-setup

## Purpose

One-time setup of a Project: its settings, ticket stores and Guidance Documents. It works on an existing code folder or a new, empty folder. Re-running it is safe and fixes or completes a setup. Run it before any other Apiary skill.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

The folder to set up as the Project Folder: the nearest folder up from where you started that holds `.apiary/project_settings.md`, else the folder you started in. Optionally, the name of an Apiary template. Without a template, it interviews the Managing Intelligence.

## Reads

- **Settings files:** `<Project Folder>/.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`. Why: to see what is already set (`ticket_system`, `launcher`, `new_idea_intake`, `new_bug_intake`, `levels_claude_code`, `levels_codex`, `thinking_levels`), offer it back, and fill only what's missing.
- **Your Agent's Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` or `~/.apiary/system/protocols/agent-codex.md`. Why: how to ask the Managing Intelligence questions, report in this Agent and identify its expected installed skills and Subagent definitions.
- **The Ticket System Protocol File** named by `ticket_system`: `~/.apiary/system/protocols/ticket-<ticket_system>.md`. Why: how to check and create the Ideas, Plans, Bugs and Research stores.
- **The Launcher Protocol File** named by `launcher`: `~/.apiary/system/protocols/launcher-<launcher>.md`. Why: to check the Launcher's prerequisites.
- **The chosen template**, if any: `~/.apiary/system/templates/<template-name>.md`, the name lowercase with hyphens. Why: it supplies that template's answers, such as how intake works.
- **The recommended Thinking Level list:** `~/.apiary/system/templates/thinking-levels.md`. Why: the lines to write into `thinking_levels`.
- **Apiary's installed files:** `~/.apiary/system/workflow.md`, and for your Agent its skills and Subagent definitions: `~/.claude/skills/<skill>/SKILL.md` and `~/.claude/agents/apiary-<role>.md` in Claude Code, `~/.agents/skills/<skill>/SKILL.md` and `~/.codex/agents/apiary-<role>.toml` in Codex CLI. Why: to check and report that Apiary is installed: workflow.md and every Apiary skill and Subagent definition is present.
- **The existing `release-guide.md`**, if any, at `<folder on the Guidance Document walk>/.apiary/release-guide.md`, or `~/.apiary/release-guide-default-fallback.md` as the rulebook specifies. Why: you help the Managing Intelligence write it, starting from what exists.
- **Each confirmed code folder** under `<Project Folder>/<code folder path>/`. Why: to work out how it builds and tests, and propose its build commands.
- **Existing Guidance Documents:** each Guidance Document on the Guidance Document walk for each confirmed code folder, and any guide the Managing Intelligence supplies. Why: to offer existing guidance as the starting answer, and to find inherited copies before applying the choice in step 5.

## Gate

None: this skill sets up the Project. During startup and throughout this Run, repair missing or bad settings, including Thinking Level mappings and lines, by asking the Managing Intelligence at their steps below. Create missing stores in step 4. These setup rules take precedence over the rulebook's stops for those settings and stores. For the Guidance Documents this skill creates, read existing copies when available and handle missing files in step 5; their absence does not stop setup at startup.

## Steps

1. **Choose and mark the Project Folder.** Project Folders don't nest.
   - If another Project exists above or below, stop and ask the Managing Intelligence: use it or choose another folder?
   - Otherwise, read existing settings.
   - If `<Project Folder>/.apiary/project_settings.md` is absent, create it.

2. **Settle the Project's code folders.** Ask the Managing Intelligence for code folders under the Project Folder, including itself, proposing git repos you see.
   - If a folder is outside, move or clone it inside.
   - If there are no code folders, offer to create a git repo in a subfolder the Managing Intelligence names.
   - If they accept, create it there.
   - If they decline, continue without a code folder.

3. **Fill in the settings.**

   a. **Choose the setup settings.**
      - If a template is named, follow its Markdown instructions and resolve its answers before writing settings. Required: Name, New Idea intake, New Bug intake. Optional engineering, test, doc-writing and maintained-doc sections give paths, ask, or skip.
      - Otherwise, interview the Managing Intelligence, including both intakes.

      For `ticket_system`, `launcher` and, when no template is selected, both intakes, show the defaults and first offer “use the default for all”; otherwise ask default or Project value for each.
      - If a value exists in the chosen file, offer it.
      - Otherwise, suggest `bees` for `ticket_system`, `agent-director` for `launcher`, and “interview the Managing Intelligence” for both intakes.
      - If Project value, write it to `<Project Folder>/.apiary/project_settings.md`.
      - If using an existing default, remove any Project value.
      - If the chosen default is missing from `~/.apiary/default_project_settings.md`, stop and ask the Managing Intelligence: approve adding it? Add it on approval, then remove any Project value.

   b. **Set intake from the template.**
      - If a template is named, follow its instructions to set the intakes.

   c. **Set the Agents' model mappings.** Stop and ask the Managing Intelligence: Claude Code, Codex CLI or both? For each used Agent's mapping (`levels_claude_code` or `levels_codex`):
      - If already set and valid, keep it.
      - Otherwise, stop and ask the Managing Intelligence for the model and effort for `low`, `medium`, `high`, `xhigh` and `max`, one line per label. Suggest no models. Ask for default versus Project value as in 3a.

   d. **Complete the Thinking Level list.** Stop and ask the Managing Intelligence for `thinking_levels` as in 3a. Complete the list in the selected file, using its existing lines. Write the complete list from `~/.apiary/system/templates/thinking-levels.md`, skills first, then Subagent Roles:
      - If a valid line exists, keep it.
      - If a line is missing, add its recommended level.
      - If a line is invalid, stop and ask the Managing Intelligence for its corrected Thinking Level.
      The Managing Intelligence may change any line.

4. **Create or check the ticket stores.** Through the selected Ticket System Protocol File, create or check the four stores with the child tiers and status values defined in the rulebook. Keep every store at the top level, never nested in another.

5. **Write the Guidance Documents.**

   a. **Set up each code folder's guidance.** The four Guidance Documents here are `engineering-best-practices.md`, `test-guide.md`, `doc-writing-guide.md` and `maintained-docs.md`. For documents the template leaves to the Managing Intelligence, first offer “use the default for all”; otherwise ask per document. For each:
      - If the template gives it, use the template's answer.
      - Else stop and ask the Managing Intelligence: point to your own guide, or use Apiary's default?
      - If the default and user copies exist on the Guidance Document walk, stop and ask the Managing Intelligence: keep them, or remove them so the default applies? Follow the answer.
      - If the default and no user copies remain, write nothing. The Default Fallback File applies.
      - If their own: ask whether all code folders share it or each has its own. Shared goes in `<Project Folder>/.apiary/<name>`; per code folder goes in `<Project Folder>/<code folder path>/.apiary/<name>`. Write the file as a pointer to their guide, relative to the folder holding the pointer file, or as its rules.
      - If a copy already exists there, offer it as the answer and change it only as the Managing Intelligence says.

   b. **Set each code folder's build commands.** For each confirmed code folder, use seven slots: Compile / type-check, Format, Lint, Narrow test (takes a path), Full test, Integration test and Model check. A slot may be marked unused.
      - If its build and test setup is clear, propose commands; stop and ask the Managing Intelligence: confirm or override?
      - Otherwise, ask for every command.

      Ask where to keep `build-commands.md`: `<Project Folder>/.apiary/` or `<Project Folder>/<code folder path>/.apiary/`. Write the slots there; in the shared `<Project Folder>/.apiary/` copy, put each code folder's slots in a section naming it.

   c. **Write or locate the release guide.** Cover permissions without a human (including pushing and releasing), human approvals and the release process in `<Project Folder>/.apiary/release-guide.md`:
      - If a guide exists, use or point to it.
      - Otherwise, write it with the Managing Intelligence.

6. **Check the installation and Launcher prerequisites.** Follow your Agent's Protocol File for the expected installed skills, Subagent definitions and their filenames. Check and report whether Apiary is installed for the running Agent. Report missing files inspected only for installation completeness here. Report what is missing and say "run Apiary's `install.sh`". Check and report the prerequisites named by the Launcher Protocol File in effect.

## Dispatches

None: project-setup does the setup itself.

## Writes

- `<Project Folder>/.apiary/project_settings.md` and, as agreed, `~/.apiary/default_project_settings.md`.
- The Ideas, Plans, Bugs and Research stores through the selected Ticket System Protocol File.
- Each supplied Guidance Document at `<Project Folder>/<code folder path>/.apiary/<name>.md` or `<Project Folder>/.apiary/<name>.md`, where `<name>` is `engineering-best-practices`, `test-guide`, `doc-writing-guide`, `maintained-docs` or `build-commands`.
- `<Project Folder>/.apiary/release-guide.md`.

## Done

Report the setup and the installation and Launcher prerequisite checks, naming anything missing and saying "run Apiary's `install.sh`" for missing Apiary files. For Guidance Documents written to git repos, tell the Managing Intelligence to commit them. Next step: “write-idea or write-bug”.
