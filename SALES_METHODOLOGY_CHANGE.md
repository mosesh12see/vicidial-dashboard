# 🔄 SALES METHODOLOGY CHANGE - Oct 27, 2025

## 📋 CHANGE SUMMARY

**OLD METHOD:** Sales counted from BOTH vicidial_log AND vicidial_closer_log
**NEW METHOD:** Sales counted ONLY from vicidial_closer_log (transferred calls only)

This change was requested to standardize sales reporting to only include transferred calls that close (closer_log), not direct opt-in conversions from the dialer (vicidial_log).

## 📊 IMPACT ON NUMBERS

### TODAY (Oct 27, 2025)
| State | OLD Sales | NEW Sales | Change |
|-------|-----------|-----------|--------|
| MO | 36 | **19** | -17 |
| GA | 9 | **9** | No change |
| IL | 0 | **0** | No change |
| OH | 1 | **1** | No change |

### LAST 6 MONTHS (April 30 - Oct 27, 2025)
| State | OLD Sales | NEW Sales | Change |
|-------|-----------|-----------|--------|
| MO | 2,692 | **1,545** | -1,147 |
| IL | 1,906 | **1,891** | -15 |
| GA | 151 | **148** | -3 |
| OH | 176 | **181** | +5 |
| KY | 2 | **0** | -2 |
| MI | 17 | **0** | -17 |
| KS | 78 | **0** | -78 |

**Note:** KY, MI, and KS dropped to 0 because they only had direct sales in vicidial_log, no transferred sales in closer_log.

## 🔧 UPDATED FILES

### 1. **update_fast.py** - Daily update script
**Changes:**
- Line 29: Removed LiveXfer from XFER_CAMPAIGN_STATES
- Line 286, 292: Removed `if status == 'SALE'` from today's vicidial_log processing
- Line 310, 316: Removed `if status == 'SALE'` from yesterday's vicidial_log processing
- Lines 321-330: Added connection reopening for closer_log queries
- Lines 361-401: Added LiveXfer queries by area code
- Lines 416-417: Added cursor/connection close

### 2. **recalculate_all_with_closer_log.py** - 6-month recalculation
**Changes:**
- Lines 37-46: Removed LiveXfer from XFER_CAMPAIGN_STATES, added AREA_CODE_STATES mapping
- Lines 78-91: Added separate LiveXfer query by area code
- Lines 111-119: Added LiveXfer sales processing by area code
- Line 168: Removed `if status == 'SALE'` from CSV processing

### 3. **get_oct27_fixed_livexfer.py** - Today's stats script
**Changes:**
- Line 111: Removed `if status == 'SALE'` from vicidial_log processing
- Only counts sales from closer_log queries

### 4. **deep-analysis.html** - HTML report
**Changes:**
- Line 162: MO today sales: 40 → 36 → **19**
- Line 170: GA today sales: 6 → 9 → **9**
- Line 252: GA 6-month sales: 151 → **148**
- Line 262: IL 6-month sales: 1906 → **1891**
- Line 272: MO 6-month sales: 2692 → **1545**
- Line 312: OH 6-month sales: 176 → **181**

## 🎯 HOW IT WORKS NOW

### Sales Counting Method:

1. **Query vicidial_closer_log** for all campaigns EXCEPT LiveXfer:
```sql
SELECT campaign_id, COUNT(*) as cnt
FROM vicidial_closer_log
WHERE call_date >= [date range]
AND status = 'SALE'
GROUP BY campaign_id
```

2. **Map to states** using XFER_CAMPAIGN_STATES:
```python
XFER_CAMPAIGN_STATES = {
    'GeorgiaXfer': 'GA',
    'StLouisXfer': 'MO',
    'StLouisXfer_FO': 'MO',
    'IllinoisXfer': 'IL',
    'IllinoisXferFailover': 'IL',
    'ColumbusCallback': 'OH',
}
```

3. **Handle LiveXfer separately** by phone number area code:
```sql
SELECT
    SUBSTRING(phone_number, 1, 3) as area_code,
    COUNT(*) as cnt
FROM vicidial_closer_log
WHERE call_date >= [date range]
AND campaign_id = 'LiveXfer'
AND status = 'SALE'
GROUP BY area_code
```

4. **Map LiveXfer by area code** to states:
```python
AREA_CODE_STATES = {
    '314': 'MO', '636': 'MO', # Missouri
    '618': 'IL', '217': 'IL', # Illinois
    '404': 'GA', '678': 'GA', '470': 'GA', # Georgia
    '614': 'OH', '740': 'OH', # Ohio
}
```

## ✅ VERIFICATION

All updated scripts now:
- ✅ Count sales ONLY from vicidial_closer_log
- ✅ Do NOT count sales from vicidial_log
- ✅ Handle LiveXfer by phone number area code
- ✅ Apply to today, yesterday, and 6-month calculations

## 📅 GOING FORWARD

All future updates will use this methodology:
- **update_fast.py** runs nightly to update HTML with today/yesterday stats
- All sales will be from closer_log only
- LiveXfer will always be distributed by area code
- Numbers will be consistent with this new methodology

---

**Last Updated:** October 27, 2025
**Change Requested By:** User
**Reason:** Standardize to only count transferred/closed sales from closer_log
