# Guides

Guides tell SDLC how you want work done. Use project-setup to choose or write them. You can keep rules in a guide or point it at an existing document in your repository.

## The seven guides

| File | What it controls |
| --- | --- |
| `engineering-best-practices.md` | Engineering and code review rules. |
| `test-guide.md` | Test design, coverage and review. |
| `doc-writing-guide.md` | Documentation content, location and style. |
| `build-commands.md` | Compile, lint, unit and integration test commands for each code folder; optionally model checking. |
| `release-guide.md` | Release process, permissions and human approvals. |
| `bug-writing-guide.md` | Bug report format used by write-bug and define-bug. |
| `research-guide.md` | Sources, depth, evidence, Report shape, human involvement and work after acceptance. |

## Where guides go

Check code guides (engineering rules, tests and build commands) into the repository so every contributor gets them, whether they use SDLC or not. Keep settings, reused generic guides and pointers to repository guides on your host, in the Project Folder's `.sdlc/` or `~/.sdlc/`, so repositories stay free of SDLC setup.

SDLC reads a named guide from the main checkout's `.sdlc/`, then parent `.sdlc/` folders, then `~/.sdlc/`. Outside a repository, the walk starts at the current code folder. Work in a worktree still reads guides from the main checkout, so unfinished guide changes do not govern their own review.

Copies **combine cumulatively**; a nearer file does not replace an inherited one. The Managing Intelligence settles conflicts. With no user copy anywhere in the walk, SDLC uses `~/.sdlc/<name>-default-fallback.md`. For example, the fallback for `test-guide.md` is `test-guide-default-fallback.md`. Installed fallback files are replaced on upgrades; put your own rules in the user guide filename.

Put shared Project guidance in `<Project Folder>/.sdlc/`, code-folder-specific guidance in that folder's `.sdlc/`, and personal defaults in `~/.sdlc/`. Project-wide release and research guidance belongs in the Project Folder's `.sdlc/`, even without a code folder. A shared Research store still uses the requesting Project's research guide.

## Example: point to repository guidance

For a checkout named `shop` under your Project Folder, point `<Project Folder>/.sdlc/test-guide.md` at its testing guide:

```markdown
Read ../shop/docs/testing.md for this repository's testing rules.
```

Relative paths resolve from the pointer file's folder; absolute paths work too. Project Templates write absolute pointers for linked guides so the link works from each Project. In skill instructions, `guide:test-guide.md` means this whole lookup, and `guide:build-commands.md ## Unit tests` selects a named section.

## Build and release requirements

For each code folder, `build-commands.md` needs `## Compile`, `## Lint`, `## Unit tests` and `## Integration tests`, each with a runnable command or `none` and a reason. A shared guide identifies each folder's commands. `## Model check` names the modelling language and checker command when needed. The build fallback asks you to supply real commands.

Your release guide must say what agents may do without a human, which steps require whose approval, and the release process, including its checks. Cover pushing, tagging and publishing explicitly so agents know their permissions. The shipped fallback permits local commits and merges only and defines no release process; release stops until you supply one through project-setup. A bot acting as Managing Intelligence cannot give an approval reserved for a named human.
