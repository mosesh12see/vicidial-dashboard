# ✅ ZAPIER SETUP - FINAL 2 MINUTES!

## 🎉 WHAT I JUST DID:

✅ **Configured Vicidial** → Sends opt-ins to your Zapier webhook
✅ **Sent test data** → Zapier received: John Doe (303-555-1234)
✅ **Call routing** → Already configured to 346-642-5246

---

## ⏳ YOU DO THIS (2 minutes):

### Step 1: Go to your Zapier dashboard
```
https://zapier.com/app/zaps
```

### Step 2: You should see your webhook trigger with test data
- Click on your Zap (the one you just created)
- You should see it caught the test: **John Doe, 303-555-1234**
- Click **"Continue"**

### Step 3: Add Action to send to GHL

1. Click **"+"** to add an Action
2. Search: **"Webhooks by Zapier"**
3. Event: **"POST"**
4. Click **"Continue"**

### Step 4: Configure the POST

**URL:**
```
https://services.leadconnectorhq.com/hooks/boXe5LQTgfuXIRfrFTja/webhook-trigger/e241703a-47bc-4554-8d04-bb31a33512cc
```

**Payload Type:** `json`

**Data:** (Map fields from trigger)
```
phone_number: Query String Phone Number
first_name: Query String First Name
last_name: Query String Last Name
email: Query String Email
address1: Query String Address1
city: Query String City
state: Query String State
postal_code: Query String Postal Code
```

### Step 5: Test it
1. Click **"Test action"**
2. Should say "Success!"
3. Click **"Publish"**

### Step 6: Turn it ON
1. Toggle switch to **"ON"**
2. Done!

---

## 🎯 COMPLETE FLOW NOW:

```
Someone opts in (SVYCLM)
         ↓
    TWO THINGS HAPPEN:
         ↓
┌─────────────────────┐    ┌─────────────────────┐
│  DATA FLOW          │    │  CALL FLOW          │
│                     │    │                     │
│  Vicidial           │    │  Vicidial           │
│    ↓                │    │    ↓                │
│  Zapier webhook     │    │  Transfer to:       │
│    ↓                │    │  +1-346-642-5246    │
│  Your Zapier        │    │                     │
│    ↓                │    │  (Recording         │
│  GHL webhook        │    │   continues)        │
│    ↓                │    │                     │
│  Lead in GHL! ✅    │    │  GHL answers! ✅    │
└─────────────────────┘    └─────────────────────┘
```

---

## ✅ WHEN YOU'RE DONE:

Test it! Tell me when Zapier is ON and I'll send another test opt-in to verify everything works end-to-end.

---

**Status:** 🟢 95% Complete - Just finish Zapier config!
