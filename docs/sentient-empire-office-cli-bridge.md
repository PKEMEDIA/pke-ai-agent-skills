# Bridge: Grok Build CLI → SentientEmpireOffice (iOS / Mac)

Connect headless Grok Build automation to the native SwiftUI app (Sentient) and Mac Compile Studio backend.

## Architecture

```
iOS / Mac UI (SentientEmpireOffice)
        │  HTTPS / local URLSession
        ▼
Mac Pro edge (Compile Studio :8778)  ──OR──  Cloudflare Worker (studio.covicea.com)
        │  shell + env XAI_API_KEY (Keychain / launchd)
        ▼
grok -p / -s / agent stdio     +    ~/.grok/skills/
        │
        ▼
scripts/empire-validate.sh · safe-ci-review.sh · session-empire-nightly.sh
        │
        ▼
Make.com webhook (Voice Commander) → Notion Empire OS DBs
        │
        ▼
hooks/post-tool-use-make.sh (optional Automation Log side-channel)
```

## Mac Pro ports (from SentientEmpireOffice)

| Service | Port |
| --- | --- |
| Compile Studio | 8778 |
| Vault TV | 8765 |
| Family TV | 8766 |
| SMM Panel | 8780 |
| Sentient Hub | 8782 |
| ComfyUI | 8188 |

## Edge helper (launchd)

Add `com.covicea.grok-cli-edge.plist` (or extend `com.covicea.grok-watch`):

```xml
<!-- sketch: StartCalendarInterval nightly 08:00 local -->
<!-- ProgramArguments: bash /path/to/scripts/session-empire-nightly.sh -->
<!-- EnvironmentVariables: XAI_API_KEY from Keychain loader, MAKE_WEBHOOK_URL -->
<!-- WorkingDirectory: clone of pke-ai-agent-skills or ~/.grok -->
```

Install (one-shot):

```bash
bash deploy/setup-grok-cli-bridge.sh
# or:
git clone https://github.com/PKEMEDIA/pke-ai-agent-skills.git ~/pke-ai-agent-skills
mkdir -p ~/.grok/skills ~/.grok/hooks
cp -r ~/pke-ai-agent-skills/{skill-creator,skill-orchestrator,pke-empire-os,voice-commander} ~/.grok/skills/
cp ~/pke-ai-agent-skills/hooks/post-tool-use-make.sh ~/.grok/hooks/
chmod +x ~/.grok/hooks/post-tool-use-make.sh ~/pke-ai-agent-skills/scripts/*.sh
```

## Compile Studio API mapping (recommended)

| iOS / Hub action | Edge route | CLI |
| --- | --- | --- |
| Validate skills | `POST /api/grok/validate` | `empire-validate.sh ~/.grok/skills` |
| Empire summary | `POST /api/grok/empire-summary` | `session-empire-nightly.sh` |
| Log visual asset | `POST /api/grok/voice` body.scenario=covicea | Voice Commander webhook |
| Legal intake | `POST /api/grok/voice` body.scenario=legal | scenario=legal (+ confirm) |
| PR review | `POST /api/grok/ci-review` | `safe-ci-review.sh` |

Never embed `XAI_API_KEY` in the iOS binary. App sends signed intent; Mac/Worker runs `grok`.

## ACP embed (optional permanent agent)

```bash
grok agent stdio
# JSON-RPC: initialize → authenticate → session/new → session/prompt
# Stream session/update agent_message_chunk into SwiftUI Concierge / Dashboard
```

Pair with existing `Sentient/Concierge/` router for natural-language empire commands.

## grok-watch integration

`deploy/grok-watch.sh` already heals Compile Studio / ComfyUI / tunnels.
Optional: after successful heal, if `empire_work_allowed`, run:

```bash
bash ~/pke-ai-agent-skills/scripts/empire-validate.sh ~/.grok/skills >>"$LOG" 2>&1 || true
```

Cooldown-limit (e.g. 6h) to avoid quota burn.

## Security
- No API keys in IPA or public git
- Legal routes require explicit UI confirm
- Sandbox/allow rules on CI review path
- Audit Make webhooks in Automation Log DB
- Prefer Keychain / launchd EnvironmentVariables over plaintext env files
