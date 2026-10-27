# Project Templates

A Project Template is a named bundle of settings and guides that project-setup applies to a Project in one step. Use one to set up several Projects the same way, for example with GitHub intake, without answering the same questions again.

Your templates live in `~/.apiary/templates/`. Installing or upgrading Apiary never writes there, so your templates stay as you left them. Apiary ships no templates of its own.

## Use a template

Name the template anywhere in your request to project-setup:

```bash
cd ~/projects/my-project
claude "/project-setup using the github-intake template"
```

project-setup finds `~/.apiary/templates/github-intake/`, applies what it holds, and asks its usual questions for everything the template leaves out.

- **Unknown name:** if there's no template by that name, project-setup stops and says so, rather than quietly interviewing you instead.
- **Checks:** project-setup checks template values the same way it checks your answers, for example that every Agent in `levels` is installed. A value that fails is reported for you to fix.
- **Existing values:** if the Project already has a different value or guide, project-setup shows both and you choose.
- **Project settings only:** template values go in the Project's `.apiary/project_settings.md`. Your home defaults in `~/.apiary/default_project_settings.md` change only if you approve.
- **Missing guide file:** if a guide's file can't be read, project-setup names it, writes nothing for that guide, and asks you about it as usual.

## Save a Project as a template

Ask project-setup to save a Project you've already set up:

```bash
cd ~/projects/my-project
claude "/project-setup save this Project as the github-intake template"
```

It collects the settings in the Project's `.apiary/project_settings.md` and the guides in its `.apiary/` folder, asks you whether to link or copy each guide, and shows you the template before writing it. It replaces an existing template of the same name only if you say so. Settings and guides the Project inherits from `~/.apiary/` stay out of the template, because they already apply everywhere.

## Layout

Each template is a folder holding one manifest, `template.md`, and any guide files it carries:

```text
~/.apiary/templates/
  github-intake/
    template.md
    test-guide.md
```

The folder's name is the template's name.

## The manifest

`template.md` uses the same forms as `.apiary/project_settings.md`, plus a `guides` section:

- `<setting>: <value>` for a one-line setting.
- `## <setting>` followed by its lines, for a multi-line setting such as `levels` or `thinking_levels`.
- `## guides` followed by one line per guide.

Headings with `#` and plain sentences are notes for people; project-setup ignores them. Anything the manifest leaves out, project-setup asks about as usual.

### Settings

A template can hold any of these. Each takes the same value it would in `project_settings.md`.

| Setting | Value |
| --- | --- |
| `ticket_system` | The ticket system, such as `bees`. |
| `launcher` | The Launcher, such as `agent-director`. |
| `prd_template` | Absolute path to the PRD layout, such as `/home/you/.apiary/system/doc-templates/prd.md`. |
| `new_idea_intake` | Absolute path to the intake for new Ideas. |
| `new_bug_intake` | Absolute path to the intake for new Bugs. |
| `research_location` | Absolute path to the folder for Research tickets and Reports. |
| `levels` | A `## levels` block: the Agent, model and effort or mode for each Thinking Level. |
| `levels_claude_code`, `levels_codex`, `levels_cursor` | Per-Agent level blocks, used when no `levels` applies. |
| `thinking_levels` | A `## thinking_levels` block: one `<skill>: <level>` line per skill. |
| `ticket_links` | How links are recorded where the ticket system lacks a link type. |

The `levels` and `thinking_levels` formats are in `~/.apiary/system/templates/thinking-levels.md`. A template can't hold `child_watch_command`, because it belongs to the host and lives in your home defaults.

### Guides

Each line in `## guides` names a guide, then `link` or `copy`, then the file that supplies it:

```text
## guides
<guide file>: link <path>
<guide file>: copy <path>
```

- **Guide file:** one of `engineering-best-practices.md`, `test-guide.md`, `doc-writing-guide.md`, `release-guide.md`, `bug-writing-guide.md` or `research-guide.md`. A template can't carry `build-commands.md`, because its commands are per code folder.
- **Path:** an absolute path, or a path relative to the template folder, so a template can carry its own guide files.
- **`link`:** project-setup writes a short pointer guide that names the file. Later edits to the file reach every Project that links it.
- **`copy`:** project-setup copies the file into the Project once. After that, the Project's copy and the source change independently.

Guides from a template always go in the Project Folder's `.apiary/`, because a template can't know a Project's code folders. Release rules are set by `release-guide.md`, so a template sets them as a guide.

## Example: GitHub intake

This template takes new Ideas and Bugs from GitHub issues and shares one release guide. It leaves every other question to project-setup.

```markdown
# Project Template: github-intake

new_idea_intake: /home/you/.apiary/system/resolvers/github.md
new_bug_intake: /home/you/.apiary/system/resolvers/github.md

## guides
release-guide.md: link /home/you/guides/release-guide.md
```

Save it as `~/.apiary/templates/github-intake/template.md`, replacing `/home/you` with your home folder.
