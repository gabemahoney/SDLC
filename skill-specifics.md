# Skill specifics

Rules moved from `workflow/workflow.md` at `1d606655eb4da0934fb3d666e02e210c509b8a65`, for future skill and Subagent definition drafts. Wording is carried over; table cells are split at their semicolons and labelled with their ticket. A statement that the source specifies nothing is an inventory note, not a new gate or permission. The Managing Intelligence section preserves its transitions.

The Reads below are the input inventory for the b.v38 drafts. Each setting is read from `<Project Folder>/.apiary/project_settings.md`, falling back by setting to `~/.apiary/default_project_settings.md`. Subagents use only the resolved settings and Protocol Files supplied by their dispatch prompt. `<repo checkout>` is the repo root selected by the skill's working location or the Subagent's dispatch: `<Project Folder>/<repo path>/` for a main checkout, or `<Project Folder>/.worktrees/<ticket id>/<repo path>/` for a worktree. A Guidance Document walk and its pointer resolution follow `~/.apiary/system/workflow.md`.

## project-setup

### State gate

None specified in the source workflow.

### Owned transitions

None specified in the source workflow.

### Specific rules

None specified in the source workflow.

## write-idea

### State gate

None specified in the source workflow.

### Owned transitions

**Idea:** write-idea creates `draft`

### Specific rules

None specified in the source workflow.

## write-bug

### Reads

- **Skill instructions:** `~/.claude/skills/write-bug/SKILL.md` or `~/.agents/skills/write-bug/SKILL.md`, selected by the Agent. Why: apply this skill’s input, state gate, owned transitions, checks and reporting rules.
- **Workflow:** `~/.apiary/system/workflow.md`. Why: apply the shared startup, path, status, Guidance Document and reporting rules.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` or `~/.apiary/system/protocols/agent-codex.md`, selected by the running Agent. Why: follow the Agent’s operations and reporting rules.
- **`ticket_system` setting:** `ticket_system` in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: select the Ticket System Protocol File for this Run.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: file the Bug in the Bugs store with its body and source reference.
- **`levels_<agent>` setting:** `levels_claude_code` or `levels_codex`, selected by the running Agent, in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: validate the running Agent’s Thinking Level mapping.
- **`thinking_levels` setting:** `thinking_levels` in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: check the `write-bug` line before starting work.
- **`new_bug_intake` setting:** `new_bug_intake` in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: interpret the input and choose the Project’s Bug intake approach.
- **`bug-writing-guide.md`:** `<folder on the Guidance Document walk>/.apiary/bug-writing-guide.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/bug-writing-guide-default-fallback.md`. Why: write the supplied Bug information in the Project’s required form; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.

### State gate

None specified in the source workflow.

### Owned transitions

**Bug:** write-bug or the Managing Intelligence creates `draft`, not yet validated

### Specific rules

None specified in the source workflow.

## define-bug

### Reads

- **Skill instructions:** `~/.claude/skills/define-bug/SKILL.md` or `~/.agents/skills/define-bug/SKILL.md`, selected by the Agent. Why: apply this skill’s input, state gate, owned transitions, checks and reporting rules.
- **Workflow:** `~/.apiary/system/workflow.md`. Why: apply the shared startup, path, status, Guidance Document and reporting rules.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` or `~/.apiary/system/protocols/agent-codex.md`, selected by the running Agent. Why: follow the Agent’s operations and reporting rules.
- **`ticket_system` setting:** `ticket_system` in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: select the Ticket System Protocol File for this Run.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: read the Bug, record validation evidence and set its status and Thinking Level tag.
- **`levels_<agent>` setting:** `levels_claude_code` or `levels_codex`, selected by the running Agent, in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: validate the running Agent’s Thinking Level mapping.
- **`thinking_levels` setting:** `thinking_levels` in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: check the `define-bug` line before starting work.
- **Bug and source references:** Ticket System selected by `ticket_system`: the input Bug ID, its body and linked source references. Why: recover the reported behaviour and reproduction evidence to validate.
- **`bug-writing-guide.md`:** `<folder on the Guidance Document walk>/.apiary/bug-writing-guide.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/bug-writing-guide-default-fallback.md`. Why: check and fill the Bug write-up after validation; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.
- **`build-commands.md`:** `<folder on the Guidance Document walk>/.apiary/build-commands.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/build-commands-default-fallback.md`. Why: find the commands needed to reproduce the Bug in each affected repo; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.
- **Build discovery references:** `<repo checkout>/README.md` and the CI configuration paths in that checkout, as directed by `~/.apiary/build-commands-default-fallback.md` when that fallback is used. Why: discover the repo’s commands when the fallback supplies none.
- **Reproduction context:** `<repo checkout>/<path>` selected by the Bug’s reproduction steps and source references, in the main checkouts. Why: read source, existing tests and configuration to decide whether the behaviour is real or intended.

### State gate

Bug `draft`.

### Owned transitions

**Bug:** define-bug sets `defined` after reproducing and validating it, and sets its `thinking_level:` tag

**Bug:** define-bug sets `invalid` when the Bug is not real, with a note saying why

### Specific rules

**Tag (`thinking_level:<label>`):** define-bug sets a Bug's.

Not a real Bug; define-bug sets it with a note saying why.

## write-prd

### Reads

- **Skill instructions:** `~/.claude/skills/write-prd/SKILL.md` or `~/.agents/skills/write-prd/SKILL.md`, selected by the Agent. Why: apply this skill’s input, state gate, owned transitions, checks and reporting rules.
- **Workflow:** `~/.apiary/system/workflow.md`. Why: apply the shared startup, path, status, Guidance Document and reporting rules.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` or `~/.apiary/system/protocols/agent-codex.md`, selected by the running Agent. Why: follow the Agent’s operations and reporting rules.
- **`ticket_system` setting:** `ticket_system` in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: select the Ticket System Protocol File for this Run.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: read the Idea and its Docs and create or revise its one PRD.
- **`levels_<agent>` setting:** `levels_claude_code` or `levels_codex`, selected by the running Agent, in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: validate the running Agent’s Thinking Level mapping.
- **`thinking_levels` setting:** `thinking_levels` in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: check the `write-prd` line before starting work.
- **Idea, Docs and source references:** Ticket System selected by `ticket_system`: the input Idea ID, its Doc children and its source references. Why: gather stated requirements, find the existing PRD to revise and determine whether an SRD exists for the next step.
- **Interview and revision input:** the conversation and the supplied review findings or change notes. Why: write only the stated requirements and record unanswered questions.

### State gate

None specified in the source workflow.

### Owned transitions

**PRD / SRD:** write-prd / write-srd creates `draft`

**PRD / SRD:** revising a `defined` PRD or SRD sets it back to `draft`

### Specific rules

None specified in the source workflow.

## write-srd

### Reads

- **Skill instructions:** `~/.claude/skills/write-srd/SKILL.md` or `~/.agents/skills/write-srd/SKILL.md`, selected by the Agent. Why: apply this skill’s input, state gate, owned transitions, checks and reporting rules.
- **Workflow:** `~/.apiary/system/workflow.md`. Why: apply the shared startup, path, status, Guidance Document and reporting rules.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` or `~/.apiary/system/protocols/agent-codex.md`, selected by the running Agent. Why: follow the Agent’s operations and reporting rules and dispatch and resume its Subagents.
- **`ticket_system` setting:** `ticket_system` in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: select the Ticket System Protocol File for this Run.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: read the Idea’s PRD, create or revise its SRD and find existing TLA+ spec Docs.
- **`levels_<agent>` setting:** `levels_claude_code` or `levels_codex`, selected by the running Agent, in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: validate the running Agent’s Thinking Level mapping and map dispatched Thinking Levels to model and effort.
- **`thinking_levels` setting:** `thinking_levels` in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: check the `write-srd` line and the dispatched Subagent Role lines (`TLA+ Writer`) before starting work.
- **TLA+ Writer definition:** `~/.claude/agents/apiary-tla-writer.md` or `~/.codex/agents/apiary-tla-writer.toml`, selected by the Agent. Why: dispatch the TLA+ Writer with its own instructions and required reads.
- **Idea and requirements Docs:** Ticket System selected by `ticket_system`: the input Idea ID and its PRD, SRD and TLA+ spec Doc children. Why: derive the SRD from the PRD, revise the existing SRD and match modelled parts to their existing specs.
- **`engineering-best-practices.md`:** `<folder on the Guidance Document walk>/.apiary/engineering-best-practices.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/engineering-best-practices-default-fallback.md`. Why: make the SRD respect each explored repo’s engineering rules; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.
- **`test-guide.md`:** `<folder on the Guidance Document walk>/.apiary/test-guide.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/test-guide-default-fallback.md`. Why: ground the SRD’s test fixtures and test requirements in each explored repo’s patterns; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.
- **Codebase and test context:** `<repo checkout>/<path>` selected by the PRD’s scope in each explored repo. Why: identify real modules, patterns, helpers and test files for the SRD.
- **Revision input and model findings:** the supplied review findings or change notes and the TLA+ Writers’ returned reports. Why: revise the SRD and correct requirements where models find defects.

### State gate

None specified in the source workflow.

### Owned transitions

**PRD / SRD:** write-prd / write-srd creates `draft`

**PRD / SRD:** revising a `defined` PRD or SRD sets it back to `draft`

### Specific rules

write-srd selects the parts to model, dispatches one TLA+ Writer per part in parallel, and fixes SRD bugs their models find.

## req-review

### Reads

- **Skill instructions:** `~/.claude/skills/req-review/SKILL.md` or `~/.agents/skills/req-review/SKILL.md`, selected by the Agent. Why: apply this skill’s input, state gate, owned transitions, checks and reporting rules.
- **Workflow:** `~/.apiary/system/workflow.md`. Why: apply the shared startup, path, status, Guidance Document and reporting rules.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` or `~/.apiary/system/protocols/agent-codex.md`, selected by the running Agent. Why: follow the Agent’s operations and reporting rules and dispatch and resume its Subagents.
- **`ticket_system` setting:** `ticket_system` in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: select the Ticket System Protocol File for this Run.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: enumerate the Idea’s Docs and set approved Doc and Idea statuses.
- **`levels_<agent>` setting:** `levels_claude_code` or `levels_codex`, selected by the running Agent, in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: validate the running Agent’s Thinking Level mapping and map dispatched Thinking Levels to model and effort.
- **`thinking_levels` setting:** `thinking_levels` in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: check the `req-review` line and the dispatched Subagent Role lines (`Requirements Reviewer`, `TLA+ Reviewer`) before starting work.
- **Requirements Reviewer definition:** `~/.claude/agents/apiary-req-reviewer.md` or `~/.codex/agents/apiary-req-reviewer.toml`, selected by the Agent. Why: dispatch the Requirements Reviewer with its own instructions and required reads.
- **TLA+ Reviewer definition:** `~/.claude/agents/apiary-tla-reviewer.md` or `~/.codex/agents/apiary-tla-reviewer.toml`, selected by the Agent. Why: dispatch the TLA+ Reviewer with its own instructions and required reads.
- **Idea and every Doc child:** Ticket System selected by `ticket_system`: the input Idea ID and all its Doc children. Why: assign the reviews, identify each TLA+ spec and check which Doc and Idea transitions are available.
- **Review reports:** the Requirements Reviewer’s and TLA+ Reviewers’ returned reports. Why: present findings and verdicts and ask which ready Docs to mark defined.

### State gate

None specified in the source workflow.

### Owned transitions

**Idea:** req-review sets `draft` → `defined` on the Managing Intelligence's yes, once its PRD and SRD are `defined`

**PRD / SRD:** req-review asks the Managing Intelligence and, on yes, sets `defined`.

**Other Doc (not PRD, SRD or TLA+ spec):** req-review asks the Managing Intelligence and, on yes, sets `defined`

### Specific rules

req-review dispatches one read-only TLA+ Reviewer per TLA+ spec Doc alongside the Requirements Reviewer, checking that the model matches the SRD and its invariants are meaningful.

## write-plan

### Reads

- **Skill instructions:** `~/.claude/skills/write-plan/SKILL.md` or `~/.agents/skills/write-plan/SKILL.md`, selected by the Agent. Why: apply this skill’s input, state gate, owned transitions, checks and reporting rules.
- **Workflow:** `~/.apiary/system/workflow.md`. Why: apply the shared startup, path, status, Guidance Document and reporting rules.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` or `~/.apiary/system/protocols/agent-codex.md`, selected by the running Agent. Why: follow the Agent’s operations and reporting rules and dispatch and resume its Subagents.
- **`ticket_system` setting:** `ticket_system` in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: select the Ticket System Protocol File for this Run.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: read the Idea and its Docs, find an existing Plan and write the Plan and Epics with dependencies.
- **`levels_<agent>` setting:** `levels_claude_code` or `levels_codex`, selected by the running Agent, in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: validate the running Agent’s Thinking Level mapping and map dispatched Thinking Levels to model and effort.
- **`thinking_levels` setting:** `thinking_levels` in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: check the `write-plan` line and the dispatched Subagent Role lines (`Product Manager`) before starting work.
- **Product Manager definition:** `~/.claude/agents/apiary-product-manager.md` or `~/.codex/agents/apiary-product-manager.toml`, selected by the Agent. Why: dispatch the Product Manager with its own instructions and required reads.
- **Idea, Docs, Plan and Epics:** Ticket System selected by `ticket_system`: the input Idea ID, every Doc child, the Plan found by the Idea’s source reference and that Plan’s Epics. Why: check the gate, plan all requirements and continue an existing Plan without duplicating work.
- **Idea source references:** the external paths or URLs stored as the input Idea’s source references. Why: read the original context for the requested work.
- **`engineering-best-practices.md`:** `<folder on the Guidance Document walk>/.apiary/engineering-best-practices.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/engineering-best-practices-default-fallback.md`. Why: plan the engineering work each repo requires; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.
- **`test-guide.md`:** `<folder on the Guidance Document walk>/.apiary/test-guide.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/test-guide-default-fallback.md`. Why: plan test coverage in proportion to the requirements and risk; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.
- **`doc-writing-guide.md`:** `<folder on the Guidance Document walk>/.apiary/doc-writing-guide.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/doc-writing-guide-default-fallback.md`. Why: plan the documentation required and allowed in each repo; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.
- **`maintained-docs.md`:** `<folder on the Guidance Document walk>/.apiary/maintained-docs.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/maintained-docs-default-fallback.md`. Why: identify the contributor and customer docs affected by the work; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.
- **Maintained documentation:** the paths listed in the loaded `maintained-docs.md` copies, resolved in the repo checkout by `~/.apiary/system/workflow.md`. Why: read the existing documentation to establish what the work must update.
- **Planning context:** `<repo checkout>/<path>` selected by the Idea’s Docs and affected repo paths. Why: ground vertical slices, working intermediate states and dependencies in the existing product.
- **Product Manager report:** the Product Manager’s returned Plan review. Why: revise the Plan’s size, slices and scope before setting it defined.

### State gate

Idea `defined`, with a PRD and an SRD. Finish an existing Plan in `draft` or `defined`; never duplicate it.

### Owned transitions

**Plan:** write-plan creates `draft`, and sets `defined` once the Plan is written, checked and revised

**Epic:** write-plan creates `draft`, and idea-review creates a Round Feedback Epic `draft`

### Specific rules

When the PRD or SRD is not `defined`, write-plan stops and asks the Managing Intelligence to confirm planning without review, and goes on only on an explicit yes.

## write-epic

### Reads

- **Skill instructions:** `~/.claude/skills/write-epic/SKILL.md` or `~/.agents/skills/write-epic/SKILL.md`, selected by the Agent. Why: apply this skill’s input, state gate, owned transitions, checks and reporting rules.
- **Workflow:** `~/.apiary/system/workflow.md`. Why: apply the shared startup, path, status, Guidance Document and reporting rules.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` or `~/.apiary/system/protocols/agent-codex.md`, selected by the running Agent. Why: follow the Agent’s operations and reporting rules and dispatch and resume its Subagents.
- **`ticket_system` setting:** `ticket_system` in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: select the Ticket System Protocol File for this Run.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: read the Epic’s context and write Tasks, Subtasks, dependencies and Thinking Level tags.
- **`levels_<agent>` setting:** `levels_claude_code` or `levels_codex`, selected by the running Agent, in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: validate the running Agent’s Thinking Level mapping and map dispatched Thinking Levels to model and effort.
- **`thinking_levels` setting:** `thinking_levels` in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: check the `write-epic` line and the dispatched Subagent Role lines (`Engineer planner`, `Test Writer planner`, `Doc Writer planner`, `Product Manager`) before starting work.
- **Engineer planner definition:** `~/.claude/agents/apiary-engineer-planner.md` or `~/.codex/agents/apiary-engineer-planner.toml`, selected by the Agent. Why: dispatch the Engineer planner with its own instructions and required reads.
- **Test Writer planner definition:** `~/.claude/agents/apiary-test-writer-planner.md` or `~/.codex/agents/apiary-test-writer-planner.toml`, selected by the Agent. Why: dispatch the Test Writer planner with its own instructions and required reads.
- **Doc Writer planner definition:** `~/.claude/agents/apiary-doc-writer-planner.md` or `~/.codex/agents/apiary-doc-writer-planner.toml`, selected by the Agent. Why: dispatch the Doc Writer planner with its own instructions and required reads.
- **Product Manager definition:** `~/.claude/agents/apiary-product-manager.md` or `~/.codex/agents/apiary-product-manager.toml`, selected by the Agent. Why: dispatch the Product Manager with its own instructions and required reads.
- **Epic, Plan, sibling Epics and Idea Docs:** Ticket System selected by `ticket_system`: the input Epic ID, its parent Plan, that Plan’s Epics and the Idea and every Doc found through the Plan’s source reference. Why: check the gate, avoid sibling work and give Tasks and Subtasks their scope and acceptance criteria.
- **Idea source references:** the external paths or URLs stored on the Idea found through the Plan. Why: read the original context for the Epic’s work.
- **`engineering-best-practices.md`:** `<folder on the Guidance Document walk>/.apiary/engineering-best-practices.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/engineering-best-practices-default-fallback.md`, when planning without the Engineer planner. Why: plan code Subtasks with the repo’s engineering rules; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.
- **`test-guide.md`:** `<folder on the Guidance Document walk>/.apiary/test-guide.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/test-guide-default-fallback.md`, when planning without the Test Writer planner. Why: plan test Subtasks and lanes with the repo’s test rules; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.
- **`doc-writing-guide.md`:** `<folder on the Guidance Document walk>/.apiary/doc-writing-guide.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/doc-writing-guide-default-fallback.md`, when planning without the Doc Writer planner. Why: plan documentation Subtasks with the repo’s writing rules; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.
- **`maintained-docs.md`:** `<folder on the Guidance Document walk>/.apiary/maintained-docs.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/maintained-docs-default-fallback.md`, when planning without the Doc Writer planner. Why: identify the contributor and customer docs affected by the work; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.
- **Maintained documentation:** the paths listed in the loaded `maintained-docs.md` copies, resolved in the repo checkout by `~/.apiary/system/workflow.md`, when planning without the Doc Writer planner. Why: read the existing documentation to establish what the work must update.
- **Key Files and interface context:** `<repo checkout>/<path>` selected by the Epic’s scope in the repos being planned. Why: name concrete Key Files, identify shared test fixtures for lanes and flag interface changes for integration.
- **Planning reports and answers:** the dispatched planners’ and Product Manager’s reports and the Managing Intelligence’s answers. Why: settle scope, lanes and Thinking Levels, revise the plan and preserve answers verbatim in affected Subtasks.

### State gate

Epic `draft`; its Plan `defined` or `active`.

### Owned transitions

**Epic:** write-epic sets `defined`

**Task:** write-epic creates `draft`, then sets `defined`

**Subtask:** write-epic creates `draft`, then sets `defined` for its Tasks

### Specific rules

**Tag (`thinking_level:<label>`):** write-epic and develop-epic set their Tasks' tags

## develop-epic

### Reads

- **Skill instructions:** `~/.claude/skills/develop-epic/SKILL.md` or `~/.agents/skills/develop-epic/SKILL.md`, selected by the Agent. Why: apply this skill’s input, state gate, owned transitions, checks and reporting rules.
- **Workflow:** `~/.apiary/system/workflow.md`. Why: apply the shared startup, path, status, Guidance Document and reporting rules.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` or `~/.apiary/system/protocols/agent-codex.md`, selected by the running Agent. Why: follow the Agent’s operations and reporting rules and dispatch and resume its Subagents.
- **`ticket_system` setting:** `ticket_system` in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: select the Ticket System Protocol File for this Run.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: read and update the Epic’s work, statuses, dependencies, Thinking Level tags and progress record.
- **`levels_<agent>` setting:** `levels_claude_code` or `levels_codex`, selected by the running Agent, in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: validate the running Agent’s Thinking Level mapping and map dispatched Thinking Levels to model and effort.
- **`thinking_levels` setting:** `thinking_levels` in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: check the `develop-epic` line and the dispatched Subagent Role lines (`Code Reviewer`, `Test Reviewer`, `Doc Reviewer`, `Product Manager`, `Integration Tester`) before starting work.
- **Engineer definition:** `~/.claude/agents/apiary-engineer.md` or `~/.codex/agents/apiary-engineer.toml`, selected by the Agent. Why: dispatch the Engineer with its own instructions and required reads.
- **Test Writer definition:** `~/.claude/agents/apiary-test-writer.md` or `~/.codex/agents/apiary-test-writer.toml`, selected by the Agent. Why: dispatch the Test Writer with its own instructions and required reads.
- **Doc Writer definition:** `~/.claude/agents/apiary-doc-writer.md` or `~/.codex/agents/apiary-doc-writer.toml`, selected by the Agent. Why: dispatch the Doc Writer with its own instructions and required reads.
- **Code Reviewer definition:** `~/.claude/agents/apiary-code-reviewer.md` or `~/.codex/agents/apiary-code-reviewer.toml`, selected by the Agent. Why: dispatch the Code Reviewer with its own instructions and required reads.
- **Test Reviewer definition:** `~/.claude/agents/apiary-test-reviewer.md` or `~/.codex/agents/apiary-test-reviewer.toml`, selected by the Agent. Why: dispatch the Test Reviewer with its own instructions and required reads.
- **Doc Reviewer definition:** `~/.claude/agents/apiary-doc-reviewer.md` or `~/.codex/agents/apiary-doc-reviewer.toml`, selected by the Agent. Why: dispatch the Doc Reviewer with its own instructions and required reads.
- **Product Manager definition:** `~/.claude/agents/apiary-product-manager.md` or `~/.codex/agents/apiary-product-manager.toml`, selected by the Agent. Why: dispatch the Product Manager with its own instructions and required reads.
- **Integration Tester definition:** `~/.claude/agents/apiary-integration-tester.md` or `~/.codex/agents/apiary-integration-tester.toml`, selected by the Agent. Why: dispatch the Integration Tester with its own instructions and required reads.
- **Epic work and requirements:** Ticket System selected by `ticket_system`: the input Epic ID, its Tasks and Subtasks, dependency Epics, parent Plan and its Epics, and the Idea and its Docs through the Plan’s source reference. Why: check gates, sequence Tasks, detect stale descriptions, dispatch work and determine Plan completion.
- **Progress and findings:** Ticket System selected by `ticket_system`: the Epic’s progress record, per-repo commits, warm Subagent IDs and recorded review feedback. Why: resume interrupted work and reconcile its progress with ticket state and git.
- **`build-commands.md`:** `<folder on the Guidance Document walk>/.apiary/build-commands.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/build-commands-default-fallback.md`. Why: run each changed repo’s Format command before committing Task or integration changes; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.
- **Build discovery references:** `<repo checkout>/README.md` and the CI configuration paths in that checkout, as directed by `~/.apiary/build-commands-default-fallback.md` when that fallback is used. Why: discover the repo’s commands when the fallback supplies none.
- **Checkout state and changes:** `<repo checkout>/<path>` selected by the Epic’s repo scope and recorded commits. Why: compare completed work to descriptions, inspect changes and commit the finished work per repo.
- **Subagent reports:** the executors’, Reviewers’, Product Manager’s and Integration Tester’s returned reports. Why: collect findings, choose fix rounds, decide the integration gate and report the end-of-Epic result.
- **Own context reading:** the context reading and freshness source named by the loaded Agent Protocol File. Why: check the context limit at each Task boundary after the first Task.

### State gate

Epic `defined` or `active`; every Epic it depends on `done`. A re-run on a `done` Epic may only finish the Plan's completion check.

### Owned transitions

**Idea:** develop-epic sets `active` when starting an Epic

**Plan:** develop-epic sets `active` when starting an Epic

**Plan:** develop-epic sets `done` when finishing an Epic leaves every Epic in the Plan `done`

**Epic:** develop-epic sets `active`, then `done`.

**Task:** develop-epic also creates integration fix Tasks `draft`, sets their `thinking_level:` tags and sets them `defined`

**Task:** develop-epic sets Tasks `active`, then `done`

**Task:** `done` requires every Subtask to be `done`.

**Subtask (context):** write-epic creates `draft`, then sets `defined` for its Tasks; develop-epic does the same for its integration fix Tasks

### Specific rules

Before each Task after the first, develop-epic checks its own context use per the Agent Protocol File. At 75% or more, or a reading older than its freshness window, stop at that Task boundary and name the re-run for a new session. The Managing Intelligence restarts it, through the Launcher for a Worker, per its Launcher Protocol File. With no reading, continue and report it.

**Tag (`thinking_level:<label>`):** write-epic and develop-epic set their Tasks' tags

## idea-review

### Reads

- **Skill instructions:** `~/.claude/skills/idea-review/SKILL.md` or `~/.agents/skills/idea-review/SKILL.md`, selected by the Agent. Why: apply this skill’s input, state gate, owned transitions, checks and reporting rules.
- **Workflow:** `~/.apiary/system/workflow.md`. Why: apply the shared startup, path, status, Guidance Document and reporting rules.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` or `~/.apiary/system/protocols/agent-codex.md`, selected by the running Agent. Why: follow the Agent’s operations and reporting rules and dispatch and resume its Subagents.
- **`ticket_system` setting:** `ticket_system` in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: select the Ticket System Protocol File for this Run.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: find the Plan by source reference, read review progress and file a Round Feedback Epic when required.
- **`levels_<agent>` setting:** `levels_claude_code` or `levels_codex`, selected by the running Agent, in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: validate the running Agent’s Thinking Level mapping and map dispatched Thinking Levels to model and effort.
- **`thinking_levels` setting:** `thinking_levels` in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: check the `idea-review` line and the dispatched Subagent Role lines (`Code Reviewer`, `Test Reviewer`, `Doc Reviewer`, `Product Manager`) before starting work.
- **Code Reviewer definition:** `~/.claude/agents/apiary-code-reviewer.md` or `~/.codex/agents/apiary-code-reviewer.toml`, selected by the Agent. Why: dispatch the Code Reviewer with its own instructions and required reads.
- **Test Reviewer definition:** `~/.claude/agents/apiary-test-reviewer.md` or `~/.codex/agents/apiary-test-reviewer.toml`, selected by the Agent. Why: dispatch the Test Reviewer with its own instructions and required reads.
- **Doc Reviewer definition:** `~/.claude/agents/apiary-doc-reviewer.md` or `~/.codex/agents/apiary-doc-reviewer.toml`, selected by the Agent. Why: dispatch the Doc Reviewer with its own instructions and required reads.
- **Product Manager definition:** `~/.claude/agents/apiary-product-manager.md` or `~/.codex/agents/apiary-product-manager.toml`, selected by the Agent. Why: dispatch the Product Manager with its own instructions and required reads.
- **Idea, Docs, Plan and Epics:** Ticket System selected by `ticket_system`: the input Idea ID, every Doc child, the Plan whose source reference is that ID, and all of its Epics. Why: check the completion gate, recover acceptance criteria and collect commits and deferred findings.
- **Round progress and earlier feedback:** Ticket System selected by `ticket_system`: the Idea’s progress record and the Plan’s Round Feedback Epics. Why: resume the round and identify findings that earlier rounds were meant to fix.
- **`build-commands.md`:** `<folder on the Guidance Document walk>/.apiary/build-commands.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/build-commands-default-fallback.md`. Why: run the commands needed to demonstrate the Idea’s acceptance criteria; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.
- **Build discovery references:** `<repo checkout>/README.md` and the CI configuration paths in that checkout, as directed by `~/.apiary/build-commands-default-fallback.md` when that fallback is used. Why: discover the repo’s commands when the fallback supplies none.
- **Finished product and git history:** `<repo checkout>/<path>` selected by the union of commits recorded on the Plan’s Epics in each repo. Why: establish the whole-change scope, check worktree merge state and demonstrate the finished behaviour.
- **Review reports:** the Code, Test and Doc Reviewers’ and Product Manager’s returned reports. Why: classify findings and copy non-trivial findings verbatim into the round’s Epic.

### State gate

Plan `done`; no worktree of its Epics still unmerged.

### Owned transitions

**Plan:** idea-review sets `done` → `active` when it files a Round Feedback Epic.

**Epic:** write-plan creates `draft`, and idea-review creates a Round Feedback Epic `draft`

### Specific rules

None specified in the source workflow.

## fix-bug

### Reads

- **Skill instructions:** `~/.claude/skills/fix-bug/SKILL.md` or `~/.agents/skills/fix-bug/SKILL.md`, selected by the Agent. Why: apply this skill’s input, state gate, owned transitions, checks and reporting rules.
- **Workflow:** `~/.apiary/system/workflow.md`. Why: apply the shared startup, path, status, Guidance Document and reporting rules.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` or `~/.apiary/system/protocols/agent-codex.md`, selected by the running Agent. Why: follow the Agent’s operations and reporting rules and dispatch and resume its Subagents.
- **`ticket_system` setting:** `ticket_system` in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: select the Ticket System Protocol File for this Run.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: read the Bug and its dependencies and maintain the Bug’s status, tag and progress record.
- **`levels_<agent>` setting:** `levels_claude_code` or `levels_codex`, selected by the running Agent, in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: validate the running Agent’s Thinking Level mapping and map dispatched Thinking Levels to model and effort.
- **`thinking_levels` setting:** `thinking_levels` in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: check the `fix-bug` line and the dispatched Subagent Role lines (`Code Reviewer`, `Test Reviewer`, `Doc Reviewer`, `Integration Tester`) before starting work.
- **Engineer definition:** `~/.claude/agents/apiary-engineer.md` or `~/.codex/agents/apiary-engineer.toml`, selected by the Agent. Why: dispatch the Engineer with its own instructions and required reads.
- **Test Writer definition:** `~/.claude/agents/apiary-test-writer.md` or `~/.codex/agents/apiary-test-writer.toml`, selected by the Agent. Why: dispatch the Test Writer with its own instructions and required reads.
- **Doc Writer definition:** `~/.claude/agents/apiary-doc-writer.md` or `~/.codex/agents/apiary-doc-writer.toml`, selected by the Agent. Why: dispatch the Doc Writer with its own instructions and required reads.
- **Code Reviewer definition:** `~/.claude/agents/apiary-code-reviewer.md` or `~/.codex/agents/apiary-code-reviewer.toml`, selected by the Agent. Why: dispatch the Code Reviewer with its own instructions and required reads.
- **Test Reviewer definition:** `~/.claude/agents/apiary-test-reviewer.md` or `~/.codex/agents/apiary-test-reviewer.toml`, selected by the Agent. Why: dispatch the Test Reviewer with its own instructions and required reads.
- **Doc Reviewer definition:** `~/.claude/agents/apiary-doc-reviewer.md` or `~/.codex/agents/apiary-doc-reviewer.toml`, selected by the Agent. Why: dispatch the Doc Reviewer with its own instructions and required reads.
- **Integration Tester definition:** `~/.claude/agents/apiary-integration-tester.md` or `~/.codex/agents/apiary-integration-tester.toml`, selected by the Agent. Why: dispatch the Integration Tester with its own instructions and required reads.
- **Bug, dependencies and progress:** Ticket System selected by `ticket_system`: the input Bug ID, its dependency tickets, validation evidence, Thinking Level tag and recorded worktree, commit, merge and Subagent progress. Why: check the gate, scope the fix and resume interrupted work.
- **Bug source references:** the external paths or URLs recorded on the Bug. Why: read context needed to understand the validated defect.
- **`build-commands.md`:** `<folder on the Guidance Document walk>/.apiary/build-commands.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/build-commands-default-fallback.md`. Why: run each changed repo’s Format command before committing the fix; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.
- **Build discovery references:** `<repo checkout>/README.md` and the CI configuration paths in that checkout, as directed by `~/.apiary/build-commands-default-fallback.md` when that fallback is used. Why: discover the repo’s commands when the fallback supplies none.
- **Fix and merge context:** `<repo checkout>/<path>` selected by the Bug’s scope in main checkouts and `<Project Folder>/.worktrees/<bug id>/<repo path>/`. Why: inspect the defect, reconcile progress with git and create, merge and clean up the fix’s worktrees.
- **Subagent reports:** the executors’, Reviewers’ and Integration Tester’s returned reports. Why: collect fixes and review findings, assess integration and report the merged result.

### State gate

Bug `defined`, or `active` when resuming; every ticket it depends on `done`.

### Owned transitions

**Bug:** fix-bug sets `active`

### Specific rules

None specified in the source workflow.

## research

### Reads

- **Skill instructions:** `~/.claude/skills/research/SKILL.md` or `~/.agents/skills/research/SKILL.md`, selected by the Agent. Why: apply this skill’s input, state gate, owned transitions, checks and reporting rules.
- **Workflow:** `~/.apiary/system/workflow.md`. Why: apply the shared startup, path, status, Guidance Document and reporting rules.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` or `~/.apiary/system/protocols/agent-codex.md`, selected by the running Agent. Why: follow the Agent’s operations and reporting rules.
- **`ticket_system` setting:** `ticket_system` in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: select the Ticket System Protocol File for this Run.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: file or continue the Research ticket and Report, record review rounds and resolve the artifacts location.
- **`levels_<agent>` setting:** `levels_claude_code` or `levels_codex`, selected by the running Agent, in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: validate the running Agent’s Thinking Level mapping.
- **`thinking_levels` setting:** `thinking_levels` in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: check the `research` line before starting work.
- **Research ticket, Report and review log:** Ticket System selected by `ticket_system`: the supplied Research ticket ID and its Report child, when continuing. Why: recover the question, scope, prior evidence and reviewer requests.
- **Research input and evidence:** the supplied question and reviewer feedback; cited sources and artifact paths selected by that question, with the artifacts location given by the Ticket System Protocol File. Why: answer the scoped question, support citations and revise the Report through acceptance.

### State gate

None specified in the source workflow.

### Owned transitions

**Research ticket and Report:** research creates the Research ticket `defined`, sets it `active` during review rounds, sets it `done` when the reviewer accepts, and reopens it as `active` when a reviewer asks for more work

**Research ticket and Report:** the Report, created with the first round, carries the Research ticket's status.

### Specific rules

None specified in the source workflow.

## configure-worktree

### Reads

- **Skill instructions:** `~/.claude/skills/configure-worktree/SKILL.md` or `~/.agents/skills/configure-worktree/SKILL.md`, selected by the Agent. Why: apply this skill’s input, state gate, owned transitions, checks and reporting rules.
- **Workflow:** `~/.apiary/system/workflow.md`. Why: apply the shared startup, path, status, Guidance Document and reporting rules.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` or `~/.apiary/system/protocols/agent-codex.md`, selected by the running Agent. Why: follow the Agent’s operations and reporting rules.
- **`ticket_system` setting:** `ticket_system` in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: select the Ticket System Protocol File for this Run.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: read the Idea or Epic, check its state and recover the work’s repo context.
- **`levels_<agent>` setting:** `levels_claude_code` or `levels_codex`, selected by the running Agent, in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: validate the running Agent’s Thinking Level mapping.
- **`thinking_levels` setting:** `thinking_levels` in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: check the `configure-worktree` line before starting work.
- **`launcher` setting:** `launcher` in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: select the Launcher Protocol File when launching a Worker.
- **Launcher Protocol File:** `~/.apiary/system/protocols/launcher-<launcher>.md`, selected by `launcher`, when launching a Worker. Why: start the Worker in the ticket’s worktree folder using the required Agent, model and effort.
- **`levels_<Worker Agent>` setting:** `levels_claude_code` or `levels_codex`, selected by the Worker Agent named by the Launcher Protocol File, in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: map the Worker’s Thinking Level for the Agent named by the Launcher Protocol File, when launching a Worker.
- **Worker skill Thinking Level:** `thinking_levels` in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`, at the skill named in the Worker prompt. Why: select the Worker’s Thinking Level before launching it.
- **Idea or Epic context:** Ticket System selected by `ticket_system`: the supplied Idea or Epic ID and its planning context. Why: check the state gate and identify which repos need worktrees.
- **Worktree and branch state:** `<Project Folder>/<repo path>/` and `<Project Folder>/.worktrees/<ticket id>/<repo path>/`, selected by the ticket and supplied repo list. Why: read git’s current branches and worktree records to choose each base and reuse existing worktrees.
- **Worker prompt:** the supplied prompt naming the Worker’s skill, when launching a Worker. Why: identify the skill whose Thinking Level applies and pass the intended work to the Worker.

### State gate

Idea or Epic `defined` or `active`.

### Owned transitions

None specified in the source workflow.

### Specific rules

At startup, a Run checks the `levels_<agent>` mapping for its Agent and the `thinking_levels` lines for its skill, each non-executor Subagent Role it dispatches and, for configure-worktree, its Worker's skill.

## teardown-worktree

### Reads

- **Skill instructions:** `~/.claude/skills/teardown-worktree/SKILL.md` or `~/.agents/skills/teardown-worktree/SKILL.md`, selected by the Agent. Why: apply this skill’s input, state gate, owned transitions, checks and reporting rules.
- **Workflow:** `~/.apiary/system/workflow.md`. Why: apply the shared startup, path, status, Guidance Document and reporting rules.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` or `~/.apiary/system/protocols/agent-codex.md`, selected by the running Agent. Why: follow the Agent’s operations and reporting rules.
- **`ticket_system` setting:** `ticket_system` in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: select the Ticket System Protocol File for this Run.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`. Why: read the Idea or Epic’s status and worktree context before merging.
- **`launcher` setting:** `launcher` in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`, outside worktree-only mode. Why: select the Launcher Protocol File for inspecting and stopping Workers.
- **Launcher Protocol File:** `~/.apiary/system/protocols/launcher-<launcher>.md`, selected by `launcher`, outside worktree-only mode. Why: to stop the Worker configure-worktree launched.
- **`levels_<agent>` setting:** `levels_claude_code` or `levels_codex`, selected by the running Agent, in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: validate the running Agent’s Thinking Level mapping.
- **`thinking_levels` setting:** `thinking_levels` in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: check the `teardown-worktree` line before starting work.
- **Idea or Epic:** Ticket System selected by `ticket_system`: the supplied Idea or Epic ID. Why: check that the ticket is done before merging its worktrees.
- **Worktree, branch and merge state:** `<Project Folder>/.worktrees/<ticket id>/<repo path>/` and `<Project Folder>/<repo path>/` for every repo under the ticket’s worktree folder. Why: find all worktrees, identify merge targets, inspect uncommitted changes and resume past repos already merged.

### State gate

Merge an Idea's worktrees only once the Idea is `done`, and an Epic's only once the Epic is `done`.

### Owned transitions

None specified in the source workflow.

### Specific rules

None specified in the source workflow.

## release

### Reads

- **Skill instructions:** `~/.claude/skills/release/SKILL.md` or `~/.agents/skills/release/SKILL.md`, selected by the Agent. Why: apply this skill’s input, state gate, owned transitions, checks and reporting rules.
- **Workflow:** `~/.apiary/system/workflow.md`. Why: apply the shared startup, path, status, Guidance Document and reporting rules.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` or `~/.apiary/system/protocols/agent-codex.md`, selected by the running Agent. Why: follow the Agent’s operations and reporting rules.
- **`ticket_system` setting:** `ticket_system` in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: select the Ticket System Protocol File for this Run, when `release-guide.md` requires ticket work.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, selected by `ticket_system`, when `release-guide.md` requires ticket work. Why: perform the ticket reads and writes required by the Project’s release process.
- **`levels_<agent>` setting:** `levels_claude_code` or `levels_codex`, selected by the running Agent, in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: validate the running Agent’s Thinking Level mapping.
- **`thinking_levels` setting:** `thinking_levels` in `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: check the `release` line before starting work.
- **`release-guide.md`:** `<folder on the Guidance Document walk>/.apiary/release-guide.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/release-guide-default-fallback.md`. Why: obtain the release input, conditions, process, human approvals, ticket operations and next step; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.
- **Release process references:** the file paths, repo paths and ticket IDs named by the loaded `release-guide.md` copies, with file pointers resolved by `~/.apiary/system/workflow.md`. Why: read the artifacts and instructions needed for this Project’s release process.

### State gate

None specified in the source workflow.

### Owned transitions

None specified in the source workflow.

### Specific rules

None specified in the source workflow.

## Engineer

### Reads

- **Subagent definition:** `~/.claude/agents/apiary-engineer.md` or `~/.codex/agents/apiary-engineer.toml`, selected by the Agent. Why: apply this Subagent Role’s scope, checks and report requirements.
- **Workflow:** `~/.apiary/system/workflow.md`. Why: apply the shared path, handoff, Guidance Document and Subagent rules.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` or `~/.apiary/system/protocols/agent-codex.md`, selected by the running Agent, as named in the dispatch prompt. Why: follow the Agent’s operations and reporting rules using the caller’s resolved Protocol File.
- **`ticket_system` setting:** `ticket_system` supplied in the dispatch prompt from `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: use the caller’s selected Ticket System for the assigned ticket work.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, as named in the dispatch prompt. Why: read assigned Subtasks and their parent Task, and set each worked Subtask active then done; read the Bug when dispatched for a fix.
- **Dispatch input and reports:** the caller’s dispatch or resume prompt and the reports it includes. Why: receive the assigned scope, repo checkout paths, Task or Bug Thinking Level and prior findings for the current pass.
- **Assigned work:** Ticket System selected by `ticket_system`: Subtask IDs and their Task, or the Bug ID, named in the dispatch prompt. Why: read acceptance criteria, Key Files and the Task’s or Bug’s Thinking Level tag.
- **`engineering-best-practices.md`:** `<folder on the Guidance Document walk>/.apiary/engineering-best-practices.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/engineering-best-practices-default-fallback.md`. Why: apply coding standards to the source changes; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.
- **`build-commands.md`:** `<folder on the Guidance Document walk>/.apiary/build-commands.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/build-commands-default-fallback.md`. Why: run Compile / type-check, Lint and Narrow test commands while implementing; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.
- **Build discovery references:** `<repo checkout>/README.md` and the CI configuration paths in that checkout, as directed by `~/.apiary/build-commands-default-fallback.md` when that fallback is used. Why: discover the repo’s commands when the fallback supplies none.
- **Source context:** `<repo checkout>/<path>` selected by the assigned Key Files or Bug scope. Why: understand affected modules, interfaces and existing behaviour before changing code.

### State gate

None specified in the source workflow.

### Owned transitions

**Subtask:** the executor working it sets `active`, then `done`.

### Specific rules

None specified in the source workflow.

## Test Writer

### Reads

- **Subagent definition:** `~/.claude/agents/apiary-test-writer.md` or `~/.codex/agents/apiary-test-writer.toml`, selected by the Agent. Why: apply this Subagent Role’s scope, checks and report requirements.
- **Workflow:** `~/.apiary/system/workflow.md`. Why: apply the shared path, handoff, Guidance Document and Subagent rules.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` or `~/.apiary/system/protocols/agent-codex.md`, selected by the running Agent, as named in the dispatch prompt. Why: follow the Agent’s operations and reporting rules using the caller’s resolved Protocol File.
- **`ticket_system` setting:** `ticket_system` supplied in the dispatch prompt from `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: use the caller’s selected Ticket System for the assigned ticket work.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, as named in the dispatch prompt. Why: read assigned Subtasks and their parent Task, and set each worked Subtask active then done; read the Bug when dispatched for a fix.
- **Dispatch input and reports:** the caller’s dispatch or resume prompt and the reports it includes. Why: receive the assigned scope, repo checkout paths, Task or Bug Thinking Level and prior findings for the current pass.
- **Assigned work:** Ticket System selected by `ticket_system`: Subtask IDs and their Task, or the Bug ID, named in the dispatch prompt. Why: read acceptance criteria, Key Files and the Task’s or Bug’s Thinking Level tag.
- **`test-guide.md`:** `<folder on the Guidance Document walk>/.apiary/test-guide.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/test-guide-default-fallback.md`. Why: apply unit test patterns, coverage requirements and proportionality to the assigned lane; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.
- **`build-commands.md`:** `<folder on the Guidance Document walk>/.apiary/build-commands.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/build-commands-default-fallback.md`. Why: run Narrow test while iterating and Full test when this is the pass’s last Test Writer; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.
- **Build discovery references:** `<repo checkout>/README.md` and the CI configuration paths in that checkout, as directed by `~/.apiary/build-commands-default-fallback.md` when that fallback is used. Why: discover the repo’s commands when the fallback supplies none.
- **Tests, fixtures and source changes:** `<repo checkout>/<path>` selected by the assigned lane, the current diff and the Bug’s reproduction steps when supplied. Why: write meaningful unit tests, respect lane ownership, demonstrate the Bug regression and diagnose suite failures.

### State gate

None specified in the source workflow.

### Owned transitions

**Subtask:** the executor working it sets `active`, then `done`.

### Specific rules

None specified in the source workflow.

## Doc Writer

### Reads

- **Subagent definition:** `~/.claude/agents/apiary-doc-writer.md` or `~/.codex/agents/apiary-doc-writer.toml`, selected by the Agent. Why: apply this Subagent Role’s scope, checks and report requirements.
- **Workflow:** `~/.apiary/system/workflow.md`. Why: apply the shared path, handoff, Guidance Document and Subagent rules.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` or `~/.apiary/system/protocols/agent-codex.md`, selected by the running Agent, as named in the dispatch prompt. Why: follow the Agent’s operations and reporting rules using the caller’s resolved Protocol File.
- **`ticket_system` setting:** `ticket_system` supplied in the dispatch prompt from `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: use the caller’s selected Ticket System for the assigned ticket work.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, as named in the dispatch prompt. Why: read assigned Subtasks and their parent Task, and set each worked Subtask active then done; read the Bug when dispatched for a fix.
- **Dispatch input and reports:** the caller’s dispatch or resume prompt and the reports it includes. Why: receive the assigned scope, repo checkout paths, Task or Bug Thinking Level and prior findings for the current pass.
- **Assigned work:** Ticket System selected by `ticket_system`: Subtask IDs and their Task, or the Bug ID, named in the dispatch prompt. Why: read acceptance criteria, Key Files and the Task’s or Bug’s Thinking Level tag.
- **`doc-writing-guide.md`:** `<folder on the Guidance Document walk>/.apiary/doc-writing-guide.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/doc-writing-guide-default-fallback.md`. Why: apply documentation style, language and allowed-file rules; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.
- **`maintained-docs.md`:** `<folder on the Guidance Document walk>/.apiary/maintained-docs.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/maintained-docs-default-fallback.md`. Why: identify the contributor and customer docs affected by the work; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.
- **Maintained documentation:** the paths listed in the loaded `maintained-docs.md` copies, resolved in the repo checkout by `~/.apiary/system/workflow.md`. Why: read the existing documentation to establish what the work must update.
- **Source and test changes:** `<repo checkout>/<path>` selected by the assigned work and current diff. Why: identify behaviour and design changes the documentation must explain.
- **Engineer report:** the Engineer’s report passed by the calling skill. Why: include the design and documentation impacts flagged by the Engineer.

### State gate

None specified in the source workflow.

### Owned transitions

**Subtask:** the executor working it sets `active`, then `done`.

### Specific rules

None specified in the source workflow.

## Engineer planner

### Reads

- **Subagent definition:** `~/.claude/agents/apiary-engineer-planner.md` or `~/.codex/agents/apiary-engineer-planner.toml`, selected by the Agent. Why: apply this Subagent Role’s scope, checks and report requirements.
- **Workflow:** `~/.apiary/system/workflow.md`. Why: apply the shared path, handoff, Guidance Document and Subagent rules.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` or `~/.apiary/system/protocols/agent-codex.md`, selected by the running Agent, as named in the dispatch prompt. Why: follow the Agent’s operations and reporting rules using the caller’s resolved Protocol File.
- **Dispatch input and reports:** the caller’s dispatch or resume prompt and the reports it includes. Why: read the proposed Task, Epic and Idea requirements supplied by write-epic, repo paths and the Managing Intelligence’s decisions to propose scoped Subtasks.
- **`engineering-best-practices.md`:** `<folder on the Guidance Document walk>/.apiary/engineering-best-practices.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/engineering-best-practices-default-fallback.md`. Why: propose code Subtasks consistent with the repo’s engineering rules; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.
- **Code planning context:** `<repo checkout>/<path>` selected by the proposed Task’s scope in the named repos. Why: identify concrete source Key Files and the code work needed for the Task.

### State gate

None specified in the source workflow.

### Owned transitions

None specified in the source workflow.

### Specific rules

None specified in the source workflow.

## Test Writer planner

### Reads

- **Subagent definition:** `~/.claude/agents/apiary-test-writer-planner.md` or `~/.codex/agents/apiary-test-writer-planner.toml`, selected by the Agent. Why: apply this Subagent Role’s scope, checks and report requirements.
- **Workflow:** `~/.apiary/system/workflow.md`. Why: apply the shared path, handoff, Guidance Document and Subagent rules.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` or `~/.apiary/system/protocols/agent-codex.md`, selected by the running Agent, as named in the dispatch prompt. Why: follow the Agent’s operations and reporting rules using the caller’s resolved Protocol File.
- **Dispatch input and reports:** the caller’s dispatch or resume prompt and the reports it includes. Why: read the proposed Task, Epic and Idea requirements supplied by write-epic, repo paths and the Managing Intelligence’s decisions to propose scoped Subtasks.
- **`test-guide.md`:** `<folder on the Guidance Document walk>/.apiary/test-guide.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/test-guide-default-fallback.md`. Why: propose unit test Subtasks in proportion to the Task’s risk; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.
- **Test planning context:** `<repo checkout>/<path>` selected by the proposed Task’s scope in the named repos. Why: identify tests, fixtures and helpers, concrete Key Files and independent test lanes.

### State gate

None specified in the source workflow.

### Owned transitions

None specified in the source workflow.

### Specific rules

None specified in the source workflow.

## Doc Writer planner

### Reads

- **Subagent definition:** `~/.claude/agents/apiary-doc-writer-planner.md` or `~/.codex/agents/apiary-doc-writer-planner.toml`, selected by the Agent. Why: apply this Subagent Role’s scope, checks and report requirements.
- **Workflow:** `~/.apiary/system/workflow.md`. Why: apply the shared path, handoff, Guidance Document and Subagent rules.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` or `~/.apiary/system/protocols/agent-codex.md`, selected by the running Agent, as named in the dispatch prompt. Why: follow the Agent’s operations and reporting rules using the caller’s resolved Protocol File.
- **Dispatch input and reports:** the caller’s dispatch or resume prompt and the reports it includes. Why: read the proposed Task, Epic and Idea requirements supplied by write-epic, repo paths and the Managing Intelligence’s decisions to propose scoped Subtasks.
- **`doc-writing-guide.md`:** `<folder on the Guidance Document walk>/.apiary/doc-writing-guide.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/doc-writing-guide-default-fallback.md`. Why: propose documentation Subtasks consistent with writing rules and allowed files; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.
- **`maintained-docs.md`:** `<folder on the Guidance Document walk>/.apiary/maintained-docs.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/maintained-docs-default-fallback.md`. Why: identify the contributor and customer docs affected by the work; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.
- **Maintained documentation:** the paths listed in the loaded `maintained-docs.md` copies, resolved in the repo checkout by `~/.apiary/system/workflow.md`. Why: read the existing documentation to establish what the work must update.
- **Product context:** `<repo checkout>/<path>` selected by the proposed Task’s scope in the named repos. Why: identify which behaviour and design changes require documentation.

### State gate

None specified in the source workflow.

### Owned transitions

None specified in the source workflow.

### Specific rules

None specified in the source workflow.

## Code Reviewer

### Reads

- **Subagent definition:** `~/.claude/agents/apiary-code-reviewer.md` or `~/.codex/agents/apiary-code-reviewer.toml`, selected by the Agent. Why: apply this Subagent Role’s scope, checks and report requirements.
- **Workflow:** `~/.apiary/system/workflow.md`. Why: apply the shared path, handoff, Guidance Document and Subagent rules.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` or `~/.apiary/system/protocols/agent-codex.md`, selected by the running Agent, as named in the dispatch prompt. Why: follow the Agent’s operations and reporting rules using the caller’s resolved Protocol File.
- **`ticket_system` setting:** `ticket_system` supplied in the dispatch prompt from `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: use the caller’s selected Ticket System for the assigned ticket work.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, as named in the dispatch prompt. Why: read the assigned Task, Idea or Bug and resolve the corresponding change scope; for an Idea, read its Plan’s Epic commit records.
- **Dispatch input and reports:** the caller’s dispatch or resume prompt and the reports it includes. Why: receive checkout paths and the changed-work scope selected after a fix round.
- **Review scope:** Ticket System selected by `ticket_system`: the Task, Idea or Bug ID in the dispatch prompt; for an Idea, its Plan and Epics found by source reference. Why: determine the uncommitted Task changes, whole-Idea commits or Bug worktree changes to review.
- **`engineering-best-practices.md`:** `<folder on the Guidance Document walk>/.apiary/engineering-best-practices.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/engineering-best-practices-default-fallback.md`. Why: judge source changes against the repo’s coding rules; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.
- **`build-commands.md`:** `<folder on the Guidance Document walk>/.apiary/build-commands.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/build-commands-default-fallback.md`. Why: run the Lint command and include its findings in the code review; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.
- **Build discovery references:** `<repo checkout>/README.md` and the CI configuration paths in that checkout, as directed by `~/.apiary/build-commands-default-fallback.md` when that fallback is used. Why: discover the repo’s commands when the fallback supplies none.
- **Source changes and context:** `<repo checkout>/<path>` selected by the assigned ticket’s diff or recorded commits. Why: review correctness, surrounding interfaces and unnecessary code.

### State gate

None specified in the source workflow.

### Owned transitions

None specified in the source workflow.

### Specific rules

None specified in the source workflow.

## Test Reviewer

### Reads

- **Subagent definition:** `~/.claude/agents/apiary-test-reviewer.md` or `~/.codex/agents/apiary-test-reviewer.toml`, selected by the Agent. Why: apply this Subagent Role’s scope, checks and report requirements.
- **Workflow:** `~/.apiary/system/workflow.md`. Why: apply the shared path, handoff, Guidance Document and Subagent rules.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` or `~/.apiary/system/protocols/agent-codex.md`, selected by the running Agent, as named in the dispatch prompt. Why: follow the Agent’s operations and reporting rules using the caller’s resolved Protocol File.
- **`ticket_system` setting:** `ticket_system` supplied in the dispatch prompt from `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: use the caller’s selected Ticket System for the assigned ticket work.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, as named in the dispatch prompt. Why: read the assigned Task, Idea or Bug and resolve the corresponding change scope; for an Idea, read its Plan’s Epic commit records.
- **Dispatch input and reports:** the caller’s dispatch or resume prompt and the reports it includes. Why: receive checkout paths and the changed-work scope selected after a fix round.
- **Review scope:** Ticket System selected by `ticket_system`: the Task, Idea or Bug ID in the dispatch prompt; for an Idea, its Plan and Epics found by source reference. Why: determine the uncommitted Task changes, whole-Idea commits or Bug worktree changes to review.
- **`test-guide.md`:** `<folder on the Guidance Document walk>/.apiary/test-guide.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/test-guide-default-fallback.md`. Why: judge changed tests against test patterns, coverage rules and proportion to risk; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.
- **Test changes and whole suite:** `<repo checkout>/<path>` selected by the assigned ticket’s diff or recorded commits. Why: assess coverage, duplication and fixture use against the whole existing suite and relevant source behaviour.

### State gate

None specified in the source workflow.

### Owned transitions

None specified in the source workflow.

### Specific rules

None specified in the source workflow.

## Doc Reviewer

### Reads

- **Subagent definition:** `~/.claude/agents/apiary-doc-reviewer.md` or `~/.codex/agents/apiary-doc-reviewer.toml`, selected by the Agent. Why: apply this Subagent Role’s scope, checks and report requirements.
- **Workflow:** `~/.apiary/system/workflow.md`. Why: apply the shared path, handoff, Guidance Document and Subagent rules.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` or `~/.apiary/system/protocols/agent-codex.md`, selected by the running Agent, as named in the dispatch prompt. Why: follow the Agent’s operations and reporting rules using the caller’s resolved Protocol File.
- **`ticket_system` setting:** `ticket_system` supplied in the dispatch prompt from `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: use the caller’s selected Ticket System for the assigned ticket work.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, as named in the dispatch prompt. Why: read the assigned Task, Idea or Bug and resolve the corresponding change scope; for an Idea, read its Plan’s Epic commit records.
- **Dispatch input and reports:** the caller’s dispatch or resume prompt and the reports it includes. Why: receive checkout paths and the changed-work scope selected after a fix round.
- **Review scope:** Ticket System selected by `ticket_system`: the Task, Idea or Bug ID in the dispatch prompt; for an Idea, its Plan and Epics found by source reference. Why: determine the uncommitted Task changes, whole-Idea commits or Bug worktree changes to review.
- **`doc-writing-guide.md`:** `<folder on the Guidance Document walk>/.apiary/doc-writing-guide.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/doc-writing-guide-default-fallback.md`. Why: check every touched document in full for writing-rule breaches; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.
- **`maintained-docs.md`:** `<folder on the Guidance Document walk>/.apiary/maintained-docs.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/maintained-docs-default-fallback.md`. Why: identify the contributor and customer docs affected by the work; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.
- **Maintained documentation:** the paths listed in the loaded `maintained-docs.md` copies, resolved in the repo checkout by `~/.apiary/system/workflow.md`. Why: read the existing documentation to establish what the work must update.
- **Complete touched docs and product changes:** `<repo checkout>/<path>` selected by the assigned ticket’s diff or recorded commits. Why: re-read touched docs in full and identify documentation made wrong or left missing by the change.

### State gate

None specified in the source workflow.

### Owned transitions

None specified in the source workflow.

### Specific rules

None specified in the source workflow.

## Product Manager

### Reads

- **Subagent definition:** `~/.claude/agents/apiary-product-manager.md` or `~/.codex/agents/apiary-product-manager.toml`, selected by the Agent. Why: apply this Subagent Role’s scope, checks and report requirements.
- **Workflow:** `~/.apiary/system/workflow.md`. Why: apply the shared path, handoff, Guidance Document and Subagent rules.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` or `~/.apiary/system/protocols/agent-codex.md`, selected by the running Agent, as named in the dispatch prompt. Why: follow the Agent’s operations and reporting rules using the caller’s resolved Protocol File.
- **`ticket_system` setting:** `ticket_system` supplied in the dispatch prompt from `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: use the caller’s selected Ticket System for the assigned ticket work.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, as named in the dispatch prompt. Why: read every Doc child of the Idea and the Plan, Epic, Tasks and Subtasks involved in the assigned product check.
- **Dispatch input and reports:** the caller’s dispatch or resume prompt and the reports it includes. Why: identify the calling skill’s product check and receive the work and reports to assess.
- **Product requirements and planned work:** Ticket System selected by `ticket_system`: the Idea and every Doc child, plus the Plan, Epic, Tasks and Subtasks selected by the dispatch. Why: compare scope, size, behaviour and acceptance criteria to the product’s stated requirements.
- **Product changes and recorded commits:** `<repo checkout>/<path>` selected by the dispatched scope and, for the end-of-Epic check, the Epic’s per-repo commit records. Why: assess delivered behaviour and count added product, test and documentation lines for disproportion.

### State gate

None specified in the source workflow.

### Owned transitions

None specified in the source workflow.

### Specific rules

None specified in the source workflow.

## Requirements Reviewer

### Reads

- **Subagent definition:** `~/.claude/agents/apiary-req-reviewer.md` or `~/.codex/agents/apiary-req-reviewer.toml`, selected by the Agent. Why: apply this Subagent Role’s scope, checks and report requirements.
- **Workflow:** `~/.apiary/system/workflow.md`. Why: apply the shared path, handoff, Guidance Document and Subagent rules.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` or `~/.apiary/system/protocols/agent-codex.md`, selected by the running Agent, as named in the dispatch prompt. Why: follow the Agent’s operations and reporting rules using the caller’s resolved Protocol File.
- **`ticket_system` setting:** `ticket_system` supplied in the dispatch prompt from `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: use the caller’s selected Ticket System for the assigned ticket work.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, as named in the dispatch prompt. Why: read the Idea and every Doc child to assess requirements and readiness.
- **Dispatch input and reports:** the caller’s dispatch or resume prompt and the reports it includes. Why: receive the Idea to review and its repo context from req-review.
- **Idea and every Doc child:** Ticket System selected by `ticket_system`: the Idea ID in the dispatch and all its Doc children. Why: check stated intent, consistency, completeness, testability, scope and readiness, including PRD structure and SRD model coverage.
- **Codebase context:** `<repo checkout>/<path>` selected by the Idea’s scope in the Project’s repos. Why: check that requirements are grounded in the current software and buildable from the Docs.

### State gate

None specified in the source workflow.

### Owned transitions

None specified in the source workflow.

### Specific rules

None specified in the source workflow.

## TLA+ Writer

### Reads

- **Subagent definition:** `~/.claude/agents/apiary-tla-writer.md` or `~/.codex/agents/apiary-tla-writer.toml`, selected by the Agent. Why: apply this Subagent Role’s scope, checks and report requirements.
- **Workflow:** `~/.apiary/system/workflow.md`. Why: apply the shared path, handoff, Guidance Document and Subagent rules.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` or `~/.apiary/system/protocols/agent-codex.md`, selected by the running Agent, as named in the dispatch prompt. Why: follow the Agent’s operations and reporting rules using the caller’s resolved Protocol File.
- **`ticket_system` setting:** `ticket_system` supplied in the dispatch prompt from `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: use the caller’s selected Ticket System for the assigned ticket work.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, as named in the dispatch prompt. Why: find the existing spec for the assigned SRD part and create or update its defined TLA+ spec Doc.
- **Dispatch input and reports:** the caller’s dispatch or resume prompt and the reports it includes. Why: receive the selected SRD part, its repo context and the requested model scope.
- **SRD and existing TLA+ spec:** Ticket System selected by `ticket_system`: the Idea and SRD IDs and selected part supplied by write-srd, plus that part’s existing TLA+ spec Doc. Why: model the assigned requirements and update the same part’s spec on revision.
- **`build-commands.md`:** `<folder on the Guidance Document walk>/.apiary/build-commands.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/build-commands-default-fallback.md`. Why: run the Model check command on the assigned model; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.
- **Build discovery references:** `<repo checkout>/README.md` and the CI configuration paths in that checkout, as directed by `~/.apiary/build-commands-default-fallback.md` when that fallback is used. Why: discover the repo’s commands when the fallback supplies none.
- **Model files and checker output:** the model and configuration paths passed to the Model check command from `build-commands.md`, and that command’s output. Why: inspect invariants and counterexamples and report a checked model or violated requirements.

### State gate

None specified in the source workflow.

### Owned transitions

**TLA+ spec Doc:** the TLA+ Writer, dispatched by write-srd, creates `defined`, one Doc per modelled SRD part

**TLA+ spec Doc:** revisiting that part updates its spec and leaves it `defined`. No other transition.

### Specific rules

None specified in the source workflow.

## TLA+ Reviewer

### Reads

- **Subagent definition:** `~/.claude/agents/apiary-tla-reviewer.md` or `~/.codex/agents/apiary-tla-reviewer.toml`, selected by the Agent. Why: apply this Subagent Role’s scope, checks and report requirements.
- **Workflow:** `~/.apiary/system/workflow.md`. Why: apply the shared path, handoff, Guidance Document and Subagent rules.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` or `~/.apiary/system/protocols/agent-codex.md`, selected by the running Agent, as named in the dispatch prompt. Why: follow the Agent’s operations and reporting rules using the caller’s resolved Protocol File.
- **`ticket_system` setting:** `ticket_system` supplied in the dispatch prompt from `<Project Folder>/.apiary/project_settings.md`, else `~/.apiary/default_project_settings.md`. Why: use the caller’s selected Ticket System for the assigned ticket work.
- **Ticket System Protocol File:** `~/.apiary/system/protocols/ticket-<ticket_system>.md`, as named in the dispatch prompt. Why: read the assigned TLA+ spec Doc and the SRD part it models.
- **Dispatch input and reports:** the caller’s dispatch or resume prompt and the reports it includes. Why: identify the one model and SRD part assigned by req-review.
- **TLA+ spec and SRD:** Ticket System selected by `ticket_system`: the spec Doc and SRD IDs supplied in the dispatch prompt. Why: check model fidelity to the requirements and whether its invariants are meaningful.

### State gate

None specified in the source workflow.

### Owned transitions

None specified in the source workflow.

### Specific rules

None specified in the source workflow.

## Integration Tester

### Reads

- **Subagent definition:** `~/.claude/agents/apiary-integration-tester.md` or `~/.codex/agents/apiary-integration-tester.toml`, selected by the Agent. Why: apply this Subagent Role’s scope, checks and report requirements.
- **Workflow:** `~/.apiary/system/workflow.md`. Why: apply the shared path, handoff, Guidance Document and Subagent rules.
- **Agent Protocol File:** `~/.apiary/system/protocols/agent-claude-code.md` or `~/.apiary/system/protocols/agent-codex.md`, selected by the running Agent, as named in the dispatch prompt. Why: follow the Agent’s operations and reporting rules using the caller’s resolved Protocol File.
- **Dispatch input and reports:** the caller’s dispatch or resume prompt and the reports it includes. Why: receive the gated Task, Epic or Bug changes, every changed repo and earlier integration failures from the calling skill.
- **`test-guide.md`:** `<folder on the Guidance Document walk>/.apiary/test-guide.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/test-guide-default-fallback.md`. Why: write integration tests in proportion to risk and apply the repo’s test patterns; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.
- **`build-commands.md`:** `<folder on the Guidance Document walk>/.apiary/build-commands.md`, every user copy found by `~/.apiary/system/workflow.md`; else `~/.apiary/build-commands-default-fallback.md`. Why: find and run the Integration test command in every repo the gated work changed; open its pointer targets at their stated paths, resolving repo-relative targets from the repo checkout.
- **Build discovery references:** `<repo checkout>/README.md` and the CI configuration paths in that checkout, as directed by `~/.apiary/build-commands-default-fallback.md` when that fallback is used. Why: discover the repo’s commands when the fallback supplies none.
- **Integration tests and changed interfaces:** `<repo checkout>/<path>` selected by the gated changes and Integration test command. Why: write and fix integration tests and distinguish test failures from source failures.
- **Integration discovery references:** `<repo checkout>/<path>` selected by repo documentation and CI configuration when the Integration test slot supplies no command. Why: locate the integration suites or establish that none was found.

### State gate

None specified in the source workflow.

### Owned transitions

None specified in the source workflow.

### Specific rules

None specified in the source workflow.

## Managing Intelligence

### State gate

None specified in the source workflow.

### Owned transitions

**Idea:** the Managing Intelligence sets `done` after testing the Idea.

**Other Doc (not PRD, SRD or TLA+ spec):** The Managing Intelligence creates `draft`

**Other Doc (not PRD, SRD or TLA+ spec):** the Managing Intelligence owns other changes.

**Bug:** write-bug or the Managing Intelligence creates `draft`, not yet validated

**Bug:** the Managing Intelligence sets `done` after checking the merged fix or agreeing with the invalidity note

**Bug:** the Managing Intelligence sets it back to `draft` to send it back to define-bug.

### Specific rules

None specified in the source workflow.
