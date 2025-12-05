# VICIDIAL PERFORMANCE DATA - ACCURATE NUMBERS

**Generated:** October 24, 2025 at 5:05 PM CDT
**Data Source:** Vicidial Database (67.198.205.116)
**Script:** update_fast.py

---

## 📊 TODAY'S PERFORMANCE (October 24, 2025)

### Overall Totals
- **Total Calls:** 265,390
- **Total Opt-ins:** 302
- **Overall Opt-in Rate:** 0.11%
- **Average Calls per Opt-in:** 879

### Campaign Breakdown

#### 📊 MO (Missouri Campaign)
- **Total Calls:** 158,738 (59.8% of total)
- **Opt-ins:** 196 (64.9% of total opt-ins)
- **Sales:** 6
- **Opt-in Rate:** 0.12%
- **Calls per Opt-in:** 810
- **Status:** ACTIVE - Best performing campaign today

#### 📊 GA (Georgia Campaign)
- **Total Calls:** 106,624 (40.2% of total)
- **Opt-ins:** 106 (35.1% of total opt-ins)
- **Sales:** 0
- **Opt-in Rate:** 0.10%
- **Calls per Opt-in:** 1,006
- **Status:** ACTIVE - Lower efficiency than MO

---

## 📊 YESTERDAY'S PERFORMANCE (October 23, 2025)

### Overall Totals
- **Total Calls:** 424,751
- **Total Opt-ins:** 384
- **Overall Opt-in Rate:** 0.09%
- **Average Calls per Opt-in:** 1,106

### Campaign Breakdown

#### 📊 MO (Missouri Campaign)
- **Total Calls:** 255,477 (60.1% of total)
- **Opt-ins:** 187 (48.7% of total opt-ins)
- **Sales:** 6
- **Opt-in Rate:** 0.07%
- **Calls per Opt-in:** 1,366
- **Status:** Lower efficiency yesterday vs today

#### 📊 GA (Georgia Campaign)
- **Total Calls:** 10,294 (2.4% of total)
- **Opt-ins:** 21 (5.5% of total opt-ins)
- **Sales:** 0
- **Opt-in Rate:** 0.20%
- **Calls per Opt-in:** 490
- **Status:** BEST opt-in rate but minimal volume

#### 📊 IL (Illinois Campaign)
- **Total Calls:** 158,980 (37.4% of total)
- **Opt-ins:** 176 (45.8% of total opt-ins)
- **Sales:** 5
- **Opt-in Rate:** 0.11%
- **Calls per Opt-in:** 903
- **Status:** INACTIVE TODAY - was running yesterday

---

## 🔍 HOW THESE NUMBERS WERE OBTAINED

### Data Source
```
Database: asterisk
Host: 67.198.205.116
Table: vicidial_log
```

### Query Logic
1. **Date Filtering:**
   - Today: `call_date >= CURDATE()`
   - Yesterday: `call_date >= DATE_SUB(CURDATE(), INTERVAL 1 DAY) AND call_date < CURDATE()`

2. **Campaign Identification:**
   - Data grouped by `campaign_id`
   - Campaign IDs mapped to dominant state names using historical analysis
   - Mapping stored in `historical_data.csv`

3. **State Determination:**
   - Extracted from `phone_number` field (first 3 digits = area code)
   - Area codes mapped to states via lookup dictionary
   - Only valid US area codes counted

4. **Opt-in Calculation:**
   - Statuses counted as opt-ins: `['SALE', 'XFER', 'CALLBK', 'WARM', 'YES', 'SVYCLM']`
   - Each status counted once per call
   - Sales = status 'SALE' only

5. **Aggregation:**
   ```sql
   SELECT campaign_id,
          SUBSTRING(phone_number, 1, 3) as area_code,
          status,
          COUNT(*) as call_count
   FROM vicidial_log
   WHERE call_date >= [DATE_FILTER]
   GROUP BY campaign_id, area_code, status
   ```

### Campaign to State Mapping
```python
campaign_states = {
    1022: 'MO',  # Missouri
    1020: 'GA',  # Georgia
    1021: 'IL',  # Illinois
    # ... 8 more campaigns
}
```

This mapping was built by analyzing historical call patterns and identifying which state each campaign predominantly calls.

---

## 📈 KEY INTERPRETATIONS

### Volume Analysis
1. **Today vs Yesterday:**
   - Today shows 37.5% LOWER volume (265K vs 424K)
   - Day is not complete yet (data as of 5:05 PM)
   - Expect final today numbers around 350-400K calls

2. **Campaign Distribution:**
   - MO campaign consistently largest (~60% of volume)
   - IL campaign turned OFF today (was 37% of volume yesterday)
   - GA campaign running but at reduced scale

### Quality Metrics

1. **Opt-in Rate Trends:**
   - TODAY: MO performing BETTER (0.12% vs 0.07% yesterday)
   - YESTERDAY: GA had exceptional rate (0.20%) but tiny volume
   - Overall rates remain in 0.07-0.20% range

2. **Efficiency Rankings (Lower = Better):**
   **Today:**
   - 🥇 MO: 810 calls/opt-in
   - 🥈 GA: 1,006 calls/opt-in

   **Yesterday:**
   - 🥇 GA: 490 calls/opt-in (BEST)
   - 🥈 IL: 903 calls/opt-in
   - 🥉 MO: 1,366 calls/opt-in (WORST)

3. **Campaign Performance Changes:**
   - **MO:** Improved 40.7% efficiency today (1,366→810 calls/opt-in)
   - **GA:** Declined 51% efficiency today (490→1,006 calls/opt-in)

### Sales Performance
- **Total Sales Today:** 6 (all from MO)
- **Total Sales Yesterday:** 11 (6 from MO, 5 from IL)
- **Sales Rate:** ~0.002% of total calls
- **Opt-in to Sale Conversion:** ~2.4%

### Operational Insights

1. **IL Campaign Pause:**
   - Generated 176 opt-ins and 5 sales yesterday
   - Turned off today - potential lost opportunity?
   - Was 37% of total volume

2. **MO Campaign Optimization:**
   - Significant efficiency improvement today
   - Maintained high volume
   - Consistent sales producer

3. **GA Campaign Variability:**
   - Extreme volume change (10K → 106K calls)
   - Opt-in rate dropped with scale increase
   - Quality vs. quantity trade-off visible

---

## 🎯 RECOMMENDATIONS

1. **Investigate IL Campaign:**
   - Why was it paused today?
   - Was performing decently (903 calls/opt-in)
   - Contributing ~45% of opt-ins yesterday

2. **Analyze MO Improvement:**
   - What changed to improve efficiency 40%?
   - Can this be replicated across other campaigns?

3. **GA Campaign Strategy:**
   - Small volume = high quality (0.20% opt-in rate)
   - Large volume = lower quality (0.10% opt-in rate)
   - Consider optimal volume sweet spot

4. **Sales Conversion:**
   - 2.4% opt-in→sale rate is low
   - Review sales process and training
   - Track which opt-in types convert best

---

## 📁 DATA SOURCES

### Primary Files
- `update_fast.py` - Main query and aggregation script
- `historical_data.csv` - Cached campaign/state mappings
- `deep-analysis.html` - Generated report output

### Database Schema
```
vicidial_log table:
- uniqueid (PK)
- lead_id
- campaign_id
- phone_number
- status
- call_date
- length_in_sec
- user
```

---

## ⚙️ TECHNICAL NOTES

### Why "Fast" Update Works
- Uses historical campaign mappings (doesn't rebuild from scratch)
- Queries only 2 days of data (today + yesterday)
- Pre-aggregated by database (GROUP BY)
- Caches results in CSV for future reference

### Data Accuracy
- ✅ Direct database queries (real-time data)
- ✅ Validated area code mappings
- ✅ Consistent opt-in status list
- ✅ Campaign IDs verified against historical patterns

### Update Frequency
- Can run multiple times per day
- Safe to run during active calling
- Appends to historical_data.csv (doesn't overwrite)
- HTML regenerated each run

---

**Last Updated:** October 24, 2025 at 5:05 PM CDT
**Next Recommended Update:** End of day (after calling stops)
