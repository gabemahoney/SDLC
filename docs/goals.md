# Goals of the new Apiary

Read this before changing any skill. Today's Apiary is effective and its skills are generally good. The new Apiary keeps what works and changes what these goals and approved decisions require.

## What the new Apiary fixes
1. **More than bees.** Any shipped ticket system works through its Protocol File.
2. **An Orchestrator in the loop.** The Managing Intelligence chooses skills for Main Agents. Main Agents can launch Child Agents with the skills their work needs, through the Launcher Protocol File.
3. **Shareable configuration.** Templates and `~/.apiary` defaults replace copy-paste between projects.
4. **Apiary reads its own settings and Guidance Documents,** not each repo's CLAUDE.md.
5. **Claude Code and Codex CLI,** each through its Agent Protocol File.
6. **Intake per Project:** how Ideas and Bugs come in is a setting.
7. **Ideas span several repos.**
8. **In proportion:** plans, code, tests and docs are sized to the change. More is not safer.
9. **Fresh reads:** skills, `~/.apiary/system/workflow.md` and Guidance Documents are read from disk on every Run, so changes need no restart.
10. **Written for capable models:** intent and gates, not scripts.

## How skills are written
- **Opinionated where it matters, flexible where it doesn't.** Fixed: ticket categories, the store hierarchy, status ownership, and the gates. Swappable: ticket system, intake, toolchain and Launcher, which live in settings, Guidance Documents and Protocol Files.

## What to keep from today's skills
- **Proven guidance:** keep workflow and ticket contracts in skills; place craft in Guidance Documents and their default fallbacks so Projects can customize it.
- **Proven process steps,** unless a goal above changes them.
- **Strip only:**
  - bees-, tmux- or Claude-Code-specific mechanics, which move to Protocol Files;
  - edge cases and over-prescribed fault handling;
  - anything the latest approved decisions reverse;
  - redundant wording;
  - steps a capable model doesn't need spelled out.

## How a skill change is made
The b.v38 PRD Docs are background only; use the Acceptance baseline for checks.

Read the existing skill and any legacy agent instructions it absorbs from the main checkout. Apply these goals, so the revision preserves useful guidance and follows the current design.
