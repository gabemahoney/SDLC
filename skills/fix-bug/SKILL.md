---
name: fix-bug
description: "Fix a defined Bug, prove the regression is covered, review and merge the repair, and hand it back for acceptance. Takes a Bug ID."
---

# fix-bug

## Purpose

Follows define-bug and takes a confirmed Bug through implementation, review, testing and merge. The Managing Intelligence checks the merged fix and accepts or returns it.

## Loading Apiary

You are running an Apiary software development workflow. Before anything else, read `~/.apiary/system/workflow.md`, then follow this skill. After a compaction, re-read `~/.apiary/system/workflow.md` before going on.

## Input

A Bug ID.

## Required Reading

- **Workflow:** `~/.apiary/system/workflow.md`. Why: to follow the shared Run rules.
- **Settings files:** `<Project Folder>/.apiary/project_settings.md`, then `~/.apiary/default_project_settings.md`. Why: to select the Ticket System Protocol File through `ticket_system`, and map the Bug's tag and the reviewers' and Integration Tester's `thinking_levels` through `levels_claude_code` or `levels_codex`.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` in Claude Code, or `~/.apiary/system/protocols/agent-codex.md` in Codex CLI. Why: to dispatch and resume Subagents and ask and report through the Agent.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: to read the Bug and its dependencies and record execution evidence, decisions and status.
- **Bug and dependencies:** through the Ticket System Protocol File, using the input ID. Why: to read the confirmed behaviour, recorded reproduction, `thinking_level:<label>` tag, Source References, progress and Managing Intelligence decisions, including why an earlier fix was returned.
- **Resolvers:** `~/.apiary/system/resolvers/<resolver>.md`, selected by each Source Reference's kind. Why: to read supporting evidence.
- **Repo and merge context:** affected main checkouts at `<Project Folder>/<repo path>/` and Bug worktrees at `<Project Folder>/.worktrees/<bug id>/<repo path>/`. Why: to identify source, tests and docs, record base revisions and merge targets, and resume from actual git state.
- **Guidance Documents:** `engineering-best-practices.md`, `test-guide.md`, `doc-writing-guide.md`, `maintained-docs.md`, `build-commands.md` and `release-guide.md` for each affected repo, found as `workflow.md` describes. Include the documents `maintained-docs.md` lists. Why: to judge findings, check the fix and affected documentation, and commit, merge and push as permitted.
- **Subagent reports:** reports returned during execution and retained on the Bug. Why: to coordinate fixes and resume unfinished work.

## Gate

Run only when all of these are true:

- The Bug is `defined`, or `active` when resuming. If it is `draft`, stop and suggest define-bug. For any other status, stop and report it.
- Every ticket the Bug depends on is `done`. If any isn't, stop and report the dependency.
- The Run starts outside `<Project Folder>/.worktrees/`, because it merges and removes its own worktrees. If it starts inside, stop and say to run from the Project Folder.

## Steps

1. **Prepare or resume the repair.** Reconcile the Bug's progress with ticket and git state. Set it `active` when work starts. Create an isolated worktree for each affected repo at the Bug's worktree path, based on its main checkout's current branch. Record each base revision and merge target. Reuse existing Bug worktrees on a resumed Run and continue the unfinished phase. Name the Bug, assigned work and each repo checkout in dispatches; executors use the Bug's Thinking Level.

2. **Implement and review the fix.** Follow the Repair pipeline below. Give the Test Writer the Bug's retained reproduction and base revisions so it can prove the regression test fails before the fix and passes after. Record accepted findings, unacted-on findings with their reasons, and decisions on the Bug.

3. **Prove the repair.** Once code, unit tests and documentation settle, pass the Integration gate below. Rerun define-bug's recorded reproduction against the repaired worktrees, using the same inputs and setup, and record the observed result alongside the regression evidence.
   - If the symptom remains, route it through the repair pipeline.
   - If the reproduction can't run, record why and stop for the Managing Intelligence's decision on how to verify the fix. Record that decision on the Bug and follow it.

4. **Commit, merge and hand off.** Once accepted findings are resolved, regression evidence is complete, the original reproduction, or the verification the Managing Intelligence chose, shows the expected behaviour, required checks pass and the integration gate is met, commit the Bug's changes in each worktree. Merge each into its recorded target from the main checkout, following `release-guide.md`. Record successful merges and remove their worktrees and branches. Leave the Bug `active` for the Managing Intelligence's check.
   - If a merge conflicts, preserve that worktree and record the conflicting files and completed merges. Stop for resolution; a later Run resumes the unfinished merge and cleanup.

## Dispatches

- **Engineer:** launch for source changes. Expect the implementation, targeted checks, deviations and changes affecting design or documentation.
- **Test Writer:** launch for regression coverage and after every source-changing pass, one per Lane and a final Writer after multiple Lanes. Expect unit tests, before-and-after regression evidence, fixture changes, gaps and assigned test results.
- **Doc Writer:** launch once code and tests settle to assess and update the maintained user, contributor and design documents. Expect changes or a reason none are needed. Resume for rounds with documentation findings or upstream changes affecting docs.
- **Code Reviewer:** launch after source changes, while Test Writers work. Expect correctness, engineering and lint findings with references and suggested fixes, or no findings.
- **Test Reviewer:** launch after unit-test changes settle, while the Doc Writer works, and after integration-test changes. Expect findings on test quality, regression coverage and duplication across the suite, or no findings.
- **Doc Reviewer:** launch after the Doc Writer finishes. Expect findings on complete touched documents and documentation missing or made outdated by the fix, or no findings.
- **Integration Tester:** launch on settled changes at the integration gate. Expect integration tests written or updated as needed, test-side repairs and a result per affected repo: `passed`, `source failures`, `could not run` or `no suites found`, with commands and evidence.

## Writes

- The Bug becomes `active` when work starts and stays `active` after merge. It holds progress, reproduction and regression evidence, review findings and decisions, checks, integration results and waivers, commits and merges, and retained executor records.
- Bug branches and worktrees are created for affected repos. Executors and the Integration Tester change files there; fix-bug commits, merges into the recorded targets and removes merged worktrees and branches.

## Done

Report the Bug's ID and status, repair summary, commits and merges per repo, before-and-after regression evidence, original reproduction result, integration results or waivers, and unacted-on review findings. Identify any remaining worktrees, unfinished phase or decision needed.

After merging, ask the Managing Intelligence to check the fix. They set the Bug `done` on acceptance or return it to `draft` for define-bug.

## Repair pipeline

Executors do the file work; reviewers provide independent checks. The skill coordinates their reports, judges findings and commits the result.

Use the same order as develop-epic: Engineer first; then Code Reviewer and Test Writers in parallel; then Test Reviewer and Doc Writer in parallel; then Doc Reviewer. Run roles when their work is required as Dispatches describes. Collect all findings before one batched fix round. Resume each affected executor once in source → unit tests → documentation order, carrying accepted findings and the preceding executors' reports. Batch documentation work into that round's single Doc Writer pass. Re-review changed work with fresh reviewers and repeat for findings still worth fixing.

The sole Test Writer, or final Writer after multiple Lanes, owns the full unit-suite run in every affected repo with unit tests. It runs once after its changes, fixes test failures and rechecks. Give each later source- or unit-test-changing pass the same owner. Route source failures to the Engineer, then back through unit testing and review. Other roles use targeted checks; the Integration Tester owns integration-suite runs.

## Regression evidence

Keep at least one unit test that fails against the pre-fix source and passes against the repaired source. Have the Test Writer demonstrate both results and record the commands and revisions, because a passing test alone does not prove it catches this regression. Exercise the public boundary that captures the reported interaction and state what the test covers and misses. The original reproduction checks the reporter's exact symptom beyond that unit coverage.

## Test Writer Lanes

A **Lane** is a group of unit-test files one Test Writer can change independently. Choose Lanes from the Bug's affected behaviours and files. Keep files together when they share a fixture or helper being changed or cover overlapping behaviour.

Give each Lane its files and behaviours, the other Lanes' assignments and the shared fixture/helper list. Each owns its files and exclusively used fixtures and helpers, including exclusively used entries in common helper files. It reports shared changes and gaps outside its files for the final Writer. After multiple Lanes finish, one final Test Writer uses all their reports to make shared changes, close gaps and run the full unit suite. A sole Writer owns all the Bug's unit tests and helpers. Apply the same ownership in fix rounds.

## Executor reuse and progress

Start one fresh Engineer, one Test Writer per Lane and one Doc Writer for the Bug as needed. Retain them, including any final Test Writer, for fix rounds. Resume only affected executors; they keep their Guidance Documents and add those for newly assigned repos. Replace an executor that cannot continue with a fresh one carrying the findings and work so far. Reviewers and Integration Testers start fresh on every dispatch.

Update the Bug after each report with the current phase, repo checkouts, base revisions and merge targets, pending findings, checks, integration results and repair-round count, commits and merges, and next work. For each retained executor, record its Role, Bug, Lane or final-Writer assignment, Agent ID, name if available and dispatch Thinking Level. After compaction or a re-run, resume by name if available, otherwise by ID, reconciling progress with ticket and git state.

## Integration gate

Run the Integration Tester across the affected worktrees once code, unit tests and documentation settle. The gate passes when every repo reports `passed` or `no suites found`, or the Managing Intelligence explicitly waives its remaining failures. Record results and waivers on the Bug.

- If integration tests change, get a fresh Test Reviewer check. Resolve accepted test findings with a fresh Integration Tester and obtain its final suite result for the resulting files.
- If source fixes are needed, pass the failures through the repair pipeline, including the full unit suite and affected documentation, then get a fresh Integration Tester result. Stop for the Managing Intelligence's decision if a round does not reduce failures or failures remain after three source-fix rounds.
- If suites cannot run, stop for the environment to be fixed or an explicit waiver. Keep the unfinished gate and evidence on the Bug so a later Run resumes there.

Results apply to the changes tested. Further source or integration-test changes need a new integration result; source changes also need the regression and original reproduction checked again.
