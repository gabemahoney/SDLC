# Build commands (SDLC default)

SDLC uses this file only when the Project has no `guide:build-commands.md` of its own.

This fallback cannot know the Project's commands. Stop and ask the Managing Intelligence to write a real `build-commands.md`, using project-setup to settle it.

For every code folder, the first four sections must contain a runnable command or `none: <reason>`. A shared guide identifies each folder's commands. Include `## Model check` when formal modelling is needed. For a check that runs outside the session, make its run command return once the job is submitted, and also give the command that blocks until it ends and one that reports without blocking whether it has ended.

## Compile

Give the command that compiles or type-checks the code.

## Lint

Give the command that checks lint and formatting without changing files.

## Unit tests

Give the command that runs the full unit test suite.

## Integration tests

Give the command that runs the integration suites.

## Fast checks

Optional: say how to run tests for only what changed, and name the cheap repo-wide guards, such as format or size checks, to run with them at every commit, so commit checks catch in minutes what a full run would catch later.

## Model check

Optional: name the formal-modelling language, the checker command and a parse-only command, needed before any Formal Model is checked. We suggest TLA+ with the TLC model checker, for example `java -cp tla2tools.jar tlc2.TLC -config <Model>.cfg <Model>.tla`, parsed with `java -cp tla2tools.jar tla2sany.SANY <Model>.tla`.

Optionally give the time cap for one gating checker run, and a longer one for during-build runs, sized to the Project's budget within the limits of the Model Check term in `~/.sdlc/install/workflow.md`.
