# ✅ ALMOST DONE! Just Upload 1 File

## 🎉 What I Just Did:
✅ Configured Campaign 4001 in database
✅ Set to trigger on opt-ins only (SVYCLM)
✅ Sent 2 test webhooks to GHL (they should have received them!)

## 📋 What You Need To Do (1 file upload):

---

## 🎯 Upload This File:

**FROM (on your Mac):**
```
/Users/mosesherrera/Desktop/vicidial-analysis/Claude Vici Creations/ghl_webhook_handler.php
```

**TO (on your server):**
```
/var/www/html/api/ghl_webhook_handler.php
```

---

## 🌐 How To Upload (Pick Easiest):

### Option 1: Server Control Panel (Easiest)
1. Go to: **https://dialpower.team:2087/** (or your cPanel/Plesk)
2. Find: **File Manager**
3. Navigate to: `/var/www/html/`
4. Create folder: `api` (if it doesn't exist)
5. Click **Upload**
6. Select: `ghl_webhook_handler.php` from your Desktop folder
7. Done!

---

### Option 2: FTP (If you use FileZilla, etc.)
1. Connect to: `67.198.205.116`
2. Login with your FTP credentials
3. Navigate to: `/var/www/html/api/`
4. Upload: `ghl_webhook_handler.php`
5. Done!

---

### Option 3: Your Server Provider Dashboard
Many providers (DigitalOcean, Linode, Vultr, etc.) have web file managers built-in:
1. Login to your provider dashboard
2. Find file manager or SSH console
3. Upload file to `/var/www/html/api/`
4. Done!

---

## ✅ Once File is Uploaded:

Test it by visiting this URL in your browser:
```
http://67.198.205.116/api/ghl_webhook_handler.php?phone_number=7205559999&first_name=Final&last_name=Test&email=final@test.com&dispo=SVYCLM&campaign_id=4001
```

**You should see:**
```
OK - Opt-in sent to GHL successfully
```

---

## 🎯 Then You're 100% DONE!

Every time someone opts-in (SVYCLM) on Colorado campaign, they'll automatically go to GHL!

---

## 📞 Don't Forget:

Ask your GHL partner if they received **2 test opt-ins**:
1. Test User - 303-555-1234
2. (The second one I sent)

If YES → Everything is working perfectly! 🎉

---

**Questions? Which upload method works best for you?**
