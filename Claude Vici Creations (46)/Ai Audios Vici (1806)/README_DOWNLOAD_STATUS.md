# 🎙️ Audio Files Download Status

**Status:** ❌ Unable to download - SSH access required

---

## 📋 Audio Files Identified (6 files)

1. **AaronAmarenIllinois.wav** - Illinois campaign survey
2. **AylaHannahGeorgiaPower.wav** - Georgia campaign survey
3. **HannahStLouisMissouriAmeren.wav** - Missouri/Colorado survey (YOUR campaign uses this)
4. **Wrapup Call.wav** - Wrapup message (all campaigns)
5. **jerseysincere.wav** - New Jersey campaign survey
6. **silence2seconds.wav** - 2-second silence (no voicemail message)

---

## ⚠️ Download Issue

**Problem:** SSH port (22) is currently blocked/refused on server 67.198.205.116

**Attempts made:**
- ❌ SSH/SCP: Connection refused (port 22 blocked)
- ❌ HTTPS public path: Files not accessible without auth

**Solution:** Need SSH access to download files

---

## 📥 How to Download (When SSH Available)

### Option 1: Automated Script
```bash
cd "/Users/mosesherrera/Desktop/vicidial-analysis/Claude Vici Creations/Ai Audios Vici"
./download_audio_files.sh
```

### Option 2: Manual Download
```bash
cd "/Users/mosesherrera/Desktop/vicidial-analysis/Claude Vici Creations/Ai Audios Vici"

scp root@67.198.205.116:/var/lib/asterisk/sounds/en/AaronAmarenIllinois.wav .
scp root@67.198.205.116:/var/lib/asterisk/sounds/en/AylaHannahGeorgiaPower.wav .
scp root@67.198.205.116:/var/lib/asterisk/sounds/en/HannahStLouisMissouriAmeren.wav .
scp root@67.198.205.116:/var/lib/asterisk/sounds/en/"Wrapup Call.wav" .
scp root@67.198.205.116:/var/lib/asterisk/sounds/en/jerseysincere.wav .
scp root@67.198.205.116:/var/lib/asterisk/sounds/en/silence2seconds.wav .
```

---

## 🔧 To Enable SSH Access

**Check if SSH service is running:**
```bash
ssh root@67.198.205.116
```

**If connection refused:**
- Contact server administrator
- Check if port 22 is blocked by firewall
- Verify SSH service is running on server

---

## 🎯 Why You Want These Audio Files

**To listen and understand:**
1. What message plays to customers on survey calls
2. What the wrapup message sounds like
3. Whether you want to create custom Colorado-specific audio
4. Quality and tone of current AI-generated voices

**Your Colorado campaign currently uses:**
- Survey: HannahStLouisMissouriAmeren.wav (Missouri message)
- AM Message: silence2seconds.wav (no voicemail)
- Wrapup: Wrapup Call.wav

**You may want to:**
- Create custom Colorado-specific survey message
- Or keep using Missouri message (it's generic enough)

---

**Created:** October 30, 2025
**Status:** Waiting for SSH access
**Action:** Contact IT/admin to enable SSH (port 22) on 67.198.205.116
