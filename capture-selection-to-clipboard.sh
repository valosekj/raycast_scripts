#!/bin/sh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Capture Selection to Clipboard
# @raycast.mode silent
# @raycast.packageName System
#
# Optional parameters:
# @raycast.icon 💻
#
# Documentation:
# @raycast.description This script screenshots the selected area and saves it to the clipboard.
# @raycast.author Aaron Miller
# @raycast.authorURL https://github.com/aaronhmiller

screencapture -ci
echo "Selection saved to clipboard"
