# 🎙️ Audio File Requirements for Moses Claude Colorado Campaign

**Campaign:** 4001 - Moses Claude Colorado
**Date:** October 28, 2025

---

## ⚠️ REQUIRED: Outbound Call Audio

### What Audio Files Do You Need?

For **Campaign 4001 (Moses Claude Colorado)**, you need these audio files:

---

## 1. **Answering Machine Detection (AMD) Message** ⚠️ **CRITICAL**

**When used:** When system detects answering machine/voicemail
**Purpose:** Leave message on answering machines automatically

**What it should say:**
```
"Hi, this is [Your Company] calling about your energy options in Colorado.
We'll try calling you back at a better time. To reach us directly, call
[Your Callback Number]. Thank you!"
```

**File specs (STRONGLY RECOMMENDED):**
- **Format:** 16bit Mono 8k PCM WAV (.wav)
- **Bit depth:** 16-bit
- **Channels:** Mono (single channel)
- **Sample rate:** 8000 Hz (8k)
- **Encoding:** PCM (uncompressed)
- **Length:** 10-30 seconds max
- **Filename:** No spaces (will be stripped automatically)

**Vicidial path:** `/var/lib/asterisk/sounds/en/`
**Filename example:** `colorado_amd_message.wav` (no spaces!)

---

## 2. **Survey/IVR Audio** (If Using Opt-In Survey)

### Current Campaign Uses Survey System

Based on Missouri template, the campaign has:
- `survey_opt_in_audio_file`
- `survey_ni_audio_file` (not interested)
- `survey_method: CALLMENU`

**What this means:**
When someone shows interest, system can play message and get response.

### Survey Audio Example:

**Opt-In Prompt:**
```
"Thank you for your interest! Press 1 to speak with a specialist now,
or press 9 to be removed from our list."
```

**Required files:**
- `survey_opt_in_audio_file` - Main opt-in prompt
- `survey_ni_audio_file` - Not interested acknowledgment
- Each file: 8kHz WAV, mono, 5-15 seconds

---

## 3. **Hold Music/Messages** (Optional but Recommended)

**When used:** While transferring to your phone (480) 560-8782

**What it should say:**
```
"Please hold while we connect you with a specialist...
[music or silence]"
```

**File specs:**
- Format: WAV or MP3
- Sample rate: 8000 Hz
- Can be longer (30-60 seconds)
- Can loop if needed

---

## 4. **No Answer Message** (Optional)

**When used:** If your opt-in phone doesn't answer

**What it should say:**
```
"We're sorry, all representatives are currently unavailable.
We'll call you back shortly. Thank you!"
```

---

## 🎙️ How to Create Audio Files

### Option 1: Record Yourself
1. Use your phone or computer mic
2. Convert to WAV 8kHz mono using:
   ```bash
   ffmpeg -i input.mp3 -ar 8000 -ac 1 output.wav
   ```

### Option 2: Text-to-Speech Services
- Amazon Polly: https://aws.amazon.com/polly/
- Google Cloud TTS: https://cloud.google.com/text-to-speech
- Responsive Voice: Free online tool

### Option 3: Professional Voice Artist
- Fiverr: $5-50 per recording
- Voices.com: Professional studio quality

---

## 📤 How to Upload Audio Files

### Method 1: Web Interface (Easiest)

1. Login: https://dialpower.team/vicidial/admin.php
2. Navigate: **Admin → Audio Store**
3. Click: **Upload Audio File**
4. Select your WAV file
5. Name it (e.g., "colorado_amd_message")
6. Click **SUBMIT**

### Method 2: SSH/SCP Upload

```bash
# Upload file to server
scp colorado_amd_message.wav root@67.198.205.116:/var/lib/asterisk/sounds/en/

# SSH in and verify
ssh root@67.198.205.116
ls -lh /var/lib/asterisk/sounds/en/colorado*
```

### Method 3: FTP Upload

```
Host: 67.198.205.116
Directory: /var/lib/asterisk/sounds/en/
User: [your FTP user]
```

---

## 🔗 Linking Audio to Campaign

### After Uploading, Configure Campaign:

**Web Interface:**
1. Admin → Campaigns → Click **4001**
2. Find these fields:
   - **AM Message Exten:** `8367` (or your audio extension)
   - **Survey Opt-In Audio:** `colorado_opt_in`
   - **Survey NI Audio:** `colorado_not_interested`
3. Click **SUBMIT**

**Database Method:**
```sql
UPDATE vicidial_campaigns
SET
  am_message_exten = 'colorado_amd_message',
  survey_opt_in_audio_file = 'colorado_opt_in',
  survey_ni_audio_file = 'colorado_not_interested'
WHERE campaign_id = '4001';
```

---

## 📋 Audio Checklist

### Must Have (Required):
- [ ] Answering machine message
- [ ] Opt-in survey prompt (if using survey system)

### Should Have (Recommended):
- [ ] Not interested acknowledgment
- [ ] Transfer hold message
- [ ] No answer voicemail

### Nice to Have (Optional):
- [ ] Multiple language versions
- [ ] Time-based messages (morning/evening greetings)
- [ ] Holiday messages

---

## 🎤 Sample Scripts

### Answering Machine Message (15 seconds)
```
"Hi, this is [Name] with [Company]. We're calling Colorado residents
about energy savings opportunities. We'll try you again soon, or
call us back at [Number]. Thank you!"
```

### Opt-In Survey Prompt (10 seconds)
```
"Press 1 to speak with a specialist about your energy options,
or press 9 if you'd like to be removed from our list."
```

### Transfer Hold Message (5 seconds)
```
"Thank you! Please hold while we connect you with a specialist..."
```

### No Answer Message (10 seconds)
```
"We're sorry, all specialists are currently busy. We'll call you
back within one business day. Thank you!"
```

---

## 🔧 Testing Audio Files

### Test Playback:
```bash
# SSH to server
ssh root@67.198.205.116

# Play audio file to test
/usr/bin/play /var/lib/asterisk/sounds/en/colorado_amd_message.wav

# Check file format
file /var/lib/asterisk/sounds/en/colorado_amd_message.wav
# Should show: RIFF (little-endian) data, WAVE audio, 8000 Hz, mono
```

### Test in Campaign:
1. Create test lead with your phone number
2. Activate campaign briefly
3. Let call go to voicemail
4. Verify message plays correctly
5. Deactivate campaign

---

## 🚨 Common Issues

### Audio Not Playing
**Cause:** Wrong format
**Fix:** Convert to 8kHz WAV mono
```bash
ffmpeg -i input.mp3 -ar 8000 -ac 1 -f wav output.wav
```

### Audio Cuts Off
**Cause:** File too long or timeout
**Fix:** Keep messages under 30 seconds

### Poor Quality
**Cause:** Low bitrate or compression
**Fix:** Use uncompressed WAV at 8kHz

---

## 📞 Missouri Campaign Audio Reference

Your template (Campaign 1022 - Missouri) uses:
- **AM Message:** `silence2seconds`
- **Survey Method:** `CALLMENU`
- **Survey Opt-In Audio:** (configured)

You can use similar setup or customize for Colorado.

---

## ⚡ Quick Setup (Minimum Required)

If you want to go live ASAP, minimum requirement:

1. **Create one AMD message** (15 seconds)
2. **Upload to Vicidial** (Web interface)
3. **Link to campaign** (am_message_exten field)
4. **Test with sample call**

That's it! Everything else is optional but recommended.

---

## 💡 Pro Tips

1. **Keep messages short** - 10-20 seconds max
2. **Speak clearly** - Phone quality, not studio quality
3. **Include callback number** - Always give way to reach you
4. **Test before launch** - Call yourself and verify
5. **Professional tone** - But friendly and conversational

---

## 📝 Next Steps

1. **Decide on message content** - What do you want to say?
2. **Record audio files** - Phone, computer, or TTS
3. **Convert to proper format** - 8kHz WAV mono
4. **Upload to Vicidial** - Web interface or SCP
5. **Link to campaign** - Update campaign settings
6. **Test!** - Call yourself and verify

---

**Need help with any of these steps? Let me know!**
