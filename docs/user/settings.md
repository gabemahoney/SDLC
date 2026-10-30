# Settings reference

Run project-setup to choose settings, or edit the settings files yourself. Settings choose SDLC's tools, ticket stores and input sources; [guides](guides.md) hold your working rules.

## Files and precedence

SDLC reads `<Project Folder>/.sdlc/project_settings.md` first, then `~/.sdlc/default_project_settings.md`. The Project Folder is the nearest ancestor of your working directory containing `.sdlc/project_settings.md`. Without one, SDLC uses the folder the Agent started in and reads only home defaults. Project Folders cannot nest.

The first file naming a setting supplies its **whole value**. A Project's `levels`, `thinking_levels` or `resolvers` block replaces the home block; their entries do not merge. Keep every entry that Project needs when overriding a block. Unmapped resolver kinds still use shipped files.

Write one-line settings as `<name>: <value>`, or use a `## <name>` heading for a multi-line value. Store file and folder paths as absolute paths so they work from every checkout.

## Available settings

| Setting | Value and purpose |
| --- | --- |
| `ticket_system` | Protocol name; SDLC ships `bees`, selecting `~/.sdlc/system/protocols/ticket-bees.md`. |
| `launcher` | Protocol name; SDLC ships `agent-director`, selecting `~/.sdlc/system/protocols/launcher-agent-director.md`. |
| `prd_template` | Path to the PRD layout. Setup suggests `~/.sdlc/system/doc-templates/prd.md`, expanded to your home path. |
| `new_idea_intake` | Path to the instructions for new Ideas. Setup suggests the shipped interview intake. See [Intakes and resolvers](intakes-and-resolvers.md). |
| `new_bug_intake` | Path to the instructions for new Bugs, chosen independently of the Idea intake. |
| `resolvers` | Optional block of `<kind>: <absolute path>` lines adding or overriding Source Reference kinds. An unmapped kind uses `~/.sdlc/system/resolvers/<kind>.md`, including when this setting is unset. |
| `research_location` | Absolute folder path for Research tickets, Reports and artifacts, located through the ticket protocol. A home default shares research across Projects; a Project override selects a separate store. Research uses the requesting Project's guide. |
| `levels` | A block mapping all five Thinking Levels to an Agent, model and effort or mode. See [Thinking Levels](thinking-levels.md). |
| `thinking_levels` | A block of `<skill>: <level>` lines covering every Main Agent and Child Agent skill. Setup supplies the recommendations from `~/.sdlc/system/templates/thinking-levels.md`. |
| `ticket_links` | Agreed instructions for Dependencies, Associations or Source References the selected ticket protocol does not cover. Only needed for uncovered link types. |
| `child_watch_command` | Optional host command followed by Child Agent IDs. It must return when any child's state leaves `pending` or `working`, printing `<id> <state>`. Setup offers it in home defaults; when unset, the launcher protocol supplies status polling. |

Setup suggestions are choices to save, not automatic runtime defaults. If a Run needs a setting absent from both files, it stops and points to project-setup. Another ticket system or launcher needs a corresponding protocol with the operations setup checks.

## Example: Project research store

In `/home/you/projects/shop/.sdlc/project_settings.md`:

```text
research_location: /home/you/projects/shop/research
```

This replaces only `research_location`; other settings still come from home defaults. Run project-setup to create or check the store. [Project Templates](../project-templates.md) can reuse settings across Projects.
