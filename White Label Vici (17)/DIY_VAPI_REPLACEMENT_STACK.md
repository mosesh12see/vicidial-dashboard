# DIY VAPI Replacement Stack

## Build Your Own Voice AI Platform for 70-80% Less

**Created:** November 28, 2025
**Purpose:** Replace VAPI ($0.09/min) with self-hosted stack (~$0.025/min)

---

## The Voice AI Pipeline

```
Customer Speaks → STT (Ears) → LLM (Brain) → TTS (Mouth) → Customer Hears
       ↓              ↓             ↓             ↓              ↓
    Twilio      Deepgram      DeepSeek     ElevenLabs      Twilio
```

---

## Cost Breakdown: DIY Stack with DeepSeek

| Layer | Component | Provider | Cost/Min | Notes |
|-------|-----------|----------|----------|-------|
| **Telephony** | Phone calls | Twilio | $0.0085 | Inbound + outbound |
| | | SignalWire | $0.004 | Cheaper alternative |
| | | **Your ViciDial** | $0.003 | Already have this! |
| **STT** | Speech-to-Text | Deepgram Nova-2 | $0.0043 | Best speed/accuracy |
| | | Whisper (self-hosted) | $0.00 | Free but slower |
| | | AssemblyAI | $0.006 | Good alternative |
| **LLM** | AI Brain | **DeepSeek V3** | **$0.001** | 90% cheaper than GPT-4! |
| | | DeepSeek Chat | $0.0014 | API pricing |
| | | OpenAI GPT-4o | $0.02 | Expensive comparison |
| | | Claude 3.5 Sonnet | $0.015 | Also expensive |
| | | Groq (Llama) | $0.0005 | Fastest, very cheap |
| **TTS** | Text-to-Speech | ElevenLabs | $0.01 | Best quality |
| | | PlayHT | $0.008 | Good alternative |
| | | Cartesia | $0.006 | Low latency |
| | | Deepgram Aura | $0.005 | Same provider as STT |
| | | XTTS (self-hosted) | $0.00 | Free, requires GPU |

---

## Total Cost Comparison

### With DeepSeek Brain (Recommended)

| Component | Provider | Cost/Min |
|-----------|----------|----------|
| Telephony | SignalWire | $0.004 |
| STT | Deepgram Nova-2 | $0.0043 |
| LLM | **DeepSeek V3** | **$0.001** |
| TTS | Cartesia | $0.006 |
| **TOTAL** | | **$0.0153/min** |

### With Your ViciDial Infrastructure

| Component | Provider | Cost/Min |
|-----------|----------|----------|
| Telephony | ViciDial/Instacall | $0.003 |
| STT | Deepgram Nova-2 | $0.0043 |
| LLM | **DeepSeek V3** | **$0.001** |
| TTS | Deepgram Aura | $0.005 |
| **TOTAL** | | **$0.0133/min** |

### Comparison to Competitors

| Platform | Cost/Min | Your Savings |
|----------|----------|--------------|
| **Your DIY Stack** | **$0.013** | - |
| VAPI | $0.09 | **85% cheaper** |
| Bland AI | $0.09 | **85% cheaper** |
| Retell AI | $0.10 | **87% cheaper** |
| Synthflow | $0.12 | **89% cheaper** |

---

## DeepSeek: Why It's the Best Brain

### Pricing (as of Nov 2025)

| Model | Input Cost | Output Cost | Per Min (est) |
|-------|------------|-------------|---------------|
| DeepSeek V3 | $0.14/1M tokens | $0.28/1M tokens | ~$0.001 |
| DeepSeek Chat | $0.27/1M tokens | $1.10/1M tokens | ~$0.0014 |
| GPT-4o | $5.00/1M tokens | $15.00/1M tokens | ~$0.02 |
| Claude 3.5 | $3.00/1M tokens | $15.00/1M tokens | ~$0.015 |

**DeepSeek is 10-20x cheaper than OpenAI/Anthropic!**

### DeepSeek API Setup

```bash
# Base URL
https://api.deepseek.com/v1

# Models available
deepseek-chat        # General conversation
deepseek-coder       # Code-focused
deepseek-reasoner    # Complex reasoning (R1)
```

### API Example (OpenAI-compatible)

```python
from openai import OpenAI

client = OpenAI(
    api_key="your-deepseek-api-key",
    base_url="https://api.deepseek.com/v1"
)

response = client.chat.completions.create(
    model="deepseek-chat",
    messages=[
        {"role": "system", "content": "You are a friendly sales agent..."},
        {"role": "user", "content": transcribed_audio}
    ],
    max_tokens=150,  # Keep short for voice
    temperature=0.7
)
```

---

## Open Source Frameworks

### 1. Vocode (Python)

**Best for:** Custom deployments, full control

```bash
pip install vocode
```

```python
from vocode.streaming.agent.chat_gpt_agent import ChatGPTAgent
from vocode.streaming.models.agent import ChatGPTAgentConfig
from vocode.streaming.synthesizer.eleven_labs_synthesizer import ElevenLabsSynthesizer
from vocode.streaming.transcriber.deepgram_transcriber import DeepgramTranscriber

# Configure with DeepSeek
agent_config = ChatGPTAgentConfig(
    initial_message="Hello! How can I help you today?",
    prompt_preamble="You are a helpful sales agent...",
    model_name="deepseek-chat",
    base_url="https://api.deepseek.com/v1"
)
```

**GitHub:** https://github.com/vocodedev/vocode-python

---

### 2. Pipecat (Daily.co)

**Best for:** Production-grade, WebRTC

```bash
pip install pipecat-ai
```

```python
from pipecat.pipeline import Pipeline
from pipecat.services.deepgram import DeepgramSTT, DeepgramTTS
from pipecat.services.openai import OpenAILLM

# Use DeepSeek as drop-in OpenAI replacement
llm = OpenAILLM(
    api_key="your-deepseek-key",
    base_url="https://api.deepseek.com/v1",
    model="deepseek-chat"
)

pipeline = Pipeline([
    DeepgramSTT(),
    llm,
    DeepgramTTS()  # Or ElevenLabs
])
```

**GitHub:** https://github.com/pipecat-ai/pipecat

---

### 3. Livekit Agents

**Best for:** Low latency, WebRTC-native

```bash
pip install livekit-agents
```

```python
from livekit.agents import AutoSubscribe, JobContext, WorkerOptions, cli
from livekit.agents.llm import openai

# DeepSeek via OpenAI-compatible API
llm = openai.LLM(
    model="deepseek-chat",
    api_key="your-deepseek-key",
    base_url="https://api.deepseek.com/v1"
)
```

**GitHub:** https://github.com/livekit/agents

---

### 4. Ultravox (Speech-to-Speech)

**Best for:** Lowest latency, skips STT→LLM→TTS chain

Ultravox is a **direct speech-to-speech model** - no transcription needed!

```python
import ultravox

client = ultravox.Client(api_key="your-ultravox-key")

# Direct audio in → audio out
response = client.chat(
    audio=audio_bytes,
    voice_id="zach-cloned-voice"
)
```

**Pricing:** ~$0.12/min (higher but faster)
**Website:** https://ultravox.ai

---

## Complete DIY Architecture

### Option A: Maximum Savings (Self-Hosted)

```
┌─────────────────────────────────────────────────────────────┐
│                    YOUR INFRASTRUCTURE                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│   │ ViciDial │───▶│ Asterisk │───▶│ WebSocket│             │
│   │ Dialer   │    │ PBX      │    │ Bridge   │             │
│   └──────────┘    └──────────┘    └────┬─────┘             │
│                                        │                    │
│                                        ▼                    │
│   ┌─────────────────────────────────────────────────────┐  │
│   │              VOICE AI ORCHESTRATOR                   │  │
│   │         (Vocode / Pipecat / Custom Node.js)         │  │
│   └───────────┬─────────────┬─────────────┬─────────────┘  │
│               │             │             │                 │
│               ▼             ▼             ▼                 │
│   ┌───────────────┐ ┌─────────────┐ ┌───────────────┐     │
│   │   Deepgram    │ │  DeepSeek   │ │  ElevenLabs   │     │
│   │   STT API     │ │  LLM API    │ │   TTS API     │     │
│   │  $0.004/min   │ │ $0.001/min  │ │  $0.01/min    │     │
│   └───────────────┘ └─────────────┘ └───────────────┘     │
│                                                              │
│   TOTAL: ~$0.015/min                                        │
└─────────────────────────────────────────────────────────────┘
```

### Option B: Managed + APIs

```
┌─────────────────────────────────────────────────────────────┐
│                                                              │
│   ┌──────────┐         ┌──────────────────────────────┐    │
│   │  Twilio  │────────▶│     Twilio Media Streams     │    │
│   │  Number  │         │     (WebSocket audio)        │    │
│   └──────────┘         └──────────────┬───────────────┘    │
│                                        │                    │
│                                        ▼                    │
│   ┌─────────────────────────────────────────────────────┐  │
│   │           YOUR SERVER (Node.js / Python)            │  │
│   │                                                      │  │
│   │   Audio In ──▶ Deepgram STT ──▶ DeepSeek LLM       │  │
│   │                                      │               │  │
│   │   Audio Out ◀── ElevenLabs TTS ◀────┘               │  │
│   │                                                      │  │
│   └─────────────────────────────────────────────────────┘  │
│                                                              │
│   TOTAL: ~$0.025/min                                        │
└─────────────────────────────────────────────────────────────┘
```

---

## Quick Start: Node.js Implementation

### 1. Install Dependencies

```bash
npm init -y
npm install @deepgram/sdk openai elevenlabs ws express
```

### 2. Environment Variables

```env
# .env
DEEPGRAM_API_KEY=your_deepgram_key
DEEPSEEK_API_KEY=your_deepseek_key
ELEVENLABS_API_KEY=your_elevenlabs_key
TWILIO_ACCOUNT_SID=your_twilio_sid
TWILIO_AUTH_TOKEN=your_twilio_token
```

### 3. Basic Voice Agent Server

```javascript
// server.js
const express = require('express');
const WebSocket = require('ws');
const { Deepgram } = require('@deepgram/sdk');
const OpenAI = require('openai');

const app = express();

// Initialize clients
const deepgram = new Deepgram(process.env.DEEPGRAM_API_KEY);

const deepseek = new OpenAI({
  apiKey: process.env.DEEPSEEK_API_KEY,
  baseURL: 'https://api.deepseek.com/v1'
});

// WebSocket server for Twilio Media Streams
const wss = new WebSocket.Server({ port: 8080 });

wss.on('connection', (ws) => {
  console.log('New call connected');

  // Deepgram live transcription
  const dgConnection = deepgram.transcription.live({
    punctuate: true,
    interim_results: false,
    language: 'en-US'
  });

  dgConnection.on('transcriptReceived', async (transcript) => {
    const text = transcript.channel?.alternatives[0]?.transcript;
    if (!text) return;

    console.log('User said:', text);

    // Get DeepSeek response
    const response = await deepseek.chat.completions.create({
      model: 'deepseek-chat',
      messages: [
        { role: 'system', content: 'You are a friendly sales agent. Keep responses under 2 sentences.' },
        { role: 'user', content: text }
      ],
      max_tokens: 100
    });

    const aiResponse = response.choices[0].message.content;
    console.log('AI says:', aiResponse);

    // TODO: Send to ElevenLabs TTS, then back to Twilio
  });

  ws.on('message', (message) => {
    const data = JSON.parse(message);
    if (data.event === 'media') {
      // Send audio to Deepgram
      dgConnection.send(Buffer.from(data.media.payload, 'base64'));
    }
  });
});

app.listen(3000, () => console.log('Server running on 3000'));
```

---

## API Keys You Need

| Service | Get Key At | Free Tier |
|---------|-----------|-----------|
| **DeepSeek** | https://platform.deepseek.com | $5 credit |
| **Deepgram** | https://console.deepgram.com | $200 credit |
| **ElevenLabs** | https://elevenlabs.io | 10k chars/mo |
| **Twilio** | https://console.twilio.com | $15 credit |
| **SignalWire** | https://signalwire.com | Free trial |

---

## Your Existing Keys (from your files)

```
ElevenLabs:  sk_f6bc11d5d056d6ae... (Claude Spanish Laura)
Deepgram:    86712d47018ee58e... (Claude Helper)
OpenAI:      sk-proj-CUuyXFM8yb5q... (can switch to DeepSeek)
Vapi:        4abc544c-f4ba-4823... (for comparison)
```

**Add DeepSeek:** https://platform.deepseek.com/api_keys

---

## Migration Path: VAPI → DIY

### Phase 1: Test (Week 1)
1. Get DeepSeek API key
2. Set up basic Vocode/Pipecat server
3. Test with single inbound number
4. Compare latency and quality

### Phase 2: Parallel Run (Week 2-3)
1. Run DIY alongside VAPI
2. A/B test same conversations
3. Measure cost per call
4. Track conversion rates

### Phase 3: Migrate (Week 4+)
1. Move campaigns one at a time
2. Start with low-value leads
3. Expand to all campaigns
4. Shut down VAPI

---

## Cost Savings Calculator

```
Monthly Call Volume: 10,000 minutes

VAPI Cost:
  10,000 × $0.09 = $900/month

DIY Stack Cost:
  10,000 × $0.015 = $150/month

MONTHLY SAVINGS: $750
ANNUAL SAVINGS: $9,000

At 50,000 minutes/month:
  VAPI: $4,500/month
  DIY:  $750/month
  SAVINGS: $3,750/month = $45,000/year
```

---

## Recommended Stack Summary

| Layer | Provider | Why |
|-------|----------|-----|
| **Telephony** | Your ViciDial + Instacall | Already have it, cheapest |
| **STT** | Deepgram Nova-2 | Best speed + accuracy |
| **LLM** | **DeepSeek V3** | 90% cheaper, great quality |
| **TTS** | ElevenLabs or Cartesia | Best voices |
| **Framework** | Pipecat or Vocode | Production-ready |

**Final Cost: ~$0.013-0.025/min**
**vs VAPI: $0.09/min**
**Savings: 70-85%**

---

## Next Steps

1. [ ] Sign up for DeepSeek API
2. [ ] Clone this repo and configure
3. [ ] Test with single number
4. [ ] Measure latency (<500ms target)
5. [ ] Compare quality to VAPI
6. [ ] Migrate campaigns

---

## Resources

- **Vocode Docs:** https://docs.vocode.dev
- **Pipecat Docs:** https://docs.pipecat.ai
- **DeepSeek API:** https://platform.deepseek.com/api-docs
- **Deepgram Docs:** https://developers.deepgram.com
- **ElevenLabs Docs:** https://docs.elevenlabs.io

---

*Built for White Label ViciDial Platform | November 2025*
