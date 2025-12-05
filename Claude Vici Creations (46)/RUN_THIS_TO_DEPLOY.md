# 🚀 RUN THIS TO DEPLOY GHL WEBHOOK

**Simple 2-step deployment for Colorado Campaign**

---

## ⚡ QUICK DEPLOY (Copy/Paste These 3 Commands)

### Step 1: Upload script to server
```bash
scp "/Users/mosesherrera/Desktop/vicidial-analysis/Claude Vici Creations/deploy_ghl_webhook.sh" root@67.198.205.116:/root/
```

### Step 2: SSH to server and run it
```bash
ssh root@67.198.205.116
```

### Step 3: Run the deployment script
```bash
bash /root/deploy_ghl_webhook.sh
```

**That's it!** The script will:
- ✅ Upload PHP webhook handler
- ✅ Configure campaign 4001
- ✅ Send test opt-in to GHL
- ✅ Show you the results

---

## 📊 What the script does:

1. Creates `/var/www/html/api/` directory
2. Creates `ghl_webhook_handler.php` webhook handler
3. Sets proper permissions
4. Configures campaign 4001 in database
5. Sends test opt-in: **John Doe, 303-555-1234**
6. Shows you the log

---

## ✅ Success looks like:

```
========================================
✅ DEPLOYMENT COMPLETE!
========================================

📋 What was deployed:
  ✓ Webhook handler: /var/www/html/api/ghl_webhook_handler.php
  ✓ Campaign 4001 configured
  ✓ Test opt-in sent to GHL

Response: OK - Opt-in sent to GHL successfully
```

---

## 🔍 After deployment, verify with GHL partner:

**Ask them:** "Did you receive a test opt-in?"

**They should see:**
- Name: John Doe
- Phone: 303-555-1234
- Email: john.doe@test.com
- Address: 123 Main St
- City: Denver
- State: CO
- ZIP: 80202

---

## 📈 Monitor webhooks in real-time:

```bash
# Watch opt-ins being sent
tail -f /tmp/ghl_webhook_success.log

# Count today's opt-ins
grep "$(date +%Y-%m-%d)" /tmp/ghl_webhook_success.log | wc -l

# Send another test
curl 'http://67.198.205.116/api/ghl_webhook_handler.php?phone_number=7205559999&first_name=Jane&last_name=Smith&email=jane@test.com&dispo=SVYCLM&campaign_id=4001'
```

---

## 🐛 If SSH doesn't work:

You can manually paste the script contents. SSH to your server and run:

```bash
ssh root@67.198.205.116

# Then copy/paste the entire script from deploy_ghl_webhook.sh
# Or run this one-liner:
bash <(cat << 'EOF'
# [entire script would go here]
EOF
)
```

---

## 🔒 Security reminder:

**Only these fields are sent to GHL:**
- Phone Number
- First Name
- Last Name
- Email
- Address
- City
- State
- ZIP

**NOT sent:**
- Lead IDs
- Agent usernames
- Campaign tracking
- Timestamps
- Internal data

---

**Ready? Run the 3 commands above!** ⬆️
