# How to Whitelist IP 108.236.85.241 in VICIdial MySQL Database

## Your Current Blocked IP
**IP Address:** 108.236.85.241
**Database Host:** 67.198.205.116
**Database User:** cron
**Database Name:** asterisk

---

## Method 1: SSH to VICIdial Server (FASTEST)

### Step 1: SSH into VICIdial Server
```bash
ssh root@67.198.205.116
# OR if you have a different user:
ssh admin@67.198.205.116
```

### Step 2: Login to MySQL as Root
```bash
mysql -u root -p
# Enter MySQL root password when prompted
```

### Step 3: Grant Access to Your IP
```sql
-- Grant all privileges to 'cron' user from your Mac's IP
GRANT ALL PRIVILEGES ON asterisk.* TO 'cron'@'108.236.85.241' IDENTIFIED BY '6sfhf9ogku0q';

-- Also grant access to all databases (if needed)
GRANT ALL PRIVILEGES ON *.* TO 'cron'@'108.236.85.241' IDENTIFIED BY '6sfhf9ogku0q';

-- Flush privileges to apply changes
FLUSH PRIVILEGES;

-- Verify the grant was created
SELECT user, host FROM mysql.user WHERE user='cron';
```

### Step 4: Exit MySQL and Test
```sql
exit;
```

Then test from your Mac:
```bash
mysql -h 67.198.205.116 -u cron -p6sfhf9ogku0q asterisk -e "SELECT COUNT(*) FROM vicidial_closer_log WHERE status='SALE';"
```

---

## Method 2: Via cPanel/phpMyAdmin (If Available)

### Step 1: Login to VICIdial Server cPanel
- Go to: https://67.198.205.116:2083 (or your cPanel URL)
- Login with server credentials

### Step 2: Open Remote MySQL
- Click "Remote MySQL" icon in cPanel
- Add "108.236.85.241" to the access list
- Click "Add Host"

### Step 3: Verify Access
Test connection from your Mac terminal

---

## Method 3: Via VICIdial Admin Interface

### Step 1: Login to VICIdial Admin
- Go to: https://dialpower.team/vicidial/admin.php
- Username: capadmin
- Password: cEi11

### Step 2: Database Configuration
- Look for "System Settings" or "Database Settings"
- Find "Remote Database Access" or "Allowed IPs"
- Add: 108.236.85.241

---

## Method 4: Edit MySQL Config File (If You Have Root Access)

### Step 1: SSH to Server
```bash
ssh root@67.198.205.116
```

### Step 2: Edit MySQL Config
```bash
# Edit my.cnf
nano /etc/my.cnf
# OR
nano /etc/mysql/my.cnf
```

### Step 3: Update bind-address
Find this line:
```
bind-address = 127.0.0.1
```

Change to:
```
bind-address = 0.0.0.0
```
(This allows connections from any IP - then MySQL user grants control access)

### Step 4: Restart MySQL
```bash
systemctl restart mysql
# OR
systemctl restart mariadb
```

### Step 5: Add User Grant (Same as Method 1 Step 3)
```bash
mysql -u root -p
```
```sql
GRANT ALL PRIVILEGES ON asterisk.* TO 'cron'@'108.236.85.241' IDENTIFIED BY '6sfhf9ogku0q';
FLUSH PRIVILEGES;
exit;
```

---

## Method 5: Check Firewall Rules

Sometimes the IP is whitelisted in MySQL but blocked by firewall:

### Step 1: SSH to Server
```bash
ssh root@67.198.205.116
```

### Step 2: Check iptables
```bash
iptables -L -n | grep 3306
```

### Step 3: Add Firewall Rule
```bash
# Allow MySQL port 3306 from your IP
iptables -I INPUT -p tcp -s 108.236.85.241 --dport 3306 -j ACCEPT

# Save rules (CentOS/RHEL)
service iptables save

# OR (Ubuntu/Debian)
iptables-save > /etc/iptables/rules.v4
```

---

## Quick Test After Whitelisting

Run this from your Mac terminal:
```bash
cd /Users/mosesherrera/Desktop/vicidial-dashboard
python3 auto_update_web_FIXED.py
```

If successful, you'll see:
```
✅ GA: X sales
✅ MO: X sales
✅ IL: X sales
```

Instead of:
```
⚠️ Database error: (1045, "Access denied...")
```

---

## Most Likely Solution

**You probably need Method 1 (SSH + MySQL GRANT)** because:
1. Database credentials are correct (cron/6sfhf9ogku0q)
2. Database host is reachable (67.198.205.116)
3. Error is "Access denied" not "Connection refused"
4. This means MySQL is blocking the IP specifically

Contact your VICIdial server administrator or hosting provider if you don't have root SSH access.

---

## After Whitelisting is Done

Once your IP is whitelisted, run:
```bash
cd /Users/mosesherrera/Desktop/vicidial-dashboard
python3 auto_update_web_FIXED.py
```

This will get REAL sales from `vicidial_closer_log` and update the HTML with accurate numbers!
