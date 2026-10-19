# Bug-writing guide (Apiary default)

Apiary uses this file only when the Project has no `guide:bug-writing-guide.md` of its own.

## Report

This section sets what a Bug's `## Report` contains. Write it under these headings, in this order:

- **Short description:** one or two sentences on what's wrong.
- **Host and environment:** everything about where it happened, such as the host, OS, versions of the software and its dependencies, configuration and relevant settings, so the bug can be reproduced in the same conditions.
- **Steps performed:** what was done, in order, with any inputs and setup.
- **Expected result:** what should have happened.
- **Actual result:** what happened instead (the bug), in the reporter's exact words where possible, so validation investigates the reported failure.

## Validation

Exercise the boundary where the real interaction happens, because an isolated component test can miss the reported failure.

Distinguish observations from inference. Record what ran and what it showed. If source inspection settles the report, cite the code and explain why it proves the conclusion. Keep attempted reproductions and their limitations so later work can tell what was demonstrated.
