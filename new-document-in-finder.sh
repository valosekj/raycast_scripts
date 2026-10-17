#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title New Document in Finder Folder
# @raycast.mode silent
# @raycast.packageName Finder
#
# Optional parameters:
# @raycast.icon 📄
# @raycast.argument1 { "type": "dropdown", "placeholder": "Type", "data": [{"title": "Word (.docx)", "value": "docx"}, {"title": "Excel (.xlsx)", "value": "xlsx"}, {"title": "PowerPoint (.pptx)", "value": "pptx"}, {"title": "Markdown (.md)", "value": "md"}, {"title": "Text (.txt)", "value": "txt"}] }
# @raycast.argument2 { "type": "text", "placeholder": "Name (default: Untitled)", "optional": true }
#
# Documentation:
# @raycast.description Creates a new blank document (Word, Excel, PowerPoint, Markdown, Text) in the current Finder folder and selects it.

ext="$1"
name="${2:-Untitled}"
name="${name%.$ext}"  # drop the extension if it was typed as part of the name

# Office files must be valid zip packages (an empty file won't open), so copy a blank template
templates_dir="$(cd "$(dirname "$0")" && pwd)/assets/templates"

# Get the current Finder window's path
finder_dir=$(osascript <<'OSA'
tell application "Finder"
  if (count of windows) = 0 then
    return ""
  end if
  POSIX path of (target of front window as alias)
end tell
OSA
)

if [ -z "$finder_dir" ]; then
  echo "No Finder window is open"
  exit 1
fi

# Don't overwrite: "Untitled.docx" → "Untitled 2.docx" → ...
dst="${finder_dir}${name}.${ext}"
i=2
while [ -e "$dst" ]; do
  dst="${finder_dir}${name} ${i}.${ext}"
  i=$((i + 1))
done

case "$ext" in
  docx|xlsx|pptx)
    if [ ! -f "$templates_dir/blank.$ext" ]; then
      echo "Missing template: $templates_dir/blank.$ext"
      exit 1
    fi
    cp "$templates_dir/blank.$ext" "$dst"
    ;;
  md|txt)
    touch "$dst"
    ;;
  *)
    echo "Unsupported type: $ext"
    exit 1
    ;;
esac

# Select the new file in Finder
osascript - "$dst" >/dev/null <<'OSA'
on run argv
  tell application "Finder" to select (POSIX file (item 1 of argv) as alias)
end run
OSA

echo "Created: $(basename "$dst")"
