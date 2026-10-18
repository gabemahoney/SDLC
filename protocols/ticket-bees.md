# bees Ticket System Protocol File

Select this file with `setting:ticket_system` set to `bees`. It installs as `~/.apiary/system/protocols/ticket-bees.md`. Each skill defines the body sections it writes.

## Prerequisites

Use the installed `bees --help` and each command's `--help`. Commands return JSON; check their result. Run the CLI from the Project Folder or a checkout covered by its bees scope. MCP tools accept `repo_root` for the same scope; their names use underscores, such as `create_ticket`. `show_ticket` takes `ticket_ids` as a list; `update_ticket` takes a single ID string for body changes. Use `body_file` for verbatim Markdown, including bodies over the inline 10,000-character limit.

## Create or check stores

Use `bees list-hives`, `bees get-types` and `bees get-status-values` to read paths, scopes, tiers and statuses. Match the Research hive by its path at `setting:research_location`, because its name may differ in a shared store.

Create each missing store with `bees colonize-hive --name '<store>' --path '<absolute-path>' --scope '<Project Folder>/**' --child-tiers '<JSON>' --status-values '<JSON>'`. Use a scope covering all requesting Projects for shared Research. Child-tier JSON is:

- Ideas: `{"t1":["Doc","Docs"]}`.
- Plans: `{"t1":["Epic","Epics"],"t2":["Task","Tasks"],"t3":["Subtask","Subtasks"]}`.
- Bugs: `{}`.
- Research: `{"t1":["Report","Reports"]}`.

Statuses are `["draft","defined","active","done"]`, plus `"invalid"` for Bugs. Repair existing configurations with `bees set-types --scope hive --hive '<store>' --child-tiers '<JSON>'` and `bees set-status-values --scope hive --hive '<store>' --status-values '<JSON>'`. The MCP `colonize_hive` has no status argument; use `set_status_values` after it.

## Create a ticket

Write its body to a UTF-8 file, then use `bees create-ticket --hive '<store>' --ticket-type bee --title '<title>' --status draft --body-file '<file>'`. Choose the status the skill owns. For a child, use its configured tier (`Doc`, `Epic`, `Task`, `Subtask` or `Report`) and `--parent '<id>'`; bees maintains the parent–child link. Parentage is immutable after creation.

## Read a ticket

Use `bees show-ticket --ids '<id>'` (or several IDs) for bodies, statuses, tags and relationships. Use the returned child and parent IDs to read related tickets.

## Find tickets

Use `bees execute-freeform-query --query-yaml '{stages: [[hive=plans, type=bee]], report: [title, ticket_status]}'` to list Plans. Replace the filter with `parent=<id>` for direct children, or use graph stages such as `[[id=<id>], [up_dependencies]]` for prerequisites. Read bodies with `show-ticket`.

## Update a ticket section

Read the current body, replace the named `##` section up to but excluding the next heading of the same or higher level, or append it if absent, and save the complete body to a UTF-8 file. Preserve other sections so another skill's record survives. Use `bees update-ticket --ids '<id>' --body-file '<file>'`; bees has no section-update command. Coordinate writers to the same ticket because this replaces its body. `append-ticket-body` appends at the end of the body, not inside a named section.

## Set status

Use `bees update-ticket --ids '<id>' --status '<status>'`. Several IDs may be updated together when the skill owns the same transition for all of them.

## Add a Dependency

Bees requires both tickets to have the same tier type. Read the waiting ticket's `up_dependencies`, add the prerequisite ID, and send the complete list with `bees update-ticket --ids '<waiting-id>' --up-deps '["<prerequisite-id>","<existing-id>"]'`. The list replaces the old one; bees updates the reciprocal downstream link. Remove a Dependency by writing the list without it. Record its reason under `## Dependencies` where the ticket format calls for it.

## Add an Association

Bees has no Association field. Add the related ticket's ID and relationship under `## Associations` on both tickets, using Update a ticket section, so either can find the other. Include the hive path for shared Research so readers can resolve its scope.

## Add a Source Reference

Keep the intake URL or absolute file path under `## Source References`, using Update a ticket section. Apiary's Resolver instructions interpret it. This body record also works for child tickets; bees' `reference_materials` field is restricted to top-level bees.

## Attach a file

Bees has no attachment command. Find the hive path with `list-hives` and the ticket's directory: a bee is `<hive>/b.abc/b.abc.md`; a child is `<hive>/b.abc/t1.abc.de/t1.abc.de.md`, with deeper tiers nested the same way. Copy the file into an `artifacts/` folder beside that ticket's Markdown file. Add a Markdown link and description under `## Artifacts`, using Update a ticket section. Resolve relative links from the ticket's directory when reading attachments. Model files stay beside their Model Doc; Research artifacts stay in the hive at `setting:research_location`.

## Set tags

Use `bees update-ticket --ids '<id>' --add-tags '["thinking_level:high"]'` for a Task or Bug. To replace a Thinking Level, also pass `--remove-tags` with its old tag; preserve unrelated tags. Use the level chosen by the skill.

## Delete a ticket

Use `bees delete-ticket --ids '<id>'` for obsolete work the planning skill removes. Deletion includes all children. Remove its Dependencies first with Add a Dependency's list update, because automatic dependency cleanup depends on bees configuration; update body Associations on surviving tickets too.

## Retain Research

In the active bees configuration (normally `~/.bees/config.json`), remove the Research hive's `undertaker_schedule` entry under its owning `scopes` entry's `hives` map, preserving the rest. There is no CLI or MCP schedule-setting operation. Restart any running `bees serve` process using that configuration so its scheduler reloads. Keep that hive out of external scheduled `bees undertaker` commands too, so accepted Reports and artifacts remain readable.
