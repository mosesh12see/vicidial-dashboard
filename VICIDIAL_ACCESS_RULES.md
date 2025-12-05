# VICIDIAL ACCESS RULES

## CRITICAL - READ BEFORE ANY VICIDIAL ACCESS

### PRIMARY RULES

1. **NEVER CHANGE ANYTHING IN VICIDIAL**
   - This is a READ-ONLY system access
   - No modifications, updates, or deletions allowed
   - No configuration changes
   - No campaign modifications

2. **READ-ONLY ACCESS**
   - Only query and retrieve data
   - Extract statistics and information
   - Generate reports from existing data

3. **PURPOSE**
   - Get information and statistics from Vicidial
   - Create HTML breakdowns and reports
   - Analyze call data, opt-ins, and sales metrics

### QUERY SAFETY PROTOCOLS

**WARNING: Queries can slow down or shut off Vicidial dialing**

When querying the database:

1. **Use SELECT queries only** - Never INSERT, UPDATE, DELETE, or ALTER
2. **Limit result sets** - Always use LIMIT clauses
3. **Avoid heavy queries during peak hours** - Check system load first
4. **Use indexed columns** - Query on indexed fields when possible
5. **Monitor query execution time** - Cancel if taking too long
6. **Space out queries** - Don't run multiple heavy queries simultaneously
7. **Check system status** - Ensure dialing is not impacted

### QUERY BEST PRACTICES

```sql
-- Good: Limited, specific query
SELECT campaign_id, COUNT(*) as calls
FROM vicidial_log
WHERE call_date >= CURDATE() - INTERVAL 7 DAY
LIMIT 1000;

-- Bad: Full table scan without limit
SELECT * FROM vicidial_log;
```

### WATCHFUL INDICATORS

Monitor these signs that queries are impacting the system:
- Dialing rate drops
- Agents report system slowness
- Database response time increases
- System load spikes

**If any of these occur: STOP QUERIES IMMEDIATELY**

### REPORTING STRUCTURE

Generate HTML reports with:
- Last 3 months stats (per state: calls, opt-ins, sales)
- Last 30 days stats
- Last 7 days stats
- Today's stats
- All consolidated in one HTML file

### DATA SOURCES

- PDFs in `vicidial-analysis` folder
- Direct database queries (when safe)
- Exported CSV/reports

---

**REMEMBER: When in doubt, don't query. Better to wait than to disrupt operations.**

Last Updated: 2025-10-22
