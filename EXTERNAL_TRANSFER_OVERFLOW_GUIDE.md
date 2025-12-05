# How to Configure External Transfer with Overflow to VICIdial Agents

## The Problem
By default, external transfers in VICIdial just dial out. If the external number doesn't answer, the call fails and that's it. No overflow.

## The Solution
Configure the Asterisk dialplan to catch "no answer" and return the call to VICIdial's queue system.

---

## How It Works - Technical

### Current Flow (Remote Agent Mode):
```
Caller → VICIdial → Remote Agent (3001-3005)
                  ↓ (if no answer in 30s)
                  → DROP status
                  → drop_action: IN_GROUP
                  → Back to VICIdial queue
                  → Other agents get it
```

### Desired Flow (External Transfer with Overflow):
```
Caller → VICIdial → External Dial (346-642-5246)
                  ↓ (if no answer in 30s)
                  → Catch NOANSWER in dialplan
                  → Return to VICIdial AGI
                  → drop_action: IN_GROUP kicks in
                  → Back to VICIdial queue
                  → Other agents get it
```

---

## Configuration Required

### 1. Asterisk Dialplan Configuration

**Location:** `/etc/asterisk/extensions.conf` or VICIdial's custom dialplan

**Add this logic:**

```asterisk
; External transfer with overflow
exten => _9003466425246,1,NoOp(External Transfer to AI - 346-642-5246)
exten => _9003466425246,n,Set(DIAL_TIMEOUT=30)
exten => _9003466425246,n,Dial(SIP/13466425246@your-carrier-trunk,${DIAL_TIMEOUT},g)
exten => _9003466425246,n,NoOp(Dial Status: ${DIALSTATUS})
exten => _9003466425246,n,GotoIf($["${DIALSTATUS}" = "ANSWER"]?answered)
exten => _9003466425246,n,GotoIf($["${DIALSTATUS}" = "NOANSWER"]?overflow)
exten => _9003466425246,n,GotoIf($["${DIALSTATUS}" = "BUSY"]?overflow)
exten => _9003466425246,n,GotoIf($["${DIALSTATUS}" = "CONGESTION"]?overflow)
exten => _9003466425246,n,Goto(overflow)

; Call was answered - all good
exten => _9003466425246,n(answered),NoOp(AI Answered - Call Connected)
exten => _9003466425246,n,Hangup()

; Call not answered - overflow to VICIdial agents
exten => _9003466425246,n(overflow),NoOp(AI No Answer - Overflowing to VICIdial)
exten => _9003466425246,n,Set(CALL_STATUS=DROP)
exten => _9003466425246,n,AGI(agi://127.0.0.1:4577/call_inbound)
exten => _9003466425246,n,Hangup()
```

**What this does:**
- Dials 346-642-5246 for 30 seconds
- If answered → Call connects normally
- If NOANSWER/BUSY → Catches it and returns to VICIdial
- VICIdial's `drop_action: IN_GROUP` then routes to available agents

---

### 2. VICIdial Transfer Configuration

**In VICIdial Admin Panel:**

**A. Create Transfer Preset:**
- Go to: Admin → Campaigns → Transfer Presets
- Campaign: StLouisXfer
- Preset Name: "AI Transfer"
- Preset Number: `9003466425246`
- Preset Description: "Transfer to AI with overflow"

**B. Configure Campaign:**
- Campaign: StLouisXfer
- Transfer-Conf settings:
  - Set transfer preset to use the new number
  - Enable "Return to queue on no answer"

**C. In-Group already configured correctly:**
- StLouisXfer has `drop_action: IN_GROUP` ✅
- This will automatically overflow to other agents

---

### 3. Carrier/Trunk Configuration

**Ensure your carrier trunk can dial:**
- Format: `13466425246` (E.164 format)
- Or whatever format your carrier requires
- Test: `Dial(SIP/13466425246@trunk)`

**Check trunk name:**
```bash
asterisk -rx "sip show peers" | grep -i trunk
```

Replace `your-carrier-trunk` in dialplan with actual trunk name.

---

## Alternative: Simpler AGI-Based Approach

If direct dialplan editing is complex, use VICIdial's built-in AGI:

```asterisk
exten => _9003466425246,1,AGI(agi-VDADcloser_inboundCID.agi)
exten => _9003466425246,n,Dial(SIP/13466425246@trunk,30,goT)
exten => _9003466425246,n,AGI(agi-VDADhangup.agi,PRI-----NODEBUG-----${HANGUPCAUSE}-----${DIALSTATUS}-----${UNIQUEID})
```

VICIdial's AGI scripts handle the overflow logic automatically.

---

## Testing the Configuration

### Step 1: Test External Dial
```bash
asterisk -rx "console dial 13466425246@trunk"
```
Should ring 346-642-5246.

### Step 2: Test with Timeout
Make a test call through StLouisXfer:
- Don't answer on 346-642-5246
- Wait 30 seconds
- Call should overflow to VDXL or agents 1002-1010

### Step 3: Monitor
```bash
asterisk -rx "core show channels"
asterisk -rx "sip show channels"
```

Watch the call flow in real-time.

---

## What You Need From Their Dev

Send them this:

```
We need external transfer to 346-642-5246 with overflow to VICIdial agents.

Requirements:
1. Create dialplan entry for external transfer to 13466425246
2. Set dial timeout to 30 seconds
3. Catch NOANSWER/BUSY/CONGESTION
4. On failure, return call to VICIdial queue using AGI
5. Existing drop_action: IN_GROUP will handle overflow

The dialplan should:
- Dial external number first
- If answered → call connects normally
- If no answer → returns to queue for available agents

This is standard VICIdial external transfer with failover.
Can you implement this or provide access to configure it?
```

---

## Why This Works

**The key insight:**
- VICIdial's `drop_action: IN_GROUP` is ALREADY configured ✅
- You just need the dialplan to trigger the DROP status when external number fails
- Once in DROP, VICIdial's existing logic takes over
- Overflow happens automatically

**It's not about building new overflow logic - it's about connecting external dial failure to VICIdial's existing overflow system.**

---

## Summary

**Is it possible?** ✅ YES - 100% possible

**Is it easy?**
- ⚠️ Requires Asterisk dialplan access
- ⚠️ Requires understanding of their carrier trunk config
- ✅ But it's standard VICIdial functionality

**Can you do it yourself?**
- If you have SSH access to VICIdial server: YES
- If you only have web panel access: Need their dev

**Will it work?**
✅ Yes - this is exactly how VICIdial does external transfers with overflow in production environments.

---

## Alternative: Easier Approach

If dialplan work is too complex:

**Use a SIP redirect service:**
1. Point VICIdial to a SIP endpoint you control
2. That endpoint redirects to your AI (346-642-5246)
3. If AI doesn't answer, your endpoint sends SIP 486 BUSY back
4. VICIdial sees BUSY and triggers overflow

This way you don't need to modify their dialplan at all.
