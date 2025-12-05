#!/bin/bash
# Check download progress

echo "=== RECORDING DOWNLOAD PROGRESS ==="
echo ""
echo "Target: ~26,769 sales recordings from last 12 months"
echo ""

total=$(find ~/Desktop/vicidial-analysis/sales_recordings -name "*.mp3" 2>/dev/null | wc -l | tr -d ' ')
pitches=$(find ~/Desktop/vicidial-analysis/sales_recordings/pitches -name "*.mp3" 2>/dev/null | wc -l | tr -d ' ')
confirmations=$(find ~/Desktop/vicidial-analysis/sales_recordings/confirmations -name "*.mp3" 2>/dev/null | wc -l | tr -d ' ')

echo "Downloaded: $total recordings"
echo "  Pitches: $pitches"
echo "  Confirmations: $confirmations"
echo ""

percent=$(echo "scale=2; $total / 26769 * 100" | bc)
echo "Progress: $percent%"
echo ""

# Check if process is still running
if ps aux | grep -v grep | grep "download_organized_recordings.py" > /dev/null; then
    echo "Status: ✓ Download is running"
    echo ""
    echo "Recent activity:"
    tail -10 ~/Desktop/vicidial-analysis/download_full_year.log 2>/dev/null | grep "✓ Saved" | tail -3
else
    echo "Status: ✗ Download process not running"
    echo ""
    echo "To restart: cd ~/Desktop/vicidial-analysis && nohup python3 download_organized_recordings.py > download_full_year.log 2>&1 &"
fi

echo ""
echo "Run this script anytime: bash ~/Desktop/vicidial-analysis/check_download_progress.sh"
