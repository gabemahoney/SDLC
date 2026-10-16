# Goals of the new Apiary

Read this before changing any skill. Today's Apiary is effective and its skills are generally good. The new Apiary keeps what works and changes what these goals require. When unsure whether to keep a piece of an old skill, keep it unless a goal below says otherwise.

## What the new Apiary fixes
1. **More than bees.** Any shipped ticket system works through its Protocol File.
2. **An Orchestrator in the loop.** A Managing Intelligence (a person or an LLM) drives the skills, and Workers run them through a Launcher.
3. **Shareable configuration.** Templates and `~/.apiary` defaults replace copy-paste between projects.
4. **Apiary reads its own settings and Guidance Documents,** not each repo's CLAUDE.md.
5. **Claude Code and Codex CLI,** each through its Agent Protocol File.
6. **Intake per Project:** how Ideas and Bugs come in is a setting.
7. **Ideas span several repos.**
8. **In proportion:** plans, code, tests and docs are sized to the change. More is not safer.
9. **Fresh reads:** skills, `workflow.md` and Guidance Documents are read from disk on every Run, so changes need no restart.
10. **Written for capable models:** intent and gates, not scripts.

## How skills are written
- **Opinionated where it matters, flexible where it doesn't.** Fixed: ticket categories, the store hierarchy, status ownership, and the gates. Swappable: ticket system, intake, toolchain and Launcher, which live in settings, Guidance Documents and Protocol Files.
- **No logic specific to one template, intake, resolver, ticket system, Launcher or Agent in a generic skill.** Say "follow the …", and put the specifics in that file.
- **Self-contained:** everything specific to a skill is in the skill. `workflow.md` holds the bird's-eye view and the rules several skills share.
- **Say exactly where everything is,** and why each file is read.
- **No edge cases or fault handling a capable Agent handles anyway.** Keep real product decisions and guards against real harm.
- **Plain, positive and complete:** say what a skill does, never what it doesn't; no random subsets; no jargon.

## What to keep from today's skills
- **Craft guidance that makes the output good:** section templates and what each holds, style rules, quality checklists, "what not to include" lists, interview topics, and report contents.
- **Proven process steps,** unless a goal above changes them.
- **Strip only:**
  - bees-, tmux- or Claude-Code-specific mechanics, which move to Protocol Files;
  - edge cases and over-prescribed fault handling;
  - anything a decision in `/tmp/b-v38-pending-edits-next.md` reverses;
  - repetition of `workflow.md`;
  - steps a capable model doesn't need spelled out.

## How a skill change is made
1. **Start from the old files.** Copy today's skill, and any Subagent it folds in, unchanged.
2. **Write a change list first.** Each change is paired with the goal, Doc or decision that requires it. Anything with no reason to change stays.
3. **Make only those changes.**
4. **Review it:**
   - "What was lost?": compare the old and new side by side;
   - a cold read;
   - the checklist (`docs/skill-review-checklist.md`).
5. **The User reviews the change list and the diff.**
