# VICIDIAL CAMPAIGN REFERENCE

**Last Updated:** October 25, 2025
**Data Source:** Historical analysis of 27+ million calls (July-October 2025)

---

## 📊 ALL ACTIVE CAMPAIGNS (Last 6 Months)

Complete campaign-to-state mapping based on actual call data analysis.

| Campaign ID | State | State Name | Total Calls | Dominant % | Last Active | Status |
|------------|-------|------------|-------------|------------|-------------|--------|
| **1028** | **IL** | Illinois | 7,913,464 | 91.5% | 2025-10-24 | ✅ ACTIVE |
| **1022** | **MO** | Missouri | 7,910,770 | 91.4% | 2025-10-24 | ✅ ACTIVE |
| **1020** | **KS** | Kansas | 5,042,167 | 46.4% | 2025-10-02 | ⏸️ PAUSED |
| **1018** | **MI** | Michigan | 2,308,746 | 90.8% | 2025-09-22 | ⏸️ PAUSED |
| **1027** | **GA** | Georgia | 2,249,894 | 89.3% | 2025-10-24 | ✅ ACTIVE |
| **1025** | **OH** | Ohio | 1,086,799 | 90.6% | 2025-10-13 | ⏸️ PAUSED |
| **1029** | **IL** | Illinois (2nd) | 285,219 | 93.2% | 2025-10-10 | ⏸️ PAUSED |
| **1030** | **KY** | Kentucky | 199,175 | 91.0% | 2025-10-18 | ⏸️ PAUSED |
| **1001** | **NV** | Nevada | 20,741 | 76.3% | 2025-07-28 | ⏸️ PAUSED |

---

## 🔥 CURRENTLY ACTIVE CAMPAIGNS (October 2025)

These are the campaigns running as of today:

1. **1028 (IL)** - Illinois Campaign
   - Volume: 7.9M calls total
   - Top Area Codes: 618, 217, 309
   - Status: Primary active campaign

2. **1022 (MO)** - Missouri Campaign
   - Volume: 7.9M calls total
   - Top Area Codes: 314 (St. Louis), 636, 573
   - Status: Primary active campaign, highest daily volume

3. **1027 (GA)** - Georgia Campaign
   - Volume: 2.2M calls total
   - Top Area Codes: 404 (Atlanta), 770, 678
   - Status: Active, started Oct 2nd

---

## 📝 IMPORTANT NOTES

### Multiple Campaigns for Same State

You have **TWO Illinois campaigns**:
- **Campaign 1028** - Main IL campaign (7.9M calls, still active)
- **Campaign 1029** - Secondary IL campaign (285K calls, paused Oct 10)

### Campaign 1020 - Kansas Not Georgia!

**Campaign 1020 is KANSAS, not Georgia:**
- Area codes 816 & 913 are Kansas City metro (Kansas side)
- Only 46% of calls go to Kansas (rest to Missouri due to KC spanning both states)
- This was previously mislabeled

### Campaign Status Key
- ✅ **ACTIVE** = Running as of Oct 24, 2025
- ⏸️ **PAUSED** = Not currently running but was active in last 6 months

---

## 💻 PYTHON DICTIONARY FOR CODE

Copy-paste this into your scripts:

```python
# Verified campaign-to-state mapping (Oct 2025)
CAMPAIGN_STATES = {
    1028: 'IL',  # Illinois - 7,913,464 calls
    1022: 'MO',  # Missouri - 7,910,770 calls
    1020: 'KS',  # Kansas - 5,042,167 calls
    1018: 'MI',  # Michigan - 2,308,746 calls
    1027: 'GA',  # Georgia - 2,249,894 calls
    1025: 'OH',  # Ohio - 1,086,799 calls
    1029: 'IL',  # Illinois (2nd) - 285,219 calls
    1030: 'KY',  # Kentucky - 199,175 calls
    1001: 'NV',  # Nevada - 20,741 calls
}
```

---

## 📍 TOP AREA CODES BY CAMPAIGN

### Campaign 1028 (Illinois)
- **618** - 2,998,176 calls (Southern IL)
- **217** - 2,426,827 calls (Springfield area)
- **309** - 1,484,241 calls (Peoria area)

### Campaign 1022 (Missouri)
- **314** - 4,406,236 calls (St. Louis)
- **636** - 2,144,838 calls (St. Louis suburbs)
- **573** - 562,198 calls (Central MO)

### Campaign 1020 (Kansas)
- **816** - 2,076,363 calls (Kansas City)
- **913** - 1,652,240 calls (Kansas City area)
- **785** - 609,841 calls (Topeka/Lawrence)

### Campaign 1018 (Michigan)
- **248** - 652,870 calls (Oakland County)
- **734** - 455,116 calls (Wayne County)
- **586** - 415,945 calls (Macomb County)

### Campaign 1027 (Georgia)
- **404** - 1,009,203 calls (Atlanta)
- **770** - 470,319 calls (Atlanta metro)
- **678** - 421,235 calls (Atlanta overlay)

### Campaign 1025 (Ohio)
- **614** - 585,135 calls (Columbus)
- **740** - 291,464 calls (Southeast OH)
- **419** - 28,674 calls (Northwest OH)

### Campaign 1029 (Illinois - 2nd)
- **847** - 129,480 calls (North suburbs)
- **630** - 60,408 calls (Western suburbs)
- **224** - 20,857 calls (Northern IL)

### Campaign 1030 (Kentucky)
- **502** - 140,203 calls (Louisville)
- **270** - 35,022 calls (Western KY)
- **859** - 4,350 calls (Lexington)

### Campaign 1001 (Nevada)
- **702** - 15,584 calls (Las Vegas)
- **775** - 191 calls (Reno)

---

## 📊 ACTIVITY TIMELINE

**July - September 2025:**
- Campaigns 1028, 1022, 1020, 1018 were running (highest volume period)

**October 2025:**
- Campaign 1020 (KS) stopped Oct 2
- Campaign 1027 (GA) started Oct 2 (replacement for 1020?)
- Campaign 1025 (OH) stopped Oct 13
- Campaign 1018 (MI) stopped Sep 22
- Campaigns 1028 (IL) and 1022 (MO) continue running

**Current Active (Oct 24):**
- 1028 (IL) - Primary
- 1022 (MO) - Primary
- 1027 (GA) - Recent addition

---

## 🔍 HOW TO VERIFY THESE MAPPINGS

Run this command to check any campaign:

```bash
# Replace XXXX with campaign ID
awk -F, '$2 == XXXX {count[$3] += $5} END {for (ac in count) print count[ac], ac}' historical_data.csv | sort -rn | head -10
```

Or use the analysis script:
```bash
python3 analyze_all_campaigns.py
```

---

## 📁 RELATED FILES

- **analyze_all_campaigns.py** - Script to analyze all campaign mappings
- **historical_data.csv** - 235,791 rows of call data
- **generate_enhanced_dashboard.py** - Uses CAMPAIGN_STATES mapping
- **update_fast.py** - Builds mapping dynamically from historical data

---

## ⚠️ CORRECTIONS FROM PREVIOUS MAPPING

**What Changed:**
1. ❌ Campaign 1020 was labeled **GA** → ✅ Actually **KS** (Kansas)
2. ❌ Campaign 1027 was labeled **PA** → ✅ Actually **GA** (Georgia)
3. ❌ Campaign 1028 was labeled **OH** → ✅ Actually **IL** (Illinois)
4. ✅ Campaign 1022 was correctly **MO** (Missouri)

**New Campaigns Discovered:**
- 1018 (MI) - 2.3M calls, paused Sep 22
- 1025 (OH) - 1.1M calls, paused Oct 13
- 1029 (IL) - 285K calls, second IL campaign
- 1030 (KY) - 199K calls, paused Oct 18
- 1001 (NV) - 20K calls, short test campaign

---

## 🎯 QUICK REFERENCE TABLE

| State Code | # of Campaigns | Campaign IDs | Status |
|-----------|---------------|--------------|--------|
| IL | 2 | 1028, 1029 | 1028 Active |
| MO | 1 | 1022 | Active |
| GA | 1 | 1027 | Active |
| KS | 1 | 1020 | Paused |
| MI | 1 | 1018 | Paused |
| OH | 1 | 1025 | Paused |
| KY | 1 | 1030 | Paused |
| NV | 1 | 1001 | Paused |

---

**For questions or updates:** Run `python3 analyze_all_campaigns.py` to regenerate this data.

**Last Analysis:** October 25, 2025
