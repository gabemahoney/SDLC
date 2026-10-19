# Documentation writing guide (Apiary default)

Apiary uses this file only when the Project has no `guide:doc-writing-guide.md` of its own.

## The README

The README is for people who want to install and run the Project. A reader should get through it in under a minute and have the Project running in five. Above all, keep it short and simple: how to install, and how to use.

- No implementation details.
- No code. Command lines are fine, and should be concrete and copy-pasteable.
- The happy path only: no theoretical error cases or alternative installs.
- Don't explain common tools, such as bash or a package manager.
- No debugging tips in the README.
- The Project as it is now: no legacy features and nothing about the past.
- Don't point to the extended docs; readers can find them.

## User guides

Put fuller detail on using the Project in user-facing guides in `docs/`: anything readers need that doesn't fit in a short README, such as configuration, backups, migration and less common tasks.

## Architecture docs

Architecture docs live in `docs/architecture/`. They set the architecture guidelines for their area and serve as a quick reference to the design: its components, how they interact, and the decisions behind them. Don't include code, because agents can read the code themselves.

## Other guides

Keep developer and operational guides current where the Project needs them, such as testing and release instructions.

## Write and trim

- Document what the software actually does now, not what it might do later.
- Use short, plain sentences, and lead with what the reader needs to know.
- Explain each fact in one place and link to it elsewhere, because repeated explanations drift apart.
- Use lists for things that really are lists, and paragraphs for everything else.
- Add a document only when its content has no suitable home, so the docs stay easy to navigate.
- Remove outdated or duplicated passages and documents. Trimming and deleting matter as much as adding.

Always finish any doc writing or reviewing effort with a succinctness pass: reread what was wrote and cut every word, sentence and section the reader doesn't need. Be on guard for documentation bloat, because docs grow with every change and each extra line makes the useful ones harder to find.
