# Engineering best practices (Apiary default)

Apiary uses this file only when the Project has no `guide:engineering-best-practices.md` of its own.

## Abstractions
- **The deletion test.** Before adding an abstraction (a module, class, interface or helper), imagine deleting it. If deleting it removes complexity, don't add it. If the complexity would spread into its callers instead, it earns its place. Apply the same test to an existing abstraction under review.
  (Adapted from Matt Pocock's `codebase-design` skill, MIT licence: github.com/mattpocock/skills.)
