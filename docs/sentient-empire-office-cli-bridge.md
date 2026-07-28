# Bridge: Grok Build CLI → SentientEmpireOffice (iOS / Mac)

Connect headless Grok Build automation to the native SwiftUI app (Sentient) and Mac Compile Studio backend.

## Architecture

```
iOS / Mac UI (SentientEmpireOffice)
        │  HTTPS / local URLSession
        ▼
Mac Pro edge helper (launchd)  ──OR──  Cloudflare Worker
        │  shell + env XAI_API_KEY
        ▼
grok -p / -s / agent stdio     +    ~/.grok/skills/
        │
        ▼
scripts/empire-validate.sh · safe-ci-review.sh · session-empire-nightly.sh
        │
        ▼
Make.com webhook (Voice Commander) → Notion Empire OS DBs
```

## Mac Pro launchd
- WorkingDirectory: repo with `.grok/skills`
- Env: `XAI_API_KEY`, `MAKE_WEBHOOK_URL` (Keychain preferred)
- Nightly: `session-empire-nightly.sh` via StartCalendarInterval

## iOS Sentient mappings
| UI action | CLI mapping |
| --- | --- |
| Validate skills | edge → empire-validate.sh |
| Empire summary | session-empire-nightly.sh |
| Log visual asset | Voice Commander scenario=covicea |
| Legal intake | scenario=legal (confirm required) |
| PR review | safe-ci-review.sh |

Never embed XAI_API_KEY in the iOS binary. App sends signed intent; Mac/Worker runs grok.

## ACP embed
`grok agent stdio` — JSON-RPC initialize → authenticate → session/new → session/prompt; stream session/update into SwiftUI.

## Security
- No API keys in IPA or public git
- Legal routes require explicit UI confirm
- Sandbox/allow rules on CI review path
- Audit Make webhooks in Automation Log DB
