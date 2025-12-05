# VICIDIAL ANALYSIS - IMPORTANT STRUCTURE RULES

**Last Updated:** October 24, 2025

---

## 🚨 CRITICAL RULES

### Campaign Display Structure

**ALWAYS organize data by CAMPAIGNS first, then STATES within each campaign**

**IMPORTANT:** Campaign headers MUST show the **DOMINANT STATE NAME**, NOT the campaign ID!

### Correct Structure:

```
📊 CALIFORNIA
   🏆 CA - 1,234 calls, 50 optins
   🥈 TX - 1,100 calls, 48 optins
   🥉 FL - 900 calls, 40 optins
   CALIFORNIA TOTAL - 5,678 calls, 200 optins

📊 TEXAS
   🏆 TX - 2,100 calls, 80 optins
   🥈 OK - 800 calls, 30 optins
   TEXAS TOTAL - 3,456 calls, 120 optins
```

### Wrong Structure (DO NOT USE):

```
❌ CAMPAIGN: 12345
   🏆 CA - 1,234 calls

❌ Showing states without campaign grouping
   🏆 CA - 5,000 calls
   🥈 TX - 4,500 calls
```

---

## 📊 Data Flow

1. **Query database** by campaign_id and area_code
2. **Map campaigns to dominant state** using `campaign_states` dictionary
3. **Group data** by `campaign_id` → `state`
4. **Display** using STATE NAME as header (not campaign ID)

---

## 🔧 Implementation Details

### Key Variables:

- `campaign_states` = {campaign_id: dominant_state_name}
  - Built from historical data
  - Maps each campaign to its most common state

- `today_by_campaign` = {campaign_id: {state: {calls, optins, sales}}}
  - Nested dictionary structure
  - Campaign → States → Metrics

### Display Loop:

```python
for campaign_id in sorted(today_by_campaign.keys()):
    # Get dominant state name
    campaign_state_name = campaign_states.get(campaign_id, 'UNKNOWN')

    # Header shows STATE NAME
    print(f"📊 {campaign_state_name}")

    # Show states under this campaign
    for state, data in today_by_campaign[campaign_id].items():
        print(f"   {state}: {data['calls']} calls")

    # Total shows STATE NAME
    print(f"{campaign_state_name} TOTAL: {total_calls}")
```

---

## 📁 Files

- `update_fast.py` - Fast daily updates (uses cached historical data)
- `update_deep_analysis_nightly.py` - Full nightly analysis
- `deep-analysis.html` - Output HTML report
- `historical_data.csv` - Cached call history

---

## 🎯 Why This Structure?

- **User wants campaigns** to see performance by campaign
- **User wants state names** because campaigns are primarily state-based
- **State is the identifier** users recognize, not campaign IDs
- **Hierarchy matters**: Campaign (by state name) → States within campaign

---

## ⚠️ NEVER FORGET

1. ✅ Group by CAMPAIGN first
2. ✅ Name campaigns by DOMINANT STATE
3. ✅ Show states WITHIN each campaign
4. ✅ Use STATE NAME in headers, NOT campaign ID
5. ✅ Calculate totals PER CAMPAIGN

---

**If you forget this structure, the user will be pissed! Read this file first before making changes.**
