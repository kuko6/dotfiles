#!/bin/sh

entries="Logout\nSleep\nReboot\nShutdown"

selected=$(printf "%b" "$entries" | fuzzel --dmenu -l 4 -p ": ")
# fuzzel --dmenu -l 7 -p "Power Menu: "
#
# Detect compositor
case "$XDG_CURRENT_DESKTOP" in
    river*)
        logout_cmd="riverctl exit"
        ;;
    sway*)
        logout_cmd="swaymsg exit"
        ;;
    *)
        # fallback if unknown
        logout_cmd="riverctl exit"
        ;;
esac

case "$selected" in
    "Logout")
        eval "$logout_cmd"
        ;;
    "Sleep")
        systemctl suspend
        ;;
    "Reboot")
        systemctl reboot
        ;;
    "Shutdown")
        systemctl poweroff
        ;;
esac
