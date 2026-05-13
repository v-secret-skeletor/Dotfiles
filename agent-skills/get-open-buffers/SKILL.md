---
name: get-open-buffers
description: >-
  List all open Neovim buffers with their file paths, filetypes, and unsaved
  status. Use at the start of a task to understand the current workspace state.
---

```bash
~/.local/bin/get-open-buffers
```

Returns a JSON array: `[{nr, name, filetype, modified}, ...]`

Use this to discover which files are already loaded before deciding what to open or edit. Check `modified: true` entries before making changes to avoid overwriting unsaved work.
