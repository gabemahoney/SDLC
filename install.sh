#!/usr/bin/env bash
# Install (or update) Apiary's skills and agents for Claude Code, Codex CLI or both.
# It copies Apiary's skills, agents, document templates and protocols.
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./install.sh [--agent claude|codex|both] [--repo <path>] [--dry-run]

  --agent    Which flavour to install: claude (default), codex or both.
  --repo     Install into one repository instead of your user-level folders.
  --dry-run  Print every action; write nothing.

Claude Code:  skills/<name>/ -> ~/.claude/skills/<name>/
              agents/*.md    -> ~/.claude/agents/
              (--repo: <repo>/.claude/skills, <repo>/.claude/agents)
Codex CLI:    skills/<name>/ -> ~/.agents/skills/<name>/
              agents/*.md    -> ~/.codex/agents/<name>.toml (rendered; needs python3)
              (--repo: <repo>/.agents/skills, <repo>/.codex/agents)
Shared:       doc-templates/ -> ~/.apiary/system/doc-templates/ (also with --repo)
              protocols/    -> ~/.apiary/system/protocols/ (also with --repo)
              dot-apiary/*-default-fallback.md -> ~/.apiary/ (also with --repo)
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
  claude|codex|both) ;;
  *) echo "install.sh: --agent must be claude, codex or both (got '$AGENT')" >&2; exit 2 ;;
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
  run mkdir -p "$base/agents"
  # cp rewrites an existing file in place: Claude Code notices agent files changed that way mid-session.
  run cp "$SRC"/agents/apiary-*.md "$base/agents/"
}

install_codex() {
  local skills agents
  if [ -n "$REPO" ]; then
    skills="$REPO/.agents/skills"
    agents="$REPO/.codex/agents"
  else
    skills="$HOME/.agents/skills"
    agents="$HOME/.codex/agents"
  fi
  echo "== Codex CLI: $skills, $agents"
  # Render first: it checks every agent before writing any, so a bad one stops the install here.
  local render=(python3 "$SRC/scripts/codex_agents.py" render --out "$agents")
  if [ "$DRY" -eq 1 ]; then
    render+=(--dry-run)
  fi
  echo "+ ${render[*]}"
  "${render[@]}"
  install_skills "$skills"
  if [ -n "$REPO" ]; then
    echo "Note: Codex loads $REPO/.codex/agents only when it trusts that project."
  fi
}

if [ "$AGENT" != claude ] && ! command -v python3 >/dev/null 2>&1; then
  echo "install.sh: python3 is required for --agent $AGENT (it renders the Codex agents from agents/*.md); nothing was installed" >&2
  exit 1
fi

case "$AGENT" in
  claude) install_claude ;;
  codex) install_codex ;;
  both) install_claude; install_codex ;;
esac

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
