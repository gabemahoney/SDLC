---
name: run-lanes
description: Run a Bee's Epics in parallel Epic lanes — pick the Epics that touch different files, give each its own worktree, branch and do-bee worker, then merge the lanes one at a time into the Bee's feature branch with a retest after each merge. Never asks questions; stops and reports instead.
---

## Overview

`/do-bee` builds one Epic at a time on one branch. `/run-lanes` builds a Bee's Epics side by side instead, and owns the whole parallel run:

1. Decides which Epics can run at the same time: they are ready and touch different files.
2. Gives each one an **Epic lane**: its own worktree and branch, started from the Bee's **feature branch**, with a `/do-bee <epic-id> --lane` worker in it.
3. Merges finished lanes back into the feature branch **one at a time**, and retests the feature branch after each merge.
4. Stops and reports on a merge conflict, a failing retest or anything else it cannot settle. It never uses AskUserQuestion and never waits for an answer.

Before any of this, every pass checks that the User approved the Bee's PRD (Approval guard), and stops if not.

One invocation is one pass: it merges every lane that is ready, starts every lane that can start, records the state on the Bee and stops. Whoever drives it (an orchestrator, a `/loop`, or a person) runs `/run-lanes <bee-id>` again whenever a lane worker finishes. Each pass rebuilds its picture from the ticket store, git and agent-director, so passes can run in fresh sessions.

"Epic lane" here is unrelated to the Test Writer lanes inside a Task (do-bee step 3).

## Usage

- `/run-lanes b.xxx`
- `/run-lanes b.xxx --base main --template WORKER --max-lanes 3`
- `/run-lanes b.xxx --worktree-only` (the caller launches the lane workers)

| Argument | Meaning | Default |
|----------|---------|---------|
| `<bee-id>` | The Bee whose Epics to run. Required. | — |
| `--base <branch>` | Branch the feature branch starts from. Used only on the first pass, when the feature branch is created. | Branch of the checkout you run in |
| `--worktree-only` | Create and merge lane worktrees, but do not launch or stop lane workers. The pass lists each new lane's worktree and prompt for the caller to launch, and the caller must end a lane's worker before the pass that merges it. | Off: lane workers are launched through `configure_worktree` and stopped by `teardown_worktree` |
| `--template <name>` | agent-director template for lane workers (e.g. `WORKER`). | None |
| `--max-lanes <n>` | Most Epic lanes running at once. | No limit |
| `--waive-retest <epic-id>` | Accept a failing post-merge retest for that merge (step 4) and carry on. Only the driver passes this, on the User's say-so. | — |

Run it from the main repo or from the feature worktree, never from inside an Epic lane's worktree.

## Names

- `{bee_branch}`: the Bee ID normalized (dots to underscores, `b.xxx` → `b_xxx`). This is the **feature branch**; its worktree `{feature_path}` is `{repo_root}/../{bee_branch}`, created by `configure_worktree`.
- `{epic_branch}`: an Epic ID normalized (`t1.xxx.ab` → `t1_xxx_ab`). This is the Epic lane's branch; its worktree `{lane_path}` is `{repo_root}/../{epic_branch}`.
- **Done Epic**: an Epic whose body has an `**Integration Suites**:` result line (it met do-bee's 4.2 gate), or whose status is `done`.
- **Merged Epic**: a done Epic listed under **Epics done** in the Bee's progress section with a merge commit, or `done`.

## Progress section

`/run-lanes` keeps its state in the Bee's `## do-bee progress` section, the same section `/do-bee` resumes from, extended with a **Lanes** line. `/run-lanes` is the section's only writer during a lane run: lane workers never edit the Bee body. Rewrite the section in full each time, editing only that section, exactly as do-bee 4.3 step 2 describes.

```markdown
## do-bee progress

**Feature branch**: <bee_branch> at <feature_path>, from <base> (<base_sha>)
**Epics done**:
- <epic-id> <epic-title>: merged into <bee_branch> at <merge_sha>; status `<status>`; Integration Suites: <lane result>; Post-merge retest: <passed | passed after fixing: <summary> | no integration suite found, unit suite passed | failed: <result> | waived by User: <last result>>
**Lanes**:
- <epic-id>: <lane_path> (branch <epic_branch>); worker <claude_instance_id> | caller's worker; <running | done, waiting to merge | blocked: <reason>>
**Next**: run-lanes | all Epics done; next: final Bee review
**Open decisions/questions**: <list, or "None">
**Notes for the next session**: <only what the ticket store and git do not already hold, or "None">
```

`**Lanes**: none` once no lane is open.

## Steps

### Approval guard

Run this first in every pass, before step 1: no worktree, merge, lane, dispatch or ticket change comes before it.

A Bee is built only once the User has approved its Idea's PRD. Read tickets with `bees show-ticket --ids <id>`.

1. Plan Bee: the `<bee-id>` given.
2. Idea Bee: the Ideas-hive Bee named in the Plan Bee's `reference_materials` (its `bees` entry) or `up_dependencies`. `bees execute-freeform-query --query-yaml "stages: [[id=<id>, hive=ideas]]"` returns a ticket only if it is in the Ideas hive. If there is more than one, check each.
3. PRD: the Idea Bee's t1 child titled `PRD`.
4. The PRD's `tags` must include `approved:yes`.

If any step fails, stop at once: change no ticket, write no progress section, start or merge no lane, and skip the step 7 report. End your output with exactly one of these lines:
- `run-lanes: needs input: <prd-id> lacks approved:yes — the User must approve it`
- `run-lanes: needs input: no <Idea Bee | PRD> found for <ticket-id> — cannot check approved:yes`

This skill never adds `approved:yes`. Only the User approves.

### 1. Validate the Bee

```bash
bees show-ticket --ids {bee_id}
```

Apply do-bee step 1's checks: the Bee is `defined` or `active`, its `up_dependencies` are `defined` or later, and no child Epic is `draft` (if one is, stop: hatching is incomplete). Load every Epic, and every Task and Subtask under it.

### 2. Make sure the feature branch exists

```
/configure_worktree {bee_id} --no-questions --worktree-only --base {base}
```

On the first pass this creates `{feature_path}` on branch `{bee_branch}` from `{base}`; later passes reuse it. If it fails, stop and pass on its failure report. On the first pass, write the progress section with the **Feature branch** line.

### 3. Rebuild the current state

Read, and trust in this order: the ticket store, git, agent-director, then the progress section.

- Epic statuses, and which Epics are done.
- Open lanes: `git worktree list --porcelain` entries on an `{epic_branch}` of this Bee's Epics.
- Lane workers: `agent-director list --label apiary_worktree={epic_branch}` for each open lane (skip with `--worktree-only`).
- The progress section's **Epics done** and **Lanes** lines. Where they disagree with the sources above, the sources win; fix the section at step 7.

If the last merged Epic's **Post-merge retest** is `failed`, re-run step 4.3 for it first (or record the waiver, with `--waive-retest <epic-id>`). Do not merge or start anything while a retest is failing.

### 4. Merge finished lanes, one at a time

Take the open lanes whose Epic is done, in the Bee's Epic order. For each lane, finish all three parts before starting the next lane:

1. **Check the worker.** It must be idle (`waiting`) or gone. If it is still `pending` or `working`, leave the lane for a later pass. With `--worktree-only`, the caller must have ended it. `teardown_worktree` refuses a live worker in its worktree, and its failure stops this pass.
2. **Merge.**
   ```
   /teardown_worktree {epic_id} --no-questions --target {bee_branch} --on-dirty fail [--worktree-only]
   ```
   On a conflict, `teardown_worktree` aborts the merge and leaves the lane as it was. Stop this pass and report the conflicting files, plus the fix: in `{lane_path}`, merge `{bee_branch}`, resolve the conflicts and commit, then re-run `/run-lanes {bee_id}`. Any other teardown failure stops the pass the same way, with its failure report.
3. **Retest the feature branch.** The lanes were tested apart; this checks that they work together. Run do-bee's integration loop (do-bee 4.2 steps 1–3) in `{feature_path}`, with these changes:
   - Dispatch one `apiary-test-writer` as the **post-merge Test Writer**, naming the Bee ID, the merged Epic ID and `{feature_path}`. Its prompt says it owns the full unit-suite run: it runs the full unit suite and fixes test-side failures, then runs the integration suites as the integration Test Writer, and reports one integration result, plus the unit-suite result.
   - On `source failures` (unit or integration), dispatch `apiary-engineer` in `{feature_path}` with the failures, then re-dispatch the post-merge Test Writer with the Engineer's report threaded in. Stop after 3 Engineer rounds, or sooner if a round does not reduce the failures.
   - Where do-bee would ask the caller, stop this pass and report instead. `could not run` stops at once.
   - Commit any changes the loop made inside `{feature_path}` (`git -C {feature_path} ...`), with a message naming the merged Epic. **Never push.**
   - **Gate**: the retest passes when its last run reported `passed` (or `passed after fixing`), or `no integration suite found` with the unit suite passing, or the driver passed `--waive-retest {epic_id}`. Until then do not merge the next lane or start new ones.
4. **Record it.** Move the Epic from **Lanes** to **Epics done** with its merge commit and retest result, and write the section (as in Progress section), before the next lane.

A lane whose Epic is not done but whose worker is idle or gone has stopped early, usually to ask something (its last output is a `do-bee: needs input:` line; check with `agent-director read-pane --claude-instance-id {id}`). Do not merge it. Mark it `blocked:` with the question or reason, and put it in the report. The driver answers the worker in its session, or re-launches it.

### 5. Start new lanes

An Epic can start a lane when all of these hold:
- It is `defined` or `active`, not done, and has no open lane.
- Every Epic in its `up_dependencies` is merged. Merged, not just done: the lane starts from `{bee_branch}` and needs that work in it.
- Its **file set** does not overlap with that of any open lane, or of any other Epic starting in this pass.

An Epic's file set is every path in the `## Key Files` sections of its Subtasks. Treat a directory as every file under it. If any Subtask has no `## Key Files` section, or lists something that is not a path (a glob, "TBD", "various"), the Epic's file set is "everything": it runs alone, only when no other lane is open, and nothing else starts beside it.

Go through the Epics in the Bee's order and start each one that qualifies, up to `--max-lanes` open lanes. If no lane is open and no Epic qualifies, the Bee is either finished (every Epic merged) or stuck. When stuck, report why: for example, an Epic depends on one that is not done, or is blocked outside this Bee.

To start a lane:

```
/configure_worktree {epic_id} --no-questions --base {bee_branch} --prompt "/do-bee {epic_id} --lane" [--template {template}] [--worktree-only]
```

With `--worktree-only`, `configure_worktree` creates the worktree only; list the lane's `{lane_path}` and prompt in the report so the caller can launch the worker. Otherwise it launches the worker through agent-director; record its `claude_instance_id`. If `configure_worktree` fails, stop and pass on its failure report. Lanes already started stay open and appear in the section.

### 6. All Epics merged

When every Epic is merged and no lane is open, set **Next** to `all Epics done; next: final Bee review`. The final Bee review, sign-off and teardown run through `/do-bee {bee_id}` in `{feature_path}` (do-bee steps 5–9), which resumes from this section.

### 7. Write the section and report

Rewrite the progress section (see Progress section), then output:

```
## run-lanes pass: <bee-title>

**Bee ID**: <bee-id>
**Feature branch**: <bee_branch> at <feature_path>
**Merged this pass**: <epic-id>: merge <sha>, retest <result> — one per line, or "None"
**Started this pass**: <epic-id>: <lane_path>, worker <id> | prompt for the caller: /do-bee <epic-id> --lane — one per line, or "None"
**Still running**: <epic-ids, or "None">
**Blocked**: <epic-id>: <reason or question> — one per line, or "None"
**Not started**: <epic-id>: <why: waiting on <dependency>, files overlap with <epic-id>, lane limit> — one per line, or "None"
```

End with exactly one of these lines:
- `run-lanes: <n> lanes open (<epic-ids>). Next: run /run-lanes <bee-id> again when a lane worker finishes.`
- `run-lanes: all Epics merged into <bee_branch>. Next: run /do-bee <bee-id> in <feature_path> for the final Bee review.`
- `run-lanes: stopped — <one-line reason>. Fix it, then run /run-lanes <bee-id> again.` (for a conflict, a failing retest, a failed worktree step, or a stuck Bee)

A pass refused by the Approval guard writes no report and ends with the guard's `run-lanes: needs input:` line instead.

## Rules

- **No questions.** Never use AskUserQuestion. Anything that needs a decision stops the pass with a report.
- **One merge at a time.** Merge, retest, record — then the next lane.
- **Never push.** All merges and commits are local.
- **Delegate discipline.** Do not do role work yourself. The post-merge Test Writer and Engineer are subagents (Agent tool, background dispatch, cold start — as in do-bee's Execution model); Epic lanes are separate do-bee sessions.
- **Never resolve a merge conflict yourself.** Report it.
- **Use the worktree skills.** Invoke `configure_worktree` and `teardown_worktree` with the Skill tool, always with `--no-questions`. Do not run their git and agent-director steps by hand.
