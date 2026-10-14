---
name: configure-worktree
description: Create an isolated git worktree for a Bee and optionally launch a tracked agent worker (Claude Code or Codex CLI) in it via agent-director
---

# Overview

Create a git worktree for a bee ticket, then (by default) launch an agent worker in it (Claude Code or Codex CLI) through agent-director, so it can work on the ticket on its own.

Callers can also run it with no questions, create only the worktree and leave the worker to the caller, and choose the branch the worktree starts from. Orchestrator bots use these options.

Worker mode needs agent-director 0.12.0 or later (`agent-director version`); 0.11.x and earlier refuse its flags. Worktree-only mode does not use agent-director.

In Codex CLI, which has no AskUserQuestion, ask each question in plain text in your reply and end your turn.

# Usage

**Invocation patterns**:
- `/configure_worktree b.xxx`
- "Launch async session for b.yyy"
- "Make a workspace for b.xxx"
- `/configure_worktree t1.abc --no-questions --worktree-only --base feature/b_xxx`

## Arguments

| Argument | Meaning | Default |
|----------|---------|---------|
| `<ticket_id>` | Bee or child-tier ticket the worktree is for. Required with `--no-questions`. | Ask (or suggest one from context) |
| `--no-questions` | Never use AskUserQuestion. All input comes from arguments. Any missing input or failed check stops the skill with a clear error (see Failure report). | Off |
| `--worktree-only` | Create (or reuse) the worktree and stop. Do not launch a worker. The caller launches its own (e.g. with `agent-director spawn --cwd {worktree_path} --agent claude`). | Off |
| `--base <ref>` | Branch (or other commit-ish) the new worktree branch starts from, e.g. a feature branch for per-Epic lanes. | `HEAD` of the checkout you run in |
| `--prompt "<text>"` | Prompt sent to the worker. Spawn mode only. Required in spawn mode with `--no-questions`. | Ask |
| `--template <name>` | agent-director template for the worker (e.g. `WORKER`). Spawn mode only. | None |
| `--agent <claude\|codex>` | The worker's agent: Claude Code or Codex CLI. Spawn mode only. | With `--template`, the template's agent; otherwise the agent you run in |
| `--model <model>` | Model for the worker. Spawn mode only. Ignored when `--template` is given — the template sets the model. | Ask (Claude: Opus or Sonnet; Codex: a Codex model name or Codex's default); with `--no-questions`, the agent's default |

Arguments may also be given in plain words ("worktree only", "base it on feature/x"); treat them the same.

## Names

- `{normalized_id}`: the ticket ID with dots replaced by underscores (`b.xxx` → `b_xxx`, `t1.abc` → `t1_abc`). It names the worktree directory, its branch and the worker's tmux session.
- `{repo_root}`: `git rev-parse --show-toplevel` of the checkout you run in.
- `{worktree_path}`: `{repo_root}/../{normalized_id}`.

# Steps

## 1. Fetch the ticket

If no ticket ID was given: with `--no-questions`, fail. Otherwise check your context for a likely bee, suggest it, or ask for one.

```bash
bees show-ticket --ids {ticket_id}
```

If the ticket is not found, fail. Otherwise show the ticket's title, status, labels, children and dependencies. With `--no-questions`, keep this to one line (ID, title, status).

## 2. Check the environment

1. **Existing worktree.** Check `git worktree list` for `{worktree_path}`.
   - If it exists and is on branch `{normalized_id}`, reuse it: skip steps 3–5 and say it was reused. If `--base` was given, say it was not applied because the worktree already existed.
   - If it exists on a different branch, or `{worktree_path}` exists but is not a worktree, fail.
2. **Existing branch.** If there is no worktree but branch `{normalized_id}` already exists (`git rev-parse --verify --quiet refs/heads/{normalized_id}`), fail: an earlier worktree's branch was left behind. Name it in the error so the caller can merge or delete it.
3. **Base.** Resolve the base: `git rev-parse --verify --quiet {base}^{commit}`. If it does not resolve, fail. Record the base commit SHA for the report.

## 3. Confirm (interactive mode only)

Skip with `--no-questions`. Otherwise use AskUserQuestion:

```
Set up a worktree for {ticket_id}?

This will create:
- Worktree {worktree_path}
- Branch {normalized_id}, starting from {base} ({base_sha})

Proceed?
```

Options: Yes / No. If No, abort.

## 4. Check for uncommitted changes

Only when the base is the checkout's own `HEAD` (no `--base`, or `--base` naming the branch you are on): uncommitted changes there would be left out of the worktree.

```bash
git status --porcelain
```

If there are uncommitted changes:
- With `--no-questions`: fail, listing the changed files. Do not commit them.
- Otherwise show what changed and use AskUserQuestion: "This checkout has uncommitted changes that the worktree will not include. Should I commit them first?" Options: "Yes, commit them" / "No, abort". If yes, commit with a descriptive message, then re-resolve `{base_sha}`.

## 5. Create the worktree

```bash
git worktree add -b {normalized_id} {worktree_path} {base}
```

If `auto_approve.sh` (gitignored) exists in `{repo_root}`, copy it into the worktree. `docker/` and `.claude/` are tracked and already present.

```bash
cp {repo_root}/auto_approve.sh {worktree_path}/auto_approve.sh
```

## 6. Stop here in worktree-only mode

With `--worktree-only`, skip to step 8.

## 7. Launch the worker via agent-director

1. **Gather inputs.** Prompt: from `--prompt`, else (interactive) AskUserQuestion for the full instruction to give the worker — a skill invocation, a task description or any valid prompt. Model: from `--model`, else (interactive, no `--template`) ask: Opus or Sonnet for a Claude worker; a Codex model name (e.g. `gpt-6-astra`) or Codex's default for a Codex worker. With `--no-questions` and no `--prompt`, fail before spawning.
2. **Pick the agent.** `--agent {agent}` when given. Otherwise, with `--template`, pass no `--agent`: the template names its agent (agent-director 0.12.0's installer set existing templates, such as `WORKER`, to `agent = "claude"`). Otherwise pass `--agent claude` when you run in Claude Code, `--agent codex` when you run in Codex CLI. A Codex worker commits into the main checkout's git metadata, so it needs full access (e.g. `--sandbox danger-full-access` in its template's agent args or the user's Codex config).
3. **Spawn.** The tmux session name and the `apiary_worktree` label let `teardown_worktree` find this worker later:
   ```bash
   agent-director spawn --cwd {worktree_path} --tmux-session-name {normalized_id} --label apiary_worktree={normalized_id} [--agent {agent}] [--template {template}] [-- --model {model}]
   ```
   Pass `-- --model {model}` only without `--template` (agent args given on the command line replace the template's). Never pass the prompt after `--`. Record `instance_id` from the JSON output. If the template chose the agent, read it from `agent-director get --instance-id {instance_id}` (its `agent`). On an error, report its `err_name` and `err_description` and fail; the worktree stays in place.
4. **Send the prompt.**
   - **Claude worker.** Wait until `agent-director status --instance-id {instance_id}` reports `waiting` (check every few seconds, up to about 2 minutes; `pending` means it is still starting). Then:
     ```bash
     agent-director send-keys --instance-id {instance_id} --text "{prompt}"
     ```
     If it never reaches `waiting`, report the last state and fail; the worker and worktree stay in place.
   - **Codex worker.** Its row stays `pending` until its first prompt. Wait until `agent-director read-pane --instance-id {instance_id}` shows Codex's input box ready for typing, with no startup or trust dialog (check every few seconds, up to about 2 minutes). A prompt that starts with a skill invocation `/<skill>` is sent as `$<skill>`: Codex invokes skills with `$`. Then:
     ```bash
     agent-director send-keys --instance-id {instance_id} --allow-pending --text "{prompt}"
     ```
     Then check that `agent-director status --instance-id {instance_id}` leaves `pending` (for `working` or `waiting`) within about a minute. If it is still `pending`, read the pane once: if the prompt text still sits in Codex's input box (e.g. the `$` skill popup took the Enter), press Enter once more with `agent-director send-keys --instance-id {instance_id} --allow-pending` (no text) and check the status again. If the input box never shows, or the row stays `pending`, report the last state and pane and fail; the worker and worktree stay in place.

## 8. Report

```
✅ Worktree ready

Ticket:      {ticket_id}
Worktree:    {worktree_path} (created | reused)
Branch:      {normalized_id}
Base:        {base} ({base_sha})
Worker:      {instance_id} ({agent}), tmux session {normalized_id} | none (worktree-only)
Prompt:      {prompt} | n/a
```

With a worker, add: `To watch: agent-director read-pane --instance-id {instance_id}`.

## Failure report

Whenever a step fails, stop and print:

```
❌ configure_worktree failed for {ticket_id}

Step:    {step}
Reason:  {what went wrong, with the git or agent-director error}
State:   {what exists now, e.g. "nothing created" or "worktree {worktree_path} created, no worker"}
Fix:     {what the caller should do before re-running}
```

Never undo a worktree or worker that was already created; report it in `State`.
