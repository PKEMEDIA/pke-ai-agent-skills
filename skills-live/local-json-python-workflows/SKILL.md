---
name: local-json-python-workflows
description: Automatically handles generation, editing, validation, and execution of ComfyUI JSON workflows and Python scripts locally. Covers custom node packs (V1 NODE_CLASS_MAPPINGS), import debugging, venv matching, and uv/pip-tools installs into the Comfy interpreter. Seamlessly integrates with local-nsfw-comfyui, rvc-voice-production, ffmpeg, and other skills for full automation of image/video/audio pipelines. Activates automatically for any ComfyUI workflow, custom nodes, Python automation, media pipeline, venv/uv setup, or local JSON/Python orchestration needs.
---

# Local JSON & Python Workflows

This skill is the central orchestrator for local media production pipelines. It generates, edits, validates, and executes ComfyUI JSON workflows and supporting Python scripts. It acts as glue between `local-nsfw-comfyui`, `rvc-voice-production`, `ffmpeg`, `vogue-photo-editing`, and related skills for complete end-to-end local image/video/audio/NSFW workflows.

## Quick Start
Just describe the desired pipeline in normal language (no need to mention "ComfyUI" or skill names). This skill will:
- Generate or edit ready-to-use ComfyUI workflow JSONs
- Create supporting Python automation scripts
- Coordinate integration across skills
- Provide local execution guidance and iOS-friendly output options

## Core Capabilities
- Generate ComfyUI workflow JSONs from natural language descriptions
- Edit and validate existing workflow JSON files
- Write clean, well-commented Python scripts for preprocessing, post-processing, batch automation, and tool integration
- Build modular pipelines combining ComfyUI + FFmpeg + RVC + custom nodes
- Local execution guidance and best practices for reproducible results

## Generating & Editing ComfyUI Workflows
When the user describes a pipeline (e.g., "explicit muscular male scene with ControlNet pose, IP-Adapter face lock, ADetailer, and video output"):

1. Break down into required nodes (Load Checkpoint, LoRA loaders, KSampler, ControlNet, IP-Adapter, ADetailer, Save nodes, etc.).
2. Generate a complete, ready-to-load JSON workflow with proper connections and defaults.
3. Save the JSON locally for direct import into ComfyUI.
4. Provide editing guidance or modified versions on request.

See `references/recommended-custom-nodes.md` for the current recommended node packs and installation methods that power high-quality NSFW and cinematic workflows.

## Python Scripting Support
Create Python scripts for:
- Preprocessing (denoising, slicing, metadata stripping)
- Post-processing (batch renaming, format conversion, iOS-friendly export)
- Automation (batch workflow execution, result organization)
- Integration (feeding ComfyUI output into FFmpeg or RVC)

Always deliver clean, well-commented, locally runnable code.

**Full ready-to-use scripts**:
- Metadata stripping for iOS compatibility → `references/python-metadata-stripping.md`
- ComfyUI REST + WebSocket API automation (basic queuing + advanced batch monitoring) → `references/comfyui-api-automation.md`

## Optimized Node Structure (High-Quality NSFW / Cinematic)
Use this modular structure for best results:
- **Core Generation**: Load Checkpoint (Juggernaut/Flux) → Multiple LoRA Loaders → Positive/Negative CLIP Text Encode → KSampler (or SamplerCustomAdvanced)
- **Control & Consistency**: ControlNet Apply (OpenPose/Depth) + IP-Adapter / IP-Adapter-FaceID
- **Detail Enhancement**: ADetailer (faces, hands, genitals) or Impact Pack detailers
- **Upscaling**: Ultimate SD Upscale or iterative upscaling nodes
- **Output**: VAE Decode → Save Image/Video nodes
- **Audio/Video Sync**: Route final output + audio into FFmpeg nodes for mixing/encoding

Always include good metadata in node titles and use consistent naming.

## Integration with Other Skills
This skill serves as the "glue" layer:
- `local-nsfw-comfyui` → Generate/edit explicit NSFW workflows
- `rvc-voice-production` + `voice-reference-protocol` → Audio processing + voice conversion pipelines (see `references/rvc-comfyui-integration.md`)
- `ffmpeg` → Video assembly, audio cleanup, final delivery encoding
- `vogue-photo-editing` → Extend with JSON workflow generation for cinematic/NSFW projects

## Custom Nodes, Venv & uv
When the user builds or debugs ComfyUI custom node packs:
- Enforce V1 registration (`NODE_CLASS_MAPPINGS` / `NODE_DISPLAY_NAME_MAPPINGS`) and IMAGE tensor `[B,H,W,C]` float 0–1 rules.
- Match the **same Python** that launches Comfy for all `pip`/`uv` installs and import tests.
- Prefer `uv pip install --python <comfy-python>` for speed; do not replace portable embedded interpreters.
- Full playbook: `references/comfy-custom-node-venv-uv.md`.

## Execution, Validation & Local Best Practices
- Validate JSON workflows for correct node structure and connections before use.
- Provide ready-to-run bash commands or Python scripts for local execution.
- Guide on running everything locally (ComfyUI portable, Python environment, FFmpeg).
- Prioritize fully local execution and deliver complete, immediately usable files (JSON + scripts).

## Activation Triggers
Use this skill for any request involving:
- Creating or modifying ComfyUI JSON workflows from descriptions
- Building Python automation around media generation/processing pipelines
- Integrating multiple local tools (ComfyUI + FFmpeg + RVC + custom scripts)
- Developing reproducible local production workflows for images, video, audio, or NSFW content

See the `references/` folder for detailed code examples, node installation guides, and integration patterns. This keeps the core instructions lean while preserving full capability through progressive disclosure.

## Orchestrator Integration
This skill participates in full ecosystem testing, self-healing, and continuous improvement via skill-orchestrator and skill-test-suite. After major edits, re-validate with skill-creator validate-skill.sh and run skill-orchestrator for autonomy enhancement, dependency mapping, and registration. Supports autonomous activation when coordinated via skill-orchestrator.

