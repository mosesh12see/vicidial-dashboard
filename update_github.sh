#!/bin/bash

# VICIdial Dashboard GitHub Auto-Push Script

cd "/Users/mosesherrera/Desktop/vicidial-dashboard"

# Add all HTML files
git add *.html 2>/dev/null || true

# Commit with timestamp
if git diff --staged --quiet; then
    echo "⏭️  No changes to commit"
    exit 0
fi

git commit -m "Auto-update $(date '+%Y-%m-%d %I:%M %p')"

# Push to GitHub with retry logic
export PATH="/opt/homebrew/bin:$PATH"
export GH_TOKEN=$(/opt/homebrew/bin/gh auth token 2>/dev/null)

# Configure git to use GitHub CLI credential helper
git config credential.helper ""
git config --local credential.helper '!gh auth git-credential'

# Push with retry
for i in {1..3}; do
    if git push origin main 2>&1; then
        echo "✅ VICIdial Dashboard pushed to GitHub"
        exit 0
    else
        echo "⚠️  Push attempt $i failed, retrying..."
        sleep 2
    fi
done

echo "❌ Failed to push after 3 attempts"
exit 1
