# Audio Generation Guide for Vicidial IVR

## ⏱️ Target Duration

**Average Duration:** 22.22 seconds
**Target Range:** 20-24 seconds (±2 seconds from average)

### Reference Files:
- SophieOGEandPSO copy.wav: 23.71 seconds
- KevanConsumers copy.wav: 21.21 seconds
- HannahStLouisMissouriAmeren copy.wav: 24.91 seconds
- AaronColoradoElectric copy.wav: 19.06 seconds

**IMPORTANT:** Keep all new audio files between 20-24 seconds for consistency with existing IVR system.

---

## 📝 Script Length Guidelines

**Word Count Target:** ~55-75 words (for 20-24 second duration)
**Speaking Rate:** ~3 words per second (conversational pace)

**Template Structure:**
1. **Opening (3-5 seconds):** Company identification
2. **Message Body (10-12 seconds):** Program details/benefits
3. **Call-to-Action (5-7 seconds):** Clear instruction (press 1)

---

## 🗣️ Pronunciation Guide

### Utility Company Names

#### Ameren
**Correct Pronunciation:** AM-ren (verified via extensive testing)
**Spelling for ElevenLabs:** "Ammren" (double M, no middle E)
**Phonetic:** AM-ren (compact, 2 syllables)
**Example:** "This is a call for Ammren customers"

**Testing Results:**
- ❌ "Ameren" - standard spelling, pronunciation too soft
- ❌ "Amaren" - pronunciation incorrect
- ❌ "Amerren" - too much emphasis on R
- ✅ "Ammren" - PERFECT MATCH to original HannahStLouisMissouriAmeren.wav

**CRITICAL:** Always spell as "Ammren" (double M, no middle E) in ElevenLabs scripts to match the original professional recordings exactly.

---

## Other Common Terms

### HVAC
**Pronunciation:** H-V-A-C (spell out each letter)
**Alternative:** "heating and cooling system"

### Rebate
**Pronunciation:** REE-bate

### Efficiency
**Pronunciation:** eh-FISH-en-see

---

**Last Updated:** October 31, 2025
**Used in Files:** Moses 3.wav (Ameren Missouri)
