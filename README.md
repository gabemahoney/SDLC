# Apiary 🐝

Apiary is a workflow of skills for Claude Code and Codex CLI. It takes an Idea from PRD to SRD, Plan, Epics, code and review, and fixes Bugs. A Managing Intelligence (you, or a bot acting for you) runs it, launching a Main Agent for each skill. Main Agents launch Child Agents to write and review code, tests and docs.

## Requirements

- Claude Code or Codex CLI
- [bees](https://github.com/gabemahoney/bees) for tickets
- [agent-director](https://github.com/gabemahoney/agent-director) and tmux to launch agents

## Install

```bash
git clone https://github.com/gabemahoney/apiary ~/projects/apiary
cd ~/projects/apiary
./install.sh --agent both
```

## Set up a Project

```bash
cd ~/projects/my-project
claude "/project-setup"
```

It sets up the Project's settings, ticket stores and guides with you.

## Use

Run each skill in its own Main Agent, such as `claude "/write-idea"`.

- **Idea:** write-idea → write-prd → write-srd → write-plan → configure-worktree → write-epic and develop-epic for each Epic → idea-review → your testing and acceptance → teardown-worktree → release.
- **Bug:** write-bug → define-bug → configure-worktree → fix-bug → your testing and acceptance → teardown-worktree → release.
- **Research:** research answers a question with a cited Report, revising it until you accept it.
