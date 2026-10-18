# Test guide

Apiary uses this default when the Project has no `test-guide.md` of its own.

## Reuse the Project's test setup

Before writing a test, find the fixtures, factories, helpers and constants the Project already has, and reuse or extend them. Add new setup only where nothing fits, in the place the Project keeps shared setup. Extend existing test files before adding new ones. This keeps tests consistent and stops each test building its own setup.

When planning testing Subtasks, name the setup each one reuses, changes or adds, and the test files it extends or creates, so parallel writers don't duplicate or clash over it.

## Test each behaviour once at each level

One unit test of a rule is enough; an end-to-end test may check the same behaviour again from the outside. Update tests the change affects, remove tests it makes obsolete and add missing coverage.

## Keep the suite lean

Avoid duplicated tests across files and needless test complexity, because they add maintenance without adding coverage.

## Cover regressions where they occur

Exercise the boundary where the defect occurs. Use unit coverage for an isolated rule and integration coverage for interacting components, because a component test can pass while the reported interaction still fails.
