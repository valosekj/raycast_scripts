#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Replace Newlines with Spaces
# @raycast.mode silent
# @raycast.packageName System
#
# Optional parameters:
# @raycast.icon ↩️
#
# Documentation:
# @raycast.description Joins the selected text (in place) into a single line, or pastes the clipboard joined into a single line if nothing is selected. Handy for paragraphs copied from PDFs; words hyphenated across line breaks are rejoined.

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

# Rejoin words hyphenated across a line break ("tem-\nporary" → "temporary"),
# replace remaining line breaks with a space, collapse repeated spaces, and trim
result=$(printf '%s' "$text" | perl -CSD -0pe '
  s/\r//g;
  s/(\w)-[ \t]*\n[ \t]*(?=\p{Ll})/$1/g;
  s/[ \t]*\n[ \t]*/ /g;
  s/[ \t]+/ /g;
  s/^\s+|\s+$//g;
')

if [ -z "$result" ]; then
  printf '%s' "$original" | pbcopy
  echo "Nothing selected and clipboard is empty"
  exit 1
fi

# Paste the result (replaces the selection, if any); it stays on the clipboard afterwards
printf '%s' "$result" | pbcopy
keystroke v
echo "Pasted single line (${#result} chars)"
