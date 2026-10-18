---
name: apiary-work
description: Apiary self-modification workflow — work an apiary ticket, fix an apiary bug, or implement an apiary bee as a single agent. Replaces do-bee/fix-bug when the target repo is apiary itself. Takes a bees ticket ID, dispatches one worker, and gates push behind operator sign-off.
---

# apiary-work

Single-agent execution of a bees ticket against the apiary repo itself. No
engineer/reviewer/doc-writer team — one worker implements end-to-end, and you
(the calling agent) run a review loop with the operator before anything is
pushed.

## Non-goals

- No multi-agent subagent team (engineer, reviewers, doc writer).
- No pre-dispatch model validation — the general-purpose Agent inherits
  harness defaults.
- No PRD/SRD generation — that stays in `write-prd` / `write-srd`.

## Steps

### Approval guard

Run this first: no context gathering, dispatch or ticket change comes before
it. If you were not given a ticket ID, ask for it as step 1 says, then run this
before anything else.

Ideas-hive and Plans-hive tickets are gated. Read tickets with
`bees show-ticket --ids <id>`. To find a ticket's hive,
`bees execute-freeform-query --query-yaml "stages: [[id=<id>, hive=<hive>]]"`
returns it only if it is in that hive (`ideas` or `plans`).

**Ideas hive:**
1. Idea Bee: the ticket itself if it is a Bee. For a child-tier ticket, follow
   `parent` up to the Bee.
2. The Idea Bee's `tags` must include `approved:yes`.
3. If the Idea Bee has a t1 child titled `PRD`, the PRD's `tags` must include
   `approved:yes` too. An Idea with no PRD passes this step.

**Plans hive** (as in `/do-bee`):
1. Plan Bee: the ticket itself if it is a Bee. For an Epic, or any ticket below
   one, follow `parent` up to the Bee.
2. Idea Bee: the Ideas-hive Bee named in the Plan Bee's `reference_materials`
   (its `bees` entry) or `up_dependencies`. If there is more than one, check
   each.
3. PRD: the Idea Bee's t1 child titled `PRD`.
4. The PRD's `tags` must include `approved:yes`.

**Any other hive** (Bugs and Research, like `/fix-bug` and `/research`): not
gated. Skip the rest of this guard.

If any step fails, stop at once: change no ticket and dispatch nothing. When
given `--no-questions`, or when `AGENT_DIRECTOR_INSTANCE_ID` is set, end your
output with exactly one of these lines; otherwise tell the user the same and
stop:
- `apiary-work: needs input: <ticket-id> lacks approved:yes — the User must approve it`,
  naming the Idea or the PRD, whichever lacks the tag
- `apiary-work: needs input: no <Plan Bee | Idea Bee | PRD> found for <ticket-id> — cannot check approved:yes`

This skill never adds `approved:yes`. Only the User approves.

### 1. Input

Take a bees ticket ID (a bee ID like `b.448` or a child-tier ID). If the user
didn't supply one, ask.

### 2. Gather context

- Before changing an Apiary skill or doc, use the
  [apiary-skill-writing skill](../apiary-skill-writing/SKILL.md), and run its
  checklist before reporting.
- Fetch the ticket: `bees show-ticket --ids <id>`.
- Scan the ticket body for linked PRD/SRD/design-doc ticket IDs and fetch
  those too.
- Read the repo state relevant to the ticket so the dispatch prompt reflects
  reality, not just the ticket's claims.

### 3. Dispatch one worker

Spawn ONE foreground `Agent` (no `subagent_type` — general-purpose) with a
self-contained prompt containing:

- the ticket body verbatim
- any PRD/SRD contents verbatim
- relevant repo conventions
- instructions to: implement the change, run any local checks (grep-based
  acceptance criteria, etc.), commit locally on `master`, and STOP before
  pushing
- for skill or doc changes: include the apiary-skill-writing instruction from
  Gather context, so the worker follows the same writing rules
- required report format: files changed, commit SHA, one-paragraph summary,
  any open questions or concerns it chose to set aside

### 4. Review loop (calling agent = operator-facing)

On worker return:

1. Show the operator `git show --stat <sha>` and `git diff <sha>^..<sha>`.
2. Present the worker's summary and open questions.
3. Wait for explicit operator sign-off — do not proceed without it.
4. If the operator requests changes: `SendMessage` back to the SAME worker
   (its context is preserved) with the change request. The worker adds fixup
   commits and reports again. Repeat until sign-off.

### 5. Publish

On sign-off, instruct the worker to:

- `git push origin master`
- `bees update-ticket --ids <id> --status done`

Confirm both to the operator.
