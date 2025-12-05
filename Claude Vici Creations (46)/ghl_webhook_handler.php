<?php
/**
 * SECURE GHL WEBHOOK HANDLER FOR COLORADO CAMPAIGN
 *
 * This script receives opt-in data from Vicidial and sends it to Go High Level
 *
 * NO CREDENTIALS EXPOSED - Only sends clean lead data
 * Campaign: Moses Claude Colorado (4001)
 *
 * Created: November 1, 2025
 */

// Enable error logging
ini_set('log_errors', 1);
ini_set('error_log', '/tmp/ghl_webhook_errors.log');

// GHL Webhook URL (provided by external partner)
define('GHL_WEBHOOK_URL', 'https://services.leadconnectorhq.com/hooks/boXe5LQTgfuXIRfrFTja/webhook-trigger/e241703a-47bc-4554-8d04-bb31a33512cc');

// Log file for successful webhooks
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
