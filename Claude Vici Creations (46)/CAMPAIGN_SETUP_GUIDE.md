# 📞 VICIDIAL CAMPAIGN SETUP GUIDE - Complete Step-by-Step

**For beginners:** How to clone and set up a campaign exactly like the existing ones

---

## 📋 TABLE OF CONTENTS

1. [Understanding the Current Setup](#understanding-the-current-setup)
2. [Step 1: Clone an Existing Campaign](#step-1-clone-an-existing-campaign)
3. [Step 2: Configure Campaign Settings](#step-2-configure-campaign-settings)
4. [Step 3: Load Leads](#step-3-load-leads)
5. [Step 4: Set Up Transfer/Closer Campaign](#step-4-set-up-transfercloser-campaign)
6. [Step 5: Configure Opt-In Routing (SVYCLM)](#step-5-configure-opt-in-routing-svyclm)
7. [Step 6: Set Up Call Rerouting](#step-6-set-up-call-rerouting)
8. [Step 7: Remote Agents with Personal Phones](#step-7-remote-agents-with-personal-phones)
9. [Step 8: Activate and Test](#step-8-activate-and-test)
10. [Step 9: Integration with External Systems](#step-9-integration-with-external-systems)
11. [Troubleshooting](#troubleshooting)

---

## 🎯 UNDERSTANDING THE CURRENT SETUP

### Existing Campaigns:
| Campaign ID | Name | State | Dial Method | Auto Dial Level | Status |
|-------------|------|-------|-------------|-----------------|--------|
| 1022 | St Louis Inbound | MO | RATIO | 190 | Active |
| 1027 | Georgia Inbound | GA | RATIO | 180 | Active |
| 1028 | Illinois Inbound | IL | RATIO | 200 | Active |
| 1025 | Ohio Inbound | OH | RATIO | 250 | Inactive |

### How It Works:
1. **Outbound Campaign** (1022, 1027, etc.) → Dials leads automatically
2. **When opt-in (SVYCLM status)** → Call transfers to closer campaign
3. **Closer Campaign** (StLouisXfer, GeorgiaXfer) → Agent handles the sale
4. **Sales recorded** → vicidial_closer_log table

---

## 📝 STEP 1: CLONE AN EXISTING CAMPAIGN

### Access Vicidial Admin:
1. Open browser: `http://67.198.205.116/vicidial/admin.php`
2. Login with admin credentials
3. Navigate: **Admin** → **Campaigns**

### Clone the Campaign:
1. Find the campaign you want to clone (e.g., **1022 - St Louis Inbound**)
2. Click **COPY** button next to the campaign
3. Enter new campaign details:
   ```
   Campaign ID: 1029  (must be unique, next available number)
   Campaign Name: Texas Inbound
   Campaign Description: Texas outbound dialer campaign
   ```
4. Click **SUBMIT**

**✅ You now have a cloned campaign!**

---

## ⚙️ STEP 2: CONFIGURE CAMPAIGN SETTINGS

### Edit Your New Campaign:
**Link:** Admin → Campaigns → Click on **1029**

### Key Settings to Configure:

#### A. BASIC SETTINGS
```
Active: Y (Yes)
Campaign Name: Texas Inbound
Description: Texas outbound dialer
```

#### B. DIALING SETTINGS
```
Dial Method: RATIO
   - This adjusts dialing based on agent availability
   - Prevents too many abandoned calls

Auto Dial Level: 190
   - How aggressively to dial
   - Higher = more calls, but more drops
   - Start with 190 (same as MO)

Dial Timeout: 40
   - How long to ring before giving up (seconds)
   - 40 seconds is standard

Lead Order: DOWN COUNT
   - Dials leads with lowest attempt count first
   - Ensures fresh leads get priority
```

#### C. HOPPER SETTINGS
```
Hopper Level: 4000
   - Number of leads queued in memory
   - 4000 is optimal for performance

Auto Hopper: Y
   - Automatically loads leads into hopper
```

#### D. RECORDING SETTINGS
```
Recording: ALLFORCE
   - Records all calls
   - Required for compliance

Recording Override: DISABLED
   - Agents cannot disable recording
```

#### E. STATUSES & DISPOSITION
Keep existing statuses from cloned campaign:
- **SVYCLM** = Survey sent to Call (OPT-IN) ← IMPORTANT
- **SALE** = Sale made
- **NP** = No answer
- **A** = Answering machine
- **DC** = Disconnected
- etc.

Click **SUBMIT** to save!

---

## 📥 STEP 3: LOAD LEADS

### Prepare Your Lead List:

#### Required Format (CSV):
```csv
phone_number,first_name,last_name,state,vendor_lead_code,source_id,list_id,gmt_offset_now,called_since_last_reset,phone_code,title,address1,address2,address3,city,province,postal_code,country_code,gender,date_of_birth,alt_phone,email,security_phrase,comments
2145551234,John,Doe,TX,LEAD001,SOURCE1,999,0,N,1,Mr,123 Main St,,,Dallas,TX,75201,USA,M,1980-01-01,,,PASS123,Test lead
```

**Minimum Required Fields:**
- `phone_number` (10 digits, no formatting)
- `first_name`
- `last_name`
- `state` (2-letter abbreviation)
- `vendor_lead_code` (unique ID)
- `list_id` (which list this belongs to)

### Upload Leads:

#### OPTION 1: Web Upload (Small batches)
1. Admin → **Lists**
2. Click **ADD NEW LIST**
3. Fill in:
   ```
   List ID: 999 (unique number)
   List Name: Texas Test Leads
   Campaign: 1029 (your new campaign)
   Active: Y
   ```
4. Click **SUBMIT**
5. Go to: Admin → **Lead Loader**
6. Select:
   ```
   Campaign: 1029
   List: 999
   File: [Upload your CSV]
   Duplicate Check: DUPLIST (checks within same list)
   ```
7. Click **SUBMIT**

#### OPTION 2: Command Line (Large batches)
```bash
# SSH to server
ssh user@67.198.205.116

# Upload via FTP first, then:
cd /usr/share/astguiclient

# Load leads
./AST_lead_loader.pl \
  --file=/tmp/texas_leads.csv \
  --campaign-id=1029 \
  --list-id=999 \
  --phone-code=1 \
  --duplicate-check=DUPLIST
```

**✅ Leads are now loaded!**

---

## 🔄 STEP 4: SET UP TRANSFER/CLOSER CAMPAIGN

### Create the Closer Campaign:

1. Admin → **Campaigns** → **ADD NEW CAMPAIGN**
2. Fill in:
   ```
   Campaign ID: TexasXfer
   Campaign Name: Texas Transfer Campaign
   Campaign Type: INBOUND (not outbound!)
   Active: Y
   ```

3. **Key Settings:**
   ```
   Dial Method: INBOUND_MAN
   Recording: ALLFORCE
   Auto Alt Dial: NONE
   Agent Script: (select your script)
   ```

4. **Inbound Group Settings:**
   - Click **Modify** next to campaign
   - Go to **INBOUND GROUPS** section
   - Create new inbound group:
     ```
     Group ID: TexasXfer
     Group Name: Texas Transfer Queue
     Active: Y
     ```

5. Click **SUBMIT**

### Link Outbound to Closer:

1. Go back to your outbound campaign (**1029**)
2. Find section: **CLOSER CAMPAIGNS**
3. Add: `TexasXfer`
4. Set transfer method:
   ```
   Transfer-Conf Group: TexasXfer
   ```

**✅ Transfer campaign ready!**

---

## 📞 STEP 5: CONFIGURE OPT-IN ROUTING (SVYCLM)

### How Opt-Ins Work:
When a call gets **SVYCLM** status (Survey sent to Call), the system should:
1. Route call to phone number for opt-in processing
2. If no answer → reroute or voicemail

### Set Up DID for Opt-Ins:

1. Admin → **Inbound Groups** → Click **TexasXfer**

2. **Call Menu Settings:**
   ```
   Handle Method: CID
   Drop Call Seconds: 360 (how long to ring)
   Drop Action: MESSAGE (play message if no answer)
   ```

3. **Add Phone Number (DID):**
   - Admin → **DIDs/Inbound**
   - Click **ADD NEW DID**
   ```
   DID Number: 8001234567 (your opt-in phone number)
   DID Description: Texas Opt-In Line
   Campaign: TexasXfer
   Group: TexasXfer
   Extension: 8368 (or your agent extension)
   ```

4. **Route to External Number (if needed):**
   - In DID settings:
   ```
   Route: AGENT
   Extension: 83EXTEN8368EXTEN8005551234
   ```
   This routes to extension 8368, then transfers to 800-555-1234 if needed

**✅ Opt-ins now route correctly!**

---

## 🔁 STEP 6: SET UP CALL REROUTING

### If Opt-In Number Doesn't Answer:

#### OPTION 1: Voicemail
```
Drop Action: VOICEMAIL
Voicemail Box: 8500
```

#### OPTION 2: Reroute to Backup Number
1. Set up **Call Menu**:
   - Admin → **Call Menus**
   - Add new menu: `TexasOptInMenu`

2. **Menu Options:**
   ```
   Option 0: Call someone if they press 0
   Timeout Route: Route to backup number after X seconds
   Invalid Route: What to do with invalid input
   ```

3. **Link to Inbound Group:**
   - Back to TexasXfer inbound group
   - Call Menu: `TexasOptInMenu`

#### OPTION 3: Round-Robin to Multiple Numbers
```
1. Create Inbound Group with multiple DIDs
2. Set Call Time: 20 seconds each
3. If no answer, moves to next number
```

**Example Flow:**
```
Call comes in → Rings 8001234567 (20 sec)
  ↓ No answer
Rings 8009876543 (20 sec)
  ↓ No answer
Leaves voicemail OR hangs up
```

**✅ Failover configured!**

---

## 📱 STEP 7: REMOTE AGENTS WITH PERSONAL PHONES

**Confirmed by Vicidial developer:** Remote agents can answer calls on their personal cell phones with automatic failover to next agent!

### How Remote Agents Work:

Instead of agents sitting at computers, they can:
- Use their personal cell phones
- Work from anywhere
- Receive calls directly
- Have calls automatically route to next agent if they don't answer

---

### Setting Up Remote Agents - Step by Step:

#### STEP 7.1: Create Remote Agent Users

1. **Navigate to:** Admin → Users

2. **Add New User:**
   ```
   User: REMOTE001
   Full Name: John Smith (Remote)
   User Level: 1 (or appropriate level)
   Phone Login: 8367 (unique extension)
   Phone Pass: 1234 (SIP password)
   ```

3. **Remote Agent Settings:**
   ```
   Active: Y
   User Group: AGENTS
   Closer Campaigns: TexasXfer (your closer campaign)

   IMPORTANT - Remote Agent Settings:
   ☑ Phone Ring Timeout: 20
      (How long to ring before moving to next agent)

   ☑ User Choose Language: DISABLED
   ☑ Alter Phone Login: DISABLED
   ```

4. **Set Personal Phone Number:**
   ```
   Outbound Caller ID Number: 2145551234
   (Their personal cell phone)
   ```

5. Click **SUBMIT**

6. **Repeat for each remote agent:**
   ```
   REMOTE001 - John Smith - 214-555-1234
   REMOTE002 - Jane Doe - 214-555-5678
   REMOTE003 - Bob Jones - 214-555-9012
   ```

---

#### STEP 7.2: Configure Phone Extensions for Remote Routing

1. **Navigate to:** Admin → Phones

2. **Add Phone for Remote Agent:**
   ```
   Extension: 8367 (matches agent's Phone Login)
   Dialplan Number: 8367
   Voicemail ID: 8367

   Server IP: 67.198.205.116
   Protocol: SIP

   Phone Type: REMOTE
   ```

3. **Outbound Call Settings:**
   ```
   Outbound Caller ID: 2145551234
   (Agent's personal cell)

   Dial Prefix:
   (Leave blank for direct routing)

   Outbound Call Method: EXTERNAL
   ```

4. **Key Settings for Remote:**
   ```
   Template ID: (leave default)
   On Hook Agent: DISABLED

   Ring Timeout: 20 seconds
   (Matches user setting)
   ```

5. Click **SUBMIT**

---

#### STEP 7.3: Set Up Round-Robin Call Routing

**This makes calls automatically go to next agent if first doesn't answer**

1. **Navigate to:** Admin → Inbound Groups → **TexasXfer**

2. **Agent Ring Settings:**
   ```
   Agent Ring Method: RANDOM
      (or LONGEST_WAIT for fairness)

   Call Time: 20
      (Ring each agent 20 seconds)

   No Answer Action: NEXT_AGENT
      (Move to next agent if no answer)
   ```

3. **Advanced Routing:**
   ```
   Max Queue Calls: 50

   Queue Priority: 50

   Drop Call Seconds: 120
      (Total time before giving up - 6 agents × 20 sec)

   Drop Action: VOICEMAIL
      (If all agents miss it)
   ```

4. **Add All Remote Agents to Group:**
   ```
   Click "Group Agents" tab

   Add:
   ☑ REMOTE001
   ☑ REMOTE002
   ☑ REMOTE003
   ```

5. Click **SUBMIT**

---

#### STEP 7.4: Configure Automatic Failover Chain

**Set up the exact order calls should route:**

##### METHOD 1: Priority-Based (Best for VIPs)

1. **Set Agent Priorities:**
   - Admin → Users → REMOTE001
   ```
   Agent Rank: 1 (highest priority)
   ```

   - Admin → Users → REMOTE002
   ```
   Agent Rank: 2
   ```

   - Admin → Users → REMOTE003
   ```
   Agent Rank: 3 (backup)
   ```

2. **Inbound Group Setting:**
   ```
   Agent Ring Method: HIGHEST_PRIORITY
   ```

**Call Flow:**
```
Incoming Call
  ↓
Rings REMOTE001 (20 sec) - No answer
  ↓
Rings REMOTE002 (20 sec) - No answer
  ↓
Rings REMOTE003 (20 sec) - No answer
  ↓
Voicemail or hang up
```

---

##### METHOD 2: Round-Robin (Fair Distribution)

1. **Inbound Group Setting:**
   ```
   Agent Ring Method: ROUND_ROBIN
   ```

**Call Flow:**
```
Call 1 → REMOTE001
Call 2 → REMOTE002
Call 3 → REMOTE003
Call 4 → REMOTE001 (starts over)
```

If agent doesn't answer within 20 seconds:
```
Call 1 to REMOTE001 (no answer)
  ↓
Automatically routes to REMOTE002
  ↓ (if no answer)
Routes to REMOTE003
  ↓ (if no answer)
Voicemail
```

---

##### METHOD 3: Skills-Based Routing

1. **Create User Groups:**
   - Admin → User Groups
   ```
   Group: TEXAS_EXPERTS
   Agents: REMOTE001, REMOTE002

   Group: GENERAL_SALES
   Agents: REMOTE003, REMOTE004
   ```

2. **Campaign Assignment:**
   ```
   Texas Campaign → TEXAS_EXPERTS (tries first)
   If no answer → GENERAL_SALES (backup)
   ```

---

#### STEP 7.5: Test Remote Agent Setup

##### Test Call Flow:

1. **Login Remote Agent:**
   ```
   Agent calls: 67.198.205.116 (Vicidial server)
   Or uses web softphone

   Enter:
   Phone: 8367
   Password: 1234
   ```

2. **Agent Status:**
   ```
   Set to: READY
   (Available to receive calls)
   ```

3. **Make Test Call:**
   ```
   Dial into opt-in DID: 800-123-4567
   Should ring REMOTE001's cell: 214-555-1234
   ```

4. **Test Failover:**
   ```
   Don't answer REMOTE001
   After 20 seconds →
   Should ring REMOTE002: 214-555-5678
   ```

5. **Verify Recording:**
   ```
   Check: Admin → Recordings
   Recording should capture entire call including transfers
   ```

---

#### STEP 7.6: Advanced Remote Agent Features

##### A. Callback from Remote Phone

**Agent missed call and wants to call back:**

1. **Set up Callback:**
   - Campaign Settings
   ```
   Allow Manual Dial: ENABLED
   Manual Dial Method: QUEUE
   ```

2. **Agent Action:**
   ```
   1. Agent logs into Vicidial web panel
   2. Clicks lead in queue
   3. Clicks "Dial"
   4. System calls agent's cell
   5. Agent answers
   6. System connects to customer
   ```

---

##### B. Call Recording with Remote Agents

**Ensure all calls are recorded even on personal phones:**

1. **Campaign Recording Settings:**
   ```
   Recording: ALLFORCE
   Recording Override: DISABLED

   Recording Delay: 0
   (Start recording immediately)
   ```

2. **Verify:**
   ```
   All calls recorded at server level
   NOT on agent's cell phone
   Agent cannot disable
   ```

---

##### C. Caller ID Masking

**Show company number instead of agent's personal number:**

1. **Outbound Caller ID:**
   ```
   Campaign → Outbound Caller ID: 8001234567

   All outbound calls show: 800-123-4567
   Customer never sees: 214-555-1234 (agent's cell)
   ```

2. **Per-Agent Override:**
   ```
   User Settings → Outbound Caller ID: 8009876543
   (Different number for specific agent)
   ```

---

##### D. Multi-Number Routing (Agent Has Multiple Phones)

**Ring agent's desk phone AND cell phone:**

1. **Create Phone Group:**
   ```
   Admin → Phones → Add New

   Extension: 8367
   Phone Type: GROUP

   Ring Strategy: SIMULTANEOUS
   ```

2. **Add Numbers to Group:**
   ```
   Number 1: 214-555-1234 (cell)
   Number 2: 972-555-6789 (desk)
   Number 3: 817-555-3456 (home office)
   ```

3. **Result:**
   ```
   Incoming call rings ALL three phones at once
   First to answer wins
   ```

---

##### E. Geographic Routing

**Route Texas calls to Texas agents, Georgia calls to Georgia agents:**

1. **Identify Call Source:**
   ```
   Campaign → DID → Caller ID
   Area Code 214 → Texas
   Area Code 404 → Georgia
   ```

2. **Route to Local Agents:**
   ```
   Admin → Call Menus → Area Code Menu

   If area code = 214-*:
      Route to: TexasXfer (Texas agents)

   If area code = 404-*:
      Route to: GeorgiaXfer (Georgia agents)
   ```

---

### Remote Agent Checklist:

Setting up remote agents? Follow this checklist:

- [ ] Create user with unique extension (8367, 8368, etc.)
- [ ] Set personal cell phone as Outbound Caller ID
- [ ] Create phone entry with REMOTE type
- [ ] Set Ring Timeout to 20 seconds
- [ ] Add agent to inbound group
- [ ] Configure Agent Ring Method (ROUND_ROBIN or PRIORITY)
- [ ] Set No Answer Action to NEXT_AGENT
- [ ] Test call routing to agent's cell
- [ ] Test failover to next agent
- [ ] Verify call recording works
- [ ] Set up Caller ID masking (optional)
- [ ] Train agent on web panel login

---

### Real-World Example Setup:

**Scenario:** 3 remote sales reps handling Texas opt-ins

**Agents:**
```
Rep 1: Sarah - Cell: 214-555-0001 - Extension: 8367
Rep 2: Mike  - Cell: 214-555-0002 - Extension: 8368
Rep 3: Lisa  - Cell: 214-555-0003 - Extension: 8369
```

**Configuration:**
```
Inbound Group: TexasXfer
Ring Method: ROUND_ROBIN
Ring Time: 20 seconds per agent
Drop Time: 90 seconds (3 agents × 30 sec)
Failover: Voicemail after all 3 miss
```

**Call Flow:**
```
1. Opt-in call comes in (800-123-4567)
2. System rings Sarah's cell (214-555-0001) - 20 sec
   → No answer
3. System rings Mike's cell (214-555-0002) - 20 sec
   → He answers!
4. Call connected, recording started
5. Mike's caller ID shows: 800-123-4567 (company number)
6. Customer never sees Mike's personal cell
```

**Reporting:**
```
Sarah: 0 calls answered today
Mike: 15 calls answered, 3 sales
Lisa: 12 calls answered, 2 sales

All recorded and tracked in Vicidial!
```

---

### Troubleshooting Remote Agents:

#### Issue: Agent's Cell Not Ringing

**Check:**
1. Extension matches in User and Phone settings?
2. Outbound Caller ID is agent's cell number?
3. Phone Type = REMOTE?
4. Agent is logged in and status = READY?

**Fix:**
```bash
# Check if agent is online
mysql -u cron -p'6sfhf9ogku0q' asterisk -e \
"SELECT user, extension, status, last_call_time \
FROM vicidial_live_agents WHERE user='REMOTE001'"
```

---

#### Issue: Calls Not Failing Over to Next Agent

**Check:**
1. No Answer Action = NEXT_AGENT?
2. Ring Timeout set correctly (20 sec)?
3. Multiple agents in group?

**Fix:**
```
Admin → Inbound Groups → [Your Group]
- Check "No Answer Action"
- Verify "Call Time" per agent
- Ensure Drop Seconds > (agents × ring time)
```

---

#### Issue: Recording Not Working for Remote Calls

**Check:**
1. Campaign Recording = ALLFORCE?
2. Recording happening at server, not agent device?

**Fix:**
```
Recording is server-side, not client-side
Check: Admin → Recordings → Filter by agent
```

---

### Cost Considerations:

**Outbound Call Costs:**
```
System calls agent's cell: $0.01/min (Vicidial to cell)
Agent talks to customer: $0.01/min (standard rate)

Total: $0.02/min

Alternative: Use WiFi calling to eliminate cell charges
```

**Recommended:**
- Give agents company phones with unlimited plans
- OR use softphone app (free calling over WiFi)

---

**✅ Remote agents are now set up with automatic failover!**

---

## ✅ STEP 8: ACTIVATE AND TEST

### Pre-Flight Checklist:

- [ ] Campaign is Active (Y)
- [ ] Leads are loaded (check Admin → Lists)
- [ ] Auto Dial Level is set (190)
- [ ] Hopper Level is set (4000)
- [ ] Closer campaign is created and linked
- [ ] DID routing is configured
- [ ] Agents are logged in

### Test the Campaign:

#### 1. Test Dial:
```
1. Add test lead with your phone number
2. Set campaign to ACTIVE
3. Login an agent
4. Let system dial your test lead
5. Answer and verify recording
```

#### 2. Test Opt-In Transfer:
```
1. When call connects, disposition as SVYCLM
2. Verify call transfers to opt-in number
3. Check if recording continues
4. Verify lead status updates
```

#### 3. Test No-Answer Scenario:
```
1. Disposition as SVYCLM
2. Don't answer opt-in number
3. Verify failover kicks in
4. Check voicemail or backup number
```

### Monitor Live:

**Real-Time Monitor:**
`http://67.198.205.116/vicidial/admin.php?ADD=999999`

Watch:
- Calls dialing
- Agents talking
- Statuses updating
- Hopper levels

**✅ Campaign is LIVE!**

---

## 🔗 STEP 8: INTEGRATION WITH EXTERNAL SYSTEMS

### A. READY MODE INTEGRATION

#### What is Ready Mode?
- Cloud-based sales acceleration platform
- Handles inbound calls & lead distribution

#### Integration Steps:

1. **Get Ready Mode API Credentials:**
   - Login to Ready Mode
   - Settings → API → Generate API Key

2. **Create Webhook in Vicidial:**
   - Admin → Scripts → Edit your script
   - Add field: `--A--ready_mode_webhook--B--`
   - Value: `https://api.readymode.com/v1/calls`

3. **Send Data on Disposition:**
   - Campaign Settings → **URL on Dispo**
   ```
   https://api.readymode.com/v1/calls?
   api_key=YOUR_KEY&
   phone=--A--phone_number--B--&
   status=--A--status--B--&
   campaign=--A--campaign--B--
   ```

4. **Test:**
   - Make test call
   - Disposition
   - Check Ready Mode dashboard for call log

---

### B. GHL (GO HIGH LEVEL) INTEGRATION

#### What is GHL?
- CRM + Marketing automation
- Handles lead nurturing & follow-ups

#### Integration Steps:

1. **Get GHL Webhook URL:**
   - GHL → Settings → Webhooks
   - Create new webhook: "Vicidial Opt-Ins"
   - Copy webhook URL

2. **Configure Vicidial to Send Data:**
   - Campaign Settings → **URL on Dispo**
   ```
   https://services.leadconnectorhq.com/hooks/YOUR_WEBHOOK_ID?
   phone_number=--A--phone_number--B--&
   first_name=--A--first_name--B--&
   last_name=--A--last_name--B--&
   status=--A--status--B--&
   email=--A--email--B--
   ```

3. **Filter for Opt-Ins Only:**
   - Add conditional URL:
   ```
   Only send if: status = SVYCLM
   ```

4. **GHL Automation:**
   - Create workflow triggered by webhook
   - Actions:
     - Add to pipeline
     - Send confirmation SMS
     - Assign to rep
     - Schedule follow-up

---

### C. ZAPIER INTEGRATION (Universal)

#### Connect Vicidial to ANY System:

1. **Set up Webhook in Zapier:**
   - Create new Zap
   - Trigger: Webhooks by Zapier
   - Copy webhook URL

2. **Vicidial URL on Dispo:**
   ```
   https://hooks.zapier.com/hooks/catch/YOUR_HOOK_ID/?
   phone=--A--phone_number--B--&
   name=--A--first_name--B-- --A--last_name--B--&
   status=--A--status--B--&
   campaign=--A--campaign--B--&
   state=--A--state--B--
   ```

3. **Zapier Actions (examples):**
   - Send to Google Sheets
   - Create Salesforce lead
   - Send SMS via Twilio
   - Add to Mailchimp
   - Create Slack notification
   - Post to webhook (Ready Mode, GHL, etc.)

---

### D. REAL-TIME CALL TRANSFER TO EXTERNAL SYSTEMS

#### Transfer Opt-Ins to External Call Center:

**Method 1: SIP Trunk**
```
1. Set up SIP trunk to external system
2. In DID routing, use:
   Transfer Number: sip:transfer@external-system.com
```

**Method 2: PSTN Transfer**
```
1. In closer campaign:
   Transfer-Conf Number: 18005551234

2. On SVYCLM status:
   Auto-transfer to 1-800-555-1234
```

**Method 3: API Call Before Transfer**
```
1. URL on Dispo sends lead data to external API
2. API returns: "ready" or "busy"
3. If ready: transfer call
4. If busy: queue or voicemail
```

---

## 🐛 TROUBLESHOOTING

### Issue: Calls Not Dialing

**Check:**
1. Campaign Active? (Admin → Campaigns)
2. Leads in hopper? (Admin → Hopper)
3. Agents logged in? (Real-Time Monitor)
4. Auto Dial Level > 0?
5. Dial timeout too low?

**Fix:**
```bash
# Force hopper load
/usr/share/astguiclient/AST_VDhopper.pl --debug
```

---

### Issue: Transfers Not Working

**Check:**
1. Closer campaign exists?
2. Closer campaign is ACTIVE?
3. DID is configured?
4. Phone number is valid?

**Fix:**
```
1. Admin → Campaigns → Check "Closer Campaigns" field
2. Verify DID routes to correct inbound group
3. Test transfer manually
```

---

### Issue: No Answer on Opt-In Number

**Check:**
1. DID configured correctly?
2. Failover set up?
3. Drop seconds too low?

**Fix:**
```
1. Increase Drop Call Seconds to 60
2. Add backup number in call menu
3. Test by calling DID directly
```

---

### Issue: External Integration Not Receiving Data

**Check:**
1. Webhook URL correct?
2. URL on Dispo enabled?
3. Correct field names?

**Test:**
```
1. Use RequestBin to capture webhook
2. Make test call
3. Check if webhook fires
4. Verify data format
```

---

## 📊 MONITORING & REPORTS

### Daily Monitoring URLs:

**Real-Time:**
- Agents: `http://67.198.205.116/vicidial/user_stats.php`
- Campaigns: `http://67.198.205.116/vicidial/AST_VDadapt_display.php`
- Hopper: `http://67.198.205.116/vicidial/AST_VDhopper.php`

**Reports:**
- Daily Stats: `Admin → Reports → Campaign Detail`
- Lead Stats: `Admin → Reports → Lead Search`
- Call Recordings: `Admin → Recordings`

### Key Metrics to Watch:

```
Calls/Hour: Should be steady (target: 100-200/hr per campaign)
Opt-In Rate: Track SVYCLM % (target: 0.05-0.10%)
Sales: Track closer_log sales (target varies)
Drop Rate: Should be <3%
Agent Talk Time: Should be 2-5 min average
```

---

## ✅ FINAL CHECKLIST

Before going live with new campaign:

- [ ] Campaign cloned and configured
- [ ] Leads loaded (at least 1000 for testing)
- [ ] Auto dial level set appropriately
- [ ] Closer campaign created and linked
- [ ] DID/opt-in routing configured
- [ ] Failover/rerouting tested
- [ ] External integrations working
- [ ] Agents trained on new campaign
- [ ] Test calls completed successfully
- [ ] Monitoring dashboards bookmarked
- [ ] Backup plan in place

---

## 📚 QUICK REFERENCE

### Important URLs:
```
Admin Panel: http://67.198.205.116/vicidial/admin.php
Real-Time: http://67.198.205.116/vicidial/admin.php?ADD=999999
Reports: http://67.198.205.116/vicidial/admin.php?ADD=32000000000
Agent Login: http://67.198.205.116/agc/vicidial.php
```

### Database Connection:
```
Host: 67.198.205.116
Database: asterisk
User: cron
Password: 6sfhf9ogku0q
Port: 3306
```

### Key Tables:
```
vicidial_campaigns - Campaign configs
vicidial_list - All leads
vicidial_log - Outbound call log
vicidial_closer_log - Transfer/sales log
vicidial_users - Agents
vicidial_inbound_groups - DID routing
```

### Campaign Field Mappings:
```
--A--phone_number--B-- = Lead phone
--A--first_name--B-- = First name
--A--last_name--B-- = Last name
--A--status--B-- = Call disposition
--A--campaign--B-- = Campaign ID
--A--state--B-- = State code
```

---

**Last Updated:** October 27, 2025
**Created For:** Campaign setup and external integrations
**Support:** Check database or system logs for issues
