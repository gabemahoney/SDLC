# Build commands (SDLC default)

SDLC uses this file only when the Project has no `guide:build-commands.md` of its own.

This fallback cannot know the Project's commands. Stop and ask the Managing Intelligence to write a real `build-commands.md`, using project-setup to settle it.

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

Optional: name the formal-modelling language and the checker command, needed before any Formal Model is checked. We suggest TLA+ with the TLC model checker, for example `java -cp tla2tools.jar tlc2.TLC -config <Model>.cfg <Model>.tla`.
