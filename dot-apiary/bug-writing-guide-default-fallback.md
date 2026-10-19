# Bug-writing guide (Apiary default)

Apiary uses this file only when the Project has no `guide:bug-writing-guide.md` of its own.

## Report

This section sets what a Bug's `## Report` contains. A good bug report lets someone who has never seen the problem reproduce it and see exactly what's wrong. Write it under these headings, in this order:

- **Short description:** one or two sentences on what's wrong.
- **Host and environment:** everything about where it happened, such as the host, OS, versions of the software and its dependencies, configuration and relevant settings, so the bug can be reproduced in the same conditions.
- **Steps performed:** numbered, in order, with any inputs and setup, so anyone can repeat them exactly.
- **Expected result:** what should have happened.
- **Actual result:** what happened instead (the bug), with exact error messages and output, in the reporter's words where possible.
- **Logs:** the relevant log lines, or paths to the full logs on disk, so the fixer can see what the software recorded.

Keep each report to one bug, and state facts you saw rather than guesses about the cause.
