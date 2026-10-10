---
name: research
description: Track a research task as a Research Bee — file it, run its review rounds, and complete it with a cited Report. Defines only the ticket state flow, not how the research is done.
---

# Overview

Research tasks live as Bees in the Research hive. This skill moves a Research Bee through its states and keeps its record: the question, a Report child holding the findings, research artifacts in the Bee's folder, and a log of review rounds.

This skill does **not** define how the research is done. Use whatever methods the question, the requester and the reviewer call for.

## Arguments

| Form | Meaning |
|---|---|
| `/research "<question>"` | File a new Research Bee for the question, then start work on it. |
| `/research <bee-id>` | Continue an existing Research Bee from its current state. Any text after the ID is the reviewer's verdict or request for the latest round (e.g. `/research b.xxx accept`). |
| `--no-questions` | Never use AskUserQuestion (see No-questions mode). |

**No-questions mode**: on when you are given `--no-questions`, or when you run as an agent-director worker (`AGENT_DIRECTOR_INSTANCE_ID` is set in your environment; such workers usually cannot use AskUserQuestion). In this mode never use AskUserQuestion. Wherever this skill asks the reviewer or the caller, stop instead: put what you know in your output, end it with exactly one `research: needs review:` or `research: needs input:` line as given in the steps, and end your turn. The driver answers in this session, or starts a fresh session and gives the answer after the ID (e.g. `/research b.xxx accept`).

## Prerequisites

The Research hive must exist with:
- Child tiers: t1 — Report / Reports
- Status values: `larva`, `pupa`, `worker`, `finished` (the same four as every Apiary hive)

If it is missing or configured differently (e.g. it still has the old `new`, `active` and `completed`), tell the user to run `/apiary-setup`, which migrates the hive, and stop. Do not create or reconfigure the hive yourself.

## States

| Status | Meaning | Next |
|---|---|---|
| `pupa` | Filed with its question, ready to work. A question is ready as soon as it is written, so a Research Bee is never `larva`. | `worker` when work starts |
| `worker` | Work in review rounds: findings are presented, the reviewer accepts or asks for more. | `finished` when the reviewer accepts |
| `finished` | Accepted. The Bee and its Report are kept as the record. | `worker` only if a reviewer asks for more work |

The Report child uses the same status values: `worker` while the Bee is `worker`, `finished` when the Bee is.

**Finished research is never archived.** Never run `bees undertaker` on the Research hive, and never give it an `undertaker_schedule` in `~/.bees/config.json`. The undertaker only touches the hive it is pointed at, so sweeping other hives is safe. Research uses `finished` like every other hive, so check which hive a sweep is pointed at.

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

- The Bee's folder is `<research hive path>/<bee-id>/` (hive path from `bees list-hives`). The Report lives in `<bee-id>/<report-id>/`.
- Put research artifacts (data, scripts, logs, screenshots, notes, excerpts) in `<research hive path>/<bee-id>/artifacts/`.
- Do not name any folder in there like a ticket ID (`b.xxx`, `t1.xxx`), and do not create a `<dir>/<dir>.md` file pair: bees would take either for a ticket.
- Keep secrets and tokens out of artifacts.

## The Report

One t1 child of the Bee, titled `Report: <Bee title>`. Its body is a well-written, standalone document a reader can use without the Bee or the conversation:

1. **Summary** — the answer first, in a few lines.
2. **Findings** — organised by theme or sub-question, with evidence.
3. **Limitations** — what was not checked, uncertainty, open questions.
4. **Conclusions / recommendations** — if the question calls for them.
5. **References** — a numbered list. Every claim that is not common knowledge carries an inline `[n]` citation pointing here. Each entry names its source precisely: URL with access date, `path:line` or commit SHA, ticket ID, Slack permalink, or document title and section.
6. **Artifacts** — each artifact linked by relative path from the Report's folder, `../artifacts/<file>`, with one line on what it is. Link artifacts from the text where they back a finding.

Put bulky raw material in artifacts, not in the Report body.

## Steps

### 1. File (`pupa`)

For `/research "<question>"`:
1. Create a Bee in the Research hive with a short title, status `pupa`, and the Question and Scope sections (Review rounds empty).
2. Go to step 2, unless the caller asked only to file it; then report the Bee ID and stop.

### 2. Start (`pupa` → `worker`)

1. Set the Bee to `worker`.
2. Create the Report child (t1), status `worker`, with a placeholder body.
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

### 6. Complete (`worker` → `finished`)

1. Check the Report meets the bar above (summary first, citations, references, artifact links).
2. Set the Report and the Bee to `finished`.
3. Report the Bee ID, the Report ID and the one-line answer.

### Continuing a Bee (`/research <bee-id>`)

Read the Bee and its Report, then by status:
- `pupa` → step 2.
- `worker`, latest round awaiting review → with a verdict given after the ID, step 5; otherwise step 4 (present it again).
- `worker`, latest verdict is more work → step 3.
- `finished` → report that it is finished, with the Report ID. Reopen it only if a reviewer asks for more work now: set the Bee and Report to `worker`, start a new round with that request as its input, and go to step 3. If it is unclear whether they want it reopened, ask (no-questions mode: `research: needs input: <bee-id> is finished — reopen it for more work? Say what to do`).
- Any other status → stop and report it; do not guess. An old value (`new`, `active` or `completed`) means the hive needs `/apiary-setup` to migrate it.
