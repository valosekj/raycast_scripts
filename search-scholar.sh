#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Search Google Scholar
# @raycast.mode silent
# @raycast.packageName Browser
#
# Optional parameters:
# @raycast.icon 🎓
# @raycast.argument1 { "type": "text", "placeholder": "Name (default: selection/clipboard)", "optional": true }
#
# Documentation:
# @raycast.description Searches Google Scholar for the given name. Without an argument, copies the current text selection and searches for that (falling back to the clipboard contents).

query="$1"

if [ -z "$query" ]; then
  # Copy current selection to clipboard, then fall back to whatever is on it
  osascript -e 'tell application "System Events" to keystroke "c" using command down'
  sleep 0.2
  query=$(pbpaste)
fi

if [ -z "$query" ]; then
  echo "No name given, and nothing selected or on the clipboard"
  exit 1
fi

encoded=$(python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]))" "$query")
open "https://scholar.google.com/scholar?q=${encoded}"
echo "Searching Scholar: $query"
