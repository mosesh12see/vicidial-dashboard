#!/bin/bash

# Watchdog script - keeps the download running even if it crashes

LOG_FILE=~/Desktop/vicidial-analysis/download_overnight.log
PID_FILE=~/Desktop/vicidial-analysis/download.pid
SCRIPT_DIR=~/Desktop/vicidial-analysis

echo "======================================================================"
echo "VICIdial Download Watchdog Started: $(date)"
echo "======================================================================"
echo ""
echo "This will keep the download running continuously."
echo "Press Ctrl+C to stop the watchdog."
echo ""

while true; do
    # Check if download script is running
    if ps aux | grep -q "[d]ownload_overnight.py"; then
        # Still running, just wait
        sleep 30
    else
        echo "----------------------------------------------------------------------"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Download stopped, restarting..."
        echo "----------------------------------------------------------------------"

        # Wait a moment for network to stabilize
        sleep 5

        # Restart the download
        cd "$SCRIPT_DIR"
        nohup python3 download_overnight.py >> "$LOG_FILE" 2>&1 &
        NEW_PID=$!
        echo $NEW_PID > "$PID_FILE"

        echo "Restarted with PID: $NEW_PID"
        echo ""

        # Wait before checking again
        sleep 30
    fi
done
