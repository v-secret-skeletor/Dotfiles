---
name: open-in-nvim
description: >-
  Open one or more files as Neovim buffers in the parent Neovim session via RPC
  socket. Use after completing a task to surface all modified files for review.
---

Run the following shell command with each file path as arguments:

```bash
~/.local/bin/nvim-agent-open <file1> [file2] ...
```

If no specific files are given, open all files modified in the current session (use `git diff --name-only` to find them).
