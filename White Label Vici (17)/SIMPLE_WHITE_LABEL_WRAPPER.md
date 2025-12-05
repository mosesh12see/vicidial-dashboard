# ⚡ SUPER SIMPLE WHITE LABEL WRAPPER

**Multi-Tenant UI on Top of Your Existing Vici (500K calls/day)**

*Created: November 11, 2025*

---

## 🎯 WHAT YOU'RE BUILDING:

A **simple dashboard** that lets other people use YOUR Vici infrastructure without seeing your Vici.

**You already have:**
- ✅ Vici running (500K calls/day!)
- ✅ Campaigns working
- ✅ Data uploads working
- ✅ DID rotation working
- ✅ Transfers/opt-ins working
- ✅ Ultravox integrated (AI voice)

**You just need:**
- Simple customer-facing UI
- API that talks to your Vici
- Multi-tenant isolation (customer A can't see customer B's stuff)

---

## 📐 SUPER SIMPLE ARCHITECTURE:

```
┌────────────────────────────────────────┐
│  CUSTOMER DASHBOARD (White Label UI)  │
│  ┌──────────────────────────────────┐ │
│  │ • Upload leads (CSV)             │ │
│  │ • Start/Stop campaigns           │ │
│  │ • Configure AI agent             │ │
│  │ • View analytics                 │ │
│  └──────────────────────────────────┘ │
└────────────────────────────────────────┘
                ↓ (Your API)
┌────────────────────────────────────────┐
│  YOUR WRAPPER API (Proxy Layer)       │
│  • Auth (which customer?)              │
│  • Map customer → Vici campaigns       │
│  • Proxy to Vici API                   │
│  • Fetch analytics from Vici DB        │
└────────────────────────────────────────┘
                ↓
┌────────────────────────────────────────┐
│  YOUR EXISTING VICI (Already Working) │
│  • 500K calls/day                      │
│  • Campaigns, DIDs, data, everything   │
│  • Ultravox AI integrated              │
└────────────────────────────────────────┘
```

**That's it. Simple proxy layer + clean UI.**

---

## 🛠️ WHAT YOU BUILD (3 COMPONENTS):

### 1. **CUSTOMER DATABASE** (Track who owns what)

```sql
-- Just 4 simple tables

-- Customer accounts
CREATE TABLE customers (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQUE,
  company_name VARCHAR(255),
  api_key VARCHAR(255) UNIQUE,
  vici_prefix VARCHAR(50),  -- e.g., "CUST123_"
  created_at TIMESTAMP
);

-- Map customer campaigns to Vici campaigns
CREATE TABLE campaigns (
  id SERIAL PRIMARY KEY,
  customer_id INT REFERENCES customers(id),
  campaign_name VARCHAR(255),
  vici_campaign_id VARCHAR(50),  -- e.g., "CUST123_SOLAR"
  status VARCHAR(20),  -- active, paused, stopped
  created_at TIMESTAMP
);

-- Track uploaded leads
CREATE TABLE lead_uploads (
  id SERIAL PRIMARY KEY,
  customer_id INT REFERENCES customers(id),
  campaign_id INT REFERENCES campaigns(id),
  filename VARCHAR(255),
  total_leads INT,
  uploaded_at TIMESTAMP
);

-- Agent configs (Ultravox settings)
CREATE TABLE agent_configs (
  id SERIAL PRIMARY KEY,
  customer_id INT REFERENCES customers(id),
  agent_name VARCHAR(255),
  ultravox_config JSON,  -- voice, prompt, etc.
  created_at TIMESTAMP
);
```

---

### 2. **WRAPPER API** (Talks to your Vici)

**Simple Node.js/Express API:**

```javascript
const express = require('express');
const axios = require('axios');
const app = express();

// Your existing Vici API
const VICI_API_URL = 'https://your-vici.com/agc/api.php';
const VICI_USER = 'api_admin';
const VICI_PASS = 'your_api_password';

// Auth middleware - which customer is this?
const authenticate = async (req, res, next) => {
  const apiKey = req.headers['x-api-key'];
  const customer = await db.customers.findOne({ api_key: apiKey });
  if (!customer) return res.status(401).json({ error: 'Unauthorized' });
  req.customer = customer;
  next();
};

// 1. Upload leads
app.post('/api/leads/upload', authenticate, async (req, res) => {
  const { campaign_id, leads } = req.body;  // leads = CSV data

  // Get customer's Vici campaign ID
  const campaign = await db.campaigns.findOne({
    id: campaign_id,
    customer_id: req.customer.id
  });

  // Upload to Vici using their API
  for (const lead of leads) {
    await axios.post(VICI_API_URL, {
      user: VICI_USER,
      pass: VICI_PASS,
      function: 'add_lead',
      list_id: campaign.vici_campaign_id,
      phone_number: lead.phone,
      first_name: lead.name,
      // ... other fields
    });
  }

  res.json({ success: true, leads_uploaded: leads.length });
});

// 2. Start campaign
app.post('/api/campaigns/:id/start', authenticate, async (req, res) => {
  const campaign = await db.campaigns.findOne({
    id: req.params.id,
    customer_id: req.customer.id
  });

  // Start dialing in Vici
  await axios.post(VICI_API_URL, {
    user: VICI_USER,
    pass: VICI_PASS,
    function: 'campaign_start',
    campaign_id: campaign.vici_campaign_id
  });

  await db.campaigns.update({ id: campaign.id }, { status: 'active' });
  res.json({ success: true });
});

// 3. Stop campaign
app.post('/api/campaigns/:id/stop', authenticate, async (req, res) => {
  const campaign = await db.campaigns.findOne({
    id: req.params.id,
    customer_id: req.customer.id
  });

  await axios.post(VICI_API_URL, {
    user: VICI_USER,
    pass: VICI_PASS,
    function: 'campaign_stop',
    campaign_id: campaign.vici_campaign_id
  });

  await db.campaigns.update({ id: campaign.id }, { status: 'stopped' });
  res.json({ success: true });
});

// 4. Get analytics (from Vici database)
app.get('/api/analytics/:campaign_id', authenticate, async (req, res) => {
  const campaign = await db.campaigns.findOne({
    id: req.params.campaign_id,
    customer_id: req.customer.id
  });

  // Query YOUR Vici MySQL database directly
  const stats = await viciDB.query(`
    SELECT
      COUNT(*) as total_calls,
      SUM(CASE WHEN status = 'SALE' THEN 1 ELSE 0 END) as sales,
      AVG(length_in_sec) as avg_duration
    FROM vicidial_log
    WHERE campaign_id = ?
    AND call_date >= CURDATE()
  `, [campaign.vici_campaign_id]);

  res.json(stats);
});

// 5. Configure AI agent (Ultravox)
app.post('/api/agents/configure', authenticate, async (req, res) => {
  const { agent_name, voice_id, prompt } = req.body;

  // Save config
  await db.agent_configs.insert({
    customer_id: req.customer.id,
    agent_name,
    ultravox_config: { voice_id, prompt }
  });

  // Apply to their Vici campaigns
  // (Update campaign settings to use this Ultravox config)

  res.json({ success: true });
});

app.listen(3000);
```

**That's basically it. Super simple proxy API.**

---

### 3. **CUSTOMER DASHBOARD** (Simple React UI)

**Pages:**

```
/login                  → Customer logs in
/dashboard             → Overview (calls today, active campaigns)
/campaigns             → List campaigns, start/stop
/campaigns/new         → Create new campaign
/leads/upload          → Upload CSV
/agent/configure       → Set up AI voice
/analytics             → Charts & stats
```

**Example Dashboard Component:**

```jsx
import { useState, useEffect } from 'react';

export default function Dashboard() {
  const [stats, setStats] = useState(null);

  useEffect(() => {
    fetch('/api/analytics/summary', {
      headers: { 'X-API-Key': localStorage.getItem('apiKey') }
    })
    .then(r => r.json())
    .then(setStats);
  }, []);

  return (
    <div className="p-8">
      <h1 className="text-3xl font-bold mb-8">Dashboard</h1>

      <div className="grid grid-cols-3 gap-6">
        <StatCard title="Calls Today" value={stats?.calls_today} />
        <StatCard title="Sales Today" value={stats?.sales_today} />
        <StatCard title="Active Campaigns" value={stats?.active_campaigns} />
      </div>

      <CampaignsList />
    </div>
  );
}

function CampaignsList() {
  const [campaigns, setCampaigns] = useState([]);

  const startCampaign = (id) => {
    fetch(`/api/campaigns/${id}/start`, {
      method: 'POST',
      headers: { 'X-API-Key': localStorage.getItem('apiKey') }
    });
  };

  return (
    <div className="mt-8">
      <h2 className="text-2xl mb-4">Your Campaigns</h2>
      {campaigns.map(c => (
        <div key={c.id} className="border p-4 mb-2">
          <span>{c.name}</span>
          <span className="ml-4 text-gray-600">{c.status}</span>
          <button
            onClick={() => startCampaign(c.id)}
            className="ml-4 bg-green-500 text-white px-4 py-2 rounded"
          >
            Start
          </button>
        </div>
      ))}
    </div>
  );
}
```

---

## ⚡ MULTI-TENANT ISOLATION:

**Key concept:** Each customer gets their own "namespace" in Vici

```javascript
// When customer signs up:
async function createCustomer(email, company_name) {
  const customer_id = generateId();
  const vici_prefix = `CUST${customer_id}_`;  // e.g., "CUST123_"

  await db.customers.insert({
    email,
    company_name,
    vici_prefix,
    api_key: generateApiKey()
  });

  return { customer_id, vici_prefix };
}

// All their Vici campaigns are prefixed:
// Customer 123: CUST123_SOLAR, CUST123_INSURANCE, etc.
// Customer 456: CUST456_SOLAR, CUST456_INSURANCE, etc.

// Your API ensures they can ONLY access their prefixed campaigns:
const campaign = await viciDB.query(`
  SELECT * FROM vicidial_campaigns
  WHERE campaign_id LIKE '${req.customer.vici_prefix}%'
`);
```

**Security:** Customer can NEVER see or access other customers' data.

---

## 💰 COST & TIMELINE:

### OPTION 1: HIRE CONTRACTOR (FASTEST)

**Timeline:** 3-4 weeks

**Breakdown:**
- Week 1: Database setup, basic API
- Week 2: Vici API integration, auth
- Week 3: Dashboard UI
- Week 4: Testing, polish

**Cost:**
- Developer: $8-10K (4 weeks @ $2-2.5K/week)
- Infrastructure: $500 (hosting, DB)
- **Total: $8.5-10.5K**

---

### OPTION 2: CLAUDE BUILDS IT (YOU MANAGE)

**Timeline:** 4-5 weeks

**Your effort:**
- Week 1: 10 hours (review schemas, test Vici API)
- Week 2: 15 hours (test endpoints, debug)
- Week 3: 10 hours (review UI, provide feedback)
- Week 4: 15 hours (end-to-end testing)
- Week 5: 10 hours (deploy, monitor)
- **Total: 60 hours**

**Cost:**
- Infrastructure: $500
- Tools: $200
- **Total: $700 + your time**

---

### OPTION 3: BARE MINIMUM MVP (2 WEEKS)

**What it includes:**
- Simple login page
- Upload CSV → goes to Vici
- Start/Stop button for campaigns
- Basic analytics (calls, sales)
- NO fancy UI, just functional

**Cost:** $4-5K (contractor) or $300 (DIY with Claude)

**Timeline:** 2 weeks

---

## 🎯 WHAT EACH CUSTOMER CAN DO:

**Customer logs in → sees ONLY their stuff:**

1. **Upload Leads**
   - Upload CSV file
   - Your API → Vici API (add_lead)
   - Their leads go to THEIR campaign only

2. **Start/Stop Campaigns**
   - Click "Start" button
   - Your API → Vici API (campaign_start)
   - Vici starts dialing their leads
   - Ultravox handles AI voice

3. **Configure AI Agent**
   - Choose voice (ElevenLabs voice ID)
   - Write prompt/script
   - Your API saves config
   - Applied to their campaigns

4. **View Analytics**
   - Dashboard shows:
     - Calls today
     - Sales/conversions
     - Average call duration
     - Lead status breakdown
   - Data pulled from YOUR Vici database
   - Filtered to ONLY their campaigns

5. **Manage DIDs** (optional)
   - Assign phone numbers to their campaigns
   - Your system rotates DIDs for them
   - They just see "using 50 numbers"

**They NEVER see:**
- Your Vici interface
- Other customers' data
- Your overall system stats
- Underlying infrastructure

---

## 🚀 STEP-BY-STEP IMPLEMENTATION:

### WEEK 1: FOUNDATION

**Day 1-2: Database & Auth**
```bash
# Set up PostgreSQL
createdb white_label_customers

# Run schema (from above)
psql white_label_customers < schema.sql

# Set up JWT auth
npm install jsonwebtoken bcrypt
```

**Day 3-4: Vici API Testing**
```javascript
// Test Vici API calls
const testViciAPI = async () => {
  // Test add_lead
  const result = await axios.post(VICI_API_URL, {
    user: VICI_USER,
    pass: VICI_PASS,
    function: 'add_lead',
    list_id: 'TEST_LIST',
    phone_number: '5551234567'
  });
  console.log(result.data);

  // Test campaign_start
  // Test campaign_stop
  // Test getting stats
};
```

**Day 5: Basic API Structure**
```bash
# Set up Express API
mkdir white-label-api
cd white-label-api
npm init -y
npm install express pg axios cors dotenv

# Create basic endpoints:
# - POST /api/auth/login
# - POST /api/leads/upload
# - POST /api/campaigns/:id/start
# - GET /api/analytics/:id
```

---

### WEEK 2: VICI INTEGRATION

**Map customer actions to Vici API:**

```javascript
// Customer uploads CSV → Vici add_lead
// Customer clicks Start → Vici campaign_start
// Customer clicks Stop → Vici campaign_stop
// Customer views analytics → Query Vici DB

// All with proper isolation (vici_prefix)
```

**Test multi-tenancy:**
```javascript
// Create 2 test customers
// Upload leads for each
// Verify customer A can't see customer B's data
```

---

### WEEK 3: DASHBOARD UI

**Simple Next.js app:**

```bash
npx create-next-app@latest white-label-dashboard
cd white-label-dashboard
npm install recharts  # for charts

# Pages:
# - app/login/page.js
# - app/dashboard/page.js
# - app/campaigns/page.js
# - app/upload/page.js
# - app/analytics/page.js
```

**Connect to API:**
```javascript
// All API calls use customer's API key
const apiCall = (endpoint, options = {}) => {
  return fetch(`${API_URL}${endpoint}`, {
    ...options,
    headers: {
      'X-API-Key': localStorage.getItem('apiKey'),
      ...options.headers
    }
  });
};
```

---

### WEEK 4: TESTING & LAUNCH

**Testing checklist:**
- [ ] Customer A uploads leads → goes to correct Vici campaign
- [ ] Customer A starts campaign → Vici dials correctly
- [ ] Customer A sees analytics → correct data
- [ ] Customer B cannot see Customer A's data
- [ ] Ultravox AI works on calls
- [ ] DID rotation works
- [ ] Handle 1000+ simultaneous calls
- [ ] API performance (<500ms response times)

**Deploy:**
```bash
# API
docker build -t white-label-api .
docker push your-registry/white-label-api
kubectl apply -f k8s/deployment.yaml

# Dashboard
vercel deploy
# or
npm run build && pm2 start npm -- start
```

---

## 📊 CUSTOMER ONBOARDING FLOW:

**New customer signs up:**

```javascript
// 1. Create customer account
POST /api/auth/register
{
  email: "customer@example.com",
  company: "Solar Co",
  password: "..."
}

// Backend creates:
// - customer record with unique vici_prefix
// - API key
// - Default campaign in Vici: CUST123_DEFAULT

// 2. Customer logs in → gets API key

// 3. Customer uploads first leads
POST /api/leads/upload
{
  campaign_id: 1,
  leads: [
    { phone: "555-1234", name: "John" },
    { phone: "555-5678", name: "Jane" }
  ]
}

// Backend:
// - Validates customer owns campaign
// - Uploads to Vici using customer's vici_prefix
// - Returns success

// 4. Customer configures AI agent
POST /api/agents/configure
{
  voice_id: "elevenlabs_voice_123",
  prompt: "You're calling about solar..."
}

// Backend:
// - Saves Ultravox config
// - Updates Vici campaign settings

// 5. Customer starts campaign
POST /api/campaigns/1/start

// Backend:
// - Calls Vici API campaign_start
// - Vici starts dialing
// - Ultravox handles AI calls
// - Customer sees real-time stats

// 6. Customer views results
GET /api/analytics/1

// Returns:
{
  calls_today: 1234,
  sales: 45,
  avg_duration: 180,
  conversion_rate: 3.6%
}
```

**Customer never touches Vici directly. They just use your clean UI.**

---

## 💡 KEY FEATURES TO INCLUDE:

### MUST-HAVES (MVP):
- ✅ Login/auth
- ✅ Upload CSV leads
- ✅ Start/stop campaigns
- ✅ Basic analytics (calls, sales, duration)
- ✅ Configure AI agent (voice, prompt)

### NICE-TO-HAVES (Phase 2):
- Real-time call monitoring (listen live)
- Call recordings playback
- Lead status management (callback, DNC, etc.)
- Multiple campaigns per customer
- Team management (sub-users)
- White-label branding (custom logo, colors)

### ADVANCED (Phase 3):
- API access for customers (they can integrate)
- Webhooks (notify customer of events)
- Custom reports
- A/B testing (different AI prompts)
- Billing/payments (Stripe)

---

## 🔒 SECURITY CHECKLIST:

- [ ] **API Key Auth:** Each customer has unique API key
- [ ] **Campaign Isolation:** Customers can ONLY access their vici_prefix campaigns
- [ ] **Database Queries:** All queries filtered by customer_id
- [ ] **Vici Access:** Your API is the ONLY thing that talks to Vici (customers never have direct access)
- [ ] **Rate Limiting:** Prevent abuse (max 1000 API calls/hour)
- [ ] **Input Validation:** Sanitize all user input (prevent SQL injection)
- [ ] **HTTPS Only:** All API communication encrypted
- [ ] **Audit Logs:** Track all customer actions

---

## 💰 PRICING MODEL (What You Charge):

**Based on usage (like your enterprise doc):**

**STARTER** - $299/month
- 1 campaign
- 10K calls/month
- Basic analytics

**PRO** - $999/month
- 5 campaigns
- 50K calls/month
- Advanced analytics
- Multi-user

**ENTERPRISE** - Custom pricing
- Unlimited campaigns
- 500K+ calls/month
- White-label
- Priority support

**Your costs:** ~$50/month per customer (infrastructure)
**Your margin:** 85%+

**With 10 customers on Pro plan:** $10K MRR
**With 50 customers:** $50K MRR
**With 100 customers:** $100K MRR

---

## 🚀 GO LIVE CHECKLIST:

**Before launch:**
- [ ] Test with 2-3 beta customers
- [ ] Verify analytics are accurate
- [ ] Ensure calls route correctly (Vici → Ultravox)
- [ ] Check multi-tenant isolation (customers can't see each other)
- [ ] Load test (can it handle 10K calls/hour?)
- [ ] Set up monitoring (alerts if API goes down)
- [ ] Create onboarding docs for customers
- [ ] Set up support channel (email/chat)

**Launch:**
- [ ] Deploy to production
- [ ] Invite first paying customer
- [ ] Monitor closely for 48 hours
- [ ] Collect feedback
- [ ] Iterate

---

## ⚡ BOTTOM LINE:

**This is SIMPLE. You're just building a UI layer on top of what you already have.**

**Timeline:**
- **MVP (bare minimum):** 2 weeks
- **Production-ready:** 4 weeks
- **Polished:** 6-8 weeks

**Cost:**
- **With contractor:** $8-10K (full featured)
- **With Claude:** $500-1K + 60 hours your time
- **Bare MVP:** $4-5K or $300 DIY

**Effort:**
- Simple CRUD app
- Proxy API calls to Vici
- Basic React dashboard
- **Complexity: 3/10** (easy)

**Claude can absolutely build this in 4-5 weeks.**

---

## 🎯 NEXT STEPS (THIS WEEK):

1. **Test Vici API access:**
   - Document your Vici API credentials
   - Test add_lead, campaign_start, campaign_stop
   - Verify you can query vicidial_log table

2. **Choose tech stack:**
   - Backend: Node.js + Express (recommended)
   - Frontend: Next.js + TailwindCSS
   - Database: PostgreSQL
   - Hosting: AWS/DigitalOcean

3. **Decide: Hire or DIY?**
   - Hire: Post on Upwork/Toptal for "Node.js + React developer"
   - DIY: We start building with Claude right now

4. **Set up infrastructure:**
   - AWS account
   - PostgreSQL database
   - Domain name for customer portal

**Want me to start building the API right now?** I can have basic endpoints working in a few hours.

Just say "build it" and I'll start with the database schema and API endpoints. 🚀
