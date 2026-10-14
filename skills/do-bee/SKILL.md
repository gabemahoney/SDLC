---
name: do-bee
description: Proceed through each Epic in a Bee, doing the work described therin. Report questions and status back to caller.
---

## Overview

This skill orchestrates the work for a complete Bee ticket by:
0. Refusing to start unless the User approved the Bee's PRD (Approval guard)
1. Finding the Bee to work on and validating it is ready (all child Epics hatched — none `draft`)
2. Finding the best Epic to work on
   2.1. Validating the Epic is unblocked
   2.2. Reconciling the Epic and downstream plan against work completed in previous Epics (re-plan, not hatch)
3. Spawning role subagents to complete the work described in the Epic, sending questions and requests for clarification or guidance to the caller
4. Finishing Tasks and Epics:
   4.1. After each Task: creating one git commit that includes all changes for that Task, and running the integration suites after a flagged Task
   4.2. After the Epic's last Task: dispatching one Test Writer to run the integration suites (the Epic is not finished while they fail)
   4.3. Recording progress in the Bee's `## do-bee progress` section and stopping, so the next Epic runs in a fresh session
5. Dispatching reviewer subagents and addressing the issues they find, in a fresh session after the last Epic
6. Getting User approval
7. Marking Bee and all child tickets as closed
8. Outputting a final summary

### Execution model

You are the **calling agent**. Role players (Engineer, Test Writer, Doc Writer, Product Manager, and the reviewers) are **subagents** — named agent definitions installed in `.claude/agents/`, spawned via the Agent tool: `Agent(subagent_type: "<agent-name>", prompt: <task-specific dispatch prompt>)`.

Rules that apply to every dispatch in this skill:

- **Background dispatch**: if the Agent tool schema accepts `run_in_background`, pass `run_in_background: true`; otherwise omit it — background is the harness default under Claude Code fork-subagents mode. Every dispatch in this skill is a background dispatch.
- **Cold start**: subagents are never named, reused, or messaged mid-flight. Every dispatch is a fresh spawn with a self-contained prompt. Dispatch prompts name the relevant ticket IDs; subagents read the tickets from the bees CLI themselves.
- **Hub-and-spoke**: subagents never talk to each other. The working tree diff plus the returned report is the handoff. You serialize dependent roles and thread each report into the next role's dispatch prompt.
- **Reconciliation loop**: drive the work event-driven, not as one big blocking turn. Each tick: (1) observe current state — ticket store, working tree, in-flight Agent status; (2) reconcile — dispatch whatever fresh Agent invocations the delta requires; (3) yield the turn. The harness fires a completion notification when each background Agent finishes; that notification triggers the next tick. No polling, no sleep loops, no blocking waits inside a turn.
- **Compaction recovery**: when a compaction/summarization marker is visible in your conversation, everything before it is non-authoritative. Before dispatching the next tick's work after a compaction, re-read the authoritative sources in full — the bees CLI for ticket state, git for code state, and the filesystem for any state files. The Bee's `## do-bee progress` section (4.3) is a short guide to these sources, not one of them. Conversation memory is never a substitute for these sources.
- **One Epic per session**: you cannot clear your own context, so after each Epic you record progress on the Bee and stop (4.3). Whoever drives the session starts a fresh `/do-bee <bee-id>`, which resumes from the Bee (step 1) the same way you recover from a compaction.
- **Delegate discipline**: you must not do role work yourself. You dispatch subagents, route reports on completion, and commit.

#### In Codex CLI

The rules above name Claude Code's tools. In Codex CLI, keep the rules and use these instead:

- **Dispatch**: for `Agent(subagent_type: "<agent-name>", prompt: <P>)`, call `spawn_agent` with `agent_type: "<agent-name>"` (pass it even if the tool does not list it; the agent is defined in `~/.codex/agents/<agent-name>.toml` or the repo's `.codex/agents/`), `message: <P>`, `fork_turns: "none"` (the cold start; where `spawn_agent` has no `fork_turns`, do not fork) and a unique `task_name` of lowercase letters, digits and underscores (e.g. `engineer_t2_abc_de`). Pass no `model` or `reasoning_effort`: the agent file sets them.
- **Ticks**: Codex sends no completion notification. Spawn every dispatch of the tick, then call `wait_agent` (prefer long waits, minutes): it ends the tick, and is the one blocking wait allowed. Each finished agent's report starts the next tick. Never end your turn while an agent you spawned is still running: Codex will not wake you when it finishes, so wait for it with `wait_agent` instead. Close a finished agent with `close_agent` where that tool exists.
- **Concurrency**: Codex runs a few agents at once (`agents.max_concurrent_threads_per_session`, 4 by default, you included). When no slot is free, wait for an agent to finish before spawning the next, so parallel dispatches (e.g. Test Writer lanes) may run in batches.
- **Questions**: there is no AskUserQuestion. Ask in plain text in your reply and end your turn. No-questions mode is unchanged.
- **Skills and agents**: "invoke the /x skill" or the Skill tool means: read `~/.agents/skills/x/SKILL.md` (or the repo's `.agents/skills/x/SKILL.md`) and follow it. Agent definitions are `.codex/agents/apiary-*.toml`, not `.claude/agents/apiary-*.md`.

### Modes

- **No-questions mode**: on when you are given `--no-questions` or `--lane`, or when you run as an agent-director worker (`AGENT_DIRECTOR_INSTANCE_ID` is set in your environment; such workers usually cannot use AskUserQuestion). In this mode never use AskUserQuestion. Wherever this skill asks the User or the caller — with AskUserQuestion or in plain text — stop instead. Put what you know in your output, end it with exactly one line `do-bee: needs input: <question, with the options>`, and end your turn. The driver answers in this session, or starts a fresh session and gives the answer in plain words alongside the ID (e.g. `/do-bee b.xxx signed off`).
- **Lane mode** (`/do-bee <epic-id> --lane`): you are one Epic lane of a `/run-lanes` run, working in that Epic's own worktree while other lanes work on other Epics of the same Bee. Lane mode implies no-questions mode and changes these steps:
  - Step 1: work only the named Epic; never pick another. The Bee's `## do-bee progress` section belongs to `/run-lanes`: never resume from it or write it, and never edit any other part of the Bee body.
  - Validate worktree: you must be in the Epic's lane worktree, named after the normalized Epic ID (e.g. `t1_xxx_ab` for `t1.xxx.ab`), on the branch of the same name. If not, stop with a needs-input line.
  - Step 2 reconcile: do steps 1–2 for your own Epic only. Skip step 3 (downstream Epics): other lanes may be working on them, and each Epic gets its own reconcile pass when its lane starts.
  - 4.3: skip steps 1–2. Stop with exactly this line: `do-bee: Epic <epic-id> done in lane <worktree path>. Next: run /run-lanes <bee-id> to merge it.`
  - Never go on to step 5 or later; those run after `/run-lanes` merges every lane.

### Approval guard

Run this first in every session, before step 1: no question, worktree check, status change or dispatch comes before it. If you were not given an ID, pick the Bee as step 1 says, then run this before anything else.

A Bee is built only once the User has approved its Idea's PRD. Read tickets with `bees show-ticket --ids <id>`.

1. Plan Bee: given a Bee ID, that Bee. Given an Epic, or any ticket below one, follow `parent` up to the Bee.
2. Idea Bee: the Ideas-hive Bee named in the Plan Bee's `reference_materials` (its `bees` entry) or `up_dependencies`. `bees execute-freeform-query --query-yaml "stages: [[id=<id>, hive=ideas]]"` returns a ticket only if it is in the Ideas hive. If there is more than one, check each.
3. PRD: the Idea Bee's t1 child titled `PRD`.
4. The PRD's `tags` must include `approved:yes`.

If any step fails, stop at once: change no ticket, write no progress section and dispatch nothing. In no-questions mode (including lane mode), end your output with exactly one of these lines; otherwise tell the user the same and stop:
- `do-bee: needs input: <prd-id> lacks approved:yes — the User must approve it`
- `do-bee: needs input: no <Plan Bee | Idea Bee | PRD> found for <ticket-id> — cannot check approved:yes`

This skill never adds `approved:yes`. Only the User approves.

### 1. Find Bee to work on and validate

The user will either call without arguments, with a Bee id or with an Epic ID:
- If called without arguments, find all bees for this repo and ask the user which one they want to work on
- If called with a Bee id, find all Epics in the `defined` state that are unblocked and ask which one they want to work on, unless the Bee has a progress section (see Resume from the progress section). In no-questions mode, do not ask: take the Epic step 2 recommends.
- If called with an Epic id, find the Bee that is a parent of that Epic and use that Bee (in lane mode, work only that Epic)

You will ultimately get the Bee ID you need to work on.
Validate it is ready for work:
- Must have a status of `defined` or `active`
- If it has `up_dependencies` they must be `defined` or later (not `draft`). (This leniency is deliberate: Bee-level dependencies express planning order, not "code already written".)
- All child Epics must be `defined` or later — none `draft`. A `draft` Epic means hatching is incomplete: stop and tell the caller to finish `hatch-epic` for every remaining `draft` Epic under this Bee. Never hatch Epics yourself; never execute a partially hatched Bee.

#### Validate worktree
You should have been launched in a worktree with a name like "b_Wx7" for a bee called "b.Wx7". After a `/run-lanes` run, this is the feature worktree it created. Lane mode has its own check (see Modes).
If you are not launched in such a worktree:
- In no-questions mode, do not ask: carry on in the current checkout, and state its directory and branch in your first output so the driver can see where the commits land.
- Otherwise use AskUserQuestion to confirm they want to proceed. Tell them what directory and branch they are on.

#### Resume from the progress section
If the Bee's body has a `## do-bee progress` section (4.3), this session continues earlier work: do not ask which Epic to work on. Read the section first, then re-read the authoritative sources as in **Compaction recovery** — the bees CLI for ticket state, git for code state. Resume at the section's **Next**: an Epic resumes at step 2, including the reconcile pass; `final Bee review` resumes at step 5; `User sign-off` resumes at step 6, using any answer given alongside the ID. Where ticket state or git disagree with the section, they win (step 2).
If **Next** is `run-lanes`, the Bee's Epics are being built in Epic lanes by `/run-lanes`, which owns the section until every lane is merged. Start no Epic; stop with exactly this line: `do-bee: Bee <bee-id> is running in Epic lanes. Next: run /run-lanes <bee-id>.`

### 2. Find Epic to work on and validate

Find all Epics in the Bee and recommend the best one to work on first:
- Must have a status of `defined` or `active`
- If it has `up_dependencies` they must be in `done` state
- An Epic in `active` whose Tasks are all `done` but whose body has no `**Integration Suites**:` result line stopped at the 4.2 gate: resume it at 4.2 step 1.
- An Epic in `active` whose body has an `**Integration Suites**:` result line met the 4.2 gate and is complete. Epics are marked `done` only in step 7, so skip it, and count it as `done` for the `up_dependencies` check and the reconcile pass below.
- When resuming from the progress section (step 1), start from its **Next** Epic, but ticket state and git are authoritative: if they disagree (e.g. another Epic is in `active` stopped at the 4.2 gate, or the named Epic is not ready), follow the rules above and correct the section at the next hand-off (4.3).
- If ANY Epic under the Bee is still `draft`, that is an error — the Bee was handed off before hatching completed. Stop and report it to the caller; do not hatch it yourself and do not execute around it.


#### Reconcile the plan against completed work (re-plan, not hatch)
All Epics were hatched up front, before any coding started, so each completed Epic can make the remaining plan stale. Before starting work on each Epic (skip this pass only when no Epic in the Bee is `done` yet — nothing has been built):

1. Review the git diff of the Epics completed so far to understand what was actually built
2. Read this upcoming Epic and its Tasks/Subtasks; update any descriptions now stale given what was built (file paths changed, function signatures differ, new modules created)
3. Scan downstream not-yet-started Epics for descriptions the completed work has outright invalidated (removed files, renamed modules, changed contracts) and fix those; leave cosmetic drift for that Epic's own reconcile pass when it comes up

This is RE-PLANNING: you are editing Tasks/Subtasks of Epics that are already hatched (`defined`). It NEVER creates Tasks for a `draft` Epic — that is hatching, which finished before this skill started. This reconcile pass is exactly why all hatching can and must happen up front.

#### Mark status when ready to start work

If ready, mark the Epic status with `status=active` to show work has started on the Epic

### 3. Dispatch Subagents to Execute Tasks

Before dispatching, load all Tasks and Subtasks for the Epic:
- Use `show_ticket()` on the Epic to get the `children` array (Task IDs)
- For each Task, fetch its full details including its own `children` array (Subtasks)
- Read every Subtask — these contain the detailed instructions (Context, What Needs to Change, Key Files, Acceptance Criteria) that the role subagents must follow
- Sort Tasks in dependency order (check each Task's `up_dependencies`) to ensure no Task is blocked when executed
- Verify at least 1 Task exists with at least 1 Subtask, and all are ready for work: `status!=draft`
- Mark the current Task with `status=active` to show work has started
- Mark the Bee with `status=active` to show work has started (if not already set)

Dispatch role subagents to work on an individual Task.
**IMPORTANT: You must not do role work yourself. Dispatch subagents, route their reports, and commit.**

Choose which roles are required.
- If source code is being modified or created, dispatch `apiary-engineer`.
  - **The Engineer is responsible for source code. It does *not* know how to update unit tests or docs!**
- If test code is being modified or created, or the Engineer changed source code (so the full unit suite runs), dispatch `apiary-test-writer`.
    - **The Test Writer is responsible for unit tests. It does *not* know how to update source code or docs!**
    - Divide the Task's testing Subtasks into Test Writer lanes and dispatch one Test Writer per lane, with no upper limit on lanes per Task.
    - Start from the suggested lanes in the Task body's `## Test Writer Lanes` section (written by hatch-epic). They are a suggestion: use more or fewer lanes when the Engineer's actual change calls for it, and state your reason in the Task report whenever you depart from the plan. If the Task has no recorded lanes (older plans), choose the lanes yourself by the same grouping rule hatch-epic uses: one lane per independent group of test files.
    - Keep test files that share a fixture or helper the Task creates or changes, or that test overlapping behaviour, in one lane, so no lane depends on another and all lanes run fully in parallel.
    - In each lane's dispatch prompt, name the other lanes' test files and the behaviours they cover, so lanes do not duplicate each other's cases, helpers or test matrices. Also include the `Shared fixtures or helpers` list from `## Test Writer Lanes` (or your own list when none was recorded). With more than one lane, a lane writer may create or change a fixture or helper only its own lane's files use, even in a common conftest or helper module (that entry only), but must not change any that another lane's files use (anything on that list, or that it can see other lanes' files rely on), and closes gaps in the Engineer's change only in its own lane's test files; it reports any other fixture or helper change or gap instead. With one lane, the list is context only: that Test Writer owns all of the Task's tests, fixtures and helpers and closes all gaps.
    - Whenever more than one lane is used — first pass, re-work or fix-up — dispatch one final Test Writer once all lanes finish, with their reports threaded into its prompt, to make the shared fixture or helper changes the lanes reported and close the test gaps they reported.
    - Trade-off: more lanes give more parallelism and a shorter Task, at some risk of duplicated cases for the reviews to clean up; fewer lanes are more serial but duplicate less.
- If docs need to be modified or created, dispatch `apiary-doc-writer` for **one** initial pass per Task, after code and tests have settled (see Sequencing across ticks). After that it is dispatched only for the batched doc pass of each review round (and the final-review fix-up in step 5), never to re-sync docs after each code or test change.
- If this is the initial dispatch for a Task, **always** dispatch `apiary-product-manager`.
  - If this is a re-work dispatch after reviewer feedback you may **optionally** choose to not dispatch the Product Manager, if the work is minor enough and will not impact Product functionality

Within a Task the roles run in order: the Engineer, then the Test Writer lanes in parallel (followed by the final Test Writer when more than one lane ran), then the Doc Writer.

Each full test suite has exactly one owner:
- **Full unit suite**: the last Test Writer of each Test Writer pass — the sole Test Writer when one lane runs, otherwise the final Test Writer after the lanes — runs it once and fixes failures; its dispatch prompt tells it that it owns the full unit-suite run, and no other Test Writer's prompt does. That is once per Task, plus once per later re-work, fix-up or integration-fix pass. On a Task's first pass, assign that writer the Task's "run the full unit test suite and fix failures" Subtask, which stays out of the lanes.
- **Integration suites**: the integration Test Writer you dispatch once per Epic after its last Task, after any flagged Task, and after final-review fix-ups that change source code or integration tests (4.1, 4.2, step 5).
- No one else — not you, the Engineer, lane Test Writers, the Doc Writer, the Product Manager or the reviewers — runs either full suite; roles may run targeted tests for the code they touched.

#### Sequencing across ticks

Coordination between roles is sequencing you own, spread across reconciliation ticks:
- On the Engineer's completion tick, dispatch the Test Writer lanes with the Engineer's report threaded into their dispatch prompts — they review the Engineer's work as part of their instructions. Dispatch the final Test Writer (when more than one lane ran) on the last lane's completion tick.
- Dispatch the Doc Writer's initial pass after code and tests have settled: on the completion tick of the last Test Writer (or of the Engineer, when the Task has no test work), with the Engineer and Test Writer reports threaded into its dispatch prompt.
- Dispatch the Product Manager sequentially with whatever prior reports you want it to review — commonly at the end for a full review of the Task, but nothing prevents interim PM dispatches (e.g., a PM check on the Engineer's design before a Test Writer starts writing against it).
- One hard constraint: the PM must not run in parallel with a writer whose output it is supposed to review — concurrent subagents cannot see each other's in-flight work.
- Dispatch the integration Test Writer (4.2) on the tick the Epic's last Task, or a flagged Task, is committed (or the final-review fix-ups settle, step 5), never alongside another role: it must run against the settled tree.
- Batch re-work within a Task (e.g. after PM findings) in the same order as the initial pass: the Engineer, then the Test Writers per step 3 (lanes by your judgement, plus the final Test Writer when more than one lane runs), then the Doc Writer, each dispatched after the previous role's re-work completes, with the earlier re-work reports threaded into its prompt. Skip any role with no findings and no upstream changes to follow. Make at most **one** Doc Writer dispatch for that review round, carrying all doc-affecting findings batched together. Never dispatch one Doc Writer pass per finding, or a doc pass while that round's code or tests are still changing. Skip the doc pass entirely if nothing doc-affecting changed.

After dispatching this tick's work, yield — the harness fires a completion notification per Agent finish, which drives the next reconciliation tick.

Each role's Responsibilities and Instructions live in its agent definition (`.claude/agents/apiary-*.md`). Your dispatch prompt supplies the job-specific context: the Task and Subtask IDs to work, any threaded reports from prior roles, and any re-work items from reviewer feedback.

#### 4.1 After Each Task

When a Task and all its Subtasks are done (all reviewer feedback addressed or ignored):

1. Create one git commit for the Task. Use system or project defined guidance on git usage. **NEVER push to remote — committing only.**
2. If the Task is flagged — its body has a `## Run Integration After This Task` section (written by hatch-epic) — and it is not the Epic's last Task, run the integration loop now (4.2 steps 1-3) and meet its gate (4.2 step 4) before marking the Task `done`. The Epic's last Task needs no separate run: 4.2 covers it.
3. Mark the Task as `status=done` (Subtasks were marked `done` by each subagent as they completed their work).
4. Output the summary below to the screen and continue to the next Task

```
## Task [N] of [total] Complete: [task-title]

**Task ID**: <task-id>
**Files Changed**: [count] files ([list key filenames if < 5, otherwise just count])
**Reviews**: [Code review: X issues found/None needed | Docs review: Y issues found/None needed]
**Test Writer Lanes**: [used: N | planned: M, or "none recorded" | reason, whenever you departed from the plan] or "No test work"
**Integration Run**: [passed | passed after fixing: <summary> | no integration suite found | waived by User: <last result>] when flagged and run after this Task, otherwise "End of Epic only"
**Ignored Review Feedback**: [list items that were flagged by code-review or doc-review but Director chose not to address, or "None"]
**Follow-up Tasks Created**: [count, if any] [list task-ids if created]
One of:
- Proceeding to next Task <task-id>
- Final Task of the Epic, moving on to the Epic's integration run
```

#### 4.2 Run the Epic's integration suites
Once the Epic's last Task is committed, run the integration suites once for the Epic:

1. Dispatch one `apiary-test-writer` as the integration Test Writer, naming the Epic ID (and the flagged Task ID, for a run after a flagged Task). It finds the integration test command (configured in the project's CLAUDE.md, otherwise discovered from the repo's docs or CI config), runs the integration suites, fixes and re-runs failures caused by the tests without editing source, and reports exactly one result: `passed` (or `passed after fixing: <summary>`), `source failures: <list>`, `could not run: <reason>` or `no integration suite found`. You do not run the suites yourself.
2. Act on the result:
   - `source failures`: dispatch `apiary-engineer` with the failures threaded into its prompt, then re-dispatch the integration Test Writer with the Engineer's report threaded in (it covers the fix in unit tests and runs the full unit suite itself). Repeat, but stop and ask the caller if an Engineer round does not reduce the failures, or after 3 Engineer rounds, whichever comes first.
   - `could not run`: ask the caller straight away; never dispatch the Engineer for it.
   - After you ask, one of three things happens: the User fixes the environment or gives guidance and you re-run from step 1; the User explicitly waives the gate for this Epic — record the waiver as its result; or execution stops with the Epic left in `active`. That stop is not a 4.3 hand-off: leave the progress section as it is; step 2's gate rule resumes the Epic.
3. If the integration run changed any files, create one git commit for them. **NEVER push to remote — committing only.**
4. **Gate**: an Epic is not done until its last integration run reported `passed` or `no integration suite found`, or the User waived the gate (step 2). Until then, never mark it `done` (wherever that happens, including step 7), start the next Epic or move to Final Review.
5. Append the result to the Epic ticket's body, for the step 8 summary, and output the summary below to the screen

```bees
append_ticket_body(ticket_id="<epic-id>", chunk="\n\n**Integration Suites**: <result>")
```

```
## Epic Complete: [epic-title]

**Epic ID**: <epic-id>
**Integration Suites**: [passed | passed after fixing: <summary> | no integration suite found | waived by User: <last result>] (command: <command>, configured or discovered)
```

Then record progress and stop (4.3).

#### 4.3 Record progress on the Bee and stop
Only once the Epic has met the 4.2 gate (4.2 step 4) and its result is appended and output (4.2 step 5):

1. Rewrite the Bee's `## do-bee progress` section in full — never append to it, so it stays short:

```markdown
## do-bee progress

**Epics done**:
- <epic-id> <epic-title>: commits <sha>, <sha>; status `<status in the ticket store>`; Integration Suites: <result>
**Next**: <next-epic-id> | all Epics done; next: final Bee review
**Open decisions/questions**: <list, or "None">
**Notes for the next session**: <only what the ticket store and git do not already hold, or "None">
```

   The status is a cross-check against the ticket store: a done Epic stays `active` until step 7, so its integration result is what marks it done. Pick the next Epic by the step 2 rules; it must already be hatched (`defined` or `active`, never `draft`) — execution never triggers hatching.
2. **Edit only this section; never change any other part of the Bee body.** The bees CLI replaces the whole body, so read the current body (`bees show-ticket --ids <bee-id>`), replace only the section — from its `## do-bee progress` heading up to the next line starting with `## `, or the end of the body; append it at the end if absent — leave every other byte unchanged, and write it back:

```bees
update_ticket(ticket_id="<bee-id>", body_file="<edited body file>")   # bees update-ticket --ids <bee-id> --body-file <path>
```

3. Stop. Your final output is exactly one of these lines:
   - More Epics remain: `do-bee: Epic <epic-id> done. Next: <next-epic-id>. Run /do-bee <bee-id> in a fresh session to continue.`
   - Last Epic: `do-bee: Epic <epic-id> done. All Epics done. Next: final Bee review. Run /do-bee <bee-id> in a fresh session to continue.`

Whoever drives the session (a human, a loop, or an orchestrator spawning a fresh worker per Epic) starts the fresh session, which resumes from step 1. To build independent Epics side by side instead, the driver uses `/run-lanes`, which runs each Epic as `/do-bee <epic-id> --lane` (see Modes). Stopping is the default. Only if the driver explicitly asks to continue in the same session (sensible only for small Bees), still rewrite the section (4.3 steps 1-2), then go straight on to the next Epic (step 2), or to step 5 after the last, instead of stopping.

### 5. Final Bee-level Code, Doc and Eng reviews

This step runs in a fresh session, resumed from the Bee's `## do-bee progress` section after the last Epic's hand-off (4.3), unless the driver asked to continue in the same session.

Once all Epics in the Bee are done, dispatch the applicable reviewer subagents as parallel background dispatches (up to three, one per applicable reviewer) in a single reconciliation tick:

If you dispatched the Engineer during execution, dispatch `apiary-code-reviewer`.
If you dispatched the Test Writer during execution, dispatch `apiary-test-reviewer`.
If you dispatched the Doc Writer during execution, or the change touched a README or any doc the repo's doc-writing guide governs (whoever edited it), dispatch `apiary-doc-reviewer`.

Each reviewer subagent invokes its corresponding review skill (/code-review, /test-review, /doc-review) and returns a numbered list of freeform findings (an explicit "no findings" statement when there are none). Include this line in each reviewer's dispatch prompt: "Your review skill is a read-only operation — invoke it via the Skill tool; do not decline the invocation."

- Get the feedback, and make a judgement call about whether that work must be done
  - If so, **spawn fresh role subagents as needed** to do the work
    - **IMPORTANT** Do not do the work yourself — dispatch, route reports, and commit.
    - If the feedback was minor enough, you may choose to **NOT** dispatch the Product Manager on this iteration 
    - Dispatch any role subagents required to do the work you deem necessary from the reviewer findings, keeping the fix-up lean and in the same order as the initial pass: code findings to the Engineer, then the test findings to Test Writers per step 3 (lanes by your judgement, plus the final Test Writer when more than one lane runs), then all doc findings batched into a single Doc Writer. Dispatch each role after the previous role's fix-up completes, with the earlier fix-up reports threaded into its prompt; skip any role with no findings and no upstream changes to follow.
    - If the fix-ups changed source code or integration tests, run the integration loop (4.2 steps 1-3) once after they settle, before step 6, naming the Bee ID (all its Epics) instead of an Epic ID, and record its result as a `**Post-review Integration Suites**: <result>` line in the Bee's `## do-bee progress` section (rewritten as in 4.3 step 2, never appended to the Bee body); the 4.2 gate still applies when the Epics are marked `done` in step 7.
  - If not, move on to Final Review but you MUST share the ignored feedback for review
  - Note: This could create an infinite loop so you may ignore feedback so long as you present it in Final Review

  
### 6. Final Output

When **all** Epics in the Bee are done, you must show the User the full list of all Reviewer feedback you chose to ignore.
- Use the AskUserQuestion tool to ask the User if they want you to act on any of these, or just continue.

For each Acceptance Criteria, either demonstrate it directly (via test or script) or instruct the user how to validate it manually. Then use `AskUserQuestion` to get official sign-off on the Acceptance Criteria.

Then use `AskUserQuestion` with:
- Question: "Are you ready to mark this Bee as done?"
- Options:
  - "Yes, mark as done"
  - "No, we have more work to do"

In no-questions mode these three questions become one stop. Output the ignored feedback and the Acceptance Criteria evidence and instructions. Rewrite the Bee's `## do-bee progress` section (as in 4.3 step 2) with `**Next**: User sign-off` and the ignored feedback under **Open decisions/questions**. Then end with `do-bee: needs input: act on any ignored feedback (list which), sign off the Acceptance Criteria, and mark Bee <bee-id> done? Reply "signed off" or say what to change.` If the answer asks for work, do it as in step 5 and come back here. If the User signs off, go to step 7.

### 7. Mark Bee Complete

Once the user approves the Bee as done:

1. Mark all Epics in the Bee as `status=done` — only once each has met the 4.2 gate:
```bees
update_ticket(ticket_id="<epic-id>", status="done")
```

2. Rewrite the Bee's `## do-bee progress` section once more (as in 4.3 step 2) as a short final summary: the Epics and their commits, the final review outcome (including any post-review integration result), and `**Next**: none — Bee done`.

3. Verify all Epics are now `done`, then mark the Bee itself:
```bees
update_ticket(ticket_id="<bee-id>", status="done")
```

### 8. Output Final Summary

```markdown
## Bee Execution Complete: [bee-title]

**Bee ID**: <bee-id>
**Epics Completed**: [count]
**Tasks Completed**: [count]
**Integration Suites**: [one line per Epic: <epic-id>: <result recorded in its body>; plus the post-review run's result from the Bee's `## do-bee progress` section, if one ran]
**Bee Status**: Done

All work has been synced to git.
```

### 9. Further testing and merging

Never tear down the worktree yourself: you run inside it.

- **In a worktree** (including the feature worktree of a `/run-lanes` run): tell the caller to do whatever further testing they want, then merge the branch and remove the worktree with `teardown_worktree` from outside it. Your final output ends with exactly this line:
  `do-bee: Bee <bee-id> finished on branch <branch>. Next: test it, then run /teardown_worktree <bee-id> from outside <worktree path>.`
  For a `/run-lanes` run, add ` --target <base>` after the Bee ID, with the base from the progress section's **Feature branch** line. Otherwise the target is the branch of the checkout teardown runs in. In no-questions mode, also add ` --no-questions`.
- **Not in a worktree**: the commits are already on the current branch; there is nothing to merge. End with `do-bee: Bee <bee-id> finished on branch <branch>.`
