# bees Ticket System Protocol File

## Prerequisites

Tickets live in bees. bees only shows a hive to commands run inside that hive's scope, so run them from the Project Folder or a checkout under it. Shared Research has its own scope, set when it was created.

## Create or check stores

Read paths, scopes, tiers and statuses with `bees list-hives`, `bees get-types` and `bees get-status-values`. Match Research by `setting:research_location`, because a shared hive may have another name.

Create missing stores with:

```sh
bees colonize-hive --name '<store>' --path '<absolute-path>' --scope '<Project Folder>/**' --child-tiers '<JSON>' --status-values '<JSON>'
```

For shared Research, use a scope covering its requesting Projects. Child-tier JSON:

- Ideas: `{"t1":["Doc","Docs"]}`.
- Plans: `{"t1":["Epic","Epics"],"t2":["Task","Tasks"],"t3":["Subtask","Subtasks"]}`.
- Bugs: `{}`.
- Research: `{"t1":["Report","Reports"]}`.

Statuses are `["draft","defined","active","done"]`, plus `"invalid"` for Bugs. Repair existing configurations with `bees set-types --scope hive --hive '<store>' --child-tiers '<JSON>'` and `bees set-status-values --scope hive --hive '<store>' --status-values '<JSON>'`.

## Create a ticket

Use the status the skill assigns and a UTF-8 body file:

```sh
bees create-ticket --hive '<store>' --ticket-type bee --title '<title>' --status '<status>' --body-file '<file>'
```

For a child, replace `bee` with its tier (`Doc`, `Epic`, `Task`, `Subtask` or `Report`) and add `--parent '<id>'`. Bees maintains the parent–child link; parentage is immutable.

## Read a ticket

Use `bees show-ticket --ids '<id>'` for its body, status, tags and relationships. Several IDs may follow `--ids`.

## Find tickets

Use `bees execute-freeform-query --query-yaml '{stages: [[hive=plans, type=bee]], report: [title, ticket_status]}'` to list Plans. Replace the filter with `parent=<id>` for direct children, or use graph stages such as `[[id=<id>], [up_dependencies]]` for prerequisites. Read bodies with `show-ticket`.

## Update a ticket section

Bees replaces whole bodies. Read the current body, replace only the named section through the next heading of the same or higher level (excluding that heading), or append it if absent. Preserve other sections and write the complete body to a UTF-8 file:

```sh
bees update-ticket --ids '<id>' --body-file '<file>'
```

Use one writer per ticket at a time to avoid lost updates. `append-ticket-body` appends at the body's end, not inside a section.

## Set status

Use `bees update-ticket --ids '<id>' --status '<status>'`. Several IDs may be updated together when the skill owns the same transition for all of them.

## Add a Dependency

Both tickets must have the same tier type. Read the waiting ticket's `up_dependencies` and send the complete list, including the new prerequisite:

```sh
bees update-ticket --ids '<waiting-id>' --up-deps '["<prerequisite-id>","<existing-id>"]'
```

This replaces the list and updates reciprocal links. Remove a Dependency by omitting it from the list. Record reasons where the skill requires them.

## Add an Association

Use Update a ticket section to put the related ID and relationship under `## Associations` on both tickets, so either can find the other. Include shared Research's hive path to identify its store; Bees has no Association field.

## Add a Source Reference

Keep the intake URL or absolute file path under `## Source References`, using Update a ticket section. Apiary's Resolver instructions interpret it. This body record also works for child tickets; bees' `reference_materials` field is restricted to top-level bees.

## Attach a file

Bees has no attachment command. Find the hive path with `bees list-hives`. A bee lives at `<hive>/<bee-id>/<bee-id>.md`; children nest inside their parents as `<child-id>/<child-id>.md`.

Copy files into `artifacts/` beside the owning ticket's Markdown file. Link and describe them under `## Artifacts`; resolve relative links from that ticket's directory. Model files belong to their Model Doc; Research artifacts stay at `setting:research_location`.

Avoid ticket IDs as artifact directory names and `<name>/<name>.md` pairs, because Bees' scanner can mistake them for tickets.

## Set tags

Use `bees update-ticket --ids '<id>' --add-tags '["thinking_level:high"]'` for a Task or Bug. To replace a Thinking Level, also pass `--remove-tags` with its old tag; preserve unrelated tags. Use the level chosen by the skill.

## Delete a ticket

Use `bees delete-ticket --ids '<id>'` for obsolete work the planning skill removes. Deletion includes all children. First remove surviving tickets' Dependency and Association links to the ticket or its children using the operations above, because automatic dependency cleanup depends on Bees configuration.

## Retain Research

In the active Bees configuration (normally `~/.bees/config.json`), remove Research's `undertaker_schedule` from its entry under `scopes` → the owning scope → `hives`, preserving the rest. There is no schedule-setting command. Restart HTTP `bees serve` instances using that configuration, because their scheduler loads it at startup. Keep Research out of external scheduled `bees undertaker` commands too, so accepted Reports and artifacts remain readable.
