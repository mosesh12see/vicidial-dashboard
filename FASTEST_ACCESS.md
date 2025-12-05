# 🚀 FASTEST WAY TO GET VICIDIAL DATA ACCESS

## Option 1: SSH + Grab MySQL Credentials (30 seconds)

If you have SSH access to the Vicidial server:

```bash
# SSH into the server
ssh root@67.198.205.116
# or
ssh admin@dialpower.team

# Once in, look for MySQL credentials:
cat /etc/astguiclient.conf

# This file contains the MySQL root password!
# Look for lines like:
# VARDBserver => localhost
# VARDBname => asterisk
# VARDBuser => cron
# VARDBpass => <PASSWORD HERE>
```

**Then tell me:**
- The database password you found
- I'll update the script and pull all data immediately

---

## Option 2: Web Interface - Enable API (2 minutes)

Using your current `capadmin` login:

1. Go to: https://dialpower.team/vicidial/admin.php
2. Click: **Admin** → **System Settings**
3. Find: `enable_queuemetrics_logging` and set to 1
4. Find: `queuemetrics_loginout` and set to 1
5. Look for **API settings** section
6. Enable: `allow_web_debug`
7. Click **SUBMIT**

Then try the API again with debug mode.

---

## Option 3: Direct Server Script (1 minute if you have SSH)

If you can SSH, I'll give you a script to run ON the server that dumps data to a file:

```bash
# On the Vicidial server, run this:
mysql -u cron -p asterisk -e "
SELECT
    DATE(call_date) as day,
    LEFT(phone_number, 3) as area_code,
    status,
    COUNT(*) as calls
FROM vicidial_log
WHERE call_date >= DATE_SUB(NOW(), INTERVAL 90 DAY)
GROUP BY DATE(call_date), LEFT(phone_number, 3), status
INTO OUTFILE '/tmp/vicidial_stats_90days.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '\"'
LINES TERMINATED BY '\n';
"

# Then download the file:
# Exit SSH and from your Mac:
scp root@67.198.205.116:/tmp/vicidial_stats_90days.csv ~/Desktop/vicidial-analysis/
```

---

## Option 4: Universal Admin API Key

Some Vicidial installations have a master API key. Check if yours does:

1. SSH into server
2. Check: `cat /etc/astguiclient.conf | grep -i api`
3. Look for: `API_key` or `api_secret`

If found, give me that key and I'll use it.

---

## 🎯 WHAT I NEED FROM YOU (Pick One):

### Path A: Give me SSH access
```
SSH Host: 67.198.205.116 (or dialpower.team)
SSH User: root (or admin, or whatever you use)
SSH Password: ___________
```

→ I'll SSH in, grab the MySQL credentials, and set everything up in 30 seconds

### Path B: Run this command and give me the output
```bash
ssh YOUR_USER@67.198.205.116 "cat /etc/astguiclient.conf | grep -i pass"
```

→ Give me the password from the output

### Path C: Access Vicidial web admin
Log into web admin and look for:
- Admin → System Settings → API Key
- Admin → Users → capadmin → API settings
- Any section mentioning "API key" or "auth token"

→ Copy/paste whatever you find

---

## ⚡ THE ABSOLUTE FASTEST:

If you can SSH right now:
```bash
# Run this ONE command and paste me the output:
ssh root@67.198.205.116 "cat /etc/astguiclient.conf"
```

I'll extract everything I need from that config file and have your reports ready in 60 seconds.

---

**Bottom line:** I need either:
1. SSH access to the server, OR
2. The MySQL password from /etc/astguiclient.conf, OR
3. An API key/token if one exists

The config file method is fastest - that file has ALL the credentials.
