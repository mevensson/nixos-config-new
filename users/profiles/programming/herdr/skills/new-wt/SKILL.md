---
name: new-wt
description: "Create a herdr git worktree and inject a prompt into the agent started there. Use ONLY when the user explicitly invokes the /new-wt skill; never invoke it on your own."
disable-model-invocation: true
---

# new-wt

Create a new herdr git worktree and deliver a prompt to the agent that the
`matte.auto-tabs` herdr plugin starts in it. Invoked as `/new-wt <prompt>`.

## Steps

1. Derive a slug from the user's prompt:
   - lowercase ASCII letters and digits, words joined by single dashes
   - 3-5 words, at most 40 characters
   - verb-noun shape, e.g. `add-grub-theme`, `fix-build-problem`
   - if the prompt references an issue or PR number, prefix it, e.g. `issue-79-continue`
2. Run the helper with the prompt on stdin:

   ```sh
   new-wt --slug <slug> <<'PROMPT'
   <the user's prompt>
   PROMPT
   ```

3. Report the printed `branch`, `path`, `workspace`, and `pane` lines. If the
   command exits non-zero, show its output verbatim; the worktree may still have
   been created.

Do not create the worktree with raw `git worktree` or `herdr worktree` commands.
