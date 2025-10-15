#!/bin/sh

# Stage/unstage the git hunk under the cursor (toggle)
#
# Usage: stage_hunk.sh <file> <line> [context]
file="$1"; line="$2"; context="${3:-3}"

# check if file is in a git repo
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "Error: not in a git repository"
  exit 1
fi

# extract hunk at a given line from a diff
extract_hunk() {
  diff_output="$1"
  echo "$diff_output" | awk -v ln="$line" '
    BEGIN { have=0; buf=""; out="" }

    /^@@ /{
      if (have && out=="") out=buf
      buf = $0 ORS
      have = 0

      header = $0
      sub(/^.*\+/, "", header)
      sub(/ .*/, "", header)
      n = split(header, parts, ",")
      start_ln = parts[1] + 0
      len = (n >= 2 ? parts[2] + 0 : 1)
      have = (len == 0 ? (ln == start_ln) : (ln >= start_ln && ln < start_ln + len))
      next
    }

    { if (buf != "") buf = buf $0 ORS }

    END {
      if (have && out=="") out=buf
      print out
    }
  '
}

# check if hunk is already staged
staged_diff=$(git --no-pager diff --cached HEAD -U"$context" -- "$file")
staged_hunk=$(extract_hunk "$staged_diff")

if [ -n "$staged_hunk" ] && [ "$staged_hunk" != "No hunk under cursor" ]; then
  # unstage
 {
    echo "diff --git a/$file b/$file"
    echo "--- a/$file"
    echo "+++ b/$file"
    echo "$staged_hunk"
  } | git apply --cached --reverse --unidiff-zero

  if [ $? -eq 0 ]; then
    echo "Hunk unstaged successfully"
  else
    echo "Failed to unstage hunk"
    exit 1
  fi
else
  # stage
  working_diff=$(git --no-pager diff HEAD -U"$context" -- "$file")
  working_hunk=$(extract_hunk "$working_diff")

  if [ -z "$working_hunk" ] || [ "$working_hunk" = "No hunk under cursor" ]; then
    echo "No hunk found under cursor"
    exit 1
  fi

  {
    echo "diff --git a/$file b/$file"
    echo "--- a/$file"
    echo "+++ b/$file"
    echo "$working_hunk"
  } | git apply --cached --unidiff-zero

  if [ $? -eq 0 ]; then
    echo "Hunk staged successfully"
  else
    echo "Failed to stage hunk"
    exit 1
  fi
fi
