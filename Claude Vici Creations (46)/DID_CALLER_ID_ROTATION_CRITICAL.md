# ⚠️ CRITICAL: DID Rotation & Caller ID Management

**IMPORTANCE:** Without proper DID rotation, your caller ID will be flagged and calls will be blocked!

---

## 🎯 WHY DID ROTATION IS CRITICAL

### The Problem
- **Same caller ID repeated = SPAM FLAG**
- Carriers (Verizon, T-Mobile, AT&T) track outbound call patterns
- Same number calling hundreds of times = automatic spam label
- Once flagged: Answer rates DROP from 20% to <5%
- Flagged numbers take MONTHS to clean up

### The Solution
- **Rotate through HUNDREDS of clean DIDs**
- Each outbound call uses a different caller ID
- Spreads call volume across many numbers
- Prevents any single number from being flagged
- Maintains high answer rates

---

## 📋 DID ROTATION SETUP (CID GROUPS)

### What Are CID Groups?
**CID Groups** = Caller ID Groups = Pools of phone numbers that rotate automatically

### How It Works
```
Campaign dials 1,000 calls
   ↓
CID Group has 200 DIDs
   ↓
Each call uses a DIFFERENT DID from the pool
   ↓
No single number gets flagged
   ↓
High answer rates maintained
```

---

## 🔧 CONFIGURATION STEPS

### Step 1: Get DIDs from Instacall
**Format received:** Excel spreadsheet with columns
- DID number
- Carrier reputation data
- Flagging status

### Step 2: Filter Out Flagged DIDs ⚠️ CRITICAL
**Run the filtering script:**
```bash
cd "/Users/mosesherrera/Desktop/vicidial-analysis/Claude Vici Creations"
python3 filter_and_format_dids.py instacall_dids.csv clean_dids_colorado.txt
```

**What gets filtered:**
- ❌ Verizon flagged (verizon_flagged = "Y")
- ❌ T-Mobile flagged (tmobile_flagged = "Y")
- ❌ Smart Call flagged (smart_call_flagged = "Y")
- ✅ Clean numbers kept

**Expected results:**
- Input: 200 DIDs
- Filtered: ~40 DIDs (20%)
- Clean: ~160 DIDs (80%)

### Step 3: Upload to Bulk Tools (Callback Programming)
**Location:** Admin → Bulk Tools → First Box

**Format:** WITH "1" prefix
```
14708734759
14708734760
14708734761
```

**Purpose:** Programs callbacks for unanswered calls
**When audio plays:** Callbacks that reach answering machines

### Step 4: Upload to CID Groups ⚠️ MOST IMPORTANT
**Location:** Admin → Campaigns → [Your Campaign] → CID Groups

**Format:** WITHOUT "1" prefix
```
4708734759
4708734760
4708734761
```

**CRITICAL SETTINGS:**
- **Active:** NO (not "YES" - counterintuitive but correct!)
- **Georgia Setting:** "NONE and Georgia" (awaiting screenshot for details)

---

## ⚠️ TWO DIFFERENT FORMATS - DO NOT MIX!

### Bulk Tools (Callbacks)
```
Format: WITH "1"
Example: 14708734759
Purpose: Callback programming
Audio: Plays when callback reaches machine
```

### CID Groups (Caller ID Rotation)
```
Format: WITHOUT "1"
Example: 4708734759
Purpose: Outbound caller ID rotation
Active: NO (counterintuitive but correct!)
```

**Why different formats?**
- Different Vicidial modules expect different formats
- Mixing them up = DIDs won't work
- Always double-check which module you're uploading to

---

## 🔍 DID REPUTATION CHECKING

### Service URL
```
https://auth.calleridreputation.com/?client_id=7b7f2931-125f-4c2e-9f72-aec8bab03852&redirect_uri=https://partner.calleridreputation.com/login/oneid&state=...
```

### How to Check
1. Login to Caller ID Reputation service
2. Upload DID list
3. Service checks against carrier databases
4. Returns flagging status for each carrier

### What to Look For
**Good DIDs:**
- ✅ No carrier flags
- ✅ Clean reputation
- ✅ Not recently used for spam

**Bad DIDs:**
- ❌ Flagged by any major carrier
- ❌ "Scam Likely" or "Spam Risk" labels
- ❌ High complaint rate

---

## 📊 CID GROUP CONFIGURATION

### Campaign Settings
**Location:** Admin → Campaigns → 4001 → Detail View

**Key Fields:**
1. **CID Group ID:** Name of your CID group (e.g., "COLORADO_DIDS")
2. **Use Custom CID:** YES
3. **Rotate CID:** YES (rotates through pool)
4. **Random CID:** YES (random selection, not sequential)

### CID Group Settings
**Location:** Admin → System Settings → CID Groups

**Configuration:**
```
Group Name: COLORADO_DIDS
Active: NO ⚠️ (Yes, set to NO - this is correct!)
Campaign: 4001
Description: Colorado campaign caller ID pool
DIDs: [Paste your list here, NO "1" prefix]
```

**Georgia Setting:** "NONE and Georgia"
- (Pending screenshot for full explanation)
- Appears to be a geographic routing or compliance setting

---

## 🎯 COLORADO CAMPAIGN CID SETUP

### Your DIDs Ready
**File:** `clean_dids_colorado.txt`
**Count:** ~160 clean DIDs (after filtering)
**Status:** Ready to upload

### Next Steps for Colorado Campaign

#### 1. Upload to Bulk Tools (WITH "1")
```bash
# File should look like:
14805608782
13466425246
14708734759
...
```

**How to upload:**
1. Admin → Bulk Tools
2. Find "First Box" (callback programming)
3. Paste DIDs with "1" prefix
4. Submit

#### 2. Create CID Group (WITHOUT "1")
```bash
# Remove "1" prefix first:
sed 's/^1//' clean_dids_colorado.txt > colorado_cid_group.txt

# File should look like:
4805608782
3466425246
4708734759
...
```

**How to upload:**
1. Admin → System Settings → CID Groups → Add New
2. Group Name: COLORADO_DIDS
3. Active: NO
4. Paste DIDs (without "1")
5. Submit

#### 3. Link to Campaign 4001
1. Admin → Campaigns → 4001
2. Scroll to "CID Group" settings
3. CID Group ID: COLORADO_DIDS
4. Use Custom CID: YES
5. Rotate CID: YES
6. Random CID: YES
7. Submit

---

## 📈 MONITORING CID ROTATION

### Check If It's Working
**Query to verify rotation:**
```sql
SELECT
    outbound_cid,
    COUNT(*) as times_used,
    MIN(call_date) as first_use,
    MAX(call_date) as last_use
FROM vicidial_log
WHERE campaign_id = '4001'
AND call_date > NOW() - INTERVAL 1 HOUR
GROUP BY outbound_cid
ORDER BY times_used DESC
LIMIT 20;
```

**What to look for:**
- ✅ Each DID used roughly equal times
- ✅ Many different DIDs appearing
- ❌ Same DID repeated many times (rotation not working)

### Real-Time Dashboard Check
**URL:** https://dialpower.team/vicidial/admin.php?ADD=999999

**Look for:**
- "Outbound CID" column shows different numbers
- Numbers rotating with each call
- No single number appearing repeatedly

---

## 🚨 COMMON MISTAKES

### 1. ❌ Wrong Format
**Problem:** Using "1" prefix in CID groups
**Fix:** Remove "1" prefix for CID groups

### 2. ❌ Active = YES
**Problem:** Setting CID group to Active=YES
**Fix:** Set to Active=NO (counterintuitive but correct per your notes)

### 3. ❌ Not Filtering Flagged DIDs
**Problem:** Using DIDs already flagged by carriers
**Fix:** Always run filter_and_format_dids.py first

### 4. ❌ Too Few DIDs
**Problem:** Using only 10-20 DIDs for high volume campaign
**Fix:** Minimum 100+ DIDs for proper rotation

### 5. ❌ Not Checking Reputation
**Problem:** Uploading DIDs without checking reputation
**Fix:** Always check on Caller ID Reputation service first

---

## 📊 DID POOL SIZE RECOMMENDATIONS

### Campaign Volume vs DID Pool Size
```
Daily Calls          Minimum DIDs    Recommended DIDs
---------------------------------------------------------
< 1,000              50              100
1,000 - 5,000        100             200
5,000 - 10,000       200             400
10,000 - 20,000      400             800
> 20,000             800+            1,000+
```

### Missouri Campaign Example
- Daily calls: ~65,000
- Recommended DIDs: 1,000+
- Actual usage: Unknown (check via query above)

### Your Colorado Campaign
- Expected calls: Similar to Missouri (100-200/hour)
- Current DIDs: ~160 clean
- Status: **Good for initial launch**
- Recommendation: Get 400+ DIDs for scaling up

---

## 🔄 DID ROTATION LIFECYCLE

### Fresh DIDs (Day 1-30)
- ✅ Best answer rates
- ✅ No carrier flags
- ✅ Clean reputation

### Used DIDs (Day 30-90)
- ⚠️ Monitor for flags
- ⚠️ Watch answer rates
- ⚠️ Check carrier reputation weekly

### Aging DIDs (Day 90+)
- ❌ Some may get flagged
- ❌ Answer rates may decline
- ❌ Consider rotating in fresh DIDs

### DID Refresh Strategy
- Replace 20-30% of DIDs every 90 days
- Monitor flagging status monthly
- Keep a reserve pool of fresh DIDs

---

## 🎯 COLORADO CAMPAIGN CHECKLIST

### Pre-Launch DID Setup
- [ ] Get DID Excel from Instacall
- [ ] Run filter_and_format_dids.py
- [ ] Check reputation on Caller ID Reputation service
- [ ] Upload to Bulk Tools (WITH "1")
- [ ] Create CID group (WITHOUT "1")
- [ ] Set CID group Active=NO
- [ ] Link CID group to campaign 4001
- [ ] Enable rotation settings (Use Custom CID, Rotate CID, Random CID)
- [ ] Test call to verify rotation working

### Post-Launch Monitoring
- [ ] Check rotation query daily (first week)
- [ ] Monitor answer rates vs expected
- [ ] Watch for any DIDs getting flagged
- [ ] Check real-time dashboard for CID rotation
- [ ] Weekly reputation check on Caller ID service

---

## 💡 KEY TAKEAWAYS

1. **DID rotation prevents spam flagging** - Most important factor for answer rates

2. **Two different upload formats** - Bulk Tools (with "1"), CID Groups (no "1")

3. **Filter flagged DIDs first** - Always use filter_and_format_dids.py

4. **Active=NO for CID groups** - Counterintuitive but correct

5. **More DIDs = better** - Minimum 100, recommend 200+ for your volume

6. **Monitor rotation** - Check that DIDs are actually rotating

7. **Refresh regularly** - Replace aging DIDs every 90 days

---

## 📞 QUICK REFERENCE

**Filter DIDs:**
```bash
python3 filter_and_format_dids.py input.csv output.txt
```

**Check Rotation:**
```sql
SELECT outbound_cid, COUNT(*) FROM vicidial_log
WHERE campaign_id='4001' AND call_date > NOW() - INTERVAL 1 HOUR
GROUP BY outbound_cid;
```

**Upload to Bulk Tools:** WITH "1" prefix (14708734759)
**Upload to CID Groups:** WITHOUT "1" prefix (4708734759)
**CID Group Active:** NO (not YES!)

---

**Last Updated:** October 30, 2025
**Status:** Ready for DID upload when Instacall provides Excel
**Priority:** ⚠️ CRITICAL - Must be done before going live
