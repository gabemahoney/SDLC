# Test guide (Apiary default)

Apiary uses this file only when the Project has no `guide:test-guide.md` of its own.

## Keep the suite lean

Aim for about 80% coverage with as few lines of test code as possible, because every extra test costs maintenance without adding confidence. Don't gold-plate: you don't need a test for every scenario.

- **Test each behaviour once at each level.** One unit test of a rule is enough; an end-to-end test may check the same behaviour again from the outside.
- **Parameterize.** When three or more tests differ only in their inputs, make them one parameterized test.
- **Delete as readily as you add.** Deleting tests matters as much as adding them: remove duplicated tests, tests a change made obsolete, and tests that no longer earn their maintenance, whenever you touch the suite.

## Reuse the Project's test setup

Before writing a test, find the fixtures, factories, helpers and constants the Project already has, and reuse them. If one doesn't do exactly what you need, change it, then update every test that uses it, rather than adding a near-copy. Do that work, because one unified set of fixtures is what keeps the suite consistent and small. Add new setup only where nothing fits, in the place the Project keeps shared setup, and extend existing test files before adding new ones.

When planning testing Subtasks, name the setup each one reuses, changes or adds, and the test files it extends or creates, so parallel writers don't duplicate or clash over it.

## Test behaviour, not implementation

Assert on what the code produces, not how it works inside, so tests survive refactoring.

- **Mock sparingly.** Mock external services, expensive operations and injected errors. Use real files in a temporary directory, and real functions, rather than mocks. A test with more than about three mocks is usually testing implementation; test it at a higher level instead.
- **Assert exactly.** Check the exact value or output the contract promises, not a loose substring.
- **Cover the edges.** Test error paths, invalid input and inputs that should do nothing, not just the happy path.
- **Never weaken a test to make it pass.** If the code is wrong, report the bug; don't encode it into the suite.

## Keep tests self-contained

Write files only under a temporary directory, never in the repo or a real shared location. Undo any global change a test makes. Don't depend on system tools behaving the same everywhere, and don't sleep: inject the time instead.

## Avoid test bloat

- **No meta-tests.** Don't test the test setup itself; if a fixture breaks, the real tests fail anyway.
- **Inline simple values.** Use `"open"` rather than a constant like `STATUS_OPEN`; keep constants for complex formats or values used in many places.
- **Import only what you use.**
- **Keep test docs short.** One or two lines per fixture, with longer explanations in the Project's testing docs.

## Cover regressions where they occur

Exercise the boundary where the defect occurs. Use unit coverage for an isolated rule and integration coverage for interacting components, because a component test can pass while the reported interaction still fails.
