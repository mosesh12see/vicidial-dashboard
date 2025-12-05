# 🔍 Lead Filtering Guide - Eliminate Carrier-Flagged Numbers

**Campaign:** Moses Claude Colorado (4001)
**Date:** October 28, 2025

---

## ⚠️ Filtering Requirements

### Eliminate Numbers Flagged By:
1. **Verizon** - Column: `verizon_flagged`
2. **T-Mobile** - Column: `tmobile_flagged`
3. **Smart Call** - Column: `smart_call_flagged`

### Filtering Rule:

**DON'T CALL if ANY of these are "Y":**
```
verizon_flagged = "Y"  → ELIMINATE
tmobile_flagged = "Y"  → ELIMINATE
smart_call_flagged = "Y" → ELIMINATE
```

**Only call if ALL are "N":**
```
verizon_flagged = "N" AND
tmobile_flagged = "N" AND
smart_call_flagged = "N"
→ KEEP (Safe to call)
```

---

## 📊 Why Filter These Numbers?

### Carrier Flagging Impact:

**When Verizon/T-Mobile/Smart Call flag a number:**
- Shows as "Scam Likely" or "Spam Risk" on recipient's phone
- **Significantly lower answer rates** (often <5%)
- Damages other numbers in your DID pool
- Can trigger carrier-level blocking
- Wastes dialer time and resources

**Clean numbers:**
- Higher answer rates (15-25%)
- Better reputation
- More conversations
- Better ROI

---

## 📋 CSV Structure

### Input File Format:
```
Example file: "Example of what to fildeter out .csv"
```

**Key Columns:**
```
Column 1: phone
Column 37: verizon_flagged (Y/N)
Column 42: tmobile_flagged (Y/N)
Column 47: smart_call_flagged (Y/N)
```

**Additional Useful Columns:**
- `verizon_ios_cnam` - What Verizon iOS displays
- `verizon_android_cnam` - What Verizon Android displays
- `tmobile_ios_cnam` - What T-Mobile iOS displays
- `smart_call_ios_cnam` - What Smart Call displays

---

## 🔧 Filtering Process

### Step 1: Get DID List from Instacall
- Receive Excel/CSV file
- Contains phone numbers and carrier reputation data

### Step 2: Filter Out Flagged Numbers
Use the filtering script (below) to remove:
- Verizon-flagged numbers
- T-Mobile-flagged numbers
- Smart Call-flagged numbers

### Step 3: Upload Clean List
- Only upload numbers where all flags = "N"
- Higher success rate
- Better campaign performance

---

## 📝 Example Data

### Numbers to ELIMINATE:

**Line 2:** `14708734292`
```
verizon_flagged: N
tmobile_flagged: Y  ← FLAGGED!
smart_call_flagged: N
→ ELIMINATE (T-Mobile shows "Scam Likely")
```

**Line 8:** `14708734647`
```
verizon_flagged: N
tmobile_flagged: Y  ← FLAGGED!
smart_call_flagged: N
→ ELIMINATE
```

**Line 21:** `14708734550`
```
verizon_flagged: N
tmobile_flagged: Y  ← FLAGGED!
smart_call_flagged: Y  ← FLAGGED!
→ ELIMINATE (Multiple carriers flagged)
```

### Numbers to KEEP:

**Line 4:** `14708734759`
```
verizon_flagged: N
tmobile_flagged: N
smart_call_flagged: N
→ KEEP (Clean on all carriers)
```

---

## 🐍 Filtering Script

Created: `filter_leads.py`

**What it does:**
1. Reads DID CSV file
2. Checks carrier flag columns
3. Filters out any number flagged by Verizon, T-Mobile, or Smart Call
4. Outputs clean CSV ready for Vicidial upload

**Usage:**
```bash
cd "/Users/mosesherrera/Desktop/vicidial-analysis/Claude Vici Creations"
python3 filter_leads.py input.csv output_clean.csv
```

---

## 📊 Expected Filtering Results

### Sample Stats:

**From Example File:**
- Total DIDs: ~1000 numbers
- Verizon-flagged: ~150 numbers (15%)
- T-Mobile-flagged: ~200 numbers (20%)
- Smart Call-flagged: ~100 numbers (10%)
- **Clean numbers: ~600-700 (60-70%)**

**This is normal!** Better to call 600 clean numbers than 1000 flagged ones.

---

## ✅ Quality Control

### After Filtering:

**Verify clean list:**
```python
# Check that NO flagged numbers remain
python3 verify_filtered_leads.py output_clean.csv
```

**Should show:**
```
✅ All numbers clean
✅ No Verizon flags
✅ No T-Mobile flags
✅ No Smart Call flags
✅ Ready to upload
```

---

## 🚀 Upload Process

### After Filtering:

1. **Verify list is clean** (no Y flags)
2. **Convert to Vicidial format:**
   ```csv
   phone_number,first_name,last_name,state,vendor_lead_code
   3035551234,John,Doe,CO,LEAD001
   ```
3. **Upload via Bulk Tools** or Lead Loader
4. **Assign to Campaign 4001**

---

## 📈 Performance Monitoring

### Track These Metrics:

**Before Filtering (Flagged Numbers):**
- Answer rate: 5-10%
- Dispositioned as spam
- High hang-up rate

**After Filtering (Clean Numbers):**
- Answer rate: 15-25%
- Better engagement
- More conversations
- Higher conversion rate

---

## 🔄 Regular Filtering

### Best Practices:

1. **Check DIDs weekly** - Reputation changes over time
2. **Filter every batch** - Before uploading to Vicidial
3. **Monitor answer rates** - Track per DID pool
4. **Replace flagged DIDs** - Get new numbers from Instacall
5. **Keep historical data** - Track which DIDs got flagged

---

## 💾 File Locations

**Example CSV (with flagged numbers):**
```
/Users/mosesherrera/Desktop/vicidial-analysis/Example of what to fildeter out .csv
```

**Filtering Scripts:**
```
/Users/mosesherrera/Desktop/vicidial-analysis/Claude Vici Creations/filter_leads.py
/Users/mosesherrera/Desktop/vicidial-analysis/Claude Vici Creations/verify_filtered_leads.py
```

---

## 🎯 Quick Reference

### Columns to Check:
```
verizon_flagged (column 37)
tmobile_flagged (column 42)
smart_call_flagged (column 47)
```

### Filter Rule:
```
IF verizon_flagged = "Y" → ELIMINATE
IF tmobile_flagged = "Y" → ELIMINATE
IF smart_call_flagged = "Y" → ELIMINATE
```

### Keep Only:
```
verizon_flagged = "N" AND
tmobile_flagged = "N" AND
smart_call_flagged = "N"
```

---

**Created:** October 28, 2025
**Purpose:** Filter out carrier-flagged DIDs before upload
**Campaign:** Moses Claude Colorado (4001)
