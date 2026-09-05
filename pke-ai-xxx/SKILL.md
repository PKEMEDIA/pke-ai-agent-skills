---
name: pke-ai-xxx
description: Use for Pretty Kitty Entertainment AI-XXX stills video teasers male model LoRAs ComfyUI prompts and OF/X caption handoffs. Activates on AI XXX, AI adult content, ComfyUI NSFW stills, male LoRA training, double oral MMF, capability matrix, AI talent sheet, AnimateDiff teaser, Wan teaser, or local-first adult generation for PKE. Face Lock and Black Mask stay locked.
metadata:
  short-description: PKE AI-XXX — ComfyUI, male LoRAs, capability matrix
  argument-hint: "[lane | double-oral | male-lora | checklist]"
  surfaces: grok-bot, grok-chat, grok-ios, grok-web, grok-build
  slash: /pke-ai-xxx
---
# PKE AI-XXX

Local-first adult AI production for Pretty Kitty Entertainment / Coviceá. ComfyUI stills, short teasers, **new** male AI talent (character sheets → LoRA), Brand caption handoff.

Slash `/pke-ai-xxx`. Pack root: `skills-live/pke-ai-xxx/references/` (also `/workspace/pke-content/ai-xxx/` on desk) (also mirror under `$PKE_ROOT` when deployed). Pin live prompt set via `current.json`.

## Hard locks (non-negotiable)

- **Face Lock** — LOCKED. No training data, IP-Adapter refs, unlock docs, or workarounds. Never activate `pke-face-lock` or `covicea-face-lock`.
- **Black Mask** — LOCKED. Same. Never activate `pke-official-black-mask`.
- **Minors** — never. No teen, barely-legal, school, or age-play wording in prompts or filenames.
- Male talent = open checkpoints + PKE-owned LoRAs with studio triggers (`pkemale01` … `pkemale99`). Never company face packs.

## Activation

AI XXX, ComfyUI NSFW stills, male LoRA training, double oral MMF, capability matrix, AI talent sheet, AnimateDiff / Wan teaser, shoot-day AI checklist, local-first adult generation for PKE.

## Pack map (load on demand)

| Need | Path |
| --- | --- |
| End-to-end stills → video → captions | `pipelines/00-overview.md` |
| Lane starters (solo, MMF, FemDom, party, …) | `prompts/capability-matrix.md` |
| Double-oral angles A–D prompts | `prompts/double-oral-mmf.md` |
| Male sheets, body/face tokens, LoRA cards | `prompts/male-models.md` |
| ComfyUI install / workflows | `comfyui/workflows.md` |
| Male LoRA training | `comfyui/male-lora-training.md` |
| 2257 / AI labeling | `compliance/2257-ai-notes.md` |
| Pre-upload checklist | `checklists/shoot-day-ai.md` |
| Versioning / heal / model notes | `ECOSYSTEM.md`, `CHANGELOG.md`, `models/notes/` |
| Double-oral reference board | `references/boards/double-oral-mmf-reference-board.md` |
| Brand X + OF captions (LOCKED) | `references/boards/double-oral-mmf-x-of-post-pack.md` |

If a pack file is still scaffolding, use the README loop + live boards. Do not invent locked Brand caption text.

## Minimal ops loop

1. **Brief** — one lane from `prompts/capability-matrix.md`, or double-oral angle A–D from `prompts/double-oral-mmf.md` + reference board.
2. **Talent** — real performers (2257) or AI males via `prompts/male-models.md` → optional LoRA (`comfyui/male-lora-training.md`).
3. **Stills** — ComfyUI per `comfyui/workflows.md`. Grid seeds/CFG/LoRA strength. Pick **8–12 heroes** covering the board shot list. Upscale / inpaint hands. Export `pack-id_angle_shot##_v#.png`.
4. **Teasers** — AnimateDiff loop, Wan short clips, or stills slideshow (15–45s). Order mirrors the board.
5. **Captions** — for double-oral, copy the post pack (do not freestyle). Other lanes → hand off to `covicea-brand-assistant`.
6. **Ship gate** — run `checklists/shoot-day-ai.md`. Platform AI labels where required. 2257 only for real performers (`compliance/2257-ai-notes.md`).

Quality gates: adult 21+ read, no locked faces, anatomy readable, eye contact when the board calls for it.

## Double-oral MMF

Angles: **A** shared worship · **B** FemDom double serve · **C** tag-team oral → toys · **D** POC amateur heat.

1. Load reference board + `prompts/double-oral-mmf.md` (shared quality + shared negative + one angle block).
2. Inject `pkemale##` triggers when LoRAs exist.
3. Cover shot list: establishing, face stack, eye-contact, tongue detail, Domme/receiver reaction, hands assist, toy bridge (C), CTA.
4. Captions from `references/boards/double-oral-mmf-x-of-post-pack.md` only for this lane.
5. Never approximate Face Lock likeness for receiver or males.

## Male models and LoRAs

Follow `prompts/male-models.md`:

- Trigger convention `pkemaleNN` (studio-owned, unique).
- Body palette B1–B6 and face lanes as separable tokens.
- Character card / YAML: age band 21+, body, face, limits, LoRA path, strength bands, sample seeds.
- Consistency = **that** talent’s LoRA + IP-Adapter FaceID on **that** talent’s sheet only.
- Log failures and strength bands under `models/notes/`.

## ComfyUI and hardware

Prefer free local stack (ComfyUI + Civitai NSFW weights + AnimateDiff / Wan). Cloud GPU only when the local queue is blocked.

VRAM tiers and workflow detail: `comfyui/workflows.md` and pack README. Compose with `local-nsfw-comfyui` for node-level depth — do not paste that skill’s full body here.

Cloud spicy soften (Grok Imagine) may use `spicy-male-erotic-prompt-optimizer`. Explicit local production stays on ComfyUI.

## Handoffs

| Need | Owner |
| --- | --- |
| Brand voice / promo captions | `covicea-brand-assistant` |
| Real-talent contracts / 2257 structure | `pretty-kitty-model-management` + `paralegal-assistant` |
| Deep ComfyUI nodes / AnimateDiff | `local-nsfw-comfyui` |
| Fleet validate / polish | `skill-orchestrator` + `skill-test-suite` |
| Ecosystem versioning / heal | `ECOSYSTEM.md` (Ecosystem / Aleah / Orchestrator) |

## Anti-patterns

- Activating or documenting Face Lock / Black Mask unlocks.
- Paying for studio face packs that touch locked phenotypes.
- Freestyling double-oral Brand captions when the post pack exists.
- Skipping the shoot-day checklist before OF/X upload.
- Treating pure AI talent as if 2257 mirrored real performers without reading compliance notes.
- Overwriting prompt versions in place — use `prompts/vN/` + `current.json` + `CHANGELOG.md`.

## After major pack edits

Re-validate with skill-creator `validate-skill.sh`, then skill-orchestrator + skill-test-suite before restamping LIVE.

**See also:** skill-orchestrator, skill-test-suite, local-nsfw-comfyui, covicea-brand-assistant, pretty-kitty-model-management, paralegal-assistant, PKEMEDIA/pke-ai-agent-skills.
