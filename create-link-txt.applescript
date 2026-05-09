#!/usr/bin/osascript
# @raycast.schemaVersion 1
# @raycast.title Create link.txt from Clipboard
# @raycast.mode silent
# @raycast.packageName Finder
# @raycast.icon 📄

on run
  # Get the current Finder folder
  tell application "Finder"
    if (count of windows) is 0 then
      return "No Finder window is open"
    end if
    set currentFolder to target of front window as alias
  end tell

  set currentFolderPath to POSIX path of currentFolder
  set filePath to currentFolderPath & "link.txt"
  set clipboardContent to the clipboard as text

  # Write clipboard content to link.txt
  do shell script "printf '%s' " & quoted form of clipboardContent & " > " & quoted form of filePath

  return "Created: " & filePath
end run
