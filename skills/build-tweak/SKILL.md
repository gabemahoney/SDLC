---
name: build-tweak
description: "Build an approved Tweak in its worktrees with one engineer and one combined review, commit it and hand it back for acceptance. Takes one or more Tweak IDs."
---

# build-tweak

## Purpose

You build a Tweak in the worktrees the Managing Intelligence set up, with one engineer and one reviewer, and hand it back to be accepted against its description.

## Loading SDLC

Read `~/.sdlc/install/workflow.md` first for shared rules, settings and file locations, and its Tweak flow for your place in it.

## Input

A Tweak ID, or several as `~/.sdlc/install/workflow.md`'s Bundles rule describes; then each must pass the Gate, and every step and record covers each Tweak.

## Required Reading

- **Settings and protocols:** Project and default settings, your Agent Protocol File (`protocol:agent-claude-code.md`, `protocol:agent-codex.md` or `protocol:agent-cursor.md`), `protocol:launcher.md` and `protocol:ticket.md`, for configuration and operations.
- **The Tweak and its Dependencies:** its `## Description` (what changes and how we know it's done), `## Decisions`, `## Progress` and `## Worktrees`. Its `thinking_level` tag, the highest in a bundle, is the level you launch `engineer` at; without one, use the skill's fixed level.
- **Guidance:** `guide:engineering-best-practices.md`, `guide:test-guide.md`, `guide:doc-writing-guide.md`, `guide:build-commands.md` and `guide:release-guide.md`, for the work, checks and commits in each repo.

## Gate

Run only when the Tweak carries the Tweak mark (`protocol:ticket.md`) and is `defined` or `active`, its `## Worktrees` records its worktrees, or `none` when it changes no repo, and every ticket it depends on is `done`, because approval, worktree setup and prerequisites come first. Otherwise, change nothing and report what's missing.

## Steps

1. **Start or resume.** Set the Tweak `active`. Build on earlier commits, fixing anything noted under `## Decisions` and any merge conflict recorded under `## Worktrees`, and have work left by an interrupted Run reviewed before committing it.
2. **Build.** Have the `engineer` write the change with its tests and docs. Run `guide:build-commands.md ## Compile`, `## Lint` and `## Unit tests` yourself, as `~/.sdlc/install/workflow.md`'s Checks rule says, until they pass.
3. **Review.** Take any proposal, as `~/.sdlc/install/workflow.md`'s Proposals rule says, then have `code-review` review the whole change: code, tests and docs. Handle its findings as `~/.sdlc/install/workflow.md`'s Review findings rule says: the engineer fixes accepted ones, you rerun the affected checks, and after blocker or suggestion repairs the same reviewer checks only the fixes. If fixes stop making progress, stop for the Managing Intelligence.
4. **Commit** in each worktree the change touched.

At any step, if the change needs a design decision or grows past one area, stop before committing and record why under `## Progress`, because it becomes an Idea. If it needs a repo with no recorded worktree, ask the Managing Intelligence to add one, because it sets up the Tweak's worktrees.

## Child Agents

Start both fresh each Run and reuse them for its fix rounds, so they keep their knowledge.

- **`engineer`:** Expect the change, its tests and docs, deviations, and any sign the work isn't a Tweak.
- **`code-review`:** Expect findings on the whole change, then a check of the fixes.

## Writes

No Child Agent writes the Tweak, because you record what they report. Keep its `## Progress`, `## Checks` and `## Declined findings` current, and answer `~/.sdlc/install/workflow.md`'s retrospective questions with evidence under `## Retrospective notes`, because the Managing Intelligence builds the retrospective from them.

## Done

Report each Tweak's ID, each worktree's path, branch and commit, the check results and declined findings with reasons. Suggest the Managing Intelligence's next step in the Tweak flow: acceptance and merge, refiling as an Idea if it outgrew a Tweak, or settling what stopped you.
