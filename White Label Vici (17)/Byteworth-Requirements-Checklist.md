# What You Need From Byteworth/ByteDialer

## Current Status

| Item | Status | What We Have |
|------|--------|--------------|
| ViciDial Server IP | ✅ Have | `67.198.205.116` |
| MySQL Read Access | ⚠️ Limited | `cron/6sfhf9ogku0q` (read-only) |
| ViciDial API | ❌ Limited | `6666/donkey` (only "version" works) |
| Asterisk AMI | ❌ Missing | Need credentials |
| SIP Trunk | ❌ Missing | Need configuration |
| IP Whitelist | ❓ Unknown | May need your server IP added |

---

## CRITICAL: What You Need to Request

### 1. ViciDial Non-Agent API User (CRITICAL)

**What it is:** A username/password that lets your system add leads, make calls, and control campaigns through ViciDial's API.

**Ask Byteworth for:**
```
"I need a Non-Agent API user with the following permissions:
- add_lead (add phone numbers)
- update_lead (update lead info)
- external_dial (make outbound calls)
- external_pause (pause agents)
- external_status (change call dispositions)
- agent_status (check agent status)
- blind_transfer (transfer calls)
- campaign_info (get campaign details)
- lead_callback_info (get lead history)

Please provide:
- API Username: ___________
- API Password: ___________
- Source name to use: ___________
"
```

**Test it with:**
```
curl "http://67.198.205.116/vicidial/non_agent_api.php?source=YOUR_SOURCE&user=YOUR_USER&pass=YOUR_PASS&function=add_lead&phone_number=5551234567&campaign_id=1022"
```

---

### 2. MySQL User with Write Access (IMPORTANT)

**What it is:** A database user that can INSERT and UPDATE records, not just read them.

**Current Problem:**
- User `cron` only has RELOAD privilege
- Can READ data but cannot WRITE

**Ask Byteworth for:**
```
"I need a MySQL user with SELECT, INSERT, UPDATE privileges on the asterisk database.

Please provide:
- MySQL Host: ___________
- MySQL Username: ___________
- MySQL Password: ___________
- Database Name: asterisk
- Required Tables:
  - vicidial_list (to add leads)
  - vicidial_hopper (to load dialers)
  - vicidial_log (to read call logs)
  - vicidial_campaigns (to read/update campaigns)
  - vicidial_live_agents (to see agent status)
"
```

---

### 3. Asterisk Manager Interface (AMI) Access (FOR REAL-TIME)

**What it is:** Direct connection to the phone system to originate calls and get real-time events.

**Why you need it:**
- Make calls directly through Asterisk (more reliable than API)
- Get instant notifications when calls connect/disconnect
- Transfer calls in real-time

**Ask Byteworth for:**
```
"I need Asterisk Manager Interface (AMI) credentials:

- AMI Host: ___________
- AMI Port: ___________ (usually 5038)
- AMI Username: ___________
- AMI Password: ___________
- Required Permissions: originate, call, agent, user, system

For IP Whitelist, add: [YOUR SERVER IP]
"
```

---

### 4. SIP Trunk Information (FOR VOICE AI CALLS)

**What it is:** Connection info to send/receive voice calls through their phone system.

**Why you need it:**
- Connect your AI voice calls to ViciDial's phone system
- Transfer calls from AI to live agents
- Make calls that show ViciDial's caller IDs

**Ask Byteworth for:**
```
"I need SIP trunk credentials to connect our external voice system:

- SIP Server: ___________
- SIP Port: ___________ (usually 5060)
- SIP Username: ___________
- SIP Password: ___________
- Codec: ___________ (G711, G729?)
- Auth Method: ___________

Or alternatively, can we register as a Remote Agent?"
```

---

### 5. IP Whitelist Addition (FOR SECURITY)

**What it is:** ViciDial blocks connections from unknown IPs. Your server needs to be allowed.

**Ask Byteworth for:**
```
"Please add these IPs to the whitelist for:
- MySQL access
- API access
- AMI access

IP Addresses to whitelist:
- [YOUR DEVELOPMENT IP]
- [YOUR PRODUCTION SERVER IP]
- [YOUR SIGNALWIRE/TWILIO IPs if known]
"
```

To find your IP:
```bash
curl ifconfig.me
```

---

### 6. Remote Agent Configuration (ALTERNATIVE TO SIP)

**What it is:** Instead of full SIP, register your SignalWire number as a "Remote Agent" in ViciDial.

**Why this might be easier:**
- No SIP trunk needed
- ViciDial calls your SignalWire number
- Your AI answers on SignalWire
- Can transfer back to ViciDial agents

**Ask Byteworth for:**
```
"Can you set up a Remote Agent with these details:

- Agent Username: AI_AGENT_001
- External Phone Number: [YOUR SIGNALWIRE NUMBER]
- Number of Lines: 10
- Campaigns to receive calls from: [YOUR CAMPAIGN IDs]
- On-Hook Agent: Yes (calls out to the number)
"
```

---

## Quick Reference: What Each Thing Does

| Credential | What It Lets You Do |
|------------|---------------------|
| **API User** | Add leads, make calls, control campaigns via HTTP |
| **MySQL User** | Read/write data directly to database |
| **AMI User** | Real-time call control and events |
| **SIP Trunk** | Send/receive actual voice calls |
| **Remote Agent** | Have ViciDial call your AI phone number |
| **IP Whitelist** | Allow your server to connect |

---

## Email Template to Send Byteworth

```
Subject: API and Database Access Request for External Integration

Hi Byteworth Team,

I'm setting up an external Voice AI system that needs to integrate with our ViciDial instance at 67.198.205.116.

I need the following access:

1. NON-AGENT API USER
   - Functions needed: add_lead, update_lead, external_dial, agent_status, blind_transfer, campaign_info
   - Please provide: username, password, and source name

2. MYSQL USER (with write access)
   - Need: SELECT, INSERT, UPDATE on asterisk database
   - Tables: vicidial_list, vicidial_hopper, vicidial_log, vicidial_campaigns, vicidial_live_agents

3. ASTERISK AMI ACCESS
   - Need: originate, call, agent permissions
   - Please provide: host, port, username, password

4. IP WHITELIST
   - Please add IP: [YOUR IP HERE]
   - For: MySQL, API, and AMI access

5. OPTIONAL: Remote Agent Setup
   - External number: [YOUR SIGNALWIRE NUMBER]
   - For campaigns: [YOUR CAMPAIGN IDs]

This is for an AI-powered voice system that will:
- Make outbound calls and qualify leads
- Transfer interested leads to live agents
- Add leads to the dialer
- Monitor campaign stats in real-time

Please let me know if you need any additional information.

Thanks,
[Your Name]
```

---

## After You Get Credentials

Update your `.env` file with:

```env
# ViciDial API
VICI_API_URL=http://67.198.205.116/vicidial/non_agent_api.php
VICI_API_USER=[from Byteworth]
VICI_API_PASS=[from Byteworth]
VICI_API_SOURCE=[from Byteworth]

# ViciDial MySQL (with write access)
VICI_DB_HOST=67.198.205.116
VICI_DB_USER=[from Byteworth]
VICI_DB_PASSWORD=[from Byteworth]
VICI_DB_NAME=asterisk

# Asterisk AMI (for real-time)
VICI_AMI_HOST=67.198.205.116
VICI_AMI_PORT=5038
VICI_AMI_USER=[from Byteworth]
VICI_AMI_PASS=[from Byteworth]

# SIP (if provided)
SIP_HOST=[from Byteworth]
SIP_PORT=5060
SIP_USER=[from Byteworth]
SIP_PASS=[from Byteworth]
```

---

## Current Limitations Without These

| Feature | Works? | Why |
|---------|--------|-----|
| View campaigns | ✅ Yes | MySQL read works |
| View agents | ✅ Yes | MySQL read works |
| View call stats | ✅ Yes | MySQL read works |
| Add leads | ❌ No | API returns "Login incorrect" |
| Make calls | ❌ No | Need API or AMI |
| Transfer calls | ❌ No | Need API or SIP |
| Start/stop campaigns | ❌ No | Need API |
| Real-time call events | ❌ No | Need AMI |

---

## Priority Order

1. **HIGHEST: API User** - This unlocks most functionality
2. **HIGH: IP Whitelist** - Required for API to work
3. **MEDIUM: MySQL Write** - Alternative to API for adding leads
4. **MEDIUM: Remote Agent** - Easiest way to connect calls
5. **LOWER: AMI** - For advanced real-time features
6. **LOWER: SIP Trunk** - Only if you need direct SIP connection
