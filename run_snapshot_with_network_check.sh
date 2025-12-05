#!/bin/bash

if ! ping -c 1 8.8.8.8 &> /dev/null && ! ping -c 1 1.1.1.1 &> /dev/null; then
    echo "[$(date)] ⚠️  No internet connection - skipping snapshot" >> /Users/mosesherrera/Desktop/vicidial-analysis/snapshot_network_check.log
    exit 0
fi

echo "[$(date)] ✅ Internet connected - running snapshot" >> /Users/mosesherrera/Desktop/vicidial-analysis/snapshot_network_check.log
cd /Users/mosesherrera/Desktop/vicidial-analysis
/opt/homebrew/bin/python3 universal_html_snapshot.py
