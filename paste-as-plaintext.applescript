#!/usr/bin/osascript
# @raycast.schemaVersion 1
# @raycast.title Paste as Plain Text
# @raycast.mode silent
# @raycast.packageName System
# @raycast.icon 📋

on run
  set plainText to the clipboard as text
  set the clipboard to plainText

  tell application "System Events"
    keystroke "v" using command down
  end tell
end run
