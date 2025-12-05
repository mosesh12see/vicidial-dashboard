# SMS Opt-in Notifier Setup

Get instant text messages when opt-ins or transfers happen!

## Step 1: Install Twilio Python Library

```bash
pip3 install twilio
```

## Step 2: Get Twilio Credentials

1. Go to https://www.twilio.com/try-twilio (free trial - $15 credit)
2. Sign up for free account
3. Get a phone number (free with trial)
4. Go to https://www.twilio.com/console
5. Copy these 3 things:
   - **Account SID** (starts with AC...)
   - **Auth Token** (click to reveal)
   - **Phone Number** (your Twilio number)

## Step 3: Configure the Script

Edit `sms_optin_notifier.py` and fill in your credentials:

```python
TWILIO_ACCOUNT_SID = 'AC...'              # Your Account SID
TWILIO_AUTH_TOKEN = 'your_token_here'     # Your Auth Token
TWILIO_FROM_NUMBER = '+1XXXXXXXXXX'       # Your Twilio phone number
MY_PHONE = '+19724691106'                 # Already set to your number!
```

## Step 4: Run the Notifier

```bash
python3 /Users/mosesherrera/Desktop/vicidial-analysis/sms_optin_notifier.py
```

## What You'll Get

Every time an opt-in or transfer happens, you'll get a text like:

```
🎯 NEW OPT-IN!

🏠 Agent 2001 (Ext: R/2001)
Campaign: Colorado Inbound
Lead State: CO
Phone: 303-555-1234
Time: 02:45 PM
```

or

```
🔄 NEW TRANSFER!

From Agent: VDAD
→ To Agent: 2001 🏠
Campaign: Colorado Inbound
Lead State: CO
Phone: 303-555-1234
Time: 02:47 PM
```

## Options

In the script, you can configure:

- `MONITOR_REMOTE_AGENTS_ONLY = True` - Only notify for remote agents (2001-2005)
- `CHECK_INTERVAL = 5` - How often to check (in seconds)

## Running 24/7

To keep it running even after you close the terminal:

```bash
nohup python3 sms_optin_notifier.py > sms_notifier.log 2>&1 &
```

To stop it:
```bash
pkill -f sms_optin_notifier.py
```

## Cost

- Twilio Trial: **FREE** ($15 credit, ~1,800 messages)
- After trial: **$0.0079 per SMS** (~$8 per 1,000 messages)

## Troubleshooting

If you get an error about Twilio library:
```bash
pip3 install --upgrade twilio
```

If texts aren't sending, check:
1. Twilio credentials are correct
2. Your phone number is verified in Twilio (required for trial)
3. Twilio account has credit

Need help? Let me know!
