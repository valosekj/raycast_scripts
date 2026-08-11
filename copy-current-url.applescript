#!/usr/bin/osascript
# @raycast.schemaVersion 1
# @raycast.title Copy Current Tab URL
# @raycast.mode silent
# @raycast.packageName Browser
# @raycast.icon 🔗

on run
  tell application "Google Chrome"
    if (count of windows) is 0 then
      return "No Chrome window is open"
    end if
    set currentURL to URL of active tab of front window
  end tell

  set the clipboard to currentURL
  return "Copied: " & currentURL
end run
