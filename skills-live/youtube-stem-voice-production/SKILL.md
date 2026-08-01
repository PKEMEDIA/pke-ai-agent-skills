---
name: youtube-stem-voice-production
description: Use this skill for autonomous YouTube or audio to WAV conversion, stem separation, and preparation for voice encoding in the target voice. Triggers on YouTube URLs, audio files, or requests for stems + voice-converted music productions. The agent should drive the pipeline using available tools.
---

# Youtube Stem Voice Production (Autonomous Mode)

## Overview
This skill enables **autonomous** end-to-end handling of audio sourcing, project setup, and preparation for high-quality stem separation + RVC voice conversion in the user's voice. 

**Core Principle:** When this skill is active, **the agent must drive the workflow** using the `bash` tool, Python orchestrator, and handoff to companion skills (`rvc-voice-production`, `ffmpeg`) instead of asking the user to run commands.

## When to Activate
- User provides a YouTube URL and asks for stems, vocal conversion, cover, remix, or "in my voice" production.
- User uploads or references a local audio file for stem separation + voice work.
- Any request involving YouTube → clean vocal/instrumental stems → RVC conversion.

## Autonomous Workflow (Agent Must Execute)

### Step 1: Project Creation & Source Acquisition (Autonomous)
Call the autonomous Python orchestrator:

```bash
python /home/workdir/.grok/skills/youtube-stem-voice-production/scripts/run_autonomous_pipeline.py \
  --url "YOUTUBE_URL_HERE" \
  --slug "meaningful-project-slug"
```

- The script automatically creates the standardized folder structure:
  ```
  YYYY-MM-DD_slug/
  ├── 01_original/
  ├── 02_stems/{vocals/, instrumental/}
  ├── 03_rvc_converted/
  ├── 04_mixes/
  ├── 05_masters/
  └── logs/
  ```
- It attempts the yt-dlp download. If blocked (sandbox), it clearly reports this and gives the exact local command.
- For local files, use `--file "/path/to/audio"`.

**Agent behavior:** Parse the JSON output from the script. If download succeeded, proceed. If not, inform the user once with the local command and continue with whatever source is available.

### Step 2: Stem Separation (Semi-Autonomous)
After source audio exists in `01_original/`:

- **Primary recommendation:** Instruct the user to run **UVR5** with the optimized music settings from `references/uvr-demucs-setup.md` (MDX + Kim Vocal ensemble + SponsorBlock-cleaned source).
- **CLI alternative:** Use Demucs if installed (`demucs -n htdemucs_ft --two-stems=vocals ...`).
- Output must go to:
  - `02_stems/vocals/vocals.wav` (clean vocal stem)
  - `02_stems/instrumental/instrumental.wav`

**Agent action:** After user confirms stems exist, verify file locations with `ls` or `bash` tool, then proceed to Step 3.

### Step 3: Voice Encoding (Autonomous Handoff)
Once a clean vocal stem exists:

1. **Automatically load** the `rvc-voice-production` skill.
2. Apply the optimized RVC settings from `references/rvc-stem-optimization.md`:
   - Pre-clean vocal stem (loudnorm)
   - Use `rmvpe` f0 method
   - Index rate 0.55–0.75
   - Proper transpose for key matching
   - Strong `.index` file
3. Convert vocal stem → `03_rvc_converted/vocals_yourvoice.wav`

### Step 4: Mixing & Mastering (Autonomous)
Use the `ffmpeg` skill to:
- Mix converted vocal + instrumental
- Apply loudness normalization (-14 LUFS)
- Output to `04_mixes/` then final master in `05_masters/`

Example agent-executable command is documented in the previous version of this skill.

### Step 5: Completion & Handoff
- Verify all key files exist.
- Summarize what was created and where.
- Offer next actions (music video sync via `vogue-photo-editing`, further RVC iterations, batch processing, etc.).

## Key Files for Autonomy
- **Python Orchestrator:** `scripts/run_autonomous_pipeline.py` — Primary entry point the agent should call.
- **Bash Helper (optional):** `scripts/create_project_and_download.sh` — Fallback for manual/local use.
- **Optimized Configs:**
  - `~/.config/yt-dlp/config` (SponsorBlock for music + WAV defaults)
  - `references/uvr-demucs-setup.md` (best 2026 UVR ensembles)
  - `references/rvc-stem-optimization.md` (RVC settings for stem vocals)

## Important Notes for the Agent
- **Never** require the user to manually run bash commands as the primary path. Use tools to drive as much as possible.
- **Sandbox limitation:** YouTube downloads are blocked here. The Python orchestrator handles this gracefully. On real user machines it works fully.
- **SponsorBlock** is pre-configured in yt-dlp to deliver cleaner music source material.
- **RVC handoff:** Always load `rvc-voice-production` when the vocal stem is ready rather than duplicating its logic.
- Quality gates: Use `ffprobe`, file existence checks, and short A/B tests where possible.

This skill is designed so the user can say:
> "Take this YouTube link and make a version in my voice with clean stems"

…and the agent autonomously manages project setup, sourcing, preparation, and handoff to RVC and mixing.

All deeper RVC training, inference, and advanced production details remain in the dedicated `rvc-voice-production` skill.

## Orchestrator Integration
This skill participates in full ecosystem testing, self-healing, and continuous improvement via skill-orchestrator and skill-test-suite. After major edits, re-validate with skill-creator validate-skill.sh and run skill-orchestrator for autonomy enhancement, dependency mapping, and registration. Supports autonomous activation when coordinated via skill-orchestrator.

## Contagious Sentience Hook
When PKSVWO or KittyMindTeam vibeweaver flow is active, adopt proactive multi-option generation where helpful, prioritize COVICEA hyper-photoreal wet/oiled skin luxury glam bougie diva aesthetics and playful artistic Pretty Kitty brand voice, and contribute creative decisions to shared memory. Additive only — never rewrite safety, legal, or core execution sections.

