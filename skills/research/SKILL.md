---
name: research
description: Track a research task as a Research Bee — file it, run its review rounds, and complete it with a cited Report and an LLM wiki update. Does not define how the research is done.
---

# Overview

Research tasks live as Bees in the Research hive. This skill moves a Research Bee through its states and keeps its record: the question, a Report child holding the findings, research artifacts in the Bee's folder, and a log of review rounds.

This skill does **not** define how the research is done. Follow the research guide below where it specifies methods; otherwise use whatever methods the question, the requester and the reviewer call for.

## Arguments

| Form | Meaning |
|---|---|
| `/research "<question>"` | File a new Research Bee for the question, then start work on it. |
| `/research <bee-id>` | Continue an existing Research Bee from its current state. Any text after the ID is the reviewer's verdict or request for the latest round (e.g. `/research b.xxx accept`). |
| `--no-questions` | Never use AskUserQuestion (see No-questions mode). |

**No-questions mode**: on when you are given `--no-questions`, or when you run as an agent-director worker (`AGENT_DIRECTOR_INSTANCE_ID` is set in your environment; such workers usually cannot use AskUserQuestion). In this mode never use AskUserQuestion. Wherever this skill asks the reviewer or the caller, stop instead: put what you know in your output, end it with exactly one `research: needs review:` or `research: needs input:` line as given in the steps, and end your turn. The driver answers in this session, or starts a fresh session and gives the answer after the ID (e.g. `/research b.xxx accept`).

In Codex CLI, which has no AskUserQuestion, ask in plain text in your reply and end your turn.

## Location and guide

Before filing or continuing a Bee:
1. Read `research_location` from `<Project Folder>/.apiary/project_settings.md`. If it is unset or the file is absent, read it from `~/.apiary/default_project_settings.md`.
2. If set, use that path as the Research hive itself (the bees hive at that location), for the Bee, Report and artifacts. Ensure bees operations address that hive, not a different project's Research hive. If unset in both files, keep the existing lookup: use the Research hive path from `bees list-hives`.
3. Read `<Project Folder>/.apiary/research-guide.md`, or, if absent, `~/.apiary/research-guide.md`. Follow the selected guide for research methods, the Report's shape where specified, and required extra outputs after acceptance. If neither exists, use this skill's defaults.

## Prerequisites

The Research hive must exist with:
- Child tiers: t1 — Report / Reports
- Status values: `draft`, `defined`, `active`, `done` (the same four as every Apiary hive)

If it is missing or configured differently (e.g. it still has an old value: `new`, `completed`, `larva`, `pupa`, `worker` or `finished`), tell the user to run `/apiary-setup`, which migrates the hive, and stop. Do not create or reconfigure the hive yourself.

## States

| Status | Meaning | Next |
|---|---|---|
| `defined` | Filed with its question, ready to work. A question is ready as soon as it is written, so a Research Bee is never `draft`. | `active` when work starts |
| `active` | Work in review rounds: findings are presented, the reviewer accepts or asks for more. | `done` when the reviewer accepts |
| `done` | Accepted. The Bee and its Report are kept as the record. | `active` only if a reviewer asks for more work |

The Report child uses the same status values: `active` while the Bee is `active`, `done` when the Bee is.

**Accepted research is never archived.** Never run `bees undertaker` on the Research hive, and never give it an `undertaker_schedule` in `~/.bees/config.json`. The undertaker only touches the hive it is pointed at, so sweeping other hives is safe. Research uses `done` like every other hive, so check which hive a sweep is pointed at.

## The reviewer

The reviewer is the User or an orchestrator Claude. When an orchestrator drives this skill, it decides for each round whether it reviews the round itself or sends it to the User. This skill does not choose the reviewer: it presents the round, records who gave the verdict and what it was, and acts on it.

## The Research Bee

Body sections:

```markdown
## Question
<the question, in the requester's words where possible>

## Scope
<who asked, why, constraints, what is out of scope; "none given" if none>

## Review rounds
### Round 1 — <YYYY-MM-DD>
**Presented**: <what was found or changed this round, 2–5 lines>
**Reviewer**: <User | orchestrator>
**Verdict**: <accepted | more work: <the request, verbatim>>
```

A round with no **Reviewer**/**Verdict** lines is awaiting review.

## Bee folder and artifacts

- The Bee's folder is `<research hive path>/<bee-id>/` (hive path resolved under Location and guide). The Report lives in `<bee-id>/<report-id>/`.
- Put research artifacts (data, scripts, logs, screenshots, notes, excerpts) in `<research hive path>/<bee-id>/artifacts/`.
- **An artifact must never look like a ticket**, because bees reads anything that looks like one as a ticket, and in the shared Research hive that breaks every bot's bees:
  - Never save a folder that holds a `.md` file of the same name (`x/x.md`). This includes copied repo files such as `workflow/workflow.md`.
  - Never save a `.md` file with ticket frontmatter.
  - Never name a folder like a ticket ID (`b.xxx`, `t1.xxx`).
  - Save snapshots of other files as `.txt` (e.g. `workflow.md.txt`) or as an archive (`.tgz`).
  - Before finishing a round, check the `artifacts/` folder for any of these and fix them.
- Keep secrets and tokens out of artifacts.

## The Report

One t1 child of the Bee, titled `Report: <Bee title>`. Its body is a well-written, standalone document a reader can use without the Bee or the conversation. Use the guide's Report shape where specified; otherwise use:

1. **Summary** — the answer first, in a few lines.
2. **Findings** — organised by theme or sub-question, with evidence.
3. **Limitations** — what was not checked, uncertainty, open questions.
4. **Conclusions / recommendations** — if the question calls for them.
5. **References** — a numbered list. Every claim that is not common knowledge carries an inline `[n]` citation pointing here. Each entry names its source precisely: URL with access date, `path:line` or commit SHA, ticket ID, Slack permalink, or document title and section.
6. **Artifacts** — each artifact linked by relative path from the Report's folder, `../artifacts/<file>`, with one line on what it is. Link artifacts from the text where they back a finding.

Put bulky raw material in artifacts, not in the Report body.

## LLM wiki

After acceptance, update the wiki in step 6 on every accepted round, including revisions. Use `~/research/wiki/` unless the research guide names another folder; follow the guide's different or extra output requirements as well. This follows [Karpathy's LLM wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f).

- For a new wiki, create `raw/` for preserved source material, kept unchanged; `pages/` for linked Markdown source summaries, topic and entity pages, comparisons and conclusions; `AGENTS.md` for structure and maintenance rules; `index.md` linking every page with a one-line description; and an append-only dated `log.md`.
- Read `AGENTS.md` and `index.md` first. Integrate accepted findings into existing or new pages and cross-link related pages. Cite the sources and the accepted Report. Mark conflicting evidence and superseded claims on the page instead of silently overwriting them.
- Update `index.md` and append a dated `log.md` entry naming the Research ticket, the Report and the pages changed.
- Lint the pages touched for broken links, orphan pages, stale claims and unresolved contradictions; fix them. Where evidence cannot settle a contradiction, state it explicitly with its sources.
- Record the updated paths and completion on the Research Bee. If the update cannot be finished, record what remains and why. Acceptance stands either way: keep the Bee and Report `done`.

## Steps

### 1. File (`defined`)

For `/research "<question>"`:
1. Create a Bee in the Research hive with a short title, status `defined`, and the Question and Scope sections (Review rounds empty).
2. Go to step 2, unless the caller asked only to file it; then report the Bee ID and stop.

### 2. Start (`defined` → `active`)

1. Set the Bee to `active`.
2. Create the Report child (t1), status `active`, with a placeholder body.
3. Create the `artifacts/` folder if this research will have artifacts.

### 3. Work round

1. Do the research for this round: the Question on the first round, the reviewer's latest request on later rounds.
2. Save artifacts and update the Report body so it reflects all findings so far, not just this round's.
3. Append `### Round N — <date>` with its **Presented** line to the Bee's Review rounds.

### 4. Present

Show the reviewer: the Bee ID, the round's **Presented** summary, the Report ID, and the paths to the Report file and `artifacts/`. Ask them to accept or say what more to do.
- Interactive: ask with AskUserQuestion (options: Accept / More work).
- No-questions mode: end with `research: needs review: <bee-id> round <N> — reply "accept" or say what more to do`.

### 5. Record the verdict

Add **Reviewer** and **Verdict** to the round. Record the request verbatim.
- More work → step 3 with the request.
- Accepted → step 6.

### 6. Complete (`active` → `done`)

1. Check the Report meets the guide's requirements and the defaults above where the guide does not specify them.
2. Set the Report and the Bee to `done`.
3. Update the LLM wiki as above and do every extra output the guide requires, on each accepted round, including accepted revisions. Before starting, record the accepted round and required outputs on the Bee; then record what was updated, including paths and completion for each output. If an output cannot be completed, record what remains and why on the Bee. Acceptance stands: keep the Bee and Report `done`.
4. Report the Bee ID, the Report ID, the one-line answer, and any extra outputs completed or left unfinished.

### Continuing a Bee (`/research <bee-id>`)

Read the Bee and its Report, then by status:
- `defined` → step 2.
- `active`, latest round awaiting review → with a verdict given after the ID, step 5; otherwise step 4 (present it again).
- `active`, latest verdict is more work → step 3.
- `done` → check the latest accepted round's wiki update and extra outputs against this skill, the guide and the Bee's record; resume any required outputs not recorded as complete via step 6.3, keeping the Bee and Report `done`. Report that it is done, with the Report ID and any unfinished outputs. Reopen it only if a reviewer asks for more research work now: set the Bee and Report to `active`, start a new round with that request as its input, and go to step 3. If it is unclear whether they want it reopened, ask (no-questions mode: `research: needs input: <bee-id> is done — reopen it for more work? Say what to do`).
- Any other status → stop and report it; do not guess. An old value (`new`, `completed`, `larva`, `pupa`, `worker` or `finished`) means the hive needs `/apiary-setup` to migrate it.
