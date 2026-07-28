# Voice Commander × Make.com — PostToolUse Hook Recipe

Wire Grok Build lifecycle hooks to Kitty Empire OS via Make.com (Voice Commander Scenario 5).

## Goal
After successful tool use (file writes, key bash jobs), notify Make so Notion Automation Log / COVICEA Visual Log / Legal Tracker stay current without manual commands.

## 1. Make.com side (Scenario 5 extension)

1. Open or create the **Webhook** listener scenario (instant trigger).
2. Copy the webhook URL → store as env `MAKE_WEBHOOK_URL` (never commit).
3. Add a **Router** on `scenario` field:
   - `automation_log` → create page in Automation Log DB
   - `legal` → Legal Tracker (Scenario 1)
   - `covicea` → COVICEA Visual Log (Scenario 2)
   - `content` → Content Strategy (Scenario 3)
   - `dashboard` → summary path (Scenario 4)
4. End with **Webhook Response**: `{ "status": "ok", "notion_page_id": "..." }`
5. Rate-limit Notion modules (~3 req/sec). Legal routes require confirmation filter.

## 2. Grok Build hook install

```bash
mkdir -p ~/.grok/hooks
cp hooks/post-tool-use-make.sh ~/.grok/hooks/
chmod +x ~/.grok/hooks/post-tool-use-make.sh
export MAKE_WEBHOOK_URL="https://hook.eu1.make.com/YOUR_ID"
```

Project-scoped (requires `/hooks-trust` in TUI once):

```bash
mkdir -p .grok/hooks
cp hooks/post-tool-use-make.sh .grok/hooks/
chmod +x .grok/hooks/post-tool-use-make.sh
```

## 3. Payload shape

```json
{
  "command": "post_tool_use",
  "scenario": "automation_log",
  "source": "grok-build-hook",
  "notion_db": "automation-log",
  "data": { "tool": "Write", "status": "ok" }
}
```

## 4. Security
- Scope Make Gmail/Drive connections to labeled folders only.
- Never put webhook URL in SKILL.md or public git.
- Legal pages: human confirmation before create.
- Log every webhook in Automation Log for audit.
