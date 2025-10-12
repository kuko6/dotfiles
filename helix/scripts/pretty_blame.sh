#!/bin/sh

# Display git blame in nicer format :p
#
# Usage: pretty_blame.sh <file> <line>
file="$1"; line="$2"

blame_output=$(git blame -L "$line",+1 --porcelain "$file")

sha=$(echo "$blame_output" | grep -E '^[0-9a-f]{40}' | cut -d' ' -f1 | cut -c1-7)
author=$(echo "$blame_output" | grep '^author ' | sed 's/^author //')
timestamp=$(echo "$blame_output" | grep '^author-time ' | cut -d' ' -f2)
timezone=$(echo "$blame_output" | grep '^author-tz ' | cut -d' ' -f2)
date="$(date -r "$timestamp" +'%Y-%m-%d %H:%M:%S') $timezone"
commit=$(echo "$blame_output" | grep '^summary ' | sed 's/^summary //')

echo "$sha $author $date - $commit"
