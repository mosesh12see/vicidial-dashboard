# 🎙️ Vicidial AI Audio Files Inventory

**Generated:** October 30, 2025
**Location:** Audio files stored on server at `/var/lib/asterisk/sounds/en/`

---

## 📊 AUDIO FILES IN USE

### 1. **AaronAmarenIllinois.wav**
- **Type:** Survey First Audio
- **Used by:** Campaign 1028 (Illinois Inbound)
- **Purpose:** Initial survey message for Illinois energy customers
- **Format:** 16-bit Mono 8kHz PCM WAV

### 2. **AylaHannahGeorgiaPower.wav**
- **Type:** Survey First Audio
- **Used by:** Campaign 1027 (Georgia Inbound)
- **Purpose:** Initial survey message for Georgia Power customers
- **Format:** 16-bit Mono 8kHz PCM WAV

### 3. **HannahStLouisMissouriAmeren.wav**
- **Type:** Survey First Audio
- **Used by:**
  - Campaign 1022 (St Louis Inbound)
  - Campaign 4001 (Moses Claude Colorado) ← YOUR NEW CAMPAIGN
- **Purpose:** Initial survey message for Missouri Ameren customers
- **Format:** 16-bit Mono 8kHz PCM WAV

### 4. **Wrapup Call.wav**
- **Type:** Wrapup Message
- **Used by:** Multiple campaigns (0001, 0002, 1022, 1027, 1028, 4001)
- **Purpose:** Message played during call wrapup phase
- **Format:** 16-bit Mono 8kHz PCM WAV

### 5. **jerseysincere.wav**
- **Type:** Survey First Audio
- **Used by:**
  - Campaign 0001 (TEST Confirmation)
  - Campaign 0002 (Georgia Confirmation)
- **Purpose:** Survey audio for New Jersey campaigns
- **Format:** 16-bit Mono 8kHz PCM WAV

### 6. **silence2seconds.wav**
- **Type:** Answering Machine Message
- **Used by:** Campaigns 1022, 1027, 1028, 4001
- **Purpose:** 2-second silence (no voicemail left, just hangs up)
- **Format:** 16-bit Mono 8kHz PCM WAV
- **Note:** Most campaigns use this to NOT leave messages on machines

---

## 🎯 AUDIO TYPES EXPLAINED

### Answering Machine (AM) Message
- **Field:** `am_message_exten`
- **When it plays:** When dialer reaches an answering machine/voicemail
- **Common practice:** Use `silence2seconds` to hang up without leaving message
- **Alternative:** Record actual message to leave on voicemail

### Survey Audio Files
- **Fields:** `survey_first_audio_file`, `survey_opt_in_audio_file`, etc.
- **When it plays:** During IVR survey prompts
- **Purpose:** Interactive voice response for customer interaction

### Wrapup Message
- **Field:** `wrapup_message`
- **When it plays:** During agent call wrapup phase
- **Purpose:** Message to agent or customer during wrapup

---

## 📥 HOW TO RETRIEVE FILES

**When SSH is available, run:**

```bash
# Navigate to audio folder
cd "/Users/mosesherrera/Desktop/vicidial-analysis/Claude Vici Creations/Ai Audios Vici"

# Download all files
scp root@67.198.205.116:/var/lib/asterisk/sounds/en/AaronAmarenIllinois.wav .
scp root@67.198.205.116:/var/lib/asterisk/sounds/en/AylaHannahGeorgiaPower.wav .
scp root@67.198.205.116:/var/lib/asterisk/sounds/en/HannahStLouisMissouriAmeren.wav .
scp root@67.198.205.116:/var/lib/asterisk/sounds/en/"Wrapup Call.wav" .
scp root@67.198.205.116:/var/lib/asterisk/sounds/en/jerseysincere.wav .
scp root@67.198.205.116:/var/lib/asterisk/sounds/en/silence2seconds.wav .
```

**Or use the automated script:**
```bash
cd "/Users/mosesherrera/Desktop/vicidial-analysis/Claude Vici Creations/Ai Audios Vici"
./download_audio_files.sh
```

---

## 🎙️ CREATING NEW AUDIO FILES

### Required Format
```
Format: WAV
Bit Depth: 16-bit
Channels: Mono (1 channel)
Sample Rate: 8000 Hz (8 kHz)
Encoding: PCM (uncompressed)
```

### Conversion Command
```bash
# Convert any audio file to Vicidial format
ffmpeg -i input.mp3 -ar 8000 -ac 1 -acodec pcm_s16le output.wav
```

### Upload to Server
```bash
# Upload new audio file
scp colorado_message.wav root@67.198.205.116:/var/lib/asterisk/sounds/en/

# Or via web interface
# Admin → Audio Store → Upload Audio File
```

---

## 🔗 YOUR COLORADO CAMPAIGN (4001)

**Currently using:**
- AM Message: `silence2seconds.wav` (no voicemail message)
- Wrapup: `Wrapup Call.wav`
- Survey: `HannahStLouisMissouriAmeren.wav`

**To customize:**
1. Create new audio file for Colorado
2. Convert to proper format
3. Upload via Admin → Audio Store
4. Update campaign: Admin → Campaigns → 4001 → AM Message Exten

---

## 📊 AUDIO FILE STATUS

| Filename | Size | Status |
|----------|------|--------|
| AaronAmarenIllinois.wav | TBD | To Download |
| AylaHannahGeorgiaPower.wav | TBD | To Download |
| HannahStLouisMissouriAmeren.wav | TBD | To Download |
| Wrapup Call.wav | TBD | To Download |
| jerseysincere.wav | TBD | To Download |
| silence2seconds.wav | TBD | To Download |

**Note:** Files will be downloaded when server SSH access is available.

---

**Last Updated:** October 30, 2025
**Server:** 67.198.205.116
**Path:** /var/lib/asterisk/sounds/en/
