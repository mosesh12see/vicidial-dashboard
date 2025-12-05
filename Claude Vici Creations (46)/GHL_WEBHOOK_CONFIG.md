# 🔗 GHL Webhook Configuration for Colorado Campaign

**Campaign:** Moses Claude Colorado (4001)
**External System:** Go High Level (GHL)
**Created:** November 1, 2025
**Status:** ✅ Ready to Deploy

---

## 📋 What This Does

When someone **opts-in** on your Colorado campaign (gets SVYCLM disposition):
1. Vicidial calls your secure webhook handler
2. Handler sends clean data to GHL (no credentials exposed)
3. GHL receives the opt-in lead information
4. Everything is logged for debugging

---

## 🚀 STEP 1: Upload PHP Handler to Your Server

### Upload the File

**File to upload:**
```
ghl_webhook_handler.php
```

**Upload location on server:**
```
/var/www/html/api/ghl_webhook_handler.php
```

### Using SCP (from your Mac):
```bash
scp /Users/mosesherrera/Desktop/vicidial-analysis/Claude\ Vici\ Creations/ghl_webhook_handler.php \
    root@67.198.205.116:/var/www/html/api/
```

### Or SSH and create directory:
```bash
ssh root@67.198.205.116

# Create API directory if it doesn't exist
mkdir -p /var/www/html/api

# Set proper permissions
chmod 755 /var/www/html/api
chmod 644 /var/www/html/api/ghl_webhook_handler.php

# Create log files with proper permissions
touch /tmp/ghl_webhook_success.log
touch /tmp/ghl_webhook_errors.log
chmod 666 /tmp/ghl_webhook_success.log
chmod 666 /tmp/ghl_webhook_errors.log
```

---

## ⚙️ STEP 2: Configure Vicidial Campaign

### Option A: Web Interface (Recommended)

1. **Login to Vicidial:**
   ```
   https://dialpower.team/vicidial/admin.php
   ```

2. **Navigate to Campaign:**
   ```
   Admin → Campaigns → Click "4001" (Moses Claude Colorado)
   ```

3. **Scroll to "Campaign URLs" section**

4. **Find field: "Dispo Call URL"**

5. **Paste this EXACT URL:**
   ```
   http://67.198.205.116/api/ghl_webhook_handler.php?lead_id=--A--lead_id--B--&phone_number=--A--phone_number--B--&first_name=--A--first_name--B--&last_name=--A--last_name--B--&dispo=--A--dispo--B--&state=--A--state--B--&campaign_id=--A--campaign--B--&user=--A--user--B--&address1=--A--address1--B--&city=--A--city--B--&postal_code=--A--postal_code--B--&email=--A--email--B--&vendor_lead_code=--A--vendor_lead_code--B--
   ```

6. **Click "SUBMIT"**

---

### Option B: Database (Quick Method)

```bash
ssh root@67.198.205.116

mysql -u cron -p'6sfhf9ogku0q' asterisk -e "
UPDATE vicidial_campaigns
SET web_form_address = 'http://67.198.205.116/api/ghl_webhook_handler.php?lead_id=--A--lead_id--B--&phone_number=--A--phone_number--B--&first_name=--A--first_name--B--&last_name=--A--last_name--B--&dispo=--A--dispo--B--&state=--A--state--B--&campaign_id=--A--campaign--B--&user=--A--user--B--&address1=--A--address1--B--&city=--A--city--B--&postal_code=--A--postal_code--B--&email=--A--email--B--&vendor_lead_code=--A--vendor_lead_code--B--',
    web_form_address_two = 'SVYCLM'
WHERE campaign_id = '4001';
"
```

**Note:** `web_form_address_two = 'SVYCLM'` means "only trigger webhook on SVYCLM status"

---

## 🔒 Security Features

### ✅ What's Protected:

1. **No database credentials exposed** - Handler uses no DB connections
2. **No Vicidial passwords** - Never sent to external system
3. **Only opt-ins sent** - Script checks `dispo = 'SVYCLM'`
4. **Only Colorado campaign** - Script checks `campaign_id = '4001'`
5. **Clean data only** - Sends only necessary lead information

### ✅ What Gets Sent to GHL:

```json
{
  "lead_id": "12345",
  "phone_number": "3035551234",
  "first_name": "John",
  "last_name": "Doe",
  "full_name": "John Doe",
  "state": "CO",
  "status": "opt-in",
  "disposition": "SVYCLM",
  "campaign": "Colorado",
  "source": "Vicidial Opt-In",
  "timestamp": "2025-11-01 15:30:00",
  "timezone": "MST"
}
```

### ❌ What's NOT Sent:

- Database credentials
- Vicidial user passwords
- Internal server IPs
- Agent login information
- Other leads' data
- System configuration

---

## 🧪 STEP 3: Test the Webhook

### Test Method 1: Manual Browser Test

Visit this URL in your browser (replace with real data):
```
http://67.198.205.116/api/ghl_webhook_handler.php?lead_id=TEST123&phone_number=3035551234&first_name=John&last_name=Doe&dispo=SVYCLM&state=CO&campaign_id=4001&user=TEST
```

**Expected Response:**
```
OK - Opt-in sent to GHL successfully
```

---

### Test Method 2: Command Line Test

```bash
ssh root@67.198.205.116

curl "http://67.198.205.116/api/ghl_webhook_handler.php?lead_id=TEST456&phone_number=7205551234&first_name=Jane&last_name=Smith&dispo=SVYCLM&state=CO&campaign_id=4001&user=TESTUSER"
```

**Expected Output:**
```
OK - Opt-in sent to GHL successfully
```

---

### Test Method 3: Check Logs

```bash
ssh root@67.198.205.116

# View successful webhook attempts
tail -f /tmp/ghl_webhook_success.log

# View any errors
tail -f /tmp/ghl_webhook_errors.log
```

**Sample Log Entry (Success):**
```json
{"timestamp":"2025-11-01 15:30:00","lead_id":"TEST123","phone_number":"3035551234","name":"John Doe","http_code":200,"success":true,"response":"","error":""}
```

---

## 📊 STEP 4: Monitor in Production

### Real-Time Monitoring

**Watch webhook activity:**
```bash
ssh root@67.198.205.116

# Follow the log in real-time
tail -f /tmp/ghl_webhook_success.log | jq '.'
```

**Sample output:**
```json
{
  "timestamp": "2025-11-01 16:45:23",
  "lead_id": "98765",
  "phone_number": "3035559876",
  "name": "Sarah Johnson",
  "http_code": 200,
  "success": true,
  "response": "",
  "error": ""
}
```

---

### Count Today's Opt-Ins Sent to GHL

```bash
# Count webhooks sent today
grep "$(date +%Y-%m-%d)" /tmp/ghl_webhook_success.log | wc -l
```

---

### Check for Failed Webhooks

```bash
# Show only failed attempts (http_code != 200)
grep '"success":false' /tmp/ghl_webhook_success.log | tail -10
```

---

## 🐛 Troubleshooting

### Issue: "404 Not Found" When Testing

**Problem:** PHP file not uploaded or wrong location

**Fix:**
```bash
ssh root@67.198.205.116
ls -la /var/www/html/api/ghl_webhook_handler.php

# If missing, upload the file again
```

---

### Issue: "Permission Denied" Errors

**Problem:** Log files can't be written

**Fix:**
```bash
ssh root@67.198.205.116

# Fix log file permissions
chmod 666 /tmp/ghl_webhook_success.log
chmod 666 /tmp/ghl_webhook_errors.log
```

---

### Issue: Webhook Not Firing on Real Calls

**Check 1: Is campaign configured?**
```bash
mysql -u cron -p'6sfhf9ogku0q' asterisk -e "
SELECT web_form_address, web_form_address_two
FROM vicidial_campaigns
WHERE campaign_id = '4001';
"
```

Should show:
```
web_form_address: http://67.198.205.116/api/ghl_webhook_handler.php?...
web_form_address_two: SVYCLM
```

**Check 2: Are opt-ins happening?**
```bash
mysql -u cron -p'6sfhf9ogku0q' asterisk -e "
SELECT COUNT(*) as opt_ins
FROM vicidial_log
WHERE campaign_id = '4001'
AND status = 'SVYCLM'
AND call_date >= CURDATE();
"
```

**Check 3: Test manually**
```bash
# Trigger webhook manually
curl "http://67.198.205.116/api/ghl_webhook_handler.php?lead_id=MANUAL123&phone_number=3035551111&first_name=Test&last_name=User&dispo=SVYCLM&state=CO&campaign_id=4001&user=ADMIN"
```

---

### Issue: GHL Not Receiving Data

**Check 1: Is webhook URL correct?**
```php
// In ghl_webhook_handler.php, verify:
define('GHL_WEBHOOK_URL', 'https://services.leadconnectorhq.com/hooks/boXe5LQTgfuXIRfrFTja/webhook-trigger/e241703a-47bc-4554-8d04-bb31a33512cc');
```

**Check 2: Test GHL webhook directly**
```bash
curl -X POST https://services.leadconnectorhq.com/hooks/boXe5LQTgfuXIRfrFTja/webhook-trigger/e241703a-47bc-4554-8d04-bb31a33512cc \
  -H "Content-Type: application/json" \
  -d '{
    "lead_id": "TEST999",
    "phone_number": "3035559999",
    "first_name": "Direct",
    "last_name": "Test",
    "status": "opt-in"
  }'
```

**Check 3: Contact GHL support**
- Provide them with webhook URL
- Ask them to check their logs
- Verify webhook is active

---

## 📈 Analytics & Reporting

### Daily Webhook Summary

```bash
ssh root@67.198.205.116

# Today's opt-ins sent to GHL
echo "Opt-ins sent to GHL today:"
grep "$(date +%Y-%m-%d)" /tmp/ghl_webhook_success.log | grep '"success":true' | wc -l

# Failed attempts today
echo "Failed attempts today:"
grep "$(date +%Y-%m-%d)" /tmp/ghl_webhook_success.log | grep '"success":false' | wc -l
```

---

### View Recent Opt-Ins with Details

```bash
# Show last 10 opt-ins sent to GHL
tail -10 /tmp/ghl_webhook_success.log | jq -r '[.timestamp, .phone_number, .name] | @tsv'
```

---

### Weekly Summary Script

```bash
# Create weekly summary
cat > /root/weekly_ghl_summary.sh << 'EOF'
#!/bin/bash
echo "=== GHL Webhook Weekly Summary ==="
echo "Week of: $(date)"
echo ""
echo "Total opt-ins sent: $(wc -l < /tmp/ghl_webhook_success.log)"
echo "Successful: $(grep '"success":true' /tmp/ghl_webhook_success.log | wc -l)"
echo "Failed: $(grep '"success":false' /tmp/ghl_webhook_success.log | wc -l)"
echo ""
echo "=== Recent Opt-Ins ==="
tail -20 /tmp/ghl_webhook_success.log | jq -r '[.timestamp, .phone_number, .name, .success] | @tsv'
EOF

chmod +x /root/weekly_ghl_summary.sh

# Run it
/root/weekly_ghl_summary.sh
```

---

## 🔧 Advanced Configuration

### Add More Fields to Send to GHL

Edit `ghl_webhook_handler.php` and add to the `$payload` array:

```php
$payload = [
    // ... existing fields ...

    // Add custom fields
    'custom_field_1' => $_GET['custom_field_1'] ?? '',
    'agent_name' => $_GET['agent_name'] ?? '',
    'call_length' => $_GET['call_length'] ?? '',
    // etc.
];
```

Then update the Vicidial URL to include new fields:
```
&custom_field_1=--A--custom_field_1--B--
```

---

### Send to Multiple Systems

Duplicate the curl section in PHP:

```php
// Send to GHL
$ch1 = curl_init(GHL_WEBHOOK_URL);
// ... curl config ...
curl_exec($ch1);

// ALSO send to another system
$ch2 = curl_init('https://another-system.com/webhook');
// ... curl config ...
curl_exec($ch2);
```

---

## ✅ Final Checklist

### Installation Complete When:

- [ ] `ghl_webhook_handler.php` uploaded to `/var/www/html/api/`
- [ ] File permissions set correctly (644)
- [ ] Log files created (`/tmp/ghl_webhook_*.log`)
- [ ] Log file permissions set (666)
- [ ] Campaign 4001 "Dispo Call URL" configured
- [ ] Web form address two = 'SVYCLM'
- [ ] Manual test successful (browser or curl)
- [ ] Logs show successful webhook
- [ ] GHL confirms they're receiving data

---

## 📞 Next Steps

1. **Deploy:** Upload PHP file and configure campaign
2. **Test:** Send test opt-in and verify in logs
3. **Verify:** Check with GHL that they received test data
4. **Monitor:** Watch logs when campaign goes live
5. **Optimize:** Adjust fields based on GHL feedback

---

## 📝 Configuration Summary

| Setting | Value |
|---------|-------|
| **Campaign ID** | 4001 (Moses Claude Colorado) |
| **Trigger Status** | SVYCLM (opt-ins only) |
| **Handler URL** | http://67.198.205.116/api/ghl_webhook_handler.php |
| **GHL Webhook** | https://services.leadconnectorhq.com/hooks/boXe5LQTgfuXIRfrFTja/... |
| **Log Location** | /tmp/ghl_webhook_success.log |
| **Error Log** | /tmp/ghl_webhook_errors.log |

---

## 🎯 What Happens When Campaign Goes Live

```
1. Agent talks to Colorado lead
   ↓
2. Lead agrees to opt-in
   ↓
3. Agent dispositions call as "SVYCLM"
   ↓
4. Vicidial triggers your webhook handler
   ↓
5. Handler validates (SVYCLM + campaign 4001)
   ↓
6. Handler sends clean data to GHL
   ↓
7. GHL receives opt-in lead
   ↓
8. Lead added to GHL CRM automatically
   ↓
9. Success logged to /tmp/ghl_webhook_success.log
```

**Result:** Instant, automatic opt-in delivery to GHL with full logging!

---

**Created:** November 1, 2025
**For Campaign:** Moses Claude Colorado (4001)
**Status:** ✅ Ready to Deploy
