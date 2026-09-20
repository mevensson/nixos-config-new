---
name: rm-wt
description: "Remove a herdr git worktree and delete its branch when safe. Use ONLY when the user explicitly invokes the /rm-wt skill; never invoke it on your own."
disable-model-invocation: true
---

# rm-wt

Remove a herdr worktree and, when safe, delete its `worktree/<slug>` branch.
Invoked as `/rm-wt <slug>`, or `/rm-wt` to remove the worktree you are in.

## Steps

1. Run the helper:
   - explicit target: `rm-wt <slug>`
   - current worktree: `rm-wt`
2. If it exits non-zero because the checkout is dirty or the branch is not
   merged or pushed, show the reason and ask the user whether to force the
   removal. Only re-run with `--force` after the user agrees.
3. Report what was removed and whether the branch was deleted or kept.
4. Removing the current worktree is delegated to another workspace and closes
   the session you are running in; tell the user that before running it.

Do not use raw `git worktree remove` or `git branch -D` yourself.
