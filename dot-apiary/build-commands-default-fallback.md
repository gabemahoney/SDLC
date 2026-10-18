# Build commands (Apiary default)

Apiary uses this file when no user copy of `guide:build-commands.md` is found as `~/.apiary/system/workflow.md` describes.

This fallback cannot know the Project's commands. Stop and ask the Managing Intelligence to write a real `build-commands.md`, using project-setup to settle it. The descriptions below are not commands or permission to skip checks.

For every code folder, the first four sections must contain a runnable command or `none: <reason>`. A shared guide identifies each folder's commands. Include `## Model check` when formal modelling is needed.

## Compile

Give the command that compiles or type-checks the code.

## Lint

Give the command that checks lint and formatting without changing files.

## Unit tests

Give the command that runs the full unit test suite.

## Integration tests

Give the command that runs the integration suites.

## Model check

Optional: name the formal-modelling language and checker command; supply both before checking a Formal Model.
