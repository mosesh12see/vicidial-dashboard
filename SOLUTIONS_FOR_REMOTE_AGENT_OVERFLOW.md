# Solutions to Prevent Lost Calls from Remote Agents

## The Problem
When remote agents (3001-3005) dial external number (480) 560-8782 and it doesn't answer:
- Call gets DROP status after 10-30 seconds
- ❌ Does NOT overflow to other VICIdial agents
- ❌ Customer's call is LOST (3 calls lost today)

---

## Solution 1: Fix Remote Agent Drop Action (EASIEST)

**What to do:**
Configure VICIdial to return dropped remote agent calls back to the queue.

**Steps:**
1. Go to: **Admin → System Settings → Remote Agents**
2. Find remote agent configuration for 3001-3005
3. Set **Drop Call Seconds**: 30 (time to wait before considering it a drop)
4. Set **Drop Action**: `IN_GROUP` (return to queue)
5. Set **Drop Inbound Group**: `StLouisXfer` or `StLouisXfer_FO`

**OR via SQL:**
```sql
UPDATE vicidial_remote_agents
SET
    drop_call_seconds = 30,
    drop_action = 'IN_GROUP',
    drop_inbound_group = 'StLouisXfer'
WHERE user IN ('3001', '3002', '3003', '3004', '3005');
```

**Pros:**
- ✅ Simple configuration change
- ✅ No dialplan editing needed
- ✅ Works immediately

**Cons:**
- ⚠️ Adds 30 seconds to wait time before overflow kicks in

**Result:**
When (480) 560-8782 doesn't answer → Call returns to StLouisXfer queue → Next available agent gets it

---

## Solution 2: Configure Asterisk Dialplan for Remote Agents

**What to do:**
Modify the dialplan to catch NOANSWER/BUSY from external number and return to queue.

**Location:** `/etc/asterisk/extensions.conf` or VICIdial custom dialplan

**Add this:**
```asterisk
; Catch failed remote agent calls
exten => _X.,1,NoOp(Remote Agent Call to 480-560-8782)
exten => _X.,n,Set(DIAL_TIMEOUT=30)
exten => _X.,n,Dial(SIP/14805608782@your-carrier-trunk,${DIAL_TIMEOUT},gT)
exten => _X.,n,NoOp(Dial Status: ${DIALSTATUS})

; If answered, all good
exten => _X.,n,GotoIf($["${DIALSTATUS}" = "ANSWER"]?answered)

; If not answered, return to VICIdial queue
exten => _X.,n,GotoIf($["${DIALSTATUS}" = "NOANSWER"]?overflow)
exten => _X.,n,GotoIf($["${DIALSTATUS}" = "BUSY"]?overflow)
exten => _X.,n,GotoIf($["${DIALSTATUS}" = "CONGESTION"]?overflow)
exten => _X.,n,Goto(overflow)

exten => _X.,n(answered),NoOp(External Agent Answered)
exten => _X.,n,Hangup()

; Return to VICIdial queue
exten => _X.,n(overflow),NoOp(No Answer - Returning to Queue)
exten => _X.,n,Set(CALL_STATUS=DROP)
exten => _X.,n,AGI(agi://127.0.0.1:4577/call_inbound)
exten => _X.,n,Hangup()
```

**Pros:**
- ✅ Full control over timeout and overflow logic
- ✅ Can customize retry behavior
- ✅ Most reliable method

**Cons:**
- ⚠️ Requires SSH access to VICIdial server
- ⚠️ Need to know carrier trunk name
- ⚠️ Requires Asterisk reload after changes

**Result:**
Calls that don't get answered by external number automatically return to VICIdial queue.

---

## Solution 3: Switch to SIP Registration Mode (RECOMMENDED)

**What to do:**
Instead of dialing external number, have your AI platform REGISTER as VICIdial agent via SIP/IAX.

**This is how Zoiper works** (from your screenshot):
- Zoiper registers via IAX2 to "CapitalCloud"
- Shows as "logged in" to VICIdial
- Receives calls directly (no external dial needed)
- VICIdial's built-in overflow handles no-answer automatically

**Steps:**
1. **Request from VICIdial admin:**
   ```
   We need SIP or IAX2 registration credentials for remote agents 3001-3005.
   Can you create SIP endpoints and provide:
   - Server IP: (probably 67.198.205.116)
   - Port: 5060 (SIP) or 4569 (IAX2)
   - Username: 3001, 3002, 3003, 3004, 3005
   - Password: (SIP passwords for each)

   This way our AI platform can register like Zoiper does.
   ```

2. **Configure your AI platform to register:**
   - Use SIP/IAX library (pjsip, linphone, etc.)
   - Register to VICIdial server
   - Show as "logged in" agent
   - Accept incoming calls

3. **When call comes in:**
   - Your AI answers (or doesn't)
   - If AI doesn't answer in 30s → VICIdial marks as DROP
   - drop_action: IN_GROUP kicks in automatically
   - Call goes to next available agent

**Pros:**
- ✅ Uses VICIdial's native overflow system
- ✅ No dialplan changes needed
- ✅ More reliable than external dial
- ✅ Same way your other agents work (via Zoiper)

**Cons:**
- ⚠️ Requires SIP credentials from admin
- ⚠️ AI platform needs SIP/IAX capability
- ⚠️ Need to implement SIP registration in your code

**Result:**
AI acts as a real VICIdial agent, overflow works automatically, no calls lost.

---

## Solution 4: Use VICIdial's Built-in AGI Scripts

**What to do:**
Use VICIdial's existing AGI scripts that handle overflow automatically.

**Configure in dialplan:**
```asterisk
exten => _X.,1,AGI(agi-VDADcloser_inboundCID.agi)
exten => _X.,n,Dial(SIP/14805608782@trunk,30,goT)
exten => _X.,n,AGI(agi-VDADhangup.agi,PRI-----NODEBUG-----${HANGUPCAUSE}-----${DIALSTATUS}-----${UNIQUEID})
```

**Pros:**
- ✅ Uses VICIdial's native AGI scripts
- ✅ Handles overflow automatically
- ✅ Logs everything correctly

**Cons:**
- ⚠️ Still requires dialplan access
- ⚠️ Need to know correct AGI parameters

**Result:**
VICIdial's AGI handles overflow logic for you.

---

## Solution 5: Create a SIP Redirect Service (NO VICIDIAL CHANGES)

**What to do:**
Create your own SIP proxy that:
1. Receives call from VICIdial
2. Redirects to your AI (480) 560-8782
3. If AI doesn't answer, sends `486 BUSY` back to VICIdial
4. VICIdial sees BUSY and triggers overflow

**Architecture:**
```
VICIdial → Your SIP Proxy → AI (480-560-8782)
           ↓ (if no answer)
           486 BUSY back to VICIdial
           ↓
           Overflow to other agents
```

**Pros:**
- ✅ No VICIdial configuration changes needed
- ✅ You control timeout and retry logic
- ✅ Can work with any external number

**Cons:**
- ⚠️ Requires setting up your own SIP server
- ⚠️ More complex infrastructure
- ⚠️ Need to configure VICIdial to dial YOUR proxy instead

**Result:**
Your proxy handles overflow by sending proper SIP error codes.

---

## COMPARISON TABLE

| Solution | Difficulty | Requires VICIdial Access | Time to Implement | Reliability |
|----------|-----------|-------------------------|-------------------|-------------|
| **1. Fix Drop Action** | ⭐ Easy | Admin panel or SQL | 5 minutes | ⭐⭐⭐ Good |
| **2. Dialplan Config** | ⭐⭐⭐ Hard | SSH + Asterisk | 30 minutes | ⭐⭐⭐⭐ Excellent |
| **3. SIP Registration** | ⭐⭐ Medium | Need credentials | 1-2 hours | ⭐⭐⭐⭐⭐ Best |
| **4. AGI Scripts** | ⭐⭐⭐ Hard | SSH + Asterisk | 30 minutes | ⭐⭐⭐⭐ Excellent |
| **5. SIP Proxy** | ⭐⭐⭐⭐ Very Hard | None (your side) | 4+ hours | ⭐⭐⭐ Good |

---

## RECOMMENDED APPROACH

**Immediate (Today):**
→ **Solution 1: Fix Drop Action**
- Quick SQL update or admin panel change
- Stops losing calls immediately
- 5 minute fix

**Long-term (Best Solution):**
→ **Solution 3: SIP Registration**
- Request SIP credentials from admin
- Have AI register as agent (like Zoiper)
- Most reliable, uses VICIdial's native systems
- Same way your other agents work

---

## SQL TO CHECK CURRENT CONFIG

```sql
-- Check if remote agents table has drop action configured
SELECT
    user,
    number_of_lines,
    server_ip,
    conf_exten,
    status,
    campaign_id
FROM vicidial_remote_agents
WHERE user IN ('3001', '3002', '3003', '3004', '3005');
```

```sql
-- Check current drop action for StLouisXfer
SELECT
    group_id,
    drop_call_seconds,
    drop_action,
    drop_inbound_group
FROM vicidial_inbound_groups
WHERE group_id = 'StLouisXfer';
```

---

## WHAT TO TELL THEIR TECH GUY

**For Immediate Fix:**
```
We're losing calls when remote agents don't answer. Can you configure:

UPDATE vicidial_remote_agents
SET
    drop_call_seconds = 30,
    drop_action = 'IN_GROUP',
    drop_inbound_group = 'StLouisXfer'
WHERE user IN ('3001', '3002', '3003', '3004', '3005');

This will return dropped calls back to the queue for other agents.
```

**For Long-term Solution:**
```
Our AI platform can register as SIP/IAX agents (like your Zoiper users).
Can you create SIP endpoints for agents 3001-3005 and provide:
- Server IP
- Port (5060 for SIP or 4569 for IAX2)
- Registration credentials

This way our AI registers as a logged-in agent, and VICIdial's
native overflow handles everything automatically.
```

---

## NEXT STEPS

1. **Check current remote agent config** (see SQL above)
2. **Choose solution** based on your access level and timeline
3. **Implement fix** (we can help with SQL or SIP registration)
4. **Test** by having external number not answer and verify overflow works
5. **Monitor** to ensure no more calls are lost
