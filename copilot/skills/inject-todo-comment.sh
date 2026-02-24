#!/bin/bash
#
# Injects a todo-style comment above a specific line in a file.
# Usage: inject-todo-comment.sh <keyword> <file> <line> <message>
#
# Keywords recognized by todo-comments.nvim: FIX, FAILED, TODO, HACK, WARN, NOTE, PERF
# Comment syntax is inferred from file extension. Indentation matches the target line.

KEYWORD="$1"
FILE="$2"
LINE="$3"
shift 3
MESSAGE="$*"

if [[ -z "$KEYWORD" || -z "$FILE" || -z "$LINE" || -z "$MESSAGE" ]]; then
  echo "usage: inject-todo-comment.sh <keyword> <file> <line> <message>" >&2
  exit 1
fi

if [[ ! -f "$FILE" ]]; then
  echo "error: '$FILE' not found" >&2
  exit 1
fi

ext="${FILE##*.}"
CMT_END=""
case "$ext" in
  go|js|ts|tsx|jsx|c|cpp|h|hpp|java|rs|swift|kt|scala) CMT="//" ;;
  py|rb|sh|bash|zsh|yaml|yml|toml|pl|r|R|Makefile)     CMT="#"  ;;
  lua|sql|hs)                                           CMT="--" ;;
  html|xml|svelte|vue)  CMT="<!--"; CMT_END=" -->" ;;
  css|scss|less)        CMT="/*";   CMT_END=" */"  ;;
  *)                    CMT="//" ;;
esac

indent=$(awk "NR==${LINE}{match(\$0,/^[ \t]*/); print substr(\$0,1,RLENGTH); exit}" "$FILE")

comment="${indent}${CMT} ${KEYWORD}: ${MESSAGE}${CMT_END}"

TMP=$(mktemp)
trap 'rm -f "$TMP"' EXIT

awk -v line="$LINE" -v cmt="$comment" 'NR==line{print cmt} {print}' "$FILE" > "$TMP"
mv "$TMP" "$FILE"
