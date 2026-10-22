#!/usr/bin/env bash
# Install Apiary skills for Main Agents and Child Agents.
# Shared files include the workflow, templates and Agent, Ticket System and Launcher protocols.
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./install.sh [--agent claude|codex|cursor|both|all] [--repo <path>] [--dry-run]

  --agent    Which flavour to install: claude (default), codex, cursor,
             both (Claude Code and Codex CLI), or all three.
  --repo     Install into one repository instead of your user-level folders.
  --dry-run  Print every action; write nothing.

Claude Code:  skills/<name>/ -> ~/.claude/skills/<name>/
              (--repo: <repo>/.claude/skills)
Codex CLI:    skills/<name>/ -> ~/.agents/skills/<name>/
              (--repo: <repo>/.agents/skills)
Cursor:       skills/<name>/ -> ~/.cursor/skills/<name>/
              (--repo: <repo>/.cursor/skills)
Shared:       workflow/workflow.md -> ~/.apiary/system/workflow.md
              templates/, intakes/, resolvers/ -> ~/.apiary/system/ (also with --repo)
              doc-templates/ -> ~/.apiary/system/doc-templates/ (also with --repo)
              protocols/    -> ~/.apiary/system/protocols/ (includes launcher-*.md)
              dot-apiary/*-default-fallback.md -> ~/.apiary/ (also with --repo)
Never written: ~/.apiary/templates/ (your Project Templates)
EOF
}

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT=claude
REPO=""
DRY=0

need_value() {
  if [ "$2" -lt 2 ]; then
    echo "install.sh: $1 needs a value" >&2
    exit 2
  fi
}

while [ $# -gt 0 ]; do
  case "$1" in
    --agent) need_value "$1" $#; AGENT="$2"; shift 2 ;;
    --agent=*) AGENT="${1#*=}"; shift ;;
    --repo) need_value "$1" $#; REPO="$2"; shift 2 ;;
    --repo=*) REPO="${1#*=}"; shift ;;
    --dry-run) DRY=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "install.sh: unknown argument: $1" >&2; usage >&2; exit 2 ;;
  esac
done

case "$AGENT" in
  claude|codex|cursor|both|all) ;;
  *) echo "install.sh: --agent must be claude, codex, cursor, both or all (got '$AGENT')" >&2; exit 2 ;;
esac

if [ -n "$REPO" ]; then
  if [ ! -d "$REPO" ]; then
    echo "install.sh: --repo $REPO is not a directory" >&2
    exit 2
  fi
  REPO="$(cd "$REPO" && pwd)"
fi

# Print each action; run it unless --dry-run.
run() {
  echo "+ $*"
  if [ "$DRY" -eq 0 ]; then
    "$@"
  fi
}

# Copy every skills/<name>/ into $1/<name>/, overwriting files in place.
install_skills() {
  local dest="$1" dir name
  run mkdir -p "$dest"
  for dir in "$SRC"/skills/*/; do
    name="$(basename "$dir")"
    run mkdir -p "$dest/$name"
    run cp -R "$dir." "$dest/$name/"
  done
}

install_claude() {
  local base="${REPO:-$HOME}/.claude"
  echo "== Claude Code: $base"
  install_skills "$base/skills"
}

install_codex() {
  local skills
  if [ -n "$REPO" ]; then
    skills="$REPO/.agents/skills"
  else
    skills="$HOME/.agents/skills"
  fi
  echo "== Codex CLI: $skills"
  install_skills "$skills"
}

install_cursor() {
  local base="${REPO:-$HOME}/.cursor"
  echo "== Cursor: $base"
  install_skills "$base/skills"
}

case "$AGENT" in
  claude) install_claude ;;
  codex) install_codex ;;
  cursor) install_cursor ;;
  both) install_claude; install_codex ;;
  all) install_claude; install_codex; install_cursor ;;
esac

# Main Agents and Child Agents share these instructions and selected protocols.
run mkdir -p "$HOME/.apiary/system"
run cp "$SRC/workflow/workflow.md" "$HOME/.apiary/system/workflow.md"
for shared in templates intakes resolvers; do
  run mkdir -p "$HOME/.apiary/system/$shared"
  run cp -R "$SRC/$shared/." "$HOME/.apiary/system/$shared/"
done
# Apiary no longer ships this Project Template; remove copies left by earlier installs.
run rm -f "$HOME/.apiary/system/templates/public-github-project.md"

run mkdir -p "$HOME/.apiary/system/doc-templates"
run cp -R "$SRC/doc-templates/." "$HOME/.apiary/system/doc-templates/"
run mkdir -p "$HOME/.apiary/system/protocols"
run cp -R "$SRC/protocols/." "$HOME/.apiary/system/protocols/"
run mkdir -p "$HOME/.apiary"
run cp "$SRC"/dot-apiary/*-default-fallback.md "$HOME/.apiary/"

if [ "$DRY" -eq 1 ]; then
  echo "Dry run: nothing was written."
else
  echo "Done."
fi
