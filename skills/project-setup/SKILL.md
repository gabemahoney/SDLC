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
- **Your Agent's Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` or `~/.apiary/system/protocols/agent-codex.md`. Why: how to ask the Managing Intelligence questions and report in this Agent.
- **The Ticket System Protocol File** named by `ticket_system`: `~/.apiary/system/protocols/ticket-<ticket_system>.md`. Why: how to check and create the Ideas, Plans, Bugs and Research stores.
- **The Launcher Protocol File** named by `launcher`: `~/.apiary/system/protocols/launcher-<launcher>.md`. Why: to check the Launcher's prerequisites (e.g. tmux).
- **The chosen template**, if any: `~/.apiary/system/templates/<template-name>.md`, the name lowercase with hyphens (Public GitHub Project is `public-github-project.md`). Why: it supplies that template's answers, such as how intake works.
- **The recommended Thinking Level list:** `~/.apiary/system/templates/thinking-levels.md`. Why: the lines to write into `thinking_levels`.
- **Apiary's installed files** for your Agent: `~/.claude/` for Claude Code, `~/.agents/` and `~/.codex/` for Codex CLI. Why: to check and report that Apiary is installed.
- **The existing `release-guide.md`**, if any, at `<folder on the Guidance Document walk>/.apiary/release-guide.md`, or `~/.apiary/release-guide-default-fallback.md` as the rulebook specifies. Why: you help the Managing Intelligence write it, starting from what exists.
- **Each confirmed code folder** under `<Project Folder>/<code folder path>/`. Why: to work out how it builds and tests, and propose its build commands.
- **Existing Guidance Documents**, if any, at the paths under Writes, and any files the Managing Intelligence points to. Why: to offer them as the starting answer instead of writing from scratch.

## Gate

None: this skill sets up the Project. During startup and throughout this Run, repair missing or bad settings, including Thinking Level mappings and lines, by asking the Managing Intelligence at their steps below. Create missing stores in step 4. These setup rules take precedence over the rulebook's stops for those settings and stores.

## Steps

1. **Choose and mark the Project Folder.** Project Folders don't nest. If a folder above or below the one you're setting up already holds `.apiary/project_settings.md`, stop and ask the Managing Intelligence: set up that existing Project instead, or choose another folder? Otherwise read existing settings and mark the Project Folder by creating `<Project Folder>/.apiary/project_settings.md` if absent.

2. **Settle the Project's code folders.** Ask the Managing Intelligence which folders under the Project Folder hold the Project's code, proposing any git repos you see. A folder outside the Project Folder must be moved or cloned inside it.

3. **Fill in the settings.**

   a. **Choose the setup settings.** Apply the named template, or interview the Managing Intelligence. Follow the template's plain Markdown instructions and resolve its answers before writing settings. Each template has Name, New Idea intake and New Bug intake sections. Optional sections give paths to engineering, test and doc-writing guidance and maintained docs, ask for them, or skip them.

      Set `ticket_system` and `launcher`, and, without a template, `new_idea_intake` and `new_bug_intake`. For each, stop and ask the Managing Intelligence: use the default or a Project value? For every value written, offer the value already in the chosen file, or suggest `bees`, `agent-director`, and “interview the Managing Intelligence” for both intakes. Write a Project value to `<Project Folder>/.apiary/project_settings.md`. To use a default, remove any Project value so the default applies. If the default is missing from `~/.apiary/default_project_settings.md`, first stop and ask the Managing Intelligence: approve adding it there?

   b. **Set intake from the template.** With a template, follow its rules to choose how to collect Ideas and Bugs, then write `new_idea_intake` and `new_bug_intake` to `<Project Folder>/.apiary/project_settings.md`. For Public GitHub Project, explain that public repos receive feature requests and bug reports through GitHub Issues. Check whether any confirmed code folder is a public repo: use the `github` resolver for both intakes if one is, otherwise interview the Managing Intelligence. Ask for Guidance Documents and maintained docs in 5a.

   c. **Set the Agents' model mappings.** Stop and ask the Managing Intelligence: which Agents does the Project use, Claude Code, Codex CLI or both? For each used Agent whose mapping (`levels_claude_code` or `levels_codex`) is not already set, stop and ask the Managing Intelligence which model and effort each of `low`, `medium`, `high`, `xhigh` and `max` means, one line per label. Suggest no models. Ask for default versus Project value as in 3a.

   d. **Complete the Thinking Level list.** Stop and ask the Managing Intelligence for `thinking_levels` as in 3a and write the complete list from `~/.apiary/system/templates/thinking-levels.md` in the chosen settings file, skills first, then Subagent Roles. Keep existing lines, adding missing lines at their recommended levels; the Managing Intelligence may change any line.

4. **Create or check the ticket stores.** Through the selected Ticket System Protocol File, create or check the four stores with the child tiers and status values defined in the rulebook.

5. **Write the Guidance Documents.**

   a. **Set up each code folder's guidance.** The four Guidance Documents here are `engineering-best-practices.md`, `test-guide.md`, `doc-writing-guide.md` and `maintained-docs.md`. For each:
      - If the template gives it, use the template's answer.
      - Else stop and ask the Managing Intelligence: point to your own guide, or use Apiary's default?
      - If the default: write nothing. The Default Fallback File applies.
      - If their own: ask whether all code folders share it or each has its own. Shared goes in `<Project Folder>/.apiary/<name>`; per code folder goes in `<Project Folder>/<code folder path>/.apiary/<name>`. Write the file as a relative pointer to their guide, or its rules.
      - If a copy already exists there, offer it as the answer and change it only as the Managing Intelligence says.

   b. **Set each code folder's build commands.** Look at each confirmed code folder to work out how it builds and tests, and propose its commands. Use these seven slots: Compile / type-check, Format, Lint, Narrow test (takes a path), Full test, Integration test and Model check. Stop and ask the Managing Intelligence: confirm or override the commands? When the code folder's build and test setup is unclear, ask for every command. Write the seven slots to `build-commands.md` at the chosen Guidance Document location when a build or test setup is found or commands are supplied; otherwise continue to 5c. A slot may be marked unused.

   c. **Write or locate the release guide.** Help the Managing Intelligence write `<Project Folder>/.apiary/release-guide.md` or make it point to an existing release guide. It covers what may be done without a human, including pushing and releasing; what needs a human; and the release process.

6. **Check the installation and Launcher prerequisites.** Check and report whether Apiary is installed for the running Agent. Report what is missing and say "run Apiary's `install.sh`". Check and report the prerequisites named by the Launcher Protocol File in effect.

## Dispatches

None: project-setup does the setup itself.

## Writes

- `<Project Folder>/.apiary/project_settings.md` and, as agreed, `~/.apiary/default_project_settings.md`.
- The Ideas, Plans, Bugs and Research stores through the selected Ticket System Protocol File.
- Each supplied Guidance Document at `<Project Folder>/<code folder path>/.apiary/<name>.md` or `<Project Folder>/.apiary/<name>.md`, where `<name>` is `engineering-best-practices`, `test-guide`, `doc-writing-guide`, `maintained-docs` or `build-commands`.
- `<Project Folder>/.apiary/release-guide.md`.

## Done

Report the setup and the installation and Launcher prerequisite checks, naming anything missing and saying "run Apiary's `install.sh`" for missing Apiary files. For Guidance Documents written to git repos, tell the Managing Intelligence to commit them. Next step: “write-idea or write-bug”.
