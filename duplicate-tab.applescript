#!/usr/bin/osascript
# @raycast.schemaVersion 1
# @raycast.title Duplicate Current Tab
# @raycast.mode silent
# @raycast.packageName Browser
# @raycast.icon 🔁

on run
  set frontApp to name of (info for (path to frontmost application))

  if frontApp contains "Safari" then
    tell application "Safari"
      set currentURL to URL of current tab of front window
      tell front window
        set newTab to make new tab with properties {URL:currentURL}
        set current tab to newTab
      end tell
    end tell
    return "Duplicated tab in Safari"

  else if frontApp contains "Chrome" then
    tell application "Google Chrome"
      set currentURL to URL of active tab of front window
      tell front window
        make new tab with properties {URL:currentURL}
      end tell
    end tell
    return "Duplicated tab in Chrome"

  else
    return "No supported browser is frontmost (Safari or Chrome)"
  end if
end run
