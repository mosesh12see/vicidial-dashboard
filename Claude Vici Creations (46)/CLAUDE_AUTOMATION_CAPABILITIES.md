# 🤖 Claude Code Automation for Vicidial - What's Possible vs Manual

## 📊 AUTOMATION SUMMARY

| Task | Claude Can Automate? | Difficulty | Manual Steps Needed |
|------|---------------------|------------|---------------------|
| Clone Campaign | ✅ 100% | Easy | None - verify settings |
| Configure Campaign Settings | ✅ 95% | Easy | Web UI for advanced options |
| Load Leads (CSV) | ✅ 100% | Easy | None - provide CSV file |
| Create Users/Agents | ✅ 100% | Easy | None - provide details |
| Set Up Phone Extensions | ✅ 90% | Medium | SIP registration if external |
| Create Inbound Groups | ✅ 100% | Easy | None |
| Configure DID Routing | ✅ 85% | Medium | Verify carrier routing |
| Set Up Remote Agents | ✅ 95% | Medium | Test calls manually |
| Configure Failover | ✅ 100% | Easy | None |
| Test Campaign | ❌ 0% | N/A | **Manual testing required** |
| External Integrations | ✅ 80% | Medium | API key setup |

---

## ✅ WHAT CLAUDE CODE CAN DO 100% AUTOMATED

### 1. Clone and Configure Campaign

**What Claude Does:**
```bash
# Direct database access
mysql -u cron -p'6sfhf9ogku0q' asterisk -e "

-- Clone campaign 1022 to new campaign 1029
INSERT INTO vicidial_campaigns
(campaign_id, campaign_name, active, dial_method, auto_dial_level,
 dial_timeout, lead_order, hopper_level, campaign_description)
SELECT
  '1029' as campaign_id,
  'Texas Inbound' as campaign_name,
  'Y' as active,
  dial_method,
  auto_dial_level,
  dial_timeout,
  lead_order,
  hopper_level,
  'Texas outbound dialer campaign'
FROM vicidial_campaigns
WHERE campaign_id = '1022';
"
```

**Manual Steps:**
- ✅ NONE - Claude creates everything
- Just verify settings look correct

**Time Saved:** ~15 minutes of clicking through web UI

---

### 2. Create Remote Agent Users

**What Claude Does:**
```bash
# Create 3 remote agents with one command
mysql -u cron -p'6sfhf9ogku0q' asterisk -e "

INSERT INTO vicidial_users
(user, pass, full_name, user_level, user_group, phone_login,
 phone_pass, active, hotkeys_active, voicemail_id,
 closer_campaigns, agent_choose_ingroups)
VALUES
('REMOTE001', 'pass123', 'Sarah Johnson', 1, 'AGENTS',
 '8367', '1234', 'Y', 0, '8367', 'TexasXfer', 1),

('REMOTE002', 'pass123', 'Mike Williams', 1, 'AGENTS',
 '8368', '1234', 'Y', 0, '8368', 'TexasXfer', 1),

('REMOTE003', 'pass123', 'Lisa Brown', 1, 'AGENTS',
 '8369', '1234', 'Y', 0, '8369', 'TexasXfer', 1);
"
```

**Manual Steps:**
- ✅ NONE - All agents created
- Just provide agent names and cell numbers

**Time Saved:** ~30 minutes of manual user creation

---

### 3. Load Leads from CSV

**What Claude Does:**
```bash
# Automatically loads leads from CSV
/usr/share/astguiclient/AST_lead_loader.pl \
  --file=/tmp/texas_leads.csv \
  --campaign-id=1029 \
  --list-id=999 \
  --phone-code=1 \
  --duplicate-check=DUPLIST \
  --verbose

# Claude can also create the list first
mysql -u cron -p'6sfhf9ogku0q' asterisk -e "
INSERT INTO vicidial_lists
(list_id, list_name, campaign_id, active, list_description)
VALUES
(999, 'Texas Test Leads', '1029', 'Y', 'Initial Texas lead batch');
"
```

**Manual Steps:**
- ✅ NONE - Fully automated
- Just provide the CSV file

**Time Saved:** ~20 minutes of web upload/configuration

---

### 4. Configure Phone Extensions for Remote Agents

**What Claude Does:**
```bash
mysql -u cron -p'6sfhf9ogku0q' asterisk -e "

INSERT INTO phones
(extension, dialplan_number, voicemail_id, server_ip,
 login, pass, protocol, phone_type,
 outbound_cid, template_id, active)
VALUES
('8367', '8367', '8367', '67.198.205.116',
 'REMOTE001', '1234', 'SIP', 'REMOTE',
 '2145551234', 'default', 'Y'),

('8368', '8368', '8368', '67.198.205.116',
 'REMOTE002', '1234', 'SIP', 'REMOTE',
 '2145555678', 'default', 'Y'),

('8369', '8369', '8369', '67.198.205.116',
 'REMOTE003', '1234', 'SIP', 'REMOTE',
 '2145559012', 'default', 'Y');
"
```

**Manual Steps:**
- ⚠️ **May need:** Asterisk SIP reload
  ```bash
  asterisk -rx "sip reload"
  ```
- Claude can do this automatically

**Time Saved:** ~45 minutes of phone setup

---

### 5. Create Closer/Transfer Campaign

**What Claude Does:**
```bash
mysql -u cron -p'6sfhf9ogku0q' asterisk -e "

-- Create TexasXfer closer campaign
INSERT INTO vicidial_campaigns
(campaign_id, campaign_name, active, dial_method,
 campaign_recording, campaign_rec_filename)
VALUES
('TexasXfer', 'Texas Transfer Campaign', 'Y', 'INBOUND_MAN',
 'ALLFORCE', 'CAMPAIGNID_CUSTPHONE_LEADID_DATE_TIME');

-- Link outbound campaign to closer
UPDATE vicidial_campaigns
SET closer_campaigns = 'TexasXfer'
WHERE campaign_id = '1029';
"
```

**Manual Steps:**
- ✅ NONE - Fully automated

**Time Saved:** ~20 minutes

---

### 6. Set Up Inbound Group with Failover

**What Claude Does:**
```bash
mysql -u cron -p'6sfhf9ogku0q' asterisk -e "

INSERT INTO vicidial_inbound_groups
(group_id, group_name, active, queue_priority,
 drop_call_seconds, drop_action, drop_inbound_group,
 on_hook_agent, agent_alert_delay, agent_ring_method)
VALUES
('TexasXfer', 'Texas Transfer Queue', 'Y', 50,
 120, 'VOICEMAIL', '', 'N', 0, 'ROUND_ROBIN');

-- Add agents to inbound group
INSERT INTO vicidial_inbound_group_agents
(group_id, user, group_rank, calls_today)
VALUES
('TexasXfer', 'REMOTE001', 1, 0),
('TexasXfer', 'REMOTE002', 2, 0),
('TexasXfer', 'REMOTE003', 3, 0);
"
```

**Manual Steps:**
- ✅ NONE - Fully automated

**Time Saved:** ~15 minutes

---

## ⚠️ WHAT REQUIRES MANUAL INTERVENTION

### 1. Testing Actual Phone Calls

**Why Manual:**
- Claude can't make/receive phone calls
- Can't verify audio quality
- Can't test recording playback

**What You Do:**
1. Call test number
2. Verify routing works
3. Check recording quality
4. Test failover by not answering

**Time Required:** ~30 minutes

---

### 2. Advanced Web UI Settings

**Why Manual:**
- Some settings only in web UI
- No command-line equivalent
- Visual confirmation needed

**Examples:**
- Custom scripts with drag-drop
- Call flow diagrams
- Real-time monitoring setup
- Custom reports

**What Claude Can Do Instead:**
- Provide exact URLs to navigate to
- Give step-by-step instructions
- Show SQL queries to verify settings

**Time Required:** ~10-15 minutes

---

### 3. External Carrier/SIP Trunk Setup

**Why Manual:**
- Requires carrier account
- May need firewall rules
- NAT configuration
- Carrier-specific settings

**What You Do:**
1. Contact carrier for SIP credentials
2. Configure trunk in Vicidial
3. Test outbound calling
4. Verify caller ID

**What Claude Can Help:**
- Generate SIP trunk config template
- Provide example settings
- Debug connection issues via logs

**Time Required:** ~1-2 hours (first time)

---

### 4. Training Agents

**Why Manual:**
- Agents need hands-on practice
- Screen sharing sessions
- Q&A

**What Claude Can Provide:**
- Agent training guide (markdown)
- Quick reference cards
- Common scenarios documentation

**Time Required:** ~2 hours per agent (first time)

---

## 🚀 COMPLETE AUTOMATION WORKFLOW

### Scenario: Set Up New Texas Campaign with 3 Remote Agents

**You provide to Claude:**
```
Campaign Name: Texas Inbound
State: TX
Agent Names: Sarah, Mike, Lisa
Agent Cell Phones: 214-555-0001, 214-555-0002, 214-555-0003
Opt-in DID: 800-123-4567
Leads CSV: /tmp/texas_leads.csv
```

**Claude executes (in terminal):**

```bash
#!/bin/bash
# AUTOMATED CAMPAIGN SETUP - Generated by Claude Code

echo "🚀 Starting Texas campaign setup..."

# Step 1: Clone campaign
echo "1️⃣ Cloning campaign..."
mysql -u cron -p'6sfhf9ogku0q' asterisk <<EOF
INSERT INTO vicidial_campaigns
SELECT
  '1029', 'Texas Inbound', 'Y', dial_method,
  auto_dial_level, dial_timeout, lead_order, hopper_level,
  'Texas outbound dialer campaign'
FROM vicidial_campaigns WHERE campaign_id = '1022';
EOF

# Step 2: Create agents
echo "2️⃣ Creating remote agents..."
mysql -u cron -p'6sfhf9ogku0q' asterisk <<EOF
INSERT INTO vicidial_users VALUES
('REMOTE001', 'pass123', 'Sarah Johnson', 1, 'AGENTS',
 '8367', '1234', 'Y', 0, '8367', 'TexasXfer', 1),
('REMOTE002', 'pass123', 'Mike Williams', 1, 'AGENTS',
 '8368', '1234', 'Y', 0, '8368', 'TexasXfer', 1),
('REMOTE003', 'pass123', 'Lisa Brown', 1, 'AGENTS',
 '8369', '1234', 'Y', 0, '8369', 'TexasXfer', 1);
EOF

# Step 3: Create phone extensions
echo "3️⃣ Configuring phone extensions..."
mysql -u cron -p'6sfhf9ogku0q' asterisk <<EOF
INSERT INTO phones VALUES
('8367', '8367', '8367', '67.198.205.116',
 'REMOTE001', '1234', 'SIP', 'REMOTE', '2145550001', 'default', 'Y'),
('8368', '8368', '8368', '67.198.205.116',
 'REMOTE002', '1234', 'SIP', 'REMOTE', '2145550002', 'default', 'Y'),
('8369', '8369', '8369', '67.198.205.116',
 'REMOTE003', '1234', 'SIP', 'REMOTE', '2145550003', 'default', 'Y');
EOF

# Step 4: Create closer campaign
echo "4️⃣ Creating transfer campaign..."
mysql -u cron -p'6sfhf9ogku0q' asterisk <<EOF
INSERT INTO vicidial_campaigns VALUES
('TexasXfer', 'Texas Transfer Campaign', 'Y', 'INBOUND_MAN',
 'ALLFORCE', 'CAMPAIGNID_CUSTPHONE_LEADID_DATE_TIME');

UPDATE vicidial_campaigns
SET closer_campaigns = 'TexasXfer' WHERE campaign_id = '1029';
EOF

# Step 5: Create inbound group with failover
echo "5️⃣ Setting up call routing with failover..."
mysql -u cron -p'6sfhf9ogku0q' asterisk <<EOF
INSERT INTO vicidial_inbound_groups VALUES
('TexasXfer', 'Texas Transfer Queue', 'Y', 50, 120,
 'VOICEMAIL', '', 'N', 0, 'ROUND_ROBIN');

INSERT INTO vicidial_inbound_group_agents VALUES
('TexasXfer', 'REMOTE001', 1, 0),
('TexasXfer', 'REMOTE002', 2, 0),
('TexasXfer', 'REMOTE003', 3, 0);
EOF

# Step 6: Create lead list
echo "6️⃣ Creating lead list..."
mysql -u cron -p'6sfhf9ogku0q' asterisk <<EOF
INSERT INTO vicidial_lists VALUES
(999, 'Texas Test Leads', '1029', 'Y', 'Initial Texas lead batch');
EOF

# Step 7: Load leads
echo "7️⃣ Loading leads from CSV..."
/usr/share/astguiclient/AST_lead_loader.pl \
  --file=/tmp/texas_leads.csv \
  --campaign-id=1029 \
  --list-id=999 \
  --phone-code=1 \
  --duplicate-check=DUPLIST

# Step 8: Configure DID
echo "8️⃣ Setting up opt-in DID..."
mysql -u cron -p'6sfhf9ogku0q' asterisk <<EOF
INSERT INTO vicidial_inbound_dids VALUES
('8001234567', 'Texas Opt-In Line', '', 'TexasXfer',
 'AGENT', '8368', 'Y', '', '', '');
EOF

# Step 9: Reload Asterisk
echo "9️⃣ Reloading Asterisk..."
asterisk -rx "sip reload"
asterisk -rx "dialplan reload"

echo "✅ SETUP COMPLETE!"
echo ""
echo "📋 NEXT STEPS (MANUAL):"
echo "1. Test call: 800-123-4567"
echo "2. Verify agent cells ring: 214-555-0001, 0002, 0003"
echo "3. Test failover by not answering"
echo "4. Check recording: http://67.198.205.116/vicidial/admin.php"
echo ""
echo "🔗 Admin Panel: http://67.198.205.116/vicidial/admin.php"
echo "📊 Real-Time: http://67.198.205.116/vicidial/admin.php?ADD=999999"
```

**Execution Time:** ~2 minutes

**Your Manual Steps:**
1. Run Claude's script: `bash setup_texas.sh`
2. Test phone calls (30 min)
3. Verify settings in web UI (10 min)

**Total Time:** ~45 minutes
**vs Manual Setup:** ~4-6 hours

---

## 💡 HYBRID APPROACH - Best of Both Worlds

### What Works Best:

**Claude Automates (95%):**
1. All database configurations
2. User/agent creation
3. Phone setup
4. Campaign cloning
5. Lead loading
6. Routing setup
7. Failover configuration

**You Manually Do (5%):**
1. Test actual phone calls
2. Verify recordings
3. Train agents
4. Fine-tune dial levels based on performance
5. Monitor first few days

---

## 🎯 SAMPLE INTERACTION WITH CLAUDE

**You:**
```
Set up a new Georgia campaign cloning 1027, with 5 remote agents:
- Emma: 404-555-0001
- David: 404-555-0002
- Rachel: 404-555-0003
- Tom: 404-555-0004
- Amy: 404-555-0005

Use GeorgiaXfer2 as closer campaign, round-robin routing,
15 second ring timeout, voicemail failover.
```

**Claude:**
```bash
# Claude generates and executes complete script
# Takes 90 seconds to run
# Creates 1 campaign, 5 agents, 5 extensions, 1 inbound group
# All configured exactly as requested
```

**Claude Reports:**
```
✅ Georgia campaign setup complete!

Created:
- Campaign: 1030 (Georgia Inbound 2)
- Agents: REMOTE004-008 (Emma, David, Rachel, Tom, Amy)
- Extensions: 8370-8374
- Closer: GeorgiaXfer2
- Inbound Group: GeorgiaXfer2 (round-robin, 15 sec timeout)

Test: Call 404-555-0001 to verify agent phone rings

Admin Panel: http://67.198.205.116/vicidial/admin.php
Real-Time Monitor: http://67.198.205.116/vicidial/admin.php?ADD=999999
```

---

## 📊 AUTOMATION SUMMARY

| Total Setup Time | Manual | With Claude |
|------------------|--------|-------------|
| Campaign Clone | 20 min | 10 sec |
| Agent Creation (5 agents) | 1 hour | 5 sec |
| Phone Setup | 45 min | 5 sec |
| Inbound Group | 20 min | 5 sec |
| Lead Loading | 30 min | 30 sec |
| DID Configuration | 15 min | 5 sec |
| Testing | 30 min | 30 min |
| **TOTAL** | **4 hours** | **35 minutes** |

**Time Savings:** ~85% automation

---

## ✅ FINAL ANSWER

### Can Claude Code Do This for You?

**YES - Almost Everything!**

**What Claude Automates:**
- ✅ 95% of technical setup
- ✅ All database configurations
- ✅ Complete campaign cloning
- ✅ All agent/phone setup
- ✅ Routing and failover
- ✅ Lead loading
- ✅ Integration webhooks

**Where You Manually Step In:**
- ⚠️ Test actual phone calls (30 min)
- ⚠️ Verify recordings sound good (5 min)
- ⚠️ Train agents on web panel (2 hours first time)
- ⚠️ Monitor first few days (adjust dial levels)

**Typical Workflow:**
```
1. You tell Claude: "Set up Texas campaign with 3 remote agents"
2. Claude generates complete automation script
3. You review script (2 min)
4. You run script (2 min execution)
5. You test calls (30 min)
6. Done! Campaign is live
```

**Total Time:** ~40 minutes vs 4-6 hours manual

---

**Bottom Line:** Claude Code can automate 85-95% of Vicidial campaign setup through terminal/database access. You only need to step in for physical testing and verification!
