#!/bin/sh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Capture Window to Desktop
# @raycast.mode silent
# @raycast.packageName System
#
# Optional parameters:
# @raycast.icon 💻
#
# Documentation:
# @raycast.description This script screenshots the entire screen and saves it to the desktop.
# @raycast.author Aaron Miller
# @raycast.authorURL https://github.com/aaronhmiller

screencapture -iW ~/Desktop/"Screenshot $(date +"%F at %-I.%M.%S %p")".png
echo "Screenshot saved to desktop"
