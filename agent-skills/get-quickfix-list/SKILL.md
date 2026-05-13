---
name: get-quickfix-list
description: >-
  Read the current Neovim quickfix list. Use to pick up the user's active
  investigation context — LSP errors, compiler output, grep results, and test
  failures all land here.
---

```bash
~/.local/bin/get-quickfix-list
```

Returns JSON: `{title, items:[{file, lnum, col, type, text}]}`

`type` is "E" (error), "W" (warning), "I" (info), or "" (generic). An empty `items` array means the quickfix list is empty or not populated.
