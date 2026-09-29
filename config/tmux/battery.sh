#!/bin/sh

case "$(uname -s)" in
  Darwin)
    pmset -g batt 2>/dev/null | awk '
      /[0-9]+%/ {
        match($0, /[0-9]+%/)
        printf " | %s", substr($0, RSTART, RLENGTH)
        exit
      }
    '
    ;;
  Linux)
    power_supply_dir=${BATTERY_POWER_SUPPLY_DIR:-/sys/class/power_supply}
    for battery in "$power_supply_dir"/*; do
      [ -r "$battery/type" ] && [ -r "$battery/capacity" ] || continue
      [ "$(cat "$battery/type")" = Battery ] || continue
      IFS= read -r percentage < "$battery/capacity"
      case "$percentage" in
        ''|*[!0-9]*) continue ;;
      esac
      printf ' | %s%%' "$percentage"
      break
    done
    ;;
esac
