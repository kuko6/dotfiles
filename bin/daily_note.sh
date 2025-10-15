#!/bin/zsh

NOTES_DIR="${NOTES_DIR:-$HOME/Notes/Daily}"
DATE_FORMAT="%Y-%m-%d"
NOTE_EXTENSION="md"
USE_SPLIT=true  # default to split view

# Parse arguments
show_usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Create and open daily standup notes in Helix.

OPTIONS:
    --no-split       Open only today's note without split
    --help           Show this help message

ENVIRONMENT:
    NOTES_DIR        Directory for notes (default: ~/Notes/Daily)

By default, opens with vertical split showing today's note and previous note side-by-side.

EOF
    exit 0
}

while [[ $# -gt 0 ]]; do
    case $1 in
        --no-split)
            USE_SPLIT=false
            shift
            ;;
        --help)
            show_usage
            ;;
        *)
            echo "Unknown option: $1"
            show_usage
            ;;
    esac
done

mkdir -p "$NOTES_DIR"

TODAY=$(date +"$DATE_FORMAT")
TODAY_NOTE="$NOTES_DIR/$TODAY.$NOTE_EXTENSION"

# find the most recent note (excluding todays if it exists)
PREVIOUS_NOTE=$(ls -t "$NOTES_DIR"/*."$NOTE_EXTENSION" 2>/dev/null | grep -v "$TODAY_NOTE" | head -n 1)

# create todays note if it doesnt exist
if [[ ! -f "$TODAY_NOTE" ]]; then
    cat > "$TODAY_NOTE" << EOF
# $TODAY

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
if [[ "$USE_SPLIT" == true ]] && [[ -n "$PREVIOUS_NOTE" ]]; then
    hx "$TODAY_NOTE" "$PREVIOUS_NOTE" --vsplit
    echo "Opened with previous note: $PREVIOUS_NOTE"
else
    hx "$TODAY_NOTE"
    [[ "$USE_SPLIT" == false ]] && echo "Opening without split" || echo "No previous notes found, opening only today's note"
fi
