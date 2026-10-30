# Engineering best practices (SDLC default)

SDLC uses this file only when the Project has no `guide:engineering-best-practices.md` of its own. Focus on what breaks, leaks or rots, not on style.

## Fit the codebase
- **Match existing patterns.** Follow the codebase's conventions, and don't add a second way of doing something it already does.
- **Separate concerns.** Keep business logic, interfaces and data access apart.
- **Build only what's needed.** Don't add abstractions for imagined future needs; three similar lines beat the wrong helper.
- **The deletion test.** Before adding an abstraction, imagine deleting it. If deleting it removes complexity, don't add it; if the complexity would spread into its callers, it earns its place. (Adapted from Matt Pocock's `codebase-design` skill, MIT licence: github.com/mattpocock/skills.)

## Leave no dead code
Remove commented-out code, unused functions and imports, old implementations left after a refactor, and debugging output. Version control keeps the history.

## Security and correctness
- Validate input at system boundaries.
- Use parameterized queries, never string-built ones.
- Check file paths against the expected workspace before using them.
- Load secrets from the environment or config, never from source.
- Check authorization on every protected path.
- Keep stack traces, internal paths and secrets out of user-facing errors.

## Readable code
- Name things for what they do or hold, and use named constants instead of magic values.
- Split functions that grow long or deeply nested.
- Comment the why, not the what, and fix any comment your change made false.

## Errors
- Catch specific errors; never swallow them silently.
- Clean up resources with the language's own mechanism.
- Handle failure on every I/O, network and external call.
- Write error messages that say what went wrong and what to do.

## Performance
Avoid the obvious traps: queries in loops, loading whole files you could stream, blocking calls in async code, and caches with no rule for when they expire.

## Beyond the diff
- **Callers.** For anything whose behaviour, signature or ordering you change, check that its callers' assumptions still hold.
- **Second-order effects.** Ask what the change newly exposes or can now fail: a new call on a path that couldn't fail before, a renamed field that dashboards or logs still read, code moved across a guard.
- **Symmetry.** When you add a new kind of resource, update every path that cleans up its siblings too.
