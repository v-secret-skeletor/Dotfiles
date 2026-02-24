#!/bin/bash
#
# Opens modified files as neovim buffers via the parent neovim's RPC socket.
# Usage: open-modified-buffers.sh <file1> [file2] [file3] ...
#
# Requires $NVIM to be set (automatic inside neovim's :terminal).

NVIM_SOCKET="${NVIM:-${NVIM_LISTEN_ADDRESS:-}}"

if [[ -z "$NVIM_SOCKET" ]]; then
  echo "error: no neovim socket found (NVIM / NVIM_LISTEN_ADDRESS not set)" >&2
  exit 1
fi

if [[ $# -eq 0 ]]; then
  echo "usage: open-modified-buffers.sh <file> [file...]" >&2
  exit 1
fi

for file in "$@"; do
  if [[ -f "$file" ]]; then
    abs_path="$(realpath "$file")"
    nvim --server "$NVIM_SOCKET" --remote-expr "execute('badd $abs_path')"
  else
    echo "warn: skipping '$file' (not a regular file)" >&2
  fi
done

nvim --server "$NVIM_SOCKET" --remote-expr "execute('set autoread | checktime')"
