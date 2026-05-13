---
name: get-lsp-diagnostics
description: >-
  Fetch LSP diagnostics from the active Neovim session. Run after making file
  changes to verify no new errors or warnings were introduced.
---

Run the following and report all diagnostics found:

```bash
~/.local/bin/get-lsp-diagnostics
```

To check a specific buffer only, pass its buffer number:
```bash
~/.local/bin/get-lsp-diagnostics <bufnr>
```

Output format is `file:line:col [SEVERITY] message`. If there are ERROR diagnostics, investigate and fix them before finishing the task.
