#!/bin/bash

# --- Configuration ---
WATCH_DIR="/Users/dirkekelund/Downloads/"
SAB_API_KEY="387ba4be9e2dc91b031cd3e03345fb85"
SAB_URL="http://192.168.2.13:8080/api"
DELETE_AFTER_UPLOAD=true  # Set to true to delete NZBs after successful upload
PROCESSED_LOG="/Users/dirkekelund/Downloads/uploaded_nzbs.log"

# Create log file if it doesn't exist
touch "$PROCESSED_LOG"

# --- Function to upload NZB ---
upload_nzb() {
    local nzb_file="$1"
    echo "[*] Uploading: $nzb_file"

    response=$(curl -s -F "apikey=$SAB_API_KEY" \
                    -F "mode=addfile" \
                    -F "name=@${nzb_file}" \
                    -F "output=json" \
                    "$SAB_URL")

    if echo "$response" | grep -q '"status":true'; then
        echo "[✓] Uploaded: $nzb_file"
        echo "$nzb_file" >> "$PROCESSED_LOG"
        if [ "$DELETE_AFTER_UPLOAD" = true ]; then
            rm -f "$nzb_file"
            echo "[−] Deleted: $nzb_file"
        fi
    else
        echo "[!] Failed to upload: $nzb_file"
        echo "    Response: $response"
    fi
}

# --- Main Loop ---
for file in "$WATCH_DIR"/*.nzb; do
    [ -e "$file" ] || continue
    if ! grep -Fxq "$file" "$PROCESSED_LOG"; then
        upload_nzb "$file"
    fi
done
