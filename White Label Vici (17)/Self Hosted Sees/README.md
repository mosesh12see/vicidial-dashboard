# SEES Voice AI Platform

**Self-hosted alternative to Vapi, Bland.ai, and Retell**
**Uses YOUR VICIdial + Instacall carriers - NOT Twilio!**

## Cost Comparison

| Platform | Cost/min | Your Savings |
|----------|----------|--------------|
| **SEES (this)** | **$0.020** | - |
| Vapi | $0.12 | **83% cheaper** |
| Bland.ai | $0.07 | **71% cheaper** |
| Retell | $0.08 | **75% cheaper** |

## Your Stack

| Component | Service | Cost/min |
|-----------|---------|----------|
| Telephony | **VICIdial + Instacall** | $0.005 |
| Speech-to-Text | Deepgram Nova-2 | $0.004 |
| LLM | DeepSeek | $0.001 |
| Text-to-Speech | ElevenLabs | $0.010 |
| **TOTAL** | | **$0.020** |

## Capacity

- **500,000 calls/day** through your VICIdial infrastructure
- No per-seat licensing like Vapi
- Your carriers, your rates

## Quick Start

### 1. Install Dependencies

```bash
cd "Self Hosted Sees"
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### 2. API Keys (Already Configured!)

All keys are pre-configured in `config/settings.py`:
- [x] VICIdial API (67.198.205.116)
- [x] Deepgram (Nova-2)
- [x] DeepSeek (LLM)
- [x] ElevenLabs (TTS)
- [x] Twilio (backup only)

### 3. Run Locally

```bash
# Start the server
uvicorn main:app --host 0.0.0.0 --port 8080

# In another terminal, expose with ngrok
ngrok http 8080
```

### 4. Configure VICIdial Remote Agent

In VICIdial admin, create a remote agent:
- Remote Agent ID: `3001`
- Conf Exten: `523` + your callback URL
- Campaigns: Your campaign IDs
- Lines: 5+

## API Usage

### Create an Agent

```bash
curl -X POST http://localhost:8080/api/agents \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Bill Maxwell",
    "system_prompt": "You are Bill Maxwell, a solar sales agent...",
    "voice_id": "MZECTTgPz0j9by6lkz2a",
    "first_message": "Good morning, this is Bill Maxwell."
  }'
```

### List Agents

```bash
curl http://localhost:8080/api/agents
```

### Make Outbound Call (via VICIdial)

```bash
curl -X POST http://localhost:8080/api/calls/outbound \
  -H "Content-Type: application/json" \
  -d '{
    "to_number": "+1234567890",
    "agent_id": "your-agent-id",
    "campaign_id": "SOLAR_OUTBOUND"
  }'
```

### List VICIdial Campaigns

```bash
curl http://localhost:8080/api/vicidial/campaigns
```

### Get Active Calls

```bash
curl http://localhost:8080/api/calls/active
```

### Check Costs

```bash
curl http://localhost:8080/api/costs
```

## Architecture

```
┌─────────────────┐     ┌─────────────┐     ┌─────────────┐
│    VICIdial     │────▶│  SEES API   │────▶│   Agent     │
│  + Instacall    │     │  (FastAPI)  │     │  Manager    │
│  (Your Carriers)│     │             │     │             │
└─────────────────┘     └─────────────┘     └─────────────┘
         │                     │
         │                     ▼
         │        ┌────────────────────────┐
         │        │     Voice Pipeline     │
         │        │  ┌──────┐  ┌──────┐   │
         │        │  │ STT  │─▶│ LLM  │   │
         │        │  │Deepgr│  │DeepSk│   │
         │        │  └──────┘  └──────┘   │
         │        │       │         │      │
         │        │       ▼         ▼      │
         │        │     ┌──────────────┐   │
         │        │     │     TTS      │   │
         │        │     │  ElevenLabs  │   │
         │        │     └──────────────┘   │
         │        └────────────────────────┘
         │                     │
         └─────────────────────┘
              Audio Stream
```

## Call Flow

1. **Outbound**: SEES API → VICIdial → Instacall Carrier → Customer Phone
2. **When Answered**: VICIdial transfers to Remote Agent (SEES extension 3001)
3. **AI Handles**:
   - Audio → Deepgram (STT) → DeepSeek (LLM) → ElevenLabs (TTS) → Audio
4. **End**: VICIdial logs the call, SEES tracks costs

## Docker Deployment

```bash
cd docker
docker-compose up -d
```

## Production Deployment

### Option 1: Render.com

1. Create new Web Service
2. Connect your GitHub repo
3. Set environment variables
4. Deploy

### Option 2: Railway

```bash
railway init
railway up
```

### Option 3: Your Own Server

Since you have VICIdial running, deploy SEES on the same network:

```bash
# On your VICIdial server or nearby
git clone <your-repo>
cd "Self Hosted Sees"
pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8080
```

## Files

```
Self Hosted Sees/
├── main.py                     # Main FastAPI app (v2.0 - VICIdial)
├── requirements.txt            # Python dependencies
├── config/
│   └── settings.py             # VICIdial + API keys
├── src/
│   ├── voice/
│   │   └── agent.py            # Pipecat voice agent
│   └── telephony/
│       ├── vicidial_handler.py # VICIdial API + AGI
│       └── twilio_handler.py   # Twilio (backup)
├── docker/
│   ├── Dockerfile
│   └── docker-compose.yml
├── agents/                     # Agent configurations (JSON)
│   └── bill_maxwell.json
├── logs/                       # Call logs
└── scripts/                    # Utility scripts
```

## VICIdial Integration Details

### Server
- IP: `67.198.205.116`
- API: `http://67.198.205.116/vicidial/non_agent_api.php`
- Database: `asterisk` on port 3306

### Remote Agents
- Extensions: 3001-3050
- Conf Exten Prefix: `523` (Instacall routing)
- Lines per agent: 5

### Carrier
- Provider: Instacall/Bytworth
- Rate: ~$0.005/min wholesale

## Migrate from Vapi

1. Export your Vapi agent system prompts
2. Create agents here with same prompts
3. Configure VICIdial remote agents
4. Test with a few calls
5. Switch campaigns to use SEES
6. Save 83% on costs!

## API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/` | GET | Health check |
| `/api/agents` | GET/POST | List/Create agents |
| `/api/agents/{id}` | GET/PUT/DELETE | Agent CRUD |
| `/api/calls/outbound` | POST | Make call via VICIdial |
| `/api/calls/active` | GET | List active calls |
| `/api/calls/{id}` | GET | Call status |
| `/api/calls/{id}/hangup` | POST | End call |
| `/api/vicidial/campaigns` | GET | List VICIdial campaigns |
| `/api/leads` | POST | Add lead to VICIdial |
| `/api/costs` | GET | Cost breakdown |
| `/ws/call/{agent_id}` | WS | Real-time voice |

## Support

Built for SEES by Claude Code.

**Your Competitive Edge:**
- Cost: ~$0.020/min (vs Vapi $0.12/min)
- Savings: 83%
- Capacity: 500K calls/day
- Infrastructure: Your own (no vendor lock-in)
