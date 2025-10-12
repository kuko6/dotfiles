#!/bin/bash
volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | head -n 1)
mute=$(pactl get-sink-mute @DEFAULT_SINK@ | grep yes)
if [ "$mute" ]; then
    echo "muted"
else
    echo "$volume  "
fi
