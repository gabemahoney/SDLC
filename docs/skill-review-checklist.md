# Skill review checklist

Every lesson from the User's reviews of `workflow.md`, write-idea and project-setup. A skill is ready for the User only when it passes every item. Each item gives the mistake it prevents.

## Structure
1. **The template, exactly.** Follow `docs/skill-template.md`, with its sections in order. An empty section says "None: <why>".
2. **A description that names the job.** The frontmatter `description` is quoted, because an unquoted colon breaks the frontmatter. It says what the skill is for in plain words. Example: project-setup is "One-time setup of an Apiary Project…", not "Set up the Project this Run works in".
3. **Purpose says where it sits.** Write "before any other Apiary skill", not "before write-idea or write-bug".
4. **Loading Apiary is the fixed two-line block, word for word.** Don't restate `workflow.md`'s shared rules in the skill.
5. **Steps have goals.** Each step starts with a bold goal. Group related steps as substeps (3a, 3b…) rather than giving one long list; eleven flat steps was too many.
6. **Branching steps are if/then bullets,** one bullet per path. Straight-line steps stay as plain sentences. Don't let if/then make a step longer.
7. **Stops sit inline in Steps,** as "stop and ask the Managing Intelligence: …". Use no separate "Stops and asks" section. List only the stops the design chose, never a generic "ask when unsure".

## What goes where
8. **Everything specific to this skill is in the skill.** Its gate, its owned status transitions and its single-skill rules all go in the skill. `workflow.md` is a bird's-eye view plus rules more than one skill needs; never rely on it for this skill's specifics.
9. **Nothing in the skill is specific to one template, intake, resolver, ticket system, Launcher or Agent.** Say "follow the template / intake / Protocol File", and put the specifics in that file. This was the User's 🚨 "Major problem!": the Public GitHub template's logic was written into project-setup.
10. **Say exactly where everything is.** Give full paths, and say how a setting value maps to a file (for example, `ticket_system: bees` → `~/.apiary/system/protocols/ticket-bees.md`). Never write "as your settings choose" or "load the X file". The paths are:
    - Apiary's installed files: `~/.apiary/system/` (`workflow.md`, `protocols/`, `templates/`);
    - settings: `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`.
11. **Every Read says why**, in the form "- **Name:** path. Why: …". A file the skill doesn't use is not a Read. Being covered in `workflow.md` doesn't exempt a file the skill does use. List `launcher.md` for skills that launch, resume, stop or inspect Main Agents or Child Agents, or check Launcher prerequisites, so lifecycle instructions are available when needed.
12. **Templates the skill uses are named in its Required Reading,** with their paths.
12a. **Thinking Levels are resolved by the caller.** A skill that launches an Agent reads `thinking_levels` and the selected Agent's model mapping for the target skill. Apply Task or Bug tag overrides as `workflow.md` describes, so launch settings follow the assignment.

## Wording
13. **Phrase things positively.** Say what the skill takes, does and writes, never what it doesn't. "No ticket ID" is wrong; "it also doesn't take a watermelon".
14. **No random subsets.** List every case, or state a general rule. A partial list implies the missing cases differ.
15. **No undefined terms.** Use Glossary terms in Title Case, including Run. If a word like "scope", "approach" or "gate" isn't defined, either define it once or say it plainly.
15a. **Full sentences.** Every instruction, including each line of a template, is a complete sentence. Never write a bare noun phrase like "The scenarios and expected behaviour supplied by the input."
16. **Plain words over jargon a capable Agent doesn't need.** Write "git repos", not "folders whose `.git` is a directory"; write "the repo", not "manifests and config".
17. **No negative-space or obvious lines.** Leave out "No ticket ID", "no status transitions", "Child Agents never …" in a skill, and "names its own …".
18. **Say which thing you mean.** Write "the folder it's setting up", not "the folder it runs in"; write "Fresh start", not a vague "new one".

## Design
19. **Capable Agents.** Include no edge cases (version mismatch, transcript limits, concurrent-agent limits, stale IDs, submodules), no fault handling a capable Agent does anyway, and no step-by-step how-to.
20. **Nothing extraneous.** Keep only real requirements and harm guards. No history, no future work, no rejected options.
21. **Don't assume git where the design doesn't.** Project-level skills (project-setup, write-idea, write-bug, write-prd, write-srd, req-review, write-plan, write-epic, research) must work without git.
22. **Defaults are easy to accept.** A question with a default offers "use the default for all" before asking per item.
23. **Only real gates.** If the skill has no gate, say "None: <why>"; never write a weak gate like "check the creation input".
24. **The skill is self-consistent.** Never tell the Agent to skip something an earlier step already ruled out. Never let one step contradict another.
24a. **Child Agent skills require a Main Agent.** Their own Gate checks that relationship, because the Main Agent owns their assignment and receives their result.
24b. **Launcher operations have named sections.** project-setup checks each heading and its instructions against `workflow.md` and stops on omissions, because the skills depend on those operations.
25. **Nothing the User already reversed.** Check `/tmp/b-v38-pending-edits-next.md` (the DECIDED / REVISED lines are the User's decisions, and later lines override earlier ones), so no reversed decision creeps back in.

## Process
- **A cold read before the User sees anything.** A fresh Agent gets only the SKILL.md, `workflow.md` and the files it names, plus concrete scenarios. It lists every point where it would have to guess. Repeat until clean.
- **A checklist review,** by a separate fresh Agent, against every item above.
- **Verify agent claims in the file itself.** Never trust a "done" report alone.

- **Every rule says why.** Each instruction that something must or must not be done gives its reason, briefly, in the same sentence ("…so later skills can find the requirements").
