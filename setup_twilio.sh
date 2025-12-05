#!/bin/bash

echo "=================================="
echo "TWILIO SMS NOTIFIER SETUP"
echo "=================================="
echo

# Step 1: Install Twilio
echo "Step 1: Installing Twilio library..."
pip3 install --break-system-packages twilio

echo
echo "Step 2: Fetching your Twilio phone number..."
echo

# Fetch phone number
PHONE=$(python3 << 'PYTHON_SCRIPT'
from twilio.rest import Client

TWILIO_ACCOUNT_SID = 'AC52926a1358b76dee0e35cc86ae0aa98c'
TWILIO_AUTH_TOKEN = '1ffc3205c0a8b3dba9035a5fa1c43ee1'

try:
    client = Client(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)
    numbers = client.incoming_phone_numbers.list(limit=1)

    if numbers:
        print(numbers[0].phone_number)
    else:
        print("NO_PHONE_FOUND")
except Exception as e:
    print(f"ERROR: {e}")
PYTHON_SCRIPT
)

if [[ "$PHONE" == "NO_PHONE_FOUND" ]]; then
    echo "❌ No phone number found in your Twilio account"
    echo
    echo "Please go to https://www.twilio.com/console/phone-numbers"
    echo "and get a phone number, then run this setup again."
    exit 1
elif [[ "$PHONE" == ERROR* ]]; then
    echo "❌ Error connecting to Twilio:"
    echo "$PHONE"
    exit 1
fi

echo "✅ Found your Twilio phone number: $PHONE"
echo

# Step 3: Update the notifier script
echo "Step 3: Updating sms_optin_notifier.py with your phone number..."

sed -i.bak "s|TWILIO_FROM_NUMBER = '.*'|TWILIO_FROM_NUMBER = '$PHONE'|" \
    /Users/mosesherrera/Desktop/vicidial-analysis/sms_optin_notifier.py

echo "✅ Configuration complete!"
echo
echo "=================================="
echo "READY TO USE!"
echo "=================================="
echo
echo "Run the notifier with:"
echo "  python3 /Users/mosesherrera/Desktop/vicidial-analysis/sms_optin_notifier.py"
echo
echo "You'll get a text at 972-469-1106 for every opt-in/transfer!"
echo "=================================="
