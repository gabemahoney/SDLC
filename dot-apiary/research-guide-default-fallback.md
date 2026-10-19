# Research guide (Apiary default)

Apiary uses this file only when the Project has no `guide:research-guide.md` of its own.

## Sources and depth

Choose sources and depth to suit the question, its constraints and the latest review request. Prefer original documentation, data and direct observations so conclusions rest on evidence close to the subject. Investigate disagreements that could change the answer and state what remains uncertain.

## Methods and evidence

Use methods that suit the question. A small runnable prototype can settle a design question; keep it as an artifact and record what it demonstrated.

Keep enough evidence to support the findings. Put bulky data, scripts, logs, screenshots, notes and excerpts in artifacts so the Report stays readable. Link artifacts from the findings they support through the Ticket System Protocol File. Remove secrets and tokens from them, because the research record may be shared.

## Report

Write a standalone answer so readers can use it without the ticket or conversation:

- **Summary:** answer the question first, in a few lines.
- **Findings:** organize the evidence by theme or sub-question.
- **Limitations:** state what was not checked, uncertainty and open questions.
- **Conclusions and recommendations:** include these when the question calls for them.
- **References:** use a numbered list and inline `[n]` citations for claims beyond common knowledge. Identify each source precisely: a URL and access date, file path and line or commit SHA, ticket ID, message permalink, or document title and section.
- **Artifacts:** link each through the Ticket System Protocol File and explain what it holds in one line.

## Asking questions

If you hit a question only your reviewer can answer, such as what's in scope or which of two conflicting sources to trust, and the answer would change what you research, ask them before going further rather than guessing.
