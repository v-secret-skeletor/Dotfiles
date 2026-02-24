#!/bin/bash
#
# Fetches LSP diagnostics from the active Neovim instance.
# Usage: get-lsp-diagnostics.sh [bufnr]
#
# If bufnr is omitted, returns diagnostics for all open buffers.
# Requires $NVIM to be set (automatic inside neovim's :terminal).
# Run this after making file changes to verify no new LSP errors were introduced.

NVIM_SOCKET="${NVIM:-${NVIM_LISTEN_ADDRESS:-}}"

if [[ -z "$NVIM_SOCKET" ]]; then
  echo "error: no neovim socket found (NVIM / NVIM_LISTEN_ADDRESS not set)" >&2
  exit 1
fi

BUFNR="${1:-nil}"
TMP=$(mktemp)
trap 'rm -f "$TMP"' EXIT

# Lua (no double-quotes or single-quotes in code to avoid shell escaping issues):
# - long bracket strings [[...]] used for all string literals
# - string.char() used for special chars: 10=\n, 32=space, 91=[, 93=]
nvim --server "$NVIM_SOCKET" --remote-expr \
  "luaeval('local f=io.open([[${TMP}]],[[w]]); local d=vim.diagnostic.get(${BUFNR}); local sev={[1]=[[ERROR]],[2]=[[WARN]],[3]=[[INFO]],[4]=[[HINT]]}; for _,v in ipairs(d) do local s=sev[v.severity] or [[?]]; local n=vim.api.nvim_buf_get_name(v.bufnr); if n~=[[]] then f:write(n..[[:]]..tostring(v.lnum+1)..[[:]]..tostring(v.col+1)..string.char(32,91)..s..string.char(93,32)..((v.message or [[]]):gsub(string.char(10),string.char(32)))..string.char(10)) end end; f:close(); return 1')" > /dev/null 2>&1

if [[ -s "$TMP" ]]; then
  cat "$TMP"
else
  echo "no diagnostics"
fi
