"""Check every original workflow statement survives the b.v38 split.

Usage: python3 scripts/check_workflow_split.py
Headings, table headers/separators and code fences are structure, not statements.
Table cells and semicolon/sentence boundaries let owners receive their own clauses.
Only whitespace, Markdown emphasis/list markers and terminal punctuation normalize.
The sole wording change redirects status authority from the removed table to SKILL.md.
"""

import json
from pathlib import Path
import re
import subprocess


ROOT = Path(__file__).resolve().parents[1]
BASELINE = "1d606655eb4da0934fb3d666e02e210c509b8a65"
TARGETS = ["workflow/workflow.md", "skill-specifics.md"]
REPLACEMENTS = {
    "Change only the tickets and statuses your `SKILL.md` and this table give you.":
        "Change only the tickets and statuses your `SKILL.md` gives you.",
}
TABLE_HEADERS = {
    "| Store | Top-level ticket | Child tiers |",
    "| Tag | Meaning |",
    "| Status | Meaning |",
    "| Ticket | Transitions and owners |",
    "| Skill | Gate |",
}


def normalize(text):
    text = re.sub(r"^\s*- ", "", text).replace("**", "")
    return re.sub(r"\s+", " ", text).strip().rstrip(".;")


def statements(source):
    for number, line in enumerate(source.splitlines(), 1):
        text = line.strip()
        if not text or text.startswith(("#", "```")):
            continue
        if text.startswith("|"):
            if re.fullmatch(r"[| :\-]+", text):
                continue
            if re.sub(r"\s+", " ", text) in TABLE_HEADERS:
                continue
            cells = [cell.strip() for cell in text.strip("|").split("|")]
        else:
            cells = [text]
        for cell in cells:
            for statement in re.split(r"(?<=[.;])\s+", cell):
                yield number, statement


def main():
    source = subprocess.check_output(
        ["git", "show", f"{BASELINE}:workflow/workflow.md"], cwd=ROOT, text=True
    )
    targets = {name: normalize((ROOT / name).read_text()) for name in TARGETS}
    checked, missing = [], []
    for line, statement in statements(source):
        expected = REPLACEMENTS.get(statement, statement)
        found = [name for name, text in targets.items() if normalize(expected) in text]
        row = {"line": line, "source": statement, "destinations": found}
        if expected != statement:
            row["split_adjustment"] = expected
        checked.append(row)
        if not found:
            missing.append(row)
    print(json.dumps({
        "baseline": BASELINE, "statements": len(checked),
        "preserved": len(checked) - len(missing), "missing": missing,
        "split_adjustments": REPLACEMENTS, "coverage": checked,
    }, indent=2))
    return bool(missing)


if __name__ == "__main__":
    raise SystemExit(main())
