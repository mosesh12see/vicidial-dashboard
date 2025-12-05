#!/bin/bash

# ============================================================================
# Vicidial Audio Files Downloader
# ============================================================================
# Purpose: Download all AI-generated audio files from Vicidial server
# Created: October 30, 2025
# ============================================================================

SERVER="root@67.198.205.116"
REMOTE_PATH="/var/lib/asterisk/sounds/en"
LOCAL_PATH="/Users/mosesherrera/Desktop/vicidial-analysis/Claude Vici Creations/Ai Audios Vici"

echo "============================================================================"
echo "🎙️  VICIDIAL AUDIO FILES DOWNLOADER"
echo "============================================================================"
echo ""
echo "Server: $SERVER"
echo "Remote Path: $REMOTE_PATH"
echo "Local Path: $LOCAL_PATH"
echo ""

# Array of audio files to download
audio_files=(
    "AaronAmarenIllinois.wav"
    "AylaHannahGeorgiaPower.wav"
    "HannahStLouisMissouriAmeren.wav"
    "Wrapup Call.wav"
    "jerseysincere.wav"
    "silence2seconds.wav"
)

# Check SSH connectivity
echo "Checking SSH connectivity..."
if ! ssh -o ConnectTimeout=5 "$SERVER" "echo 'Connection successful'" 2>/dev/null; then
    echo "❌ ERROR: Cannot connect to server via SSH"
    echo "   Server may be down or SSH port may be blocked"
    echo ""
    echo "Please check:"
    echo "  1. Server is running"
    echo "  2. SSH service is active (port 22)"
    echo "  3. Network connectivity"
    exit 1
fi

echo "✅ SSH connection successful!"
echo ""

# Download each file
downloaded=0
failed=0

for file in "${audio_files[@]}"; do
    echo "Downloading: $file"

    # Use scp to download
    if scp "$SERVER:$REMOTE_PATH/$file" "$LOCAL_PATH/" 2>/dev/null; then
        echo "  ✅ Downloaded successfully"
        ((downloaded++))
    else
        echo "  ❌ Failed to download (file may not exist)"
        ((failed++))
    fi
    echo ""
done

# Summary
echo "============================================================================"
echo "📊 DOWNLOAD SUMMARY"
echo "============================================================================"
echo "✅ Successfully downloaded: $downloaded files"
echo "❌ Failed to download: $failed files"
echo ""

if [ $downloaded -gt 0 ]; then
    echo "Files saved to:"
    echo "  $LOCAL_PATH"
    echo ""
    echo "To play an audio file:"
    echo "  afplay '$LOCAL_PATH/[filename].wav'"
fi

echo ""
echo "✅ Done!"
echo "============================================================================"
