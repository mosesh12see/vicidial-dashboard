# 📝 MASTER NOTES - Moses Claude Colorado Campaign

**Campaign ID:** 4001
**Campaign Name:** Moses Claude Colorado
**Created:** October 28, 2025
**Last Updated:** October 30, 2025

---

## ⚠️ CRITICAL NEW DOCUMENTS (October 30, 2025)

### 🎯 DID Caller ID Rotation (MOST IMPORTANT!)
**File:** `DID_CALLER_ID_ROTATION_CRITICAL.md`
**Why critical:** Without proper DID rotation, your calls will be flagged as spam!
**Contents:**
- Why DID rotation prevents spam flagging
- Two different upload formats (Bulk Tools vs CID Groups)
- Step-by-step configuration guide
- Monitoring and troubleshooting

### 🎙️ AI Audio Files Inventory
**Folder:** `Ai Audios Vici/`
**Contents:**
- List of all 6 audio files currently in use
- AUDIO_FILES_LIST.md - Complete inventory
- download_audio_files.sh - Automated download script
- Audio format requirements and conversion guide

**Audio Files Found:**
1. AaronAmarenIllinois.wav (Illinois campaign)
2. AylaHannahGeorgiaPower.wav (Georgia campaign)
3. HannahStLouisMissouriAmeren.wav (Missouri + YOUR Colorado campaign)
4. Wrapup Call.wav (All campaigns)
5. jerseysincere.wav (New Jersey campaigns)
6. silence2seconds.wav (No voicemail message - most campaigns use this)

**To download when SSH available:**
```bash
cd "Ai Audios Vici"
./download_audio_files.sh
```

---

## ✅ COMPLETED SETUP

### Campaign Configuration
- [x] Campaign 4001 created (cloned from Missouri 1022)
- [x] Status: INACTIVE (safe, ready for activation)
- [x] Dial Method: RATIO
- [x] Auto Dial Level: 190
- [x] Hopper Level: 4000
- [x] Recording: ALLCALLS (cannot be disabled)
- [x] Closer campaigns linked

### Opt-In Phone Routing (Missouri Style)
- [x] Primary: +1 (480) 560-8782 (rings 30 seconds)
- [x] Secondary: +1 (346) 642-5246 (rings 30 seconds if primary no answer)
- [x] Failover: ColoradoXfer_Failover (rings 360 seconds / 6 minutes)
- [x] No Answer Action: MESSAGE (voicemail)
- [x] Total cascade time: 7 minutes before voicemail

**Call Flow:**
```
Opt-in (SVYCLM) → (480) 560-8782 (30s) → (346) 642-5246 (30s) → Failover (6min) → Voicemail
```

### Routing Groups Created
- [x] ColoradoXfer - Primary inbound group
- [x] ColoradoXfer_Secondary - Secondary routing
- [x] ColoradoXfer_Failover - Extended failover
- [x] All linked to Campaign 4001

---

## 📞 DID MANAGEMENT

### DID Reputation Checking
**Service:** https://auth.calleridreputation.com/?client_id=7b7f2931-125f-4c2e-9f72-aec8bab03852&redirect_uri=https://partner.calleridreputation.com/login/oneid&state=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdGF0ZVRva2VuIjoiTWE3aWotNVNpaE1NaUdaMCIsImlzcyI6IjdiN2YyOTMxLTEyNWYtNGMyZS05ZjcyLWFlYzhiYWIwMzg1MiIsImV4cCI6MTc2MTY5NTM0MSwibmJmIjoxNzYxNjk1MDQxLCJpYXQiOjE3NjE2OTUwNDF9.S3TtaS1384S42m2nXQxPdPztQ5t_xNW8Mok-JyYkago

**Purpose:** Check DIDs are good before using

**Process:**
1. Instacall provides Excel with DIDs
2. Check each DID on Caller ID Reputation service
3. Filter out flagged numbers
4. Upload to Vicidial

### DID Filtering Rules
**ELIMINATE numbers flagged by:**
- Verizon (`verizon_flagged = "Y"`)
- T-Mobile (`tmobile_flagged = "Y"`)
- Smart Call (`smart_call_flagged = "Y"`)

**Example Results:**
- From 200 DIDs: Filtered 40 (20%), Kept 160 (80%)

**Script:** `filter_and_format_dids.py`
```bash
python3 filter_and_format_dids.py input.csv output.txt
```

### DID Upload Formats ⚠️ IMPORTANT

**Two Different Processes:**

#### 1. DID Bulk Copy (First Box in Bulk Tools)
- **Format:** WITH "1" prefix
- **Example:** `14708734759`
- **Used for:** Programming callbacks
- **When callback happens:** Audio message plays

#### 2. CID Groups (Caller ID Groups) ⚠️ PENDING SCREENSHOT
- **Format:** WITHOUT "1" prefix
- **Example:** `4708734759` (NO leading 1)
- **Active:** Set to "No"
- **Georgia settings:** "NONE and Georgia" (awaiting screenshot for details)
- **Used for:** Outbound caller ID rotation

---

## 🎙️ AUDIO REQUIREMENTS

### Strongly Recommended Format
**From Admin → Audio Store:**
- **Format:** 16bit Mono 8k PCM WAV (.wav)
- **Bit depth:** 16-bit
- **Channels:** Mono (single channel)
- **Sample rate:** 8000 Hz (8k)
- **Encoding:** PCM (uncompressed)
- **Length:** 10-30 seconds max
- **Filename:** No spaces (automatically stripped)

### Audio Usage
**Answering Machine Message (OUTBOUND):**
- Plays when campaign dials out and reaches voicemail
- Leaves message on prospect's answering machine
- Required for campaign to leave voicemails

**NOT used for opt-in transfers** - Those just ring your phones

### Configuration
**After upload, link to campaign:**
```
Admin → Campaigns → 4001
→ Field: "AM Message Exten"
→ Enter: audio_filename (without .wav)
→ Submit
```

**Missouri uses:** `silence2seconds` (doesn't leave voicemail, just hangs up)

---

## 📊 CALLBACK PROGRAMMING

### Bulk Tools - First Box
**Purpose:** Programs callbacks for unanswered calls

**How it works:**
1. Campaign dials, gets no answer/busy/voicemail
2. Callback is programmed
3. System calls back later
4. **When callback reaches answering machine → Audio plays**

**This is when your outbound audio message activates!**

---

## 🔄 LEAD LOADING

### CSV Format Required
**Minimum fields:**
```csv
phone_number,first_name,last_name,state,vendor_lead_code
3035551234,John,Doe,CO,LEAD001
```

### Upload Methods

**Option 1: Web Interface**
```
1. Admin → Lists → Add New List
   - Campaign: 4001
   - Active: Y
2. Admin → Lead Loader
   - Upload CSV
   - Duplicate Check: DUPLIST
```

**Option 2: Command Line**
```bash
ssh root@67.198.205.116
cd /usr/share/astguiclient
./AST_lead_loader.pl \
  --file=/tmp/colorado.csv \
  --campaign-id=4001 \
  --list-id=999 \
  --phone-code=1 \
  --duplicate-check=DUPLIST
```

---

## 📋 PRE-LAUNCH CHECKLIST

### Still Needed Before Go-Live:

#### 1. Audio File Upload ⚠️ REQUIRED
- [ ] Create/record answering machine message (10-20 sec)
- [ ] Convert to 16bit Mono 8k PCM WAV format
- [ ] Upload via Admin → Audio Store
- [ ] Link to Campaign 4001 (AM Message Exten field)

#### 2. DID Setup ⚠️ PENDING SCREENSHOT
- [ ] Get CID Groups screenshot
- [ ] Understand "Georgia NONE and Georgia" setting
- [ ] Configure CID groups with Active = No
- [ ] Upload DIDs WITHOUT "1" prefix to CID groups
- [ ] Get Instacall DID Excel
- [ ] Filter carrier-flagged numbers
- [ ] Upload to Bulk Tools (WITH "1" prefix)

#### 3. Lead Loading
- [ ] Prepare Colorado leads CSV
- [ ] Upload via Lead Loader
- [ ] Verify hopper fills

#### 4. Testing
- [ ] Add test lead with your phone
- [ ] Activate campaign temporarily
- [ ] Verify call comes through
- [ ] Test opt-in transfer to both phones
- [ ] Verify cascade routing works
- [ ] Check audio plays on machines
- [ ] Deactivate campaign

#### 5. Go Live (Tomorrow)
- [ ] Set Active='Y'
- [ ] Monitor real-time dashboard
- [ ] Check recordings
- [ ] Verify opt-in transfers work
- [ ] Monitor answer rates

---

## 🔗 IMPORTANT URLS

**Vicidial Access:**
- Admin: https://dialpower.team/vicidial/admin.php
- Campaign 4001: https://dialpower.team/vicidial/admin.php?ADD=34&campaign_id=4001
- Real-Time Monitor: https://dialpower.team/vicidial/admin.php?ADD=999999
- Bulk Tools: Admin → Bulk Tools

**DID Reputation:**
- Caller ID Reputation: (see full URL above)

**Database:**
```
Host: 67.198.205.116
Database: asterisk
User: cron
Password: 6sfhf9ogku0q
Port: 3306
```

---

## 📂 SCRIPTS & TOOLS

### Located in: `/Users/mosesherrera/Desktop/vicidial-analysis/Claude Vici Creations/`

**Filtering & Formatting:**
- `filter_and_format_dids.py` - Filter flagged DIDs + add "1" prefix
- Usage: `python3 filter_and_format_dids.py input.csv output.txt`

**Verification:**
- `verify_colorado_campaign.py` - Verify campaign configuration
- `check_campaigns.py` - List all campaigns

**Setup Scripts:**
- `clone_missouri_auto.py` - Campaign cloning (already used)
- `setup_missouri_style_routing.py` - Routing config (already used)

---

## 📖 DOCUMENTATION FILES

**Start Here:**
- `START_HERE.md` - Quick start guide
- `SUMMARY.md` - What's done, what's next
- `GO_LIVE_CHECKLIST.md` - Pre-launch checklist

**Complete Guides:**
- `MOSES_CLAUDE_COLORADO_CAMPAIGN.md` - Full campaign documentation
- `README.md` - Complete toolkit reference
- `AUDIO_REQUIREMENTS.md` - Audio file specifications
- `LEAD_FILTERING_GUIDE.md` - DID filtering process
- `DID_VERIFICATION_PROCESS.md` - Reputation checking

**This File:**
- `MASTER_NOTES.md` - All important notes consolidated

---

## ⚠️ CRITICAL REMINDERS

### DO NOT Forget:

1. **DID Formats are Different:**
   - Bulk Tools (callbacks): WITH "1" prefix
   - CID Groups: WITHOUT "1" prefix

2. **Audio Format is Specific:**
   - Must be 16bit Mono 8k PCM WAV
   - No spaces in filename

3. **Filtering is Required:**
   - Always filter Verizon/T-Mobile/Smart Call flagged numbers
   - Check reputation before using DIDs

4. **Campaign Starts INACTIVE:**
   - Safe to configure
   - Won't dial until Active='Y'

5. **Opt-In Phones Configured:**
   - (480) 560-8782 - Primary
   - (346) 642-5246 - Secondary
   - Both need to be reachable tomorrow

---

## 🔍 PENDING INFORMATION

### Awaiting from User:

1. **CID Groups Screenshot** ⚠️ NEEDED
   - Shows how to configure caller ID groups
   - "Active = No" setting
   - "Georgia NONE and Georgia" explanation
   - Number format confirmation (no "1" prefix)

2. **Audio File** ⚠️ NEEDED
   - Answering machine message
   - 10-20 seconds
   - Will need to convert to proper format

3. **Instacall DID Excel** ⚠️ NEEDED
   - Once received, filter and upload
   - Use for outbound caller ID

---

## 📊 CAMPAIGN STATISTICS (Expected)

### Based on Missouri (Template):
- **Calls per hour:** 100-200
- **No answer:** ~40%
- **Answering machine:** ~30%
- **Connects:** ~20%
- **Opt-ins (SVYCLM):** ~0.05-0.10%

### DID Filtering (From Example):
- **Total DIDs:** 200
- **Filtered:** 40 (20%)
- **Clean:** 160 (80%)

---

## 🎯 TOMORROW'S PLAN

### Morning:
1. Upload audio file
2. Upload & filter DIDs (if Instacall provides)
3. Configure CID groups (after screenshot review)
4. Load Colorado leads
5. Test campaign

### Afternoon:
1. Set Active='Y'
2. Monitor dashboard
3. Verify opt-in routing
4. Check recordings
5. Monitor performance

---

## 📞 QUICK REFERENCE

**Activate Campaign:**
```sql
UPDATE vicidial_campaigns SET active = 'Y' WHERE campaign_id = '4001';
```

**Check Status:**
```sql
SELECT campaign_id, campaign_name, active, auto_dial_level
FROM vicidial_campaigns WHERE campaign_id = '4001';
```

**Check Hopper:**
```sql
SELECT COUNT(*) FROM vicidial_hopper WHERE campaign_id = '4001';
```

---

## 💡 NOTES FROM CONVERSATION

### Important Clarifications:

1. **Audio is for OUTBOUND calls** - Not for opt-in transfers
2. **Callback programming triggers audio** - When callback reaches machine
3. **Two DID upload methods** - Different number formats for each
4. **Missouri routing replicated** - Proven 7.9M call template
5. **Carrier filtering critical** - Flagged numbers = poor performance

### User Preferences:
- Same routing as Missouri (cascade failover)
- Same no-answer handling as Missouri (MESSAGE)
- Filter out carrier-flagged DIDs
- Active = No for CID groups
- DIDs need "1" for bulk copy, no "1" for CID groups

---

**Last Updated:** October 28, 2025
**Status:** Awaiting CID groups screenshot, audio file, and Instacall DIDs
**Ready for:** Go-live tomorrow after final configuration
