# 🚀 Deploy GHL Webhook for Colorado Campaign

**Campaign:** Moses Claude Colorado (4001)
**External Partner:** Go High Level
**Fields Shared:** Contact info only (NO internal tracking)

---

## 📦 What Gets Sent to GHL

**ONLY these 8 fields:**
- Phone Number
- First Name
- Last Name
- Email
- Address (street)
- City
- State (CO)
- Postal Code

**NOT sent:**
- ❌ Lead ID
- ❌ Agent username
- ❌ Campaign tracking codes
- ❌ Timestamps
- ❌ Internal Vicidial data

---

## 🔧 STEP 1: Upload PHP File to Server

### Copy file to server:
```bash
scp /Users/mosesherrera/Desktop/vicidial-analysis/Claude\ Vici\ Creations/ghl_webhook_handler.php \
    root@67.198.205.116:/var/www/html/api/
```

### OR manually upload via SSH:
```bash
ssh root@67.198.205.116

# Create directory
mkdir -p /var/www/html/api

# Set permissions
chmod 755 /var/www/html/api

# Create log files
touch /tmp/ghl_webhook_success.log
touch /tmp/ghl_webhook_errors.log
chmod 666 /tmp/ghl_webhook_success.log
chmod 666 /tmp/ghl_webhook_errors.log
```

---

## ⚙️ STEP 2: Configure Colorado Campaign

### Copy this URL (all one line):
```
http://67.198.205.116/api/ghl_webhook_handler.php?phone_number=--A--phone_number--B--&first_name=--A--first_name--B--&last_name=--A--last_name--B--&email=--A--email--B--&address1=--A--address1--B--&city=--A--city--B--&state=--A--state--B--&postal_code=--A--postal_code--B--&dispo=--A--dispo--B--&campaign_id=--A--campaign--B--
```

### Add to Vicidial via database:
```bash
ssh root@67.198.205.116

mysql -u cron -p'6sfhf9ogku0q' asterisk << 'EOF'
UPDATE vicidial_campaigns
SET
  web_form_address = 'http://67.198.205.116/api/ghl_webhook_handler.php?phone_number=--A--phone_number--B--&first_name=--A--first_name--B--&last_name=--A--last_name--B--&email=--A--email--B--&address1=--A--address1--B--&city=--A--city--B--&state=--A--state--B--&postal_code=--A--postal_code--B--&dispo=--A--dispo--B--&campaign_id=--A--campaign--B--',
  web_form_address_two = 'SVYCLM'
WHERE campaign_id = '4001';
EOF
```

---

## 🧪 STEP 3: Test the Webhook

### Test with sample data:
```bash
curl "http://67.198.205.116/api/ghl_webhook_handler.php?phone_number=3035551234&first_name=John&last_name=Doe&email=john@example.com&address1=123+Main+St&city=Denver&state=CO&postal_code=80202&dispo=SVYCLM&campaign_id=4001"
```

**Expected response:**
```
OK - Opt-in sent to GHL successfully
```

### Check the log:
```bash
tail -1 /tmp/ghl_webhook_success.log
```

**Sample log entry:**
```json
{"timestamp":"2025-11-01 16:30:00","phone_number":"3035551234","name":"John Doe","http_code":200,"success":true,"error":""}
```

---

## 📊 STEP 4: Verify Configuration

### Check campaign is configured:
```bash
ssh root@67.198.205.116

mysql -u cron -p'6sfhf9ogku0q' asterisk -e "
SELECT
  campaign_id,
  campaign_name,
  web_form_address_two as trigger_status
FROM vicidial_campaigns
WHERE campaign_id = '4001';
"
```

**Should show:**
```
campaign_id: 4001
campaign_name: Moses Claude Colorado
trigger_status: SVYCLM
```

---

## 📈 Monitor Webhooks

### Watch real-time:
```bash
tail -f /tmp/ghl_webhook_success.log
```

### Count today's opt-ins sent:
```bash
grep "$(date +%Y-%m-%d)" /tmp/ghl_webhook_success.log | grep '"success":true' | wc -l
```

### View last 10 sent:
```bash
tail -10 /tmp/ghl_webhook_success.log | jq -r '[.timestamp, .phone_number, .name] | @tsv'
```

---

## ✅ Deployment Checklist

- [ ] PHP file uploaded to `/var/www/html/api/ghl_webhook_handler.php`
- [ ] File permissions: 644
- [ ] Log files created: `/tmp/ghl_webhook_*.log`
- [ ] Log permissions: 666
- [ ] Campaign 4001 configured with webhook URL
- [ ] Trigger status = 'SVYCLM' (opt-ins only)
- [ ] Test webhook returns "OK - Opt-in sent to GHL successfully"
- [ ] Log shows successful webhook
- [ ] GHL partner confirms test data received

---

## 🔒 Privacy & Security

### What's Protected:
✅ No database credentials shared
✅ No Vicidial passwords exposed
✅ No agent usernames sent
✅ No lead IDs or tracking codes
✅ No internal campaign data
✅ Only works for campaign 4001
✅ Only triggers on SVYCLM (opt-ins)

### What Gets Shared:
📤 Contact information only (name, phone, email, address)
📤 Only when someone explicitly opts in
📤 Only from Colorado campaign

---

## 🐛 Quick Troubleshooting

**"404 Not Found"**
```bash
# Check file exists
ls -la /var/www/html/api/ghl_webhook_handler.php
```

**"Permission Denied"**
```bash
# Fix permissions
chmod 666 /tmp/ghl_webhook_success.log
chmod 666 /tmp/ghl_webhook_errors.log
```

**"Not firing on real calls"**
```bash
# Check campaign config
mysql -u cron -p'6sfhf9ogku0q' asterisk -e "SELECT web_form_address FROM vicidial_campaigns WHERE campaign_id='4001';"
```

---

## 📞 Support

If GHL partner isn't receiving data:

1. **Verify webhook URL is correct** in `ghl_webhook_handler.php` line 16
2. **Test GHL webhook directly:**
   ```bash
   curl -X POST https://services.leadconnectorhq.com/hooks/boXe5LQTgfuXIRfrFTja/webhook-trigger/e241703a-47bc-4554-8d04-bb31a33512cc \
     -H "Content-Type: application/json" \
     -d '{"phone_number":"3035551234","first_name":"Test","last_name":"User"}'
   ```
3. **Check logs:** `/tmp/ghl_webhook_success.log`
4. **Ask GHL partner** to check their webhook logs

---

**Status:** ✅ Ready to Deploy
**Campaign:** 4001 (Moses Claude Colorado)
**Trigger:** SVYCLM opt-ins only
**Data Shared:** Contact info only (8 fields)
