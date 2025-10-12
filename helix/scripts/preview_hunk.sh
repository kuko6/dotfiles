#!/bin/sh

# Preview git hunk under cursor
# inspired by: https://gist.github.com/gloaysa/828707f067e3bb20da18d72fa5d4963a
#
# Usage: stage_hunk.sh <file> <line> [context]
file="$1"; line="$2"; context="${3:-3}"

# check if file is in a git repo
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "Error: not in a git repository"
  exit 1
fi

# print only the hunk whose +start,len covers $line
git --no-pager diff HEAD -U"$context" -- "$file" | awk -v ln="$line" '
  BEGIN { have=0; buf=""; out="" }

  /^@@ /{
    if (have && out=="") out=buf
    buf = $0 ORS
    have = 0

    header = $0
    sub(/^.*\+/, "", header)
    sub(/ .*/, "", header)
    n = split(header, parts, ",")
    start_ln = parts[1] + 0 # +0 to type it as int
    len = (n >= 2 ? parts[2] + 0 : 1)
    have = (len == 0 ? (ln == start_ln) : (ln >= start_ln && ln < start_ln + len))
    next
  }

  { if (buf != "") buf = buf $0 ORS }

  END {
    if (have && out=="") out=buf
    if (out != "") print out
    else print "No hunk under cursor"
  }
'
