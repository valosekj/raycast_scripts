#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Move Last Download to Finder Folder
# @raycast.mode silent
# @raycast.packageName Finder
#
# Optional parameters:
# @raycast.icon 📥
#
# Documentation:
# @raycast.description Moves the most recently downloaded file to the folder open in the frontmost Finder window.

downloads_dir="$HOME/Downloads"

# Get the most recently added file in Downloads
latest=$(ls -At "$downloads_dir" | head -1)

if [ -z "$latest" ]; then
  echo "No files in Downloads"
  exit 1
fi

# Get the current Finder window's path
finder_dir=$(osascript <<'EOF'
tell application "Finder"
  if (count of windows) = 0 then
    return ""
  end if
  POSIX path of (target of front window as alias)
end tell
EOF
)

if [ -z "$finder_dir" ]; then
  echo "No Finder window is open"
  exit 1
fi

src="${downloads_dir}/${latest}"
dst="${finder_dir}${latest}"

if [ -e "$dst" ]; then
  echo "Already exists in destination: $latest"
  exit 1
fi

mv "$src" "$dst"
echo "Moved: $latest → $finder_dir"
