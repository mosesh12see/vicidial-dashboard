# ✅ Moses Claude Colorado - Go Live Checklist

**Campaign:** 4001 - Moses Claude Colorado
**Go Live Date:** Tomorrow (October 29, 2025)
**Current Status:** Configured, INACTIVE (Safe)

---

## 📋 WHAT'S DONE ✅

### Campaign Setup
- [x] Campaign 4001 created
- [x] Cloned from Missouri (1022) template
- [x] Dial settings configured (RATIO, level 190)
- [x] Recording enabled (ALLCALLS, cannot be disabled)
- [x] Campaign set to INACTIVE (won't dial yet)

### Routing Configuration
- [x] ColoradoXfer primary group configured (30 sec ring)
- [x] ColoradoXfer_Failover backup group created (360 sec ring)
- [x] Routing method: Same as Missouri (cascade failover)
- [x] DID configured for (480) 560-8782
- [x] No-answer handling: MESSAGE (voicemail)

### How Routing Works:
```
Opt-in call comes in
    ↓
Rings (480) 560-8782 for 30 seconds
    ↓ (if no answer)
Tries failover for 360 seconds (6 minutes)
    ↓ (if still no answer)
Leaves voicemail message
```

---

## ⏳ WHAT'S LEFT TO DO

### Before Going Live Tomorrow:

#### 1. Audio Files ⚠️ **REQUIRED**

**Minimum Required:**
- [ ] Answering machine message (10-20 seconds)

**What to say:**
```
"Hi, this is [Your Name] with [Company].
We're calling about energy savings in Colorado.
We'll call back soon, or reach us at [Number].
Thank you!"
```

**How to create:**
- Record on phone → Convert to WAV
- Use text-to-speech (Amazon Polly, Google TTS)
- Hire on Fiverr ($5-20)

**Format:** WAV, 8000 Hz, mono

**Upload:**
```bash
# Web Interface (easiest):
Admin → Audio Store → Upload Audio File
Name it: "colorado_amd_message"

# Or SCP:
scp message.wav root@67.198.205.116:/var/lib/asterisk/sounds/en/colorado_amd_message.wav
```

**Link to campaign:**
```
Admin → Campaigns → 4001
→ AM Message Exten: "colorado_amd_message"
→ Submit
```

#### 2. Load Colorado Leads ⚠️ **REQUIRED**

**You mentioned you'll do this - here's how:**

**Option A: Web Interface**
```
1. Admin → Lists → Add New List
   - List ID: 999 (or next available)
   - List Name: "Colorado Leads Oct 2025"
   - Campaign: 4001
   - Active: Y

2. Admin → Lead Loader
   - Campaign: 4001
   - List: 999
   - Upload CSV file
   - Duplicate Check: DUPLIST
```

**Option B: Command Line (Faster for large batches)**
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

**CSV Format Required:**
```csv
phone_number,first_name,last_name,state,vendor_lead_code
3035551234,John,Doe,CO,LEAD001
7205551234,Jane,Smith,CO,LEAD002
```

**Minimum fields:**
- phone_number (10 digits, no formatting)
- first_name
- last_name
- state (must be "CO")

#### 3. Test Campaign ⚠️ **REQUIRED**

**Do this tomorrow morning before going live:**

```
1. Add test lead with YOUR phone number
   Admin → Lists → Click your list → Add Lead
   Phone: [your phone]
   First: Test
   Last: Lead
   State: CO

2. Temporarily activate campaign
   Admin → Campaigns → 4001 → Active: Y → Submit

3. Wait for call (should come within minutes)

4. Answer and verify:
   ✓ Call comes through
   ✓ Recording works
   ✓ Can disposition as SVYCLM (opt-in)

5. Disposition as SVYCLM (opt-in)

6. Verify opt-in transfer:
   ✓ (480) 560-8782 rings
   ✓ If no answer → failover kicks in
   ✓ Recording continues

7. Deactivate campaign
   Admin → Campaigns → 4001 → Active: N → Submit
```

#### 4. Additional Phone Numbers (Optional)

**You asked if you can give more numbers - YES!**

Just tell me:
- The phone numbers
- I'll add them to the failover chain

Each additional number extends the ring time before voicemail.

---

## 🚀 GO LIVE TOMORROW

### Final Activation Steps:

**1. Verify Everything Ready:**
```bash
cd "/Users/mosesherrera/Desktop/vicidial-analysis/Claude Vici Creations"
python3 verify_colorado_campaign.py
```

**2. Activate Campaign:**

**Web Interface:**
```
1. Login: https://dialpower.team/vicidial/admin.php
2. Admin → Campaigns
3. Click "4001"
4. Change Active: N → Y
5. Click SUBMIT
```

**Database (Quick):**
```sql
mysql -h 67.198.205.116 -u cron -p'6sfhf9ogku0q' asterisk -e \
"UPDATE vicidial_campaigns SET active = 'Y' WHERE campaign_id = '4001'"
```

**3. Monitor:**
```
Real-Time Dashboard:
https://dialpower.team/vicidial/admin.php?ADD=999999

Watch for:
- Calls dialing
- Hopper filling
- Agents connecting
- Statuses updating
```

---

## 📊 Expected Behavior

### First Hour:
- System loads 4000 leads into hopper
- Begins dialing at level 190
- Agents receive calls
- Status codes start appearing

### Typical Results (Based on Missouri):
- **Calls per hour:** 100-200
- **No answer:** ~40%
- **Answering machine:** ~30%
- **Connects:** ~20%
- **Opt-ins (SVYCLM):** ~0.05-0.10%

### When Opt-In Happens:
1. Agent dispositions call as SVYCLM
2. Call transfers to ColoradoXfer
3. (480) 560-8782 rings for 30 seconds
4. If no answer → Failover rings 360 seconds
5. If no answer → Voicemail message plays
6. Call logged in vicidial_closer_log

---

## 🛠️ Troubleshooting

### Campaign Not Dialing

**Check:**
```sql
-- Is it active?
SELECT active FROM vicidial_campaigns WHERE campaign_id = '4001';

-- Are there leads in hopper?
SELECT COUNT(*) FROM vicidial_hopper WHERE campaign_id = '4001';

-- Is auto dial level set?
SELECT auto_dial_level FROM vicidial_campaigns WHERE campaign_id = '4001';
```

**Fix:**
```bash
# Force hopper reload
ssh root@67.198.205.116
/usr/share/astguiclient/AST_VDhopper.pl --debug
```

### Transfers Not Working

**Check routing:**
```bash
python3 verify_colorado_campaign.py
```

**Verify DID:**
```sql
SELECT * FROM vicidial_inbound_dids WHERE did_pattern = '4805608782';
```

### Audio Not Playing

**Check audio file:**
```bash
ssh root@67.198.205.116
ls -lh /var/lib/asterisk/sounds/en/ | grep colorado
```

**Test playback:**
```bash
/usr/bin/play /var/lib/asterisk/sounds/en/colorado_amd_message.wav
```

---

## 📞 Contact Configuration

### Currently Configured:
- **Primary:** (480) 560-8782
- **Ring Time:** 30 seconds
- **Failover:** 360 seconds (6 minutes)
- **No Answer:** Voicemail message

### To Add More Numbers:
Just provide them and I'll add to the routing chain.

Each number extends the cascade:
```
Number 1 (30 sec) → Number 2 (30 sec) → Number 3 (30 sec) → Voicemail
```

---

## 🎯 Quick Reference

### Campaign Details:
```
Campaign ID: 4001
Name: Moses Claude Colorado
State: Colorado (CO)
Status: INACTIVE (until tomorrow)
Dial Level: 190
Hopper: 4000
Recording: ALL CALLS
```

### Web Access:
```
Admin: https://dialpower.team/vicidial/admin.php
Campaign: .../admin.php?ADD=34&campaign_id=4001
Real-Time: .../admin.php?ADD=999999
```

### Database:
```
Host: 67.198.205.116
DB: asterisk
User: cron
Pass: 6sfhf9ogku0q
```

---

## 📋 Pre-Launch Checklist

**Tonight (Before Tomorrow):**
- [ ] Create answering machine audio
- [ ] Upload audio to Vicidial
- [ ] Link audio to campaign 4001
- [ ] Load Colorado leads
- [ ] Verify leads loaded correctly

**Tomorrow Morning (Before Activation):**
- [ ] Test call with your phone number
- [ ] Verify recording works
- [ ] Verify opt-in transfer works
- [ ] Check audio plays on machines
- [ ] Review hopper levels

**Tomorrow (Go Live):**
- [ ] Set Active='Y'
- [ ] Monitor real-time dashboard
- [ ] Watch for errors
- [ ] Check first opt-in transfers
- [ ] Adjust dial level if needed

---

## ✅ CURRENT STATUS

**READY:** ✅ Routing configured (Missouri style)
**READY:** ✅ Phone number configured (480) 560-8782
**READY:** ✅ Campaign cloned and configured
**READY:** ✅ Failover system in place

**NEEDED:** ⏳ Audio files (answering machine message)
**NEEDED:** ⏳ Colorado leads loaded
**NEEDED:** ⏳ Test call completed

**TOMORROW:** 🚀 Set Active='Y' and go live!

---

**Last Updated:** October 28, 2025
**Go Live:** October 29, 2025
**Status:** Ready (pending audio + leads)
