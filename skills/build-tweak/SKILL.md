---
name: build-tweak
description: "Build an approved Tweak in the worktrees the Managing Intelligence set up, with one engineer and one combined review, get its checks passing, commit it and hand it back for acceptance. Takes a Tweak ID."
---

# build-tweak

## Purpose

You build a Tweak, a minor feature with no PRD, SRD or Plan, in the worktrees the Managing Intelligence set up: one engineer writes its code, tests and docs, one reviewer checks the whole change, and you hand it back for the Managing Intelligence to accept against its description.

## Loading SDLC

Read `~/.sdlc/install/workflow.md` first for shared rules, settings and file locations.

## Input

A Tweak ID.

## Required Reading

- **Settings:** Project and defaults, for configuration.
- **Protocols:** your Agent Protocol File (`protocol:agent-claude-code.md`, `protocol:agent-codex.md` or `protocol:agent-cursor.md`), `protocol:launcher.md` and `protocol:ticket.md`, for operations.
- **Tweak and its Dependencies:** its `## Description`, for what changes and how we know it's done, its decisions and progress, and its `## Worktrees`, for where you work and any merge conflict recorded there.
- **Guidance:** `guide:engineering-best-practices.md`, `guide:test-guide.md`, `guide:doc-writing-guide.md`, `guide:build-commands.md` and `guide:release-guide.md` for implementation, review, checks and commits in each affected repo.

## Gate

Run only when all of these are true:

- The Tweak is `defined` or `active`, because the User's one approval stands in for a PRD, SRD and Plan. If it's `draft`, stop and suggest the Managing Intelligence get it approved. Otherwise, stop and report its status.
- Its `## Worktrees` records a worktree for each repo the change needs, because the Managing Intelligence sets them up. Otherwise, stop and ask the Managing Intelligence to set them up.
- Every ticket the Tweak depends on is `done`. Otherwise, stop and report the blocking ticket IDs.

## Steps

1. **Start or resume.** Set the Tweak `active`. If the Managing Intelligence has noted under `## Decisions` what's still wrong after an earlier build, fix that on top of the earlier commits. Resolve any merge conflict recorded in the Tweak's `## Worktrees` on the Tweak's branch, because the Managing Intelligence can't merge until it's gone. Before committing work left by an interrupted Run, have it reviewed.

2. **Build.** Have the `engineer` write the change with its tests and doc changes. Run `guide:build-commands.md ## Compile`, `## Lint` and `## Unit tests` yourself for every code folder the change touched, and send failures back to the engineer until they pass.

3. **Review.** Have `code-review` review the whole change: code, tests and docs. Return accepted findings to the engineer, rerun the checks they affect, then resume the reviewer to check only the fixes, because its first round covered the rest.

4. **Commit** in each worktree the change touched, once the checks pass and the reviewer accepts the fixes.

At any step, if the change needs a design decision or grows past one area, stop before committing and record why under `## Progress`, because it is no longer a Tweak and becomes an Idea.

## Child Agents

Start both fresh each Run and reuse them for its fix rounds, to preserve their knowledge.

- **`engineer`:** Expect the implementation, its tests and doc changes, targeted checks, deviations and anything suggesting the work isn't a Tweak.
- **`code-review`:** Expect findings on the whole change, as its only reviewer, and later a check of the fixes.

## Writes

The Tweak is the only ticket you change, and no Child Agent writes it, so its record has one writer. Leave it `active` for the Managing Intelligence to accept. Keep its `## Progress` (including the deviations and documentation effects the engineer reports), `## Checks` and `## Declined findings` current.

## Retrospective notes

While you work, note under `## Retrospective notes` on your ticket, with evidence, your answers to these questions, because the Managing Intelligence builds the ticket's retrospective from them:

- Where did we introduce a quality issue? How could it have been avoided?
- Where did we spend too much time and not gain value? How could it have been avoided?
- Where did we spend too many tokens and not gain value? How could it have been avoided?

## Done

Report the Tweak's ID, each worktree's path, branch and commit, the check results, and unaddressed findings with reasons.

- If the work stopped being a Tweak, say why and suggest the Managing Intelligence refile it as an Idea, as `~/.sdlc/install/workflow.md`'s Tweak flow describes.
- If you stopped before committing for another reason, say what you need, and suggest re-running build-tweak once it's settled.
- Otherwise, suggest the Managing Intelligence accept the change against its `## Description` in its worktrees, then merge it and remove the worktrees, or note what's still wrong under `## Decisions` and run build-tweak again.

## Handling Reviewer Feedback

For each finding from code-review:

- **Fix it:** return it to the engineer.
- **Decline it:** use your judgement to decline findings that are minor or trivial, and record each one with its reason under `## Declined findings` and in the Done report.
- **Ask the Managing Intelligence:** for expected behaviour, or conflicts with the Tweak and its decisions, because those are theirs to decide.

If fixes stop making progress, stop for the Managing Intelligence, so a fix loop doesn't burn the budget.
