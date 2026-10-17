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

## Required Reading

- **Settings files:** `<Project Folder>/.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`. Why: to see the existing ticket, Research location, Launcher, template, intake and Thinking Level settings, offer them back, and fill what's missing.
- **Your Agent's Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` or `~/.apiary/system/protocols/agent-codex.md`. Why: to check this Main Agent's context, invoke installed skills, and ask and report through the Agent.
- **The Ticket System Protocol File** named by `ticket_system`: `~/.apiary/system/protocols/ticket-<ticket_system>.md`. Why: how to check and create the Ideas, Plans, Bugs and Research stores.
- **The Launcher Protocol File** named by `launcher`: `~/.apiary/system/protocols/launcher-<launcher>.md`. Why: to check how it launches both Main Agents and Child Agents, keeps their parent relationship, resumes Child Agents, reads their context, watches them and stops them.
- **The chosen template**, if any: `~/.apiary/system/templates/<template-name>.md`, the name lowercase with hyphens. Why: it supplies that template's answers, such as how intake works.
- **The recommended Thinking Level list:** `~/.apiary/system/templates/thinking-levels.md`. Why: the lines to write into `thinking_levels`.
- **Apiary's installed files:** `~/.apiary/system/workflow.md` and the skills in the running Agent's install scope, as its Agent Protocol File describes. Why: to check that the workflow and skills for both Main Agents and Child Agents are present.
- **The existing `release-guide.md` and `research-guide.md`**, found as `workflow.md` describes, when available. Why: to offer existing guidance as the starting point when writing these guides.
- **Each confirmed code folder** under `<Project Folder>/<code folder path>/`. Why: to work out how it builds and tests, and propose its build commands.
- **Existing Guidance Documents:** each Guidance Document on the Guidance Document walk for each confirmed code folder, and any guide the Managing Intelligence supplies. Why: to offer existing guidance as the starting answer, and to find inherited copies before applying the choice in step 5.

## Gate

None: this skill sets up the Project. During startup and throughout this Run, repair missing or bad settings, including Thinking Level mappings and lines, by asking the Managing Intelligence at their steps below. Create missing stores in step 4. These setup rules take precedence over the rulebook's stops for those settings and stores. For the Guidance Documents this skill creates, read existing copies when available and handle missing files in step 5; their absence does not stop setup at startup.

## Steps

1. **Choose and mark the Project Folder.** Project Folders don't nest, so each folder resolves one Project's settings.
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
      - If a template is named, follow its Markdown instructions and resolve its answers before writing settings. Required: Name, New Idea intake, New Bug intake. Optional engineering, test and doc-writing sections give paths, ask, or skip.
      - Otherwise, interview the Managing Intelligence, including both intakes.

      For `ticket_system`, `launcher`, `prd_template` and, when no template is selected, both intakes, show the defaults and first offer “use the default for all”; otherwise ask default or Project value for each.
      - If a value exists in the chosen file, offer it.
      - Otherwise, suggest `bees` for `ticket_system`, `agent-director` for `launcher`, `~/.apiary/system/doc-templates/prd.md` for `prd_template`, and “interview the Managing Intelligence” for both intakes.
      - For `prd_template`, offer the default first, then their own template file; write its path as the setting's value, because the PRD covers the whole Project while Guidance Documents can vary by repo.
      - If Project value, write it to `<Project Folder>/.apiary/project_settings.md`.
      - If using an existing default, remove any Project value.
      - If the chosen default is missing from `~/.apiary/default_project_settings.md`, stop and ask the Managing Intelligence: approve adding it? Add it on approval, then remove any Project value.

   b. **Set intake from the template.**
      - If a template is named, follow its instructions to set the intakes.

   c. **Set the Agents' model mappings.** Stop and ask the Managing Intelligence: Claude Code, Codex CLI or both? For each used Agent's mapping (`levels_claude_code` or `levels_codex`):
      - If already set and valid, keep it.
      - Otherwise, stop and ask the Managing Intelligence for the model and effort for `low`, `medium`, `high`, `xhigh` and `max`, one line per label. Suggest no models, because model names change often and depend on the account. Ask for default versus Project value as in 3a.

   d. **Complete the Thinking Level list.** Stop and ask the Managing Intelligence for `thinking_levels` as in 3a. Complete the list in the selected file, using its existing lines. Write the complete list from `~/.apiary/system/templates/thinking-levels.md`, one line per skill, including every skill Child Agents run:
      - If a valid line exists, keep it.
      - If a line is missing, add its recommended level.
      - If a line is invalid, stop and ask the Managing Intelligence for its corrected Thinking Level.
      The Managing Intelligence may change any line.

   e. **Choose the Research location.** Ask whether Research should be shared across Projects and bots or kept inside this Project, and where it should live. Offer the existing `research_location` if set. Recommend a shared location such as `~/research/tickets`, because research is often useful beyond the Project that requested it; also offer a folder inside the Project.
      - For shared Research, write `research_location` to `~/.apiary/default_project_settings.md` and remove any Project override so this Project uses the shared setting.
      - For Project-local Research, write `research_location` to `<Project Folder>/.apiary/project_settings.md`.
      Record an absolute path for a folder location so it resolves the same way from every working directory. Explain that changing the home default affects every Project and bot using it.

4. **Create or check the ticket stores.** Through the selected Ticket System Protocol File, create or check the four stores with the child tiers and status values defined in the rulebook. Keep every store at the top level, so each store's tickets can be found and listed on their own.
   - Create or check the Research store at `research_location`. Confirm the location exists and the selected ticket system can read and write Research tickets, Reports and artifacts there, so later Runs can use it. Keep automatic archival disabled so accepted research remains available to other Projects.
   - Check that the Ticket System Protocol File says how to record each link type in the rulebook: Dependency, Association and Source Reference, because every later skill relies on them.
   - If it doesn't cover one, agree with the Managing Intelligence how to record it in this ticket system, and write the answer to the `ticket_links` setting in `<Project Folder>/.apiary/project_settings.md`.

5. **Write the Guidance Documents.**

   a. **Set up each code folder's guidance.** The three Guidance Documents here are `engineering-best-practices.md`, `test-guide.md` and `doc-writing-guide.md`. For documents the template leaves to the Managing Intelligence, first offer “use the default for all”; otherwise ask per document. For each:
      - If the template gives it, use the template's answer.
      - Else stop and ask the Managing Intelligence: point to your own guide, or use Apiary's default?
      - If the default and user copies exist on the Guidance Document walk, stop and ask the Managing Intelligence: keep them, or remove them so the default applies? Follow the answer.
      - If the default and no user copies remain, write nothing. The Default Fallback File applies.
      - If their own: ask whether all code folders share it or each has its own. Write a shared copy in `<Project Folder>/.apiary/` and a per-code-folder copy in `<Project Folder>/<code folder path>/.apiary/`, under the Guidance Document's filename. Write the file as a pointer to their guide, relative to the folder holding the pointer file, or as its rules.
      - If a copy already exists there, offer it as the answer and change it only as the Managing Intelligence says.

   b. **Set each code folder's build commands.** Write `build-commands.md` with `## Compile` for compilation or type-checking, `## Lint` for lint and format checks, `## Unit tests` for the full unit suite and `## Integration tests` for integration suites. Apiary names these sets of work as Terms so skills can sequence them: Lint before a commit, Unit Tests at the end of each Task and Integration Tests at the end of each Epic.
      - Propose commands from each code folder's setup and have the Managing Intelligence settle them. Each required section needs a command or `none` with a reason, so setup can check that every code folder's required work is accounted for.
      - Ask whether to add `## Model check`, naming the formal-modelling language and checker command. The checker needs installing on the host so write-srd can check Formal Models.
      - Keep any other `##` sections the Project needs, with instructions for their use.

      Agree where to keep `build-commands.md` with the Managing Intelligence. Use a copy for each code folder or a shared copy found as `workflow.md` describes. In a shared copy, name each code folder's commands within the required sections so skills can find the commands for the folder they affect. Check that all four required sections have a command or `none` with a reason for every confirmed code folder before finishing setup.

   c. **Write or locate the release guide.** Cover permissions without a human (including pushing and releasing), human approvals and the release process in `<Project Folder>/.apiary/release-guide.md`:
      - If a guide exists, use or point to it.
      - Otherwise, write it with the Managing Intelligence.

   d. **Write or locate the research guide.** Offer to use existing `research-guide.md` guidance, write a guide with the Managing Intelligence, point to their own guide, or use Apiary's default. Cover preferred and banned sources, depth, evidence to retain, Report shape, extra outputs after acceptance and when to involve a human. Agree where a user copy belongs on the Guidance Document walk; use `<Project Folder>/.apiary/research-guide.md` for Project-wide rules, including when there are no code folders. If they choose the default, settle any inherited user copies as in step 5a so the Default Fallback File applies. The guide follows the requesting Project even when its Research store is shared.

6. **Check the installation and Launcher.** Check the workflow and every skill in the running Agent's install scope, as its Agent Protocol File describes. Report missing installed files and say to run Apiary's `install.sh`, so an incomplete installation is visible before work starts. Check the prerequisites in the selected `launcher.md` and require each named section below, with usable instructions, because later skills rely on every operation:
   - `## Launch a Main Agent`: start the assigned skill.
   - `## Launch a Child Agent`: start its skill and keep it a child of its Main Agent.
   - `## Resume a Child Agent`: continue its recorded session.
   - `## Know when a Child Agent's state changes`: how the Main Agent learns a Child Agent has finished, asked a question or stopped. Some Launchers report this automatically, as Claude Code and Codex Subagents do.
   - `## Stop a Child Agent`: stop it and verify exit.
   - `## Read a Child Agent's context`: read or estimate its context fraction.

   If any section is absent, empty or does not describe its operation, stop and name the Launcher Protocol File and every missing section or instruction. Also check that the file describes watching both classes and stopping a Main Agent, and that each used Agent Protocol File describes reading that Agent's own context. Stop and name any missing instructions, because the shared Context rules and worktree cleanup depend on them.

## Child Agents

None: project-setup does the setup itself.

## Writes

- `<Project Folder>/.apiary/project_settings.md` and, as agreed, `~/.apiary/default_project_settings.md`, including `ticket_links` when step 4 needed it.
- The Ideas, Plans and Bugs stores, and the Research store at `research_location`, through the selected Ticket System Protocol File.
- Each supplied Guidance Document at `<Project Folder>/<code folder path>/.apiary/<name>.md` or `<Project Folder>/.apiary/<name>.md`, where `<name>` is `engineering-best-practices`, `test-guide`, `doc-writing-guide` or `build-commands`.
- `<Project Folder>/.apiary/release-guide.md`.
- `research-guide.md` at the agreed place on the Guidance Document walk, when the Managing Intelligence chooses a user copy.

## Done

Report the setup and the installation and Launcher prerequisite checks, naming anything missing and saying "run Apiary's `install.sh`" for missing Apiary files. For Guidance Documents written to git repos, tell the Managing Intelligence to commit them, because project-setup works without git. Next step: “write-idea or write-bug”.
