#!/usr/bin/env bash

# Extract "<old> <new>" from the first two lines
read previous current < <(
  home-manager generations | head -n2 | awk '
    NR==2 { old=$7 }
    NR==1 { new=$7 }
    END     { print old, new }
  '
)

# Show a header and do the diff in the shell
echo "Changes from $(basename "$previous") → $(basename "$current"):"
nvd diff "$previous" "$current"
