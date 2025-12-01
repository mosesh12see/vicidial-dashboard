#!/bin/bash

# Auto-commit and push updated dashboard to GitHub Pages
# Runs after update_comprehensive.py generates new HTML

cd /Users/mosesherrera/Desktop/vicidial-dashboard

# Copy to public folder (create if needed)
mkdir -p public
cp deep-analysis-2.html public/

# Add changes
git add deep-analysis-2.html public/deep-analysis-2.html

# Commit with timestamp
git commit -m "Auto-update dashboard - $(date '+%Y-%m-%d %I:%M %p')"

# Push to GitHub
git push origin main

echo "✅ Dashboard updated on GitHub Pages"
