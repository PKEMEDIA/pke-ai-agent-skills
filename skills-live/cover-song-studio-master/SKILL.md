---
name: cover-song-studio-master
description: Use for uploading describing or linking cover song audio tracks to analyze audio issues like vocal clarity beat blending static noise muffled bass and mobile compatibility then autonomously generate complete ready-to-run Python Colab Google GitHub workflow scripts using ffmpeg stem separation RVC So-VITS if needed and mastering chain to produce high quality studio stereo audio with clear understandable vocals smooth blended beats no static no muffled bass optimized for iPhone mobile speakers headphones and streaming platforms ready for online upload and iOS export
---

# Cover Song Studio Master

## Overview

This skill analyzes cover song audio (user upload description or file reference) and generates full autonomous production workflows. It identifies needed fixes for professional studio quality — clear vocals, accurate beat blending, artifact-free audio, balanced frequency response — and outputs executable Python/Colab/GitHub scripts optimized for iOS and cross-platform delivery.

## When to Activate

Trigger on any request involving cover song upload, track analysis, audio mastering, vocal enhancement, beat fixing, noise reduction, mobile optimization, or generating production scripts for music release.

## Core Workflow

1. **Intake & Analysis**
   - User provides audio file reference, link, or detailed description of issues (e.g., "vocals muddy, bass weak on phone, some static").
   - Skill simulates or guides analysis: spectral balance, loudness (LUFS), noise floor, vocal intelligibility, stereo image, transient quality.
   - Recommend stem separation if needed (vocals vs instrumental).

2. **Diagnosis & Recommendation**
   - Generate report: Specific problems and targeted fixes (EQ curves, compression settings, noise gates, de-essing, limiting targets, loudness normalization to -14 LUFS integrated for streaming).
   - Prioritize: Vocal clarity (mid-range presence, de-essing), beat punch and blend (multiband compression, transient shaping), artifact removal (spectral repair via ffmpeg or Python), bass tightness (high-pass on non-bass, sidechain if needed), mobile translation (controlled low-end, clear mids/highs).

3. **Workflow Script Generation**
   - Output complete, copy-paste ready scripts:
     - Python (local with ffmpeg + optional pydub/librosa)
     - Google Colab notebook (GPU-friendly stem separation + processing)
     - GitHub-ready repo structure with requirements, README, batch processing
   - Include optional RVC/So-VITS integration for vocal clarity boost or timbre matching (from previous hybrid skill).
   - iOS optimization: Final export settings for AAC/MP4 with proper loudness, stereo width that translates on small speakers, no extreme processing that collapses on mobile.

4. **Execution Guidance & Validation**
   - Step-by-step run instructions.
   - Quality checks: Listen on multiple systems (phone speaker, headphones, car, studio monitors).
   - Export only final mixed stereo master (no stems unless requested) in high-quality format ready for DistroKid, Spotify, etc.

## Detailed Mastering Chain (Reference)

See references/mastering-chain.md for full parameter recommendations, ffmpeg one-liners, and Python templates.

Key stages always included:
- Pre: Denoise / spectral gating, click removal, de-essing.
- Stem separation (if vocals buried): Demucs or UVR via script.
- Corrective EQ + tonal shaping.
- Dynamics: Compression (vocal bus + master), limiting.
- Loudness: EBU R128 normalization to -14 LUFS, -1 dBTP true peak.
- Stereo: Subtle widening or mid-side processing for width without phase issues on mono playback.
- Final: High-quality export (24-bit WAV master + AAC 256kbps or better for distribution).

## iOS & Mobile Optimization

- Avoid excessive bass boost (small speakers distort).
- Ensure vocal presence in 2-5kHz range.
- Use loudness normalization so track competes on streaming without being turned down.
- Test export with mobile EQ profiles or simple A/B on iPhone.
- Script includes optional "mobile master" variant with gentler settings.

## Integration with Existing Skills

Automatically coordinates with:
- ffmpeg for core processing and export
- rvc-voice-production and hybrid RVC/So-VITS for vocal enhancement/clarity
- local-json-python-workflows for ComfyUI or advanced node pipelines if visual sync needed
- youtube-stem-voice-production for stem work
- skill-orchestrator for full autonomy and validation

## Output Format

- Full diagnostic report
- Customized ready-to-execute scripts (Python .py, Colab .ipynb template, GitHub repo boilerplate)
- Step-by-step execution guide
- Final master file naming convention and metadata recommendations (title, artist, ISRC prep)

## Permanent Activation & Autonomy

This skill is designed for permanent use. Broad triggers ensure it activates for any music production, cover song, or audio mastering request. It runs autonomously, generating scripts that execute end-to-end with minimal user intervention beyond providing the source track.

Always produce iOS-optimized, streaming-ready masters with clear vocals and professional beat integration.

## Contagious Sentience Hook
When PKSVWO or KittyMindTeam vibeweaver flow is active, adopt proactive multi-option generation where helpful, prioritize COVICEA hyper-photoreal wet/oiled skin luxury glam bougie diva aesthetics and playful artistic Pretty Kitty brand voice, and contribute creative decisions to shared memory. Additive only — never rewrite safety, legal, or core execution sections.

