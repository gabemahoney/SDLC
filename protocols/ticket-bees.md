# bees Ticket System Protocol File

## Prerequisites

Tickets live in bees, and you know how to use it. bees only shows a hive to commands run inside that hive's scope, so run them from the Project Folder or a checkout under it. Shared Research has its own scope, set when it was created.

## Create or check stores

Each store is a hive scoped to the Project Folder. Find Research by `setting:research_location`, because a shared hive may have another name. Give each hive these child tiers, because Apiary's skills expect them:

- **Ideas:** Doc.
- **Plans:** Epic, then Task, then Subtask.
- **Bugs:** none.
- **Research:** Report.

Every hive's statuses are `draft`, `defined`, `active` and `done`, and Bugs also have `invalid`, because the skills move tickets through exactly these.

## Apiary's records in bees

Keep every ticket title you write to a few words, like an email subject line, with details in the body, so ticket lists stay readable.

When a skill says to:

- **Update a ticket section:** bees replaces whole bodies, so change only that section and keep the rest. Keep one writer per ticket at a time, so no update is lost.
- **Add a Dependency:** use bees dependencies. Both tickets must be the same tier.
- **Add an Association:** bees has no field for it, so record the related ticket's ID, and its hive path for shared Research, under `## Associations` on both tickets.
- **Add a Source Reference:** record the intake URL or absolute file path under `## Source References`, because Apiary's Resolvers read it from there.
- **Attach a file:** bees has no attachments, so copy files into an `artifacts/` folder beside the ticket's own file and link them under `## Artifacts`. Don't name folders or files after ticket IDs, because bees can mistake them for tickets.
- **Set a Thinking Level:** use a `thinking_level:<label>` tag, replacing any old one.
- **Delete a ticket:** first remove other tickets' Dependency and Association links to it and its children.
- **Retain Research:** keep the Research hive out of automatic archiving, so accepted Reports and artifacts stay readable.

Skills often need a ticket's children (`{stages: [[parent=<id>]], report: [title, ticket_status]}`) and its prerequisites (`{stages: [[id=<id>], [up_dependencies]]}`).
