---
name: get-lsp-hover
description: >-
  Fetch LSP hover documentation for a symbol at a specific position. Use to get
  type signatures, docstrings, and inline docs without reading source files.
---

```bash
~/.local/bin/get-lsp-hover <file> <line> <col>
```

Returns JSON: `{content, file, line, col}` or `null` if no LSP hover info is available.

`content` is markdown text from the language server — typically includes the type signature and documentation. The file must be open as a Neovim buffer with an active LSP client. Returns `null` if no LSP client is attached or the symbol has no hover info.
