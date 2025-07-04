#!/bin/bash

# Directory to scan - set your desired directory here
WATCH_DIR="/Users/dirkekelund/Downloads"

# Log file (optional, helpful for debugging)
LOG_FILE="/Users/dirkekelund/Downloads/unrar_cron.log"

# Ensure unrar is available
#if ! command -v unar &> /dev/null; then
#  echo "[$(date)] ERROR: 'unrar' is not installed." >> "$LOG_FILE"
#  exit 1
#fi

# Process matching .rar files (case-insensitive)
find "$WATCH_DIR" -maxdepth 1 -type f -iname "*german*.rar" | while read -r rarfile; do
  BASENAME=$(basename "$rarfile" .rar)
  DEST_DIR="$WATCH_DIR/$BASENAME"

  # Skip if already extracted
  if [ -d "$DEST_DIR" ]; then
    echo "[$(date)] Skipping already extracted: $rarfile" >> "$LOG_FILE"
    continue
  fi

  echo "[$(date)] Extracting: $rarfile" >> "$LOG_FILE"
#  mkdir -p "$DEST_DIR"
  if /opt/homebrew/bin/unar -D "$rarfile" >> "$LOG_FILE" 2>&1; then
    echo "[$(date)] ✓ Successfully extracted: $rarfile" >> "$LOG_FILE"
    rm -f "$rarfile" && echo "[$(date)] 🗑️ Deleted: $rarfile" >> "$LOG_FILE"
  else
    echo "[$(date)] ❌ Failed to extract: $rarfile" >> "$LOG_FILE"
  fi
done
