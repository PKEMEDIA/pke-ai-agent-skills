---
name: voice-commander
description: Use for Voice Commander natural language commands that trigger Make.com scenarios via webhook for the Kitty Empire OS. Handles Gmail/Drive to Legal Tracker, Drive to COVICEA Visual Log, Calendar to Content Strategy, dashboard summaries, and direct Make webhook calls. Activates on voice commander, trigger make, make webhook, orchestrate with make.com, build make scenario, or any command to automate DB population from external events.
---

# Voice Commander — Make.com Webhook Integration

## Purpose
Turn natural language commands into automated actions across Kitty Empire OS databases (Podcast Production Hub, Legal & Paralegal Tracker, COVICEA Visual Production Log, Content Strategy & Calendar, Master Dashboard) via Make.com webhook listeners.

## When to Activate
- Natural language commands involving external triggers (Gmail, Drive, Calendar) or DB pushes via Make.
- Commands like "log legal attachment from email", "auto log this Drive image to COVICEA", "schedule content from calendar", "send weekly dashboard summary", or "trigger Make scenario for [X]".
- Building or extending the 5 core automation scenarios.

## Core Capabilities
1. Parse natural language into structured payloads for specific Make scenarios.
2. Generate and (in supported environments) execute HTTP POST to Make.com webhook URLs.
3. Provide exact Make.com scenario blueprints and property mappings for the 5 priority flows.
4. Coordinate with Notion MCP tools for verification after Make runs.
5. Maintain security scoping (especially Legal Tracker) and respect Notion API rate limits.

## How to Use
1. User gives natural language command.
2. Parse intent → map to one of the 5 scenarios (see references/make-scenarios.md).
3. Construct payload (see references/payload-examples.md) and trigger Make webhook (or direct Notion if simpler).
4. Make executes heavy lifting (Gmail/Drive/Calendar parsing, complex logic).
5. Confirm result with links and next actions.
6. Use skill-orchestrator to test end-to-end after setup.

## Scenario 5 — Voice Commander Webhook (Core)
**Make Side**: Webhook trigger → router on payload "scenario" field → execute corresponding scenario actions → Webhook Response `{ "status": "ok", "notion_page_id": "xxx" }`.

**Voice Commander Side**: Construct JSON payload, POST to Make webhook URL. On success confirm with Notion page links. Fallback: direct Notion MCP create/update.

**Security & Limits**:
- Scope connections narrowly.
- Delay between Notion calls (3 req/sec).
- Legal: require confirmation before creating sensitive pages.
- Log all webhook calls in Automation Log DB.

## Setup
1. Build the 5 Make scenarios using blueprints in references/make-scenarios.md.
2. Create Webhook listener scenario first; store URL in config/env (never hardcode secrets in skill files).
3. Test with: "log this legal email as new claim" or "auto log the latest Drive COVICEA image".

## Integration
- Works alongside covicea-brand-assistant, paralegal-assistant, content-strategy-suite, episode-bible.
- Respects locked visual standards from covicea-core and covicea-distraction-image-defaults.
- Coordinates with Notion MCP for verification and fallback.
- Orchestrated by skill-orchestrator for full system tests.
- Pair with `hooks/post-tool-use-make.sh` for automatic Automation Log updates after Grok Build writes.

## References (load on demand)
- `references/make-scenarios.md` — Full blueprints for all 5 Make.com scenarios
- `references/payload-examples.md` — JSON payload examples for legal, covicea, content, dashboard
