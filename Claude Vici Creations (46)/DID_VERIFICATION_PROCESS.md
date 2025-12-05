# 📞 DID Verification & Management Process

**Campaign:** Moses Claude Colorado (4001)
**Date:** October 28, 2025

---

## 🔍 DID Reputation Checking

### Caller ID Reputation Service

**URL:** https://auth.calleridreputation.com/?client_id=7b7f2931-125f-4c2e-9f72-aec8bab03852&redirect_uri=https://partner.calleridreputation.com/login/oneid&state=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdGF0ZVRva2VuIjoiTWE3aWotNVNpaE1NaUdaMCIsImlzcyI6IjdiN2YyOTMxLTEyNWYtNGMyZS05ZjcyLWFlYzhiYWIwMzg1MiIsImV4cCI6MTc2MTY5NTM0MSwibmJmIjoxNzYxNjk1MDQxLCJpYXQiOjE3NjE2OTUwNDF9.S3TtaS1384S42m2nXQxPdPztQ5t_xNW8Mok-JyYkago

**Purpose:** Verify if DIDs (phone numbers) are good before using them in campaigns

**Process:**
1. Get DIDs from Instacall (Excel format)
2. Check each DID on Caller ID Reputation service
3. Verify DID reputation is good
4. Upload verified DIDs to Vicidial

---

## 📊 DID Sources

### Instacall
- **Provider:** Instacall
- **Format:** Excel spreadsheet
- **Content:** List of DIDs (phone numbers)
- **Usage:** Outbound caller ID numbers for campaigns

---

## 🔄 DID Upload & Management Process

### Workflow:

```
1. Instacall provides Excel file with DIDs
         ↓
2. Check each DID on Caller ID Reputation service
   (Use URL above to login and verify)
         ↓
3. Verify DIDs have good reputation
   - Good = Use it
   - Bad/Flagged = Don't use
         ↓
4. Upload verified DIDs to Vicidial
   (via Bulk Tools or Admin interface)
         ↓
5. Assign DIDs to campaigns
```

---

## ⚠️ Important Notes

### Why Check DID Reputation?

**Bad reputation DIDs can cause:**
- Calls marked as spam/scam
- Lower answer rates
- Carrier blocking
- Compliance issues

**Good reputation DIDs:**
- Higher answer rates
- Better deliverability
- Less carrier blocking
- Better campaign performance

---

## 📋 DID Verification Checklist

Before using a DID:
- [ ] Obtained from Instacall (Excel)
- [ ] Checked on Caller ID Reputation service
- [ ] Verified as "Good" reputation
- [ ] Uploaded to Vicidial
- [ ] Assigned to appropriate campaign
- [ ] Tested with sample call

---

## 🔗 Quick Links

**DID Reputation Check:**
https://auth.calleridreputation.com/?client_id=7b7f2931-125f-4c2e-9f72-aec8bab03852&redirect_uri=https://partner.calleridreputation.com/login/oneid&state=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdGF0ZVRva2VuIjoiTWE3aWotNVNpaE1NaUdaMCIsImlzcyI6IjdiN2YyOTMxLTEyNWYtNGMyZS05ZjcyLWFlYzhiYWIwMzg1MiIsImV4cCI6MTc2MTY5NTM0MSwibmJmIjoxNzYxNjk1MDQxLCJpYXQiOjE3NjE2OTUwNDF9.S3TtaS1384S42m2nXQxPdPztQ5t_xNW8Mok-JyYkago

**Vicidial Admin:**
https://dialpower.team/vicidial/admin.php

**Bulk Tools:**
Admin → Bulk Tools (for uploading DIDs)

---

## 📝 Colorado Campaign DIDs

### Currently Configured:

**Opt-In Phone Numbers (Inbound):**
- +1 (480) 560-8782 - Primary opt-in line
- +1 (346) 642-5246 - Secondary opt-in line

**Outbound Caller ID DIDs:**
- [To be added from Instacall Excel]
- [Must verify reputation first]

---

## 🔧 DID Management in Vicidial

### Location: Admin → Bulk Tools

**First Box:** Callback Programming
- Programs unanswered call callbacks
- When callback triggers → audio message plays
- Manages callback timing and attempts

**DID Upload:**
- Upload Instacall Excel file
- Bulk import DIDs
- Assign to campaigns
- Configure caller ID rotation

---

## 📞 DID Types

### Inbound DIDs (Receiving Calls)
**Purpose:** Numbers customers call
**Colorado Campaign:**
- (480) 560-8782 - Opt-in primary
- (346) 642-5246 - Opt-in secondary

### Outbound DIDs (Caller ID)
**Purpose:** Numbers displayed when dialing out
**Colorado Campaign:**
- TBD - From Instacall Excel
- Must be verified on Caller ID Reputation

---

## ⚡ Quick Process Summary

**For New Campaign DIDs:**

1. **Get DIDs:** Instacall sends Excel file
2. **Verify:** Check on calleridreputation.com
3. **Upload:** Bulk Tools in Vicidial
4. **Assign:** Link to Campaign 4001
5. **Test:** Make sample calls
6. **Monitor:** Check answer rates

---

## 🚨 DID Reputation Monitoring

**Regular Checks:**
- Check DID reputation weekly
- Monitor answer rates
- Watch for carrier blocks
- Replace flagged DIDs immediately

**If DID Gets Flagged:**
1. Stop using immediately
2. Get replacement from Instacall
3. Verify new DID reputation
4. Upload and test
5. Document the change

---

## 📊 DID Performance Tracking

**Metrics to Monitor:**
- Answer rate per DID
- Spam flag reports
- Carrier blocking
- Call completion rate

**Good DID Performance:**
- Answer rate: >15-20%
- No spam flags
- No carrier blocks
- Consistent delivery

**Bad DID Performance:**
- Answer rate: <10%
- Spam flags present
- Carrier blocking
- Poor delivery

---

## 💡 Best Practices

1. **Always verify DIDs before use** - Never skip reputation check
2. **Rotate DIDs regularly** - Don't burn out good numbers
3. **Monitor performance** - Track answer rates
4. **Replace flagged DIDs immediately** - Don't wait
5. **Keep good DIDs clean** - Don't over-dial

---

## 📝 Notes for Colorado Campaign

**DID Strategy:**
- Use verified Instacall DIDs for outbound caller ID
- Monitor reputation weekly
- Replace any flagged numbers
- Track answer rate per DID
- Rotate to prevent burnout

**Callback Programming:**
- Unanswered calls trigger callback
- Audio message plays on callback attempt
- Configured via Bulk Tools (first box)
- Manages timing and retry logic

---

**Created:** October 28, 2025
**Campaign:** Moses Claude Colorado (4001)
**Last Updated:** October 28, 2025
