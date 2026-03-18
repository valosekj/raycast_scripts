#!/usr/bin/osascript
# @raycast.schemaVersion 1
# @raycast.title Open URL or Search Text from Clipboard
# @raycast.mode silent
# @raycast.packageName Browser
# @raycast.icon 🧭

on run
  # Get content from clipboard
  set clipboardContent to (the clipboard as text)

  # Check if the content is a URL
  if (clipboardContent starts with "http://" or clipboardContent starts with "https://" or clipboardContent starts with "www.") then
    # Handle as URL
    # If it starts with www. but not with http, add https://
    if (clipboardContent starts with "www.") and not (clipboardContent starts with "http") then
      set clipboardContent to "https://" & clipboardContent
    end if

    # Open URL in new Safari tab and bring focus to it
    tell application "Safari"
      activate
      tell front window
        set newTab to make new tab with properties {URL:clipboardContent}
        set current tab to newTab
      end tell
    end tell
    return "URL opened in Safari"
  else
    # Handle as search text
    set searchText to my encodeText(clipboardContent)
    set searchURL to "https://www.google.com/search?q=" & searchText

    tell application "Safari"
      activate
      tell front window
        set newTab to make new tab with properties {URL:searchURL}
        set current tab to newTab
      end tell
    end tell
    return "Searching for text in Safari"
  end if
end run

# Convert special characters and spaces into a format that's safe to use in URLs
on encodeText(theText)
  # URL encode the text
  set theTextEnc to ""
  repeat with eachChar in characters of theText
    set theCharNum to ASCII number of eachChar
    if theCharNum is 32 then
      # space becomes "+"
      set theTextEnc to theTextEnc & "+"
    else if (theCharNum ≥ 48 and theCharNum ≤ 57) or (theCharNum ≥ 65 and theCharNum ≤ 90) or (theCharNum ≥ 97 and theCharNum ≤ 122) then
      # 0-9, A-Z, and a-z stay as is
      set theTextEnc to theTextEnc & eachChar
    else
      # Everything else gets percent-encoded
      set hexNum to do shell script "printf '%02X' " & theCharNum
      set theTextEnc to theTextEnc & "%" & hexNum
    end if
  end repeat
  return theTextEnc
end encodeText
