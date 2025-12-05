# 🚀 Claude Vici Creations

**Campaign Creation & Management Tools**

---

## ⚠️ IMPORTANT: This folder is SEPARATE from vicidial-analysis

**This folder (`Claude Vici Creations`)** contains:
- Campaign creation scripts
- Campaign cloning tools
- Campaign management utilities
- Campaign setup documentation

**The other folder (`vicidial-analysis`)** contains:
- Stats dashboard generation
- HTML report creation
- Historical data analysis
- Performance tracking

**DO NOT CONFUSE THE TWO!**

---

## 📂 What's in This Folder

### Campaign Creation Scripts

**`clone_missouri_auto.py`** - Main automation script
- Automatically clones Missouri campaign (1022)
- Creates new campaigns with proper configuration
- Safe mode: Creates campaigns as INACTIVE
- Used to create: Moses Claude Colorado (Campaign 4001)

**`check_campaigns.py`** - Verification tool
- Lists all campaigns in database
- Shows active/inactive status
- Checks for linked campaigns and inbound groups

**`verify_colorado_campaign.py`** - Post-creation verification
- Verifies campaign configuration
- Checks all linkages
- Provides next steps for activation

**`create_coloradoxfer.py`** - Closer campaign creator
- Creates transfer/closer campaigns
- Sets up inbound routing

---

## ✅ What Has Been Created

### Campaign: Moses Claude Colorado

**Campaign ID:** 4001
**Campaign Name:** Moses Claude Colorado
**State:** Colorado (CO)
**Status:** INACTIVE (safe, won't dial)

**Configuration:**
- Cloned from: Missouri campaign (1022)
- Dial Method: RATIO
- Auto Dial Level: 190
- Hopper Level: 4000
- Recording: ALLCALLS
- Dial Timeout: 40 seconds
- Lead Order: DOWN COUNT

### Closer Campaign: Colorado

**Campaign ID:** Colorado
**Campaign Name:** Colorado Transfer Campaign
**Type:** INBOUND_MAN
**Status:** ACTIVE

### Inbound Group: ColoradoXfer

**Group ID:** ColoradoXfer
**Group Name:** Colorado Transfer Queue
**Status:** ACTIVE
**Queue Priority:** 50
**Drop Call Seconds:** 360

---

## 🔗 How It Works

```
┌─────────────────────────────────────┐
│  Campaign 4001                      │
│  Moses Claude Colorado              │
│  (INACTIVE - Safe)                  │
│                                     │
│  • Dials Colorado leads             │
│  • Records all calls                │
│  • Auto dial level: 190             │
└──────────┬──────────────────────────┘
           │
           │ When lead gets SVYCLM status
           │ (opt-in / interested)
           ↓
┌─────────────────────────────────────┐
│  Closer Campaign: Colorado          │
│  (ACTIVE)                           │
│                                     │
│  • Receives transferred calls       │
│  • Routes to inbound group          │
└──────────┬──────────────────────────┘
           │
           ↓
┌─────────────────────────────────────┐
│  Inbound Group: ColoradoXfer        │
│                                     │
│  • Queues incoming opt-ins          │
│  • Routes to agent/phone number     │
│  • Handles no-answer scenarios      │
└─────────────────────────────────────┘
```

---

## 🔧 Database Credentials

**Location:** These scripts use embedded credentials
- Host: 67.198.205.116
- Database: asterisk
- User: cron
- Password: 6sfhf9ogku0q

**⚠️ READ-ONLY RULES:**
- These scripts create/update campaigns
- They do NOT modify lead data
- They do NOT affect active campaigns
- Safe to run - campaigns start INACTIVE

---

## 📝 Next Steps to Activate Campaign

### 1. Configure DID (Phone Number) for Opt-In Routing

You need to tell Vicidial what phone number should ring when someone opts in:

**Option A: Web Interface**
1. Go to: https://dialpower.team/vicidial/admin.php
2. Navigate: Admin → DIDs/Inbound → Add New DID
3. Configure:
   - DID Number: [Your opt-in phone number]
   - Campaign: Colorado
   - Group: ColoradoXfer
   - Route: AGENT or PHONE
   - Extension: [Where calls should ring]

**Option B: Remote Agent Setup**
- Set up remote agents with cell phones
- Configure round-robin routing
- Auto-failover if agent doesn't answer
- See: `/Users/mosesherrera/Desktop/vicidial-analysis/CAMPAIGN_SETUP_GUIDE.md` (Step 7)

### 2. Load Colorado Leads

**Web Upload (Small batches):**
1. Admin → Lists → Add New List
   - List ID: 999 (or next available)
   - Campaign: 4001
   - Active: Y
2. Admin → Lead Loader
   - Upload CSV file
   - Minimum fields: phone, first_name, last_name, state

**Command Line (Large batches):**
```bash
ssh root@67.198.205.116
cd /usr/share/astguiclient
./AST_lead_loader.pl \
  --file=/tmp/colorado_leads.csv \
  --campaign-id=4001 \
  --list-id=999 \
  --phone-code=1 \
  --duplicate-check=DUPLIST
```

### 3. Test with Sample Lead

Before going live:
1. Add a test lead with YOUR phone number
2. Temporarily set campaign 4001 Active='Y'
3. Verify:
   - Call comes through
   - Recording works
   - Transfer to opt-in number works
   - Failover works (if configured)
4. Set back to Active='N'

### 4. Activate Campaign

When ready to go live:

**Option A: Web Interface**
1. Admin → Campaigns → Click 4001
2. Set Active = 'Y'
3. Click SUBMIT

**Option B: Database (Quick)**
```sql
UPDATE vicidial_campaigns
SET active = 'Y'
WHERE campaign_id = '4001';
```

**Monitor:** https://dialpower.team/vicidial/admin.php?ADD=999999

---

## 🛡️ Safety Features

### Campaign Starts INACTIVE
- Campaign 4001 is created with Active='N'
- Will NOT dial until you manually activate it
- Safe to configure and test first

### Cloned from Proven Campaign
- All settings copied from Missouri (1022)
- Missouri has made 7.9M calls successfully
- Proven dial settings and configuration

### Recording Enabled
- All calls recorded: ALLCALLS
- Recording override: DISABLED
- Agents cannot disable recording
- Compliance-ready

---

## 📊 Monitoring & Reports

### Real-Time Monitoring
- **Active Calls:** http://67.198.205.116/vicidial/admin.php?ADD=999999
- **Agent Status:** http://67.198.205.116/vicidial/user_stats.php
- **Hopper Status:** http://67.198.205.116/vicidial/AST_VDhopper.php

### Reports
- **Campaign Stats:** Admin → Reports → Campaign Detail
- **Call Logs:** Admin → Reports → Lead Search
- **Recordings:** Admin → Recordings

### Database Queries
```sql
-- Campaign performance
SELECT COUNT(*) as calls, status
FROM vicidial_log
WHERE campaign_id = '4001'
GROUP BY status;

-- Opt-ins transferred
SELECT COUNT(*) as opt_ins
FROM vicidial_log
WHERE campaign_id = '4001'
AND status = 'SVYCLM';

-- Sales closed
SELECT COUNT(*) as sales
FROM vicidial_closer_log
WHERE campaign_id = 'Colorado'
AND status = 'SALE';
```

---

## 🔍 Verification Commands

### Check Campaign Exists
```bash
python3 check_campaigns.py
```

### Verify Full Configuration
```bash
python3 verify_colorado_campaign.py
```

### Quick Database Check
```sql
mysql -h 67.198.205.116 -u cron -p'6sfhf9ogku0q' asterisk -e \
"SELECT campaign_id, campaign_name, active, dial_method, auto_dial_level
 FROM vicidial_campaigns
 WHERE campaign_id = '4001'"
```

---

## 📚 Related Documentation

**In this folder:**
- This README - Campaign creation overview

**In `/Users/mosesherrera/Desktop/vicidial-analysis/`:**
- `CAMPAIGN_SETUP_GUIDE.md` - Complete step-by-step setup guide
- `CAMPAIGN_REFERENCE.md` - All existing campaigns and states
- `VICIDIAL_API_ACCESS.md` - Database access guide
- `FASTEST_ACCESS.md` - Quick access methods

---

## ⚙️ Script Usage Examples

### Clone Another Campaign

To clone a different campaign (e.g., Georgia):

```python
# Edit clone_missouri_auto.py
# Change line:
missouri_campaign = get_campaign_details(conn, '1022')
# To:
georgia_campaign = get_campaign_details(conn, '1027')

# Change campaign name:
clone_sql = create_clone_sql(georgia_campaign, next_id, "New Campaign Name")
```

### Check All Campaigns
```bash
python3 check_campaigns.py
```

Output shows:
- All campaign IDs
- Campaign names
- Active/inactive status
- Descriptions

---

## 🚨 Troubleshooting

### Issue: "Duplicate entry for key PRIMARY"
**Cause:** Campaign ID already exists
**Fix:** Script will auto-find next available ID

### Issue: "ColoradoXfer not found"
**Cause:** Closer campaign creation failed
**Fix:** Run `create_coloradoxfer.py`

### Issue: Campaign won't dial
**Check:**
1. Campaign Active = 'Y'?
2. Leads loaded?
3. Auto Dial Level > 0?
4. Hopper has leads?

**Fix:**
```sql
-- Check hopper
SELECT COUNT(*) FROM vicidial_hopper WHERE campaign_id = '4001';

-- Force hopper load
/usr/share/astguiclient/AST_VDhopper.pl --debug
```

---

## 📞 Campaign 4001 - Quick Reference

| Setting | Value | Description |
|---------|-------|-------------|
| Campaign ID | 4001 | Unique identifier |
| Name | Moses Claude Colorado | Display name |
| State | Colorado (CO) | Target state |
| Active | N | INACTIVE (safe) |
| Dial Method | RATIO | Adaptive dialing |
| Auto Dial Level | 190 | Aggressiveness |
| Hopper Level | 4000 | Queue size |
| Dial Timeout | 40s | Ring time |
| Recording | ALLCALLS | Record everything |
| Closer | Colorado/ColoradoXfer | Transfer destination |

---

## 🎯 Quick Start Checklist

- [x] Campaign 4001 created
- [x] Closer campaign created
- [x] Inbound group created
- [x] Campaigns linked
- [ ] DID/phone number configured
- [ ] Remote agents set up (optional)
- [ ] Colorado leads loaded
- [ ] Test call completed
- [ ] Campaign activated

---

## 📅 Created

**Date:** October 28, 2025
**Created By:** Claude (Automated)
**Template:** Missouri Campaign (1022)
**Target:** Colorado outbound calling

---

**Last Updated:** October 28, 2025
