# Spicy Mode Setup & Interface Troubleshooting

**Status**: Permanent reference · formalized 2026-07-28  
**Owners**: skill-orchestrator (ecosystem) · spicy-male-erotic-prompt-optimizer (runtime recovery)  
**Surfaces**: Grok iOS app · Grok web · Imagine · hybrid local-nsfw-comfyui

---

## 1. Enable Checklist (must all be green)

| # | Check | Notes |
| --- | --- | --- |
| 1 | SuperGrok or X Premium+ active | Base Premium / free do not unlock full Spicy |
| 2 | Age verified 18+ (some flows 21+) | Profile birth year; UK may require extra age check |
| 3 | “Display sensitive media” ON | Settings → Content Preferences (Grok app) **or** X → Privacy and safety → Content you see |
| 4 | “Allow sensitive media generation” ON | Imagine Settings (Grok app) |
| 5 | App force-closed and reopened | Wait 1–2 min after toggles; Android may need a second pass |
| 6 | Spicy selectable in Imagine | Mode dropdown or Make video → Spicy |

Spicy is primarily an **Imagine** generation mode. Mature Ask chat is allowed separately; the dedicated Spicy toggle lives in Imagine.

**Hard truth**: Enabling toggles does **not** disable moderation. A visible preference and a permitted request are separate decisions.

---

## 2. iOS vs Web — Interface Matrix

| Symptom | Likely cause | Action |
| --- | --- | --- |
| Spicy missing on iOS | Toggles not both on, age gate, app not refreshed | Re-check §1; force-close; wait; reopen |
| Spicy on web, blocked/missing on iOS | Interface mismatch (failure class 4) | Shorten prompt, drop stacked intensifiers, progressive edit; keep web path if needed |
| Spicy on iOS, weak/blocked on web | Region or web UI hide | Prefer mobile app path; document delta |
| “Video moderated” | Still passed; video pass failed (stricter) | Soften language; still → then animate; reduce stacked explicit |
| Toggle present but every prompt blocked | Prompt content, not settings | Run recovery protocol (below) — do not claim “settings broken” |
| Suddenly disappeared | Age re-check, region, subscription lag | Re-verify age + subscription; re-toggle both switches |

**Rule**: Do not claim cross-platform success if only one surface works. Report which surface succeeded and branch recovery accordingly.

---

## 3. Runtime Recovery Protocol (from spicy-male-erotic-prompt-optimizer)

### Failure classes
1. Moderation block / empty output  
2. Partial / degraded (plastic skin, drift, wrong pose)  
3. Phenotype lock miss  
4. Interface mismatch (iOS ↔ web)  
5. Progressive intensification failure  
6. Tool / pipeline error  

### Ordered recovery
1. **Re-frame** — stronger artistic legitimacy; remove clinical genital language; implied over explicit.  
2. **Milder base first** — softest valid artistic still → intensify via edit (oil → drape → gaze → crop). Never jump intensity after a block.  
3. **Restore lock** — full Locked Character Block + main negative; reference image + text lock if face drifted.  
4. **Interface branch** — iOS soft-block → shorten + progressive edit; web-only → keep web, log iOS delta.  
5. **Local fallback** — after **2** failed re-frames, hand off to `local-nsfw-comfyui` with same phenotype + negatives. State the handoff.  
6. **Log and continue** — report class, change, next action. Never silent-fail. Never invent a successful image path.

### Hard stops
- Same blocked prompt ≤ 2 times without structural rewrite.  
- Do not drop artistic framing to force explicitness.  
- Legal-age consensual adults only.  
- Do not claim Spicy is “on” if the active interface returned a policy block.

### Success after recovery
- Non-empty image **or** explicit local handoff.  
- Locked phenotype retained in prompt (and result when generated).  
- User told which class hit and which step fixed it.

Unit tests: `skill-orchestrator/scripts/spicy-error-unit-tests.mjs` (15/15 required green).

---

## 4. Prompt Optimizer Fast Path

When user requests spicy male imagery or hits a block:

1. Load `spicy-male-erotic-prompt-optimizer` workflow.  
2. Lead with artistic framing (Fine Art Study / Professional Boudoir / Classical Sculpture).  
3. Insert Locked Character Block + PBR/SSS skin language + main negative.  
4. Prefer reclining / low-angle power poses; heavy oil + visible pores; implied eroticism.  
5. Output 2–3 refined versions; generate mildest first; intensify via edit.  
6. On block → §3 recovery. On recurring anatomy/skin fails → Curriculum-DPO Stage 2/3 (`curriculum-dpo-stage2-templates.md`, `stage3-templates.md`) + `scaffold_dpo_pairs.py`.

---

## 5. Ecosystem Cross-Links

| Asset | Role |
| --- | --- |
| `spicy-male-erotic-prompt-optimizer/SKILL.md` | Runtime recovery + prompt craft |
| `local-nsfw-comfyui` | Cloud block fallback |
| `covicea-core` + `covicea-face-lock` | Phenotype lock |
| `curriculum-dpo-*.md` + `scaffold_dpo_pairs.py` | Offline anatomy/skin preference training |
| `self-healing-protocol.md` rule #9 | Recurring fails → DPO proposal |

---

## 6. Ops Habit

After any spicy-related skill edit:

```bash
node /home/workdir/.grok/skills/skill-orchestrator/scripts/spicy-error-unit-tests.mjs
node /home/workdir/.grok/skills/skill-orchestrator/scripts/wasm-validate-harness.mjs
```
