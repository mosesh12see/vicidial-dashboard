#!/bin/bash
# 🚀 AUTOMATED GHL WEBHOOK DEPLOYMENT FOR COLORADO CAMPAIGN
# Run this on your Vicidial server (67.198.205.116)

echo "========================================"
echo "🚀 GHL Webhook Deployment Starting..."
echo "========================================"
echo ""

# Step 1: Create API directory
echo "📁 Step 1: Creating API directory..."
mkdir -p /var/www/html/api
chmod 755 /var/www/html/api
echo "✅ Directory created"
echo ""

# Step 2: Create PHP webhook handler
echo "📝 Step 2: Creating webhook handler..."
cat > /var/www/html/api/ghl_webhook_handler.php << 'PHPEOF'
<?php
/**
 * SECURE GHL WEBHOOK HANDLER FOR COLORADO CAMPAIGN
 * Campaign: Moses Claude Colorado (4001)
 * Only sends: Phone, Name, Email, Address - NO internal tracking
 */

ini_set('log_errors', 1);
ini_set('error_log', '/tmp/ghl_webhook_errors.log');

// GHL Webhook URL
define('GHL_WEBHOOK_URL', 'https://services.leadconnectorhq.com/hooks/boXe5LQTgfuXIRfrFTja/webhook-trigger/e241703a-47bc-4554-8d04-bb31a33512cc');
define('LOG_FILE', '/tmp/ghl_webhook_success.log');

// Get parameters from Vicidial (internal use only)
$dispo = $_GET['dispo'] ?? '';
$campaign_id = $_GET['campaign_id'] ?? '4001';

// Get ONLY the fields user wants to share with GHL
$phone_number = $_GET['phone_number'] ?? '';
$first_name = $_GET['first_name'] ?? '';
$last_name = $_GET['last_name'] ?? '';
$email = $_GET['email'] ?? '';
$address1 = $_GET['address1'] ?? '';
$city = $_GET['city'] ?? '';
$state = $_GET['state'] ?? 'CO';
$postal_code = $_GET['postal_code'] ?? '';

// SECURITY: Only process opt-ins (SVYCLM status)
if ($dispo !== 'SVYCLM') {
    http_response_code(200);
    echo "OK - Not an opt-in (Status: $dispo)";
    exit;
}

// SECURITY: Only process Colorado campaign
if ($campaign_id !== '4001') {
    http_response_code(200);
    echo "OK - Not Colorado campaign";
    exit;
}

// Validate required field (phone number is minimum)
if (empty($phone_number)) {
    http_response_code(400);
    echo "ERROR - Missing phone number";
    error_log("GHL Webhook Error: Missing phone_number");
    exit;
}

// Prepare MINIMAL data for GHL - ONLY contact info, NO internal tracking
$payload = [
    'phone_number' => $phone_number,
    'first_name' => $first_name,
    'last_name' => $last_name,
    'email' => $email,
    'address1' => $address1,
    'city' => $city,
    'state' => $state,
    'postal_code' => $postal_code,
];

// Remove empty fields
$payload = array_filter($payload, function($value) {
    return $value !== '' && $value !== null;
});

// Send to GHL webhook
$ch = curl_init(GHL_WEBHOOK_URL);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    'Content-Type: application/json',
    'User-Agent: Vicidial-Colorado-Campaign/1.0'
]);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_TIMEOUT, 10);
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, true);

$response = curl_exec($ch);
$http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$curl_error = curl_error($ch);
curl_close($ch);

// Log the webhook attempt (minimal info)
$log_entry = [
    'timestamp' => date('Y-m-d H:i:s'),
    'phone_number' => $phone_number,
    'name' => trim("$first_name $last_name"),
    'http_code' => $http_code,
    'success' => ($http_code >= 200 && $http_code < 300),
    'error' => $curl_error ? substr($curl_error, 0, 100) : ''
];

// Write to success log
file_put_contents(
    LOG_FILE,
    json_encode($log_entry) . "\n",
    FILE_APPEND
);

// Return response
if ($http_code >= 200 && $http_code < 300) {
    http_response_code(200);
    echo "OK - Opt-in sent to GHL successfully";
    error_log("GHL Webhook Success: $phone_number sent to GHL");
} else {
    http_response_code(500);
    echo "ERROR - Failed to send to GHL (HTTP $http_code)";
    error_log("GHL Webhook Failed: HTTP $http_code - $curl_error");
}
?>
PHPEOF

chmod 644 /var/www/html/api/ghl_webhook_handler.php
echo "✅ Webhook handler created"
echo ""

# Step 3: Create log files
echo "📋 Step 3: Creating log files..."
touch /tmp/ghl_webhook_success.log
touch /tmp/ghl_webhook_errors.log
chmod 666 /tmp/ghl_webhook_success.log
chmod 666 /tmp/ghl_webhook_errors.log
echo "✅ Log files created"
echo ""

# Step 4: Configure campaign in database
echo "⚙️  Step 4: Configuring campaign 4001..."
mysql -u cron -p'6sfhf9ogku0q' asterisk << 'SQLEOF'
UPDATE vicidial_campaigns
SET
  web_form_address = 'http://67.198.205.116/api/ghl_webhook_handler.php?phone_number=--A--phone_number--B--&first_name=--A--first_name--B--&last_name=--A--last_name--B--&email=--A--email--B--&address1=--A--address1--B--&city=--A--city--B--&state=--A--state--B--&postal_code=--A--postal_code--B--&dispo=--A--dispo--B--&campaign_id=--A--campaign--B--',
  web_form_address_two = 'SVYCLM'
WHERE campaign_id = '4001';
SQLEOF

if [ $? -eq 0 ]; then
    echo "✅ Campaign configured"
else
    echo "❌ Failed to configure campaign"
    exit 1
fi
echo ""

# Step 5: Verify configuration
echo "🔍 Step 5: Verifying configuration..."
mysql -u cron -p'6sfhf9ogku0q' asterisk -e "
SELECT
  campaign_id,
  campaign_name,
  web_form_address_two as trigger_status
FROM vicidial_campaigns
WHERE campaign_id = '4001';
"
echo ""

# Step 6: Test webhook
echo "🧪 Step 6: Sending test opt-in to GHL..."
echo ""
TEST_RESPONSE=$(curl -s "http://67.198.205.116/api/ghl_webhook_handler.php?phone_number=3035551234&first_name=John&last_name=Doe&email=john.doe@test.com&address1=123+Main+St&city=Denver&state=CO&postal_code=80202&dispo=SVYCLM&campaign_id=4001")

echo "Response: $TEST_RESPONSE"
echo ""

# Step 7: Check logs
echo "📊 Step 7: Checking webhook log..."
if [ -f /tmp/ghl_webhook_success.log ]; then
    echo "Last log entry:"
    tail -1 /tmp/ghl_webhook_success.log | python3 -m json.tool 2>/dev/null || tail -1 /tmp/ghl_webhook_success.log
else
    echo "❌ Log file not found"
fi
echo ""

# Summary
echo "========================================"
echo "✅ DEPLOYMENT COMPLETE!"
echo "========================================"
echo ""
echo "📋 What was deployed:"
echo "  ✓ Webhook handler: /var/www/html/api/ghl_webhook_handler.php"
echo "  ✓ Campaign 4001 configured"
echo "  ✓ Test opt-in sent to GHL"
echo ""
echo "📊 Monitor webhooks:"
echo "  tail -f /tmp/ghl_webhook_success.log"
echo ""
echo "🧪 Manual test command:"
echo "  curl 'http://67.198.205.116/api/ghl_webhook_handler.php?phone_number=3035559999&first_name=Test&last_name=User&dispo=SVYCLM&campaign_id=4001'"
echo ""
echo "⚠️  NEXT STEP: Ask your GHL partner if they received:"
echo "  - Test opt-in for: John Doe"
echo "  - Phone: 303-555-1234"
echo "  - Email: john.doe@test.com"
echo ""
