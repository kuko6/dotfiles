#!/bin/sh

# entries="Logout\nSleep\nReboot\nShutdown"
entries="Logout\nReboot\nShutdown"

selected=$(echo $entries | rofi -dmenu \
    -theme-str "window {width: 12em;} listview {lines: 3;}" \
    -p "Powermenu: ")

case $selected in
    "Logout")
        bspc quit;;
    # "Sleep")
    #     # systemctl suspend;;
    #     betterlockscreen -l;;
    "Reboot")
        systemctl reboot;;
    "Shutdown")
        systemctl poweroff;;
esac
