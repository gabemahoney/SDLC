---
name: write-idea
description: File a new Idea from a description of the work or intake input such as an issue URL, following the Project's new_idea_intake setting.
---

# write-idea

## Purpose

Files a new Idea in `draft`. It is the first step of the Idea flow; write-prd comes next.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

A description of the work, or intake input such as an issue URL.

## Reads

- The `new_idea_intake` setting, from the Project Folder's `.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. It names how this Project files Ideas: interview the Managing Intelligence, or a source reference resolver such as `github`.

## Gate

None: write-idea creates a new ticket.

## Steps

1. Follow the intake named by `new_idea_intake` to check the input. If it doesn't fit, stop and ask the Managing Intelligence for what's needed.
2. When the intake names a source reference resolver, store the input as the Idea's source reference.
3. Follow the intake's instructions for the Idea's body.
4. File the Idea.

## Dispatches

None.

## Writes

- A new Idea in the Ideas store, status `draft`.

## Done

Print the Idea's ID. Next step: "write-prd".
