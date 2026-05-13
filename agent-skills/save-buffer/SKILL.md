---
name: save-buffer
description: >-
  Save a Neovim buffer for a specific file. Use after making edits to ensure the
  buffer on disk matches what Neovim has loaded.
---

```bash
~/.local/bin/save-buffer <file>
```

Exits 0 and prints "saved" on success. Exits 1 and prints "not found" if the file is not currently loaded as a Neovim buffer. Does not create new buffers — use `open-at-location` first if needed.
