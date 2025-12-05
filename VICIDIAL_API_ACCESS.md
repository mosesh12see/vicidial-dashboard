# VICIDIAL API ACCESS GUIDE

## 🔐 API ACCESS METHOD (PREFERRED)

**Access Vicidial through API/Database - NO PDF EXPORTS NEEDED!**

This allows:
- Real-time data pulling on demand
- Automated report generation
- No manual exports required
- Historical data queries on command

---

## CRITICAL RULES

### ⛔ NEVER CHANGE ANYTHING
1. **READ-ONLY ACCESS ONLY**
2. Use SELECT queries ONLY - Never INSERT, UPDATE, DELETE, ALTER
3. No configuration changes
4. No campaign modifications

### ⚠️ QUERY SAFETY
**WARNING: Queries can slow down or shut off Vicidial dialing!**

**Safe Query Practices:**
- Always use LIMIT clauses
- Query during low-traffic times if possible
- Use indexed columns (call_date, campaign_id, etc.)
- Monitor execution time - cancel if > 5 seconds
- Space out queries - wait 2-3 seconds between queries
- Check system load before running heavy queries

**If dialing slows down: STOP ALL QUERIES IMMEDIATELY**

---

## 📋 WHAT I NEED FROM YOU

To access Vicidial and pull stats automatically, provide these credentials:

### 1. Vicidial URL/Hostname
```
Example: https://dialpower.team
Your URL: https://dialpower.team
```

### 2. API User Credentials
Vicidial has an API for reports. I need:
```
API User: ___________________________________
API Pass: ___________________________________
```

**How to create API user:**
1. Go to: Admin → Users
2. Create new user with report access only
3. Set User Level: 7 or 8 (reports only)
4. Give permissions: View Reports, Export Data

### 3. Database Access (Alternative/Backup)
If API is limited, I can query database directly:
```
DB Host: ___________________________________
DB Name: vicidial (usually)
DB User: ___________________________________
DB Pass: ___________________________________
DB Port: 3306 (usually)
```

**How to create DB read-only user:**
```sql
CREATE USER 'vici_readonly'@'%' IDENTIFIED BY 'your_password';
GRANT SELECT ON vicidial.* TO 'vici_readonly'@'%';
FLUSH PRIVILEGES;
```

### 4. Server Access (Optional - for exports)
```
SSH Host: ___________________________________
SSH User: ___________________________________
SSH Key/Pass: ___________________________________
```

---

## 📊 WHAT DATA I'LL PULL

Once you provide credentials, I can automatically pull:

### Real-Time Stats
- Current active calls
- Agents online/available
- Calls in queue
- System load

### Historical Reports
- **Last 90 days** - Calls, opt-ins, sales by state
- **Last 30 days** - Same breakdown
- **Last 7 days** - Same breakdown
- **Today** - Current day stats

### Per-State Breakdown
- Total calls per state
- Opt-ins per state (by status code)
- Sales per state (by status code)
- Conversion rates

### Campaign Stats
- Calls per campaign
- Agent performance
- List penetration
- Status breakdowns

---

## 🔧 API ENDPOINTS I'LL USE

Vicidial API endpoints (examples):
```
GET /vicidial/non_agent_api.php?source=test&function=realtime_report
GET /vicidial/non_agent_api.php?source=test&function=call_log_export
GET /vicidial/non_agent_api.php?source=test&function=lead_status_summary
```

## 🗄️ DATABASE TABLES I'LL QUERY

Read-only SELECT queries on:
```sql
-- Call logs
vicidial_log (outbound calls)
vicidial_closer_log (inbound calls)

-- Leads and statuses
vicidial_list (lead data)
vicidial_statuses (status definitions)

-- Campaigns
vicidial_campaigns (campaign settings - READ ONLY)

-- Agents
vicidial_users (agent info)
vicidial_agent_log (agent activity)
```

---

## 🚀 NEXT STEPS

1. **Fill in the credentials** above
2. **Save** this file with your info
3. **Tell me** when ready
4. I'll **test the connection** safely
5. I'll **pull your first report** automatically

Then anytime you ask for stats, I'll pull them live from Vicidial!

---

## 📝 IMPORTANT REMINDERS

- ✅ I will ONLY read data
- ✅ I will use safe, limited queries
- ✅ I will monitor for system impact
- ✅ I will stop immediately if dialing is affected
- ❌ I will NEVER modify configurations
- ❌ I will NEVER change campaign settings
- ❌ I will NEVER insert/update/delete data

**When in doubt, I won't query. Safety first!**

---

Last Updated: 2025-10-22
