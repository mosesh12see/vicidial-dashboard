# VICIdial White Label: Technical Implementation Guide

**Technical Deep-Dive for Developers and System Administrators**

---

## Table of Contents

1. [VICIdial Architecture Overview](#architecture-overview)
2. [File Structure and Key Components](#file-structure)
3. [Customization Points](#customization-points)
4. [Step-by-Step Implementation](#step-by-step-implementation)
5. [Database Modifications](#database-modifications)
6. [Advanced Customizations](#advanced-customizations)
7. [Testing and Validation](#testing-validation)
8. [Troubleshooting](#troubleshooting)

---

## Architecture Overview

### Technology Stack

VICIdial is built on the following technologies:

```
┌─────────────────────────────────────┐
│         Web Interface (PHP)         │
│  - Agent Portal: /agc/vicidial.php  │
│  - Admin Portal: /vicidial/admin.php│
│  - API: /agc/api.php                │
└─────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────┐
│      Backend Scripts (Perl/AGI)     │
│  - Call routing (Asterisk AGI)      │
│  - Lead processing                  │
│  - Dialing logic                    │
└─────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────┐
│        Database (MySQL/MariaDB)     │
│  - asterisk database                │
│  - Call logs, campaigns, agents     │
└─────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────┐
│      Telephony (Asterisk PBX)       │
│  - SIP trunking                     │
│  - Call control                     │
│  - Conference bridges               │
└─────────────────────────────────────┘
```

### Component Breakdown

**1. Frontend (PHP + JavaScript)**
- Language: PHP 7.x/8.x
- Framework: Custom (no framework - pure PHP)
- AJAX: jQuery-based real-time updates
- Location: `/srv/www/htdocs/`

**2. Backend Processing**
- Language: Perl
- AGI Scripts: Asterisk Gateway Interface
- Cron jobs: Automated lead processing
- Location: `/usr/share/astguiclient/`

**3. Database Layer**
- Engine: MySQL 5.0+ or MariaDB
- Default database: `asterisk`
- Tables: 100+ tables for campaigns, leads, agents, etc.

**4. PBX Layer**
- Platform: Asterisk 13.x/16.x/18.x
- Protocol: SIP/IAX2
- Dialplan: Custom AGI integration

---

## File Structure

### Complete Directory Layout

```
/srv/www/htdocs/                    # Web root (OpenSuSE)
│
├── agc/                            # Agent interface
│   ├── vicidial.php                # Main agent screen
│   ├── api.php                     # Agent API endpoints
│   ├── options.php                 # Agent customization options
│   ├── dbconnect.php               # Database connection config
│   │
│   ├── css/
│   │   ├── vicidial_stylesheet.css # Main styles
│   │   └── custom.css              # Custom CSS override
│   │
│   ├── images/
│   │   ├── vdc_tab_vicidial.gif    # Main logo (220x60px)
│   │   ├── vicidial_logo.gif       # Alternate logo
│   │   └── [other UI images]
│   │
│   ├── js/
│   │   ├── vicidial_script.js      # Core JavaScript
│   │   └── custom.js               # Custom JS
│   │
│   └── viciphone/                  # WebRTC softphone
│       └── [webphone files]
│
├── vicidial/                       # Admin interface
│   ├── admin.php                   # Main admin panel
│   ├── admin_header.php            # Admin page header
│   ├── admin_footer.php            # Admin page footer
│   ├── dbconnect.php               # Database connection config
│   ├── options.php                 # Admin customization options
│   │
│   ├── vicidial_admin_web_logo.gif # Admin logo (220x60px)
│   │
│   └── [200+ admin PHP files]
│       ├── admin_campaigns.php
│       ├── admin_users.php
│       ├── admin_lists.php
│       └── [etc.]
│
└── index.html                      # Landing page

/usr/share/astguiclient/            # Backend scripts
├── AST_CRON_audio_1_move_mix.pl    # Audio processing
├── AST_CRON_audio_2_compress.pl
├── AST_manager_send.pl             # Asterisk manager
├── AST_VDhopper.pl                 # Auto-dialer hopper
├── AST_VDauto_dial.pl              # Auto-dial engine
└── [100+ Perl scripts]

/etc/asterisk/                      # Asterisk config
├── extensions.conf                 # Dialplan
├── sip.conf                        # SIP configuration
├── manager.conf                    # Manager API
└── [other Asterisk configs]
```

### Critical Files for Branding

| File Path | Purpose | Modification Difficulty |
|-----------|---------|------------------------|
| `/srv/www/htdocs/agc/images/vdc_tab_vicidial.gif` | Agent logo | Easy (replace image) |
| `/srv/www/htdocs/vicidial/vicidial_admin_web_logo.gif` | Admin logo | Easy (replace image) |
| `/srv/www/htdocs/agc/css/custom.css` | Agent styles | Medium (CSS skills) |
| `/srv/www/htdocs/agc/options.php` | Agent config | Medium (PHP knowledge) |
| `/srv/www/htdocs/vicidial/options.php` | Admin config | Medium (PHP knowledge) |
| `/srv/www/htdocs/agc/vicidial.php` | Agent interface | Hard (core file) |
| `/srv/www/htdocs/vicidial/admin.php` | Admin interface | Hard (core file) |
| `/srv/www/htdocs/vicidial/admin_header.php` | Admin header | Medium (template) |

---

## Customization Points

### Level 1: Visual Branding (No Code Changes)

**1. Logo Replacement**
```bash
# Backup originals
cp /srv/www/htdocs/agc/images/vdc_tab_vicidial.gif \
   /srv/www/htdocs/agc/images/vdc_tab_vicidial.gif.backup

cp /srv/www/htdocs/vicidial/vicidial_admin_web_logo.gif \
   /srv/www/htdocs/vicidial/vicidial_admin_web_logo.gif.backup

# Replace with your logos (must be exactly 220x60 pixels, GIF format)
cp /path/to/your/agent_logo.gif \
   /srv/www/htdocs/agc/images/vdc_tab_vicidial.gif

cp /path/to/your/admin_logo.gif \
   /srv/www/htdocs/vicidial/vicidial_admin_web_logo.gif

# Set permissions
chmod 644 /srv/www/htdocs/agc/images/vdc_tab_vicidial.gif
chmod 644 /srv/www/htdocs/vicidial/vicidial_admin_web_logo.gif
```

**2. Custom CSS Styling**

Create `/srv/www/htdocs/agc/css/custom.css`:
```css
/* Your Company Branding */
:root {
    --primary-color: #0066CC;      /* Your brand blue */
    --secondary-color: #FF6600;    /* Your brand orange */
    --accent-color: #00CC66;       /* Your brand green */
    --text-color: #333333;
    --bg-color: #FFFFFF;
}

/* Override header background */
#vicidial_header {
    background-color: var(--primary-color) !important;
    background-image: linear-gradient(135deg,
        var(--primary-color) 0%,
        var(--secondary-color) 100%) !important;
}

/* Custom button styling */
.button, input[type="button"], input[type="submit"] {
    background-color: var(--primary-color) !important;
    border: 2px solid var(--primary-color) !important;
    color: white !important;
    border-radius: 4px !important;
    padding: 8px 16px !important;
    font-weight: bold !important;
}

.button:hover {
    background-color: var(--secondary-color) !important;
    border-color: var(--secondary-color) !important;
}

/* Custom table styling */
table.vicidial_table {
    border: 2px solid var(--primary-color) !important;
}

table.vicidial_table th {
    background-color: var(--primary-color) !important;
    color: white !important;
}

/* Custom footer */
#footer_logo {
    display: none !important; /* Hide VICIdial footer logo */
}

#custom_footer {
    text-align: center;
    padding: 20px;
    background-color: var(--primary-color);
    color: white;
    font-size: 12px;
}

#custom_footer::after {
    content: "© 2025 Your Company Name. All Rights Reserved.";
}
```

**3. options.php Configuration**

Copy and modify `/srv/www/htdocs/agc/options-example.php`:
```php
<?php
// Custom VICIdial Options
// Copy this file to options.php and customize

// Custom page title
$SSpage_title = "Your Company - Agent Portal";

// Custom header text
$SSlogin_heading = "Your Company Call Center";

// Custom colors
$SSstd_row1_background = "#E6F3FF";  // Light blue
$SSstd_row2_background = "#FFFFFF";  // White
$SSstd_row3_background = "#0066CC";  // Brand blue
$SSstd_row4_background = "#FF6600";  // Brand orange
$SSstd_row5_background = "#00CC66";  // Brand green

// Hide VICIdial version info
$SSadmin_screen_display = "1";  // 0=hide, 1=show

// Custom web form address
$SSweb_form_address = "https://yourcompany.com/crm";

// Custom agent logout URL
$SSlogout_goto = "https://yourcompany.com/thank-you";
?>
```

### Level 2: Template Modifications (Light Code Changes)

**1. Modify Admin Header**

Edit `/srv/www/htdocs/vicidial/admin_header.php`:
```php
<?php
// Find the header section (around line 50-100)
// Replace VICIdial references

// ORIGINAL:
// echo "<title>VICIdial Admin: $page_title</title>";

// REPLACE WITH:
echo "<title>Your Company Admin: $page_title</title>";

// ORIGINAL:
// echo "<h1>VICIdial Administration</h1>";

// REPLACE WITH:
echo "<h1>Your Company Call Center</h1>";

// Add custom CSS link
echo '<link rel="stylesheet" type="text/css" href="custom_admin.css">';
?>
```

**2. Modify Page Titles**

Use search and replace across PHP files:
```bash
# Backup first!
cd /srv/www/htdocs/vicidial/

# Find all instances
grep -r "VICIdial" *.php | wc -l

# Replace (CAREFUL!)
find . -name "*.php" -type f -exec sed -i.bak \
    's/VICIdial Admin/Your Company Admin/g' {} \;

find . -name "*.php" -type f -exec sed -i.bak \
    's/VICIdial/YourBrand/g' {} \;
```

### Level 3: Database Branding

**1. System Settings**

```sql
-- Update system name
UPDATE system_settings
SET sounds_web_server = 'https://yourcompany.com',
    web_server_ip = 'your.server.ip',
    sounds_web_directory = '/audio';

-- Update email settings
UPDATE system_settings
SET outbound_email_from = 'noreply@yourcompany.com';

-- Update user messages
UPDATE vicidial_admin_log_tables
SET comments = REPLACE(comments, 'VICIdial', 'YourCompany');
```

**2. Campaign Templates**

```sql
-- Update campaign descriptions
UPDATE vicidial_campaigns
SET campaign_description = REPLACE(
    campaign_description,
    'VICIdial',
    'Your Company'
);
```

### Level 4: Advanced Code Modifications

**1. Create Custom Wrapper**

Instead of modifying core files, create a wrapper:

`/srv/www/htdocs/yourcompany/index.php`:
```php
<?php
// Your Company Call Center Portal
// Custom wrapper around VICIdial

session_start();
require_once('../agc/dbconnect.php');

// Custom authentication
function custom_auth() {
    // Your custom auth logic
    // Could integrate with your existing SSO
}

// Custom branding
$company_name = "Your Company";
$brand_color = "#0066CC";
$logo_url = "/images/your-logo.png";

// Include VICIdial but override display
ob_start();
include('../agc/vicidial.php');
$vicidial_content = ob_get_clean();

// Replace branding in output
$vicidial_content = str_replace(
    'VICIdial',
    $company_name,
    $vicidial_content
);

// Custom header
include('custom_header.php');

// Output modified content
echo $vicidial_content;

// Custom footer
include('custom_footer.php');
?>
```

**2. API Wrapper for White Label**

`/srv/www/htdocs/api/yourcompany_api.php`:
```php
<?php
// Your Company API Wrapper
// Proxies VICIdial API with custom branding

require_once('../agc/dbconnect.php');

class YourCompanyAPI {
    private $vicidial_api;

    public function __construct() {
        // Initialize VICIdial API
        require_once('../agc/api.php');
    }

    public function make_call($phone, $campaign) {
        // Your custom logic
        // Then call VICIdial API
        $result = $this->vicidial_api->originate_call($phone, $campaign);

        // Transform response to match your API format
        return $this->transform_response($result);
    }

    private function transform_response($vicidial_response) {
        // Remove VICIdial references
        // Return as "Your Company" API response
    }
}

// RESTful endpoints
$api = new YourCompanyAPI();

switch($_SERVER['REQUEST_METHOD']) {
    case 'POST':
        // Handle API calls
        break;
}
?>
```

---

## Step-by-Step Implementation

### Phase 1: Preparation (Day 1)

**1. Backup Everything**
```bash
#!/bin/bash
# Complete backup script

BACKUP_DIR="/backup/vicidial_$(date +%Y%m%d_%H%M%S)"
mkdir -p $BACKUP_DIR

# Backup web files
tar -czf $BACKUP_DIR/www.tar.gz /srv/www/htdocs/

# Backup database
mysqldump -u root -p asterisk > $BACKUP_DIR/asterisk_db.sql

# Backup Asterisk configs
tar -czf $BACKUP_DIR/asterisk_config.tar.gz /etc/asterisk/

# Backup Perl scripts
tar -czf $BACKUP_DIR/astguiclient.tar.gz /usr/share/astguiclient/

echo "Backup complete: $BACKUP_DIR"
```

**2. Document Current State**
```bash
# Take screenshots of current interface
# Document current URLs
# List all customizations already made
# Export database schema

mysqldump -u root -p --no-data asterisk > schema_before.sql
```

**3. Setup Testing Environment**
```bash
# Create a staging subdomain
# Clone current installation
# Test all changes here first
```

### Phase 2: Basic Branding (Days 2-3)

**1. Replace Logos**
```bash
# Prepare your logos (220x60px, GIF format)
convert your_logo.png -resize 220x60! -colors 256 vdc_tab_vicidial.gif
convert your_logo.png -resize 220x60! -colors 256 vicidial_admin_web_logo.gif

# Backup originals
cd /srv/www/htdocs/agc/images/
cp vdc_tab_vicidial.gif vdc_tab_vicidial.gif.orig

cd /srv/www/htdocs/vicidial/
cp vicidial_admin_web_logo.gif vicidial_admin_web_logo.gif.orig

# Copy new logos
cp /path/to/vdc_tab_vicidial.gif /srv/www/htdocs/agc/images/
cp /path/to/vicidial_admin_web_logo.gif /srv/www/htdocs/vicidial/

# Clear browser cache and test
```

**2. Apply Custom CSS**
```bash
# Create custom.css in agent interface
nano /srv/www/htdocs/agc/css/custom.css
# [paste CSS from above]

# Link in main file
nano /srv/www/htdocs/agc/vicidial.php
# Add: <link rel="stylesheet" href="css/custom.css">

# Same for admin
nano /srv/www/htdocs/vicidial/custom_admin.css
```

**3. Configure options.php**
```bash
# Agent options
cp /srv/www/htdocs/agc/options-example.php \
   /srv/www/htdocs/agc/options.php
nano /srv/www/htdocs/agc/options.php
# [customize as shown above]

# Admin options
cp /srv/www/htdocs/vicidial/options-example.php \
   /srv/www/htdocs/vicidial/options.php
nano /srv/www/htdocs/vicidial/options.php
```

### Phase 3: Template Modifications (Days 4-7)

**1. Header/Footer Updates**
```bash
# Modify admin header
nano /srv/www/htdocs/vicidial/admin_header.php

# Modify admin footer
nano /srv/www/htdocs/vicidial/admin_footer.php

# Test all admin pages
```

**2. Systematic Text Replacement**
```bash
# Create replacement script
cat > /tmp/replace_branding.sh << 'EOF'
#!/bin/bash

SEARCH="VICIdial"
REPLACE="YourCompany"

for file in /srv/www/htdocs/vicidial/*.php; do
    echo "Processing: $file"
    sed -i.bak "s/$SEARCH Admin/$REPLACE Admin/g" "$file"
    sed -i.bak "s/$SEARCH System/$REPLACE System/g" "$file"
done

echo "Done! Backup files saved with .bak extension"
EOF

chmod +x /tmp/replace_branding.sh
# Review script before running!
# /tmp/replace_branding.sh
```

### Phase 4: Testing & Validation (Days 8-10)

**1. Functional Testing**
```bash
# Test checklist
□ Agent login
□ Make test call
□ Disposition call
□ View reports
□ Admin login
□ Create campaign
□ Upload leads
□ Modify user
□ Generate reports
```

**2. Visual Testing**
```bash
# Check all pages for:
□ Logo appears correctly
□ Colors match brand
□ No "VICIdial" text visible
□ Custom footer shows
□ CSS loads properly
□ No console errors
```

### Phase 5: Deployment (Day 11)

**1. Schedule Maintenance Window**
```bash
# Off-peak hours recommended
# Send notification to users
# Prepare rollback plan
```

**2. Deploy to Production**
```bash
# Stop services
systemctl stop apache2
systemctl stop asterisk

# Copy files from staging
rsync -av /staging/www/ /srv/www/htdocs/

# Restart services
systemctl start asterisk
systemctl start apache2

# Monitor logs
tail -f /var/log/apache2/error.log
tail -f /var/log/asterisk/full
```

---

## Database Modifications

### Safe Database Updates

```sql
-- Always backup first!
-- mysqldump -u root -p asterisk > backup_before_changes.sql

-- 1. Update System Branding
USE asterisk;

UPDATE system_settings
SET
    enable_queuemetrics_logging = 'Y',
    queuemetrics_server_ip = 'your.qm.server',
    queuemetrics_dbname = 'yourcompany_qm',
    sounds_web_server = 'https://calls.yourcompany.com',
    sounds_web_directory = '/audio',
    outbound_email_from = 'dialer@yourcompany.com',
    admin_email = 'admin@yourcompany.com';

-- 2. Update Campaign Descriptions
UPDATE vicidial_campaigns
SET campaign_description = CONCAT(
    'Your Company - ',
    campaign_description
);

-- 3. Update User Welcome Messages
UPDATE vicidial_users
SET user_start_url = 'https://yourcompany.com/agent-welcome'
WHERE user_start_url LIKE '%vicidial%';

-- 4. Update Email Templates
UPDATE vicidial_email_list
SET email_from = 'noreply@yourcompany.com'
WHERE email_from LIKE '%vicidial%';

-- 5. Create Custom Branding Table
CREATE TABLE IF NOT EXISTS yourcompany_branding (
    setting_name VARCHAR(100) PRIMARY KEY,
    setting_value TEXT,
    description VARCHAR(255),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO yourcompany_branding VALUES
('company_name', 'Your Company Name', 'Display name', NOW()),
('logo_url', '/images/your-logo.png', 'Logo path', NOW()),
('primary_color', '#0066CC', 'Brand color', NOW()),
('support_email', 'support@yourcompany.com', 'Contact email', NOW()),
('copyright_text', '© 2025 Your Company', 'Footer text', NOW());
```

---

## Advanced Customizations

### Custom Dashboard Integration

Create your own dashboard that pulls VICIdial data:

**File:** `/srv/www/htdocs/yourcompany/dashboard.php`
```php
<?php
require_once('../agc/dbconnect.php');

// Your Company Custom Dashboard
$company_name = "Your Company";
?>
<!DOCTYPE html>
<html>
<head>
    <title><?php echo $company_name; ?> Dashboard</title>
    <style>
        /* Your custom styles */
    </style>
</head>
<body>
    <header>
        <img src="/images/your-logo.png" alt="<?php echo $company_name; ?>">
        <h1><?php echo $company_name; ?> Call Center</h1>
    </header>

    <main>
        <?php
        // Query VICIdial database for stats
        $query = "SELECT
            COUNT(*) as total_calls,
            COUNT(CASE WHEN status = 'SALE' THEN 1 END) as sales,
            COUNT(DISTINCT user) as active_agents
        FROM vicidial_log
        WHERE DATE(call_date) = CURDATE()";

        $result = mysqli_query($link, $query);
        $stats = mysqli_fetch_assoc($result);
        ?>

        <div class="stats">
            <div class="stat-box">
                <h2><?php echo number_format($stats['total_calls']); ?></h2>
                <p>Calls Today</p>
            </div>
            <div class="stat-box">
                <h2><?php echo number_format($stats['sales']); ?></h2>
                <p>Sales Today</p>
            </div>
            <div class="stat-box">
                <h2><?php echo $stats['active_agents']; ?></h2>
                <p>Active Agents</p>
            </div>
        </div>

        <!-- Link to VICIdial interfaces -->
        <div class="quick-links">
            <a href="../agc/vicidial.php" class="btn">Agent Login</a>
            <a href="../vicidial/admin.php" class="btn">Admin Panel</a>
        </div>
    </main>
</body>
</html>
```

### Custom API Gateway

Create a white-labeled API:

**File:** `/srv/www/htdocs/api/v1/calls.php`
```php
<?php
header('Content-Type: application/json');
require_once('../../agc/dbconnect.php');

// Your Company API v1 - Calls Endpoint
class YourCompanyCallsAPI {
    private $db;

    public function __construct($link) {
        $this->db = $link;
    }

    public function originate_call($data) {
        // Validate API key
        if (!$this->validate_api_key($data['api_key'])) {
            return ['error' => 'Invalid API key'];
        }

        // Call VICIdial function
        // (You would include VICIdial's API functions here)

        $phone = $data['phone_number'];
        $campaign = $data['campaign_id'];

        // Insert into hopper for immediate dial
        $query = "INSERT INTO vicidial_hopper
            (campaign_id, lead_id, source, status, user)
            VALUES ('$campaign', 'NEW', 'API', 'READY', 'API')";

        if (mysqli_query($this->db, $query)) {
            return [
                'success' => true,
                'call_id' => mysqli_insert_id($this->db),
                'message' => 'Call queued successfully'
            ];
        } else {
            return [
                'error' => 'Failed to queue call',
                'details' => mysqli_error($this->db)
            ];
        }
    }

    private function validate_api_key($key) {
        // Validate against your API keys table
        $query = "SELECT * FROM yourcompany_api_keys WHERE api_key = '$key' AND active = 'Y'";
        $result = mysqli_query($this->db, $query);
        return mysqli_num_rows($result) > 0;
    }
}

// Handle request
$api = new YourCompanyCallsAPI($link);

switch($_SERVER['REQUEST_METHOD']) {
    case 'POST':
        $data = json_decode(file_get_contents('php://input'), true);
        $result = $api->originate_call($data);
        echo json_encode($result);
        break;

    default:
        echo json_encode(['error' => 'Method not allowed']);
}
?>
```

---

## Testing & Validation

### Pre-Launch Checklist

```bash
# Visual Checks
□ All logos replaced
□ Color scheme matches brand
□ No VICIdial text in UI
□ Custom footer displays
□ Favicon updated

# Functional Checks
□ Agent login works
□ Calls can be made
□ Calls can be received
□ Dispositions save correctly
□ Reports generate properly
□ Admin functions work
□ User management works
□ Campaign management works

# Technical Checks
□ No JavaScript errors (F12 console)
□ CSS loads correctly
□ Images load correctly
□ Database connections work
□ API endpoints respond
□ Email notifications send with correct branding

# Performance Checks
□ Page load times acceptable
□ Database queries optimized
□ No memory leaks
□ Asterisk stable
□ Call quality maintained

# Security Checks
□ File permissions correct (644 for files, 755 for dirs)
□ Database credentials secure
□ API keys validated
□ SQL injection prevention
□ XSS prevention
```

---

## Troubleshooting

### Common Issues

**1. Logos Not Showing**
```bash
# Check file permissions
ls -la /srv/www/htdocs/agc/images/vdc_tab_vicidial.gif
# Should be: -rw-r--r-- (644)

# Check file size
file /srv/www/htdocs/agc/images/vdc_tab_vicidial.gif
# Should be GIF image data

# Clear browser cache
# Hard refresh: Ctrl+Shift+R

# Check Apache error log
tail -f /var/log/apache2/error.log
```

**2. CSS Not Loading**
```bash
# Verify file exists
ls -la /srv/www/htdocs/agc/css/custom.css

# Check if linked in HTML
grep "custom.css" /srv/www/htdocs/agc/vicidial.php

# Verify CSS syntax
css-validator /srv/www/htdocs/agc/css/custom.css

# Check browser console for 404 errors
```

**3. Database Changes Not Reflected**
```sql
-- Verify changes were saved
SELECT * FROM system_settings;

-- Check for caching
FLUSH TABLES;

-- Restart Apache (to clear PHP opcache)
systemctl restart apache2
```

**4. Calls Not Working After Changes**
```bash
# Check Asterisk
asterisk -rx "core show channels"
asterisk -rx "sip show peers"

# Check database connectivity
mysql -u cron -p -h 67.198.205.116 asterisk

# Review Asterisk logs
tail -f /var/log/asterisk/full | grep ERROR

# Verify dialplan
asterisk -rx "dialplan show"
```

**5. Performance Degradation**
```bash
# Check Apache processes
ps aux | grep apache2 | wc -l

# Check MySQL queries
mysqladmin processlist -u root -p

# Monitor server resources
htop

# Check slow query log
tail -f /var/log/mysql/slow-query.log
```

---

## Maintenance & Updates

### Ongoing Maintenance Tasks

**Monthly:**
- Review custom files for VICIdial updates
- Test all customizations still work
- Backup customizations separately
- Update documentation

**Quarterly:**
- Review and optimize custom code
- Update logos/branding if changed
- Performance testing
- Security audit

**When Updating VICIdial:**
1. Test update in staging first
2. Document all custom files
3. Re-apply customizations after update
4. Test thoroughly before production
5. Keep customizations in version control

---

## Next Steps

After completing this implementation:

1. ✅ Document all changes made
2. ✅ Train administrators on maintenance
3. ✅ Create runbook for common tasks
4. ✅ Set up monitoring/alerts
5. ✅ Plan for future enhancements

See also:
- `03_FILE_MODIFICATION_GUIDE.md` - Complete file-by-file changes
- `04_VENDOR_COMPARISON.md` - Pre-built theme options
- `05_IMPLEMENTATION_PLAN.md` - Project timeline

---

**Document Version:** 1.0
**Last Updated:** October 28, 2025
**Maintained By:** Technical Team
