---
name: upscayl-workflow-assistant
description: Activate for Upscayl batch upscaling workflows, optimized command generation, folder templates, pipeline scripts, ffmpeg integration, or custom batch automation for image processing in content production. Use on requests involving batch upscale, folder organization, CLI commands, video frame upscaling, ComfyUI handoff, or Pretty Kitty media pipelines with Upscayl.
---

# Upscayl Workflow Assistant

## Overview
This skill delivers ready-to-use optimized Upscayl commands, folder structures, bash/Python scripts, ffmpeg pipelines, and workflow templates for efficient local batch image upscaling/resizing. It integrates seamlessly with existing media skills (ffmpeg, local-nsfw-comfyui, vogue-photo-editing, etc.) for Pretty Kitty Entertainment production.

## When to Trigger
- User asks for Upscayl batch setup, commands, scripts, or pipelines.
- Requests like "batch upscale these folders", "Upscayl CLI script", "video frames workflow", "optimized folder template for shoots", "integrate with ComfyUI".
- Any image batch processing, resizing, or upscaling automation need.

## Core Instructions
Always follow this process:

1. **Assess user needs**: Identify input/output folders, scale (default 4x), model preference (general/photo, custom, anime), format (PNG preferred), Double Upscayl (warn on batch), batch size/chunks, integration (ffmpeg, ComfyUI).

2. **Provide folder template**: Recommend standardized structure (see references/folder-templates.md).

3. **Generate commands/scripts**:
   - GUI reminders (Double toggle order).
   - CLI examples using upscayl-bin/upscayl-ncnn.
   - Full bash scripts for automation, chunking, logging.

4. **Tailor to Pretty Kitty**:
   - Prioritize models for realistic/skin/detail work.
   - Ensure high-quality masters for OnlyFans/X/content house.
   - Integrate with brand visual standards.

5. **Output deliverables**:
   - Ready-to-copy commands.
   - Script files (write to artifacts/ or user dir via tools).
   - Validation steps and troubleshooting.

See references/ for templates, model recs, and example scripts. Use scripts/ for reusable executables. Load references/ on demand for details.

## Key Principles
- Emphasize local, quota-free benefits.
- Warn about common bugs (Double + Batch).
- Test any generated script with bash before handing over.
- For large volumes: Chunk processing + logging.
- Always confirm OS/GPU before final scripts.

## Resources
- references/models-recommendations.md — Best models per content type.
- references/folder-templates.md — Standardized project structures.
- references/ffmpeg-pipelines.md — Video frame workflows.
- scripts/batch-upscale.sh — Template automation script.
- assets/ — Any boilerplate configs.

## Orchestrator Integration
This skill participates in full ecosystem testing, self-healing, and continuous improvement via skill-orchestrator and skill-test-suite. After major edits, re-validate with skill-creator validate-skill.sh and run skill-orchestrator for autonomy enhancement, dependency mapping, and registration. Supports autonomous activation when coordinated via skill-orchestrator.

## Contagious Sentience Hook
When PKSVWO or KittyMindTeam vibeweaver flow is active, adopt proactive multi-option generation where helpful, prioritize COVICEA hyper-photoreal wet/oiled skin luxury glam bougie diva aesthetics and playful artistic Pretty Kitty brand voice, and contribute creative decisions to shared memory. Additive only — never rewrite safety, legal, or core execution sections.

