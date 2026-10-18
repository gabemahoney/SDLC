# Writing Apiary skills

Use this guide when writing or revising Apiary skills and their documentation. [The template](skill-template.md) supplies the shape; [the checklist](skill-review-checklist.md) checks the result.

## Start from what works

- Start with today's skill and the agent instructions it absorbs, preserving proven guidance so a revision keeps what already works.
- Apply the latest approved decisions and [product goals](goals.md), because older drafts and reviews can describe a superseded design.
- When wording is unclear, work out the paragraph's purpose and rewrite it whole, because word swaps preserve a broken structure.
- Review additions, updates, trimming and deletion equally, because useful documentation depends on removing stale material too.

## Give capable agents the rules

- State workflow, ownership and outcomes at a high level, because capable agents know their jobs; keep a paragraph only when you can defend its value.
- Keep real product decisions and guards against likely harm, because instructions for rare edge cases and routine recovery obscure the work.
- State the current requirements only, because rejected options, optional extras and future work can become unintended scope.
- Use judgement for qualitative needs and numbers only for confirmed limits, because downstream agents treat invented precision as a requirement.
- State a general rule or every applicable case, because a partial list implies the omitted cases differ.
- Base prerequisites on what the work needs, because a Project may have neither code nor git yet.

Bad: “Map every acceptance criterion to at least one numbered requirement.” Good: “Cover every acceptance criterion so the requirements preserve the intended outcome.”

## Write plainly

- Use short, complete sentences, clear subjects and concrete verbs such as “write” or “review”, so the reader knows who does what.
- Say what to do in positive terms, because prohibitions about abandoned ideas reintroduce them.
- Give each rule its reason briefly in the same sentence, so an agent can apply it with judgement.
- Address the running agent as “you” and “your Child Agents”, because responsibility should be clear.
- Use Main Agent and Child Agent consistently, and established Glossary terms in Title Case, so one concept keeps one name.
- Define only novel terms, briefly and before use, because glossaries explain concepts while implementation details belong with the instructions.
- Say who decides when a decision is needed, because the workflow needs ownership while the agent can choose how to ask.
- Size detail to the work and audience, preserving information when shortening text, because brevity is useful only while the meaning survives.

Bad: “No change notes.” Good: “Read the Idea ticket for changes so planning uses the recorded decisions.”

## Put guidance where it belongs

- Keep the skill's gates, owned transitions and special rules in its own file, because it must be executable from its instructions; workflow.md gives the bird's-eye view.
- Put workflow rules needed by more than one skill in workflow.md and point each skill to it, so shared loading and workflow guidance has one home.
- Put craft in Guidance Documents and their default fallbacks, preserving useful existing advice there so Projects can customize the standards.
- Put implementation-specific logic in the selected template or Protocol File, so generic skills work with every supported configuration.
- Follow the selected template's structure, because adding compulsory sections defeats its customization.
- State each rule once in its proper place, because repeated versions drift and consume context.

Bad: “Reuse test fixtures” in a skill. Good: “Follow `guide:test-guide.md` for testing standards.”

## Name the reading

- Use `setting:<name>`, `guide:<file>` and `protocol:<file>`, with optional ` ## <Section>` inside the same backticks for file sections, so references resolve consistently; use full paths for fixed files.
- Name selected files through their selecting setting or resolved protocol reference, so the agent knows which configuration applies.
- Read Guidance Documents from the main checkout, because worktrees may contain guidance still in development.
- List mandatory readings as “**Name:** reference, for purpose”, including used templates and protocols, and justify each source for this skill, so each Run loads only what it needs.
- Put conditional reading in one closing line tailored to the work, so optional context stays distinct from mandatory reading; documentation agents read docs and relevant code.
- Begin Child Agent reading with “**Launcher:** `protocol:launcher.md`, for how you work as a Child Agent and report to your Main Agent”, so reporting follows the Launcher.
- Describe an executor's assignment as “**Your Subtask or Bug:** it holds everything you need to do”, because the ticket carries the assignment.

Example closing line: “Also read the Project's code, tests and any linked Research tickets as the work needs.”

## Shape the workflow

- Use the template's core sections and a quoted frontmatter description stating the skill's purpose and when to use it, so readers can find the contract and YAML punctuation stays valid; an unused section says “None: <why>”.
- Make Main Agent Gates check the input ticket and prerequisite states, and Child Agent Gates check the assigned ticket's state, so work starts at its intended stage.
- Write Gates as plain conditions with the response to a failed condition, so the next action is clear.
- Keep Steps short and numbered, label each with its goal and group related substeps, using if/then bullets for actual branches, so the workflow stays easy to follow.
- Make Writes name affected tickets or files, their store or path, and owned status changes with the deciding authority, so ownership is explicit.
- Define ticket bodies in the skills that write them, because each writer needs its own output contract.
- Make writing and reading instructions agree, and derive checks from stated requirements, so handoffs work without hidden obligations.

## Use tickets for continuity

- For ticket work, take IDs as input and keep findings, decisions, progress and handoffs on the affected tickets, so launches and reports point to one durable record.
- Put rules a Task sets for later Tasks in those Tasks' `## Context`, so executors find their prerequisites with their assignments.
- Keep executor `## Progress` to deviations with reasons, unfinished work and effects on docs or other work, so the Main Agent sees what needs coordination.
- Make Done report the ticket ID, unaddressed work with reasons and the next step, so the caller can act; Child Agents report to their Main Agent as `protocol:launcher.md` describes.

## Define Child Agent responsibilities

- Use Child Agents for independence, scale or parallel work, because delegation should add value beyond passing back another agent's report.
- State when each Child Agent launches, its expected result, and whether it is fresh or reused with the scope and reason, so its lifecycle is clear.
- Have planners write their own draft Subtasks and apply review edits through the same planner, so revisions retain planning context.
- Give each testing Subtask one writer and distinct files, grouping tests that change a shared helper, so parallel writers avoid conflicting edits.
- Assign Compile, Lint, Unit tests and Integration tests to the Main Agent and targeted checks to executors, so combined work is checked by its owner.
- Have documentation reviewers read the code changes and every covered document in full, so all affected documentation is found.

## Judge reviews

- Have reviewers read the main brief before reviewing a child document, because local wording must serve the overall intent.
- Require reviewers to interpret Guidance Documents strictly and tag findings `blocker` (wrong), `suggestion` (fragile or confusing) or `nit` (style), with meanings suited to their review, so the Main Agent can weigh them.
- Vet each finding against approved intent and the actual files before acting, because reviewers can mistake ordinary agent judgement for missing rules.
- Let the Main Agent fix accepted findings, decline minor findings with recorded reasons, or ask the Managing Intelligence about product decisions and requirements conflicts, because they own those decisions.
- Raise genuine conflicts with the reason and your recommended resolution, because agreement without judgement can undermine earlier decisions.
- Review cold for clarity and logical consistency, compare with the previous skill and check the checklist, then trim after each review round, so revisions stay clear and complete.
- Stop review rounds when findings are trivial or further cuts would lose information, because agents can always find another wording change.

## Make documents easy to navigate

- Put purpose and goals before detail, carrying the Idea's problem statement into its PRD, because readers need a consistent explanation of the problem before the mechanics.
- Write PRD requirements as succinct bullets with explanatory paragraphs where needed, while choosing the SRD's format for agents, because the PRD serves human readers too.
- Phrase requirements around problems and required outcomes, using user stories where helpful, because prescribing a solution can hide the need it serves.
- Label completion checks as Acceptance Criteria, because readers need to distinguish proof of success from the requirements themselves.
- Use descriptive headings and links between related documents, so readers can find the part they need.
- Split an unwieldy document into a core brief and linked documents by logical section, keeping each diagram with its subject, so detail stays manageable.
- Distinguish skills, Main Agents, Child Agents and the Managing Intelligence in diagrams, giving each Child Agent its own labelled box with its job and caller and showing review loops, so humans can follow the work.
- Keep diagram boxes focused on the flow and explain shared conventions once in a legend or caption, because file inventories and repeated notes obscure the picture.
