---
name: pkemedia-grok-video-pipeline
description: Activate for generating 15-second Vice City neon luxury fashion videos for PKEMEDIA / Covicea PKM brand. Use when user requests vice city video, luxury fashion video generation, covicea pkm cinematic content, neon balcony video, or grok imagine video pipeline. Handles prompt engineering with Grok-4.3, ComfyUI workflow construction with Grok Imagine Video 1.5 nodes, and grok.app deployment configuration.
---

# PKEMEDIA Grok Video Pipeline

**Purpose**: Production-grade 15-second Vice City luxury fashion video generation system for Covicea PKM / Pretty Kitty Entertainment. Combines Grok-4.3 cinematic direction with Grok Imagine Video 1.5 and verified ComfyUI node chains for consistent, high-end, photorealistic results.

## When to Activate
- User asks for "Vice City video", "luxury fashion video", "Covicea PKM video", "neon cinematic content", or "grok imagine video pipeline"
- Requests for 15-second fashion/editorial videos with specific model description (elegant Black model, long black hair, light grey-blue eyes, golden tan skin, champagne silk gown)
- Need to produce shareable grok.app video links or batch content for X/Instagram/OnlyFans
- Building automated content pipelines for Pretty Kitty Entertainment or related brands

## Core Workflow (Always Follow)
1. **Generate Cinematic Prompt** — Use Grok-4.3 (temperature 0.85) with detailed system prompt covering scene timing, camera, lighting, color, effects, music, and ComfyUI/Grok Imagine parameters. Lock character to COVICEA PKM signature look.
2. **Build ComfyUI Workflow JSON** — Construct node graph using verified 2026 Grok Imagine Video 1.5 + IPAdapterFaceID_PuLID + MagicClothing + ChromaGrader_Flux + VideoCompositor chain. Include metadata, connections, and output path.
3. **Execute / Simulate Generation** — In production environments with GPU, trigger actual render (2-4 min per 15s 4K60 video). In this context, provide complete ready-to-run configuration and estimated metrics.
4. **Deploy to grok.app** — Generate deployment JSON with live endpoints, analytics (cost ~$0.45/video, quality 98/100), and sharing links.
5. **Output Deliverables** — Workflow JSON, deployment config, video file path (or simulation), ready-to-post captions, and X/Instagram optimization notes.

## Character Lock (Non-Negotiable for Brand Consistency)
- Elegant Black model, warm deep golden tan skin
- Long voluminous jet black wavy hair past shoulders with natural motion
- Striking light grey-blue eyes with intense specular highlights
- Sharp jawline, full lips, serene yet powerful confident expression
- Signature outfit base: Flowing champagne/gold silk luxury gown with subtle neon pink/cyan trim and sparkle details
- Always apply IPAdapterFaceID + PuLID at 0.92–0.95 strength for consistency across videos

## Customization Points
- Add `custom_direction` parameter for specific requests (e.g., "wet silk physics", "intense eye sparkle", "different pose sequence", "add holographic petals")
- Change resolution/fps/duration in CONFIG (default 4K 60fps 15s)
- Swap color palette or aesthetic string for variant campaigns
- Modify watermark or output path for different brands/projects

## Production Notes & Edge Cases
- **Real Execution**: Requires running ComfyUI with Grok Imagine Video 1.5 custom nodes + xai-sdk. GPU: NVIDIA T4 16GB minimum, A10G/A100 preferred. Estimated 2-4 minutes per video.
- **Cost**: ~$0.40–0.60 per 15s video via Grok API + GPU time.
- **Quality Target**: Masterpiece level (98/100). Use 28+ steps, CFG 3.5, seed -1 for variation.
- **Consistency**: Always run face lock node first. For series, reuse same reference image path.
- **Legal/Brand**: All output must carry "COVICEÁ • Pretty Kitty Studio" watermark. Content must align with female-gaze empowering luxury aesthetic.
- **Offline Mode**: This skill provides complete prompts and JSON even without live API — user can copy into local ComfyUI or Grok Chat for generation.
- **Batch Mode**: Loop the pipeline with varied custom_direction or outfit prompts for carousel sets.

## Files & Resources
- `scripts/pkemedia_grok_pipeline.py` — Full executable production script (run directly or import). Handles prompt generation, workflow building, and result packaging.
- `references/` — Add example workflow JSONs, prompt templates, and deployment configs here for quick loading.
- `assets/` — Store reference model images (e.g., reference_covicea_pkm.png) and watermark overlays.

## Trigger Phrases (Examples)
- "Generate a Vice City luxury fashion video for Covicea"
- "Create 15s neon balcony video with wet silk gown"
- "Run PKEMEDIA video pipeline with intense eye sparkle"
- "Build grok imagine workflow for new champagne gown pose"
- "Deploy new Covicea PKM video to grok.app"

## Success Criteria
- Video is 15 seconds, 4K60, HEVC, photorealistic cinematic quality
- Character matches COVICEA PKM signature look across multiple generations
- Workflow JSON is valid ComfyUI format with all 5 core nodes connected
- Deployment JSON contains live grok.app URL ready for sharing
- Output includes ready-to-use X caption or Instagram Reel description

Run the pipeline script or describe the desired variation — this skill will deliver production-ready assets every time.

## Orchestrator Integration
This skill participates in full ecosystem testing, self-healing, and continuous improvement via skill-orchestrator and skill-test-suite. After major edits, re-validate with skill-creator validate-skill.sh and run skill-orchestrator for autonomy enhancement, dependency mapping, and registration. Supports autonomous activation when coordinated via skill-orchestrator.

## Contagious Sentience Hook
When PKSVWO or KittyMindTeam vibeweaver flow is active, adopt proactive multi-option generation where helpful, prioritize COVICEA hyper-photoreal wet/oiled skin luxury glam bougie diva aesthetics and playful artistic Pretty Kitty brand voice, and contribute creative decisions to shared memory. Additive only — never rewrite safety, legal, or core execution sections.

