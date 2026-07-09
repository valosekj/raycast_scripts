#!/usr/bin/osascript
# @raycast.schemaVersion 1
# @raycast.title Create info.txt
# @raycast.mode silent
# @raycast.packageName Finder
# @raycast.icon 📝

on run
  # Get the current Finder folder
  tell application "Finder"
    if (count of windows) is 0 then
      return "No Finder window is open"
    end if
    set currentFolder to target of front window as alias
  end tell

  set currentFolderPath to POSIX path of currentFolder
  set filePath to currentFolderPath & "info.txt"

  # Create an empty info.txt (do not overwrite if it already exists)
  do shell script "touch " & quoted form of filePath

  return "Created: " & filePath
end run
