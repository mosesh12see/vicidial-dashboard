# 🎙️ Vicidial Audio Files - Complete Library

**Downloaded:** October 30, 2025
**Total Files:** 1,764 WAV files
**Total Size:** 117 MB

---

## 📊 Summary

✅ **ALL audio files from Vicidial server downloaded successfully!**

This folder contains every single audio file from your Vicidial system:
- Custom AI-generated voices (Aaron, Ayla, Hannah, etc.)
- System sounds (digits, letters, prompts)
- IVR messages
- Survey audio
- Wrapup messages
- Everything!

---

## 🎯 Key AI-Generated Audio Files (Your Campaigns)

### Currently Used by Campaigns:

**Illinois (1028):**
- AaronAmarenIllinois.wav (372 KB)
- AaronAmarenIllinois25sec.wav (386 KB)

**Georgia (1027):**
- AylaHannahGeorgiaPower.wav (387 KB)

**Missouri (1022) & Your Colorado (4001):**
- HannahStLouisMissouriAmeren.wav (389 KB)

**New Jersey:**
- jerseysincere.wav (258 KB)

**Answering Machine (Most campaigns):**
- silence2seconds.wav (48 KB) - No voicemail, just 2 sec silence

### Other Colorado Options:
- AaronColoradoElectric.wav (298 KB) - Alternate Colorado message

### Other State-Specific Messages:
Browse through files starting with "Aaron", "Ayla", "Hannah" for different states

---

## 📂 File Organization

**System Sounds:**
- 0.wav - 9.wav: Digit prompts
- Letters, phonetics, time/date sounds
- Standard Asterisk system prompts

**Custom AI Voices:**
- Aaron*.wav: Male AI voice (various states/utilities)
- Ayla*.wav: Female AI voice
- Hannah*.wav: Female AI voice
- Lisa*.wav: Female AI voice

**IVR/Survey:**
- Various question and response prompts
- Confirmation messages
- Transfer prompts

---

## 🎧 How to Listen

**Play any file:**
```bash
cd "/Users/mosesherrera/Desktop/vicidial-analysis/Claude Vici Creations/Ai Audios Vici"

# Listen to your current Colorado campaign audio:
afplay "HannahStLouisMissouriAmeren.wav"

# Listen to alternate Colorado option:
afplay "AaronColoradoElectric.wav"

# Browse all Aaron voices:
ls -1 Aaron*.wav

# Play them in sequence:
for f in Aaron*.wav; do echo "Playing: $f"; afplay "$f"; done
```

**Search for specific audio:**
```bash
# Find all Colorado-related audio:
ls -1 *Colorado*.wav

# Find all Aaron voices:
ls -1 Aaron*.wav

# Find all survey messages:
ls -1 *survey*.wav
```

---

## 🔍 Quick Search Commands

**Find audio for specific states:**
```bash
ls -1 *Colorado*.wav
ls -1 *Missouri*.wav
ls -1 *Illinois*.wav
ls -1 *Georgia*.wav
```

**Find by voice talent:**
```bash
ls -1 Aaron*.wav | wc -l    # Count Aaron files
ls -1 Ayla*.wav | wc -l     # Count Ayla files
ls -1 Hannah*.wav | wc -l   # Count Hannah files
```

**Find by utility company:**
```bash
ls -1 *Ameren*.wav
ls -1 *GeorgiaPower*.wav
ls -1 *Electric*.wav
```

---

## 📋 File Formats

**All files are:**
- Format: RIFF WAVE
- Bit depth: 16-bit
- Channels: Mono
- Sample rate: 8000 Hz (8 kHz)
- Encoding: PCM (uncompressed)

**Perfect for Vicidial use - no conversion needed!**

---

## 🎯 For Your Colorado Campaign

**Currently using:**
- Survey: HannahStLouisMissouriAmeren.wav (Missouri message, generic)

**Options to switch to:**
- AaronColoradoElectric.wav (Colorado-specific message)

**To change:**
1. Listen to both options
2. If you prefer AaronColoradoElectric.wav:
   - Admin → Campaigns → 4001
   - Survey First Audio File: Change to "AaronColoradoElectric"
   - Submit

---

## 💾 Storage Location

```
/Users/mosesherrera/Desktop/vicidial-analysis/Claude Vici Creations/Ai Audios Vici/
```

**Total files:** 1,764
**Total size:** 117 MB

---

## 🚀 Downloaded Using

**Method:** Vicidial Non-Agent API (`sounds_list` function)
**API Credentials:** byteworth / 6sfhf9ogku0qStJuDe10adv1l3
**API Endpoint:** https://dialpower.team/vicidial/non_agent_api.php

---

**Last Updated:** October 30, 2025
**Status:** ✅ Complete - All 1,764 files downloaded successfully
