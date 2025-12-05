# 📋 Moses Claude Colorado Campaign - Complete Summary

**Campaign Created:** October 28, 2025
**Status:** ✅ READY (Inactive - Safe)
**Cloned From:** Missouri Campaign (1022)

---

## 🎯 Campaign Overview

### Main Campaign
- **Campaign ID:** 4001
- **Campaign Name:** Moses Claude Colorado
- **State:** Colorado (CO)
- **Status:** INACTIVE ✅ (Won't dial until activated)
- **Type:** Outbound auto-dialer

### Transfer/Closer Campaign
- **Campaign ID:** Colorado
- **Campaign Name:** Colorado Transfer Campaign
- **Status:** ACTIVE ✅
- **Type:** INBOUND_MAN (manual inbound)

### Inbound Group
- **Group ID:** ColoradoXfer
- **Group Name:** Colorado Transfer Queue
- **Status:** ACTIVE ✅

---

## ⚙️ Campaign Settings

### Dialing Configuration
```
Dial Method:        RATIO (adaptive)
Auto Dial Level:    190
Dial Timeout:       40 seconds
Lead Order:         DOWN COUNT (prioritize fresh leads)
```

### Hopper Settings
```
Hopper Level:       4000 leads
Auto Hopper:        Enabled
```

### Recording Settings
```
Recording:          ALLCALLS
Recording Override: FULLDATE_CUSTPHONE
Agent Override:     DISABLED (agents cannot disable)
```

### Call Time
```
Local Call Time:    24hours
```

---

## 🔗 Campaign Flow

### How Calls Work

```
STEP 1: OUTBOUND DIALING
┌────────────────────────────────────────┐
│ Campaign 4001: Moses Claude Colorado  │
│ Status: INACTIVE                       │
│ ───────────────────────────────────────│
│ → Loads 4000 leads into hopper        │
│ → Dials at level 190 (RATIO method)   │
│ → Attempts fresh leads first           │
│ → Records all calls                    │
└────────────┬───────────────────────────┘
             │
             ↓
   Agent answers, talks to lead
             │
             ↓
   ┌────────┴─────────┐
   │                  │
   ↓                  ↓
NO INTEREST        INTERESTED
   │                  │
   ↓                  │
Disposition:          │
• NP (No answer)      │
• A (Machine)         │
• DEC (Declined)      │
• DC (Disconnected)   │
   ↓                  ↓
Call ends      Disposition: SVYCLM
               (Survey sent to Call)
                     │
                     ↓
       ┌─────────────────────────────┐
       │                             │
       ↓                             ↓

STEP 2: TRANSFER TO CLOSER
┌────────────────────────────────────────┐
│ Campaign: Colorado                     │
│ Type: INBOUND_MAN                      │
│ Status: ACTIVE                         │
│ ───────────────────────────────────────│
│ → Call transferred automatically       │
│ → Routes to ColoradoXfer group         │
└────────────┬───────────────────────────┘
             │
             ↓

STEP 3: INBOUND QUEUE
┌────────────────────────────────────────┐
│ Inbound Group: ColoradoXfer            │
│ Status: ACTIVE                         │
│ ───────────────────────────────────────│
│ → Rings configured phone number        │
│ → Waits 360 seconds max                │
│ → If no answer: MESSAGE action         │
└────────────┬───────────────────────────┘
             │
             ↓
   Your opt-in phone rings
   (NEED TO CONFIGURE THIS!)
```

---

## 🚦 Current Status

### What's Done ✅
- [x] Campaign 4001 created
- [x] Cloned from proven Missouri template
- [x] Closer campaign "Colorado" created
- [x] Inbound group "ColoradoXfer" created
- [x] Campaigns linked together
- [x] Recording enabled and locked
- [x] Dial settings configured
- [x] Campaign set to INACTIVE (safe)

### What's Pending ⏳

#### 1. Configure Phone Number for Opt-Ins ⚠️ REQUIRED
**You need to provide:**
- What phone number should ring when someone opts in?
- Is this a cell phone, landline, or VoIP?
- Do you want multiple numbers (round-robin)?
- Do you want failover if no answer?

**How to configure:**
```
Web Interface:
1. Go to: Admin → DIDs/Inbound → Add New DID
2. DID Number: [YOUR PHONE NUMBER]
3. Campaign: Colorado
4. Group: ColoradoXfer
5. Route: AGENT or PHONE
6. Extension: [Your extension or phone]
```

#### 2. Load Colorado Leads
**Status:** No leads loaded yet
**Next step:** Upload CSV with Colorado phone numbers

**Required CSV format:**
```csv
phone_number,first_name,last_name,state,vendor_lead_code,list_id
3035551234,John,Doe,CO,LEAD001,999
7205551234,Jane,Smith,CO,LEAD002,999
```

**Minimum required:**
- phone_number (10 digits)
- first_name
- last_name
- state (must be "CO")

#### 3. Test Campaign
- Add test lead with your phone
- Temporarily activate
- Verify call flow
- Test opt-in transfer
- Deactivate

#### 4. Go Live
- Load real Colorado leads
- Set Active='Y'
- Monitor real-time dashboard

---

## 📊 Monitoring

### Real-Time URLs
```
Admin Panel:
https://dialpower.team/vicidial/admin.php

Real-Time Monitor:
https://dialpower.team/vicidial/admin.php?ADD=999999

View Campaign 4001:
https://dialpower.team/vicidial/admin.php?ADD=34&campaign_id=4001
```

### Database Queries

**Check campaign status:**
```sql
SELECT campaign_id, campaign_name, active, auto_dial_level
FROM vicidial_campaigns
WHERE campaign_id = '4001';
```

**Count leads loaded:**
```sql
SELECT COUNT(*) as total_leads
FROM vicidial_list
WHERE list_id IN (
  SELECT list_id FROM vicidial_lists WHERE campaign_id = '4001'
);
```

**Check hopper:**
```sql
SELECT COUNT(*) as leads_in_hopper
FROM vicidial_hopper
WHERE campaign_id = '4001';
```

**View recent calls:**
```sql
SELECT call_date, phone_number, status, length_in_sec
FROM vicidial_log
WHERE campaign_id = '4001'
ORDER BY call_date DESC
LIMIT 50;
```

**Count opt-ins:**
```sql
SELECT COUNT(*) as opt_ins
FROM vicidial_log
WHERE campaign_id = '4001'
AND status = 'SVYCLM';
```

---

## 🛠️ How to Activate

### Method 1: Web Interface (Safest)
1. Login: https://dialpower.team/vicidial/admin.php
2. Navigate: Admin → Campaigns
3. Click campaign **4001**
4. Change **Active** from 'N' to 'Y'
5. Click **SUBMIT**

### Method 2: Database (Quick)
```sql
mysql -h 67.198.205.116 -u cron -p'6sfhf9ogku0q' asterisk -e \
"UPDATE vicidial_campaigns SET active = 'Y' WHERE campaign_id = '4001'"
```

### Method 3: Python Script
```python
import pymysql
conn = pymysql.connect(
    host='67.198.205.116',
    user='cron',
    password='6sfhf9ogku0q',
    database='asterisk'
)
cursor = conn.cursor()
cursor.execute("UPDATE vicidial_campaigns SET active = 'Y' WHERE campaign_id = '4001'")
conn.commit()
print("✅ Campaign 4001 activated!")
```

---

## 🎛️ Adjusting Settings

### If Calls Are Too Aggressive
```sql
-- Reduce auto dial level
UPDATE vicidial_campaigns
SET auto_dial_level = '150'
WHERE campaign_id = '4001';
```

### If Calls Are Too Slow
```sql
-- Increase auto dial level
UPDATE vicidial_campaigns
SET auto_dial_level = '250'
WHERE campaign_id = '4001';
```

### If Too Many Drops
```sql
-- More conservative dialing
UPDATE vicidial_campaigns
SET dial_method = 'ADAPT_HARD_LIMIT',
    auto_dial_level = '150'
WHERE campaign_id = '4001';
```

### Change Hopper Size
```sql
-- More leads in memory
UPDATE vicidial_campaigns
SET hopper_level = '6000'
WHERE campaign_id = '4001';
```

---

## 📞 Setting Up Your Opt-In Phone Number

### Option 1: Direct Phone Number
**Best for:** Simple setup, single phone line

```
DID Setup:
- DID Number: 303-555-1234 (your opt-in number)
- Campaign: Colorado
- Group: ColoradoXfer
- Route: PHONE
- Extension: Your SIP extension
```

### Option 2: Cell Phone (Remote Agent)
**Best for:** Mobile, work from anywhere

```
Agent Setup:
1. Create user: REMOTE_COLORADO
2. Phone Login: 8370 (unique extension)
3. Outbound Caller ID: 303-555-1234 (your cell)
4. Phone Type: REMOTE
5. Add to ColoradoXfer group
```

**Benefits:**
- Answer from anywhere
- Auto-failover to next agent
- All calls recorded server-side
- Company caller ID shown to customer

### Option 3: Round-Robin (Multiple Phones)
**Best for:** Team environment, high volume

```
Setup multiple remote agents:
- Agent 1: 303-555-0001 (rings 20 sec)
- Agent 2: 303-555-0002 (rings 20 sec if 1 no answer)
- Agent 3: 303-555-0003 (rings 20 sec if 2 no answer)
- Then: Voicemail
```

### Option 4: External Transfer
**Best for:** Third-party call center

```
DID Setup:
- Transfer to: 1-800-555-1234
- Method: PSTN or SIP trunk
- All calls forwarded automatically
```

---

## 🔍 Verification Scripts

### Check Everything
```bash
cd "/Users/mosesherrera/Desktop/Claude Vici Creations"
python3 verify_colorado_campaign.py
```

### List All Campaigns
```bash
python3 check_campaigns.py
```

### Quick Status Check
```bash
python3 -c "
import pymysql
conn = pymysql.connect(host='67.198.205.116', user='cron', password='6sfhf9ogku0q', database='asterisk')
cursor = conn.cursor(pymysql.cursors.DictCursor)
cursor.execute('SELECT campaign_id, campaign_name, active, auto_dial_level FROM vicidial_campaigns WHERE campaign_id = \"4001\"')
camp = cursor.fetchone()
print(f'Campaign: {camp[\"campaign_name\"]}')
print(f'Status: {\"ACTIVE\" if camp[\"active\"] == \"Y\" else \"INACTIVE\"}')
print(f'Dial Level: {camp[\"auto_dial_level\"]}')
conn.close()
"
```

---

## 🚨 Troubleshooting

### Campaign Won't Dial

**Check 1: Is it active?**
```sql
SELECT active FROM vicidial_campaigns WHERE campaign_id = '4001';
-- Should return: Y
```

**Check 2: Are there leads?**
```sql
SELECT COUNT(*) FROM vicidial_hopper WHERE campaign_id = '4001';
-- Should return: > 0
```

**Check 3: Auto dial level?**
```sql
SELECT auto_dial_level FROM vicidial_campaigns WHERE campaign_id = '4001';
-- Should return: > 0
```

**Fix:**
```bash
# Force hopper reload
ssh root@67.198.205.116
/usr/share/astguiclient/AST_VDhopper.pl --debug
```

### Transfers Not Working

**Check 1: Closer campaign exists?**
```sql
SELECT * FROM vicidial_campaigns WHERE campaign_id = 'Colorado';
```

**Check 2: Linked correctly?**
```sql
SELECT closer_campaigns FROM vicidial_campaigns WHERE campaign_id = '4001';
-- Should contain: ColoradoXfer
```

**Check 3: Inbound group active?**
```sql
SELECT active FROM vicidial_inbound_groups WHERE group_id = 'ColoradoXfer';
-- Should return: Y
```

### No Answer on Opt-In Calls

**Problem:** Opt-in calls ringing but no one answers

**Check DID configuration:**
```sql
SELECT did_pattern, extension, user
FROM vicidial_inbound_dids
WHERE group_id = 'ColoradoXfer';
```

**Solution:** Configure phone number/extension in DID settings

---

## 📈 Expected Performance

Based on Missouri campaign (1022) which this was cloned from:

### Dial Rate
- **Calls per hour:** 100-200 (depends on agent availability)
- **Dial level:** 190 (same as Missouri)
- **Dial method:** RATIO (adaptive to agent count)

### Typical Stats (Missouri comparison)
- **Total calls:** 7,910,770 (over 4 months)
- **Daily average:** ~65,000 calls/day
- **Status breakdown:**
  - No answer: ~40%
  - Answering machine: ~30%
  - Connects: ~20%
  - Opt-ins (SVYCLM): ~0.05-0.10%

### Your Colorado Campaign
- Start with small lead batch (1,000 leads)
- Monitor for 1-2 hours
- Adjust dial level based on results
- Scale up when comfortable

---

## 📝 Quick Reference Card

```
┌─────────────────────────────────────────────┐
│  MOSES CLAUDE COLORADO CAMPAIGN             │
│  Campaign ID: 4001                          │
├─────────────────────────────────────────────┤
│  Status: INACTIVE ✅                         │
│  Dial Level: 190                            │
│  Hopper: 4000                               │
│  Recording: ALL CALLS                       │
│  Closer: ColoradoXfer                       │
├─────────────────────────────────────────────┤
│  TO ACTIVATE:                               │
│  1. Configure opt-in phone number           │
│  2. Load Colorado leads                     │
│  3. Test with sample lead                   │
│  4. Set Active = 'Y'                        │
├─────────────────────────────────────────────┤
│  WEB ACCESS:                                │
│  https://dialpower.team                     │
│  /vicidial/admin.php?ADD=34&campaign_id=4001│
├─────────────────────────────────────────────┤
│  DATABASE:                                  │
│  Host: 67.198.205.116                       │
│  DB: asterisk                               │
│  User: cron / 6sfhf9ogku0q                     │
└─────────────────────────────────────────────┘
```

---

## ✅ Final Checklist

### Pre-Launch
- [x] Campaign created
- [x] Settings configured
- [x] Closer campaign linked
- [ ] Opt-in phone configured ⚠️ **YOU NEED TO PROVIDE**
- [ ] Leads loaded
- [ ] Test call completed

### Launch Day
- [ ] Activate campaign (Active='Y')
- [ ] Monitor real-time dashboard
- [ ] Check for any errors
- [ ] Verify recordings working
- [ ] Confirm transfers working

### Post-Launch
- [ ] Review call stats daily
- [ ] Adjust dial level if needed
- [ ] Monitor opt-in rate
- [ ] Check recording storage
- [ ] Track sales/conversions

---

**Created:** October 28, 2025
**Last Updated:** October 28, 2025
**Status:** Ready for opt-in phone configuration

**Next Action Required:** Provide phone number for opt-in routing
