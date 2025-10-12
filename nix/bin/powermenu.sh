#!/bin/sh

entries="Logout\nSleep\nReboot\nShutdown"

selected=$(echo -e $entries | fuzzel --dmenu -l 4 -p ": ")
# fuzzel --dmenu -l 7 -p "Power Menu: "

case $selected in
    "Logout")
        riverctl exit;;
    "Sleep")
        systemctl suspend;;
    "Reboot")
        systemctl reboot;;
    "Shutdown")
        systemctl poweroff;;
esac
