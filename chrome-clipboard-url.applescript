#!/usr/bin/osascript
# @raycast.schemaVersion 1
# @raycast.title Open URL or Search Text from Clipboard
# @raycast.mode silent
# @raycast.packageName Browser
# @raycast.icon 🧭

on run
  # Get content from clipboard
  set clipboardContent to (the clipboard as text)

  # Trim whitespace/newlines picked up when copying from a page
  set clipboardContent to my trimText(clipboardContent)

  if clipboardContent is "" then
    return "Clipboard is empty"
  end if

  # Check if the content is a URL
  if (clipboardContent starts with "http://" or clipboardContent starts with "https://" or clipboardContent starts with "www.") then
    # If it starts with www. but not with http, add https://
    if (clipboardContent starts with "www.") and not (clipboardContent starts with "http") then
      set clipboardContent to "https://" & clipboardContent
    end if

    my openInChrome(clipboardContent)
    return "URL opened in Chrome"
  else
    # Handle as search text
    set searchURL to "https://www.google.com/search?q=" & my encodeText(clipboardContent)

    my openInChrome(searchURL)
    return "Searching for text in Chrome"
  end if
end run

# Open a URL in a new Chrome tab and bring focus to it
on openInChrome(theURL)
  tell application "Google Chrome"
    activate
    # Chrome may be running with no window (or not running at all)
    if (count of windows) is 0 then
      make new window
      set URL of active tab of front window to theURL
    else
      tell front window
        make new tab with properties {URL:theURL}
        # Chrome does not focus a newly made tab -- select it explicitly
        set active tab index to (count of tabs)
      end tell
    end if
  end tell
end openInChrome

# Strip leading/trailing spaces, tabs, returns and linefeeds
on trimText(theText)
  set whitespaceChars to {space, tab, return, linefeed}
  repeat while theText is not "" and (character 1 of theText) is in whitespaceChars
    if (length of theText) is 1 then
      set theText to ""
    else
      set theText to text 2 thru -1 of theText
    end if
  end repeat
  repeat while theText is not "" and (character -1 of theText) is in whitespaceChars
    if (length of theText) is 1 then
      set theText to ""
    else
      set theText to text 1 thru -2 of theText
    end if
  end repeat
  return theText
end trimText

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
