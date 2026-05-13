---
name: get-treesitter-context
description: >-
  Find the nearest enclosing function or class scope at a position using
  Treesitter. Use to determine structural scope without reading the whole file.
---

```bash
# Current buffer and cursor position:
~/.local/bin/get-treesitter-context

# Specific position (file must be open as a buffer):
~/.local/bin/get-treesitter-context <file> <line> <col>
```

Returns JSON: `{type, name, file, range:{start:{line,col}, finish:{line,col}}}` or `null` if no enclosing scope exists.

`type` is the Treesitter node type (e.g. `function_definition`, `class_declaration`, `impl_item`). Use the `range` to understand the full extent of the scope before editing it.
