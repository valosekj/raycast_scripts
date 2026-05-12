#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Move Last Desktop File to Finder Folder
# @raycast.mode silent
# @raycast.packageName Finder
#
# Optional parameters:
# @raycast.icon 📥
#
# Documentation:
# @raycast.description Moves the most recently added Desktop file to the folder open in the frontmost Finder window.

desktop_dir="$HOME/Desktop"

# Get the most recently added file on Desktop (files only, no hidden files, no subdirectories)
src=$(find "$desktop_dir" -maxdepth 1 -type f ! -name '.*' -exec stat -f '%m %N' {} \; | sort -rn | head -1 | cut -d' ' -f2-)

if [ -z "$src" ]; then
  echo "No files on Desktop"
  exit 1
fi

latest=$(basename "$src")

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

dst="${finder_dir}${latest}"

if [ -e "$dst" ]; then
  echo "Already exists in destination: $latest"
  exit 1
fi

mv "$src" "$dst"
echo "Moved: $latest → $finder_dir"
