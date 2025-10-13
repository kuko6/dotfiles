#!/bin/zsh

NOTES_DIR="${NOTES_DIR:-$HOME/Notes/Daily}"
DATE_FORMAT="%Y-%m-%d"
NOTE_EXTENSION="md"

mkdir -p "$NOTES_DIR"

TODAY=$(date +"$DATE_FORMAT")
TODAY_NOTE="$NOTES_DIR/$TODAY.$NOTE_EXTENSION"

# find the most recent note (excluding todays if it exists)
PREVIOUS_NOTE=$(ls -t "$NOTES_DIR"/*."$NOTE_EXTENSION" 2>/dev/null | grep -v "$TODAY_NOTE" | head -n 1)

# create todays note if it doesnt exist
if [[ ! -f "$TODAY_NOTE" ]]; then
    cat > "$TODAY_NOTE" << EOF
# Daily Standup - $TODAY

## Today's Goals
-

## Tasks
- [ ]

## Notes

EOF
    echo "Created new daily note: $TODAY_NOTE"
else
    echo "Opening existing note: $TODAY_NOTE"
fi

# open helix with split view
if [[ -n "$PREVIOUS_NOTE" ]]; then
    hx "$TODAY_NOTE" "$PREVIOUS_NOTE" -c ":vsplit"
    echo "Opened with previous note: $PREVIOUS_NOTE"
else
    hx "$TODAY_NOTE"
    echo "No previous notes found, opening only today's note"
fi
