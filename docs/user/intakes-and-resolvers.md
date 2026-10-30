# Intakes and resolvers

An **intake** tells write-idea or write-bug how to turn your input into a ticket. A **resolver** tells write-prd or define-bug how to read the ticket's original source, called a Source Reference. Both intake skills always accept plain text describing the work or defect.

## Choose files

Set `new_idea_intake` and `new_bug_intake` independently to the chosen file's absolute path in either [settings file](settings.md). The shipped choices are:

| File under `~/.sdlc/` | Use |
| --- | --- |
| `install/intakes/interview.md` | Takes any input, including nothing, and asks questions until the work is clear. |
| `install/resolvers/github.md` | Takes a GitHub issue URL as an intake; also resolves GitHub Source References. |
| `install/resolvers/file.md` | Resolves a file Source Reference by reading it. It has no intake instructions. |

`resolvers` is optional: add or override a source kind with a `<kind>: <absolute path>` line under `## resolvers`. GitHub URLs use `github`; file paths use `file`. A kind without a mapping uses `~/.sdlc/install/resolvers/<kind>.md`, even when the setting is unset. If neither a mapping nor a shipped resolver exists, the Run stops. The selected file and its prerequisites must be available.

## Example: GitHub Issues

Install the GitHub CLI and give it access to the repository whose issues you want to read. Put this in your Project settings, replacing `/home/you` with your home folder:

```text
new_idea_intake: /home/you/.sdlc/install/resolvers/github.md
new_bug_intake: /home/you/.sdlc/install/resolvers/github.md
```

Run project-setup to check the files and prerequisites, then give write-idea or write-bug an issue URL. The intake reads the issue and records its URL on the ticket. write-prd or define-bug later reads it through the `github` resolver; downstream skills use the ticket's established requirements.

## Write your own

Your intakes live in `~/.sdlc/intakes/` and your resolvers in `~/.sdlc/resolvers/`. Installing or upgrading SDLC never writes there, so your files stay as you left them, just like [Project Templates](../project-templates.md). The shipped files under `~/.sdlc/install/` are replaced on installation.

Create the user folder and write a Markdown file, or copy a shipped file there to customize it. An intake describes its accepted input and how to prepare the ticket. A resolver describes how to identify and read its source kind. Include prerequisites such as a CLI, login or file access so setup can check them. A file serving both roles needs both sets of instructions.

Set the intake path or resolver mapping to your file's absolute path. A resolver named `support.md` needs an explicit `support` entry; its filename alone does not register it. A Project `resolvers` block replaces the home mapping, so include every custom or overridden kind you want to keep; unmapped kinds still use shipped resolvers.
