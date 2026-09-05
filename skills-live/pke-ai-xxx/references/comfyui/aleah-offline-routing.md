# Aleah — ComfyUI Offline Routing (Free-Tier)

**Owner:** Aleah (Empire OS control plane)  
**Pairs with:** `ECOSYSTEM.md`, `pke-synthetic-intellect`, `aleah-empire-os`  
**Rule:** Local ComfyUI first. **imagine_calls = 0** on heal / learn / orchestrate. Face Lock + Black Mask stay **LOCKED**.

---

## Credit-aware router (AI-XXX gens)

```text
L0  Local ComfyUI (this machine / studio GPU)
      ↓ fail / queue blocked / VRAM too low for the job
L1  Offline sim + stills slideshow path (no cloud gen)
      ↓ still blocked AND Coviceá explicitly approves spend
L2  Rented GPU (RunPod/Vast) — download weights home; reuse
      ↓ NEVER from heal/learn loops
LX  Grok Imagine / SuperGrok Heavy — FORBIDDEN for pack ops,
      heal, learn, or "practice" gens. Brand may use Imagine
      only on a separate, human-initiated creative ask.
```

| Signal | Route |
|--------|-------|
| Free-tier / no quota burn | L0 only |
| Pack self-heal / learn cycle | Text + logs only — never call any image API |
| Entry VRAM (8 GB) | Stills @ 832–1024; slideshow teasers; defer Wan |
| Workhorse (12–16 GB) | Full stills + AnimateDiff; light Wan |
| Pro (24 GB+) | Multi-LoRA + Wan teasers |
| Cloud GPU hours | L2 only after L0/L1 fail; keep models local after |

**Hard stop:** Never invent a second company face. Never train / ref / document unlock for Face Lock or Black Mask. Male talent = new `pkemale##` cards + open weights only.

---

## Offline ComfyUI ops (Aleah expects)

1. **Workflow source of truth** — `comfyui/workflows.md` (API JSON under `comfyui/graphs/` when added).  
2. **Dry-run before GPU** — validate graph JSON + required nodes/models present; log missing deps to `runs/YYYY-MM.md`.  
3. **Batch discipline** — grid seeds locally; pick heroes; upscale winners; write `manifest.md` (ckpt, LoRAs, seeds, AI vs real).  
4. **No remote caption burn required** — use Brand post packs + board; optional local WD14/JoyCaption only.  
5. **Sim fallback** — if ComfyUI down: stills-from-cache + Ken Burns slideshow path from pipeline overview (stage 3).

Suggested local helpers (when scripts land in skill pack):

```bash
# Prefer these over any cloud gen
python3 scripts/comfy-offline-sim.py          # graph / folder sanity
bash scripts/pke-self-heal.sh                 # heal before learn
bash scripts/pke-learn.sh                     # observe → score → patch text
node scripts/aleah-validate.mjs               # structural gates
```

---

## Heal / learn hooks (AI-XXX)

Wire into `ECOSYSTEM.md` + Super Mind OODA:

| Step | Aleah action | AI-XXX artifact |
|------|--------------|-----------------|
| **HEAL** | Freeze deploys on Face Lock check fail or quality cliff | Patch prompts/notes only; never unlock locks |
| **OBSERVE** | Read `runs/YYYY-MM.md`, `current.json`, model notes | Failure classes: hands, eye-contact miss, locked-face lookalike |
| **ORIENT** | Score stills/teasers vs board shot list | Angles A–D coverage gaps |
| **DECIDE** | Prompt revision vs LoRA strength band vs neg pack | Prefer prompt/neg edits before new train |
| **ACT** | Write `prompts/vN/` + bump `current.json` | Never overwrite live set in place |
| **REMEMBER** | Append `mind/lessons.md` (text only) | Contagious winners → templates; losers → anti-patterns in `models/notes/` |
| **PUBLISH** | Optional GitHub SoT mirror | CI re-validate; `imagine_calls=0` |

### Trigger conditions (auto)

- Quality drop vs last N runs → heal freeze + prompt polish  
- Face Lock / Black Mask similarity flag → **trash seed**, change refs, log anti-pattern; never “fix” by unlocking  
- Missing README-mapped files → scaffold gap ticket (see Gaps)  
- VRAM OOM storm → route to L1 slideshow / lower res; record in run log  

### Constitutional (never auto-weaken)

- Face Lock  
- Black Mask  
- Minors ban  
- Free-tier: no Imagine inside learn/heal/orchestrate  

---

## Pairing (agents / skills)

| Role | Who |
|------|-----|
| Control plane / routing | **Aleah** (this doc) |
| Health gates | Orchestrator |
| New skill authoring | Creator |
| Contagious patterns / versioning | Ecosystem |
| Brand captions | Brand (use locked post packs; don’t freestyle this lane) |
| Talent / 2257 for *real* performers | Talent + Paralegal |
| Empire strategy | `pke-empire-os` |

---

## Acceptance for “Aleah-ready”

- [ ] Every gen job states route L0/L1/L2 before launch  
- [ ] Heal/learn cycles leave `imagine_calls=0`  
- [ ] `current.json` locks array includes `face-lock`, `black-mask`  
- [ ] Run log + model notes updated after material packs  
- [ ] No Face Lock / Black Mask assets in Comfy input folders  

---

## Version

Aleah offline routing v1 — 2026-09-05 — free-tier · local-first · locks immutable.
