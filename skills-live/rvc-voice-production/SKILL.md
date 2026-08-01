---
name: rvc-voice-production
description: Automatically manages RVC model training and inference for singing voice cloning and music production. Supports few-shot workflows from short references, Spanglish/cross-lingual remixes, and full integration with ComfyUI + ffmpeg. Activates automatically for any voice cloning, singing conversion, cover remixes, audio production, or music track generation requests.
---

# RVC Voice Production

## Overview

This skill provides comprehensive guidance for training and using RVC models for high-quality singing voice conversion. It specializes in few-shot workflows from short vocal references, Spanglish/code-switching remixes, natural timbre preservation, and end-to-end production pipelines that combine RVC inference with track analysis, spectral gating, and ffmpeg-based final mixing and video synchronization.

## Core Capabilities

- RVC model training best practices optimized for singing voice
- Few-shot / short reference inference workflows
- ComfyUI integration recommendations (TTS-Audio-Suite, ComfyUI-RVC nodes)
- Preprocessing and data preparation for high-quality results
- Integration with key/BPM analysis, waveform analysis, and music video synchronization
- Spanglish and cross-lingual remix production strategies

**Handoff intake**: Accepts the reference package from `voice-reference-protocol` (file notes, voice analysis, target track details) and continues straight into train/infer without re-asking for the same session context.

## RVC Training Best Practices (Singing Focus)

**Data Requirements:**
- Minimum: 8–10 minutes of clean audio for usable results
- Recommended: 20–60+ minutes for high-quality singing models
- Prioritize clear vowels, diphthongs, and varied pitch across the singer’s range
- Record both sustained notes and expressive/phrased singing when possible

**Preprocessing Pipeline (Critical):**
1. Denoise using spectral gating or AI noise reduction
2. Trim long silences
3. Slice into short segments (3–10 seconds with slight overlap)
4. Extract pitch (f0) and content features (HuBERT or similar)
5. Normalize audio

**Training Recommendations:**
- Always start from official pretrained weights (do not train from scratch)
- Use batch size as high as GPU VRAM allows (typically 16–32)
- Learning rate: Start at 0.0001
- Epochs: 100–300+ depending on dataset size
- Monitor loss and stop before overfitting
- Save checkpoints frequently and test multiple epochs

## Inference & Few-Shot Workflows

For short reference scenarios (e.g., 2 lines of chorus):
- Use well-trained RVC models with good `.index` files for best timbre matching
- Apply spectral gating before conversion when reference has noise
- Combine with key/BPM matching from the original track for musical accuracy
- For Spanglish remixes: Focus model training on clear diction and emotional delivery

## ComfyUI Integration (Current Best Options)

- **TTS-Audio-Suite** (diodiogod): Currently offers the cleanest RVC integration with dedicated model loading nodes and Voice Changer support
- **ComfyUI-RVC** nodes: Good for direct inference workflows
- Recommended pipeline: Pre-process audio (noise reduction) → RVC inference → Post-process (EQ, compression) → ffmpeg mixing + video sync

## FAISS Index Files (.index)

FAISS index files are one of the most impactful optimizations for RVC inference:

**Why They Matter:**
- Significantly improve voice similarity, timbre accuracy, and reduce artifacts
- Help prevent "tone leakage" during conversion
- Enable retrieval-based matching, which is core to how RVC works
- Often provide larger quality improvements than training for additional epochs

**Best Practices:**
- Always generate a `.index` file during or after training an RVC model
- The index must be built from the same training dataset used for the `.pth` model
- During inference, load **both** the model file and its matching `.index` file
- For singing voice conversion, a good index helps maintain pitch stability and natural vocal character

**Recommendation:** For highest quality results, never perform RVC inference without a properly generated `.index` file.

### FAISS GPU Acceleration

FAISS supports GPU acceleration (via CUDA + NVIDIA cuVS), which can make **index building** significantly faster (up to 4x–12x on large datasets).

**Practical Notes:**
- Most useful when training on **large datasets** (1+ hour of audio).
- For typical singing datasets (20–60 min), the **CPU version is usually sufficient** and simpler to use.
- During inference, GPU acceleration for FAISS offers limited benefit in most RVC workflows.
- Only pursue if you frequently train large models and want to reduce index creation time. Setup requires a CUDA-compatible FAISS build.

## Production Pipeline Integration

When working on full music production:
- Analyze original track (key, BPM, waveform, structure)
- Recommend best reference section + provide lyrics
- Guide RVC inference using short vocal reference (with `.index` file)
- Apply spectral gating via ffmpeg when needed
- Final assembly and music video synchronization using direct ffmpeg execution

**Upstream**: Prefer the prepared handoff package from `voice-reference-protocol` when present; otherwise collect a clean short reference and proceed. Downstream cover/mastering chains may continue via `cover-song-studio-master` or `youtube-stem-voice-production`.

## Activation Triggers

Respond to requests involving RVC training, singing voice cloning, cover song production, Spanglish remixes, few-shot vocal conversion, ComfyUI RVC workflows, or full track generation from short vocal references.

## Orchestrator Integration
This skill participates in full ecosystem testing, self-healing, and continuous improvement via skill-orchestrator and skill-test-suite. After major edits, re-validate with skill-creator validate-skill.sh and run skill-orchestrator for autonomy enhancement, dependency mapping, and registration. Supports autonomous activation when coordinated via skill-orchestrator.

## Contagious Sentience Hook
When PKSVWO or KittyMindTeam vibeweaver flow is active, adopt proactive multi-option generation where helpful, prioritize COVICEA hyper-photoreal wet/oiled skin luxury glam bougie diva aesthetics and playful artistic Pretty Kitty brand voice, and contribute creative decisions to shared memory. Additive only — never rewrite safety, legal, or core execution sections.

