---
name: write-idea
description: File an Idea from a description of the work or intake input such as an issue URL, using the Project's new_idea_intake setting.
---

# write-idea

Files an Idea. Input: a description of the work, or intake input such as an issue URL.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Gate

None: write-idea creates a new ticket.

## Owned transition

write-idea creates `draft`.

## Filing the Idea

Read the `new_idea_intake` setting. It names how this Project files Ideas: interview the Managing Intelligence, or a source reference resolver such as `github`. If the input doesn't fit that intake (for example, no issue URL for the `github` resolver), stop and say what's needed. Otherwise follow it:
- When it names a source reference resolver, store the input as the Idea's source reference.
- When it says to interview the Managing Intelligence, do so and write the description in the Idea's body.

File the Idea and print its ID. Next step: "write-prd".
