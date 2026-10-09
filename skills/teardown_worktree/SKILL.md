---
name: teardown-worktree
description: Merge and clean up a git worktree created by configure_worktree
---

# Overview

Merge a worktree's branch into a target branch, stop the worker that `configure_worktree` launched in it, then remove the worktree and its branch.

Callers can also run it with no questions, leave the worker to the caller, and choose the branch to merge into. Orchestrator bots use these options.

**Important:** Run this skill from outside the worktree being torn down (the main repo, or any other checkout). Running it inside the worktree would remove the directory, and kill the session, it is running in. See step 1.

# Usage

**Invocation patterns**:
- `/teardown_worktree b.Yk9`
- "Tear down the worktree for b.Yk9"
- "Merge and clean up workspace for b.Yk9"
- `/teardown_worktree t1.abc --no-questions --worktree-only --target feature/b_xxx`

## Arguments

| Argument | Meaning | Default |
|----------|---------|---------|
| `<ticket_id>` | Ticket whose worktree to tear down. Required with `--no-questions`. | Ask, from `git worktree list` |
| `--no-questions` | Never use AskUserQuestion. All input comes from arguments. A dirty tree, a merge conflict or any failed check stops the skill with a clear error (see Failure report). | Off |
| `--worktree-only` | Merge and remove the worktree only; do not look for or stop a worker. The caller owns its worker and must end it first. | Off |
| `--target <branch>` | Branch to merge into, e.g. a feature branch for per-Epic lanes. | The branch of the checkout you run in |
| `--on-dirty commit\|discard\|fail` | What to do with uncommitted changes in the worktree. | Ask; with `--no-questions`, `fail` |

Arguments may also be given in plain words ("merge into feature/x", "commit anything left over"); treat them the same.

## Names

- `{normalized_id}`: the ticket ID with dots replaced by underscores (`b.Yk9` → `b_Yk9`). It names the worktree directory, its branch and the worker's tmux session.
- `{repo_root}`: `git rev-parse --show-toplevel` of the checkout you run in.
- `{worktree_path}`: the path `git worktree list` shows on branch `{normalized_id}` (normally `{repo_root}/../{normalized_id}`).

# Steps

## 0. Determine the worktree

If no ticket ID was given: with `--no-questions`, fail. Otherwise list worktrees with `git worktree list` and use AskUserQuestion to ask which one to tear down.

## 1. Check where you are running

```bash
git rev-parse --show-toplevel
```

If this is `{worktree_path}`, fail: "This skill must run from outside the worktree — teardown would remove the directory this session runs in. Run `/teardown_worktree {ticket_id}` from the main repo or another checkout."

## 2. Find the worktree and its worker

1. Confirm the worktree exists with `git worktree list --porcelain`: an entry with `branch refs/heads/{normalized_id}`. If there is none, fail (nothing to tear down).
2. Find live agent-director workers in it:
   ```bash
   agent-director list --cwd {worktree_path} --state pending,waiting,working,ask_user,check_permission
   ```
   - With `--worktree-only`: if any are live, fail. Removing the worktree would pull the directory out from under them; the caller must end its worker first.
   - Otherwise: the worker this skill stops is the row labelled `apiary_worktree={normalized_id}` (check its `labels`). If it is `pending` or `working`, it is still busy: with `--no-questions`, fail; otherwise use AskUserQuestion to confirm merging anyway. Live rows without the label are someone else's: fail, as in worktree-only mode. If no row is live, note "no live worker" and carry on.

## 3. Handle uncommitted changes in the worktree

```bash
git -C {worktree_path} status --porcelain
```

If there are uncommitted changes, pick an action: `--on-dirty`; else with `--no-questions`, `fail`; else show what changed and use AskUserQuestion: "The worktree has uncommitted changes. What should I do?" Options: "Commit them" / "Discard them" / "Abort".

- **commit**: commit inside the worktree. Exclude `auto_approve.sh` — it is gitignored and copied in by configure_worktree, not a source change.
  ```bash
  git -C {worktree_path} add -A -- ':!auto_approve.sh'
  git -C {worktree_path} commit -m "uncommitted changes from {ticket_id}"
  ```
- **discard**: `git -C {worktree_path} reset --hard HEAD`, then `git -C {worktree_path} clean -fd`.
- **fail** / **Abort**: stop, listing the changed files.

## 4. Find the merge target

1. **Target branch**: `--target`, else the branch of the checkout you run in (`git rev-parse --abbrev-ref HEAD`). It must not be `{normalized_id}`. If it is not a local branch (`git rev-parse --verify --quiet refs/heads/{target}`), fail.
2. **Target checkout**: a merge needs the target checked out. Find the checkout that has it in `git worktree list --porcelain` (`branch refs/heads/{target}`) and call its path `{target_checkout}`. Never check out a branch for the caller. If no checkout has it: with `--no-questions`, fail ("check out `{target}` in a worktree, then re-run"); otherwise use AskUserQuestion to offer checking it out in `{repo_root}` (only if `{repo_root}` has no uncommitted changes), else abort.
3. **Clean target**: `git -C {target_checkout} status --porcelain --untracked-files=no` must be empty. If not, fail, listing the files; this skill does not commit other people's work.
4. **Confirm** (interactive mode only; skip with `--no-questions`). Use AskUserQuestion:
   ```
   Merge {normalized_id} into {target}?

   Worktree: {worktree_path}
   Target:   {target} (checked out at {target_checkout})

   Proceed?
   ```
   Options: Yes / No / "No, let me specify a branch". For a different branch, repeat this step with it.

## 5. Merge

```bash
git -C {target_checkout} merge {normalized_id} --no-ff -m "Merge worktree {ticket_id} into {target}"
```

If the merge conflicts:
- List the conflicting files: `git -C {target_checkout} diff --name-only --diff-filter=U`.
- With `--no-questions`: run `git -C {target_checkout} merge --abort` and fail with the file list. The worktree, branch and worker are left untouched, so the caller can resolve the conflict in the worktree (e.g. by merging `{target}` into it) and re-run.
- Otherwise use AskUserQuestion: "Merge conflicts detected. What should I do?" Options: "Abort the merge" / "I'll resolve manually". If abort: `git -C {target_checkout} merge --abort` and stop, telling the user to resolve before re-running. If they resolve it, wait for them to confirm the merge is committed before continuing.

Record the merge commit: `git -C {target_checkout} rev-parse HEAD`.

## 6. Stop the worker

Skip with `--worktree-only`, or if step 2 found no live worker. Only after a successful merge:

```bash
agent-director kill --claude-instance-id {claude_instance_id}
```

If kill returns an error, fail with its `err_name` and `err_description`; do not remove the worktree under a worker that may still be running. The merge stays in place.

## 7. Remove the worktree and branch

```bash
git worktree remove {worktree_path} --force
```

Delete the branch. In interactive mode, first confirm with AskUserQuestion; with `--no-questions`, delete it without asking.

```bash
git branch -d {normalized_id}
```

If the delete fails as unmerged: with `--no-questions`, leave the branch and report it; otherwise warn the user and ask: "Force delete it" / "Leave the branch". Never force-delete without being told to.

## 8. Report

```
✅ Worktree torn down

Ticket:       {ticket_id}
Merged into:  {target} at {target_checkout} (merge commit {sha})
Worktree:     {worktree_path} (removed)
Branch:       {normalized_id} (deleted | kept: {reason})
Worker:       {claude_instance_id} (stopped) | none found | left to caller (worktree-only)
```

## Failure report

Whenever a step fails, stop and print:

```
❌ teardown_worktree failed for {ticket_id}

Step:    {step}
Reason:  {what went wrong, with the git or agent-director error, and the files involved}
State:   {what has and has not happened, e.g. "merge aborted; worktree, branch and worker untouched"}
Fix:     {what the caller should do before re-running}
```
