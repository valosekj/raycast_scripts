#!/usr/bin/osascript
# @raycast.schemaVersion 1
# @raycast.title Duplicate Current Tab
# @raycast.mode silent
# @raycast.packageName Browser
# @raycast.icon 🔁

on run
  tell application "Google Chrome"
    if (count of windows) is 0 then
      return "No Chrome window is open"
    end if

    set currentURL to URL of active tab of front window
    tell front window
      make new tab with properties {URL:currentURL}
      # Chrome does not focus a newly made tab -- select it explicitly
      set active tab index to (count of tabs)
    end tell
  end tell

  return "Duplicated tab in Chrome"
end run
