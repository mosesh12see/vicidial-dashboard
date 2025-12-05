#!/bin/bash

# Check internet connectivity
if ! ping -c 1 8.8.8.8 &> /dev/null && ! ping -c 1 1.1.1.1 &> /dev/null; then
    echo "[$(date)] ⚠️  No internet connection - skipping update" >> /Users/mosesherrera/Desktop/vicidial-analysis/network_check.log
    exit 0
fi

# Internet is available, run the update
echo "[$(date)] ✅ Internet connected - running update" >> /Users/mosesherrera/Desktop/vicidial-analysis/network_check.log
cd /Users/mosesherrera/Desktop/vicidial-analysis
/opt/homebrew/bin/python3 update_comprehensive.py
