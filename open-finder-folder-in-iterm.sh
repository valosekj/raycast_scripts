#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open Finder Folder in iTerm2
# @raycast.mode silent
# @raycast.packageName Finder
#
# Optional parameters:
# @raycast.icon 💻
#
# Documentation:
# @raycast.description Opens the frontmost Finder window's folder in iTerm2.
# @raycast.author Jan Valosek, Claude Code

folder=$(osascript <<'EOF'
tell application "Finder"
    if (count of windows) > 0 then
        set folderPath to (target of front window) as alias
        POSIX path of folderPath
    else
        POSIX path of (path to home folder)
    end if
end tell
EOF
)

if [ -z "$folder" ]; then
    echo "Could not determine Finder folder"
    exit 1
fi

osascript <<EOF
tell application "iTerm2"
    activate
    set newWindow to (create window with default profile)
    tell current session of newWindow
        write text "cd $(printf '%q' "$folder")"
    end tell
end tell
EOF

echo "Opened: $folder"
