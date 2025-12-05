# VICIdial White Label: SaaS Reseller Business Model

**Building a Multi-Tenant Call Center Platform to Resell**

**Purpose:** Hide your proprietary vendors (Instacall, Bytworth, etc.), markup services, and resell dialer access to other companies while protecting your competitive advantages.

---

## Executive Summary

**Business Model:** You become a **white-labeled dialer service provider**, where other companies plug into YOUR system, pay YOU for minutes/DIDs/data, and you skim profit off the top while keeping your vendor relationships and processes SECRET.

**Your Role:**
- Platform provider (they use your VICIdial infrastructure)
- Service wholesaler (you resell minutes/DIDs with markup)
- Technology partner (they think it's your proprietary system)

**Their Experience:**
- They see "YourBrand Dialer" (not VICIdial)
- They never know about Instacall, Bytworth, or your vendors
- They pay YOUR prices (marked up from your costs)
- They can't see your backend processes or configurations
- They get their own isolated campaigns and data

---

## The Revenue Model

### Your Cost Structure (Hidden from Clients)

**Current Vendors You're Hiding:**
- **Instacall:** $X per minute (your actual cost)
- **Bytworth:** Server hosting/infrastructure
- **SIP Carriers:** Minute costs, DID costs
- **VICIdial:** Open source (free)
- **Your labor:** Setup, management, support

### Your Pricing Structure (What Clients See)

**Client-Facing Prices (Markup Examples):**

```yaml
Services You Resell:

Minutes:
  Your Cost: $0.01/min (Instacall)
  Your Price: $0.025/min (150% markup)
  Profit: $0.015/min

DIDs (Phone Numbers):
  Your Cost: $1/month (wholesale)
  Your Price: $3/month (200% markup)
  Profit: $2/month per DID

Platform Access:
  Your Cost: $0 (amortized infrastructure)
  Your Price: $500/month (per client)
  Profit: Pure margin

Data Storage:
  Your Cost: $0.10/GB (your servers)
  Your Price: $1/GB (900% markup)
  Profit: $0.90/GB

Setup Fee:
  Your Cost: 2 hours labor ($200)
  Your Price: $1,500 one-time
  Profit: $1,300
```

**Example Client Bill:**
```
Client: ABC Solar Company
Month: October 2025

Platform License:     $500
100,000 minutes:      $2,500  (@ $0.025/min)
10 DIDs:              $30
50 GB data:           $50
Support (5 hours):    $500

TOTAL:                $3,580
Your Actual Cost:     $1,200
YOUR PROFIT:          $2,380 (66% margin!)
```

**At Scale (10 Clients):**
- Revenue: $35,800/month
- Costs: $12,000/month
- **Profit: $23,800/month** ($285K/year)

---

## Multi-Tenant Architecture

### What You Need to Hide

**1. Your Backend Vendors (CRITICAL)**
```
CLIENT SEES:
┌─────────────────────────┐
│   YourBrand Dialer      │
│   "Powered by Our Tech" │
└─────────────────────────┘

CLIENT DOESN'T SEE:
┌─────────────────────────┐
│   VICIdial (open source)│
│   Instacall (minutes)   │
│   Bytworth (hosting)    │
│   Your SIP carriers     │
│   Your secret processes │
└─────────────────────────┘
```

**2. Your Pricing Margins**
- Never show actual costs
- Bundle services to obscure markup
- Present as "your infrastructure"

**3. Your Technical Setup**
- Database structure (they get isolated views)
- Server architecture
- Routing logic
- Integration methods

**4. Other Clients**
- Complete data isolation
- Can't see other campaigns
- Can't see system capacity

### Technical Implementation

**Multi-Tenant Database Structure:**

```sql
-- Client Isolation Table
CREATE TABLE reseller_clients (
    client_id INT PRIMARY KEY AUTO_INCREMENT,
    client_name VARCHAR(100),
    api_key VARCHAR(255) UNIQUE,
    created_date DATETIME,
    status ENUM('active', 'suspended', 'cancelled'),

    -- Billing
    rate_per_minute DECIMAL(6,4),  -- Their rate (marked up)
    monthly_platform_fee DECIMAL(10,2),

    -- Limits
    max_concurrent_calls INT,
    max_agents INT,
    max_campaigns INT,

    -- Hidden from client
    internal_notes TEXT,
    actual_cost_per_minute DECIMAL(6,4)  -- Your real cost
);

-- Client-Specific Campaigns
ALTER TABLE vicidial_campaigns
ADD COLUMN reseller_client_id INT,
ADD FOREIGN KEY (reseller_client_id)
    REFERENCES reseller_clients(client_id);

-- Client-Specific Users
ALTER TABLE vicidial_users
ADD COLUMN reseller_client_id INT,
ADD FOREIGN KEY (reseller_client_id)
    REFERENCES reseller_clients(client_id);

-- Usage Tracking for Billing
CREATE TABLE reseller_usage (
    usage_id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT,
    usage_date DATE,
    minutes_used INT,
    dids_active INT,
    data_storage_gb DECIMAL(10,2),
    api_calls INT,

    -- Your costs (hidden)
    actual_cost DECIMAL(10,2),

    -- Their charges
    billed_amount DECIMAL(10,2),

    FOREIGN KEY (client_id) REFERENCES reseller_clients(client_id)
);
```

**Access Control (Row-Level Security):**

```sql
-- Clients can ONLY see their own data
CREATE VIEW client_campaigns AS
SELECT * FROM vicidial_campaigns
WHERE reseller_client_id = @current_client_id;

CREATE VIEW client_leads AS
SELECT l.* FROM vicidial_list l
JOIN vicidial_campaigns c ON l.list_id = c.campaign_id
WHERE c.reseller_client_id = @current_client_id;

CREATE VIEW client_call_logs AS
SELECT vl.* FROM vicidial_log vl
JOIN vicidial_campaigns c ON vl.campaign_id = c.campaign_id
WHERE c.reseller_client_id = @current_client_id;

-- They NEVER see:
-- - Other clients' data
-- - System configuration
-- - Your vendor information
-- - Actual cost data
-- - Server details
```

---

## White Label Portal (Client-Facing)

### What Clients Access

**Custom Branded Portal:** `https://dialer.yourclientcompany.com`

**They See:**
```
┌────────────────────────────────────┐
│  ABC Solar Dialer                  │
│  "Powered by Your Technology"      │
├────────────────────────────────────┤
│  Dashboard                         │
│  - My Campaigns                    │
│  - My Agents                       │
│  - My Reports                      │
│  - My Billing                      │
│                                    │
│  Usage This Month:                 │
│  Minutes: 45,230 @ $0.025/min     │
│  Cost: $1,130.75                   │
│                                    │
│  DIDs: 10 active                   │
│  Platform Fee: $500                │
│                                    │
│  TOTAL: $1,640.75                  │
└────────────────────────────────────┘
```

**They DON'T See:**
- VICIdial anywhere
- Your actual vendors
- Other clients
- System admin panel
- True infrastructure costs
- Markup percentages

### Custom Client Portal Code

**File:** `/srv/www/htdocs/client_portal/dashboard.php`

```php
<?php
// Client-Branded Portal
// Completely hides VICIdial and your vendors

session_start();
require_once('../config/client_auth.php');

// Get current client
$client_id = $_SESSION['client_id'];
$client = get_client_info($client_id);

// Get their usage (with YOUR marked up prices)
$usage = calculate_client_billing($client_id, date('Y-m'));

?>
<!DOCTYPE html>
<html>
<head>
    <title><?php echo $client['client_name']; ?> Dialer</title>
    <style>
        /* Their custom branding */
        :root {
            --brand-color: <?php echo $client['brand_color']; ?>;
        }
        /* Completely different UI from VICIdial */
    </style>
</head>
<body>
    <header>
        <img src="<?php echo $client['logo_url']; ?>">
        <h1><?php echo $client['client_name']; ?> Call Center</h1>
        <p>Powered by [Your Company] Technology</p>
    </header>

    <div class="dashboard">
        <div class="usage-summary">
            <h2>This Month's Usage</h2>

            <!-- Show THEIR prices (marked up) -->
            <div class="usage-item">
                <span>Minutes Used:</span>
                <span><?php echo number_format($usage['minutes']); ?></span>
                <span class="cost">$<?php echo number_format($usage['minutes_cost'], 2); ?></span>
                <small>@ $<?php echo $client['rate_per_minute']; ?>/min</small>
            </div>

            <div class="usage-item">
                <span>DIDs Active:</span>
                <span><?php echo $usage['dids']; ?></span>
                <span class="cost">$<?php echo number_format($usage['did_cost'], 2); ?></span>
            </div>

            <div class="usage-item">
                <span>Platform Fee:</span>
                <span>Monthly</span>
                <span class="cost">$<?php echo number_format($client['monthly_platform_fee'], 2); ?></span>
            </div>

            <div class="total">
                <strong>Total This Month:</strong>
                <strong class="cost">$<?php echo number_format($usage['total'], 2); ?></strong>
            </div>

            <!-- HIDDEN: Your actual costs and profit margin -->
            <?php /*
            Your actual cost: $<?php echo $usage['internal_cost']; ?>
            Your profit: $<?php echo $usage['total'] - $usage['internal_cost']; ?>
            Margin: <?php echo (($usage['total'] - $usage['internal_cost']) / $usage['total'] * 100); ?>%
            */ ?>
        </div>

        <div class="quick-actions">
            <a href="campaigns.php">Manage Campaigns</a>
            <a href="agents.php">Manage Agents</a>
            <a href="reports.php">View Reports</a>
            <a href="billing.php">Billing History</a>
        </div>

        <!-- Link to VICIdial agent screen (but proxied through your branding) -->
        <div class="agent-login">
            <a href="agent_login.php" class="btn-primary">
                Agent Login
            </a>
        </div>
    </div>

    <!-- NO MENTION OF:
         - VICIdial
         - Instacall
         - Bytworth
         - Your other vendors
         - Other clients
    -->
</body>
</html>

<?php
function calculate_client_billing($client_id, $month) {
    global $link;

    // Get actual usage from VICIdial tables
    $query = "SELECT
        COUNT(*) as total_calls,
        SUM(length_in_sec) as total_seconds
    FROM vicidial_log vl
    JOIN vicidial_campaigns vc ON vl.campaign_id = vc.campaign_id
    WHERE vc.reseller_client_id = ?
    AND DATE_FORMAT(call_date, '%Y-%m') = ?";

    $stmt = $link->prepare($query);
    $stmt->bind_param('is', $client_id, $month);
    $stmt->execute();
    $result = $stmt->get_result()->fetch_assoc();

    $minutes = ceil($result['total_seconds'] / 60);

    // Get client's rate (YOUR marked up price)
    $client_rate = get_client_rate($client_id);

    // Calculate THEIR bill (at marked up prices)
    $minutes_cost = $minutes * $client_rate['per_minute'];
    $did_cost = count_active_dids($client_id) * $client_rate['per_did'];
    $platform_fee = $client_rate['monthly_fee'];

    // Get YOUR actual cost (hidden from client)
    $actual_cost = $minutes * 0.01; // Your real rate from Instacall

    return [
        'minutes' => $minutes,
        'minutes_cost' => $minutes_cost,
        'dids' => count_active_dids($client_id),
        'did_cost' => $did_cost,
        'platform_fee' => $platform_fee,
        'total' => $minutes_cost + $did_cost + $platform_fee,

        // Hidden from client view
        'internal_cost' => $actual_cost,
        'profit' => ($minutes_cost + $did_cost + $platform_fee) - $actual_cost
    ];
}
?>
```

---

## Protecting Your Secrets

### 1. Hide Your Vendor Relationships

**Problem:** Client might see "Instacall" in SIP headers or call logs

**Solution: SIP Header Rewriting**

```bash
# In Asterisk dialplan
# /etc/asterisk/extensions_custom.conf

[client-outbound]
; Rewrite headers to hide Instacall
exten => _X.,1,Set(CALLERID(name)=YourBrand Dialer)
exten => _X.,n,Set(CDR(accountcode)=${CLIENT_ID})
; Remove/rewrite SIP headers that might expose Instacall
exten => _X.,n,SIPRemoveHeader(X-Instacall-ID)
exten => _X.,n,SIPAddHeader(X-Platform: YourBrand)
exten => _X.,n,Dial(SIP/${EXTEN}@instacall-hidden)
```

**In SIP configuration:**
```ini
; /etc/asterisk/sip_custom.conf

[instacall-hidden]
; Your actual Instacall trunk
type=peer
host=instacall.com
username=your_account
secret=your_secret

; But clients see generic "trunk"
; They never know it's Instacall
```

### 2. Hide Database Schema

**Proxy Database Access:**

```php
// Instead of direct database access, use API wrapper

class ClientAPI {
    private $client_id;

    public function get_campaigns() {
        // Only returns THEIR campaigns
        // Hides table structure and other data

        $query = "SELECT
            campaign_id as id,
            campaign_name as name,
            active,
            dial_method
        FROM vicidial_campaigns
        WHERE reseller_client_id = ?
        AND deleted = 'N'";

        // They never see:
        // - Full table structure
        // - Other clients' campaigns
        // - Internal fields
        // - System campaigns
    }

    public function get_call_stats() {
        // Returns sanitized stats
        // Hides backend processes
    }
}
```

### 3. Hide Your Costs

**Never Show:**
```
❌ "Instacall minutes cost: $0.01/min"
❌ "Server hosting: $400/month"
❌ "Your profit margin: 150%"
❌ "Actual vendor: Bytworth"
```

**Instead Show:**
```
✓ "Premium minute rate: $0.025/min"
✓ "Enterprise platform access: $500/month"
✓ "Professional tier pricing"
✓ "Powered by YourBrand Technology"
```

### 4. Legal Protection

**Client Contract Must Include:**

```markdown
SERVICE AGREEMENT

1. PROPRIETARY TECHNOLOGY
   Client acknowledges that [Your Company]'s platform,
   including but not limited to routing, infrastructure,
   and vendor relationships, are proprietary trade secrets.

2. NON-DISCLOSURE
   Client agrees not to:
   - Reverse engineer the platform
   - Attempt to discover vendor relationships
   - Share platform details with third parties
   - Replicate the technology

3. NO VENDOR ACCESS
   Client has no direct relationship with underlying
   service providers. All services are provided by
   [Your Company] exclusively.

4. PRICING
   Rates are subject to change with 30 days notice.
   Client acknowledges rates include platform access,
   support, and infrastructure.

5. TERMINATION
   Upon termination, Client must cease all use of
   platform and may not transfer or replicate any
   aspect of the service.
```

---

## Client Onboarding Process

### Step 1: Sales & Contract

```yaml
Sales Process:
  - Demo your "proprietary platform"
  - Quote YOUR prices (marked up)
  - Sign service agreement (with NDA)
  - Collect setup fee ($1,500)
```

### Step 2: Technical Setup (Automated by AI)

```python
# Client Provisioning Script
# Runs when new client signs up

def onboard_new_client(client_name, contact_info, pricing_tier):
    # 1. Create client record
    client_id = create_client_record(client_name, pricing_tier)

    # 2. Generate API credentials
    api_key = generate_api_key(client_id)

    # 3. Create isolated database views
    create_client_views(client_id)

    # 4. Set up their campaigns
    create_default_campaigns(client_id)

    # 5. Configure routing (using YOUR Instacall trunk)
    configure_trunk_routing(client_id, 'instacall-hidden')

    # 6. Brand their portal
    deploy_branded_portal(client_id, client_name)

    # 7. Send welcome email (from your brand)
    send_welcome_email(contact_info, api_key)

    print(f"✓ Client {client_name} provisioned")
    print(f"✓ They see: YourBrand Dialer")
    print(f"✓ They pay: {pricing_tier} rates")
    print(f"✓ Your cost: Wholesale")
    print(f"✓ Your profit: {calculate_margin(pricing_tier)}%")
```

### Step 3: Training (Your Branded)

```markdown
Training Materials:

"Welcome to [Your Company] Dialer Platform"

✓ How to log in
✓ How to create campaigns
✓ How to upload leads
✓ How to add agents
✓ How to view reports
✓ How billing works

NO MENTION OF:
✗ VICIdial
✗ Instacall
✗ Bytworth
✗ Your vendors
✗ Your processes
```

---

## Scaling the Business

### Revenue Projections

**Month 1-3: Pilot Clients**
```
Clients: 3
Avg Revenue/Client: $3,500/month
Total Revenue: $10,500/month
Your Costs: $4,000/month
Profit: $6,500/month
```

**Month 6: Growing**
```
Clients: 10
Avg Revenue/Client: $3,500/month
Total Revenue: $35,000/month
Your Costs: $12,000/month
Profit: $23,000/month ($276K/year)
```

**Month 12: Established**
```
Clients: 25
Avg Revenue/Client: $4,000/month
Total Revenue: $100,000/month
Your Costs: $30,000/month
Profit: $70,000/month ($840K/year)
```

**Year 2: Scaling**
```
Clients: 50
Avg Revenue/Client: $4,500/month
Total Revenue: $225,000/month
Your Costs: $65,000/month
Profit: $160,000/month ($1.92M/year)
```

### Cost Structure at Scale

```yaml
Infrastructure (Fixed):
  VICIdial Servers: $2,000/month
  Database Hosting: $1,000/month
  Backup/DR: $500/month
  Monitoring: $300/month
  Total Fixed: $3,800/month

Variable Costs (Per Client):
  Minutes (avg 50K/month @ $0.01): $500
  DIDs (avg 10 @ $1): $10
  Storage (avg 20GB @ $0.10): $2
  Total Variable: ~$512/client

Support (Scales with clients):
  1 support person per 15 clients: $4,000/month

Total Cost at 25 Clients:
  Fixed: $3,800
  Variable: $12,800 (25 x $512)
  Support: $8,000 (2 people)
  TOTAL: $24,600/month

Revenue at 25 Clients: $100,000/month
Profit: $75,400/month (75% margin!)
```

---

## Competitive Advantages You're Hiding

### 1. Your Vendor Relationships

```
SECRET ADVANTAGES:
✓ Negotiated Instacall rates (cheaper than retail)
✓ Direct Bytworth partnership (better support)
✓ Wholesale DID provider (bulk pricing)
✓ Custom SIP routing (optimized quality)

CLIENT PERCEPTION:
"YourBrand has proprietary technology"
(They don't know you're marking up wholesale services)
```

### 2. Your Processes

```
SECRET SAUCE:
✓ Custom dialplan logic
✓ Optimized campaign templates
✓ Proven conversion strategies
✓ Integration methods
✓ Reporting formulas

CLIENT SEES:
"Advanced platform features"
(They don't know your exact setup)
```

### 3. Your Economics

```
YOUR REALITY:
Minutes: $0.01 (Instacall wholesale)
Your Price: $0.025 (150% markup)

CLIENT THINKS:
"Industry standard pricing"
(They don't know your actual costs)
```

---

## Technical Architecture

### Multi-Tenant System Diagram

```
┌─────────────────────────────────────────────────┐
│              CLIENT COMPANIES                    │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │Client A  │  │Client B  │  │Client C  │ ...  │
│  │(Solar)   │  │(HVAC)    │  │(Insurance)│      │
│  └─────┬────┘  └─────┬────┘  └─────┬────┘      │
│        │             │              │            │
│        │   "Your Brand Dialer API"  │            │
│        └─────────────┼──────────────┘            │
└──────────────────────┼───────────────────────────┘
                       │
         ┌─────────────▼─────────────┐
         │   YOUR PLATFORM LAYER      │
         │   (Branded Portal)         │
         │   - Client isolation       │
         │   - Billing markup         │
         │   - Usage tracking         │
         └─────────────┬─────────────┘
                       │
         ┌─────────────▼─────────────┐
         │   VICIDIAL CORE            │
         │   (Hidden from clients)    │
         │   - Campaign management    │
         │   - Agent routing          │
         │   - Call processing        │
         └─────────────┬─────────────┘
                       │
      ┌────────────────┼────────────────┐
      │                │                 │
┌─────▼──────┐  ┌──────▼──────┐  ┌──────▼──────┐
│ Instacall  │  │  Bytworth   │  │  Your SIP   │
│ (Minutes)  │  │  (Hosting)  │  │  (DIDs)     │
│ HIDDEN     │  │  HIDDEN     │  │  HIDDEN     │
└────────────┘  └─────────────┘  └─────────────┘

CLIENTS NEVER SEE YOUR VENDORS!
```

---

## Sample Pricing Tiers

### Bronze Tier
```
Platform Fee: $299/month
Minutes: $0.03/min
DIDs: $5/month each
Max 5 concurrent calls
Max 10 agents

Your Cost: ~$150/month
Your Profit: ~$150/month per client
```

### Silver Tier (Most Popular)
```
Platform Fee: $499/month
Minutes: $0.025/min
DIDs: $3/month each
Max 20 concurrent calls
Max 50 agents
Priority support

Your Cost: ~$250/month
Your Profit: ~$250/month + minute markup
```

### Gold Tier
```
Platform Fee: $999/month
Minutes: $0.02/min
DIDs: $2/month each
Unlimited concurrent calls
Unlimited agents
24/7 support
Custom integrations

Your Cost: ~$400/month
Your Profit: ~$600/month + minute markup
```

### Enterprise (Custom)
```
Custom pricing
Dedicated infrastructure
White-labeled for their clients
Custom features
SLA guarantees

Your Profit: $2,000-10,000+/month
```

---

## Next Steps to Launch

### Phase 1: Infrastructure (Week 1-2)
- [ ] Set up multi-tenant database schema
- [ ] Configure client isolation
- [ ] Build billing system
- [ ] Create branded client portal
- [ ] Test with dummy client

### Phase 2: Legal & Business (Week 2-3)
- [ ] Create service agreements
- [ ] Set up billing system (Stripe, etc.)
- [ ] Define pricing tiers
- [ ] Create sales materials (hiding VICIdial/vendors)

### Phase 3: First Client (Week 3-4)
- [ ] Sign first pilot client
- [ ] Provision their account
- [ ] Train their team
- [ ] Monitor usage
- [ ] Generate first invoice

### Phase 4: Scale (Month 2+)
- [ ] Add 2-3 clients per month
- [ ] Refine processes
- [ ] Automate onboarding
- [ ] Hire support staff
- [ ] Grow to 10+ clients

---

## Bottom Line

**This is a MUCH better business model than simple white labeling!**

**Traditional White Label:**
- One-time effort
- Internal use only
- Saves money

**Reseller SaaS Model:**
- Recurring revenue
- Scalable business
- **Makes $70K-160K/month profit at scale**

**You Provide:**
- Infrastructure (VICIdial)
- Vendor relationships (Instacall, etc.)
- Support

**Clients Get:**
- Turnkey dialer
- "Your" technology
- Pay premium prices

**You Keep Secret:**
- VICIdial (open source)
- Instacall (your vendor)
- Bytworth (your vendor)
- Your markup (150-300%)
- Your processes

**You Profit:**
- 66-75% margins
- Scalable to $1-2M/year
- Minimal additional cost per client
- Recurring revenue

---

**Ready to build a 7-figure dialer resale business?**

This is the model to follow! 🚀💰
