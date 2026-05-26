---
name: open-at-location
description: >-
  Open a file in Neovim and jump the cursor to a specific line and column. Use
  to surface a finding directly rather than just opening the file.
---

```bash
~/.local/bin/open-at-location <file> <line> [col]
```

Accepts the `file:line:col` format produced by `get-lsp-diagnostics` — extract the parts and pass them as separate args. Column defaults to 1 if omitted.
