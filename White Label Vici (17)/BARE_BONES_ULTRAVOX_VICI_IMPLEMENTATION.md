# 🚀 BARE BONES WHITE LABEL: ULTRAVOX + VICI

**Simple SaaS Wrapper for Multi-Tenant AI Calling**

*Created: November 11, 2025*

---

## 🎯 THE GOAL:

Let customers run their own AI dialer campaigns WITHOUT accessing your Vici instance.

**Simple architecture:**
- User-friendly UI (customers only see this)
- Your platform API (orchestration layer)
- Ultravox (AI voice handling)
- Your Vici (dialing engine)

**Purpose:** SaaS model where you control infrastructure, customers just use it.

---

## 📐 ARCHITECTURE (Based on Your Diagram):

```
┌─────────────────────────────────────────────┐
│   USER-FACING DASHBOARD (Web App)          │
│   ┌──────────────────────────────────┐    │
│   │ • Configure AI                   │    │
│   │ • Upload Data                    │    │
│   │ • Initiate Calls                 │    │
│   │ • View Analytics                 │    │
│   │ • Database (customer data)       │    │
│   └──────────────────────────────────┘    │
└─────────────────────────────────────────────┘
                    ↓ (REST API)
┌─────────────────────────────────────────────┐
│   YOUR PLATFORM API (Node.js/Python)       │
│   • Authentication                          │
│   • Lead management                         │
│   • Campaign orchestration                  │
│   • Call routing logic                      │
│   • Analytics aggregation                   │
└─────────────────────────────────────────────┘
        ↓                           ↓
┌──────────────────┐      ┌──────────────────┐
│  ULTRAVOX        │      │   YOUR VICI      │
│  (AI Voice)      │←────→│   (Dialing)      │
│  • SIP server    │      │   • Campaign mgmt│
│  • AI responses  │      │   • Lead dialing │
│  • Voice cloning │      │   • Call routing │
│  • Transcription │      │   • Call logs    │
└──────────────────┘      └──────────────────┘
```

---

## 🛠️ WHAT YOU BUILD (MVP):

### 1. **USER DASHBOARD** (Frontend)
**Tech stack:** Next.js/React + TailwindCSS

**Pages:**
- `/login` - Authentication
- `/dashboard` - Overview stats
- `/agents` - Configure AI agents
- `/campaigns` - Create/manage campaigns
- `/leads` - Upload/view lead lists
- `/analytics` - Call results & metrics

**Key features:**
- Upload CSV (leads)
- Configure AI personality/script
- Start/stop campaigns
- Real-time call monitoring
- Analytics dashboards

**Time to build:** 2-3 weeks
**Cost:** $5-8K (contractor) or DIY with Claude

---

### 2. **PLATFORM API** (Backend)
**Tech stack:** Node.js (Express) or Python (FastAPI)

**Core endpoints:**

```javascript
// Authentication
POST /api/auth/register
POST /api/auth/login

// Lead management
POST /api/leads/upload        // CSV upload
GET  /api/leads/:campaign_id  // List leads
PUT  /api/leads/:id           // Update lead status

// Campaign management
POST /api/campaigns/create
POST /api/campaigns/:id/start
POST /api/campaigns/:id/stop
GET  /api/campaigns/:id/stats

// AI Agent configuration
POST /api/agents/create       // Configure Ultravox agent
PUT  /api/agents/:id          // Update agent settings
GET  /api/agents/:id/test     // Test call

// Call handling (webhooks from Ultravox/Vici)
POST /api/webhooks/ultravox   // Call events from Ultravox
POST /api/webhooks/vici       // Call events from Vici

// Analytics
GET  /api/analytics/campaign/:id
GET  /api/analytics/daily
```

**Key logic:**
- Multi-tenant (isolate customer data)
- Queue management (when to dial next lead)
- Call routing (Vici → Ultravox → back to customer)
- Status tracking (lead lifecycle)
- Analytics aggregation

**Time to build:** 3-4 weeks
**Cost:** $8-12K (contractor) or DIY with Claude

---

### 3. **DATABASE** (Customer Data)
**Tech stack:** PostgreSQL

**Tables:**

```sql
-- Customer accounts (multi-tenant)
users (id, email, company_name, api_key, created_at)
subscriptions (user_id, plan, status, billing_info)

-- Lead management
campaigns (id, user_id, name, status, ultravox_agent_id, vici_campaign_id)
leads (id, campaign_id, phone, name, status, metadata, created_at)
call_logs (id, lead_id, duration, outcome, recording_url, transcript)

-- AI agent configs
agents (id, user_id, name, ultravox_config, voice_id, prompt)

-- Analytics (aggregated)
campaign_stats (campaign_id, date, calls_made, connects, conversions)
```

**Time to build:** 1 week (schema + migrations)
**Cost:** $2-3K or DIY

---

### 4. **ULTRAVOX INTEGRATION**
**What it does:** Handles the AI voice conversation

**Integration points:**

```javascript
// Create Ultravox agent for customer
const createAgent = async (userId, config) => {
  const response = await ultravox.agents.create({
    name: config.agentName,
    voice: config.voiceId,         // ElevenLabs voice ID
    systemPrompt: config.prompt,   // AI personality
    model: "claude-3-5-sonnet",    // LLM model
    webhookUrl: `${API_URL}/webhooks/ultravox`
  });

  return response.agentId;
};

// Route call to Ultravox (SIP)
const routeCallToAI = async (callId, leadPhone) => {
  // When Vici connects, transfer to Ultravox SIP
  await ultravox.calls.create({
    agentId: agentId,
    phoneNumber: leadPhone,
    metadata: { campaign_id, lead_id }
  });
};

// Handle call events
app.post('/webhooks/ultravox', async (req, res) => {
  const { event, callId, transcript, outcome } = req.body;

  switch(event) {
    case 'call_started':
      // Update lead status
      break;
    case 'call_ended':
      // Log result, move to next lead
      break;
    case 'transfer_requested':
      // Human handoff logic
      break;
  }
});
```

**Time to build:** 1-2 weeks
**Cost:** $3-5K or DIY

---

### 5. **VICI INTEGRATION**
**What it does:** Your existing Vici handles actual dialing

**Integration approach:**

```python
# Use Vici API to manage campaigns programmatically
import requests

VICI_API = "https://your-vici-server.com/agc/api.php"
VICI_USER = "api_user"
VICI_PASS = "api_password"

def create_vici_campaign(customer_id, campaign_name):
    """Create isolated Vici campaign for customer"""
    response = requests.post(VICI_API, data={
        'user': VICI_USER,
        'pass': VICI_PASS,
        'function': 'add_list',
        'list_id': f"CUST_{customer_id}_{campaign_name}",
        'list_name': campaign_name,
        'campaign_id': f"CAMP_{customer_id}"
    })
    return response.json()

def upload_leads_to_vici(campaign_id, leads):
    """Upload customer leads to Vici"""
    for lead in leads:
        requests.post(VICI_API, data={
            'user': VICI_USER,
            'pass': VICI_PASS,
            'function': 'add_lead',
            'phone_number': lead['phone'],
            'first_name': lead['name'],
            'list_id': campaign_id,
            # Route to Ultravox on answer
            'custom_field_1': ultravox_sip_uri
        })

def start_dialing(campaign_id):
    """Start Vici auto-dialer"""
    requests.post(VICI_API, data={
        'user': VICI_USER,
        'pass': VICI_PASS,
        'function': 'campaign_start',
        'campaign_id': campaign_id
    })
```

**Call flow:**
1. Customer clicks "Start Campaign" in your UI
2. Your API uploads leads to Vici
3. Vici starts dialing
4. On answer, Vici transfers to Ultravox SIP
5. Ultravox handles AI conversation
6. Call ends, Vici logs result
7. Your API fetches results, shows in dashboard

**Time to build:** 2 weeks
**Cost:** $4-6K or DIY

---

## 💰 TOTAL COST BREAKDOWN:

### OPTION 1: HIRE CONTRACTORS
| Component | Time | Cost |
|-----------|------|------|
| Frontend Dashboard | 2-3 weeks | $5-8K |
| Backend API | 3-4 weeks | $8-12K |
| Database Setup | 1 week | $2-3K |
| Ultravox Integration | 1-2 weeks | $3-5K |
| Vici Integration | 2 weeks | $4-6K |
| Testing & Polish | 1 week | $2-3K |
| **TOTAL** | **10-13 weeks** | **$24-37K** |

### OPTION 2: CLAUDE DOES 90% (YOU MANAGE)
| Component | Time | Your Effort |
|-----------|------|-------------|
| Frontend (Next.js template) | 1 week | 10 hours (guidance) |
| Backend API | 1.5 weeks | 15 hours (review/test) |
| Database | 3 days | 5 hours (schema review) |
| Ultravox Integration | 1 week | 8 hours (API key setup) |
| Vici Integration | 1 week | 10 hours (test calls) |
| Testing & Deployment | 1 week | 20 hours (QA) |
| **TOTAL** | **6-7 weeks** | **68 hours + $5K hosting/tools** |

### OPTION 3: YOU CODE IT (WITH CLAUDE)
- **Timeline:** 3-4 months part-time
- **Cost:** ~$2-5K (hosting, APIs, tools)
- **Your time:** 200+ hours
- **Feasibility:** Doable if you have coding experience

---

## ⚡ FASTEST PATH (RECOMMENDED):

### PHASE 1: MVP (4 WEEKS, $15K)
**Goal:** Working prototype, 1 test customer

**Must-haves:**
- Simple dashboard (upload CSV, start campaign)
- Basic API (lead upload, campaign start/stop)
- Ultravox integration (AI calls work)
- Vici integration (dialing works)
- PostgreSQL database

**Skip for MVP:**
- Advanced analytics (just basic counts)
- Multi-agent support (one agent per customer)
- White-label customization
- Payment processing (manual invoicing)

**Team:**
- 1 Full-stack developer (contractor)
- You (product management, testing)
- Claude (code generation, debugging)

**Budget:**
- Developer: $10K (4 weeks @ $2.5K/week)
- Infrastructure: $2K (AWS, Ultravox, etc.)
- Buffer: $3K
- **Total: $15K**

---

### PHASE 2: BETA (4 WEEKS, $10K)
**Goal:** 5-10 paying beta customers

**Add:**
- Analytics dashboard
- Multi-agent support
- User management
- Stripe integration (billing)
- Better UI/UX

**Team:**
- Same developer (2-3 weeks)
- Designer (1 week for UI polish)

**Budget:** $10K

---

### PHASE 3: PRODUCTION (4 WEEKS, $10K)
**Goal:** Scale-ready platform

**Add:**
- White-label options
- Advanced analytics
- Call monitoring dashboard
- Performance optimization
- Documentation

**Budget:** $10K

**TOTAL TIMELINE: 12 weeks (3 months)**
**TOTAL COST: $35K**

---

## 🎯 WHAT YOU NEED TO DO:

### WEEK 1: SETUP
- [ ] Set up AWS/GCP account
- [ ] Get Ultravox API access (sign up at ultravox.ai)
- [ ] Document your Vici API endpoints/credentials
- [ ] Choose tech stack (recommend: Next.js + Node.js + Postgres)
- [ ] Set up GitHub repo
- [ ] Hire developer OR decide to DIY with Claude

### WEEK 2-3: DATABASE & API
- [ ] Design database schema with Claude
- [ ] Set up PostgreSQL
- [ ] Build core API endpoints
- [ ] Test authentication & multi-tenancy

### WEEK 4-5: ULTRAVOX INTEGRATION
- [ ] Set up Ultravox account & SIP
- [ ] Create test AI agent
- [ ] Build agent creation API
- [ ] Test AI calls (manually dial first)

### WEEK 6-7: VICI INTEGRATION
- [ ] Document Vici API calls needed
- [ ] Build lead upload to Vici
- [ ] Build campaign start/stop
- [ ] Test full flow: Lead → Vici → Ultravox → Result

### WEEK 8-9: FRONTEND DASHBOARD
- [ ] Build React dashboard
- [ ] Connect to API
- [ ] Test user flows
- [ ] Polish UI

### WEEK 10-11: TESTING
- [ ] End-to-end testing
- [ ] Load testing (can it handle 1000 calls?)
- [ ] Fix bugs
- [ ] Security audit

### WEEK 12: LAUNCH
- [ ] Deploy to production
- [ ] Onboard first customer (your solar business!)
- [ ] Monitor & iterate

---

## 🚨 POTENTIAL ISSUES & SOLUTIONS:

### ISSUE 1: Ultravox → Vici SIP Routing
**Problem:** How to route calls between Ultravox and Vici?

**Solution A (Simpler):**
- Vici dials → connects → transfers to Ultravox SIP
- Use Vici's dial plan to route to Ultravox
- Ultravox handles entire conversation

**Solution B (More control):**
- Your API triggers Ultravox to make outbound call
- Ultravox reports results back to API
- Vici used just for lead management
- **This is cleaner for white-label**

**Recommended: Solution B**

---

### ISSUE 2: Call Recording & Compliance
**Problem:** Need to record calls, handle consent

**Solution:**
- Ultravox handles recording automatically
- Store in S3 (Ultravox can send recordings)
- Your API fetches & displays in dashboard
- Add consent language to AI script ("This call may be recorded...")

---

### ISSUE 3: Multi-Tenancy (Data Isolation)
**Problem:** Keep customer A's data separate from customer B

**Solution:**
```javascript
// Every API call requires authentication
const userId = authenticateRequest(req);

// All queries scoped to user
const campaigns = await db.campaigns.find({ user_id: userId });

// Vici campaigns namespaced
const viciCampaignId = `CUST_${userId}_${campaignName}`;
```

---

### ISSUE 4: Scaling (1000+ simultaneous calls)
**Problem:** Can your infrastructure handle high volume?

**Solution:**
- Ultravox scales automatically (SaaS)
- Your Vici needs capacity (add more servers if needed)
- Your API needs to be stateless (use Redis for queues)
- Database needs optimization (indexes, read replicas)

**For MVP:** Don't worry, test with <100 concurrent calls first

---

## 💡 BETTER ALTERNATIVES TO CONSIDER:

### ALTERNATIVE 1: Skip Vici Entirely
**Why:** Vici adds complexity. Ultravox can dial directly.

**Architecture:**
```
User Dashboard → Your API → Ultravox (SIP) → Twilio (phone numbers)
```

**Pros:**
- Much simpler (cut out Vici integration)
- Fewer moving parts
- Easier to debug
- Ultravox handles everything

**Cons:**
- Less control over dialing logic
- Harder to implement advanced features (predictive dialing)
- Your current Vici investment unused

**When to choose:** If you want fastest time to market

---

### ALTERNATIVE 2: Vici Multi-Tenant Mode
**Why:** Use Vici's built-in multi-tenant features

**Architecture:**
```
User Dashboard → Your API → Vici (multi-tenant) → Asterisk + Ultravox
```

**Pros:**
- Leverage existing Vici
- Vici has robust dialing features
- Proven at scale

**Cons:**
- Still need custom UI (Vici UI is ugly)
- Need to deeply understand Vici
- Updates might break customizations

**When to choose:** If you want to leverage your Vici expertise

---

### ALTERNATIVE 3: Build Dialer from Scratch
**Why:** Full control, modern architecture

**Architecture:**
```
Your Dashboard → Your API → Your Dialer (Twilio API) → Ultravox
```

**Pros:**
- Complete control
- Modern tech stack
- Easier to maintain
- No legacy code

**Cons:**
- More work upfront
- Need to build dialer logic (predictive dialing is complex)
- Reinventing the wheel

**When to choose:** If you're building for long-term (SaaS platform)

---

## 🏆 MY RECOMMENDATION:

### GO WITH: Alternative 1 (Skip Vici for MVP)

**Reasoning:**
1. **Fastest time to market** (6-8 weeks vs 12)
2. **Simpler architecture** (fewer integration points)
3. **Lower cost** ($15K vs $35K)
4. **Easier to maintain** (no Vici complexity)
5. **Ultravox can handle dialing** (built-in dialer)

**You can always add Vici later** if you need advanced features.

**MVP Architecture:**
```
┌─────────────────────────────┐
│  User Dashboard (Next.js)   │
│  • Upload leads             │
│  • Configure AI             │
│  • View results             │
└─────────────────────────────┘
         ↓ (REST API)
┌─────────────────────────────┐
│  Platform API (Node.js)     │
│  • Lead management          │
│  • Campaign orchestration   │
│  • Analytics                │
└─────────────────────────────┘
         ↓
┌─────────────────────────────┐
│  Ultravox API               │
│  • AI voice + dialing       │
│  • Call handling            │
│  • Transcripts              │
└─────────────────────────────┘
```

**This gets you to market in 6-8 weeks at $15K.**

---

## 📊 PRICING FOR CUSTOMERS:

Once built, you can charge:

**STARTER** - $299/month
- 1 AI agent
- 1,000 AI call minutes/month
- 5,000 leads
- Basic analytics

**PRO** - $999/month
- 5 AI agents
- 5,000 minutes/month
- Unlimited leads
- Advanced analytics
- CRM integrations

**ENTERPRISE** - $4,999/month
- Unlimited agents
- 25,000 minutes/month
- White-label
- API access
- Priority support

**YOUR COSTS:**
- Ultravox: ~$0.05-0.10/minute
- Infrastructure: ~$200/month (AWS/GCP)
- **Margins: 70-80%**

---

## 🚀 BOTTOM LINE:

### IF YOU HIRE A CONTRACTOR:
- **Timeline:** 12 weeks (full implementation) or 6 weeks (simplified)
- **Cost:** $35K (with Vici) or $15K (Ultravox only)
- **Your effort:** 50-100 hours (management, testing)

### IF CLAUDE BUILDS IT (YOU MANAGE):
- **Timeline:** 8-10 weeks
- **Cost:** $5K (hosting/tools)
- **Your effort:** 150-200 hours (heavy involvement)

### IF YOU BUILD IT (CLAUDE HELPS):
- **Timeline:** 4-6 months part-time
- **Cost:** $2-5K
- **Your effort:** 300+ hours

---

## 🎯 HOW QUICKLY CAN WE DO THIS?

**ABSOLUTE FASTEST (Bare bones MVP):**
- 4 weeks with contractor ($15K)
- 6 weeks with Claude building ($5K + your time)

**REALISTIC (Production-ready):**
- 12 weeks with contractor ($35K)
- 16 weeks with Claude/you ($10K + your time)

**GOLD STANDARD (Everything polished):**
- 6 months ($75K+ with team)

---

## 💪 MY ASSESSMENT:

**Can Claude build this?** YES, absolutely.

**Complexity level:** Medium (not trivial, but very doable)

**Biggest challenges:**
1. SIP/telephony routing (but Ultravox abstracts this)
2. Real-time call handling (webhooks, state management)
3. Multi-tenant data isolation (critical for security)

**Easiest parts:**
1. Dashboard UI (standard React patterns)
2. API endpoints (CRUD operations)
3. Database schema (straightforward)

**Confidence level:** 8/10 that Claude could build a working MVP in 6-8 weeks with proper guidance.

---

## 🎬 IMMEDIATE NEXT STEPS:

1. **Decide on approach:**
   - Simplified (Ultravox only): 6 weeks, $15K
   - Full integration (Ultravox + Vici): 12 weeks, $35K

2. **Get Ultravox access:**
   - Sign up at https://ultravox.ai
   - Get API credentials
   - Test their examples

3. **Sketch database schema:**
   - I can help you design this with Claude right now

4. **Choose tech stack:**
   - Frontend: Next.js (recommended) or Vue/React
   - Backend: Node.js (recommended) or Python
   - Database: PostgreSQL (recommended)

5. **Decide: hire or DIY?**
   - Hire contractor: Post on Upwork/Toptal
   - DIY with Claude: We can start building next week

---

## 📝 FINAL THOUGHTS:

This is **highly achievable**. The architecture is straightforward.

**Key insight:** Don't overcomplicate it. Start simple:
1. Dashboard to upload leads
2. API to manage campaigns
3. Ultravox to handle AI calls
4. Basic analytics

You can add Vici integration later if needed.

**This can be live in 6-8 weeks for $15K.**

Once live, you can charge $299-999/month per customer.

**10 customers = $5-10K MRR** (3-7 month payback period)

**100 customers = $50-100K MRR** (profitable SaaS business)

---

**Want me to start building the database schema right now?** Or map out the exact API endpoints?

Let me know what you want to tackle first! 🚀
