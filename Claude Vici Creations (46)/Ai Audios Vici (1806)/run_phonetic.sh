#!/bin/bash
# Simple launcher for audio_to_phonetic.py

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Activate virtual environment
source "$SCRIPT_DIR/venv/bin/activate"

# Run the Python script with all arguments
python3 "$SCRIPT_DIR/audio_to_phonetic.py" "$@"
