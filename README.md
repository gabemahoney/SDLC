# Apiary 🐝

Apiary is a workflow of skills for Claude Code and Codex CLI. It takes an Idea from requirements to reviewed, tested code, fixes Bugs, and answers research questions. You (or a bot acting for you) run one skill at a time; each skill launches its own agents to write and review the code, tests and docs.

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

Run each skill below in a fresh session, such as `claude "/write-idea"`, in the order shown. Each one tells you when it's done and what to run next.

**Build an Idea**

- **write-idea:** files your Idea as a ticket.
- **write-prd:** writes the product requirements with you.
- **write-srd:** turns them into software requirements.
- **write-plan:** splits the work into Epics.
- **configure-worktree:** makes a branch and worktree for the work.
- **write-epic:** breaks one Epic into Tasks. Run it, then develop-epic, once per Epic.
- **develop-epic:** builds, tests, reviews and commits one Epic.
- **idea-review:** reviews the finished Idea and files fixes for anything wrong. Then you test it and accept it.
- **teardown-worktree:** merges the branch and removes the worktree.
- **release:** releases it the way your Project's release guide says.

**Fix a Bug**

- **write-bug:** files your Bug report.
- **define-bug:** checks the docs to confirm it's a real Bug, not a design choice, and reproduces it.
- **configure-worktree:** makes a branch and worktree for the fix.
- **fix-bug:** writes a test that catches the Bug, then fixes and commits it. Then you test it and accept it.
- **teardown-worktree** and **release:** as for an Idea.

**Research**

- **research:** answers a question with a cited Report, revising it until you accept it.

## Customize

Run project-setup to change these, or edit the files in your Project's `.apiary/` folder. Put a guide in `~/.apiary/` to use it in every Project.

- **Guides:** your own rules for engineering, testing, docs, bug reports, research, build commands and releases. Apiary ships a default for each.
- **Guidance that lives where it belongs:** guides about the code (engineering rules, tests, build commands) are checked into the repo, so every contributor gets them, Apiary user or not. Your own setup (settings, generic guides you reuse across Projects, and pointers to the repo's guides) lives on your host, in the Project Folder's `.apiary`, so your repos stay free of Apiary.
- **Release:** how your work ships, and whether Apiary may push, tag or publish. By default it only merges to your local main.
- **Models and effort:** which model and effort each skill runs with, for Claude Code and Codex CLI.
- **PRD template:** the layout of your requirements documents.
- **Intake:** where new Ideas and Bugs come from, such as GitHub issues.
- **Tickets:** where and how tickets, Research and Reports are stored.
