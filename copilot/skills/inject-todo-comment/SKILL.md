---
name: inject-todo-comment
description: >-
  Inject a todo-comments.nvim style comment above a specific line in a file.
  Use when flagging issues, incomplete work, or deferred fixes without modifying
  the code itself.
---

```bash
~/.local/bin/inject-todo-comment <KEYWORD> <file> <line> <message>
```

Valid keywords (recognized by todo-comments.nvim): `FIX`, `FAILED`, `TODO`, `HACK`, `WARN`, `NOTE`, `PERF`

Comment syntax is inferred from the file extension. Indentation matches the target line automatically.

Example: flag a known issue at line 42 of a TypeScript file:
```bash
~/.local/bin/inject-todo-comment HACK src/auth.ts 42 token refresh race condition, needs mutex
```
