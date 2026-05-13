---
name: worktrees
description: >-
  Orchestrate concurrent coding tasks using isolated git worktrees. Use
  /worktrees to list active agents, attach to a running session, cancel a
  worktree, or trigger consolidation. Also use when a multi-item checklist is
  given and concurrency would speed up the work.
---

## When to invoke this skill

Invoke automatically (without waiting for the user to type `/worktrees`) when:
- A checklist with 2+ independent items is given and concurrency would reduce total time
- The user says "in parallel", "concurrently", "background", or "at the same time"
- The user types `/worktrees` with any arguments (list, attach, cancel, consolidate)

---

## /worktrees — list active worktrees

With no arguments, run:

```bash
~/.local/bin/worktree-manager list
```

Print the output. If any worktrees are **stalled**, flag them and offer to cancel or attach.

---

## /worktrees <id> — attach to a worktree

```bash
~/.local/bin/worktree-manager attach <id>
```

If the agent is still running, this replaces the current process with `tmux attach -t <id>`.
If the agent has completed, it opens a new interactive `claude` session in the worktree directory.

---

## /worktrees cancel <id>

```bash
~/.local/bin/worktree-manager cancel <id>
```

Kills the tmux session, removes the git worktree, and deletes the branch. If any worktrees were queued, the next one starts automatically.

---

## /worktrees consolidate [--branch NAME] [--strategy squash|merge|rebase]

```bash
~/.local/bin/worktree-manager consolidate [--branch feat/my-feature] [--strategy squash]
```

Merges all **completed** worktrees into a single feature branch (default strategy: squash merge, one commit per worktree). If conflicts are detected, consolidation pauses and reports which files conflict — **do not proceed automatically**. Ask the user to resolve and retry.

---

## Orchestration flow — running tasks concurrently

Follow this flow exactly when you identify tasks that can be parallelized:

### Step 1 — Analyze

Read the task list or checklist. For each item, identify:
- What files it will read and write
- Whether it depends on output from another item
- Whether it is safe to run concurrently (no shared file writes with another concurrent task)

Group items into:
- **Concurrent batch** — independent, no overlapping file writes
- **Sequential** — must run after a prior task, or touches files another concurrent task will modify

### Step 2 — Present the plan

Output a table like this before doing anything:

```
CONCURRENT BATCH 1 (will run in parallel):
  [wt-1] Add user authentication endpoints   → src/auth/, tests/auth/
  [wt-2] Refactor database connection pool   → src/db/
  [wt-3] Update CI config                    → .github/workflows/

SEQUENTIAL (after batch 1):
  [seq-1] Integration test for auth + db     → depends on wt-1, wt-2

SERIALIZED (file conflict):
  [ser-1] Update README                      → runs after batch 1 (touches README also modified by wt-3)

POST-CONSOLIDATION (automatic, parallel):
  [pc-1] test-custodian      → sync tests with consolidated changes
  [pc-2] documentation-sync  → sync docs with consolidated changes

ORCHESTRATOR:
  worktree-orchestrator will monitor all worktrees, trigger consolidation
  when complete, sequence the post-consolidation pipeline, and notify you
  when the run finishes or when your input is needed.

Max concurrent: 3 of 5 slots used.
Merge strategy: squash (one commit per worktree)
Feature branch: feat/auth-db-refactor-ci

Proceed? (reply to adjust task breakdown, branch name, or merge strategy)
```

Wait for user confirmation or adjustments before proceeding.

### Step 3 — Create worktrees

For each task in the concurrent batch, run:

```bash
~/.local/bin/worktree-manager create "task description here" [--agent claude] [--branch feat/override]
```

Run these `create` calls sequentially (each takes < 1s — no need to parallelize the creation itself).

If the cwd is **not a git repository**, inform the user that concurrency is unavailable and fall back to executing the tasks sequentially in the current session.

If more than 5 tasks would run at once, the extras are automatically queued by the manager and will start as slots free.

After all worker worktrees are created, spawn the orchestrator as the final worktree:

```bash
~/.local/bin/worktree-manager create "orchestrate: monitor worktrees, consolidate on completion, run test-custodian and documentation-sync pipeline" --agent worktree-orchestrator
```

The orchestrator owns all subsequent pipeline stages — consolidation, post-consolidation agents, and cleanup. You do not need to trigger these manually unless overriding.

### Step 4 — Monitor

After launching, run:

```bash
~/.local/bin/worktree-manager list
```

Report the initial status including the orchestrator worktree. Let the user know they can:
- `/worktrees` — check status at any time
- `/worktrees <id>` — attach to any session, including the orchestrator
- `/worktrees cancel <id>` — stop a worktree
- `/worktrees consolidate` — manually override and consolidate immediately

The orchestrator will handle consolidation, post-consolidation agents, and cleanup automatically. It will surface any blockers (GUARDRAILs, conflicts, stalls) that need user input.

### Step 5 — Consolidate (manual override)

If the user wants to consolidate before the orchestrator triggers it, or the orchestrator is not running:

```bash
~/.local/bin/worktree-manager consolidate [--branch feat/name] [--strategy squash]
```

Report the resulting feature branch name. If conflicts occur, show the conflicting files and stop — ask the user to resolve before retrying.

After successful manual consolidation, spawn the post-consolidation agents:

```bash
~/.local/bin/worktree-manager create "sync tests with consolidated feature changes" --agent test-custodian
~/.local/bin/worktree-manager create "sync docs with consolidated feature changes" --agent documentation-sync
```

When both complete, offer cleanup:

```bash
~/.local/bin/worktree-manager cleanup
```

---

## Guardrails reminder

Worktree agents run with `bypassPermissions`. They are instructed to stop and output `GUARDRAIL: <description>` before:
- Destructive git ops (reset --hard, push --force, branch -D)
- Bulk file/directory deletion
- Database schema migrations
- Writes to external services

The orchestrator monitors all worktree logs for `GUARDRAIL:` entries and surfaces them proactively — you will see an `ORCHESTRATOR BLOCKED` message without needing to poll manually. If the orchestrator is not running, check logs yourself with `worktree-manager status <id>` and attach to unblock.

---

## Checking status of a specific worktree

```bash
~/.local/bin/worktree-manager status <id>
```

Prints full metadata and the last 20 lines of the agent's log.
