---
name: project-setup
description: "One-time setup of an Apiary Project: its settings, ticket stores and Guidance Documents, from a template or an interview. Re-run it to fix or complete a setup."
---

# project-setup

## Purpose

One-time setup of a Project: its settings, ticket stores and Guidance Documents. It works on an existing repo or a new, empty folder. Re-running it is safe and fixes or completes a setup. Run it before any other Apiary skill.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

The folder to set up as the Project Folder: the nearest folder up from where you started that holds `.apiary/project_settings.md`, else the folder you started in. Optionally, the name of an Apiary template. Without a template, it interviews the Managing Intelligence.

## Reads

- **Settings files:** `<Project Folder>/.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`. Why: to see what is already set (`ticket_system`, `launcher`, `new_idea_intake`, `new_bug_intake`, `levels_claude_code`, `levels_codex`, `thinking_levels`), offer it back, and fill only what's missing.
- **Your Agent's Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` or `agent-codex.md`. Why: how to ask the Managing Intelligence questions and report in this Agent.
- **The Ticket System Protocol File** named by `ticket_system`: `~/.apiary/system/protocols/ticket-<ticket_system>.md`. Why: how to check and create the Ideas, Plans, Bugs and Research stores.
- **The chosen template**, if any: `~/.apiary/system/templates/<template-name>.md`, the name lowercase with hyphens (Public GitHub Project is `public-github-project.md`). Why: it supplies that template's answers, such as how intake works.
- **Apiary's installed files** for your Agent: `~/.claude/` for Claude Code, `~/.agents/` and `~/.codex/` for Codex CLI. Why: to check and report that Apiary is installed.
- **The existing `release-guide.md`** on the Guidance Document walk. Why: you help the Managing Intelligence write it, starting from what exists.
- **Each confirmed repo's manifests and config** under `<Project Folder>/<repo path>/`. Why: to detect its stack and propose its build commands.
- **Existing Guidance Documents** at the paths under Writes, and any repo files the Managing Intelligence points to. Why: to offer them as the starting answer instead of writing from scratch.

## Gate

None: project-setup configures a Project without a ticket state gate. During startup and throughout this Run, its setup exceptions override the rulebook's stops for missing or bad settings, including Thinking Level mappings and lines, and missing stores. Stop and ask the Managing Intelligence for missing or bad settings at their steps below; step 7 creates missing stores.

## Steps

1. Project Folders don't nest. If a folder above or below the one you're setting up already holds `.apiary/project_settings.md`, stop and ask the Managing Intelligence: set up that existing Project instead, or choose another folder? Otherwise read existing settings and mark the Project Folder by creating `<Project Folder>/.apiary/project_settings.md` if absent.

2. Discover main checkouts at any depth under the Project Folder: folders whose `.git` is a directory. Skip `.worktrees`, the inside of each repo found, and any folder holding its own `.apiary/project_settings.md`. Stop and ask the Managing Intelligence: confirm the proposed repos? Scan each confirmed repo for manifests. Then stop and ask the Managing Intelligence: does this Project use other repos? For a repo named outside the Project Folder, stop and ask the Managing Intelligence: move or clone it under the Project Folder. Scan additional confirmed repos for manifests too. With no repo, stop and ask the Managing Intelligence: create the product's repo in a subfolder they name? On yes, create `<Project Folder>/<named subfolder>/`, initialize git and make an empty first commit. On no, carry on without git.

3. Apply the named template, or interview the Managing Intelligence. Templates are plain Markdown instructions: resolve their values before writing settings. Their required sections are Name, New Idea intake and New Bug intake; optional sections supply engineering, test and doc-writing guidance and maintained docs through fixed paths, questions or a skip. Build commands are detected independently of the template.

   Settle `ticket_system` and `launcher`, and, without a template, `new_idea_intake` and `new_bug_intake`. For each, stop and ask the Managing Intelligence: use the default or a Project value? For every value written, offer the value already in the chosen file, or suggest `bees`, `agent-director`, and “interview the Managing Intelligence, no source references” for both intakes. Write a Project value to `<Project Folder>/.apiary/project_settings.md`. To use a default, omit the setting from that file, removing any value there. If the default is missing from `~/.apiary/default_project_settings.md`, first stop and ask the Managing Intelligence: approve adding it there?

4. With a template, resolve its two intake approaches or rules for choosing them and write the resolved `new_idea_intake` and `new_bug_intake` to `<Project Folder>/.apiary/project_settings.md`. The Public GitHub Project template explains that public repos receive feature requests and bug reports through GitHub Issues while private repos do not. For that template, detect whether any Project repo is public: use the `github` resolver for both intakes if one is, otherwise interview the Managing Intelligence. That template asks for Guidance Documents and maintained docs.

5. Stop and ask the Managing Intelligence: which Agents does the Project use, Claude Code, Codex CLI or both? For each used Agent whose mapping (`levels_claude_code` or `levels_codex`) is not already set, stop and ask the Managing Intelligence which model and effort each of `low`, `medium`, `high`, `xhigh` and `max` means, one line per label. Suggest no models. Ask for default versus Project value as in step 3.

6. Ask for `thinking_levels` as in step 3 and write the complete list in the chosen settings file, skills first, then Subagent Roles. Keep existing lines, adding missing lines at their recommended levels; the Managing Intelligence may change any line. The recommended list is:

   ```text
   project-setup: medium
   write-idea: medium
   write-bug: medium
   define-bug: high
   fix-bug: medium
   write-prd: xhigh
   write-srd: max
   req-review: medium
   write-plan: max
   write-epic: xhigh
   develop-epic: medium
   idea-review: high
   research: high
   release: medium
   configure-worktree: medium
   teardown-worktree: medium
   TLA+ Writer: xhigh
   TLA+ Reviewer: xhigh
   Requirements Reviewer: max
   Engineer planner: high
   Test Writer planner: high
   Doc Writer planner: high
   Integration Tester: xhigh
   Code Reviewer: xhigh
   Test Reviewer: xhigh
   Doc Reviewer: high
   Product Manager: xhigh
   ```

7. Through the selected Ticket System Protocol File, create or validate the four stores with the child tiers and status values defined in the rulebook.

8. For each repo, stop and ask the Managing Intelligence: commit its Guidance Documents in `<Project Folder>/<repo path>/.apiary/` (the default), or, for a repo they cannot commit to, keep them in `<Project Folder>/.apiary/`? In the latter location, add the repo's guidance to existing copies, in a section naming the repo when the Project has several. Offer each existing Guidance Document as the answer and change it only as the Managing Intelligence says.

9. For each repo, obtain `engineering-best-practices.md`, `test-guide.md` and `doc-writing-guide.md` from the template or stop and ask the Managing Intelligence for each. For each supplied, write a same-named Guidance Document at the chosen location, containing a relative pointer to the repo file or the supplied rules. Write none for a skipped document. Obtain contributor-doc and customer-doc path lists likewise and write them to `maintained-docs.md` at that location; write none when skipped.

10. Detect each repo's stack and propose its build commands using all applicable cases below. Stop and ask the Managing Intelligence: confirm or override the commands? With no detected stack, ask for every command; with none given, write no `build-commands.md`. Otherwise write its seven slots at the chosen Guidance Document location: Compile / type-check, Format, Lint, Narrow test (takes a path), Full test, Integration test and Model check. A slot may say it has no command.

    | Manifest under `<Project Folder>/<repo path>/` | Stack and detection |
    |---|---|
    | `Cargo.toml` | Rust workspace or single crate. |
    | `package.json` with `tsconfig.json` | Node / TypeScript; identify the test runner from jest or vitest config. |
    | `package.json` without `tsconfig.json` | Node / JavaScript; identify the test runner from jest or vitest config. |
    | `pyproject.toml` or `setup.py` | Python; a poetry lock file means commands run through poetry. |
    | `go.mod` | Go's standard toolchain. |
    | `pom.xml` or `build.gradle` | Java with Maven or Gradle. |

11. Help the Managing Intelligence write `<Project Folder>/.apiary/release-guide.md`: what may be done without a human, including pushing and releasing; what needs a human; and the release process.

12. Check and report whether Apiary is installed for the running Agent. Report what is missing and say "run Apiary's `install.sh`". Check and report the prerequisites named by the Launcher Protocol File in effect.

## Dispatches

None: project-setup does the setup itself.

## Writes

- `<Project Folder>/.apiary/project_settings.md` and, as agreed, `~/.apiary/default_project_settings.md`.
- The Ideas, Plans, Bugs and Research stores through the selected Ticket System Protocol File.
- If accepted, the product's repo at `<Project Folder>/<named subfolder>/`, with an empty first commit.
- Each supplied repo Guidance Document at `<Project Folder>/<repo path>/.apiary/<name>.md` or `<Project Folder>/.apiary/<name>.md`, where `<name>` is `engineering-best-practices`, `test-guide`, `doc-writing-guide`, `maintained-docs` or `build-commands`.
- `<Project Folder>/.apiary/release-guide.md`.

## Done

Report the setup and the installation and Launcher prerequisite checks, naming anything missing and saying "run Apiary's `install.sh`" for missing Apiary files. Tell the Managing Intelligence to commit the Guidance Documents written to repos. Next step: “write-idea or write-bug”.
