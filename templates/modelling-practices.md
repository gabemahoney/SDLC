# Modelling practices

model-writer and model-review read this file in every Project, because Formal Models need these practices whatever test guide the Project has. A Project's `guide:test-guide.md` may add to them or override them.

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
