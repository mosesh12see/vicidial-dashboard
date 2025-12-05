# ✅ SUPER EASY SETUP (SSH Blocked - Use This Instead)

Since SSH port 22 is blocked, here's the simplest way:

---

## 🌐 OPTION 1: Use Web-Based Terminal (Easiest)

### Step 1: Access your server
Go to: **https://dialpower.team:2087/** or your server control panel

Look for:
- "Terminal" or "Web Terminal" or "Shell Access" or "Command Line"

### Step 2: Open the file
On your Mac, open this file:
```
/Users/mosesherrera/Desktop/vicidial-analysis/Claude Vici Creations/PASTE_INTO_SERVER.txt
```

### Step 3: Copy EVERYTHING in that file

### Step 4: Paste it into the web terminal

### Step 5: Hit Enter

**Done!** It will say "✅ Setup complete!"

---

## 🌐 OPTION 2: Check if SSH uses a different port

Try these commands (one at a time):

```bash
# Try port 2222
ssh -p 2222 root@67.198.205.116

# Try with dialpower domain
ssh root@dialpower.team

# Try admin user
ssh admin@67.198.205.116
```

If any of those work, then you can run the original commands!

---

## 🌐 OPTION 3: Direct Database + Manual File (If you have web file manager)

### Part A: Create the PHP file via web file manager

1. Go to your server's **File Manager** (cPanel, Plesk, etc.)
2. Navigate to: `/var/www/html/api/`
3. Create new file: `ghl_webhook_handler.php`
4. Copy contents from: `/Users/mosesherrera/Desktop/vicidial-analysis/Claude Vici Creations/ghl_webhook_handler.php`
5. Paste and save

### Part B: Run this ONE SQL command in Vicidial

Go to: **https://dialpower.team/vicidial/admin.php**

Look for: **Admin → System Settings → MySQL Command Line** (or similar)

Paste this:
```sql
UPDATE vicidial_campaigns
SET
  web_form_address = 'http://67.198.205.116/api/ghl_webhook_handler.php?phone_number=--A--phone_number--B--&first_name=--A--first_name--B--&last_name=--A--last_name--B--&email=--A--email--B--&address1=--A--address1--B--&city=--A--city--B--&state=--A--state--B--&postal_code=--A--postal_code--B--&dispo=--A--dispo--B--&campaign_id=--A--campaign--B--',
  web_form_address_two = 'SVYCLM'
WHERE campaign_id = '4001';
```

**Done!**

---

## ✅ Which option is easiest for you?

**OPTION 1** is fastest if you have web terminal access.

Let me know which one you want to try!
