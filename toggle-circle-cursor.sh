#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Cursor Circle
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🌀
# @raycast.argument1 { "type": "text", "placeholder": "Diameter (default 80)", "optional": true }

APP="${HOME}/code/experiments/CircleAroundCursor/CircleAroundCursor"    # update if needed
DIAMETER="${1:-100}"

if pgrep -f "CircleAroundCursor" > /dev/null; then
  pkill -f CircleAroundCursor
  echo "🛑 Cursor circle stopped"
else
  if [ -x "$APP" ]; then
    "$APP" "$DIAMETER" &
    echo "🟢 Cursor circle started (diameter: $DIAMETER)"
  else
    echo "❌ CircleAroundCursor not found at $APP"
  fi
fi
