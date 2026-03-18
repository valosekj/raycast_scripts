#!/usr/bin/osascript

# Raycast Script Command Template
#
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open TextEdit
# @raycast.mode silent
# @raycast.packageName Raycast Scripts
#
# Optional parameters:
# @raycast.icon ✏️
# @raycast.currentDirectoryPath ~
# @raycast.needsConfirmation false
#
# Documentation:
# @raycast.description Open TextEdit with the content of the clipboard.
# @raycast.author Jan Valosek
# @raycast.authorURL https://janvalosek.com/

tell application "TextEdit"
    activate
    make new document
    set text of front document to (the clipboard as text)
end tell
