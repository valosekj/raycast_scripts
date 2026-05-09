#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Search Google Scholar
# @raycast.mode silent
# @raycast.packageName Browser
#
# Optional parameters:
# @raycast.icon 🎓
#
# Documentation:
# @raycast.description Copies the current text selection and searches for it on Google Scholar.

# Copy current selection to clipboard
osascript -e 'tell application "System Events" to keystroke "c" using command down'
sleep 0.2

selected=$(pbpaste)

if [ -z "$selected" ]; then
  echo "No text selected"
  exit 1
fi

encoded=$(python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]))" "$selected")
open "https://scholar.google.com/scholar?q=${encoded}"
echo "Searching Scholar: $selected"
