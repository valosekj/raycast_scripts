#!/bin/sh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Capture Current Screen with Cursor to Desktop
# @raycast.mode silent
# @raycast.packageName System
#
# Optional parameters:
# @raycast.icon 💻
#
# Documentation:
# @raycast.description Captures the screen currently containing the mouse cursor (with cursor) and saves the screenshot to the desktop.
# @raycast.author Jan Valosek and GPT4o

DISPLAY_INDEX=$(swift -e '
import Cocoa
import CoreGraphics

let mouseLocation = NSEvent.mouseLocation

// Convert global mouse location to each screen’s coordinates
let screens = NSScreen.screens
for (index, screen) in screens.enumerated() {
    let screenFrame = screen.frame
    if screenFrame.contains(mouseLocation) {
        print(index + 1) // screencapture -D expects display index starting from 1
        break
    }
}
')

if [ -z "$DISPLAY_INDEX" ]; then
  echo "Could not determine active screen."
  exit 1
fi

screencapture -D "$DISPLAY_INDEX" -C ~/Desktop/"Screenshot $(date +"%F at %-I.%M.%S %p")".png
echo "Screenshot of screen $DISPLAY_INDEX with cursor saved to Desktop"
