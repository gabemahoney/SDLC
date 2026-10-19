# Documentation writing guide (Apiary default)

Apiary uses this file only when the Project has no `guide:doc-writing-guide.md` of its own.

## The README

The README is for people who want to install and use the Project. A reader should get through it in about a minute and have the Project running in about five.

- Cover installing and using it, on the main path. Leave out implementation details, alternative installs, error cases, migration, backups and debugging.
- Use concrete commands readers can copy and paste. Don't explain common tools.
- Describe the Project as it is now, not its history or legacy features.

## Architecture docs

Keep architecture docs current with the system's components, how they interact, and the design decisions behind them, so readers can find the design without reading all the code. Use the Project's existing architecture docs, or `docs/architecture/` if it has none. Describe the design rather than reproducing code, which readers can open themselves.

## Other guides

Keep developer and operational guides current where the Project needs them, including configuration, testing and release instructions.

## Write and trim

- Document what the software actually does now, not what it might do later.
- Use short, plain sentences, and lead with what the reader needs to know.
- Explain each fact in one place and link to it elsewhere, because repeated explanations drift apart.
- Use lists for things that really are lists, and paragraphs for everything else.
- Add a document only when its content has no suitable home, so the docs stay easy to navigate.
- Remove outdated or duplicated passages and documents. Trimming and deleting matter as much as adding.
