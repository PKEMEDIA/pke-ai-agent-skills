# AI-XXX Pack Changelog

## 2026-09-05 — scaffold
- Initial pack dirs + README
- Ecosystem self-heal schema: prompt versioning (`prompts/vN/`), `current.json`, model notes, run logs
- Locked: Face Lock + Black Mask (never train/unlock)
- Aleah: `comfyui/aleah-offline-routing.md` (free-tier Comfy router + heal/learn hooks)

## 2026-09-05 — v1 ready
- Pack bodies landed (prompts, comfyui, compliance, checklists)
- Skill `pke-ai-xxx` saved (/pke-ai-xxx)
- prompts/v1 pinned via current.json

## 2026-09-05 — Aleah gaps closed
- Seeded prompts/v1, runs/2026-09.md, models/notes/pkemale01 (+ yaml)
- comfyui/graphs/ placeholder for API JSON exports
- current.json status=ready; skill pke-ai-xxx saved

## 2026-09-06 — Aleah graph fix
- Added `comfyui/graphs/stills-grid.json` + `animatediff-teaser.json` (template-api)
- Added `validate-graphs.py` offline structure check (imagine_calls=0)
- Shoot-day checklist: Face Lock abort → deploy freeze + Orchestrator/Aleah ownership

## 2026-09-19 — ecosystem loop polish
- Expanded `ECOSYSTEM.md` from bullet list into operable runbook (prompt bump, current.json, CHANGELOG, model notes, run log, heal/freeze, contagious promotion, GitHub SoT, Aleah routing)
- Added `scripts/heal-check.sh` + `scripts/heal-check.py` (pins, required files, Face Lock / Black Mask LOCKED checks, graph validate)
- Added `models/notes/_TEMPLATE.md`; `prompts/README.md` (root = live mirror of `current.json` pin)
- Verified root `prompts/*.md` identical to `prompts/v1/` (checksums match); no sync rewrite needed
- `current.json`: `updated=2026-09-19`, `ecosystem_loop=active`, locks unchanged, status=ready
- heal-check PASS; GitHub SoT synced to `skills-live/pke-ai-xxx/references/` on PKEMEDIA/pke-ai-agent-skills main
