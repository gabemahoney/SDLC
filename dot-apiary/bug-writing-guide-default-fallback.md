# Bug-writing guide (Apiary default)

Apiary uses this file when no user copy of `guide:bug-writing-guide.md` is found as `~/.apiary/system/workflow.md` describes.

## Report

This section sets what a Bug's `## Report` contains. Describe the reported symptom, expected and actual behaviour, and supplied reproduction steps, inputs and setup. Preserve the reporter's exact symptom so validation investigates the reported failure.

## Validation

Exercise the boundary where the real interaction happens, because an isolated component test can miss the reported failure.

Distinguish observations from inference. Record what ran and what it showed. If source inspection settles the report, cite the code and explain why it proves the conclusion. Keep attempted reproductions and their limitations so later work can tell what was demonstrated.
