#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Log sct_run_batch (from clipboard)
# @raycast.mode fullOutput
# @raycast.packageName sct_run_batch log
#
# Optional parameters:
# @raycast.icon 📋
#
# Documentation:
# @raycast.description Parse the sct_run_batch terminal text on the clipboard (copy the prompt+command line first) and append machine/dataset/analysis to ~/Desktop/sct_run_batch_log.xlsx. More robust than OCR.
# @raycast.author Jan Valosek

PY="$HOME/miniconda3/envs/sct_batch_log/bin/python"
SCRIPT="$HOME/code/sct-run-batch-log/log_sct_run_batch.py"

if [ ! -x "$PY" ]; then
  echo "Conda env 'sct_batch_log' not found. See $HOME/code/sct-run-batch-log/README.md"
  exit 1
fi

"$PY" "$SCRIPT" --clipboard
