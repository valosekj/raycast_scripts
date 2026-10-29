#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Replace Spaces with Underscores
# @raycast.mode silent
# @raycast.packageName System
#
# Optional parameters:
# @raycast.icon ⎵
#
# Documentation:
# @raycast.description Replaces spaces with underscores in the selected text (in place), or pastes the clipboard text with spaces replaced by underscores if nothing is selected. Handy when naming a file in Finder.

# pbcopy/pbpaste need a UTF-8 locale to keep non-ASCII characters (e.g. č, ř) intact
export LC_ALL=en_US.UTF-8

keystroke() {
  osascript -e "tell application \"System Events\" to keystroke \"$1\" using command down"
}

# Detect a selection: put a sentinel on the clipboard, Cmd+C, and see if it changed
original=$(pbpaste)
sentinel="__raycast_no_selection_$$__"
printf '%s' "$sentinel" | pbcopy
keystroke c
sleep 0.2
selection=$(pbpaste)

if [ "$selection" != "$sentinel" ] && [ -n "$selection" ]; then
  text="$selection"
else
  text="$original"
fi

# Trim leading/trailing whitespace (incl. newlines), then replace spaces with underscores
text=$(printf '%s' "$text" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' | tr -d '\n')
if [ -z "$text" ]; then
  printf '%s' "$original" | pbcopy
  echo "Nothing selected and clipboard is empty"
  exit 1
fi
result="${text// /_}"

# Paste the result (replaces the selection, if any); it stays on the clipboard afterwards
printf '%s' "$result" | pbcopy
keystroke v
echo "Pasted: $result"
