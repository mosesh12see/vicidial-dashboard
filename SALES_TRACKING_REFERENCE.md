# SALES TRACKING REFERENCE - DO NOT MAKE THESE MISTAKES AGAIN!

## CRITICAL: How to Count Sales Correctly

### ✅ CORRECT Method

1. **ALWAYS query `vicidial_closer_log` table for sales**
   - Use `status = 'SALE'` condition
   - Filter by the transfer campaign names

2. **ONLY count these transfer campaigns:**
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

3. **EXCLUDE LiveXfer from ALL sales counting**
   - LiveXfer is a mixed campaign, not state-specific
   - Do not include it in any sales queries or totals

### ❌ WRONG Methods (Never Do These!)

1. **❌ DO NOT count sales from `vicidial_log` table**
   - The `vicidial_log` table contains outbound call statuses
   - SALE status in vicidial_log is NOT the same as actual sales
   - Only `vicidial_closer_log` has transfer sales

2. **❌ DO NOT use area codes to determine sales**
   - Sales come from transfer campaigns with specific names
   - Area codes are for determining which state a campaign calls
   - Sales mapping uses transfer campaign names, NOT area codes

3. **❌ DO NOT forget to add sales to campaign-level breakdowns**
   - When showing sales by campaign/state in tables, ensure sales are added to:
     - State totals (`today_by_state`, `yesterday_by_state`)
     - Campaign breakdowns (`today_by_campaign`, `yesterday_by_campaign`)
   - Both levels need sales data for accurate reporting

## Correct SQL Query Pattern

### For Today's Sales:
```sql
SELECT campaign_id, COUNT(*) as cnt
FROM vicidial_closer_log
WHERE call_date >= CURDATE() AND call_date < CURDATE() + INTERVAL 1 DAY
AND status = 'SALE'
GROUP BY campaign_id
```

### For Monthly Sales:
```sql
SELECT COUNT(*) as cnt
FROM vicidial_closer_log
WHERE DATE_FORMAT(call_date, '%Y-%m') = '{month}'
AND status = 'SALE'
AND campaign_id IN ('GeorgiaXfer', 'StLouisXfer', 'StLouisXfer_FO', 'IllinoisXfer', 'IllinoisXferFailover', 'ColumbusCallback')
```

## Adding Sales to Data Structures

When processing sales from `vicidial_closer_log`:

```python
for row in closer_sales:
    campaign_id = row['campaign_id']
    cnt = row['cnt']

    if campaign_id in XFER_CAMPAIGN_STATES:
        state = XFER_CAMPAIGN_STATES[campaign_id]

        # Add to state totals
        by_state[state]['sales'] += cnt

        # ALSO add to campaign breakdown (find original outbound campaign for this state)
        for orig_campaign_id, campaign_state in campaign_states.items():
            if campaign_state == state:
                by_campaign[orig_campaign_id][state]['sales'] += cnt
```

## Common Mistakes Fixed in This Session

1. **Sales showing as 0:** Fixed by properly querying `vicidial_closer_log` instead of `vicidial_log`
2. **Phantom TX/CA states:** Fixed by using campaign IDs instead of area codes for state mapping
3. **Missing sales in tables:** Fixed by adding sales to both state totals AND campaign breakdowns
4. **Including LiveXfer:** Fixed by explicitly excluding it from all sales queries

## Files That Use This Methodology

- `update_fast.py` - Daily HTML updates (CORRECT as of 2025-10-30)
- `fix_efficiency_campaigns_and_sales.py` - Efficiency score graphs (CORRECT)
- `add_6month_graph.py` - 6-month performance graphs (needs verification)

## When Making New Scripts

Always refer to this document and ensure:
1. Sales come from `vicidial_closer_log` ONLY
2. Only the 6 transfer campaigns listed above are counted
3. LiveXfer is EXCLUDED
4. Sales are added to ALL relevant data structures (state totals AND campaign breakdowns)
5. Campaign mapping uses numeric IDs, NOT area codes

---

**Last Updated:** 2025-10-30
**Verified Methodology:** See `FINAL_SALES_METHODOLOGY.md` for original documentation
