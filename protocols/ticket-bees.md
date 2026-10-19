# bees Ticket System Protocol File

## Prerequisites

Tickets live in bees. bees only shows a hive to commands run inside that hive's scope, so run them from the Project Folder or a checkout under it. Shared Research has its own scope, set when it was created.

## Create or check stores

Each store is a hive scoped to the Project Folder. Find Research by `setting:research_location`, because a shared hive may have another name. Give each hive these child tiers, because Apiary's skills expect them:

- **Ideas:** Doc.
- **Plans:** Epic, then Task, then Subtask.
- **Bugs:** none.
- **Research:** Report.

Every hive's statuses are `draft`, `defined`, `active` and `done`, and Bugs also have `invalid`, because the skills move tickets through exactly these.

## Create a ticket

Create it in its store with the status the skill assigns. A child goes under its parent at its tier.

## Read a ticket

Read its body, status, tags and relationships.

## Find tickets

Query bees by hive, type, parent or Dependency.

## Update a ticket section

bees replaces whole bodies, so read the current body, change only the named section, and write the whole body back. Keep one writer per ticket at a time, so no update is lost.

## Set status

Set the status the skill's transition gives.

## Add a Dependency

Add the prerequisite to the waiting ticket's dependencies. Both must be the same tier.

## Add an Association

bees has no Association field, so record the related ticket's ID, and its hive path for shared Research, under `## Associations` on both tickets.

## Add a Source Reference

Record the intake URL or absolute file path under `## Source References`, because Apiary's Resolvers read it from there.

## Attach a file

bees has no attachments, so copy files into an `artifacts/` folder beside the ticket's own file, and link them under `## Artifacts`. Don't name folders or files after ticket IDs, because bees can mistake them for tickets.

## Set tags

Set the Thinking Level as a `thinking_level:<label>` tag, replacing any old one.

## Delete a ticket

Delete obsolete work the skill removes. This deletes its children too, so first remove other tickets' Dependency and Association links to it.

## Retain Research

Keep the Research hive out of automatic archiving, so accepted Reports and artifacts stay readable.
