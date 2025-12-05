#!/bin/bash

echo "======================================================================"
echo " VICIdial Overnight Download Progress"
echo "======================================================================"
echo ""

# Check if process is running
if ps aux | grep -q "[d]ownload_overnight.py"; then
    echo "✓ Download process: RUNNING"
    echo ""
else
    echo "✗ Download process: NOT RUNNING"
    echo ""
fi

# Count current recordings
total=$(find ~/Desktop/vicidial-analysis/sales_recordings -name '*.mp3' 2>/dev/null | wc -l | tr -d ' ')
pitches=$(find ~/Desktop/vicidial-analysis/sales_recordings/pitches -name '*.mp3' 2>/dev/null | wc -l | tr -d ' ')
confirmations=$(find ~/Desktop/vicidial-analysis/sales_recordings/confirmations -name '*.mp3' 2>/dev/null | wc -l | tr -d ' ')

echo "Current recordings:"
echo "  Total: $total"
echo "  Pitches: $pitches"
echo "  Confirmations: $confirmations"
echo ""

# Show last 20 lines of log
echo "Recent activity (last 20 lines):"
echo "----------------------------------------------------------------------"
tail -20 ~/Desktop/vicidial-analysis/download_overnight.log 2>/dev/null || echo "  (No activity yet - waiting for database query)"
echo ""
echo "======================================================================"
echo "To see full log: tail -f ~/Desktop/vicidial-analysis/download_overnight.log"
echo "======================================================================"
