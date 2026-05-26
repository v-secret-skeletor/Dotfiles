---
name: get-lsp-symbols
description: >-
  List all LSP document symbols in a file — functions, classes, methods,
  variables, etc. Use to understand file structure before reading or editing it.
---

```bash
~/.local/bin/get-lsp-symbols <file>
```

Returns JSON: `{file, symbols:[{name, kind, line, col, depth}]}`

`kind` is a human-readable string (e.g. `Function`, `Class`, `Method`, `Variable`). `depth` indicates nesting level — methods inside a class have `depth: 1`. The file must be open as a Neovim buffer with an active LSP client.
