# Claude Code Agent Protocol File

## Context use

Your context fraction is the latest assistant message's input, cache and output tokens in your session's transcript, divided by your model's context window. If you can't tell, treat it as unknown, never zero.

## Launch template

Launch every Main Agent and Child Agent with the `WORKER` template, because it sets the agent's sandbox and permissions.
