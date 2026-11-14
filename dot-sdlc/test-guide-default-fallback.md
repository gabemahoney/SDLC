# Test guide (SDLC default)

SDLC uses this file only when the Project has no `guide:test-guide.md` of its own.

## Keep the suite lean

Aim for about 80% coverage with as few lines of test code as possible, because every extra test adds maintenance without adding confidence. Don't gold-plate: you don't need a test for every scenario.

- **Choose cases by distinct regressions.** Acceptance criteria are obligations, not a test inventory. Combine related requirements in representative cases; add a case only when it catches a plausible failure the existing cases would miss.
- **Parameterize.** When three or more tests differ only in their inputs, make them one parameterized test.
- **Delete as readily as you add.** Deleting tests matters as much as adding them: remove duplicated tests, tests a change made obsolete, and tests that no longer earn their maintenance, whenever you touch the suite.

## Keep the full run fast

A full run of the unit and integration suites should finish within 15 minutes of run time, because every Epic and Bug waits for one before handoff. If it runs longer, split it into parallel jobs or raise it with the Managing Intelligence. A Project with its own test guide sets its limit there.

## Reuse the Project's test setup

Before writing a test, find the fixtures, factories, helpers and constants the Project already has, and reuse them. If one doesn't do exactly what you need, change it, then update every test that uses it, rather than adding a near-copy. Do that work, because one unified set of fixtures is what keeps the suite consistent and small. Add new setup only where nothing fits, in the place the Project keeps shared setup, and extend existing test files before adding new ones.

When planning testing Subtasks, name the setup each one reuses, changes or adds, and the test files it extends or creates, so parallel writers don't duplicate or clash over it.

## Test behaviour, not implementation

Assert on what the code produces, not how it works inside, so tests survive refactoring.

- **Mock sparingly.** Mock external services, slow operations and injected errors. Use real files in a temporary directory, and real functions, rather than mocks. A test with more than about three mocks is usually testing implementation; test it at a higher level instead.
- **Assert exactly.** Check the exact value or output the contract promises, not a loose substring.
- **Cover changed edges.** Add edge and error cases where the change introduces or alters a failure path; rely on existing tests for unchanged shared paths.
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

## Modelling for tractability

Ordinary-test rules exclude models, because percentages and test economy cannot waive coverage, controls or abstraction arguments.

- Store comparisons, defer immutable choices and clear fields after their last reader, because choices multiply states; preserve correlations, same-value writes, stale callbacks and races.
- Tabulate all concrete initial/history classes, abstract representatives, mapped/erased steps and why observations/successors survive; show each property implies its clause and justify liveness fairness separately, because finite episodes alone prove no cutoff.
- Partition immutable choices exhaustively or close component assumptions with checked guarantees covering peer effects and cross-component races, because independent histories multiply.
- Trace selectors into reachable behaviour/properties and investigate equal counts; merge only under observation/transition equivalence, because counts prove neither coverage nor equivalence.
- List oracle reads, forbid operational dependencies and derive expectations from independent source events; audit allowed/forbidden raw effects, because shared computations hide corruption.
- For each clause, record inspected outcome witnesses and mutations, exact violated predicates, trace locations and untested conjuncts under final reductions; credit shared controls only for demonstrated clauses, because early unrelated violations prove nothing.
- Archive exact inputs before each run and stream logs with versions/settings/resources, initial/generated/distinct/queued counts, depth, wall time and completion/cancellation, because later sources cannot reproduce earlier evidence.
- Label diagnostic completion separately from gate passage and inspected expected violations as successful controls, because process exit cannot establish proof.

### TLA+ and TLC

- Inspect configurations, because SANY does not validate them.
- Use symmetry only for interchangeable roles and safety; equal views must preserve observations/successors, because reductions can hide violations.
- Treat constraints, simulation and smaller probes as diagnostics, because unexplored behaviour remains.
- Unless overridden, accept unchanged exhaustive cases after two different fingerprint polynomials agree on completed verdicts/distinct counts; retain estimates/residual risk, because agreement cannot prove collision freedom. Inspected concrete control traces need no second polynomial, because they prove reachability.
- Keep heap headroom and measure exhaustive throughput on allocated CPUs, because simulation speed cannot predict exhaustive time.
